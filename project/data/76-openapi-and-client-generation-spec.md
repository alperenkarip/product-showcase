---
id: OPENAPI-CLIENT-GENERATION-SPEC-001
title: OpenAPI and Client Generation Spec
doc_type: api_codegen_spec
status: ratified
version: 1.0.0
owner: engineering
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - API-CONTRACTS-001
  - DERIVED-REPO-BOOTSTRAP-MONOREPO-SPEC-001
  - TECH-STACK-RUNTIME-DECISIONS-001
  - DATABASE-SCHEMA-SPEC-001
blocks:
  - MVP-EXECUTION-TICKET-PACK-001
---

# OpenAPI and Client Generation Spec

## 1. Bu belge nedir?

Bu belge, `[70-api-contracts.md](/Users/alperenkarip/Projects/product-showcase/project/data/70-api-contracts.md)` icinde tanimlanan semantik API kontratinin fiziksel schema authority, OpenAPI export, generated client ve mock/fixture zincirine nasil donecegini tanimlayan resmi codegen belgesidir.

Bu belge su sorulari kapatir:

- exact machine-readable kontrat nerede yasayacak?
- OpenAPI artefact'i hangi kaynaktan generate edilecek?
- generated client hangi package'e yazilacak?
- request/response schema kimindir?
- manual edit yasagi nerede baslar?

Bu belge olmadiginda tipik bozulma sudur:

1. `70-api-contracts` insan-okur belge olarak kalir
2. route handler'lar kendi lokal type'larini uretir
3. mobile ve web farkli DTO tanimlariyla yasamaya baslar
4. mock ve generated client baska dogrular uretir

---

## 2. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` HTTP kontrat authority'si `packages/contracts` altindaki runtime-validated Zod schema'lar olacak; OpenAPI `v1` artefact'i bu schema katmanindan generate edilecek; generated web/mobile client'lari ve contract fixture'lari ayni authority'den uretilecek; OpenAPI JSON/YAML ve generated client dosyalari elle duzenlenmeyecektir.

Bu karar su sonuclari dogurur:

1. markdown belge -> semantik authority
2. Zod schema -> executable authority
3. OpenAPI -> transport export
4. generated client -> app tuketim katmani

Bu zincir tersine cevrilmez.

---

## 3. Authority katmanlari

Bu projede API authority katmani dort seviyeden olusur:

1. urunsel contract authority -> `70-api-contracts.md`
2. executable schema authority -> `packages/contracts/src/http/*`
3. generated OpenAPI artefact -> `packages/contracts/openapi/product-showcase-v1.{json,yaml}`
4. generated client -> `packages/contracts/generated-client/*`

Kural:

- app kodu 3. veya 4. katmani tuketir
- 2. katman elle yazilir
- 3. ve 4. katman generate edilir

---

## 4. Fiziksel dosya hedefleri

Bootstrap sonrasi asgari dizinler:

```text
packages/contracts/
|-- src/
|   |-- http/
|   |   |-- public/
|   |   |-- auth/
|   |   |-- creator/
|   |   |-- ops/
|   |   `-- webhooks/
|   |-- shared/
|   |-- errors/
|   `-- events/
|-- openapi/
|   |-- product-showcase-v1.json
|   `-- product-showcase-v1.yaml
|-- generated-client/
|   |-- web/
|   |-- mobile/
|   `-- internal/
`-- fixtures/
```

### 4.1. `src/http/*`

Route request/response schema authority'sidir.

### 4.2. `openapi/*`

Generated artefact'tir. Source edit almaz.

### 4.3. `generated-client/*`

Generated request helper ve typed response wrapper katmanidir. Elle edit edilmez.

### 4.4. `fixtures/*`

Contract smoke test, mock server ve docs example payload'lari icin kullanilir.

---

## 5. Route family -> tag stratejisi

OpenAPI tag aileleri sabitlenir:

1. `public`
2. `auth`
3. `creator-workspaces`
4. `creator-products`
5. `creator-pages`
6. `creator-imports`
7. `creator-billing`
8. `ops`
9. `webhooks`

Kural:

- tag'ler runtime actor mantigiyla ayrilir
- "misc" veya "internal2" gibi adlar kullanilmaz

---

## 6. Schema tasarim kurallari

## 6.1. Request schema tek kaynaktan gelir

Query, params, headers ve body schema'lari route yaninda, ayri reusable schema dosyalari ile yazilir.

## 6.2. Response envelope standardi korunur

Success response:

- `data`
- `meta`

Error response:

- `error.code`
- `error.message`
- `error.details`
- `meta.requestId`

## 6.3. Version gorunurlugu zorunludur

`meta.contractVersion` her response'ta bulunur.

## 6.4. Stable error code registry

`packages/contracts/src/errors/` altinda error code enum authority'si olacaktir.

Kural:

- string literal'lar handler icinde rastgele yazilmaz

---

## 7. Code generation zinciri

Asgari generate sirasi su sekilde olur:

1. Zod schema compile edilir
2. OpenAPI `json` uretilir
3. OpenAPI `yaml` turetilir
4. typed client artefact'lari uretilir
5. contract fixture snapshot'lari guncellenir

Canonical root komutu:

1. `pnpm contracts:generate`

Alt komutlar:

1. `pnpm contracts:openapi`
2. `pnpm contracts:client`
3. `pnpm contracts:fixtures`

---

## 8. Manual edit yasagi

Elle duzenlenmeyecek dosyalar:

1. `packages/contracts/openapi/*.json`
2. `packages/contracts/openapi/*.yaml`
3. `packages/contracts/generated-client/**`

Elle duzenlenebilecek authority:

1. `packages/contracts/src/**`
2. `packages/contracts/fixtures/source/**`

CI kural:

- generated dosya değişmisse ama source schema degismediyse PR sorgulanir
- source schema degismisse generate output guncellenmeden PR merge edilmez

---

## 9. Web ve mobile client authority'si

Generated client iki farkli app icin ayni semantic contract'i tasir.

### 9.1. Web client

Gorevi:

1. React Router loader/action ya da query-layer cagrilari
2. auth-aware request wrapper
3. server-rendered olmayan screen composition

### 9.2. Mobile client

Gorevi:

1. creator utility request'leri
2. offline-aware retry wrapper
3. auth session summary ile entegre request pipeline

Kural:

- web ve mobile farkli adapter kullanabilir
- DTO isimleri ve error code set'i farkli olamaz

---

## 10. Mock ve fixture rejimi

Contract fixture aileleri su minimum paketi tasir:

1. happy-path public page read
2. creator import created
3. creator import needs correction
4. publish blocked by disclosure
5. billing checkout pending
6. ops merchant tier detail
7. webhook billing duplicate ignored

Kural:

- fixture payload'lari gercek field set'ini temsil eder
- placeholder `foo/bar` tipinde mock kabul edilmez

---

## 11. Versioning ve backward compatibility

Ilk transport versiyonu `v1` olur.

Breaking degisim olusturan durumlar:

1. field remove
2. field semantic degisimi
3. error code degisimi
4. idempotency veya required header degisimi

Breaking degisim su sekilde yurur:

1. belge revizyonu
2. schema degisimi
3. OpenAPI yeniden generate
4. generated client bump
5. migration/consumer impact notu

---

## 12. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. handler icinde lokal response type yazmak
2. mobile icin ayrik DTO tanimlamak
3. OpenAPI YAML'i elle duzeltmek
4. generated client yerine raw fetch dagitmak
5. docs example payload'i ile runtime schema'yi ayri dunyalarda tutmak

---

## 13. Implementation emirleri

1. Faz 0 sonunda `packages/contracts` iskeleti vardir.
2. Faz 1 sonunda public ve auth route schema'lari executable hale gelir.
3. Faz 2 sonunda creator import, publish ve billing route'lari generate output verir.
4. Faz 2 kapanmadan mobile ve web app'ler raw fetch helper biriktiremez.

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `118-mvp-execution-ticket-pack.md`, contracts bootstrap ve generate task'larini ilk sprint'e koymalidir.
2. `114-internal-test-plan.md`, contract fixture smoke test'lerini zorunlu kilmalidir.
3. `71-database-schema-spec.md` ile `76` ayni resource adlarini kullanmalidir.

---

## 15. Basari kriteri

Bu belge basarili sayilir, eger:

1. web, mobile ve ops ayni schema authority'den besleniyorsa
2. OpenAPI export gercek route implementation'i ile birebirse
3. generated client drift'i CI'da yakalaniyorsa
4. yeni bir muhendis route eklerken hangi dosyayi duzenleyecegini biliyorsa

