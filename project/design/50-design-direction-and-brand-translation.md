---
id: DESIGN-DIRECTION-BRAND-TRANSLATION-001
title: Design Direction and Brand Translation
doc_type: design_strategy
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-VISION-THESIS-001
  - TEMPLATE-CUSTOMIZATION-RULES-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
blocks:
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-MOBILE-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - CONTENT-COPY-GUIDELINES
---

# Design Direction and Brand Translation

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun gorsel kimliginin neye benzemesi gerektigini, urun tezindeki "context-first recommendation publishing" mantiginin public, creator ve internal yuzeylerde nasil farkli ama tutarli bir tasarim diline cevrilecegini, hangi brand niteliklerinin zorunlu oldugunu ve hangi gorsel dillerin urunun kimligini bozdugunu tanimlayan resmi design direction belgesidir.

Bu belge su sorulara cevap verir:

- Urunun hissi "storefront", "creator tool" ve "ops console" yuzeylerinde nasil ayrisir?
- Neden generic SaaS dili veya influencer-profile-first estetik bu urune uymaz?
- Typography, color, spacing, imagery ve motion katmanlari hangi amaca hizmet eder?
- Trust/disclosure katmani tasarim dilinin neresindedir?
- Template varyasyonu serbestligi ne kadar olabilir, ne kadar olamaz?

Bu belge, moodboard ozeti degil; urunun gorsel kararlarini yoneten source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Bu urunun en buyuk tasarim riski "yanlis kategoriye ait gorunmek"tir.

Urun su hatalardan biriyle kolayca raydan cikabilir:

- link-in-bio kutucuklari gibi gorunmek
- generic storefront builder gibi gorunmek
- influencer profil karti gibi davranmak
- opsiyonel disclosure dipnotu olan parlak commerce vitrinine donusmek
- creator surface'leri fazla "designy" yapip utility hizini bozmak

Bu urun ne tam bir e-commerce PDP sistemi, ne de sadece creator profile vitrini.  
Tasarim dili bu ara konumu netlestirmek zorundadir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` tasarim dili, public yuzeylerde editorial guven ve secicilik; creator yuzeylerinde ise hizli utility ve karar netligi ureten iki katmanli bir sistemdir; her iki katman da ayni brand temelini paylasir ama ayni layout davranisini veya ayni gorsel yogunlugu tasimaz.

Bu karar su sonuclari dogurur:

1. Public web daha atmosferik ve editorial olabilir.
2. Creator mobile/web daha utility-first kalir.
3. Trust/disclosure ve stale bilgisi gorsel dilin icine gomulur; dipnota itilmez.
4. Template farklari brand iskeletini bozacak kadar genisleyemez.

---

## 4. Brand tezinin gorsel cevirisi

Urun tezini gorsel tarafa ceviren uc ana sifat vardir:

1. `editorial`
2. `trustworthy`
3. `fast`

### 4.1. `editorial`

Anlami:

- secici
- baglamli
- nefesli
- urunu sadece kart listesi olarak degil, "neden burada" sorusuyla gosterme

### 4.2. `trustworthy`

Anlami:

- disclosure ve source bilgisi saklanmaz
- fiyat stale ise current gibi parlatilmaz
- görsel ve bilgi hiyerarsisi aldatıcı olmaz

### 4.3. `fast`

Anlami:

- creator tarafinda karar alma maliyeti dusuk olur
- gereksiz modallar, uzun formlar ve gorsel gosteris performansinin önune gecmez

Bu uc sifat birlikte calismalidir.  
Sadece editorial olursa yavaslar.  
Sadece fast olursa generic toola doner.  
Sadece trustworthy olursa steril kalabilir.

---

## 5. Public, creator ve ops yuzeylerinin ayrimi

### 5.1. Public web

Ana his:

- editorial recommendation surface
- creator baglami net
- urun kararini hizlandiran sade ama karakterli vitrin

Temel hedef:

- viewer hizli tarasin
- neden bu urun burada anlasilsin
- trust katmani ilk bakista gorunsun

### 5.2. Creator mobile

Ana his:

- cepte hizli is cözen arac
- bir el kullanima yakin
- import ve verify odakli

Temel hedef:

- friction'i minimuma indirmek
- publish ve review akisini agir ayarlardan ayirmak

### 5.3. Creator web

Ana his:

- derin duzenleme ve organizasyon araci
- yogun bilgi ama creator için okunur

Temel hedef:

- library, bulk edit ve page management'i guclendirmek
- dashboard'u vanity analytics yerine is sinyallerine odaklamak

### 5.4. Admin / ops

Ana his:

- utility-first internal control plane

Temel hedef:

- hizli tanilama
- tek bakista neden / etki / sonraki aksiyon

Ops yuzeyi brand estegini public kadar tasimak zorunda degildir; ama ayni terminoloji ve karar mantigini korur.

---

## 6. Typography yonu

Typography bu urunde yalniz okunaklilik araci degil, kategori sinyali ureticidir.

### 6.1. Public typography

Kurallar:

1. Headline'lar editorial agirlik tasiyabilir.
2. Metadata ve trust satirlari utility netliginde kalir.
3. Urun basliklari ne katalog shout'u ne de moda dergisi kadar dramatik olur.

### 6.2. Creator typography

Kurallar:

1. Form label, state ve CTA katmanlari acik ve hizli okunur olmalidir.
2. Mobile'da iki satirdan fazla kritik bilgi bloklari az tutulur.
3. Confidence, warning ve duplicate sinyalleri yazisal olarak ayirt edilir.

### 6.3. Typographic kontrast ilkesi

Hiyerarsi su eksenlerde calisir:

- page context
- product title
- creator note
- trust metadata
- supporting diagnostics

Bu katmanlar ayni agirlikta yazilamaz.

---

## 7. Renk sistemi ve semantik renk kullanimi

### 7.1. Ana renk karakteri

Urunun ana renk sistemi:

- neutral ve acik zemin odakli
- koyu metin kontrasti guclu
- bir ana accent ve bir yardimci accent ile sinirli

### 7.2. Neden bu yon?

Cunku:

- product ve image on planda kalmali
- disclosure/trust sinyalleri net okunmali
- generic "purple SaaS" hissi olusmamali

### 7.3. Semantik renkler

Asagidaki semantic roller ayri tutulur:

- primary action
- stale/warning
- blocked/error
- disclosure/trust accent

Kural:

- stale ile error ayni renk davranisini tasimaz
- disclosure ile CTA ayni vurgu tonuna sahip olamaz

### 7.4. Renk anti-pattern'leri

- mor agirlikli generic B2B SaaS paleti
- koyu fon ustunde parlak neon commerce dili
- stale warning'i "sevimli accent" gibi gostermek

---

## 8. Spacing, ritim ve layout ilkeleri

### 8.1. Public layout ritmi

Publicte:

- nefesli ama daginik olmayan spacing
- creator context ile product listesi arasinda net segmentasyon
- trust row'lari sikismaz

### 8.2. Creator layout ritmi

Creator yuzeylerinde:

- bilgi yogunlugu daha yuksek olabilir
- ama kritik aksiyonlar ve state copy'leri sıkismamalidir
- verification ekranlari "sonsuz form" hissi veremez

### 8.3. Ritmik tutarlilik

Urun ailelerinde spacing sistemi tutarli olmali:

- section spacing
- card internal padding
- list-to-detail gecis ritmi

Bu sistem template'den template'e kirilmamalidir.

---

## 9. Surface dili

### 9.1. Card

Card'lar:

- utilitarian kutucuk degil
- ama asiri parlak shop tile da degil

Icinde su denge korunur:

- image
- title
- creator/context note
- trust satiri
- CTA

### 9.2. Page header

Header:

- creator kimligini veya page context'i verir
- ama urun listesini ilk viewport'tan atmaz

### 9.3. Panels ve tables

Creator web ve ops'ta panel/table kullanimi kabul edilir.  
Ama bunlar publicteki editorial dili bozmadan ayrik tutulur.

---

## 10. Imagery ve visual asset kullanimi

### 10.1. Product imagery'nin rolu

Product image:

- kimlik sinyali
- guven sinyali
- hizli tarama yardimcisi

### 10.2. Background ve dekorasyon

Public yuzeyde hafif editorial atmosfer olabilir:

- yumusak zemin tonlari
- subtle divider ve yüzey farklari

Ama:

- urunlerle rekabet eden illüstratif dekorasyon
- dikkat dagitan gradient show

kullanilmaz.

### 10.3. Creator yuzeyleri

Creator tarafinda atmosfer ikinci planda kalir.  
Arac dogrudan ve rahat okunur hissettirmelidir.

---

## 11. Motion ilkeleri

Motion bu urunde "oyuncak hissi" icin degil, durum netligi icin vardir.

### 11.1. Kabul edilen motion rolleri

- import processing gecisi
- verification candidate degisimi
- publish onayi
- lightweight list reordering feedback

### 11.2. Kabul edilmeyen motion rolleri

- uzun decorative entrance animasyonlari
- disclosure veya warning bilgisini animasyonla gizlemek
- loading state'i gizlemek icin dikkat dagitici motion

### 11.3. Reduced motion

Reduced motion durumunda:

- feedback korunur
- ama animasyon sadeleştirilir

---

## 12. Trust ve disclosure'in gorsel entegrasyonu

Bu urunde trust katmani ayri hukuki dipnot alanina surulmez.

### 12.1. Publicte trust row

Kurallar:

1. merchant kimligi görünur olmalidir
2. disclosure badge ya da copy gorunur olmalidir
3. stale price varsa kart veya detail icinde saygi duyulan bir warning dili olmalidir

### 12.2. Creator tarafinda trust editing

Kurallar:

1. disclosure secimi ayar sayfasina gomulmez
2. verification ve page editing akisi icinde anlamli yerde gorunur

### 12.3. Visual hiyerarsi

Trust:

- ne title kadar buyuk
- ne tooltip kadar gizli

orta seviye ama kalici bir görunurlukte olmalidir.

---

## 13. Template ve varyasyon sinirlari

Template sistemi bu brand direction'u esnetebilir, ama bozamaz.

### 13.1. Serbest alanlar

- card radius ve density varyasyonu
- cover hero yogunlugu
- grid/list vurgusu
- accent kullaniminin doz farki

### 13.2. Serbest olmayan alanlar

- trust/disclosure'i gizlemek
- page context'i yukariya degil asagiya gommek
- creator profile'i urunlerden buyuk hale getirmek
- public homepage'i link-in-bio kutularina indirmek

---

## 14. Copy ve tone ile iliski

Design direction ile copy birbirinden ayrik dusunulmez.

Kurallar:

1. Public copy'de abartili shopping dili yok
2. Creator copy'si command center jargonu tasimaz
3. Warning copy'leri panik yaratmadan net olur
4. Empty state'ler utancli veya creator'i yargilayan dile kaymaz

---

## 15. Yasaklanan gorsel yonler

Bu urun asagidaki estetik cizgilere kayamaz:

1. mor/pembe agirlikli generic SaaS dili
2. glassmorphism gösterisi
3. ultra-dark hype commerce dili
4. influencer profile-first layout
5. marketplace category tree hissi
6. tool gibi gorunen public vitrin

---

## 16. Senaryolar

## 16.1. Senaryo A: Public storefront ilk gorus

Beklenen his:

- creator kimligi var
- ama urun ve baglam asagida kaybolmuyor
- ilk viewport'ta recommendation sinyali goruluyor

## 16.2. Senaryo B: Creator mobile verification

Beklenen his:

- utility-first
- hizli karar
- confidence/warning görünur
- gorsel gösteri minimum

## 16.3. Senaryo C: Content page

Beklenen his:

- "bu icerikte kullanilanlar" ana omurga
- trust ve source sinyalleri saklanmiyor
- urunler editorial context ile birlikte okunuyor

---

## 17. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Public ve creator yuzeylerini ayni UI density ile tasarlamak
2. Trust/disclosure katmanini modal veya tooltip'e itmek
3. Creator profilini urun akisinin onune koymak
4. Public experience'i link tree benzeri kutu yiginina cevirmek
5. Motion'u feedback yerine dekorasyon icin kullanmak
6. Template ozgurlugu adina brand iskeletini dagitmak

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `52-public-web-screen-spec.md`, editorial/trustworthy/fast dengesini public sayfalarda hiyerarsiye cevirmelidir.
2. `53-creator-mobile-screen-spec.md`, mobile utility-first tasarim tezi ile hizli import ve review akislarini somutlastirmalidir.
3. `54-creator-web-screen-spec.md`, yogun bilgi ama creator-odakli ekran dilini bu belgeye gore kurmalidir.
4. `58-content-copy-guidelines.md`, tonal dili bu brand yonu ile tutarli yazmalidir.

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- public yuzey generic shop builder gibi degil, context-first recommendation surface gibi hissediyorsa
- creator yuzeyleri gorsel olarak ayni marka cizgisini tasirken utility hizini kaybetmiyorsa
- trust/disclosure katmani gorsel iskeletin dogal parcasi haline geliyorsa
- template varyasyonlari urun kimligini dagitmiyorsa

Bu belge basarisiz sayilir, eger:

- urun ya generic SaaS tool ya da generic link-in-bio vitrini gibi gorunuyorsa
- trust katmani hep ikinci plana itiliyorsa
- public ve creator surface'leri ayni yogunlukta ve ayni dille tasarlaniyorsa

