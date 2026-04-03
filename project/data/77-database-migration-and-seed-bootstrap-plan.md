---
id: DATABASE-MIGRATION-SEED-BOOTSTRAP-PLAN-001
title: Database Migration and Seed Bootstrap Plan
doc_type: data_execution_plan
status: ratified
version: 1.0.0
owner: engineering
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - DATABASE-SCHEMA-SPEC-001
  - DERIVED-REPO-BOOTSTRAP-MONOREPO-SPEC-001
  - TECH-STACK-RUNTIME-DECISIONS-001
  - INITIAL-SEED-CONTENT-DEMO-DATA-PLAN-001
  - INTERNAL-TEST-PLAN-001
blocks:
  - MVP-EXECUTION-TICKET-PACK-001
---

# Database Migration and Seed Bootstrap Plan

## 1. Bu belge nedir?

Bu belge, `[71-database-schema-spec.md](/Users/alperenkarip/Projects/product-showcase/project/data/71-database-schema-spec.md)` icinde tanimlanan veri modelini fiziksel migration dalgalarina, seed paketlerine, environment korumalarina ve bootstrap komutlarina cevirmek icin yazilan resmi execution planidir.

Bu belge su sorulari kapatir:

- migration'lar hangi dalgalarla cikacak?
- schema authority ile SQL migration iliskisi nasil kurulacak?
- seed verisi hangi siniflara ayrilacak?
- local, preview, staging ve production'da hangi seed davranisi kabul edilir?
- destructive migration nasil korunur?

---

## 2. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` veritabani additive-first, forward-only migration disipliniyle bootstrap edilecek; schema authority `packages/db/schema` altinda tutulacak, migration SQL artefact'lari versioned olarak check-in edilecek, seed verisi `base`, `demo`, `test-fixture` ve `ops-recovery` siniflarina ayrilacak ve production ortaminda demo seed kesinlikle calistirilmeyecektir.

Bu karar su sonuclari dogurur:

1. auto-push schema diff tek basina deployment authority olmaz
2. seed script'leri tek liste halinde karisik tutulmaz
3. preview/staging dogrulugu icin demo dataset idempotent tasarlanir
4. production reset veya manual update script'leri ayri operator sinifina cikar

---

## 3. Fiziksel dizin authority'si

```text
packages/db/
|-- src/schema/
|-- src/queries/
|-- src/seed/
|   |-- base/
|   |-- demo/
|   |-- fixtures/
|   `-- ops/
|-- migrations/
|-- drizzle.config.ts
`-- scripts/
```

### 3.1. `src/schema/`

Table, relation ve enum authority'si.

### 3.2. `migrations/`

Generated veya curated SQL migration dosyalari.

### 3.3. `src/seed/base/`

Minimum sistem seed'i:

1. role enum defaults
2. default config
3. issue code ve reason code registry

### 3.4. `src/seed/demo/`

Internal test ve staging icin creator, merchant, import, page ve billing-ornek dataset.

### 3.5. `src/seed/fixtures/`

Test suite icin deterministic kucuk dataset.

### 3.6. `src/seed/ops/`

Recovery, repair ve audit verification script'leri.

---

## 4. Migration dalga plani

Bu urunde migration dalgalari schema aksamina gore acilir:

## 4.1. M0 - Core identity ve workspace

Tablolar:

1. users
2. sessions / auth bridge
3. workspaces
4. memberships
5. storefront identities

## 4.2. M1 - Publication ve product graph

Tablolar:

1. pages
2. shelves
3. products
4. placements
5. selected source state

## 4.3. M2 - Import ve verification

Tablolar:

1. import_jobs
2. import_attempts
3. merchant_capability_snapshots
4. verification records
5. dedupe decisions

## 4.4. M3 - Trust, disclosure ve public quality

Tablolar:

1. disclosure records
2. price snapshots
3. staleness metadata
4. media candidate / selection tables

## 4.5. M4 - Billing, ownership ve compliance

Tablolar:

1. subscription mirrors
2. entitlement snapshots
3. ownership transfer records
4. takedown/report tables

## 4.6. M5 - Ops, support ve observability support tables

Tablolar:

1. audit events
2. issue queues
3. restore job records
4. operator notes

Kural:

- sonraki dalga oncekinin foreign key ve state authority'sini varsayar
- M2 oncesi import code yazmak technical debt degil, dogrudan sequencing ihlalidir

---

## 5. Migration yazim kurallari

1. Migration dosyalari kronolojik ve acik isimli olur.
2. Enum ve nullable field gecisleri destructive degil, asamali tasarlanir.
3. Large backfill gerektiren degisimde schema migration ile data backfill ayrilir.
4. Her migration rollback dusuncesiyle yazilir ama rollback script'i ayni anda calistirilacak varsayilmaz.

### 5.1. Yasaklar

1. production'da elle SQL degistirip migration'a sonradan yazmak
2. demo seed ile production config'i degistirmek
3. destructive column drop'u tek migration ile yapmak

---

## 6. Seed siniflari ve kullanimi

## 6.1. Base seed

Her ortamda calisabilir.

Icerik:

1. reason code registry
2. internal role defaults
3. essential feature gate defaults

## 6.2. Demo seed

Yalniz local, preview ve staging icindir.

Icerik:

1. `creator-beauty`
2. `creator-tech`
3. `creator-lifestyle-mixed`
4. farkli merchant tier ornekleri
5. import failure ve correction senaryolari

## 6.3. Test fixture seed

CI ve local test icindir.

Kural:

- minimal ve deterministic olur
- buyuk staging dataseti kopyalamaz

## 6.4. Ops recovery seed/script

Yalniz operator komutu ile calisir.

Icerik:

1. replay helper
2. audit compare helper
3. seed verification snapshot

---

## 7. Environment koruma kurallari

## 7.1. Local

Base + demo + fixture serbesttir.

## 7.2. Preview

Base + secili demo seed kullanilir. PII benzeri veri yoktur.

## 7.3. Staging

Base + dogrulanmis demo dataset kullanilir. Seed versiyonu release candidate ile etiketlenir.

## 7.4. Production

Yalniz base seed ve explicit operator migration script'leri kabul edilir.

Yasak:

1. demo seed
2. test fixture seed
3. reset/clean slate helper

---

## 8. Bootstrap command contract

Asgari DB komutlari:

1. `pnpm db:generate`
2. `pnpm db:migrate`
3. `pnpm db:seed:base`
4. `pnpm db:seed:demo`
5. `pnpm db:seed:fixtures`
6. `pnpm db:check`

Kural:

- `db:migrate` migration SQL olmadan schema push gibi davranmaz
- `db:seed:demo` production ortaminda guard ile durur

---

## 9. Internal test icin zorunlu seed paketi

`114-internal-test-plan.md` ile uyumlu olarak asgari demo veri paketi su aileleri tasir:

1. full / partial / fallback-only / blocked merchant ornekleri
2. stale / hidden / unavailable price state'leri
3. affiliate / sponsored / gifted / brand_provided / self_purchased / unknown_relationship disclosure state'leri
4. duplicate ve wrong-image import ornekleri
5. billing bridge pending ve entitlement-ready actor'leri

---

## 10. Backfill ve destructive degisim politikasi

### 10.1. Additive once gelir

Yeni field:

1. nullable veya default ile eklenir
2. backfill script'i ayrik calisir
3. read-path yeni alanla uyumlu hale gelir
4. sonra required hale getirilir

### 10.2. Drop son adimdir

Column/table drop ancak:

1. kod yeni alanla stabil calisiyorsa
2. read-path eski alana bagli degilse
3. staging verification tamamlandiysa

### 10.3. Rename gizli drop/add degildir

Naming degisimi migration notu ve backfill planisiz yapilmaz.

---

## 11. Audit ve dogrulama kurallari

Her migration PR'i asgari su kanitlari tasir:

1. etkilenen tablo listesi
2. backward-compat notu
3. seed etkisi
4. rollback veya mitigation notu
5. staging verify sonucu

Her seed PR'i asgari su kanitlari tasir:

1. hangi ortamlarda kosacagi
2. idempotency davranisi
3. cleanup veya reset gerekip gerekmedigi

---

## 12. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. "simdilik schema push yapalim"
2. migration ile seed'i tek script'e gommek
3. production'da demo creator hesaplari olusturmak
4. import fixtures olmadan internal test baslatmak
5. seed verisini app icinden elle olusturmak

---

## 13. Bu belge sonraki belgelere ne emreder?

1. `118-mvp-execution-ticket-pack.md`, migration dalgalarini sprint sirasina baglamalidir.
2. `71-database-schema-spec.md`, yeni tablo aileleri eklenirse bu dalga planini revize ettirmelidir.
3. `113-initial-seed-content-and-demo-data-plan.md`, demo seed siniflari ile fiziksel seed dizinlerini birebir kullanmalidir.

---

## 14. Basari kriteri

Bu belge basarili sayilir, eger:

1. schema degisimi kontrollu migration disipliniyle yuruyorsa
2. internal test icin gereken veri tek komutla yuklenebiliyorsa
3. production seed guvenligi yazili guard'larla korunuyorsa
4. yeni bir muhendis migration ve seed sorumlulugunu app koduyla karistirmiyorsa

