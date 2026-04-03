---
id: SEARCH-FILTER-TAGGING-RULES-001
title: Search, Filter and Tagging Rules
doc_type: discovery_policy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - DOMAIN-GLOSSARY-001
blocks:
  - TAG-TAXONOMY-CLASSIFICATION-MODEL
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
---

# Search, Filter and Tagging Rules

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde arama, filtreleme, faceting ve tagging davranisinin hangi amaçla var oldugunu, hangi yüzeylerde nasıl calisacagini, category-first mimariye kaymadan discoverability saglamak icin hangi kurallarin zorunlu oldugunu tanimlayan resmi discoverability policy belgesidir.

Bu belge su sorulara cevap verir:

- Search neyi çözmek içindir?
- Public search ile creator-side search neden farklidir?
- Tags hangi kaynaklardan gelir?
- Hangi tag conflict'lerinde kimin sözü son olur?
- Filter hangi yüzeyde ne kadar görünmelidir?
- Ranking hangi sinyallerle çalışır?

---

## 2. Bu belge neden kritiktir?

Bu urunde category ana omurga degildir.  
Bu yüzden search ve tags doğal olarak daha önemli görünür.

Ama burada tehlike sudur:

> Discoverability katmani, IA'nin yerine gecmeye calisabilir.

Bu olursa:

- shelf ve content page önemi zayiflar
- public root generic shopping browse'a döner
- creator-centered model bozulur

Bu belge, discoverability'nin ne kadar ileri gidecegini ve nerede duracagini baglar.

---

## 3. Ana karar

Bu belge için ana karar sudur:

> Search, filter ve tags bu urunde yardımcı bulma katmanidir; creator-context-first bilgi mimarisinin yerine gecemez.

Bu karar su sonuclari doğurur:

1. Search primary navigation olmaz
2. Category tree gizli omurga gibi kurulamaz
3. Tags semantic support'tur, structural primitive degildir
4. Public arama creator universe içinde kalır

---

## 4. Search davranisinin amacı

Search bu urunde iki ayri problem çözer:

### 4.1. Creator-side findability

Creator:

- büyük library'de product bulmak ister
- source, merchant veya custom title üzerinden arama yapmak ister

### 4.2. Viewer-side findability

Viewer:

- storefront veya shelf içinde belirli urunu bulmak ister
- content page içinde taramayi kolaylaştırmak ister

Bu iki ihtiyaç ayni değildir.  
Bu nedenle search davranisi actor bazli ayrışır.

---

## 5. Public search modeli

### 5.1. Scope sınırı

Public search varsayilan olarak creator universe içinde kalir.

Anlamı:

- belirli creator'in storefront'u içinde search
- belirli shelf veya content page içinde search

Yapılmayan:

- tüm creator'lar arası marketplace search

### 5.2. Public search ne için uygundur?

Uygun kullanım:

- büyük shelf'te ürün bulma
- belirli creator'in library yüzeyinde yardımcı arama
- benzer adli urunleri ayırma

### 5.3. Public search neyi bozmaz?

Kural:

- search, content ve shelf girişlerinin yerine geçmez
- entry point hala context sayfalaridir

---

## 6. Creator-side search modeli

### 6.1. Creator aramasi neden daha güçlüdür?

Cunku creator operasyonel nesne yönetir.

Creator-side aramada aranabilir alanlar:

- canonical title
- custom title
- merchant
- tag'ler
- URL parçaları
- source geçmişi

### 6.2. Creator-side arama neyi desteklemelidir?

1. reuse için doğru product'i hızlı bulmak
2. duplicate confusion'ı azaltmak
3. archived product'lari ayırmak
4. source sorunlarını incelemek

---

## 7. Filter modeli

### 7.1. Filter'in rolü

Filter:

- listeyi yönetilebilir kılar
- IA omurgasının yerine geçmez

### 7.2. Public filter türleri

Public tarafta kabul edilebilir filter aileleri:

- context/use-case tag
- product type tag
- merchant
- disclosure type
- availability / price visibility state

### 7.3. Creator filter türleri

Creator tarafında daha derin filter mantığı kabul edilebilir:

- merchant
- verification state
- archive state
- disclosure state
- source health

### 7.4. Filter yoğunluğu kuralı

Kural:

- public sayfa enterprise dashboard gibi görünemez
- onlarca facet ile yüzey kirletilemez

---

## 8. Tagging modeli

### 8.1. Tag nedir?

Tag:

- semantic yardımcı sinyal
- context, product type veya use-case descriptor

dir.

Tag ne değildir:

- ana navigation primitive
- category ağacı yerine geçen gizli iskelet

### 8.2. Tag kaynakları

Tag'ler üç kaynaktan gelebilir:

1. creator manual input
2. deterministic extraction / classification
3. AI-assisted normalization

### 8.3. Otorite sırası

Tag conflict durumunda otorite sırası:

1. creator manual override
2. deterministic extraction
3. AI-assisted guess

Kural:

- AI veya extraction creator override'ını sessizce ezemez

---

## 9. Tag rolleri

Bu urunde tag'ler dört ana rol taşıyabilir:

### 9.1. Product-type tags

Ornek:

- supplement
- tripod
- skincare

### 9.2. Use-case tags

Ornek:

- travel
- recovery
- daily-use

### 9.3. Context tags

Ornek:

- video-used
- gym-routine
- desk-setup

### 9.4. Trust / disclosure related tags

Ornek:

- affiliate
- gifted

Not:

Disclosure ile tag aynı şey değildir.  
Ama discoverability amacıyla disclosure state'i filter/tag-like sinyal olarak expose edilebilir.

---

## 10. Ranking kurallari

### 10.1. Public ranking sinyalleri

Public aramada sıra şu sinyallerle etkilenebilir:

1. exact / strong title match
2. current page context ile uyum
3. featured placement state
4. active / non-archived status
5. creator note eşleşmesi

### 10.2. Creator ranking sinyalleri

Creator-side aramada önem kazanabilecek sinyaller:

1. exact title match
2. merchant match
3. source URL match
4. recent usage
5. verification state

### 10.3. Yasak ranking sinyalleri

Kural:

- sponsorlu veya plan durumu ranking'i gizlice manipule etmek için kullanılamaz
- monetization signal public aramada gizli üstünlük sağlamaz

---

## 11. Conflict ve ambiguity kurallari

### 11.1. Untagged product

Tag yoksa:

- product aramadan dışlanmaz
- title, merchant ve note üzerinden bulunabilir

### 11.2. Conflicting tags

Conflicting tag seti varsa:

- creator kararı son sözdür
- UI gerektiğinde warning verebilir

### 11.3. Similar products

Birçok benzer product varsa:

- merchant
- image
- note
- source health

ayrıştırıcı sinyal olarak görünmelidir.

---

## 12. Filter/search'in page tiplerine göre davranisi

### 12.1. Storefront

Search ve filter:

- yardımcı rol oynar
- featured context'lerin önüne geçmez

### 12.2. Shelf

Filter daha görünür olabilir; çünkü benzer set içindeki taramayi kolaylaştırır.

### 12.3. Content page

Genelde arama ikinci plandadir; çünkü page zaten belirli context için açılmıştır.

### 12.4. Creator library

Search/filter burada birincil operasyon aracı olabilir.

---

## 13. Anti-pattern listesi

Bu belgeye göre su yaklasimlar yanlistir:

1. Tag'leri gizli category tree'ye dönüştürmek
2. Publicte onlarca facet göstermek
3. Search'i marketplace engine gibi konumlamak
4. Creator override'ını sessizce ezmek
5. Discovery layer'i context pages yerine ana giriş yapmak

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `33-tag-taxonomy-and-classification-model.md` tag ailelerini bu rol tanımlarına göre modellemelidir
2. `52-public-web-screen-spec.md` filter yoğunluğunu public sadeliği bozmayacak şekilde tasarlamalıdır
3. `54-creator-web-screen-spec.md` creator library search/filter'ını derin operasyon aracı olarak ele almalıdır

---

## 15. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- discoverability varken bile IA omurgasi context-first kalıyorsa
- creator library search'i duplicate ve reuse sorununu azaltıyorsa
- public filter/search sayfayı dashboard'a çevirmiyorsa
- creator override tüm tagging katmanlarında korunuyorsa

Bu belge basarisiz sayilir, eger:

- tags ve categories sessizce omurgaya donusurse
- public arama generic shopping browse hissi yaratırsa
- ranking monetization veya sponsorluk lehine gizlice bükülürse

Bu nedenle bu belge, bulmayi kolaylaştıran ama urunun çekirdek yapisini bozmayan discoverability sınırlarını tanımlar.
