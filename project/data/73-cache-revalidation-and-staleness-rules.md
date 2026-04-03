---
id: CACHE-REVALIDATION-STALENESS-RULES-001
title: Cache, Revalidation and Staleness Rules
doc_type: reliability_policy
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRICE-AVAILABILITY-REFRESH-POLICY-001
  - FILE-MEDIA-IMAGE-ASSET-ARCHITECTURE-001
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE-001
  - API-CONTRACTS-001
  - BACKGROUND-JOBS-SCHEDULING-SPEC-001
blocks:
  - PERFORMANCE-BUDGETS
  - RUNBOOKS
  - RELEASE-READINESS-CHECKLIST
---

# Cache, Revalidation and Staleness Rules

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde public ve authenticated read modelleri icin cache katmanlarini, hangi veri siniflarinin shared cache'e girebilecegini, hangi event'lerin hangi surface'lerde revalidation tetikleyecegini, source freshness ile cache staleness arasindaki ayrimi ve invalidation basarisizligi durumunda sistemin nasil degrade olacagini tanimlayan resmi cache ve staleness politika belgesidir.

Bu belge su sorulara cevap verir:

- Hangi data ne kadar sure cache'lenebilir?
- Public page cache'i ile source freshness neden ayni kavram degildir?
- Hangi state degisimi page invalidation ister, hangisi istemez?
- Creator ve ops read modelleri neden shared cache'e giremez?
- Media CDN cache'i, HTML/page cache'i ve client query cache'i nasil ayrisir?
- Revalidation basarisiz olursa viewer'a veya creator'a ne olur?

---

## 2. Bu belge neden kritiktir?

Bu urunde cache hatasi yalniz performans problemi yaratmaz.

Yanlis cache stratejisi su bozulmalara yol acar:

1. Publicte stale fiyat current gibi gorunur.
2. Slug degisimi sonrasi eski canonical uzun sure yasamaya devam eder.
3. Creator yeni cover yukler ama eski share image servis edilir.
4. Import apply sonrasi creator eski verification veya eski product state gorur.
5. Billing/entitlement stale cache yuzunden owner yanlis capability algilar.

Dolayisiyla cache bu urunde "hiz icin kucuk optimizasyon" degil, trust ve correctness katmanidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` cache'i performans icin kullanir, truth icin degil; public shared cache yalniz published ve privacy-safe read modellerinde kullanilir; source freshness her zaman verinin kendisine ait semantik state olarak ele alinir ve salt TTL ile karistirilmaz; kritik state degisimlerinde event-driven revalidation esastir.

Bu karar su sonuclari dogurur:

1. TTL bitmeden de invalidation tetiklenebilir.
2. Selected source freshness state degisimi, gerekli public surface'lerde cache invalidation olayi sayilir.
3. Creator, ops, billing ve import verification payload'lari shared cache'e girmez.
4. Long-lived media CDN cache'i content-hashed asset'ler uzerinden kurulur; pointer metadata ise event-driven guncellenir.

---

## 4. Temel kavramlar

### 4.1. Shared cache

Birden fazla kullanicinin ayni cache objesini gorebildigi cache katmani.

Ornek:

- edge/html cache
- public API response cache
- CDN object cache

### 4.2. Private cache

Tek kullanici veya tek cihaz baglaminda tutulan cache.

Ornek:

- creator query cache
- mobile local draft cache

### 4.3. Cache staleness

Cache'teki verinin arkadaki source of truth ile ayni olmayabilecegi durumu.

### 4.4. Source freshness

Product source verisinin ne kadar guncel oldugunu anlatan domain semantigi.

### 4.5. Revalidation

Cache objesinin yeniden dogrulanmasi veya tekrar uretilmesi sureci.

### 4.6. Invalidation

Belirli cache key/tag/route'un artik guvenilir olmadigini ilan edip yenilenmeye zorlayan aksiyon.

Kural:

Cache staleness ile source freshness ayni kavram olarak kullanilamaz.

---

## 5. Cache katmanlari

Bu urunde alti ana cache katmani vardir:

1. public route/html cache
2. public data payload cache
3. creator/mobile client query cache
4. media ve CDN cache
5. OG/share preview cache
6. scheduler/reliability purpose store'lari

### 5.1. Public route/html cache

Kapsar:

- storefront page
- shelf page
- content page
- varsa product light detail page

Ozellik:

- shared olabilir
- published surface ile sinirlidir

### 5.2. Public data payload cache

Kapsar:

- server-side loader/BFF read modeli
- public JSON veya internal serialized read payload

### 5.3. Creator/mobile client query cache

Kapsar:

- dashboard summary
- product list/detail
- import job status
- settings
- billing summary

Ozellik:

- shared cache degildir
- staleTime ve invalidation kurallari ayri ele alinir

### 5.4. Media ve CDN cache

Kapsar:

- product image variant'lari
- creator cover variant'lari
- generated asset'ler

### 5.5. OG/share preview cache

Kapsar:

- OG image asset'i
- metadata read modeli

### 5.6. Reliability store'lari

Idempotency key, workflow dedup ve benzeri mekanizmalar "cache" gibi gorunse de bu belgede performance cache sayilmaz; bunlar durable reliability store'dur.

---

## 6. Shared cache'e uygun veri siniflari

Shared cache'e girebilecek baslica veri siniflari:

1. published public storefront read modeli
2. published shelf read modeli
3. published content page read modeli
4. product light detail public read modeli
5. static-ish dictionary verileri
6. immutable content-hashed media asset'leri

Kurallar:

1. Shared cache'e girecek her response privacy-safe olmalidir.
2. Public response unpublished veya internal alan tasiyamaz.
3. Shared cache'e giren response trust state'ini gizleyemez.

---

## 7. Shared cache'e uygun olmayan veri siniflari

Asagidaki veri siniflari shared cache'e GIREMEZ:

1. creator dashboard
2. import verification payload
3. import job detail
4. entitlement/billing current state
5. workspace team ve invite listeleri
6. ops/support panel read modelleri
7. session ve auth state
8. deletion/export workflow state'leri

Neden?

1. privacy riski
2. actor-specific dogruluk ihtiyaci
3. yuksek state degisim hizi
4. stale data'nin zararinin yuksek olmasi

---

## 8. TTL ve stale-time ilkeleri

Event-driven invalidation ana mekanizmadir.  
TTL ise fallback/performans penceresidir.

### 8.1. Public route/html cache

Varsayilan hedef:

- hard TTL: `300` saniye
- stale-while-revalidate benzeri pencere: sistem yetenegine gore kontrollu kullanilabilir

Neden?

- public trafik kazanci
- ama slug, publish veya trust state degisimlerinde gec yenilenme olmamali

### 8.2. Public loader/payload cache

Varsayilan:

- `60-300` saniye arasi
- ama event-driven invalidation zorunlu

### 8.3. Creator query cache

Entity sinifina gore degisir:

- dashboard summary: `15-30` saniye
- product list/detail: `15-60` saniye
- import job status: UI poll veya focus-based refetch
- billing summary: `30-60` saniye
- settings: daha uzun ama mutation sonrasi explicit invalidate

### 8.4. Media CDN cache

Immutable content-hashed asset'ler icin:

- uzun TTL (`30` gun ve ustu)

Pointer veya mutable URL semantigi olan durumlarda:

- uzun TTL yerine versioned key stratejisi tercih edilir

### 8.5. OG/share asset cache

Hashli asset icin uzun TTL uygundur.  
Ama metadata page'i publication revision degisince yeniden olusturulur.

---

## 9. Source freshness ile cache iliskisi

Fiyat ve availability staleness'i TTL ile cözulmez.

### 9.1. Domain truth

`freshness_state`, `price_display_state` ve `last_checked_at` source'un domain verisidir.

### 9.2. Cache'in rolu

Cache, bu domain truth'unu belli sure tutar.  
Ama stale oldugu halde cache'te current gibi gostermeyi meşrulastirmaz.

### 9.3. Kritik kural

Selected source su state gecislerinden birine girerse ilgili public surface invalidation gerekir:

- `show_current -> show_with_stale_notice`
- `show_with_stale_notice -> hidden_by_policy`
- `availability in_stock -> out_of_stock`
- selected source degisikligi

Bu state degisimleri TTL bitimini beklemez.

---

## 10. Revalidation tetikleyicileri

Public ve creator surface'lerde asgari su olaylar revalidation tetikler:

### 10.1. Publication olaylari

- shelf publish
- shelf unpublish
- content page publish
- content page unpublish
- storefront publish durumu degisimi

### 10.2. URL ve canonical olaylari

- slug degisimi
- handle degisimi
- custom domain aktivasyonu
- custom domain kaldirilmasi

### 10.3. Product/source olaylari

- selected source degisimi
- selected source freshness state esik gecisi
- price display state degisimi
- availability state kritik gecisi
- product title veya selected media degisimi

### 10.4. Appearance ve media olaylari

- storefront cover degisimi
- shelf hero degisimi
- content page visual degisimi
- OG generation tamamlama

### 10.5. Team/billing olaylari

Public invalidation gerekmez; creator-side private invalidation gerekir:

- entitlement degisimi
- invite acceptance
- role degisimi

---

## 11. Invalidation kapsami

Her event tum sistemi invalidate etmez.  
Kapsam kontrollu olmalidir.

### 11.1. Storefront degisikligi

Invalidate edilmesi gerekenler:

- storefront route
- ilgili metadata
- varsa featured section payload'i

### 11.2. Shelf publish/unpublish

Invalidate edilmesi gerekenler:

- ilgili shelf route
- storefront featured listesi etkileniyorsa storefront route
- ilgili OG/share asset pointer'lari

### 11.3. Content page degisikligi

Invalidate edilmesi gerekenler:

- ilgili content page route
- storefront veya bagli section summary gerekiyorsa o read model

### 11.4. Selected source freshness esik gecisi

Invalidate edilmesi gerekenler:

- product'i gosteren public surfaces
- product light detail route varsa o route

### 11.5. Billing degisikligi

Invalidate edilmesi gerekenler:

- creator billing read modeli
- capability-gated creator screens

Shared public cache invalidation gerekmeyebilir; entitlements public truth'u sessizce degistirmiyorsa.

---

## 12. Cache key ve tag ilkeleri

Cache invalidation route string'e bagli karma mantiklarla degil, semantik key/tag aileleriyle calisir.

Asgari tag aileleri:

- `storefront:{storefrontId}`
- `shelf:{shelfId}`
- `content-page:{pageId}`
- `product:{productId}`
- `source:{sourceId}`
- `billing:{creatorProfileId}`
- `team:{creatorProfileId}`
- `og:{surfaceType}:{surfaceId}`

Kurallar:

1. Bir product degisikligi, tum creator cache'ini kolektif temizleme bahanesi olamaz.
2. Route bazli invalidate gerekiyorsa tag'den route haritalama deterministic olur.
3. Tag ailesi adlari product ve observability event isimleriyle uyumlu kalir.

---

## 13. Creator query cache kurallari

Creator tarafinda client query cache'i vardir; ama bu truth degildir.

### 13.1. Mutation sonrasi invalidation

Asagidaki mutasyonlardan sonra explicit invalidation zorunludur:

- import apply
- product source selection
- page publish/unpublish
- appearance update
- billing plan degisimi

### 13.2. Import job polling

Import job detail response'u uzun staleTime ile tutulmaz.

Beklenen davranis:

- aktif `accepted/queued/processing` job'larda kisa periyotlu refetch
- `needs_review/applied/failed/blocked` durumunda daha seyrek veya event/focus tabanli refetch

### 13.3. Offline ve reconnect

Reconnect sonrasi eski creator state sessizce authoritative kabul edilmez; gerekli sorgular yeniden dogrulanir.

---

## 14. Mobile local cache kurallari

Mobile creator runtime su alanlarda local cache kullanabilir:

- son acilan dashboard summary
- product list snapshot
- taslak hedef secimi

Ama su alanlarda local cache authoritative olamaz:

- import apply sonucu
- billing/entitlement state
- ownership/team state

Offline pattern:

1. local cache kullaniciya son gorulen state'i gosterebilir
2. baglanti gelince server truth ile yeniden hizalanir
3. stale veya conflict durumunda UI bunu gizlemez

---

## 15. Media ve OG cache kurallari

## 15.1. Immutable asset ilkesi

Content-hashed media URL'leri degismeyen asset gibi cachelenebilir.

## 15.2. Mutable pointer yasagi

Ayni URL altinda farkli binary servis edip CDN purge'e bel baglamak tercih edilen model degildir.

## 15.3. OG asset davranisi

OG asset:

- publication revision veya gorsel context degisince yeni kimlikle uretilir
- eski asset'ler kisa sure yasayabilir ama aktif pointer degisir

### 15.4. Hotlink yasagi

Merchant image URL'si publicte kalici asset URL'si gibi cachelenmez.

---

## 16. Search ve index staleness

Public search/read model indeksi varsa, bunun stale olmasi page cache'ten ayri ele alinir.

Kurallar:

1. Publish/unpublish olaylari search indeksine event-driven yansitilir.
2. Search sonucu public route var olmayan veya unpublished page'e gitmemelidir.
3. Search index stale ise UI hafif gecikmeyi tolere edebilir; ama broken result kabul edilemez.

Hedef:

- publish veya unpublish sonrasi `5` dakika icinde index uyumu

---

## 17. Revalidation failure davranisi

Revalidation da bir workflow'dur; basarisiz olabilir.

### 17.1. Public route revalidation fail

Beklenen sistem davranisi:

1. Outbox/job retry dener
2. Telemetry event uretilir
3. Yeni write basarili olsa bile invalidation sorunu runbook konusu olur

### 17.2. OG generation fail

Beklenen davranis:

1. Page public olmaya devam eder
2. fallback metadata/preview davranisi kullanilir
3. generation retry veya parked mekanizmasi devreye girer

### 17.3. CDN propagation gecikmesi

Beklenen davranis:

1. Yeni asset pointer'i DB/public metadata'da dogru olur
2. kisa sureli propagation farki tolera edilir
3. ama eski asset'e sonsuz referans verilmez

---

## 18. Canonical degisim ve redirect davranisi

Slug, handle veya custom domain degisimleri cache acisindan en riskli olaylardandir.

Kurallar:

1. Yeni canonical route aktif edilir
2. Eski slug history kaydi redirect davranisi tasir
3. Eski route cache'i invalidate edilir
4. Metadata ve OG pointer'i yeni canonical'a baglanir

Yasak davranis:

- yeni canonical aktif edip eski route cache'ini kendi haline birakmak

---

## 19. Senaryo bazli akışlar

### 19.1. Senaryo: Content page publish edildi

Beklenen akış:

1. Publication kaydi yazilir
2. `content-page:{id}` tag'i invalidate edilir
3. storefront featured list etkileniyorsa `storefront:{id}` invalidate edilir
4. metadata/og generation follow-up tetiklenir

### 19.2. Senaryo: Selected source `show_current` iken stale notice'a dustu

Beklenen akış:

1. refresh veya scheduler source state'i gunceller
2. ilgili product ve onu gosteren public surface tag'leri invalidate edilir
3. yeni read model stale notice ile uretilir

### 19.3. Senaryo: Creator yeni shelf cover yukledi

Beklenen akış:

1. eski selected asset pointer'i degisir
2. shelf route invalidation olur
3. ilgili OG asset yenilenir
4. eski immutable asset silinmez; lifecycle kuralina gore sonra purge edilir

### 19.4. Senaryo: Billing downgrade oldu

Beklenen akış:

1. creator billing ve gated screen cache'leri invalidate edilir
2. public surface derhal bozulmaz; domain policy ne diyorsa o uygulanir
3. stale capability UI'de sessizce kalmaz

---

## 20. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Cache TTL'ini source freshness yerine kullanmak
2. Shared cache'e creator veya ops payload'i koymak
3. Publish/unpublish olayini TTL bitimini bekleyerek guncellemek
4. Selected source state degistigi halde public route invalidate etmemek
5. Hotlink URL'yi kalici media cache'i gibi kullanmak
6. Tumuyle global cache flush yaparak dar invalidation ihtiyacini gecistirmek
7. Search index stale oldugunda broken/unpublished route servis etmek
8. Billing ve entitlement state'ini uzun sure local/private cache'te dogrulamadan tutmak

---

## 21. Bu belge sonraki belgelere ne emreder?

### 21.1. Performance budgets belgesine

- hangi surface'in hangi cache stratejisiyle hedef performansi tuttugu yazilacak

### 21.2. Runbook'lara

- invalidation fail, OG generate fail ve CDN propagation issue runbook'lari buradaki ayrimlarla yazilacak

### 21.3. Release readiness checklist'e

- publish -> invalidate -> public gorunum zinciri uctan uca kanitlanacak

---

## 22. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin su kosullar saglanmis olmalidir:

1. Hangi verinin shared/private/no-store oldugu nettir.
2. Source freshness ile cache staleness ayrimi bozulmadan korunmustur.
3. Public invalidation tetikleyicileri event bazli ve yuzeye gore tanimlanmistir.
4. Media ve OG cache davranisi publication ve appearance olaylariyla hizalanmistir.
5. Yeni bir muhendis veya SRE, "hangi olay hangi cache'i ne zaman temizler?" sorusunu ek aciklama olmadan cevaplayabilir.
