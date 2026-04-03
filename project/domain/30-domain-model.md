---
id: DOMAIN-MODEL-001
title: Domain Model
doc_type: domain_architecture
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - DOMAIN-GLOSSARY-001
  - PAGE-TYPES-PUBLICATION-MODEL-001
blocks:
  - DATABASE-SCHEMA-SPEC
  - API-CONTRACTS
  - PRODUCT-LIBRARY-REUSE-MODEL
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL
  - DATA-LIFECYCLE-RETENTION-DELETION-RULES
---

# Domain Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun ana domain varliklarini, bu varliklar arasindaki iliskileri, hangi entity'lerin source of truth oldugunu, hangi invariant'larin asla bozulamayacagini ve ürün davranışının hangi domain primitive'leri uzerine inşa edileceğini tanımlayan resmi domain architecture belgesidir.

Bu belge su sorulara cevap verir:

- Ürünün ana entity kümeleri nelerdir?
- Product, source ve placement neden ayrıdır?
- Storefront, shelf ve content page iliskisi nasil kurulur?
- Import job hangi entity'leri olusturur veya etkiler?
- Ownership ve audit hangi entity'lerde kritik hale gelir?

Bu belge, tablo listesi degildir.  
Bu belge, ürünün gerçek iş mantığını taşıyan alan modelidir.

---

## 2. Bu belge neden kritiktir?

Bu urunde en tehlikeli modelleme hatalari şunlardır:

- product'i URL ile ayni sey sanmak
- page icinde görünen kartı product'in kendisi sanmak
- storefront'u profile section ile karistirmak
- merchant capability bilgisini hardcoded davranisa gömmek

Bu hatalar UI'da küçük görünür; ama sonuçta:

- duplicate ürünler artar
- reuse modeli bozulur
- stale data yönetimi zayıflar
- support issue tipleri karışır

Bu nedenle domain model, estetik karar degil; ürünün doğruluk ve sürdürülebilirlik zemini sayılır.

---

## 3. Ana domain kararı

Bu belge için ana karar sudur:

> Product, Product Source ve Product Placement üç ayrı primitive'tir; Creator, Storefront, Shelf ve Content Page ise recommendation universe'ün yapisal primitive'leridir; URL import bu primitive'leri etkilemek için Import Job üzerinden çalışan ayri bir operasyon domain'idir.

Bu karar su sonuclari doğurur:

1. product URL ile aynı şey değildir
2. page üzerindeki görünüm placement primitive'i ile modellenir
3. source freshness product'in kimliğiyle karışmaz
4. import job domain'i UI state değil, iş kaydıdır

---

## 4. Ana entity kümeleri

Bu urunun ana entity kümeleri sekiz gruba ayrılır:

1. Identity and account
2. Creator presence
3. Public publication surfaces
4. Product and source graph
5. Trust and disclosure
6. Import and operations
7. Billing and entitlement
8. Governance and audit

---

## 5. Identity and account entity'leri

### 5.1. User

Teknik auth ve account primitive'i.

Rolü:

- authentication
- session ilişkisi
- account-level settings

Kural:

- `User`, urun actor'u olarak her zaman `Creator` ile aynı anlamda kullanılmaz

### 5.2. User Settings

Teknik user preference ve account-level ürün ayarları.

Örnek:

- locale
- timezone
- notification preferences

---

## 6. Creator presence entity'leri

### 6.1. Creator Profile

Creator'ın kimlik katmanı.

Alan örnekleri:

- display name
- handle
- avatar
- bio / positioning

Rolü:

- creator identity primitive'i

### 6.2. Storefront

Creator'in public root surface primitive'i.

Rolü:

- public recommendation root
- featured content selection
- appearance binding

Kural:

- bir creator profile'ın etkin bir storefront primitive'i vardır

### 6.3. Storefront Appearance / Template Binding

Storefront'un hangi template family ve appearance config ile render edileceğini tasiyan alan veya alt entity.

Kural:

- appearance, storefront'un kimligini degistirmez

---

## 7. Public publication surface entity'leri

### 7.1. Shelf

Kalici veya yarı-kalici context organizer primitive'i.

Rolü:

- recurring recommendation cluster

### 7.2. Content Page

Belirli bir icerik baglamina ait page primitive'i.

Rolü:

- differentiator surface

### 7.3. Product Placement

Bir product'in belirli bir shelf veya content page icindeki görünümü.

Rolü:

- page-specific title / note / order / featured state

Kural:

- product placement ya shelf'e ya content page'e aittir
- ikisine birden bagli tek placement olamaz

### 7.4. Optional Product Detail View Model

Eğer tutulursa, product veya placement'in detail presentation primitive'i olabilir.

Ama:

- ayrı product catalog entity'si yaratmak için kullanılmaz

---

## 8. Product and source graph entity'leri

### 8.1. Product

Creator library içindeki tekrar kullanılabilir urun primitive'i.

Product'in görevi:

- urun identity'sini taşımak
- source'lar ve placement'lar için parent olmak

Product ne değildir:

- merchant URL
- page içindeki kart

### 8.2. Product Source

Bir product ile iliskili external merchant/source kaydı.

Rolü:

- canonical URL
- extraction sonucu
- merchant bilgisi
- freshness / availability

### 8.3. Price Snapshot / Availability Snapshot

Eğer ayrı tutulursa:

- zaman bağlı source truth change'lerini izler

Kural:

- source current state ile snapshot history karıştırılmamalıdır

### 8.4. Merchant Capability

Domain veya merchant seviyesi destek bilgisi primitive'i.

Rolü:

- full / partial / fallback-only / blocked
- known limitations

Kural:

- hardcoded UI metni yerine domain primitive'i olarak tutulmalıdır

---

## 9. Trust and disclosure entity'leri

### 9.1. Disclosure Record

Disclosure primitive'i.

Rolü:

- affiliate
- sponsored
- gifted
- brand_provided
- self_purchased
- unknown_relationship

gibi sinyalleri taşır.

### 9.2. Trust Metadata

Ürün veya placement etrafinda:

- trust note
- source certainty
- price freshness

gibi sinyallerin bir araya geldigi alan veya ilişkili primitive.

Kural:

- note ile disclosure aynı veri primitive'i gibi ele alınmaz

---

## 10. Import and operations entity'leri

### 10.1. Import Job

Tek bir import denemesinin iş kaydı.

Rolü:

- submitted URL
- normalized URL
- extractor path
- confidence
- failure reason
- actor

### 10.2. Import Attempt / Job Events

Gerekirse:

- retry
- status transitions
- classified failures

için ayrıntılı alt model tutulabilir.

### 10.3. Safety / Block Records

Unsafe domain, blocked redirect veya policy action için auditli kayıtlar.

---

## 11. Billing and entitlement entity'leri

### 11.1. Subscription Record

Creator owner'ın aktif plan durumunu taşır.

### 11.2. Entitlement Snapshot

Aktif capability limitleri veya current entitlement yüzeyi.

Kural:

- product quality floor entitlement ile kırpılamaz; ama capacity limitleri burada yaşar

---

## 12. Governance and audit entity'leri

### 12.1. Audit Log

Kritik aksiyonlar:

- publish
- unpublish
- archive
- ownership changes
- billing changes
- support actions

için audit izini taşır.

### 12.2. Support Action / Ops Action Trail

Support veya ops tarafinin yaptığı scoped müdahaleleri kaydeder.

Kural:

- internal roles gizli ve izsiz içerik değiştiremez

---

## 13. Ana ilişkiler

### 13.1. Identity ilişkileri

- Bir `User` bir `Creator Profile` ile ilişkilenebilir
- Bir `Creator Profile` bir ana `Storefront` taşır

### 13.2. Publication ilişkileri

- Bir `Storefront` birden fazla `Shelf` barındırabilir
- Bir `Storefront` birden fazla `Content Page` barındırabilir

### 13.3. Product graph ilişkileri

- Bir `Product` bir creator owner'a bağlıdır
- Bir `Product` birden fazla `Product Source` taşıyabilir
- Bir `Product` birden fazla `Product Placement` taşıyabilir

### 13.4. Placement parent ilişkisi

- Bir `Product Placement` ya `Shelf` ya da `Content Page` altında yaşar
- Aynı placement iki parent altında birden yaşayamaz

### 13.5. Import ilişkileri

- Bir `Import Job` yeni bir `Product Source` yaratabilir
- Varsa mevcut `Product` ile ilişki kurabilir
- Yeni veya mevcut `Product Placement` oluşturmayı tetikleyebilir

---

## 14. Source of truth kurallari

### 14.1. Product source of truth

Product:

- creator library identity'sinin source of truth'udur

### 14.2. Source source of truth

Product Source:

- external merchant ilişkisi ve freshness bilgisinin source of truth'udur

### 14.3. Placement source of truth

Placement:

- context-specific presentation'ın source of truth'udur

### 14.4. Page visibility source of truth

Page ve placement publication state birlikteliği:

- public görünürlüğün source of truth'udur

---

## 15. Invariant listesi

Bu urunde asla bozulmaması gereken domain invariant'ları sunlardır:

1. Product ile placement aynı şey değildir
2. Product source canonical URL olmadan active source sayılmaz
3. Published placement, parent page published değilse publicte görünmez
4. Disclosure primitive'i "yok sayıldı" seviyesinde kalamaz; açık bir state taşımalıdır
5. Merchant capability primitive'i olmadan unsupported/blocked davranışı sadece UI kopyasına bırakılamaz
6. Owner olmayan actor product ownership devralamaz

---

## 16. State aileleri

### 16.1. Product state ailesi

Olası ana state'ler:

- active
- archived
- pending_delete

### 16.2. Product Source state ailesi

Olası ana state'ler:

- pending_verification
- verified
- stale
- broken
- blocked

### 16.3. Import Job state ailesi

Olası ana state'ler:

- queued
- processing
- needs_review
- completed
- failed
- blocked

### 16.4. Page state ailesi

Page state'leri ayri belgede tanımlanır; ama domain tarafında:

- draft
- published
- unlisted
- archived

semantic primitive olarak korunur.

---

## 17. Ownership ve audit kurallari

### 17.1. Ownership

Her kritik entity için owner ilişkisi veya owner'a geri iz düşümü olmalıdır.

Asgari owner trace gerekli entity'ler:

- storefront
- shelf
- content page
- product
- subscription

### 17.2. Audit

Audit izi zorunlu entity olayları:

- publish / unpublish
- archive / restore
- ownership changes
- billing changes
- support intervention

---

## 18. Anti-pattern listesi

Bu belgeye göre su yaklasimlar domain ihlalidir:

1. Product'i merchant URL ile ayni primitive gibi modellemek
2. Product card'i product entity sanmak
3. Merchant support bilgisini hardcoded switch-case mantigina gömmek
4. Disclosure'u serbest text alanina indirmek
5. Import job'i sadece frontend spinner state'i gibi ele almak

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `71-database-schema-spec.md` entity ayrimlarini tablo seviyesinde korumalıdır
2. `70-api-contracts.md` product/source/placement ayrımını API shape'inde taşımalıdır
3. `31-product-library-and-reuse-model.md` duplicate ve merge davranışını bu entity modeline göre yazmalıdır
4. `34-roles-permissions-and-ownership-model.md` owner trace mantığını permission modeline dönüştürmelidir
5. `35-data-lifecycle-retention-and-deletion-rules.md` entity bazlı lifecycle kurallarını bu primitive'lere göre tanımlamalıdır

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- product, source, placement ve page primitive'leri ekip içinde karışmıyorsa
- import, trust ve publication davranışları aynı domain omurgasında buluşuyorsa
- duplicate, stale ve support issue'ları bu model üzerinde çözülebiliyorsa

Bu belge basarisiz sayilir, eger:

- UI primitive'leri ile domain primitive'leri karışırsa
- external URL ve internal product identity aynı şey gibi davranırsa
- ownership ve audit izleri modelde açık yer bulamazsa

Bu nedenle bu belge, urunun teknik değil iş mantığı omurgasını tanımlar.
