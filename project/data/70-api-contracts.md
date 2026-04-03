---
id: API-CONTRACTS-001
title: API Contracts
doc_type: api_spec
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DOMAIN-MODEL-001
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
  - SYSTEM-ARCHITECTURE-001
  - AUTH-IDENTITY-SESSION-MODEL-001
  - SUBSCRIPTION-BILLING-INTEGRATION-ARCHITECTURE-001
blocks:
  - DATABASE-SCHEMA-SPEC
  - CACHE-REVALIDATION-STALENESS-RULES
  - WEBHOOK-EVENT-CONSUMER-SPEC
  - FEATURE-SEQUENCING-DEPENDENCY-ORDER
---

# API Contracts

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun HTTP ve uygulama-servis kontratlarini tanimlayan resmi API spesifikasyonudur. Hangi endpoint ailelerinin bulunacagini, hangi route'larin public veya authenticated olacagini, request ve response zarflarinin nasil standardize edilecegini, write workflow'larinda idempotency ve stale-write guard'larinin nasil uygulanacagini ve web ile mobile istemcilerin ayni semantic contract dunyasini nasil paylasacagini belirler.

Bu belge exact OpenAPI export'u degildir.  
Ama exact route implementation, shared schema paketi ve client SDK uretecek kadar baglayicidir.

Bu belge su sorulara cevap verir:

- Public okuyucu, creator uygulamasi, mobile istemci ve ops yuzeyi ayni API omurgasina nasil baglanir?
- Route aileleri hangi mantikla ayrilir?
- Hangi yazma islemleri resource mutation, hangileri workflow command sayilir?
- Idempotency ve concurrency token'lari nerede zorunludur?
- Error kodlari ve response zarfi nasil standardize edilir?
- Billing, import, publish ve ownership-sensitive aksiyonlar nasil korunur?

---

## 2. Bu belge neden kritiktir?

Bu urunde API yalnizca veri alip veri donduren bir CRUD katmani degildir.

Ayni anda su islevleri tasir:

1. auth ve session giris noktasi
2. creator workspace data yuzeyi
3. import ve verification workflow command katmani
4. publish/unpublish state transition kapisi
5. billing ve entitlement entrypoint'i
6. ops/support action entrypoint'i
7. webhook ve dis olay kabul kapisi

Bu kadar farkli sorumluluk kuralsiz tasarlanirsa tipik bozulmalar sunlardir:

### 2.1. Resource ve workflow birbirine karisir

`PATCH /products/:id` icinde publish, source secimi, disclosure override ve page attachment ayni anda yapilmaya baslar.

### 2.2. Web ve mobile farkli JSON dunyalari kurar

Ayni "import job detail" bir yerde `jobStatus`, baska yerde `status`, baska yerde `phase` olarak doner.

### 2.3. Auth var diye authorization tamam sanilir

Session tasiyan ama owner olmayan actor, ownership-sensitive mutasyonlara sessizce ulasabilir.

### 2.4. Duplicate submit ve duplicate side effect artar

Ozellikle import, publish, retry, checkout ve webhook alanlarinda idempotency yoksa veri ve audit zinciri bozulur.

### 2.5. Ops route'lari public/creator route'lariyla ayni duzende acilir

Bu da hem security hem de maintainability acisindan risklidir.

Bu nedenle API kontratlari, domain model kadar baglayici bir urun davranis katmanidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` API yuzeyi contract-first, typed ve explicit route-family mantigiyla kurulacaktir; public read, creator application, ops/internal ve webhook ingress yuzeyleri semantik olarak ayrilacak; her kritik write aksiyonu idempotency, authorization scope ve stale-write guard ile korunacaktir.

Bu karar su sonuclari dogurur:

1. Ad-hoc JSON donduren handler yazilamaz.
2. Her endpoint ailesinin actor modeli acik olacaktir.
3. Publish, import apply, checkout baslatma ve destructive aksiyonlar plain CRUD gibi modellenmeyecektir.
4. Web ve mobile presentation farkliligi kontrat semantigini degistirmeyecektir.
5. Error davranisi string mesajlardan degil, stable code alanlarindan okunacaktir.

---

## 4. Kontrat tasarim ilkeleri

## 4.1. Contract-first

Her endpoint ailesi icin su dort sey implementation'dan once netlesir:

1. request schema
2. success response schema
3. error code family
4. auth / permission expectation

## 4.2. Resource ile workflow command ayrimi

Su alanlar resource mutation'dir:

- creator profile guncelleme
- storefront appearance guncelleme
- shelf metadata degistirme
- content page basic field guncelleme

Su alanlar workflow command'dir:

- import baslatma
- verification apply
- publish
- unpublish
- checkout baslatma
- custom domain verify retry
- ownership transfer confirm

Bu iki alan ayni endpoint davranisiyla tasarlanmaz.

## 4.3. Domain-first isimlendirme

Route path teknik helper degil, urunsel anlami tasir.

Iyi ornekler:

- `/api/creator/import-jobs`
- `/api/creator/products/:productId/sources`
- `/api/creator/content-pages/:pageId/publish`
- `/api/ops/merchant-capabilities/:merchantKey`

Kotu ornekler:

- `/api/do-import`
- `/api/update-all`
- `/api/public-page-data`

## 4.4. Thin transport, thick application service

Route handler su isleri yapar:

1. input parse eder
2. auth principal cikarir
3. permission / scope guard cagirir
4. uygun application service'i tetikler
5. standard response dondurur

Handler icinde domain policy dagitilmaz.

## 4.5. Privacy-aware payload

Client'a gereken kadar veri doner.

Kurallar:

1. Creator verification payload'inda ham fetch artefact'i topluca dondurulmaz.
2. Public payload'ta internal source failure ayrintilari gosterilmez.
3. Ops payload'i publicte reuse edilmez.
4. PII iceren alanlar paylasilabilir analytics event'i yerine API response icin ayrik ele alinir.

## 4.6. Version-visible evolution

Kontrat degisimi release note'da gizlenmez.

Kurallar:

1. Response `meta.contractVersion` tasir.
2. Buyuk semantik degisimde endpoint veya schema versiyonu explicit degisir.
3. Breaking degisim sessiz rollout ile yapilmaz.

---

## 5. API topolojisi

Bu urun icin dort ana ingress ailesi vardir:

1. public read surface
2. authenticated creator surface
3. ops/internal surface
4. webhook / external ingress surface

Mantiksal ana mount'lar:

- `/api/public/*`
- `/api/auth/*`
- `/api/creator/*`
- `/api/ops/*`
- `/api/webhooks/*`

Not:

- Public HTML route'lari `/{handle}` gibi temiz path'lerde yasayabilir.
- Bu belge API kontratini tanimlar; SEO/public page route modelinin kendisi `[22-route-slug-and-url-model.md](/Users/alperenkarip/Projects/product-showcase/project/product/22-route-slug-and-url-model.md)` belgesindedir.
- Public HTML route arkasindaki loader/bff payload'i yine bu kontrat felsefesine uymak zorundadir.

---

## 6. Actor ve auth modeli

API actor seviyesinde asgari su principal turlerini tanir:

1. anonymous viewer
2. signed-in owner
3. signed-in editor
4. support
5. ops/admin
6. system worker

### 6.1. Anonymous viewer

Yalnizca public read surface'e ulasir.

### 6.2. Owner

Workspace'in nihai sahibi olan principal'dir.

Yapabilecekleri:

- import baslatma
- page publish/unpublish
- billing write aksiyonlari
- ownership-sensitive settings
- editor yonetimi

### 6.3. Editor

Icerik ve product tarafinda yetkili olabilir; ama ownership-sensitive alanlarda write yapamaz.

### 6.4. Support ve ops

Kendi mount'larinda, scoped ve auditli sekilde davranir.

### 6.5. System worker

HTTP uzerinden degil; internal contract veya signed internal endpoint uzerinden eylem alir.

Kurallar:

1. Auth varligi permission karari yerine gecmez.
2. Her creator mutation, aktif workspace/storefront scope'u ile degerlendirilir.
3. Billing ve ownership aksiyonlari owner disindaki creator principal'lara kapalidir.

---

## 7. Response zarfi standardi

Standart application response zarfi su mantigi izler:

```ts
type ApiSuccess<T> = {
  ok: true
  data: T
  meta: {
    requestId: string
    contractVersion: string
    schemaVersion: string
    warnings?: string[]
    pagination?: {
      cursor?: string
      nextCursor?: string
      hasMore: boolean
    }
  }
}

type ApiError = {
  ok: false
  error: {
    code: string
    message: string
    requestId: string
    retriable?: boolean
    retryAfterSeconds?: number
    details?: Record<string, unknown>
  }
}
```

### 7.1. Neden bu yapi?

1. Client parse davranisi stabildir.
2. Request tracing kolaylasir.
3. Pagination ve warning alanlari explicit hale gelir.
4. Teknik ve urunsel hata ayrimi standardize olur.

### 7.2. Istisnalar

Su alanlar bu zarftan ayrisabilir:

- auth callback redirect'leri
- binary asset response'lari
- webhook ack response'lari

Ama normal product API'leri bu yuzeye uyar.

---

## 8. Error kodu politikasi

Programatik davranis `message` parse edilerek kurulmaz.  
Davranis `error.code` uzerinden kurulur.

Asgari error aileleri:

- `auth.*`
- `permission.*`
- `validation.*`
- `workspace.*`
- `product.*`
- `source.*`
- `page.*`
- `import.*`
- `billing.*`
- `webhook.*`
- `system.*`

Ornek kodlar:

- `auth.unauthorized`
- `auth.reauth_required`
- `permission.owner_required`
- `permission.scope_denied`
- `workspace.inactive`
- `product.not_found`
- `product.stale_write`
- `source.invalid_primary_selection`
- `page.slug_conflict`
- `page.invalid_publish_state`
- `import.duplicate_submission`
- `import.review_expired`
- `import.apply_conflict`
- `billing.checkout_unavailable`
- `billing.entitlement_pending`
- `webhook.signature_invalid`
- `system.rate_limited`
- `system.idempotency_conflict`

Kurallar:

1. Error code aileleri dokumanda listelenen mantiga uyar.
2. Bir hata once `validation.*`, sonra `page.*` gibi karisik kodlamaz.
3. UI logic message string'e dayanmaz.

---

## 9. Request metadata kurallari

Kritik request'lerde asgari su metadata alanlari kullanilir:

- `X-Request-Id` veya server-generated request id
- `Idempotency-Key` gereken aksiyonlarda
- stale-write guard alanlari request body veya header icinde
- auth/session context
- locale/timezone sinyali gerekiyorsa explicit tasinabilir

### 9.1. Idempotency gereken route aileleri

Zorunlu:

- import create
- import retry
- verification apply
- publish
- unpublish
- ownership transfer confirm
- billing checkout start
- destructive domain settings write

### 9.2. Stale-write guard gereken route aileleri

Zorunlu:

- verification apply
- source selection update
- page publish
- page reorder
- editor invite accept/role update

Guard alan ornekleri:

- `revisionId`
- `updatedAtVersion`
- `verificationSessionId`
- `publicationDraftId`

### 9.3. Kural

Idempotency duplicate request'i tekilleştirir.  
Stale-write guard ise eski ekranin yeni veriyi ezmesini engeller.  
Bu ikisi ayni sey degildir.

---

## 10. Public read contracts

Public surface'in görevi viewer'a hizli, indexlenebilir ve trust-preserving read modeli sunmaktir.

Asgari public read aileleri:

- `GET /api/public/storefronts/:handle`
- `GET /api/public/storefronts/:handle/shelves/:slug`
- `GET /api/public/storefronts/:handle/content-pages/:slug`
- `GET /api/public/storefronts/:handle/products/:slug`
- `GET /api/public/storefronts/:handle/search`

### 10.1. Storefront read modeli

Response icermesi gereken alanlar:

- creator public identity
- storefront theme/appearance read modeli
- featured shelves/content pages summary
- trust/disclosure summary
- available public sections

Response'ta olmamasi gerekenler:

- internal ids topluca
- import telemetry
- unpublished draft alanlari
- internal merchant ranking score

### 10.2. Shelf read modeli

Response icermesi gereken alanlar:

- shelf title ve context copy
- placement listesi
- her placement icin selected source summary
- disclosure/trust row
- pagination ihtiyaci varsa cursor meta

### 10.3. Content page read modeli

Response icermesi gereken alanlar:

- content-linked context
- page hero/summary
- placements
- related shelf or storefront breadcrumbs
- disclosure summary

### 10.4. Public product detail modeli

Bu urunde product detail route ikincil yuzeydir.

Response:

- product identity
- primary media summary
- selected source summary
- price/freshness/trust row
- page-context entrypoints

Kurallar:

1. Public response daima selected/primary source semantigine uyar.
2. Multi-source tum detaylar publicte dump edilmez.
3. Stale veya hidden-by-policy fiyat null birakilip sebep gizlenmez; trust state ozetlenir.

### 10.5. Public search/filter contract

Launch'ta global marketplace search yoktur.  
Public search storefront scope'unda calisir.

Query param aileleri:

- `q`
- `tag`
- `surfaceType`
- `sort`
- `cursor`

Kural:

- search exact database query semanticsini expose etmez
- unsupported filter silently ignore edilmez; `validation.invalid_filter` benzeri hata doner

---

## 11. Auth ve session contracts

Canonical auth mount:

- `/api/auth/*`

Bu aile auth altyapisi tarafindan saglanabilir; ama uygulama beklentileri baglayicidir.

Ek uygulama-level session read modeli:

- `GET /api/creator/session`

Donmesi gerekenler:

- authenticated user summary
- active workspace summary
- principal type
- workspace memberships
- entitlement snapshot summary

Donmemesi gerekenler:

- raw provider token'lari
- internal risk flags
- gereksiz session storage detail'i

Session surface amaci:

1. uygulama bootstrap
2. scope secimi
3. feature gating

Bu endpoint permission logic'in kendisi degil, sonucu yansitan read modeldir.

---

## 12. Creator workspace read contracts

Creator tarafi icin ana read aileleri:

- `GET /api/creator/dashboard`
- `GET /api/creator/products`
- `GET /api/creator/products/:productId`
- `GET /api/creator/shelves`
- `GET /api/creator/shelves/:shelfId`
- `GET /api/creator/content-pages`
- `GET /api/creator/content-pages/:pageId`
- `GET /api/creator/storefront`
- `GET /api/creator/import-jobs`
- `GET /api/creator/import-jobs/:jobId`
- `GET /api/creator/team`
- `GET /api/creator/billing`

### 12.1. Dashboard contract

Dashboard response su alanlari ozetleyebilir:

- latest import jobs
- review-required jobs
- stale public sources count
- unpublished draft count
- entitlement warnings

Ama dashboard "tum sistem dump'i" olmaz.

### 12.2. Product list contract

List response her satirda su summary'yi tasir:

- product identity
- selected source summary
- freshness badge summary
- placement count
- review flags

List response tum source'lari satir bazinda acmaz.

### 12.3. Product detail contract

Detail response:

- product core fields
- source list
- source selection state
- media candidate/selected state
- placement references
- disclosure config summary
- audit-visible important warnings

### 12.4. Import job detail contract

Bu endpoint import UI'nin omurgasidir.

Donmesi gerekenler:

- job status
- current stage
- failure code varsa
- verification summary
- reuse adaylari
- retry eligibility
- target context

Kural:

Import job detail, worker log dump'i degildir.  
Ama creator'in ne olup bittigini anlayacagi kadar detay icermelidir.

---

## 13. Creator write contracts

Ana write aileleri:

- `PATCH /api/creator/profile`
- `PATCH /api/creator/storefront`
- `POST /api/creator/shelves`
- `PATCH /api/creator/shelves/:shelfId`
- `POST /api/creator/content-pages`
- `PATCH /api/creator/content-pages/:pageId`
- `POST /api/creator/products/:productId/placements`
- `PATCH /api/creator/placements/:placementId`
- `DELETE /api/creator/placements/:placementId`
- `POST /api/creator/products`
- `PATCH /api/creator/products/:productId`
- `POST /api/creator/products/:productId/sources`
- `PATCH /api/creator/products/:productId/selected-source`

### 13.1. Create vs patch kurali

`POST` yeni entity yaratir.  
`PATCH` parcali mutasyon yapar.  
`PUT` tam replace semantigi launch kapsaminda kullanilmaz.

### 13.2. Reorder contract

Position veya order degisimi tek tek `PATCH` ile dagitilmaz.

Canonical yuzey:

- `POST /api/creator/shelves/:shelfId/reorder-placements`
- `POST /api/creator/storefront/reorder-sections`

Body:

- ordered id listesi
- stale-write guard alanlari

### 13.3. Delete semantigi

Delete route'lari "veriyi fiziksel yok et" anlamina gelmez.

Semantik:

- archive
- detach
- soft removal

hangi entity olduguna gore ayri belirlenir.

Kurallar:

1. Product delete, aktif placement varken sessizce calismaz.
2. Published surface'e bagli entity silinmeden once referential guard devreye girer.
3. Retention ve audit izi bozulmaz.

---

## 14. Import workflow contracts

Import plain resource create degildir.  
Workflow command olarak ele alinir.

Canonical route aileleri:

- `POST /api/creator/import-jobs`
- `POST /api/creator/import-jobs/:jobId/retry`
- `POST /api/creator/import-jobs/:jobId/cancel`
- `POST /api/creator/import-jobs/:jobId/apply`
- `POST /api/creator/import-jobs/:jobId/manual-correction`

### 14.1. Import create

Request asgari alanlari:

- `submittedUrl`
- `intent`
- `targetContext`
- `existingProductId` opsiyonel

Response:

- `jobId`
- `status`
- `acceptedAt`
- `dedupeDisposition`
- `nextPollHintSeconds`

Kurallar:

1. Sync response import'in tamamlandigini iddia etmez.
2. Duplicate submission tespitinde ya ayni aktif job referansi dondurulur ya da stable conflict semantigi kullanilir.
3. Owner ve editor ayri yetkilerle kullanabilir; ama target context ownership guard ayni kalir.

### 14.2. Manual correction

Manual correction write'i plain `PATCH /product` degildir.

Neden?

1. Bu yazma islemi verification session'a baglidir.
2. Extraction truth ile creator correction ayrismalidir.
3. Audit'te hangi alanin insan tarafindan duzeltildigi gorunmelidir.

Bu nedenle request su alanlari tasir:

- `verificationSessionId`
- `fieldCorrections`
- `applyMode`
- `revisionGuard`

### 14.3. Apply contract

`/apply` route'u asgari sunlari garanti eder:

1. verification session expired degil
2. stale-write guard uyumlu
3. permission gecerli
4. duplicate reuse karari kesinlesmis
5. product/source/placement mutasyonu atomic semantik tasir

Response:

- `appliedEntitySummary`
- `resultingProductId`
- `resultingPlacementIds`
- `publicInvalidationSummary`

---

## 15. Publication workflow contracts

Publish/unpublish route'lari plain `PATCH published=true` seklinde modellenmez.

Canonical aileler:

- `POST /api/creator/shelves/:shelfId/publish`
- `POST /api/creator/shelves/:shelfId/unpublish`
- `POST /api/creator/content-pages/:pageId/publish`
- `POST /api/creator/content-pages/:pageId/unpublish`
- `POST /api/creator/storefront/publish`

### 15.1. Publish neden workflow command'dur?

Cunku publish sadece flag degistirmez.

Yan etkiler:

1. validation
2. slug conflict check
3. required disclosure guard
4. selected source sanity check
5. public cache invalidation
6. OG/share regeneration
7. audit event

### 15.2. Publish response

Response icermesi gerekenler:

- `publicationState`
- `publishedAt`
- `canonicalUrl`
- `warnings`
- `invalidatedSurfaces`

### 15.3. Publish error aileleri

- `page.validation_failed`
- `page.slug_conflict`
- `page.publish_guard_failed`
- `page.source_ineligible`
- `page.entitlement_restricted`

---

## 16. Team ve ownership contracts

Ana aileler:

- `GET /api/creator/team`
- `POST /api/creator/team/invites`
- `POST /api/creator/team/invites/:inviteId/resend`
- `PATCH /api/creator/team/members/:memberId`
- `DELETE /api/creator/team/members/:memberId`
- `POST /api/creator/ownership-transfer/request`
- `POST /api/creator/ownership-transfer/confirm`

Kurallar:

1. Invite create ve ownership transfer owner-only route'lardir.
2. Editor role update owner-only aksiyondur.
3. Ownership transfer re-auth ister.
4. Transfer confirm plain role change degildir; durable workflow command sayilir.

---

## 17. Billing ve entitlement contracts

Ana aileler:

- `GET /api/creator/billing`
- `POST /api/creator/billing/checkout-session`
- `POST /api/creator/billing/portal-session`
- `POST /api/creator/billing/change-plan`
- `POST /api/creator/billing/cancel-at-period-end`

Kurallar:

1. Yalniz owner cagirir.
2. Checkout basarisi tek basina entitlement acmaz.
3. Response provider success screen'u yerine internal state'i esas alir.

### 17.1. Billing read modeli

Donmesi gerekenler:

- current plan
- entitlement summary
- billing status
- renewal or trial end date
- grace warning varsa

### 17.2. Checkout create response

Donmesi gerekenler:

- `checkoutState`
- `providerSessionUrl` veya equivalent token
- `bridgeState`
- `expiresAt`

Donmemesi gerekenler:

- raw provider object dump
- secret-bearing fields

### 17.3. Checkout edge case

Webhook veya entitlement bridge hazir degilse endpoint su davranislardan birini uygular:

1. feature-flag kapaliysa `billing.checkout_unavailable`
2. provider gecici problemliyse `system.temporarily_unavailable`

Sessiz degrade yapilip kullanici belirsiz durumda birakilmaz.

---

## 18. Ops ve support contracts

Ops/internal route'lar ayri mount'ta tutulur:

- `GET /api/ops/import-jobs`
- `GET /api/ops/import-jobs/:jobId`
- `POST /api/ops/import-jobs/:jobId/retry`
- `PATCH /api/ops/merchant-capabilities/:merchantKey`
- `POST /api/ops/link-safety/block`
- `GET /api/ops/workspaces/:workspaceId`
- `POST /api/ops/workspaces/:workspaceId/support-actions`

Kurallar:

1. Ops route'lari public dokumanda sade ozetle listelenebilir; ama auth/permission semantigi daha sıkıdır.
2. Support aksiyonlari business object degil, audited action command'dir.
3. Ops route'lari normal creator client bundle'i tarafindan kullanilmaz.

### 18.1. Support action contract'lari

Su aksiyonlar icin reason ve audit zorunludur:

- invite reset
- import unlock / retry force
- ownership recovery support note
- domain verification assist

Kurallar:

1. "silent fix" yoktur
2. reason ve actor kaydi olmadan state mutation yapilmaz

---

## 19. Webhook surface siniri

Webhook route'lari bu belgede aile olarak tanimlanir; detayli davranis `[75-webhook-and-event-consumer-spec.md](/Users/alperenkarip/Projects/product-showcase/project/data/75-webhook-and-event-consumer-spec.md)` belgesindedir.

Ana route aileleri:

- `POST /api/webhooks/billing`
- `POST /api/webhooks/web-checkout`
- `POST /api/webhooks/domain`
- `POST /api/webhooks/email`
- `POST /api/webhooks/extraction-provider`

Kurallar:

1. Her webhook signature dogrular.
2. Her webhook durable dedupe anahtarina sahiptir.
3. Basari yaniti side effect'in aninda tamamlandigini degil, event'in kabul edildigini ifade eder.

---

## 20. Pagination, filtering ve sorting

List endpoint'leri page-number yerine cursor-first mantik izler.

### 20.1. Cursor gereken aileler

- products
- import jobs
- ops import jobs
- audit-facing listeler

### 20.2. Kucuk ayar listelerinde

Kisa ve bounded listelerde page numarasi veya tam liste response'u kabul edilebilir.

### 20.3. Filtering kurallari

Filtering alanlari explicit whitelist ile belirlenir.

Ornek:

- `status`
- `visibility`
- `freshnessState`
- `surfaceType`
- `merchantKey`

Kural:

- unknown filter silently ignore edilmez
- sort alanlari sabit whitelist'tir

---

## 21. Validation ve field-level error davranisi

Validation error'lari iki katmanda ele alinir:

1. schema-level validation
2. domain-level validation

### 21.1. Schema-level

Ornek:

- URL parse edilemiyor
- slug pattern gecersiz
- enum disi deger gonderildi

Kod ailesi:

- `validation.*`

### 21.2. Domain-level

Ornek:

- secili source public icin uygun degil
- publish icin disclosure eksik
- editor billing route'una erisiyor

Kod ailesi:

- ilgili domain family

### 21.3. Field errors

UI form mapping icin `details.fieldErrors` yapisi verilebilir.  
Ama domain-level hatalar yalniz field error'a indirgenmez.

---

## 22. Rate limiting ve abuse guard'lari

Asgari rate-limited aileler:

- import create
- import retry
- invite create/resend
- checkout session start
- webhook ingress
- public search

Kurallar:

1. Rate limit actor + IP + route semantigine gore ayarlanir.
2. Abuse guard sessiz degrade degil, explicit `system.rate_limited` hatasi dondurur.
3. Public HTML page request'leri ile programatik public API request'leri ayni limit politikasini kullanmak zorunda degildir.

---

## 23. Cache ile kontrat arasindaki sinir

Cache davranisi `[73-cache-revalidation-and-staleness-rules.md](/Users/alperenkarip/Projects/product-showcase/project/data/73-cache-revalidation-and-staleness-rules.md)` belgesinin konusudur.  
Ama kontrat tarafinda su kurallar baglayicidir:

1. Shared cache'e uygun olmayan user-scoped response'lar `private/no-store` semantigine sahiptir.
2. Public response'lar cachelenebilir olsa bile stale trust state'i gizlenmez.
3. Write response'u cache invalidation icin gerekli tag/summary bilgisini `meta.warnings` veya explicit alanlarla tasiyabilir.

---

## 24. Senaryo bazli zorunlu akışlar

### 24.1. Senaryo: Editor URL import baslatir

Beklenen akış:

1. Session resolve edilir
2. Aktif workspace scope cikarilir
3. Editor'un target surface uzerinde write yetkisi kontrol edilir
4. URL parse edilir
5. Idempotency kontrolu yapilir
6. Job accepted response doner

Olasi sorunlar:

- editor target context'e yetkisiz
- ayni URL icin aktif job var
- domain blocked

Beklenen davranis:

- permission veya import family hata kodu doner
- duplicate durumda ya mevcut job referansi ya da conflict semantigi acikca gorunur

### 24.2. Senaryo: Creator review ekranindan apply yapar

Beklenen akış:

1. Verification session okunur
2. Expiry kontrolu yapilir
3. Stale-write guard kontrol edilir
4. Reuse/new product karari uygulanir
5. Product/source/placement mutasyonu gerceklesir
6. Public invalidation summary doner

Olasi sorunlar:

- verification expired
- duplicate product race
- target page archived

Beklenen davranis:

- sessiz overwrite yok
- explicit domain error kodu var
- creator yeni verification veya target secimine yonlendirilir

### 24.3. Senaryo: Owner page publish eder

Beklenen akış:

1. Publish command gelir
2. Validation + slug guard + disclosure guard calisir
3. Publication state atomik guncellenir
4. Cache/OG invalidation event'i tetiklenir
5. Canonical URL response'a konur

Olasi sorunlar:

- slug conflict
- required source/trust state eksik
- entitlement limiti asildi

### 24.4. Senaryo: Billing checkout acilir ama bridge hazir degildir

Beklenen davranis:

1. Endpoint success page URL donmez
2. `billing.checkout_unavailable` veya kontrollu bakım semantigi doner
3. UI owner'a net yonlendirme verir

---

## 25. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. `PATCH /entity/:id` icine ilgisiz workflow'lari yigmak
2. Mesaj string'ine bakarak client davranisi kurmak
3. Creator ve mobile icin farkli semantic response kullanmak
4. Publish ve apply gibi kritik write'larda stale-write guard kullanmamak
5. Public ve ops surface'i ayni route/dto ile servis etmek
6. Verification correction'i plain product patch gibi ele almak
7. Idempotency anahtarini alip storage olmadan yok saymak
8. Unknown filter veya invalid sort'u sessizce ignore etmek
9. Success response icinde aslinda async olan isi tamamlandi gibi gostermek

---

## 26. Bu belge sonraki belgelere ne emreder?

Bu belge su belgeler icin baglayici emirler verir:

### 26.1. Database schema

- idempotency, webhook ve audit icin durable tablo aileleri kurulacak
- verification session ve publication workflow'lari tablo/ilişki seviyesinde desteklenecek

### 26.2. Cache/revalidation

- route ailelerine gore cacheability ve invalidation tag'leri tanimlanacak

### 26.3. Webhook consumer

- webhook ingress route'lari burada belirtilen error/idempotency standardina uyacak

### 26.4. Uygulama implementasyonu

- shared contract/schema paketi olmadan route implementation tamamlanmis sayilmayacak
- route-level auth ve permission guard'lari explicit katmanlasacak

---

## 27. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin asgari olarak sunlar dogru olmalidir:

1. Her ana route ailesinin actor modeli netlesmis olmali.
2. Import, publish, billing ve webhook gibi kritik workflow'lar plain CRUD gibi ele alinmiyor olmali.
3. Error kodu ve response zarfi tutarli olmali.
4. Database, cache ve webhook belgeleri bu kontratlari gercekleyebilecek kadar hizalanmis olmali.
5. Yeni bir muhendis bu belgeye bakarak route klasorlugu ve shared schema paketini tasarlayabiliyor olmali.
