---
id: FILE-MEDIA-IMAGE-ASSET-ARCHITECTURE-001
title: File, Media and Image Asset Architecture
doc_type: media_architecture
status: ratified
version: 2.1.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - MEDIA-SELECTION-IMAGE-QUALITY-RULES-001
  - PUBLIC-WEB-SCREEN-SPEC-001
  - DATA-LIFECYCLE-RETENTION-DELETION-RULES-001
blocks:
  - CACHE-REVALIDATION-STALENESS-RULES
  - DATA-BACKUP-RETENTION-RESTORE
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE
---

# File, Media and Image Asset Architecture

## 1. Bu belge nedir?

Bu belge, imported product image'lar, creator uploaded cover'lar, transformed variants ve generated OG/share asset'lerinin hangi storage katmanlarinda tutulacagini, original ile optimized served asset ayrimini, ingestion ve scanning davranisini, CDN ve cache stratejisini, temp extraction adaylarinin lifecycle'ini ve media varliklarinin parent entity state'leriyle nasil senkronize olacagini tanimlayan resmi media architecture belgesidir.

Bu belge su sorulara cevap verir:

- Source image URL neden public asset URL ile ayni sey olamaz?
- Ingestion pipeline hangi kontrolleri yapmak zorundadir?
- Card, detail ve OG surface'leri icin neden farkli asset varyantlari gerekir?
- Temp candidate image'lar neden kalıcı asset gibi tutulmaz?
- Source image silindiginde public deneyim nasil kontrollu kalir?

Bu belge, media'yi sadece file upload konusu degil, trust ve performance konusu olarak ele alir.

---

## 2. Bu belge neden kritiktir?

Bu urunde görsel:

- product identity
- trust
- share preview
- public page performance

alanlarinin hepsini etkiler.

Yanlis media mimarisi su problemlere yol acar:

1. hotlink kirilir ve public kartlar boş kalir
2. source image cok agir oldugu icin performans bozulur
3. secilmeyen image adaylari storage coplugune donusur
4. creator yeni cover yukledigi halde eski varyantlar servis edilmeye devam eder

Bu nedenle media, sonradan eklenen CDN notu değil, ilk sınıf mimari katmandır.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Source image ile uygulamanin publicte servis ettigi asset ayni şey değildir; urun içinde görünen her kalıcı görsel ingest edilir, güvenlik ve kalite kontrolünden geçer, surface'e uygun optimize varyantlara çevrilir ve lifecycle/purge kuralları parent entity state'i ile birlikte yönetilir.

Bu karar su sonuclari dogurur:

1. Hotlink public source-of-truth değildir.
2. Original asset ile served asset ayrıdır.
3. Card/detail/OG ihtiyaçları ayrı varyant stratejisi ister.
4. Temp extraction candidate'lari uzun ömürlü media varlığı sayılmaz.

---

## 4. Asset aileleri

Sistemdeki ana asset aileleri:

1. imported product images
2. creator uploaded covers
3. generated OG/share images
4. transformed delivery variants
5. temporary extraction candidates

### 4.1. Imported product images

Merchant/source tarafından gelen ve product identity için kullanılan varlıklardır.

### 4.2. Creator uploaded covers

Storefront, shelf veya content page context asset'leridir.

### 4.3. Generated OG/share images

Social preview için uygulama tarafından üretilen asset'lerdir.

### 4.4. Delivery variants

Surface'e uygun optimize edilmiş kopyalardır.

### 4.5. Temporary candidates

Import sırasında aday olarak görülen ama seçilmeyen görsellerdir.

---

## 5. Asset yaşam döngüsü

Her asset aynı lifecycle'i izlemez.

### 5.1. Imported product image lifecycle

1. source candidate bulundu
2. ingest edildi
3. validation/scanning yapildi
4. variants üretildi
5. selected as primary or supporting
6. parent entity lifecycle'ine bağlandı

### 5.2. Creator cover lifecycle

1. upload
2. validation
3. original persist
4. variants üretimi
5. prior variant invalidation

### 5.3. Temp candidate lifecycle

1. extraction adayı olarak bulundu
2. kısa süreli saklandı
3. selected değilse purge queue'ya alındı

---

## 6. Original vs served asset ayrımı

### 6.1. Original asset

Amacı:

- arşiv / yeniden türetme
- kalite kontrolü
- future variant generation

### 6.2. Served asset

Amacı:

- public delivery
- performance
- stable URL behavior

### 6.3. Neden ayrım şart?

Original:

- çok büyük olabilir
- uygun crop/oran taşımayabilir
- güvenlik taraması sonrasındaki normalized çıktıyla aynı olmayabilir

Served asset:

- optimize
- CDN-friendly
- surface-specific

olmalıdır.

---

## 7. Ingestion pipeline

### 7.1. Giriş

Asset ingestion şu kaynaklardan gelebilir:

- external image URL
- creator upload
- internal generation job

### 7.2. Validation adımları

1. content-type doğrulama
2. file size sınırı
3. decode edilebilirlik
4. malware / zararlı payload taraması
5. dimension metadata çıkarımı

### 7.3. Rejection durumları

- bozuk dosya
- unsupported format
- güvenlik riski
- limit aşımı

### 7.4. Kural

Validation fail eden asset public candidate havuzuna girmez.

---

## 8. Variant üretim stratejisi

Surface bazlı asgari variant aileleri:

- `card`
- `detail`
- `hero/cover`
- `og/share`

### 8.1. Card variant

Amaç:

- hızlı liste görüntüleme
- düşük bandwidth

### 8.2. Detail variant

Amaç:

- product light detail
- daha yüksek netlik

### 8.3. Hero/cover variant

Amaç:

- storefront/shelf/content page context blokları

### 8.4. OG/share variant

Amaç:

- sosyal preview
- kontrollü aspect ratio

---

## 9. URL ve delivery modeli

### 9.1. Public URL

Served asset URL'leri:

- deterministic olmalı
- cacheable olmalı
- source merchant URL'lerine bağımlı olmamalı

### 9.2. Internal/private URL

Temp candidate veya restricted asset'ler public URL gibi açık servis edilmez.

### 9.3. Signed access gereksinimi

Preview veya özel inspection asset'leri gerekiyorsa signed access modeli düşünülebilir.

---

## 10. CDN ve cache stratejisi

### 10.1. CDN first delivery

Public asset delivery CDN üzerinden cache-friendly olmalıdır.

### 10.2. Variant invalidation

Asagidaki olaylarda ilgili variant ailesi invalidate edilir:

- creator yeni cover upload etti
- primary image değişti
- page archived oldu ve OG asset değişti

### 10.3. Cache ayrımı

Image variant cache ile page HTML/metadata cache aynı şey değildir.

---

## 11. Parent entity ile ilişki

Media asset'ler bağımsız dosya değil, parent entity bağlamı taşır.

### 11.1. Product images

`Product` ve `Product Source` ile ilişkilidir.

### 11.2. Covers

`Storefront`, `Shelf`, `Content Page` ile ilişkilidir.

### 11.3. OG assets

Page lifecycle ve metadata invalidation ile ilişkilidir.

### 11.4. Kural

Parent archived/soft-deleted olunca asset lifecycle buna göre etkilenir.

---

## 12. Temp candidate yönetimi

Import sırasında bulunan image candidate'lar:

- quality review için kısa süre tutulabilir
- selected olmazsa kalıcı catalog asset sayılmaz

### 12.1. Neden?

Candidate'ların çoğu:

- yanlış image
- düşük kalite
- duplicate

olabilir. Bunları kalıcılaştırmak storage ve privacy riskidir.

### 12.2. Retention ilkesi

Temp candidate'lar kısa ömürlü retention sınıfına girer.

---

## 13. Source image silinmesi ve fallback

Source merchant image sonradan kalkabilir.

Beklenen davranış:

1. served asset hemen kırılmaz
2. refresh/revalidation pipeline asset state'i gözden geçirir
3. gerekiyorsa fallback/no-image state'ine kontrollü geçilir

### Kural

Broken source image, public sayfada sessiz 404 img elementi olarak bırakılmaz.

---

## 14. Güvenlik ve abuse notları

### 14.1. Zararlı dosya riski

Upload veya fetch edilen görseller güvenlik taramasından geçmelidir.

### 14.2. Content spoofing riski

Image metadata veya URL trusted source sayılmaz; gerçek decode ve validation gerekir.

### 14.3. Hotlink abuse riski

Public delivery dış kaynağa bağımlı bırakılmaz.

---

## 15. Cost-awareness

Media maliyetleri:

- storage
- transform compute
- egress/CDN

taşır.

Kural:

1. her image için sınırsız varyant üretilmez
2. kullanılmayan candidate'lar tutulmaz
3. OG generation gereksiz tekrar çalıştırılmaz

---

## 16. Edge-case senaryolari

### 16.1. Aynı image farklı product'larda kullanılıyor

Beklenen davranis:

- binary dedupe mümkün olabilir
- ama parent ilişkileri korunur

### 16.2. Creator eski cover'a geri döndü

Beklenen davranis:

- mevcut original tekrar kullanılabilir
- yeni variants deterministik üretilebilir

### 16.3. OG generation gecikti

Beklenen davranis:

- son geçerli OG asset bir süre servis edilebilir
- ama metadata drift gözlenir

### 16.4. Image validation geçti ama crop uygun değil

Beklenen davranis:

- source original kalabilir
- card/detail variant üretiminde safe fallback/crop uygulanır

---

## 17. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. hotlink'e bağımlı public image servisi
2. original ile served asset'i aynı şey saymak
3. temp extraction adaylarını kalıcı asset gibi saklamak
4. page cache invalidation ile image variant invalidation'ı karıştırmak
5. güvenlik taramasız upload/fetch kabul etmek

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `73-cache-revalidation-and-staleness-rules.md`, asset cache invalidation'ı page ve trust cache'inden ayrı tanımlamalıdır.
2. `104-data-backup-retention-and-restore.md`, original, served ve temp candidate retention farklarını bu belgeye göre ayırmalıdır.
3. `67-seo-og-and-share-preview-architecture.md`, OG asset generation'i bu media pipeline ile uyumlu kurmalıdır.

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- public görseller source hotlink'e bağlı kalmadan güvenli servis ediliyorsa
- quality ve performance birlikte korunuyorsa
- asset lifecycle parent entity state'leriyle tutarlıysa
- temp candidate ve kalıcı asset ayrımı operasyonel olarak uygulanabiliyorsa

Bu belge basarisiz sayilir, eger:

- broken source image public deneyimi kolayca kırıyorsa
- asset storage kontrolsüz büyüyorsa
- invalidation ve lifecycle sınırları bulanık kalıyorsa

