---
id: SEO-OG-SHARE-PREVIEW-ARCHITECTURE-001
title: SEO, OG and Share Preview Architecture
doc_type: metadata_architecture
status: ratified
version: 2.1.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PAGE-TYPES-PUBLICATION-MODEL-001
  - ROUTE-SLUG-URL-MODEL-001
  - PUBLIC-WEB-SCREEN-SPEC-001
  - FILE-MEDIA-IMAGE-ASSET-ARCHITECTURE-001
blocks:
  - CACHE-REVALIDATION-STALENESS-RULES
  - WEB-SURFACE-ARCHITECTURE
  - DEEP-LINKING-SHARE-ENTRY-MODEL
---

# SEO, OG and Share Preview Architecture

## 1. Bu belge nedir?

Bu belge, published public surfaces için metadata title/description üretimini, canonical ve noindex kurallarını, OG/share preview mimarisini, page type bazlı preview önceliklerini, structured data üretimini ve publish/unpublish/slug/domain değişikliklerinde metadata cache ile preview asset'lerinin nasıl yönetileceğini tanımlayan resmi metadata architecture belgesidir.

Bu belge su sorulara cevap verir:

- Hangi yüzeyler indexlenebilir?
- Content page neden share tarafında en kritik surface'tir?
- Draft, preview ve unlisted sayfalar canonical public page gibi mi davranır?
- Structured data fiyat/trust gerçeğini nasıl bozmadan üretilir?
- Slug veya custom domain değiştiğinde hangi metadata zinciri yenilenmelidir?

Bu belge, SEO ve share preview'yi sonradan eklenen meta tag notu olmaktan çıkarır.

---

## 2. Bu belge neden kritiktir?

Bu urunde public paylasim davranisi ürün değerinin parçasıdır.  
Yanlış metadata mimarisi su problemlere yol acar:

1. content page sosyal paylaşımda bağlamını kaybeder
2. draft/preview linkler indexlenir
3. stale fiyat structured data'da kesin offer gibi görünür
4. custom domain değişimi sonrası canonical kaosu oluşur

Bu nedenle SEO ve share preview, public architecture'in çekirdek parçasıdır.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Yalnız published public surfaces canonical metadata üretir; storefront, shelf, content page ve varsa light product detail kendi page-type-aware metadata omurgasına sahiptir; draft, preview, unlisted ve internal surfaces asla canonical public content gibi davranmaz; share preview üretimi context-first public experience'i doğru yansıtmak zorundadır.

Bu karar su sonuclari dogurur:

1. Content page share priority surface kabul edilir.
2. Creator workspace ve ops route'lari noindex'tir.
3. Preview URLs canonical yüzey gibi davranmaz.
4. Trust/freshness gerçekleri metadata katmanında bozulmaz.

---

## 4. Metadata surface aileleri

### 4.1. Storefront

Metadata omurgasi:

- creator identity
- kısa positioning
- featured recommendation sinyali

### 4.2. Shelf

Metadata omurgasi:

- shelf title
- context summary
- selected cover/hero

### 4.3. Content page

Metadata omurgasi:

- content reference
- "used in this content" bağlamı
- creator identity

### 4.4. Product light detail

Varsa:

- supporting discovery surface
- limited decision detail

---

## 5. Canonical kuralları

### 5.1. Published public page

Her published page'in:

- tek canonical URL'si vardır
- handle/domain/slugs ile deterministik çözülür

### 5.2. Custom domain

Custom domain aktifse canonical çözüm ona göre hesaplanır.

### 5.3. Draft / preview

Draft ve preview route'ları:

- canonical public equivalent taşımaz
- noindex / private behavior gösterir

### 5.4. Unlisted

Unlisted sayfalar discoverability açısından sınırlı olabilir.  
Ama canonical davranışı page policy'sine göre açıkça belirlenmelidir.

---

## 6. Noindex ve robots davranışı

Noindex olacak aileler:

- creator routes
- ops/admin routes
- preview routes
- draft pages
- gerektiğinde archived pages

### Kural

Noindex davranışı yalnız client-side tag ile bırakılmaz; server-rendered metadata seviyesinde taşınır.

---

## 7. OG/share preview stratejisi

### 7.1. Content page neden öncelikli?

Cunku urunun farklaştırıcı yüzeyi budur.  
Sosyal paylaşımda bağlam + creator + recommendation hissini en iyi content page taşır.

### 7.2. Shelf preview

Shelf preview:

- context cluster hissi vermelidir
- generic storefront kartına dönüşmemelidir

### 7.3. Storefront preview

Storefront preview:

- creator root identity
- featured recommendation hissi

taşır.

### 7.4. Product detail preview

Varsa sınırlı rol taşır; PDP ağırlığına dönmez.

---

## 8. OG image üretim ilkeleri

### 8.1. Kaynaklar

OG image:

- creator cover
- content cover
- selected page context
- generated template

üzerinden üretilebilir.

### 8.2. Kural

OG image:

- stale fiyatı kesin offer gibi göstermez
- disclosure/trust'ı yanıltıcı biçimde gizlemez
- yanlış page type hissi vermez

### 8.3. Regeneration

Asagidaki olaylar OG asset regeneration tetikleyebilir:

- cover değişimi
- title/context değişimi
- slug/domain değişimi
- publish state değişimi

---

## 9. Title ve description üretim kuralları

### 9.1. Storefront

- creator identity first
- kısa positioning second

### 9.2. Shelf

- shelf context first
- creator identity second

### 9.3. Content page

- content context first
- creator identity and recommendation frame second

### 9.4. Kural

Metadata title/description, publicte görünmeyen iddiaları üretmez.

---

## 10. Structured data ilkeleri

### 10.1. Görünürlük uyumu

Structured data, görünür içerikle uyumlu olmalıdır.

### 10.2. Fiyat/trust uyumu

Kural:

- stale fiyat kesin offer gibi yazılmaz
- hidden price structured data'da fiyat varmış gibi taşınmaz

### 10.3. Page-type uygunluğu

Her page type için uygun schema ailesi seçilir; generic tek schema yaklaşımı kullanılmaz.

---

## 11. Invalidation ve revalidation zinciri

Metadata ve preview katmanı şu olaylarla invalid olur:

1. publish
2. unpublish
3. archive
4. slug değişimi
5. custom domain değişimi
6. cover/title/context değişimi
7. OG generation source değişimi

### Kural

HTML cache, OG asset cache ve structured data revalidation aynı job olmayabilir; ama aynı event zinciriyle yönetilir.

---

## 12. Deep link ve share ilişkisi

Canonical public URL share'in tek güvenilir hedefidir.

### 12.1. App-open opsiyonu

App yüklüyse surface-specific açılış olabilir.

### 12.2. Kural

App-open davranışı canonical metadata omurgasını bozmaz.  
Web canonical her zaman güvenilir fallback kalır.

---

## 13. Archived, removed ve degraded state etkileri

### 13.1. Archived page

- active SEO surface gibi kalmaz
- eski OG cache'i temizlenir

### 13.2. Broken merchant / stale source

- page canonical kalabilir
- ama structured data yanlış commerce sinyali üretmez

### 13.3. Removed route

- controlled redirect/state
- metadata güncellenir

---

## 14. Edge-case senaryolari

### 14.1. Handle değişti

Beklenen davranis:

- redirect
- canonical update
- OG regeneration

### 14.2. Preview URL kamuya sızdı

Beklenen davranis:

- public canonical yerine preview state verir
- indexlenmez

### 14.3. Content page archived oldu ama social cache kaldı

Beklenen davranis:

- OG cache invalidation
- metadata refresh

### 14.4. Fiyat stale oldu

Beklenen davranis:

- page canonical kalabilir
- ama structured data offer doğruluğu bozulmaz

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Creator/internal route'lara public metadata mantığı vermek
2. Preview URL'leri canonical content gibi düşünmek
3. Stale/hidden price'ı structured data'da kesin commerce offer'a çevirmek
4. Content page share preview'sini storefront generic preview'sine indirmek
5. Invalidation zincirini slug/domain/cover değişimlerinden koparmak

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `73-cache-revalidation-and-staleness-rules.md`, metadata cache ve OG asset invalidation'ı bu event ailesine göre yazmalıdır.
2. `52-public-web-screen-spec.md`, share-priority content page davranışını bu metadata hiyerarşisiyle uyumlu tasarlamalıdır.
3. `68-deep-linking-and-share-entry-model.md`, share edilen linklerin canonical public URL'den türediğini bu modele göre korumalıdır.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- her public page type doğru metadata ve preview davranışıyla render ediliyorsa
- draft/preview/internal surfaces canonical public yüzeyle karışmıyorsa
- content page sosyal paylaşımda bağlamını kaybetmiyorsa
- slug/domain/state değişimlerinde metadata drift oluşmuyorsa

Bu belge basarisiz sayilir, eger:

- social share preview'ler genericleşirse
- stale/hidden trust gerçekleri metadata katmanında bozulursa
- preview ve canonical davranışı sık sık karışırsa

