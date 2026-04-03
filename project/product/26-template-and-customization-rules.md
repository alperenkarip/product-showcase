---
id: TEMPLATE-CUSTOMIZATION-RULES-001
title: Template and Customization Rules
doc_type: customization_policy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-VISION-THESIS-001
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - PAGE-TYPES-PUBLICATION-MODEL-001
blocks:
  - DESIGN-DIRECTION-BRAND-TRANSLATION
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - PROJECT-ADR-006
---

# Template and Customization Rules

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde creator'a ne kadar gorsel ve yapisal ozgurluk verilecegini, template sisteminin hangi prensiple calisacagini, hangi ozellestirme alanlarinin acik veya kapali oldugunu ve neden bu urunun no-code website builder'a donusturulmeyecegini tanimlayan resmi customization policy belgesidir.

Bu belge su sorulara cevap verir:

- Template sistemi neden var?
- Hangi alanlar creator tarafından değiştirilebilir?
- Hangi alanlar ürün bütünlüğü için kilitlenir?
- Public kalite ile creator ifade özgürlüğü nasıl dengelenir?
- Plan farkları customization'a nasıl yansır?

---

## 2. Bu belge neden kritiktir?

Bu urun creator-facing oldugu icin "daha fazla özgürlük" talebi dogal olarak artar.

Ama bu urunde kontrolsuz customization tehlikelidir.  
Cunku:

- IA bozulabilir
- trust/disclosure görünmezleşebilir
- public kalite creator emegine bağlı hale gelir
- ürün website builder kategorisine kayabilir

Bu belge, creator'a anlamli ifade alani verirken urunun neden kontrollu preset modeliyle ilerlemesi gerektigini baglar.

---

## 3. Ana karar

Bu belge için ana karar sudur:

> `product-showcase` creator'a kontrollu ama anlamli template varyasyonu sunar; fakat yapisal section hierarchy, context-first organization ve trust-visible information architecture template bahanesiyle bozulamaz.

Bu karar su sonuclari doğurur:

1. Theme özgürlüğü vardır
2. Yapisal builder özgürlüğü yoktur
3. Disclosure/trust alanları kaldırılamaz
4. Storefront, shelf ve content page aynı creator ailesine ait hissedilmelidir

---

## 4. Template sisteminin amaci

Template sistemi su problemlere cevap verir:

1. Creator'in hiç tasarım bilgisi olmadan iyi görünen vitrine sahip olması
2. Public kalitenin creator emeğine tamamen bağlı kalmaması
3. Dikeyler arası tonal fark yaratmak
4. Story-friendly, editorial, compact gibi varyasyonlar sağlamak

Template sistemi su sorunlari çözmek için yoktur:

- tam builder esnekliği vermek
- özel HTML/CSS/JS ekletmek
- bilgi mimarisini creator tercihine göre rastgele bozmak

---

## 5. Template aileleri

İlk fazda template seti sınırlı ama güçlü olmalıdır.

Onerilen ilk aileler:

1. minimal grid
2. editorial list
3. compact / story-friendly
4. visual hero stack
5. dense comparison list

Bu ailelerin amacı:

- farklı creator tonlarına alan açmak
- ama urunu template kaosu içine sokmamak

Kural:

- 20 zayıf template yerine 3-5 güçlü ve iyi düşünülmüş aile tercih edilir

---

## 6. Template sisteminin yapisal sınırları

Template hangi alanları DEĞİŞTİREBİLİR?

- görsel ritim
- kart yoğunluğu
- tipografi tonu
- görsel ağırlık
- featured section stili

Template hangi alanları DEĞİŞTİREMEZ?

- page type hiyerarşisini
- context-first yapıyı
- trust alanlarının varlığını
- zorunlu bilgi bloklarının mevcudiyetini

---

## 7. İzin verilen özelleştirme alanları

### 7.1. Renk sistemi

Creator:

- token bazlı renk ailelerinden seçim yapabilir
- brand translation için kontrollu palette tercih edebilir

Kural:

- kontrast ve readability guardrail'i bozulamaz

### 7.2. Tipografi preset'i

Creator:

- font ailesi preset'i
- tipografik yoğunluk hissi

üzerinde seçim yapabilir.

Kural:

- erişilebilirlik ve readability çizgisi altına inemez

### 7.3. Hero / cover davranışı

Creator:

- kapak / hero görseli seçebilir
- ancak hero, urunleri ekran altına itemez

### 7.4. Card density

Creator:

- compact / regular / spacious benzeri yoğunluk preset'leri seçebilir

Kural:

- disclosure ve merchant alanları görünmezleşemez

### 7.5. Featured seçimleri

Creator:

- hangi shelf / content page / placement öne çıkacak bunu seçebilir

Kural:

- öne çıkan bloklar IA'yı bozacak kadar rastgele çoğaltılamaz

### 7.6. Copy ve bio alanları

Creator:

- kısa positioning
- bio
- intro note

gibi içerikleri düzenleyebilir.

Kural:

- bu alanlar product discovery'yi alt seviyeye itemez

---

## 8. Yasak veya kısıtlı özelleştirme alanları

### 8.1. Yapısal section hierarchy

Creator:

- storefront'un ana yapisal hiyerarsisini tamamen bozamaz

Yasak örnekler:

- featured content'i tümden kaldırmak
- product sections yerine serbest blok yığını kurmak

### 8.2. Trust/disclosure visibility

Creator:

- disclosure, trust row, source merchant veya price freshness alanini gizleyemez

### 8.3. Custom code injection

Creator:

- keyfi HTML / CSS / JS enjekte edemez

Neden:

- kalite ve güvenlik bozulur

### 8.4. SEO / metadata structure

Template:

- canonical davranışı
- OG mantığını
- metadata temel yapısını

bozamaz.

### 8.5. Free-form builder özgürlüğü

Yasak:

- drag-and-drop page builder
- arbitrary block marketplace

Neden:

- ürün category drift yaşar
- support ve QA maliyeti patlar

---

## 9. Page type tutarlılığı

Bir creator'in seçtiği template family:

- storefront
- shelf
- content page
- varsa product light detail

yüzeylerinde aynı creator ailesine ait hissettirmelidir.

Bu ne anlama gelir?

- sayfalar farklı ürünler gibi görünmez
- çok sert estetik kopuş yaşanmaz
- viewer aynı creator universe içinde kaldığını hisseder

---

## 10. Template değişikliği davranışı

### 10.1. Creator template değiştirebilir mi?

Evet.

Ama sonuçları:

- route değişmez
- canonical değişmez
- product data değişmez

### 10.2. Template değişikliği neyi etkiler?

- public görsel ifade
- yoğunluk
- hero hissi
- featured blok sunumu

### 10.3. Template değişikliği neyi etkilemez?

- IA primitive'leri
- page type state'i
- disclosure primitive'i
- source / merchant ilişkisi

---

## 11. Accessibility ve quality guardrail'leri

Template seçiminde sistem şu alanları korumalıdır:

1. contrast
2. text readability
3. tap targets
4. trust badge visibility
5. CTA clarity

Kural:

- creator seçimi bu guardrail'leri aşarsa sistem reddetmeli veya düzeltme önermelidir

---

## 12. Editor ve owner etkisi

### 12.1. Editor

Editor:

- template preview hazırlayabilir
- varyasyon deneyebilir

Ama final owner karari:

- brand preset seçimi
- custom domain ile ilişkili sunum kararları

owner'a aittir.

### 12.2. Owner

Owner:

- final template family seçimi
- büyük görünüm değişikliği
- premium customization entitlement'larını kullanma

yetkisine sahiptir.

---

## 13. Plan etkisi

Customization alanları plan farklarına bağlanabilir.  
Ama şu kural zorunludur:

> Düşük plan, düşük kalite anlamına gelmez.

Bu ne anlama gelir?

- temel iyi görünen preset seti tüm creator'lar için yeterli olmalıdır
- premium plan farkı kalite temellerini değil, çeşit ve esnekliği açabilir

Planla ayrıştırılabilecek alanlar:

- daha fazla preset family
- custom domain branding
- daha fazla hero varyasyonu

Planla ayrıştırılmaması gereken alanlar:

- trust visibility
- public readability
- temel IA bütünlüğü

---

## 14. Edge case ve recovery kurallari

### 14.1. Invalid color selection

Renk seçimi kontrastı bozuyorsa:

- sistem reddeder
- ya da güvenli öneri sunar

### 14.2. Missing hero asset

Hero görseli yoksa:

- template kırık görünmez
- controlled fallback render olur

### 14.3. Template migration

Yeni template family'e geçerken:

- mevcut page içerikleri anlamsal kayıp yaşamamalı
- disclosure/trust bileşenleri taşınmalı

### 14.4. Preview mismatch

Preview ile live render çok farklı olamaz.  
Creator neyi onayladıysa ona yakın sonucu görmelidir.

---

## 15. Anti-pattern listesi

Bu belgeye göre şu yaklaşımlar yanlıştır:

1. ürünü no-code page builder'a çevirmek
2. trust/disclosure alanlarını isteğe bağlı gizlenebilir hale getirmek
3. storefront ile content page'i ayrı marka evrenleri gibi göstermek
4. kaliteli default yerine creator emeğine bağımlı vitrin sunmak

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `50-design-direction-and-brand-translation.md` preset ailelerini bu boundary içinde tanımlamalıdır
2. `52-public-web-screen-spec.md` template varyasyonlarını IA'yı bozmadan ekranlara yansıtmalıdır
3. `PROJECT-ADR-006-template-customization-boundaries.md` boundary kararlarını bu belgeyle hizalı tutmalıdır

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator yeterli ifade alanı bulurken ürün builder'a dönmüyorsa
- trust, disclosure ve IA template bahanesiyle bozulmuyorsa
- düşük plan bile iyi görünen ve güven veren public surface üretiyorsa
- storefront, shelf ve content page aynı creator ailesine ait hissediyorsa

Bu belge basarisiz sayilir, eger:

- customization talepleri urünü serbest layout editörüne sürüklüyorsa
- template farkları content ve trust hiyerarşisini bozuyorsa
- kalite creator emeğine aşırı bağımlı hale geliyorsa

Bu nedenle bu belge, estetik seçenek listesi değil; creator ifade özgürlüğü ile ürün bütünlüğü arasındaki sınır sözleşmesidir.
