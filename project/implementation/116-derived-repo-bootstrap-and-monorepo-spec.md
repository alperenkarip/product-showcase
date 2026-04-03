---
id: DERIVED-REPO-BOOTSTRAP-MONOREPO-SPEC-001
title: Derived Repo Bootstrap and Monorepo Spec
doc_type: repository_spec
status: ratified
version: 1.0.0
owner: engineering
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - SYSTEM-ARCHITECTURE-001
  - WEB-SURFACE-ARCHITECTURE-001
  - MOBILE-SURFACE-ARCHITECTURE-001
  - API-CONTRACTS-001
  - ENVIRONMENT-AND-SECRETS-MATRIX-001
  - PROJECT-ROADMAP-001
blocks:
  - TECH-STACK-RUNTIME-DECISIONS-001
  - OPENAPI-CLIENT-GENERATION-SPEC-001
  - DATABASE-MIGRATION-SEED-BOOTSTRAP-PLAN-001
  - MVP-EXECUTION-TICKET-PACK-001
---

# Derived Repo Bootstrap and Monorepo Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` reposunun belge-only safhadan cikip gercek implementasyon reposuna nasil donecegini, hangi klasor ve package omurgasiyla kurulacagini, kodun nereye yazilacagini, nereye yazilmayacagini ve ilk bootstrap commit'inin hangi fiziksel ciktiyi uretmek zorunda oldugunu tanimlayan resmi derived repo belgesidir.

Bu belge su sorulari kapatir:

- Bu repo gercek kodu kendi icinde mi tasiyacak?
- `apps/`, `packages/`, `scripts/`, `tooling/` ve `project/` arasindaki sinir nedir?
- Hangi package canonical authority olacak?
- Domain, contracts, db ve import motoru neden ayrik package'lerdir?
- App kodu ile shared kod arasindaki bagimlilik yonu nasil korunacak?
- Ilk bootstrap commit'i neyi icermeden "basladi" sayilmayacaktir?

Bu belge yoksa implementasyon su sekilde bozulur:

1. `apps/web` icinde domain mantigi birikmeye baslar.
2. `apps/mobile` kendi auth ve contract kopyasini olusturur.
3. `apps/api` schema authority'yi handler dosyalarina gomerek dagitir.
4. `project/` altindaki kararlar kod dizinlerine yansimaz.
5. Seed, migration, script ve tooling rastgele klasorlerde toplanir.

Bu belge repo duzenini estetik degil, delivery ve audit konusu olarak ele alir.

---

## 2. Bu belge neden kritiktir?

`product-showcase` tek uygulama degildir. Tek repo icinde birlikte yasayacak ama farkli sorumluluk tasiyacak su runtime ve package aileleri vardir:

1. public ve creator route ailelerini tasiyan web runtime
2. hizli import ve verification odakli mobile runtime
3. auth, publication, import ve billing girislerini tasiyan API runtime
4. import, refresh, billing reconcile ve cleanup islerini tasiyan jobs runtime
5. shared contracts, domain, db ve import motoru package'leri
6. docs, scripts ve tooling katmani

Bu kadar farkli alan tek `src/` altina yigilirsa su problemler cikacaktir:

1. ownership kaybolur
2. query/auth/config siniri bozulur
3. web ve mobile ayrik dogrular uretir
4. migration ve seed disiplini app koduna gomulur
5. CI ve test gorevleri runtime yerine klasor bazli dagilir

Bu nedenle repo yapisi teknik tercih degil, urunun ilk delivery kararidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase`, bu ayni repo icinde yasayan bir `pnpm workspace + Turborepo` monoreposu olarak bootstrap edilecektir; kod authority'si `apps/` ve `packages/` altinda acik sinirlarla kurulacak, `project/` karar katmani yerinde kalacak, derived repo baska dizinde yeniden uretilmeyecek ve bootstrap sonrasi bu repo hem dokuman hem kod authority'si olacaktir.

Bu karar su sonuclari dogurur:

1. Ayrik web/mobile/api repo'lari acilmaz.
2. Bu repo "dokuman biter, sonra baska repo acilir" modeline donmez.
3. `project/` klasoru silinmez; kodun ust otoritesi olarak kalir.
4. Package sinirlari bootstrap commit'inde gorunur hale gelir.
5. App icinde lokal helper kopyalari yerine shared package authority'si kurulur.
6. Boilerplate'ten devralinan `docs/adr/` mirror'i, `.sync-config.yaml` ve `tooling/sync/upstream-sync-manifest.yaml` ayni root repo icinde fiziksel olarak kurulur.

---

## 4. Monorepo tasarim ilkeleri

Bu proje icin monorepo su sekiz ilkeye dayanir:

1. docs-first authority korunur
2. apps ince, packages baglayici olur
3. domain presentation'dan bagimsiz kalir
4. config merkezi, env kullanimi kontrollu olur
5. codegen ve generated artefact path'leri onceden sabitlenir
6. test yardimcilari runtime'lar arasi kopyalanmaz
7. scripts ve tooling app kodundan ayrik kalir
8. zorunlu miras artefact'lari fiziksel olarak repo kokunde gorunur olur

### 4.1. Docs-first authority korunur

`project/` altindaki belgeler bootstrap sonrasi da source of truth kalir. Kod bu belgeleri invalidate edemez; gerekirse belge revize edilir.

### 4.2. Apps ince, packages baglayici olur

`apps/*` yalnizca runtime giris noktasi, navigation, screen composition, handler wiring ve deployment-specific glue tasir. Domain, contract ve schema authority `packages/*` altinda olur.

### 4.3. Domain presentation'dan bagimsiz kalir

`packages/domain` ve `packages/contracts` UI kutuphanelerine baglanmaz.

### 4.4. Config merkezi olur

ESLint, TypeScript, Tailwind, Vitest, Jest, Playwright ve env parse authority'si ortak config package'lerinde yasayacaktir.

### 4.5. Generated artefact path'i gizli olmaz

OpenAPI, typed client, DB migration SQL ve analytics registry uretilen dosyalari onceden tanimli dizinlere yazilir; "generate edip nereye dusecegine bakalim" modeli reddedilir.

### 4.6. Test yardimcilari tek yerde tutulur

Fixture, mock factory, route helper ve contract test utility'leri `packages/testing` altinda toplanir.

### 4.7. Scripts uygulama kodu sayilmaz

One-shot maintenance script'leri `scripts/`; repo-genis kalite ve codegen araci ise `tooling/` altina girer.

---

### 4.8. Zorunlu miras artefact'lari fiziksel olur

`product-showcase`, boilerplate'i sadece referans gosterip gecmez. Derived repo olarak su fiziksel artefact'lari kok seviyesinde tasir:

1. read-only `docs/adr/` mirror'i
2. `.sync-config.yaml`
3. `tooling/sync/upstream-sync-manifest.yaml`
4. upstream drift/sync komutlari ve audit task'lari

Bu katmanlar olmadan repo "derived" degil, sadece "boilerplate'i okumus proje klasoru" sayilir.

---

## 5. Root klasor authority haritasi

Bootstrap sonrasi root duzeni asgari su sekilde olacaktir:

```text
.
|-- apps/
|   |-- web/
|   |-- mobile/
|   |-- api/
|   `-- jobs/
|-- packages/
|   |-- domain/
|   |-- contracts/
|   |-- db/
|   |-- auth-shared/
|   |-- import-engine/
|   |-- ui-web/
|   |-- ui-native/
|   |-- design-tokens/
|   |-- analytics/
|   |-- config-eslint/
|   |-- config-typescript/
|   |-- config-tailwind/
|   |-- testing/
|   `-- shared-utils/
|-- scripts/
|-- tooling/
|   |-- ci/
|   `-- sync/
|-- project/
|-- docs/
|   `-- adr/
|-- .github/
|-- .sync-config.yaml
|-- package.json
|-- pnpm-workspace.yaml
|-- turbo.json
`-- tsconfig.base.json
```

### 5.1. `project/`

Mevcut proje-ozel karar belgeleri burada kalir. Runtime kodu bu klasore yazilmaz.

### 5.2. `docs/`

Boilerplate referans ADR ve governance aynalari icin ayrilan alan olur. `docs/adr/` read-only tutulur; bu klasor documentation surface'tir, app kodu burada yasamaz.

### 5.3. `.sync-config.yaml`

Adaptive sync icin root source-of-truth degisken dosyasidir. Repo adi, org scope ve upstream repo kimligi bu dosyada tutulur.

### 5.4. `tooling/sync`

Upstream sync manifest'i, drift audit script'leri ve docs mirror otomasyonu burada yasayacaktir.

### 5.5. `.github/`

CI, label, release ve docs audit pipeline'i burada kalir.

---

## 6. `apps/` sinirlari

## 6.1. `apps/web`

Gorevi:

1. public web routes
2. creator authenticated routes
3. ops/admin web routes
4. web-specific data loaders ve route guards
5. SEO/OG ve web rendering davranisi

Buraya yazilmayacaklar:

1. canonical DB schema
2. import parsing mantigi
3. auth token authority
4. analytics vendor wrapper implementation authority

## 6.2. `apps/mobile`

Gorevi:

1. creator utility flow'lari
2. React Navigation shell
3. quick add, verification ve hafif edit screen'leri
4. mobile local draft ve secure storage glue

Buraya yazilmayacaklar:

1. public storefront rendering authority
2. billing truth mantigi
3. import engine parsing katmani

## 6.3. `apps/api`

Gorevi:

1. auth entrypoint
2. creator/public/ops HTTP ingress
3. application service orchestration
4. webhook ingress
5. BFF composition

Buraya yazilmayacaklar:

1. background retry loop'u
2. migration dosyalari
3. seed authority
4. import parser strategy tablosu

## 6.4. `apps/jobs`

Gorevi:

1. import worker
2. refresh scheduler
3. webhook follow-up processing
4. retention purge ve cleanup
5. media regeneration tetikleri

Buraya yazilmayacaklar:

1. HTTP API route'lari
2. route-level auth/session UI mantigi

---

## 7. `packages/` authority sinirlari

## 7.1. `packages/domain`

Canonical entity, state machine, reason code ve invariant authority'sidir.

Kural:

- UI dependency almaz
- network/HTTP client bilmez

## 7.2. `packages/contracts`

HTTP schema, event payload, typed DTO ve codegen input authority'sidir.

Kural:

- request/response schema tek source of truth burada olur
- app kodunda paralel type tanimlari yasamaz

## 7.3. `packages/db`

Drizzle schema, migration runner glue ve seed implementation authority'sidir.

Kural:

- table ve relation truth'u app'lerde tekrar edilmez

## 7.4. `packages/auth-shared`

Session summary, auth guard helper, role predicate ve secure-storage bridge helper'larini tasir.

## 7.5. `packages/import-engine`

Normalization, dedupe, extraction fallback, confidence map, media secimi ve failure taxonomy'nin kod authority'sidir.

Kural:

- UI copy uretmez
- app route bagimliligi almaz

## 7.6. `packages/ui-web`

Web component, screen-section primitive ve shared web UX helper'larini tasir.

## 7.7. `packages/ui-native`

Mobile screen primitive, token adapter ve native composable UI katmanidir.

## 7.8. `packages/design-tokens`

Semantic token authority'sidir. Raw color/spacing degerleri app icinde kopyalanmaz.

## 7.9. `packages/analytics`

Product analytics registry, event builder, consent gate helper ve vendor-agnostic adapter interface'i burada olur.

## 7.10. `packages/testing`

Factory, fixture loader, contract test helper, fake principal ve shared assertion utility authority'sidir.

## 7.11. `packages/shared-utils`

Generic ama domain-disiplinli utility'ler buradadir. "Cop kutusu" olmasina izin verilmez.

---

## 8. Bagimlilik yonu kurali

Monorepoda canonical bagimlilik yonu su sekildedir:

1. `apps/*` -> `packages/*`
2. `packages/ui-*` -> `packages/design-tokens`, `packages/contracts`, `packages/shared-utils`
3. `packages/import-engine` -> `packages/domain`, `packages/contracts`, `packages/shared-utils`
4. `packages/db` -> `packages/domain` ve sinirli `packages/contracts`
5. `packages/domain` -> kimseye degil veya yalniz cok dusuk seviye util'lere

Yasak bagimliliklar:

1. `packages/domain` -> `packages/ui-web`
2. `packages/contracts` -> `apps/api`
3. `apps/mobile` -> `apps/web`
4. `packages/db` -> `apps/jobs`
5. `project/` -> runtime package dependency

---

## 9. Bootstrap command contract

Fiziksel repo bootstrap'i sonrasi root command omurgasi asgari su sekilde olacaktir:

1. `pnpm install`
2. `pnpm lint`
3. `pnpm typecheck`
4. `pnpm test`
5. `pnpm dev:web`
6. `pnpm dev:api`
7. `pnpm dev:jobs`
8. `pnpm dev:mobile`
9. `pnpm db:migrate`
10. `pnpm db:seed:demo`
11. `pnpm contracts:generate`
12. `pnpm analytics:registry:check`

Kural:

- app-ozel script'ler root task alias'i olmadan tek basina canonical sayilmaz
- command isimleri runtime amacini acik tasir

---

## 10. Ilk bootstrap commit'inin zorunlu ciktilari

Bootstrap basladi denebilmesi icin ilk fiziksel implementasyon commit'i asgari su ciktilari tasir:

1. root workspace manifest'leri
2. `apps/web`, `apps/mobile`, `apps/api`, `apps/jobs` package manifest'leri
3. `packages/domain`, `packages/contracts`, `packages/db`, `packages/import-engine` iskeleti
4. shared TS config ve lint config package'leri
5. env parse authority'si
6. dummy ama calisan root task zinciri
7. CI'da `lint + typecheck + test` skeleton'u
8. `docs/adr/` read-only boilerplate mirror'i
9. `.sync-config.yaml`
10. `tooling/sync/upstream-sync-manifest.yaml`

Sunlar olmadan bootstrap tamamlandi denmez:

1. yalniz bos klasorler
2. package ismi var ama tsconfig yok
3. app shell var ama workspace baglantisi yok
4. command isimleri tanimsiz
5. boilerplate mirror ve sync artefact'lari atlanmis root iskeleti

---

## 11. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. "simdilik web icinde yazalim, sonra package'e cikaririz"
2. "mobile kendi contract type'ini ciksin"
3. "seed script'ini `apps/api/scripts` icine atalim"
4. "generated client dosyalari runtime app icinde olussun"
5. "shared-utils altina her seyi koyariz"
6. "ops runtime'i sonra goruruz"

---

## 12. Faz 0 implementasyon emri

Bu belge faz 0 icin su emirleri verir:

1. package sinirlari ilk commit'te gorunur hale gelecek
2. generated artefact path'leri kod yazilmadan once sabitlenecek
3. root command sozlugu ekibe onboarding maliyeti yaratmayacak kadar sade olacak
4. `project/` dokuman authority'si kodla ayni repo icinde korunacak
5. derived repo boundary'si sadece belgeyle degil, `docs/adr/` mirror'i ve sync artefact'lariyla fiziksel olarak kurulacak

---

## 13. Bu belge sonraki belgelere ne emreder?

1. `117-tech-stack-and-runtime-decisions.md`, burada tanimlanan app/package sinirlarini stack secimiyle doldurmalidir.
2. `76-openapi-and-client-generation-spec.md`, `packages/contracts` ve generated client path'lerini bu belgeye gore sabitlemelidir.
3. `77-schema-migration-and-seed-bootstrap-plan.md`, `packages/db` authority'sini bu belgeye gore kullanmalidir.
4. `118-mvp-execution-ticket-pack.md`, ilk sprint ticket'larini bu fiziksel dizinlere baglamalidir.

---

## 14. Basari kriteri

Bu belge basarili sayilir, eger:

1. yeni bir muhendis tek bakista hangi kodun nereye yazilacagini anliyorsa
2. apps ile packages arasindaki authority ayrimi tartismasizsa
3. bootstrap commit'i "dosya acildi" degil gercek monorepo omurgasi uretiyorsa
4. ileride fiziksel repo temizligine degil urun implementasyonuna enerji harcaniyorsa
