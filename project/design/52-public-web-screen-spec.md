---
id: PUBLIC-WEB-SCREEN-SPEC-001
title: Public Web Screen Spec
doc_type: public_surface_design
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - VIEWER-EXPERIENCE-SPEC-001
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
  - PRICE-AVAILABILITY-REFRESH-POLICY-001
blocks:
  - WEB-SURFACE-ARCHITECTURE
  - EMPTY-LOADING-ERROR-STATE-SPEC
  - MOTION-FEEDBACK-MICROINTERACTION-SPEC
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE
---

# Public Web Screen Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun public web yuzeylerinde bulunan storefront home, shelf page, content page, light product detail ve sistem-state ekranlarinin bilgi hiyerarsisini, above-the-fold davranisini, trust ve disclosure yerlesimini, CTA mantigini, responsive kirilimlarini ve SEO/share etkisini tanimlayan resmi public surface design spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Publicte ilk bakista ne gorunmeli?
- Creator kimligi ile urun/context hiyerarsisi nasil dengelenmeli?
- Content page ile shelf neden ayni layout varyanti gibi davranmamali?
- Kart icindeki trust row ve CTA nerede konumlanmali?
- Stale price, archived page ve broken link gibi durumlar publicte nasil gorunmeli?
- Public layout neden ne marketplace ne de bio-link kutucuk dizisi gibi gorunmelidir?

Bu belge, public sayfalarin yalniz ekran listesi degil; bilgi onceligi ve davranis standardidir.

---

## 2. Bu belge neden kritiktir?

Public web bu urunun dis dunyaya acilan ana yuzeyidir.  
Creator ne kadar iyi import ederse etsin, public hiyerarsi yanlissa urun degeri hissedilmez.

En buyuk riskler:

- creator header'in urunleri asagi itmesi
- trust/disclosure'in dipnota kaymasi
- content page'in sıradan kategori listesi gibi gorunmesi
- CTA'nin shopping manipülasyonu gibi hissettirmesi

Bu nedenle public web spec, sadece visual polish degil; urunun tezini gozle gorulur hale getirme belgesidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Public web yuzeyleri, creator-centered ama product/context-first editorial recommendation experience'i olarak tasarlanir; above-the-fold alanda daima creator baglami, page context'i ve en az bir recommendation sinyali birlikte gorunur; trust katmani kart ve detail seviyesinde görünür kalir, asla modal veya footer bilgisine dusmez.

Bu karar su sonuclari dogurur:

1. Hero alanlari urunleri asagi iten ego bolgesine donusemez.
2. Content page, "bu icerikte gecenler" hissini ilk bakista vermelidir.
3. CTA, "satın al" manipülasyonu degil, merchant'a cikis netligi uretmelidir.
4. Stale ve missing state'ler gizlenmez; trust row uzerinden iletilir.

---

## 4. Public surface ilkeleri

### 4.1. Context-first

Viewer once "neden bu urun burada" sorusuna cevap alir.

### 4.2. Creator-visible, not creator-dominant

Creator kimligi gorunur.  
Ama public experience creator biography sayfasina donmez.

### 4.3. Trust-in-line

Disclosure, merchant ve stale bilgisi iceriğin akisinda yer alir.

### 4.4. Decision-light

Viewer'i PDP duvarina sokmadan yeterli karar bilgisi verilir.

### 4.5. Performance-aware

Skeleton ve visual zenginlik SEO ve hiz hedefini bozmadan uygulanir.

---

## 5. Global public layout iskeleti

Tum public ekranlarda asgari ortak iskelet vardir:

1. lightweight top bar / creator identity anchor
2. page-level context block
3. recommendation body
4. trust-supporting metadata
5. footer-level navigation/supporting links

### 5.1. Top bar

Amaci:

- creator handle / identity
- ana navigation
- gerekiyorsa storefront geri donus yolu

### 5.2. Page-level context block

Ekran tipine gore:

- storefront intro
- shelf context
- content reference
- product light detail lead

### 5.3. Recommendation body

Ana grid/list/sections burada yer alir.

### 5.4. Supporting footer

Footer:

- trust katmaninin yerine gecmez
- only supportive links ve low-priority bilgi tasir

---

## 6. Screen family 1: Storefront home

## 6.1. Amac

Storefront home, creator'in public root recommendation girisidir.  
Ama amaci creator profile sayfasi olmak degil, recommendation universe'e ilk giris vermektir.

## 6.2. Above-the-fold hiyerarsi

Ilk viewport'ta asgari olarak:

1. creator identity anchor
2. kisa positioning/bio satiri
3. featured recommendation signal

gorunmelidir.

Kural:

- creator intro, featured shelf/content page veya featured products'i viewport disina itemez

## 6.3. Govde yapisi

Onerilen sira:

1. compact creator intro
2. featured shelf veya highlighted content page
3. secondary recommendation rails
4. gerekirse latest/selected content page'ler

## 6.4. Yapilmamasi gerekenler

- uzun influencer bio blogu
- social icon duvari
- urunlerden once gelen aşiri creator self-promo
- onlarca mini kutudan olusan link tree dizilimi

---

## 7. Screen family 2: Shelf page

## 7.1. Amac

Shelf page, tekrarli veya evergreen recommendation cluster'ini gosterir.

Ornek:

- travel essentials
- daily skincare
- gym bag setup

## 7.2. Above-the-fold hiyerarsi

1. shelf title
2. kisa context note
3. gerekiyorsa subtle hero/cover
4. ilk placement'larin gorunur baslangici

Kural:

- hero varsa bile ilk product satiri fold altina gomulmemelidir

## 7.3. Filter / tag rail

Filter rail yardimci katmandir.

Kurallar:

1. default acik ama compact olabilir
2. dozens-of-facets paneline donmez
3. rail yoksa sayfa anlamsiz kalmamalidir

## 7.4. Shelf body

Grid veya list secimi template varyasyonuna bagli olabilir.  
Ama her iki durumda da:

- image
- title
- creator note/context note
- trust row
- CTA

gorunurlugunu korumalidir.

---

## 8. Screen family 3: Content page

## 8.1. Amac

Content page, urunun differentiator surface'idir.  
Viewer'e "bu icerikte neler kullanildi?" sorusunun cevabini verir.

## 8.2. Above-the-fold hiyerarsi

Ilk viewport'ta:

1. content reference / context block
2. page title
3. gerekiyorsa creator intro note
4. ilk recommendation item'larin baslangici

gorunmelidir.

## 8.3. Content reference block

Bu blok asgari olarak su sinyalleri tasiyabilir:

- platform type
- content title
- cover/thumbnail
- original publish reference

Kural:

- content block product listesini bogmaz
- ama content-linked nature ilk bakista anlaşılır

## 8.4. Recommendation body

Content page body, shelf body'den daha narratif olabilir.

Ornek düzen:

1. intro/context note
2. used-in-this-content grid/list
3. optionally related shelf link

## 8.5. Yapilmamasi gerekenler

- content page'i sadece generic product grid yapmak
- content reference'i alta ya da paylaşılmayan meta bilgisine gommek

---

## 9. Screen family 4: Product light detail

## 9.1. Amac

Bu ekran katalog PDP degildir.  
Kartta sigmayan ama viewer kararini destekleyen hafif detay ekranidir.

## 9.2. Above-the-fold yapisi

1. primary image
2. title
3. creator note veya reason snippet
4. trust row
5. merchant + price block
6. outbound CTA

## 9.3. Kural

- teknik spec tablosu duvarina donmez
- benzer urun/up-sell modulu ile dolmaz
- checkout hissi vermez

---

## 10. Card tasarim ilkeleri

Card, public yuzeylerin temel birimidir.

### 10.1. Card'in asgari bolumleri

1. primary image
2. title
3. context veya creator note snippet
4. trust row
5. CTA

### 10.2. Card trust row

Asagidaki verilerin anlamli subset'i gorunur olur:

- disclosure signal
- merchant kimligi
- price state
- stale warning varsa kisa baglam

### 10.3. CTA copy ilkesi

CTA:

- merchant'a cikisi acik anlatir
- manipülatif shopping dili kullanmaz

Uygun dil:

- "Merchant'ta gor"
- "Linke git"
- "Detayi ac"

Uygun olmayan dil:

- "Hemen satin al"
- "Kacirma"
- "Sepete ekle"

---

## 11. Creator kimligi ve profile davranisi

### 11.1. Creator identity anchor

Gorunmesi gerekenler:

- isim veya handle
- avatar opsiyonel
- kisa positioning

### 11.2. Creator profile'in siniri

Yapilmamasi gerekenler:

- uzun hikaye metni
- shop item'lari fold altina iten buyuk portrait hero
- sosyal link kalabaligi

### 11.3. Storefront-to-page continuity

Shelf ve content page'lerde creator baglamina geri donus kolay olmalidir.

---

## 12. Trust ve disclosure yerlesimi

### 12.1. Page-level trust

Gerektiginde:

- genel disclosure note
- source freshness notu

page-level olarak bulunabilir.

Ama:

- product-level trust bilgisinin yerine gecmez

### 12.2. Card-level trust

Card veya detail icinde visible olmalidir.

### 12.3. Stale price

Price stale ise:

- current fiyat gibi tasarlanmaz
- warning tone ve copy kullanilir

### 12.4. Hidden price

Creator veya policy price'i gizlediyse:

- bos slot olmaz
- anlaşilir copy kullanilir

---

## 13. Grid, list ve density kurallari

### 13.1. Desktop

Desktop'ta:

- 2-4 kolon arasi grid kabul edilebilir
- ama trust row okunurlugu korunur

### 13.2. Mobile

Mobile'da:

- tek kolon veya rahat 2-up layout
- note ve trust'i bozmayacak yogunluk

### 13.3. Density siniri

Kurallar:

1. Çok sıkışık card dizilimi trust bilgisini yok ediyorsa tercih edilmez.
2. Fazla bosluk urun taramasini yavaslatiyorsa editorial adına abartilmaz.

---

## 14. Responsive ilkeler

### 14.1. Storefront

- creator intro kisa kalir
- featured recommendation ilk viewport'ta yine görünür

### 14.2. Shelf

- filter rail collapse olabilir
- ama filter yoksa sayfa hala anlamli kalir

### 14.3. Content page

- content reference block mobile'da compactlasir
- urun listesi baglamdan kopmaz

### 14.4. Product detail

- CTA ve trust satiri mobile'da okunur ve dokunulabilir olmalidir

---

## 15. Empty, archived ve degraded state yerlesimi

### 15.1. Empty storefront

Publicte utandirici degil, saygili empty state gerekir.

### 15.2. Archived content/shelf

Kural:

- sert 404 yerine controlled archived state olabilir
- viewer'a alternatif rota verilir

### 15.3. Broken merchant link

Kural:

- publicte panik copy yok
- creator recommendation value tamamen silinmez
- gerekiyorsa merchant cikisi gecici kapatilir

Bu state'ler `56` ile detaylanir; ama public ekran iskeleti bunlara alan ayirmalidir.

---

## 16. SEO ve share davranisi

### 16.1. Storefront

- creator root surface olarak canonical metadata tasir

### 16.2. Shelf

- kendi title/context metadata'si vardir

### 16.3. Content page

- share preview'de en guclu yuzeylerden biridir
- content reference ve creator baglami anlamli sekilde gorunmelidir

### 16.4. Archived pages

- aktif SEO surface gibi davranmaz

---

## 17. Motion ve feedback notlari

Public motion hafif olmalidir.

Kabul edilenler:

- image load fade
- list reflow'da hafif continuity
- CTA hover/press feedback

Kabul edilmeyenler:

- hero bolgesinde uzun parallax
- disclosure/warning bilgisini animasyona gommek
- skeleton'u gercek layout'tan kopuk yapmak

---

## 18. Senaryolar

## 18.1. Senaryo A: Viewer storefront'a ilk kez geldi

Beklenen deneyim:

- creator kimligini anlar
- ama asıl olarak ne tavsiye edildigini hemen gorur
- urunlere gecis net olur

## 18.2. Senaryo B: Content page linki paylasildi

Beklenen deneyim:

- bu sayfanin bir icerik baglamina ait oldugu ilk bakista anlasilir
- urunler baglamdan kopuk katalog gibi durmaz

## 18.3. Senaryo C: Shelf icinde stale price var

Beklenen deneyim:

- trust row stale bilgisini verir
- viewer current price algisina itilmez

## 18.4. Senaryo D: Broken source

Beklenen deneyim:

- urunun recommendation degeri sifirlanmaz
- ama merchant cikisi veya price satiri controlled hale gelir

---

## 19. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Public homepage'i creator bio sayfasi gibi kurmak
2. Content page'i shelf'in görsel varyanti gibi ele almak
3. Trust/disclosure'i tooltip veya footer bilgisina itmek
4. CTA'lari agresif commerce diline kaydirmak
5. Filter/tag rail'i IA'nin yerine koymak
6. Hero alanlarin urunleri fold altina atmasina izin vermek

---

## 20. Bu belge sonraki belgelere ne emreder?

1. `61-web-surface-architecture.md`, public route ailelerini bu screen family'lere gore ayirmalidir.
2. `56-empty-loading-error-and-state-spec.md`, archived, empty, broken-link ve stale-price state'lerini bu ekran hiyerarsisiyle uyumlu detaylandirmalidir.
3. `57-motion-feedback-and-microinteraction-spec.md`, public motion'u bu hafif feedback kurallarina gore tanimlamalidir.
4. `67-seo-og-and-share-preview-architecture.md`, content page ve shelf metadata hiyerarsisini bu bilgi mimarisine gore kurmalidir.

---

## 21. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- public web ilk bakista context-first recommendation experience'i olarak okunuyorsa
- creator kimligi gorunur ama urunlerden daha baskin degilse
- trust ve stale bilgisi layout icinde dogal ama gorunur yerdeyse
- storefront, shelf ve content page birbirinden anlamsal olarak ayri hissediliyorsa

Bu belge basarisiz sayilir, eger:

- public yuzey generic shop builder, bio-link page veya PDP kopyasi gibi gorunuyorsa
- stale/disclosure bilgisi layout kenarina itilmis veya kaybolmussa
- content page ile shelf arasindaki fark ilk bakista anlasilmiyorsa

