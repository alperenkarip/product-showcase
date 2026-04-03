#!/bin/bash
# upstream-sync.sh
# Derived projede calistirilir.
# Boilerplate'ten belirtilen tag'e kadar olan degisiklikleri manifest'e gore sync eder.
#
# Kullanim:
#   ./tooling/sync/upstream-sync.sh <hedef-tag>
#   ./tooling/sync/upstream-sync.sh bp-v1.2.0
#
# On kosullar:
#   - 'upstream' remote tanimli olmali: git remote add upstream <boilerplate-repo-url>
#   - tooling/sync/upstream-sync-manifest.yaml mevcut olmali
#   - BOUNDARY.md mevcut olmali (ilk sync icin bos olabilir)
#
# Referans: docs/governance/49-upstream-sync-strategy.md

set -euo pipefail

# --- Renkli cikti ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[UYARI]${NC} $1"; }
error() { echo -e "${RED}[HATA]${NC} $1"; }

# --- Parametreler ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MANIFEST="$SCRIPT_DIR/upstream-sync-manifest.yaml"
PARTIAL_MERGE="$SCRIPT_DIR/partial-merge.sh"
TARGET_TAG="${1:-}"
UPSTREAM_REMOTE="upstream"
BOUNDARY_FILE="BOUNDARY.md"
SYNC_DATE=$(date '+%Y-%m-%d')

if [ -z "$TARGET_TAG" ]; then
  error "Hedef tag belirtilmeli."
  echo "Kullanim: $0 <hedef-tag>"
  echo "Ornek:    $0 bp-v1.2.0"
  echo ""
  echo "Mevcut upstream tag'leri listelemek icin:"
  echo "  git fetch upstream --tags && git tag -l 'bp-v*' --sort=-v:refname"
  exit 1
fi

# --- 1. Upstream remote kontrolu ---
info "Upstream remote kontrol ediliyor..."
if ! git remote get-url "$UPSTREAM_REMOTE" &>/dev/null; then
  error "'$UPSTREAM_REMOTE' remote tanimli degil."
  echo "Eklemek icin: git remote add upstream <boilerplate-repo-url>"
  exit 1
fi
ok "Upstream remote: $(git remote get-url "$UPSTREAM_REMOTE")"

# --- 2. Upstream fetch ---
info "Upstream fetch ediliyor..."
git fetch "$UPSTREAM_REMOTE" --tags --quiet
ok "Fetch tamamlandi."

# --- 3. Hedef tag dogrulama ---
if ! git rev-parse "$TARGET_TAG" &>/dev/null; then
  error "'$TARGET_TAG' tag'i bulunamadi."
  echo "Mevcut tag'ler:"
  git tag -l 'bp-v*' --sort=-v:refname | head -10
  exit 1
fi

TARGET_HASH=$(git rev-parse "$TARGET_TAG")
ok "Hedef tag: $TARGET_TAG ($TARGET_HASH)"

# --- 4. BOUNDARY.md'den mevcut hash oku ---
CURRENT_HASH=""
CURRENT_VERSION=""
if [ -f "$BOUNDARY_FILE" ]; then
  CURRENT_HASH=$(grep -oP '(?<=boilerplate_upstream_hash: )[a-f0-9]+' "$BOUNDARY_FILE" 2>/dev/null || echo "")
  CURRENT_VERSION=$(grep -oP '(?<=upstream_version: )bp-v[0-9.]+' "$BOUNDARY_FILE" 2>/dev/null || echo "")
fi

if [ -n "$CURRENT_HASH" ]; then
  info "Mevcut sync: $CURRENT_VERSION ($CURRENT_HASH)"
else
  warn "BOUNDARY.md'de onceki sync bilgisi bulunamadi. Tam sync yapilacak."
fi

# --- 5. Guncellik kontrolu ---
if [ "$CURRENT_HASH" = "$TARGET_HASH" ]; then
  ok "Derived proje zaten $TARGET_TAG ile guncel. Islem gerekmiyor."
  exit 0
fi

# --- 6. Sync branch olustur ---
SYNC_BRANCH="chore/upstream-sync-${TARGET_TAG}"
info "Sync branch olusturuluyor: $SYNC_BRANCH"

if git show-ref --verify --quiet "refs/heads/$SYNC_BRANCH" 2>/dev/null; then
  warn "Branch zaten mevcut: $SYNC_BRANCH. Mevcut branch uzerine devam ediliyor."
  git checkout "$SYNC_BRANCH"
else
  git checkout -b "$SYNC_BRANCH"
fi

# --- 7. Degisen dosyalari tespit et ---
FULL_SYNC=false
if [ -n "$CURRENT_HASH" ]; then
  info "Degisen dosyalar tespit ediliyor ($CURRENT_HASH..$TARGET_HASH)..."
  CHANGED_FILES=$(git diff --name-only "$CURRENT_HASH" "$TARGET_HASH" 2>/dev/null || echo "")
  if [ -z "$CHANGED_FILES" ]; then
    warn "Degisen dosya tespit edilemedi. Tam sync yapilacak."
    FULL_SYNC=true
  fi
else
  FULL_SYNC=true
fi

# --- 8. Manifest'i parse et ve dosyalari sync et ---
info "Manifest okunuyor: $MANIFEST"

SYNC_COUNT=0
SKIP_COUNT=0
PARTIAL_COUNT=0
ADAPTIVE_COUNT=0
CONFLICT_COUNT=0
ERROR_COUNT=0

# 3-way merge ile dosya sync et
# base  = derived projenin en son sync ettigi boilerplate versiyonu
# ours  = derived projedeki mevcut dosya
# theirs = boilerplate'in yeni versiyonu
#
# Sonuclar:
#   - Dosya derived projede degistirilmemisse → birebir boilerplate versiyonu alinir
#   - Dosya derived projede degistirilmisse → otomatik merge denenir
#   - Her iki taraf da ayni bolumu degistirdiyse → conflict marker birakilir
sync_exact_file() {
  local file_path="$1"

  # Dosya hedef tag'te var mi kontrol et
  if ! git cat-file -e "$TARGET_TAG:$file_path" 2>/dev/null; then
    warn "Dosya upstream'de bulunamadi, atlaniyor: $file_path"
    ((SKIP_COUNT++)) || true
    return
  fi

  # Tam sync degilse, dosya degismis mi kontrol et
  if [ "$FULL_SYNC" = false ]; then
    if ! echo "$CHANGED_FILES" | grep -qF "$file_path"; then
      return  # Dosya degismemis, atla
    fi
  fi

  local dir=$(dirname "$file_path")
  mkdir -p "$dir" 2>/dev/null || true

  # Dosya derived projede henuz yoksa → direkt kopyala
  if [ ! -f "$file_path" ]; then
    git show "$TARGET_TAG:$file_path" > "$file_path" 2>/dev/null
    ok "  [exact/yeni] $file_path"
    ((SYNC_COUNT++)) || true
    return
  fi

  # 3-way merge icin gecici dosyalar
  local tmp_base=$(mktemp)
  local tmp_ours=$(mktemp)
  local tmp_theirs=$(mktemp)
  trap "rm -f $tmp_base $tmp_ours $tmp_theirs" RETURN

  # theirs = boilerplate'in yeni versiyonu
  git show "$TARGET_TAG:$file_path" > "$tmp_theirs" 2>/dev/null

  # ours = derived projedeki mevcut dosya
  cp "$file_path" "$tmp_ours"

  # base = onceki sync noktasindaki boilerplate versiyonu
  if [ -n "$CURRENT_HASH" ] && git cat-file -e "$CURRENT_HASH:$file_path" 2>/dev/null; then
    git show "$CURRENT_HASH:$file_path" > "$tmp_base" 2>/dev/null
  else
    # Onceki versiyon yoksa, bos dosya base olarak kullan
    # Bu durumda derived projenin tum icerigi "ekleme" olarak gorunur
    > "$tmp_base"
  fi

  # Derived proje dosyayi hic degistirmemis mi kontrol et
  if diff -q "$tmp_base" "$tmp_ours" >/dev/null 2>&1; then
    # Derived proje dosyayi degistirmemis → direkt boilerplate versiyonunu al
    cp "$tmp_theirs" "$file_path"
    ok "  [exact] $file_path"
    ((SYNC_COUNT++)) || true
    return
  fi

  # Derived proje dosyayi degistirmis → 3-way merge dene
  # git merge-file: basarili ise exit 0, conflict varsa exit >0
  cp "$tmp_ours" "$file_path"
  if git merge-file -L "derived-proje" -L "onceki-sync" -L "boilerplate-$TARGET_TAG" \
      "$file_path" "$tmp_base" "$tmp_theirs" 2>/dev/null; then
    ok "  [merge] $file_path (derived degisiklikler korundu)"
    ((SYNC_COUNT++)) || true
  else
    warn "  [CONFLICT] $file_path — elle cozum gerekiyor"
    warn "    Dosyadaki <<<<<<< / ======= / >>>>>>> isaretlerini bulun ve cozun"
    ((CONFLICT_COUNT++)) || true
  fi
}

# Partial mode sync (CLAUDE.md, AGENTS.md)
sync_partial_file() {
  local file_path="$1"

  if ! git cat-file -e "$TARGET_TAG:$file_path" 2>/dev/null; then
    warn "Dosya upstream'de bulunamadi: $file_path"
    ((SKIP_COUNT++)) || true
    return
  fi

  # Tam sync degilse, dosya degismis mi kontrol et
  if [ "$FULL_SYNC" = false ]; then
    if ! echo "$CHANGED_FILES" | grep -qF "$file_path"; then
      return
    fi
  fi

  # Upstream versiyonunu gecici dosyaya cikar
  local tmp_upstream=$(mktemp)
  git show "$TARGET_TAG:$file_path" > "$tmp_upstream" 2>/dev/null

  if [ -f "$file_path" ] && [ -f "$PARTIAL_MERGE" ]; then
    # Partial merge calistir
    bash "$PARTIAL_MERGE" "$file_path" "$tmp_upstream"
    ok "  [partial] $file_path"
    ((PARTIAL_COUNT++)) || true
  elif [ ! -f "$file_path" ]; then
    # Dosya henuz yok, tam kopyala
    cp "$tmp_upstream" "$file_path"
    ok "  [partial/ilk] $file_path"
    ((SYNC_COUNT++)) || true
  else
    warn "  [partial] partial-merge.sh bulunamadi, dosya atlanıyor: $file_path"
    ((SKIP_COUNT++)) || true
  fi

  rm -f "$tmp_upstream"
}

# Adaptive mode sync
sync_adaptive_file() {
  local file_path="$1"
  local sync_config=".sync-config.yaml"

  if ! git cat-file -e "$TARGET_TAG:$file_path" 2>/dev/null; then
    warn "Dosya upstream'de bulunamadi: $file_path"
    ((SKIP_COUNT++)) || true
    return
  fi

  # Tam sync degilse, dosya degismis mi kontrol et
  if [ "$FULL_SYNC" = false ]; then
    if ! echo "$CHANGED_FILES" | grep -qF "$file_path"; then
      return
    fi
  fi

  # 3-way merge ile dosyayi sync et (exact ile ayni mantik)
  local dir=$(dirname "$file_path")
  mkdir -p "$dir" 2>/dev/null || true

  if [ ! -f "$file_path" ]; then
    # Dosya henuz yoksa direkt kopyala
    git show "$TARGET_TAG:$file_path" > "$file_path" 2>/dev/null
  else
    # 3-way merge
    local tmp_base_a=$(mktemp)
    local tmp_ours_a=$(mktemp)
    local tmp_theirs_a=$(mktemp)

    git show "$TARGET_TAG:$file_path" > "$tmp_theirs_a" 2>/dev/null
    cp "$file_path" "$tmp_ours_a"

    if [ -n "$CURRENT_HASH" ] && git cat-file -e "$CURRENT_HASH:$file_path" 2>/dev/null; then
      git show "$CURRENT_HASH:$file_path" > "$tmp_base_a" 2>/dev/null
    else
      > "$tmp_base_a"
    fi

    if diff -q "$tmp_base_a" "$tmp_ours_a" >/dev/null 2>&1; then
      cp "$tmp_theirs_a" "$file_path"
    else
      cp "$tmp_ours_a" "$file_path"
      if ! git merge-file -L "derived-proje" -L "onceki-sync" -L "boilerplate-$TARGET_TAG" \
          "$file_path" "$tmp_base_a" "$tmp_theirs_a" 2>/dev/null; then
        warn "  [CONFLICT] $file_path — adaptive merge conflict, elle cozum gerekiyor"
        ((CONFLICT_COUNT++)) || true
      fi
    fi

    rm -f "$tmp_base_a" "$tmp_ours_a" "$tmp_theirs_a"
  fi

  # .sync-config.yaml'dan degisken substitution
  if [ -f "$sync_config" ]; then
    # YAML'dan basit key-value cikartimi (yq yoksa grep/sed fallback)
    if command -v yq &>/dev/null; then
      local project_name=$(yq -r '.project_name // ""' "$sync_config")
      local org_scope=$(yq -r '.org_scope // ""' "$sync_config")
      local upstream_repo=$(yq -r '.upstream_repo // ""' "$sync_config")
    else
      local project_name=$(grep 'project_name:' "$sync_config" 2>/dev/null | sed 's/.*: *"\?\([^"]*\)"\?/\1/' || echo "")
      local org_scope=$(grep 'org_scope:' "$sync_config" 2>/dev/null | sed 's/.*: *"\?\([^"]*\)"\?/\1/' || echo "")
      local upstream_repo=$(grep 'upstream_repo:' "$sync_config" 2>/dev/null | sed 's/.*: *"\?\([^"]*\)"\?/\1/' || echo "")
    fi

    # Placeholder substitution
    if [ -n "$project_name" ]; then
      sed -i.bak "s|{{REPO_NAME}}|$project_name|g; s|{{APP_NAME}}|$project_name|g; s|{{PACKAGE_NAME}}|$project_name|g" "$file_path"
    fi
    if [ -n "$org_scope" ]; then
      sed -i.bak "s|{{ORG_SCOPE}}|$org_scope|g" "$file_path"
    fi
    if [ -n "$upstream_repo" ]; then
      sed -i.bak "s|{{UPSTREAM_REPO}}|$upstream_repo|g" "$file_path"
    fi
    rm -f "${file_path}.bak"
  fi

  ok "  [adaptive] $file_path"
  ((ADAPTIVE_COUNT++)) || true
}

# --- Ana sync dongusu ---
echo ""
info "========================================="
info "  UPSTREAM SYNC BASLIYOR"
info "  Hedef: $TARGET_TAG"
info "========================================="
echo ""

# Glob pattern'leri genislet ve sync et
# Manifest parse: basit grep-based yaklasim
# (yq varsa daha temiz, yoksa grep/awk fallback)

expand_and_sync() {
  local pattern="$1"
  local mode="$2"

  # Glob pattern'i genislet (upstream tree'de)
  local files
  files=$(git ls-tree -r --name-only "$TARGET_TAG" 2>/dev/null | grep -E "^${pattern//\*/[^/]*}$" 2>/dev/null || echo "")

  # Eger glob calismadiysa, exact match dene
  if [ -z "$files" ]; then
    # Pattern'deki * karakterlerini regex'e cevir
    local regex_pattern=$(echo "$pattern" | sed 's|\*\*/|.*/|g' | sed 's|\*|[^/]*|g')
    files=$(git ls-tree -r --name-only "$TARGET_TAG" 2>/dev/null | grep -E "^${regex_pattern}$" 2>/dev/null || echo "")
  fi

  # Hala bos ise, direkt dosya yolu olarak dene
  if [ -z "$files" ]; then
    if git cat-file -e "$TARGET_TAG:$pattern" 2>/dev/null; then
      files="$pattern"
    fi
  fi

  while IFS= read -r file; do
    [ -z "$file" ] && continue
    case "$mode" in
      exact)    sync_exact_file "$file" ;;
      partial)  sync_partial_file "$file" ;;
      adaptive) sync_adaptive_file "$file" ;;
    esac
  done <<< "$files"
}

# Manifest'ten entry'leri oku ve sync et
# Zorunlu miras (mandatory) dosyalari
info "--- ZORUNLU MIRAS DOSYALARI ---"

# ADR'ler
expand_and_sync "docs/adr/ADR-*.md" "exact"
expand_and_sync "docs/adr/18-adr-template.md" "exact"

# Domain guardrail'ler
expand_and_sync "docs/ai-guardrails/domain/D-*.md" "exact"

# Aktivite guardrail'ler
expand_and_sync "docs/ai-guardrails/activity/A-*.md" "exact"

# Governance
for gov_file in \
  "docs/governance/15-quality-gates-and-ci-rules.md" \
  "docs/governance/37-dependency-policy.md" \
  "docs/governance/38-version-compatibility-matrix.md" \
  "docs/governance/40-ai-workflow-and-tooling.md" \
  "docs/governance/41-ai-instruction-standards.md" \
  "docs/governance/42-branching-and-merge-strategy.md" \
  "docs/governance/44-exception-and-exemption-policy.md" \
  "docs/governance/45-boilerplate-project-boundary-contract.md" \
  "docs/governance/47-ai-guardrail-governance.md" \
  "docs/governance/48-expo-sdk-upgrade-strategy.md" \
  "docs/governance/49-upstream-sync-strategy.md"; do
  expand_and_sync "$gov_file" "exact"
done

# Quality baselines
expand_and_sync "docs/quality/12-accessibility-standard.md" "exact"
expand_and_sync "docs/quality/27-security-and-secrets-baseline.md" "exact"

# Design system core
expand_and_sync "docs/design-system/22-design-tokens-spec.md" "exact"
expand_and_sync "docs/design-system/23-component-governance-rules.md" "exact"

# Checklists
expand_and_sync "docs/checklists/31-audit-checklist.md" "exact"
expand_and_sync "docs/checklists/32-definition-of-done.md" "exact"

# Implementation
expand_and_sync "docs/implementation/21-repo-structure-spec.md" "exact"

# Root dosyalar (partial)
info "--- PARTIAL SYNC DOSYALARI ---"
sync_partial_file "CLAUDE.md"
sync_partial_file "AGENTS.md"

# Claude altyapisi
info "--- CLAUDE ALTYAPISI ---"
expand_and_sync ".claude/hooks/pre-edit-guardrail.sh" "exact"
expand_and_sync ".claude/hooks/post-edit-guardrail.sh" "exact"
expand_and_sync ".claude/settings.json" "exact"

# Skills dizinleri
for skill_dir in $(git ls-tree -d --name-only "$TARGET_TAG" .claude/skills/ 2>/dev/null || echo ""); do
  expand_and_sync "${skill_dir}/SKILL.md" "exact"
done

# Tooling
expand_and_sync "tooling/governance/exception-template.yaml" "exact"
expand_and_sync "tooling/sync/upstream-sync-manifest.yaml" "exact"
expand_and_sync "tooling/sync/upstream-sync.sh" "exact"
expand_and_sync "tooling/sync/partial-merge.sh" "exact"

# Yapisal miras (structural) dosyalari
echo ""
info "--- YAPISAL MIRAS DOSYALARI ---"

# Architecture
expand_and_sync "docs/architecture/*.md" "exact"

# Design system (diger)
for ds_file in \
  "docs/design-system/03-ui-ux-quality-standard.md" \
  "docs/design-system/04-design-system-architecture.md" \
  "docs/design-system/05-theming-and-visual-language.md" \
  "docs/design-system/24-motion-and-interaction-standard.md" \
  "docs/design-system/25-error-empty-loading-states.md" \
  "docs/design-system/26-platform-adaptation-rules.md" \
  "docs/design-system/33-visual-implementation-contract.md" \
  "docs/design-system/34-hig-enforcement-strategy.md" \
  "docs/design-system/39-default-screens-and-components-spec.md"; do
  expand_and_sync "$ds_file" "exact"
done

# Foundation
expand_and_sync "docs/foundation/00-project-charter.md" "exact"
expand_and_sync "docs/foundation/01-working-principles.md" "exact"
expand_and_sync "docs/foundation/02-product-platform-philosophy.md" "exact"

# Quality (diger)
expand_and_sync "docs/quality/13-performance-standard.md" "exact"
expand_and_sync "docs/quality/14-testing-strategy.md" "exact"

# Governance (diger)
for gov_file in \
  "docs/governance/16-tooling-and-governance.md" \
  "docs/governance/17-technology-decision-framework.md" \
  "docs/governance/29-release-and-versioning-rules.md" \
  "docs/governance/30-contribution-guide.md" \
  "docs/governance/36-canonical-stack-decision.md" \
  "docs/governance/46-stitch-pipeline-spec.md"; do
  expand_and_sync "$gov_file" "exact"
done

# Tooling (adaptive)
info "--- ADAPTIVE SYNC DOSYALARI ---"
expand_and_sync "tooling/ci/ci.yml" "adaptive"
expand_and_sync "tooling/ci/scheduled-audit.yml" "adaptive"
expand_and_sync "tooling/agents/apps-mobile-AGENTS.md" "adaptive"
expand_and_sync "tooling/agents/apps-web-AGENTS.md" "adaptive"
expand_and_sync "tooling/agents/packages-ui-AGENTS.md" "adaptive"

# --- 9. BOUNDARY.md guncelle ---
echo ""
info "BOUNDARY.md guncelleniyor..."

# Mevcut BOUNDARY.md'yi yedekle
if [ -f "$BOUNDARY_FILE" ]; then
  cp "$BOUNDARY_FILE" "${BOUNDARY_FILE}.bak"
fi

# Sync gecmisi satirini olustur
TOTAL_SYNCED=$((SYNC_COUNT + PARTIAL_COUNT + ADAPTIVE_COUNT))

# BOUNDARY.md'de hash, tarih ve versiyon guncelle
if [ -f "$BOUNDARY_FILE" ]; then
  # Mevcut HTML yorumlarini guncelle
  sed -i.bak "s|boilerplate_upstream_hash: [a-f0-9]*|boilerplate_upstream_hash: $TARGET_HASH|g" "$BOUNDARY_FILE"
  sed -i.bak "s|last_sync_date: [0-9-]*|last_sync_date: $SYNC_DATE|g" "$BOUNDARY_FILE"
  sed -i.bak "s|upstream_version: bp-v[0-9.]*|upstream_version: $TARGET_TAG|g" "$BOUNDARY_FILE"

  # Surum bilgisini guncelle
  sed -i.bak "s|Surum: bp-v[0-9.]*|Surum: $TARGET_TAG|g" "$BOUNDARY_FILE"
  sed -i.bak "s|Son sync tarihi: [0-9-]*|Son sync tarihi: $SYNC_DATE|g" "$BOUNDARY_FILE"
  sed -i.bak "s|Upstream hash: [a-f0-9]*|Upstream hash: $TARGET_HASH|g" "$BOUNDARY_FILE"

  # Sync gecmisi tablosuna yeni satir ekle (tablonun son satirindan sonra)
  HISTORY_LINE="| $SYNC_DATE | ${CURRENT_VERSION:-ilk} | $TARGET_TAG | $TOTAL_SYNCED |"
  # Son Audit bolumunun hemen oncesine ekle
  sed -i.bak "/^## Son Audit/i\\
$HISTORY_LINE" "$BOUNDARY_FILE"

  rm -f "${BOUNDARY_FILE}.bak"
else
  warn "BOUNDARY.md bulunamadi. Sync bilgileri yalnizca terminal ciktisinda gosterilecek."
  warn "BOUNDARY.md olusturmak icin: 43-derived-project-creation-guide.md Adim 5'e bakin."
fi

# --- 10. Sonuc raporu ---
echo ""
info "========================================="
info "  UPSTREAM SYNC TAMAMLANDI"
info "========================================="
echo ""
ok   "Hedef tag:        $TARGET_TAG"
ok   "Exact/merge sync: $SYNC_COUNT dosya"
ok   "Partial sync:     $PARTIAL_COUNT dosya"
ok   "Adaptive sync:    $ADAPTIVE_COUNT dosya"
warn "Atlanan:          $SKIP_COUNT dosya"
if [ "$CONFLICT_COUNT" -gt 0 ]; then
  error "CONFLICT:         $CONFLICT_COUNT dosya — elle cozum gerekiyor!"
  echo ""
  error "Conflict'li dosyalari bulmak icin:"
  echo "  grep -rn '<<<<<<< derived-proje' . --include='*.md' --include='*.yaml' --include='*.yml' --include='*.sh'"
  echo ""
  error "Her conflict'i cozup <<<<<<< / ======= / >>>>>>> satirlarini kaldirin."
fi
if [ "$ERROR_COUNT" -gt 0 ]; then
  error "Hata:             $ERROR_COUNT dosya"
fi
echo ""
info "Sonraki adimlar:"
echo "  1. Degisiklikleri gozden gecirin: git diff"
if [ "$CONFLICT_COUNT" -gt 0 ]; then
  echo "  2. Conflict'leri cozun (yukaridaki grep komutunu kullanin)"
  echo "  3. Commit olusturun: git add -A && git commit -m 'chore: upstream sync $TARGET_TAG'"
else
  echo "  2. Commit olusturun: git add -A && git commit -m 'chore: upstream sync $TARGET_TAG'"
fi
echo "  PR acin: git push origin $SYNC_BRANCH"
echo "     gh pr create --title 'chore: upstream sync $TARGET_TAG'"
echo ""
