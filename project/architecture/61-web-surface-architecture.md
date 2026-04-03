---
id: WEB-SURFACE-ARCHITECTURE-001
title: Web Surface Architecture
doc_type: runtime_surface_architecture
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - SYSTEM-ARCHITECTURE-001
  - ROUTE-SLUG-URL-MODEL-001
  - PUBLIC-WEB-SCREEN-SPEC-001
blocks:
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE
  - API-CONTRACTS
  - AUTH-IDENTITY-SESSION-MODEL
---

# Web Surface Architecture

## 1. Bu belge nedir?

Bu belge, `apps/web` icindeki public web, creator authenticated web ve internal ops/admin route ailelerinin nasil ayrilacagini, rendering ve data loading stratejilerinin nasıl farklilasacagini, custom domain, canonical, metadata ve auth gate davranisinin hangi sinirlarda tutulacagini tanimlayan resmi web runtime architecture belgesidir.

Bu belge su sorulara cevap verir:

- Tek web runtime icinde neden birden fazla mantıksal surface vardir?
- Public ve authenticated route'larin rendering stratejisi neden ayni olamaz?
- Custom domain, canonical ve auth cookie davranisi nasil ayrisir?
- Hangi route aileleri indexlenir, hangileri asla indexlenmez?
- Internal ops route'lari creator route'larindan nasil ayrilir?

Bu belge, web runtime'inin route shell ve rendering omurgasidir.

---

## 2. Bu belge neden kritiktir?

Web, bu urunde hem public product consumption hem de creator/ops workspace tasir.  
Bu ayrim bulanıklaşırsa:

1. public metadata ve auth shell birbirini bozar
2. creator route'lari SEO surface gibi davranabilir
3. ops route'lari yanlışlıkla public asset indeksine sızabilir
4. custom domain ve canonical mantigi kirilir

Bu nedenle web runtime tek deploy olsa bile tek surface sayilamaz.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `apps/web`, tek build/runtime altında çalışsa bile üç ayrı mantıksal route ailesi taşır: public routes, creator authenticated routes ve internal ops/admin routes; bu aileler route guard, metadata davranışı, data loading şekli, caching ve indexing açısından ayrı kurallara tabidir.

Bu karar su sonuclari dogurur:

1. Public route'lar metadata-first ve indexable olur.
2. Creator ve ops route'lari auth-gated application shell icinde çalışır ve noindex kabul edilir.
3. Route paylaşımı olabilir ama permission ve metadata mantigi paylaşılmaz.

---

## 4. Route aileleri

### 4.1. Public routes

Ornek aileler:

- handle root storefront
- shelf page
- content page
- light product detail
- archived/removed/not-found variants

### 4.2. Creator authenticated routes

Ornek aileler:

- dashboard
- library
- shelf editor
- content page builder
- import history
- settings
- billing

### 4.3. Internal ops/admin routes

Ornek aileler:

- jobs dashboard
- job detail
- merchant registry
- support lookup
- unsafe link review

---

## 5. Route partition ilkeleri

### 5.1. URL netligi

Public ve internal route alanlari URL seviyesinde de net ayrilmalidir.

### 5.2. Auth gate ayrimi

Public route'ta auth olmadan render gerekir.  
Creator ve ops route'ta auth zorunludur.

### 5.3. Metadata ayrimi

Public route metadata üretir.  
Creator ve ops route metadata-first davranmaz; noindex'tir.

### 5.4. Shell ayrimi

Public shell:

- hafif
- SEO-aware
- anonymous-first

Creator/ops shell:

- authenticated app shell
- navigation/stateful workspace

---

## 6. Rendering stratejileri

### 6.1. Public rendering

Public surfaces su özellikleri tasir:

- metadata-first
- fast first render
- layout-faithful skeleton
- share-preview correctness

### 6.2. Creator rendering

Creator surfaces su özellikleri tasir:

- auth-gated shell
- heavier client-side interactivity
- optimistic updates ve mutation feedback

### 6.3. Ops rendering

Ops surfaces su özellikleri tasir:

- dense data views
- table/filter heavy layout
- noindex/internal-only

---

## 7. Data loading modeli

### 7.1. Public read models

Public read model:

- page context
- placements
- selected source/trust row
- metadata

üzerinden kurulur.

Kural:

- creator-side ağır workspace verisi public read model'e taşınmaz

### 7.2. Creator read models

Creator read model:

- entity yönetimi
- source detail
- duplicate clarity
- workflow status

taşir.

### 7.3. Ops read models

Ops read model:

- event/failure timeline
- registry state
- raw-ish diagnostics

taşir.

---

## 8. Caching ve invalidation ayrimi

### 8.1. Public cache

Publicte:

- page payload cache
- metadata/OG cache
- image cache

katmanlari ayrik dusunulur.

### 8.2. Creator cache

Creator route'lari daha cok session-scoped data cache ve mutation invalidation davranisi tasir.

### 8.3. Ops cache

Ops route'lari stale telemetry ve queue verisi nedeniyle kısa ömürlü veya manual refresh odakli olabilir.

Kural:

Public cache politikasi creator/ops route'larına kopyalanmaz.

---

## 9. Custom domain ve canonical davranisi

### 9.1. Public custom domain

Storefront veya public page custom domain üzerinden açılabilir.

Kural:

- canonical target tekildir
- handle-subpath fallback ile çatışmaz

### 9.2. Creator/ops routes

Creator ve ops route'lari custom public domain altında taşınmaz.  
Bu, auth cookie ve security scope'u icin kritiktir.

### 9.3. Handle/domain degisimi

Slug veya domain degisince:

- canonical invalidate
- OG/metadata refresh
- old route redirect strategy

birlikte dusunulur.

---

## 10. Auth ve session yerleşimi

### 10.1. Public

Public route'lar anonymous-first'tir.  
Signed-in viewer olsa bile public davranis auth shell'e donmez.

### 10.2. Creator

Creator route'lar:

- HttpOnly session cookie
- route-level auth gate
- workspace/context resolution

tasir.

### 10.3. Ops/admin

Ops routes:

- stronger auth gate
- internal role checks
- break-glass audit expectation

tasir.

---

## 11. Public SEO ve share önceliği

Web runtime'ta SEO/share onceligi yalniz public routes'a aittir.

Kural:

1. Draft/unlisted/creator routes indexlenmez.
2. Archived public pages active SEO yüzeyi gibi davranmaz.
3. Content page share preview priority surface kabul edilir.

---

## 12. Route-level error ve state davranisi

### 12.1. Public

Public route state'leri:

- empty storefront
- archived page
- broken merchant/degraded trust
- not found

### 12.2. Creator

Creator route state'leri:

- auth expired
- permission denied
- import failed/review required
- empty library

### 12.3. Ops

Ops route state'leri:

- empty failed queue
- anomaly spike
- blocked host detail

Bu state'ler route-level architecture'in bir parçasidir; sonradan tasarlanmaz.

---

## 13. Asset delivery stratejisi

### 13.1. Public assets

- CDN friendly
- metadata aware
- image optimized

### 13.2. Creator assets

- app shell bundle
- authenticated data fetch

### 13.3. Internal assets

- noindex/internal-only
- public route cache'ine karışmaz

---

## 14. Güvenlik sinirlari

### 14.1. Route isolation

Ops route'lari public discovery veya sitemap tarafina sızmaz.

### 14.2. Cookie scope

Custom domain ve authenticated route domain/cookie kapsamı net olmalidir.

### 14.3. Preview security

Preview/draft route'lari public canonical ile karışmaz.

---

## 15. Edge-case senaryolari

### 15.1. Custom domain altinda creator route acilmaya calisiliyor

Beklenen davranis:

- creator workspace canonical auth host'a yönlenir
- public domain altında authenticated app shell açılmaz

### 15.2. Archived public page cache'te kaldı

Beklenen davranis:

- public metadata ve page payload invalidate olur

### 15.3. Signed-in creator public page'e geldi

Beklenen davranis:

- public experience bozulmaz
- auth-only tool chrome'u enjekte edilmez

---

## 16. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Public ve creator route'larini ayni shell ile çözmek
2. Authenticated workspace route'larina SEO davranisi vermek
3. Ops route'larini creator route'lari içine gizlemek
4. Custom domain altında creator auth akisi taşımak
5. Public page metadata üretimini client-only sonradan çözmeye çalışmak

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `67-seo-og-and-share-preview-architecture.md`, public-only metadata önceliğini bu route partition modeline göre kurmalıdır.
2. `63-auth-identity-and-session-model.md`, cookie scope, session invalidation ve route guard mantığını bu belgeye göre detaylandırmalıdır.
3. `70-api-contracts.md`, public read model ile creator/ops read model ayrımını response shaping düzeyinde korumalıdır.

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- public, creator ve ops route aileleri teknik ve davranissal olarak ayrisiyorsa
- public SEO/share ihtiyaci authenticated workspace mantigina kurban edilmiyorsa
- custom domain, auth ve canonical davranislari birbiriyle çakışmıyorsa

Bu belge basarisiz sayilir, eger:

- route partition sadece klasör organizasyonu gibi kalıyorsa
- public route'lar auth shell'e, creator route'lar metadata-first davranisa kayiyorsa

