---
id: MARKET-LANDSCAPE-COMPETITOR-MAP-001
title: Market Landscape and Competitor Map
doc_type: research_strategy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-VISION-THESIS-001
  - PRODUCT-SCOPE-NON-GOALS-001
blocks:
  - PROBLEM-VALIDATION-FRICTION-MAP
  - PRODUCT-INFORMATION-ARCHITECTURE
  - SUBSCRIPTION-PLAN-MODEL
  - URL-IMPORT-PIPELINE-SPEC
---

# Market Landscape and Competitor Map

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun girecegi pazar alanini, komsu kategori kümelerini, bu kümelerin guclu ve zayif yönlerini, urunun hangi eksenlerde dogrudan rekabet ettigini ve hangi eksenlerde bilincli olarak rekabet DISI kaldigini tanimlayan resmi strateji ve rekabet haritasidir.

Bu belge su sorulara cevap verir:

- Bu urun gercekte hangi kategori kümeleriyle yan yana durur?
- Hangi rakipler urun icin dogrudan tehdit, hangileri dolayli baski yaratir?
- Hangi özellikler parity olarak gorulebilir ama bizim icin stratejik merkez olmamalidir?
- Uygun farklilasma eksenleri nelerdir?
- Hangi positioning dilleri bizi yanlis sepete iter?

Bu belge rakip isim listesi belgesi degildir.  
Bu belge, "hangi urun mantiklari ile ayni alanda oynuyoruz?" sorusunun cevabidir.

---

## 2. Bu belge neden kritiktir?

Bu urun icin en buyuk stratejik hata, rakibi yanlis tanimlamaktir.

Ornek yanlislar:

- Yalnizca Linktree ile rekabet ettigimizi sanmak
- Yalnizca storefront urunu oldugumuzu sanmak
- Yalnizca affiliate tool'lari rakip kabul etmek
- Platform-native shopping'i "baska alan" diyerek tamamen dislamak

Bu yanlislar su sonuclari dogurur:

- urun positioning'i yanlis yazilir
- roadmap'te yanlis parity baskilari birikir
- hangi capability'lerin cekirdek, hangilerinin yardimci oldugu karisir

Bu belge su ana karari dayatir:

> `product-showcase`, link-in-bio/storefront, affiliate-first creator commerce ve platform-native shopping kümeleriyle farklı seviyelerde rekabet eden; ama bunların hicbirine tam indirgenmemesi gereken context-first recommendation publishing urunudur.

---

## 3. Pazar okumasinin ana tezi

Pazarda uc temel kume vardir ve bu kümeleri birbirine karistirmak stratejik hatadir:

1. Link-in-bio / storefront araclari
2. Affiliate-first creator commerce araclari
3. Platform-native shopping yuzeyleri

Bu urun bu uc kume ile de temas eder.  
Ama bu urunun savunulabilir yeri sudur:

> platform-neutral, URL-first, context-rich, trust-visible, reusable recommendation publishing

Bu beşli ayni anda kurulamazsa urun kolayca daha buyuk ve daha kalabalik bir kümeye yutulur.

---

## 4. Kume 1: Link-in-bio / storefront araclari

### 4.1. Bu kume nedir?

Bu kume creator'in tek bir public link etrafinda:

- profil,
- link listesi,
- bazen vitrin,
- bazen dijital urun,
- bazen analytics

yapisi kurdugu araçlardan olusur.

Tipik ornekler:

- Linktree
- Beacons
- Stan

### 4.2. Bu kumenin guclu taraflari nelerdir?

1. Tek-link davranisi pazar tarafinda ogrenilmis davranistir
2. Kurulum kolayligi yuksektir
3. Theme ve storefront kontrollari genellikle gucludur
4. Creator monetization dili kuvvetlidir

### 4.3. Bu kumenin zayif taraflari nelerdir?

1. Context-first urun anlatimi genellikle cekirdek degildir
2. Product reuse / library modeli merkezi olmayabilir
3. Import velocity ve verification zinciri genellikle urunun kalbi degildir
4. Trust/disclosure katmani cogu zaman gomulu veya ikincildir

### 4.4. Bu kume neden tehlikelidir?

Cunku en yakin gorunen kategori budur.  
Yanlis positioning yaparsak pazar bizi su sekilde algilar:

- biraz daha iyi Linktree
- biraz daha temiz storefront
- biraz daha guzel creator profile page

Bu algi urunun asil farkini oldurur.

### 4.5. Bu kumeden ne ogrenilir?

Ogrenilmesi gerekenler:

- tek-link giris davranisinin tanidik olmasi
- hizli setup beklentisi
- theme kalitesinin onemi

Taklit edilmemesi gerekenler:

- link listesi merkezli urun anlayisi
- product-context iliskisinin zayif kalmasi
- analytics / monetization dilinin urun anlatimini ezmesi

---

## 5. Kume 2: Affiliate-first creator commerce araclari

### 5.1. Bu kume nedir?

Bu kume:

- creator storefront,
- affiliate retailer network,
- shoppable link,
- monetization ve gelir gorunurlugu

etrafinda kurulan urunleri kapsar.

Tipik ornekler:

- ShopMy
- LTK

### 5.2. Bu kumenin guclu taraflari nelerdir?

1. Gelir anlatisi nettir
2. Retailer / affiliate baglantilari derindir
3. Creator'a finansal fayda degerini acik gosterir
4. Shopping davranisini kuvvetli tasir

### 5.3. Bu kumenin zayif taraflari nelerdir?

1. Platform-neutral URL import bazen ana odak degildir
2. Recommendation trust ve kullanım bağlamı monetization tarafinda eriyebilir
3. Retention'nin merkezi gelir olabilir; publishing kalitesi değil
4. Baslangicta retailer/network bagimliligi onboarding sürtünmesi yaratabilir

### 5.4. Bu kume neden tehlikelidir?

Bu kume urune su baskiyi getirir:

- "gelir paneli de olsun"
- "affiliate intelligence de kuralim"
- "retailer network olmasa eksik kalir"

Bu baski ilk faz icin yanlistir.  
Cunku urunun farki monetization derinligi degil, neutral ve context-rich publishing'dir.

### 5.5. Bu kumeden ne ogrenilir?

Ogrenilmesi gerekenler:

- recommendation ile gelir arasindaki iliskinin creator icin anlamli olmasi
- shopping yönünün tamamen yok sayilmamasi

Taklit edilmemesi gerekenler:

- urun anlatimini gelir paneline cevirmek
- ilk fazda affiliate network derinligiyle yarismaya calismak

---

## 6. Kume 3: Platform-native shopping yuzeyleri

### 6.1. Bu kume nedir?

Bu kume, sosyal platformlarin creator icerigine urun baglama ve shopping davranisini kendi iclerinde sundugu yüzeylerden olusur.

Tipik ornekler:

- YouTube Shopping
- TikTok Shop
- Instagram shopping baglama mantiklari

### 6.2. Bu kumenin guclu taraflari nelerdir?

1. Icerik ile urun arasindaki mesafe cok kisadir
2. Platform ici dagitim ve algi avantajı vardir
3. Checkout veya conversion davranisi daha akışkandır

### 6.3. Bu kumenin zayif taraflari nelerdir?

1. Creator tek platforma baglanir
2. Farkli platformlardaki urun mention'larini tek yerde toplama problemi cozulmez
3. Creator kendi cross-platform recommendation presence'ini kuramaz

### 6.4. Bu kume neden tehlikelidir?

Bu kume urune su yanlis yorum baskisini getirir:

- "madem platformlar yapiyor, bizim farkimiz ne?"

Dogru cevap sudur:

- farkimiz platform-neutral olmak
- farkimiz tek-link ve web-first tüketim katmani olmak
- farkimiz content-linked page'i platformlar arasi birlestirmek

### 6.5. Bu kumeden ne ogrenilir?

Ogrenilmesi gerekenler:

- content-to-product akisi ne kadar kisaysa deger artar
- "used in this video" mantigi cok gucludur

Taklit edilmemesi gerekenler:

- tek platforma kilitlenme
- platform ici shopping primitive'lerini bire bir kopyalama

---

## 7. Dörduncu dolayli kume: Generic CMS / website builder baskisi

Bu kume dogrudan rakip gibi gorunmeyebilir; ama urune baska bir tür baski yapar.

Bu baski:

- daha serbest builder
- daha fazla blok
- daha fazla ozgurluk
- daha fazla layout kontrolu

seklinde gelir.

Bu neden onemlidir?

Cunku urunun anti-pattern'lerinden biri, website builder'a donusmektir.

Bu kumeden ogrenilen:

- creatorlar estetik ve kontrol ister

Ama reddedilen şey:

- urunun builder kimligi kazanmasi

---

## 8. Rekabet eksenleri

Rakipleri isim bazli degil, eksen bazli okumak gerekir.

### 8.1. Tek-link behavior

Rakiplerde durum:

- kuvvetli

Bizim karar:

- parity capability'dir
- ama farklastirici ana eksen degildir

### 8.2. Context-linked publishing

Rakiplerde durum:

- kismi veya zayif

Bizim karar:

- ana farklastirici eksendir

### 8.3. URL-first import automation

Rakiplerde durum:

- tutarsiz
- bazen yardimci, bazen cok zayif

Bizim karar:

- cekirdek capability

### 8.4. Reusable product library

Rakiplerde durum:

- kimi yerde vardir ama merkezi degildir

Bizim karar:

- veri modeli ve creator retention'in merkezidir

### 8.5. Trust/disclosure visibility

Rakiplerde durum:

- cogu zaman gomulu veya zayif

Bizim karar:

- UI'nin ve product truth layer'in cekirdegi

### 8.6. Platform neutrality

Rakiplerde durum:

- platform-native shopping yuzeylerinde zayif
- storefront urunlerinde vardir ama context zayif olabilir

Bizim karar:

- stratejik avantajdir

---

## 9. Rekabet matrisi

| Eksen | Link-in-bio / Storefront | Affiliate-first | Platform-native shopping | `product-showcase` hedefi |
| --- | --- | --- | --- | --- |
| Tek-link tanidikligi | Yuksek | Orta | Dusuk | Yuksek ama parity seviyesi |
| Context-linked page | Dusuk-Orta | Dusuk-Orta | Orta | Cok yuksek |
| URL-first import | Dusuk-Orta | Orta | Dusuk | Cok yuksek |
| Reusable library | Orta | Orta-Yuksek | Dusuk | Cok yuksek |
| Trust/disclosure visibility | Dusuk | Orta | Platforma bagli | Yuksek |
| Platform-neutrality | Yuksek | Orta | Dusuk | Yuksek |
| Checkout / transaction derinligi | Dusuk-Orta | Yuksek | Yuksek | Bilincli olarak dusuk |

Bu matrisin anlami sudur:

Bizim urun, checkout veya monetization derinligiyle kazanmayacak.  
Asil kazanc hattı:

- context-linked page
- URL-first import
- library reuse
- trust visibility

olacaktir.

---

## 10. Pazar icinde savunulabilir fark nedir?

Bu urun icin savunulabilir fark tek ozellikte degil, dört eksenin birlikte kurulmasindadir:

1. Context-first information architecture
2. Fast import + verification workflow
3. Reusable product library + placement modeli
4. Trust/disclosure ve stale-data seffafligi

Bu dort eksenden biri zayiflarsa urun kolayca baska bir kategoriye indirgenir.

Ornek:

- import zayifsa urun theme editor'e doner
- context zayifsa urun link listesine doner
- reuse zayifsa urun manuel product manager'a doner
- trust zayifsa urun reklam vitrini gibi hissedilir

---

## 11. Hangi alanlarda parity yeterlidir?

Bu urun her alanda rakibi gecmek zorunda degildir.  
Bazi alanlarda parity yeterlidir.

Parity kabul edilebilecek alanlar:

- tek-link davranisi
- temel storefront gorselligi
- sade theme secimi
- basic analytics sinyalleri

Parity'nin yeterli olmadigi alanlar:

- import velocity
- import accuracy
- context-linked publishing
- trust/disclosure visibility
- reuse and placement model

---

## 12. Hangi positioning dilleri yanlistir?

Asagidaki positioning dilleri bizi yanlis sepete iter:

### 12.1. "Linktree alternatifi"

Neden yanlis:

- urunun farkini asiri daraltir
- bizi commodity alana iter

### 12.2. "Creator store"

Neden yanlis:

- checkout / commerce beklentisi yaratir
- store yerine recommendation publishing merkezli olmamiz gerekir

### 12.3. "Affiliate platform"

Neden yanlis:

- gelir paneli ve network beklentisi dogurur

### 12.4. "AI product curator"

Neden yanlis:

- AI'nin rolunu abartir
- import ve verification davranisinin insani kalite kapisini zayif gosterir

Doğru positioning dili:

- creator recommendation showcase
- used in this video / what I used
- trusted product picks
- cross-platform creator vitrini

---

## 13. Ilk wedge stratejisinin rekabet acisindan anlami

Fitness creator'larla baslama karari yalniz urun degil, rekabet stratejisi kararidir.

Bu segmentin avantajlari:

1. Context yapisi net
2. Product tekrar kullanimi yuksek
3. Shelf mantigi dogal
4. "what I use" anlatimi kolay
5. Takipci sorusu tekrarli

Bu neyi saglar?

- urunun farklastirici tezleri ilk gunde daha gorunur olur
- generic creator suite hissi zayiflar

Beauty ve tech neden daha sonra?

- beauty'de urun hacmi ve varyasyon cok dağınık olabilir
- tech'te fiyat/stok ve data karmaşıkligi daha yüksek olabilir

Bu segmentler dislanmaz; ama ilk wedge icin daha riskli olabilir.

---

## 14. Rekabetten dogan scope tuzaklari

Rekabet haritasi, hangi capability'lerin tehlikeli scope baskisi oldugunu gosterir.

### 14.1. Monetization suite baskisi

Kaynak:

- affiliate-first rakipler

Sonuc:

- analytics ve attribution erken scope'a sizar

### 14.2. Theme/builder baskisi

Kaynak:

- link-in-bio/storefront urunleri

Sonuc:

- urun import ve context yerine kozmetik builder'a kayar

### 14.3. Checkout baskisi

Kaynak:

- storefront ve platform-native shopping

Sonuc:

- commerce operations scope'a sizar

### 14.4. Discovery feed baskisi

Kaynak:

- marketplace ve shopping browse davranisi

Sonuc:

- creator-centered model zayiflar

---

## 15. Bu arastirmadan cikan stratejik kararlar

Bu belgeye gore resmi stratejik cikarsamalar sunlardir:

1. Kategori ana omurga olmayacaktir
2. Content-linked page urunun cekirdek farklastirici yuzeyi kabul edilecektir
3. URL-first import urunun teknik merkezidir
4. Public web consumption birinci sinif yuzeydir
5. Monetization ve analytics ilk fazin ana anlatisi olmayacaktir
6. Fitness, ilk wedge olarak uygundur

Bu kararlar yalnizca research notu degil; sonraki belgeler icin baglayici girditir.

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `11-problem-validation-and-user-friction-map.md` friction alanlarini bu kume farklarina gore yazmalidir
2. `20-product-information-architecture.md` category-first IA kuramaz
3. `28-subscription-and-plan-model.md` monetization'i urun anlatiminin onune koyamaz
4. `40-url-import-pipeline-spec.md` import farkini merkezde tutmak zorundadir
5. `52-public-web-screen-spec.md` public sayfayi profile vanity page'e donusturemez

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ekip rakipleri isim degil kume ve eksen bazinda tartisabiliyorsa
- hangi capability'lerde parity, hangi capability'lerde farklastirma gerektigi netse
- positioning dili yanlis kategoriye kaymiyorsa
- urun roadmap'i monetization, builder veya checkout baskisina erken yenilmiyorsa

Bu belge basarisiz sayilir, eger:

- urun hala "biraz daha iyi Linktree" gibi algilaniyorsa
- content-linked page ve import farki rekabet dilinde yeterince merkezi degilse
- rakip baskisi scope kontrolunu deliyorsa

Bu nedenle bu belge, urunun pazarda nerede durdugunu degil; hangi pazarlara benzememek icin kendini nasıl korumasi gerektigini de tanimlar.
