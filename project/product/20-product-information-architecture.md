---
id: PRODUCT-INFORMATION-ARCHITECTURE-001
title: Product Information Architecture
doc_type: product_structure
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-VISION-THESIS-001
  - DOMAIN-GLOSSARY-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
blocks:
  - PAGE-TYPES-PUBLICATION-MODEL
  - ROUTE-SLUG-URL-MODEL
  - VIEWER-EXPERIENCE-SPEC
  - SEARCH-FILTER-TAGGING-RULES
  - DOMAIN-MODEL
  - PUBLIC-WEB-SCREEN-SPEC
---

# Product Information Architecture

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun bilgi mimarisini, ust seviye nesne hiyerarsisini, public ve creator yuzeyleri arasindaki anlamsal farki, category yerine context-first organization mantigini ve discoverability katmaninin hangi sinirlar icinde calisacagini tanimlayan resmi IA belgesidir.

Bu belge su sorulara cevap verir:

- Urunun omurgasi hangi nesnelerden olusur?
- Creator tarafi ile public tarafi neden ayni menü modeline sahip olmak zorunda degildir?
- Storefront, shelf, content page, product ve placement nasil iliskilenir?
- Category neden yardimci katmandir?
- Search, filter ve tags neden omurganin yerine gecemez?

Bu belge navigation listesi degildir.  
Bu belge, urunun ne olarak algilanacagini belirleyen yapisal otoritedir.

---

## 2. Bu belge neden kritiktir?

Bu urunde IA yanlis kurulursa urun hızlıca yanlis kategoriye kayar.

Ornek kaymalar:

- urun generic shopping katalogu gibi algilanir
- creator bio / vanity page urunleri ezer
- content-linked page arka plana itilir
- product ile placement birbirine karisir
- tags ve categories omurga gibi davranmaya baslar

Bu nedenle IA karari yalniz tasarim karari degildir.  
Su alanlari dogrudan etkiler:

1. route modeli
2. domain modeli
3. template yapisi
4. public sayfa hierarchy
5. search/filter davranisi
6. SEO / OG metadata stratejisi

Bu belge, urunun hangi nesneler etrafinda dusunulecegini sabitler.

---

## 3. IA'nin ana tezi

Bu urunde bilgi mimarisinin ust omurgasi su zincirdir:

> Creator -> Storefront -> Shelf / Content Page -> Product Placement -> Merchant Exit

Bu zincirin anlami:

- **Creator** guven ve sahiplik kaynagidir
- **Storefront** tek-link giris yuzeyidir
- **Shelf** nispeten kalici context organizer'dir
- **Content Page** belirli bir icerik etrafinda kurulan context surface'tir
- **Product Placement** urunun context icindeki gorunumudur
- **Merchant Exit** viewer'in son cikis aksiyonudur

Bu omurgada `category` yoktur.  
Category, tag ve filter yardimci semantic layer olarak vardir; ama omurga degildir.

---

## 4. IA'nin birinci seviye ilkeleri

### 4.1. Context-first, category-second

Viewer cogu durumda sunu arar:

- bu videoda ne kullanildi
- gunluk stack ne
- gym bag'de ne var
- bu routine icin hangi urunler oneriliyor

Viewer genelde sunu aramaz:

- tum fitness kategorisi
- tum supplement kategorisi
- tum tech urunleri

Bu nedenle context birinci sinif primitive'tir.

### 4.2. Creator-centered, not marketplace-centered

Public giris generic shopping browse degil, creator recommendation universe'tur.

Bu nedenle:

- global marketplace home kurulmaz
- creator kimligi her zaman anlamli context kapisi olarak kalir

### 4.3. Reuse-driven organization

Product library ve placement modeli IA'nin gorunmeyen ama temel omurgasidir.

Bu nedenle:

- her page kendi product kopyasini üretmez
- ayni product farkli page'lerde yaşar
- page ve product arasina placement katmani girer

### 4.4. Trust-visible organization

Disclosure, merchant kaynagi, stale/missing price bilgisi ve context note urun sunumunun ayrilmaz parçalari olarak tasinir.

### 4.5. Public and creator IA can differ by design

Creator tarafi operasyon merkezlidir.  
Viewer tarafi karar merkezlidir.

Bu nedenle iki yuzeyin ayni navigation yapisini tasimasi zorunlu değildir.

---

## 5. Ust seviye varlik haritasi

### 5.1. Creator

Creator, public recommendation universe'un sahibi olan aktordur.

IA rolü:

- root identity
- trust source
- recommendation context owner

Creator katmaninda gorunen alanlar:

- display name
- handle
- avatar / visual identity
- kısa positioning
- genel disclosure / trust summary

Creator katmaninda gereksiz buyutulmamasi gereken alanlar:

- uzun biyografi
- alakasiz link yiginlari
- urunleri ikinci plana iten hero bloklari

### 5.2. Storefront

Storefront, creator'in public ana vitrini ve tek-link landing'idir.

IA rolü:

- creator'i tanitmak
- featured context'lere gecis vermek
- public recommendation evreninin ana giris haritasini sunmak

Storefront ne degildir:

- global category landing page
- full shopping catalog
- long-form profile microsite

### 5.3. Shelf

Shelf, baglama dayali ama nispeten kalici urun gruplamasidir.

Tipik shelf mantiklari:

- daily stack
- shooting setup
- gym bag
- budget picks
- recovery routine

Shelf'in IA rolü:

- tekrar ziyaret edilen context'leri sabitlemek
- urunleri set mantiginda organize etmek
- creator'in recurring recommendation cluster'larini tasimak

### 5.4. Content Page

Content Page, belirli bir icerik etrafinda kurulan public sayfadir.

Tipik content page mantiklari:

- this video'da kullandiklarim
- bu post'ta gecen urunler
- bu reels setup'i
- bu bolumde bahsettiklerim

Content Page'in IA rolü:

- creator icerigi ile urunleri ayni anlamsal cümleye oturtmak
- urunun farklastirici deneyimini sunmak

### 5.5. Product Library

Product Library creator tarafinda merkezi operasyon katmanidir.

IA rolü:

- tekrarli veri girisini azaltmak
- source ve verification bilgisini merkezde tutmak
- placement'larin ust varligini olusturmak

Public tarafta Product Library ayni sekilde expose edilmek zorunda degildir.

### 5.6. Product Placement

Placement, product'in belirli bir shelf veya content page icindeki context-bound gorunumudur.

Placement seviyesinde degisebilen şeyler:

- custom title
- custom note
- display order
- featured flag
- page-specific context

Product seviyesinde kalan şeyler:

- genel identity
- source baglantilari
- extraction trail

Bu ayrim bozulursa reuse modeli kirilir.

---

## 6. Public IA modeli

### 6.1. Public entry point tipleri

Viewer public experience'e uc tip entry ile gelir:

1. Storefront root
2. Shelf page
3. Content page

Product detail page varsayilan ana entry degildir; ikincil destek yuzeyidir.

### 6.2. Storefront'ta bilgi hiyerarsisi

Storefront'ta ana oncelik sırası sunlardir:

1. Creator kimligi ve kısa positioning
2. Featured shelves
3. Featured content pages
4. Gerekirse featured placements
5. Yardimci discoverability elemanlari

Storefront'ta yapilmamasi gerekenler:

- devasa creator hero area
- category grid ile ilk ekranı doldurmak
- urunleri alta iten uzun "hakkimda" bloklari

### 6.3. Shelf page'te bilgi hiyerarsisi

Shelf page'te ana sıra:

1. shelf title
2. context description
3. product placements
4. gerekiyorsa hafif filter / tag layer
5. related shelves / content pages

### 6.4. Content page'te bilgi hiyerarsisi

Content page'te ana sıra:

1. content context
2. bu icerikte gecen product placements
3. creator note
4. related shelf / related context

Viewer, content page'e girdiginde "bu sayfa neyin sayfasi?" sorusuna ilk ekranda cevap bulmalidir.

### 6.5. Public detail mantigi

Product detail veya light detail surface varsa:

- standalone catalog page gibi davranmamalidir
- creator context'inden kopmamalidir
- "bu creator bu urunu hangi baglamlarda kullaniyor?" hissi korunmalidir

---

## 7. Creator IA modeli

### 7.1. Creator-side ana bolumler

Creator tarafinda ana IA bolumleri sunlardir:

1. dashboard / recent activity
2. product library
3. shelves
4. content pages
5. storefront / template settings
6. import history
7. billing / domain / ownership settings

### 7.2. Creator neden library-first görür?

Cunku creator için asıl tekrarli davranis product yönetimidir.

Creator su işler etrafinda hareket eder:

- import
- verify
- reuse
- place
- publish

Bu isler library merkezlidir.  
Bu nedenle creator tarafinda library birincil primitive gibi gorunur.

### 7.3. Creator-side IA neden public IA ile ayni degildir?

Public tarafta viewer context arar.  
Creator tarafta operator nesne yönetir.

Bu fark su sonuclari dogurur:

- publicte library ana navigation olmayabilir
- creator panelinde ise library ana navigation olabilir

### 7.4. Mobile vs web creator IA farki

Mobile:

- hizli capture
- hizli verify
- son kullanilan page / shelf
- mini edit / publish

Web:

- deep curation
- bulk operations
- library search/filter depth
- import trail inspection

Bu fark bilincli tasarim karari kabul edilir.

---

## 8. Discoverability neden ikincil katmandir?

Discoverability vardir ama omurga degildir.

### 8.1. Search'in rolu

Search:

- creator tarafinda library bulma yardimcisidir
- public tarafta büyük sayfalarda taramayı kolaylastirir

Search ne değildir:

- global creator marketplace search
- primary navigation replacement

### 8.2. Filter'in rolu

Filter:

- context içi taramayı kolaylaştırır
- category hissi yaratmadan ayırıcı katman sunar

### 8.3. Tags'in rolu

Tags:

- yardımcı semantic signal'dir
- context'in yerine geçmez
- ranking ve findability'e yardim eder

### 8.4. Category neden omurga olamaz?

Category omurga olursa:

- content-linked page farki zayiflar
- urun generic shopping browse hissine kayar
- creator-centered model zayiflar

Bu nedenle category yalnız yardımcı semantic layer olarak kalır.

---

## 9. IA ile route modelinin iliskisi

Bu belge route detayini yazmaz ama route modeline şu emirleri verir:

1. Creator kimligi URL'de birinci sinif olarak yasar
2. Storefront, shelf ve content page route'lari anlamsal olarak ayrisir
3. Product detail varsa context'ten kopuk katalog URL mantigina donusmez
4. Preview ve draft route'lari public canonical yolun yerine gecmez

---

## 10. IA ile domain modelinin iliskisi

Bu belge domain modeline su zorunlu ayrimlari verir:

1. creator ayrı primitivdir
2. storefront ayrı primitivdir
3. shelf ve content page ayri page type primitive'leridir
4. product ile placement ayri primitive'lerdir
5. source primitive'i product'tan ayridir

Bu ayrimlardan biri zayiflarsa domain modeli IA'yi tasiyamaz.

---

## 11. IA ile template modelinin iliskisi

Template sistemi IA'yi bozamaz.

Bu karar su anlama gelir:

- template degisimi page type hiyerarsisini bozmaz
- creator, trust ve context alanlarini kaldiramaz
- storefront ile content page baska urunler gibi hissedemez

Template, IA'nin ustune giydirilen gorsel varyasyondur; IA'nin yerine gecen bir özgürlük katmani degildir.

---

## 12. Empty state ve edge-case kurallari

### 12.1. Empty storefront

Bos storefront:

- kirik sayfa gibi görünmemeli
- creator'in aktif vitrini olmadigi acik yazilmali
- yalanci placeholder urunler gosterilmemeli

### 12.2. Empty shelf

Bos shelf:

- publish edilemeyebilir veya controlled empty state ile gosterilebilir
- bu karar publication modelinde net olmalidir

### 12.3. Content page source content kaybi

Ornek:

- video silinmistir ama page kaydi yaşıyordur

Beklenen davranis:

- page tamamen anlamsizlasmadan once acik bilgilendirme verilir
- ilgili urunler baglamsiz ama kirik hissettirmeyecek sekilde korunabilir

### 12.4. Same product in multiple contexts

Bu hata degildir.  
Ama viewer'i karistirmamasi icin:

- context note farki acik olmali
- title varyasyonlari anlamsal olmali

---

## 13. Anti-pattern listesi

Asagidaki yaklasimlar bu belgeye gore IA ihlalidir:

1. category grid ile public root page baslatmak
2. content-linked page'i ikincil veya gizli capability gibi ele almak
3. product yerine link primitive'i etrafinda dusunmek
4. placement katmanini yok saymak
5. creator bio ve hero'yu product discovery'nin önüne koymak
6. search ve tags'i omurgaya cevirmek

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `21-page-types-and-publication-model.md` storefront, shelf ve content page'i first-class page type olarak ele almalidir
2. `22-route-slug-and-url-model.md` creator -> page type zincirini URL'ye cevirmelidir
3. `24-viewer-experience-spec.md` context/product-first hiyerarsiyi sayfa deneyimine dönusturmelidir
4. `25-search-filter-tagging-rules.md` discoverability katmanini IA'nin yerine gecirmemelidir
5. `30-domain-model.md` product/source/placement ayrimini dogrudan domain primitive'ine cevirmelidir

---

## 15. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- urunun omurgasi category yerine creator/context/product ilişkisi etrafında netleşiyorsa
- public ve creator IA farki ekip icinde tartışmasız hale geliyorsa
- content-linked page farklastirici primitive olarak korunuyorsa
- search, filter ve template kararları omurgayi bozmadan tasarlanabiliyorsa

Bu belge basarisiz sayilir, eger:

- category-first yorum geri sızıyorsa
- product ile placement ayrimi karışıyorsa
- storefront profile vanity page'e dönüşüyorsa
- content page trafik veya tasarimda ikincil kalıyorsa

Bu nedenle bu belge, urunun yalnizca nasıl gezilecegini değil; hangi yapisal mantıkla ayakta duracagini tanimlar.
