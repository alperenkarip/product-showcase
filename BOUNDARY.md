# BOUNDARY.md

## Dokuman Kimligi

- **Dokuman adi:** Derived Project Boundary
- **Dosya adi:** `BOUNDARY.md`
- **Dokuman turu:** Boundary / derived project manifest
- **Durum:** Accepted
- **Tarih:** 2026-04-03
- **Kapsam:** `product-showcase` calisma alaninin boilerplate ile sinir iliskisini, zorunlu miras katmanlarini, proje-ozel dokuman alanini ve mevcut turetme durumunu tanimlar.

---

# 1. Amac

Bu belge, boilerplate otoritesi ile proje otoritesini acik bicimde ayirir. Bu repoda yazilan her proje-ozel belge, boilerplate'in canonical karar katmaniyla uyumlu kalmak zorundadir.

---

# 2. Guncel Turetme Durumu

| Alan | Durum |
| --- | --- |
| Proje adi | `product-showcase` |
| Calisma modu | Documentation-first, implementation-ready, pre-code-bootstrap |
| Boilerplate referansi | `../boilerplate` |
| Referans denetim tarihi | 2026-04-02 |
| Fiziksel monorepo bootstrap | Henuz uygulanmadi; source-of-truth bootstrap belgeleri yazildi |
| Upstream remote | `origin -> alperenkarip/product-showcase` |
| `.sync-config.yaml` | Yok |
| `docs/adr/` boilerplate kopyasi | Yok |
| Aktif override | Yok |

Bu repo artik proje icin canonical git reposudur; kod omurgasi henuz acilmamis olsa da derived monorepo bootstrap'i bu repo icinde uygulanacaktir.

---

# 3. Zorunlu Miras Katmanlari

Bu proje asagidaki boilerplate katmanlarini baglayici kabul eder:

- `docs/adr/ADR-001` -> `ADR-019`
- `docs/governance/36-canonical-stack-decision.md`
- `docs/governance/37-dependency-policy.md`
- `docs/governance/38-version-compatibility-matrix.md`
- `docs/governance/45-boilerplate-project-boundary-contract.md`
- `docs/governance/49-upstream-sync-strategy.md`
- `docs/foundation/00-project-charter.md`
- `docs/foundation/01-working-principles.md`
- `docs/foundation/02-product-platform-philosophy.md`
- `docs/quality/12-accessibility-standard.md`
- `docs/quality/27-security-and-secrets-baseline.md`
- `docs/governance/47-ai-guardrail-governance.md`

Proje belgeleri bu alanlarla celisemez; yalnizca proje baglaminda somutlastirma ve daraltma yapabilir.

---

# 4. Proje Otorite Alani

Bu repo icinde proje ekibinin otorite alani:

- `project/` altindaki tum proje-ozel belgeler
- root `README.md`
- root `BOUNDARY.md`
- root `.env.example`
- kaynak arastirma notlari

Boilerplate'in `docs/` alani referans otoritesidir. Bu repoda o alan tekrar yazilmaz.

---

# 5. Aktif Override ve Bilincli Yorumlar

## 5.1 Aktif override

Yok.

## 5.2 Bilincli yorumlar

- kategori-first yerine context-first IA
- public consumption web-first
- creator workflow mobile-friendly + web-supported split
- URL import motorunun cekirdek teknik risk olarak ele alinmasi
- controlled template/preset modeli

Bu yorumlar boilerplate stack kararlarini acmaz; proje alanini somutlastirir.

---

# 6. Bu Iterasyonda Uretilen Belge Seti

Bu repo icinde olusturulan proje-ozel belge aileleri:

- foundation
- research
- product
- domain
- import
- design
- architecture
- data
- quality
- compliance
- operations
- implementation
- implementation-ready bootstrap pack
- project ADR
- project AI guardrails

Toplam `project/` belge sayisi: 107 dosya.

---

# 7. Bilinen Bosluklar

Belge seti implementation-ready olsa da su alanlar henuz fiziksel repo seviyesinde yoktur:

- `apps/`, `packages/`, `tooling/`, `scripts/`
- derived repo `docs/` ve boilerplate ADR kopyasi
- upstream sync config ve docs mirror automation
- toolchain lock dosyalari

Bu bosluklar artik belgesiz degildir; `project/implementation/116-118`, `project/data/76-77` ve `project/operations/105-106` aileleri tarafindan kapatilacak sekilde tanimlanmistir. Fiziksel implementasyon adimi bunlari uygulamaktir.

---

# 8. Sonraki Zorunlu Adimlar

1. `project/implementation/116-derived-repo-bootstrap-and-monorepo-spec.md` uzerinden fiziksel repo bootstrap'ini baslatmak
2. `project/implementation/117-tech-stack-and-runtime-decisions.md` uzerinden dependency ve runtime lock'larini package manifest'lerine uygulamak
3. `project/data/76-openapi-and-client-generation-spec.md` ve `project/data/77-database-migration-and-seed-bootstrap-plan.md` uzerinden generated artefact ve migration zincirini kurmak
4. `docs/adr/` referans setini derived repo'ya yerlestirmek
5. `.env.example` ve `project/operations/100-environment-and-secrets-matrix.md` uzerinden gercek environment kurulumuna gecmek
6. `project/implementation/118-mvp-execution-ticket-pack.md` uzerinden sprint ve ticket acilisini baslatmak
