#!/bin/bash
# partial-merge.sh
# CLAUDE.md ve AGENTS.md gibi hem boilerplate hem proje-spesifik icerik
# barindiran dosyalar icin sentinel-based partial merge yapar.
#
# Sentinel formatı:
#   <!-- UPSTREAM-SYNC-START: Bolum Adi -->
#   [boilerplate icerik — sync tarafindan guncellenir]
#   <!-- UPSTREAM-SYNC-END: Bolum Adi -->
#
#   <!-- PROJECT-SPECIFIC-START: Bolum Adi -->
#   [proje-spesifik icerik — sync dokunmaz]
#   <!-- PROJECT-SPECIFIC-END: Bolum Adi -->
#
# Kullanim:
#   ./partial-merge.sh <hedef-dosya> <upstream-dosya>
#   ./partial-merge.sh CLAUDE.md /tmp/upstream-claude.md
#
# Referans: docs/governance/49-upstream-sync-strategy.md Bolum 6.3

set -euo pipefail

TARGET_FILE="${1:?Hedef dosya belirtilmeli}"
UPSTREAM_FILE="${2:?Upstream dosya belirtilmeli}"

if [ ! -f "$TARGET_FILE" ]; then
  echo "[HATA] Hedef dosya bulunamadi: $TARGET_FILE"
  exit 1
fi

if [ ! -f "$UPSTREAM_FILE" ]; then
  echo "[HATA] Upstream dosya bulunamadi: $UPSTREAM_FILE"
  exit 1
fi

# Hedef dosyada sentinel yorumlari var mi kontrol et
if ! grep -q "UPSTREAM-SYNC-START" "$TARGET_FILE"; then
  echo "[UYARI] $TARGET_FILE dosyasinda sentinel yorumlari bulunamadi."
  echo "  Partial merge yapilamaz. Dosya atlanıyor."
  echo "  Sentinel eklemek icin: 49-upstream-sync-strategy.md Bolum 6.3'e bakin."
  exit 0
fi

# Upstream dosyada da sentinel olmali
if ! grep -q "UPSTREAM-SYNC-START" "$UPSTREAM_FILE"; then
  echo "[UYARI] Upstream dosyada sentinel yorumlari bulunamadi."
  echo "  Partial merge yapilamaz. Dosya atlanıyor."
  exit 0
fi

# Gecici dosya olustur
TMP_OUTPUT=$(mktemp)
trap "rm -f $TMP_OUTPUT" EXIT

# Hedef dosyayi satir satir oku ve sentinel bloklari isle
IN_UPSTREAM_BLOCK=false
CURRENT_SECTION=""

while IFS= read -r line; do
  # UPSTREAM-SYNC-START tespiti
  if echo "$line" | grep -q "UPSTREAM-SYNC-START:"; then
    IN_UPSTREAM_BLOCK=true
    CURRENT_SECTION=$(echo "$line" | sed 's/.*UPSTREAM-SYNC-START: *\(.*\) *-->/\1/' | xargs)

    # Sentinel yorumunu yaz
    echo "$line" >> "$TMP_OUTPUT"

    # Upstream dosyadan bu bolumun icerigini al
    EXTRACTING=false
    while IFS= read -r upstream_line; do
      if echo "$upstream_line" | grep -q "UPSTREAM-SYNC-START: *${CURRENT_SECTION}"; then
        EXTRACTING=true
        continue  # Sentinel satirini atla (zaten yazdik)
      fi
      if [ "$EXTRACTING" = true ]; then
        if echo "$upstream_line" | grep -q "UPSTREAM-SYNC-END: *${CURRENT_SECTION}"; then
          break  # Bolum sonu
        fi
        echo "$upstream_line" >> "$TMP_OUTPUT"
      fi
    done < "$UPSTREAM_FILE"

    continue
  fi

  # UPSTREAM-SYNC-END tespiti
  if echo "$line" | grep -q "UPSTREAM-SYNC-END:"; then
    if [ "$IN_UPSTREAM_BLOCK" = true ]; then
      echo "$line" >> "$TMP_OUTPUT"
      IN_UPSTREAM_BLOCK=false
      CURRENT_SECTION=""
      continue
    fi
  fi

  # Upstream blok icerisindeyken hedef dosyanin eski icerigini atla
  if [ "$IN_UPSTREAM_BLOCK" = true ]; then
    continue
  fi

  # Diger satirlar (PROJECT-SPECIFIC dahil) oldugu gibi korunur
  echo "$line" >> "$TMP_OUTPUT"

done < "$TARGET_FILE"

# Sonucu hedef dosyaya yaz
cp "$TMP_OUTPUT" "$TARGET_FILE"

# Merge edilen bolum sayisini raporla
SECTION_COUNT=$(grep -c "UPSTREAM-SYNC-START" "$TARGET_FILE" 2>/dev/null || echo "0")
echo "[OK] Partial merge tamamlandi: $TARGET_FILE ($SECTION_COUNT bolum guncellendi)"
