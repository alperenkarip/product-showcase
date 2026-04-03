---
id: PRODUCT-SCOPE-NON-GOALS-001
title: Product Scope and Non-Goals
doc_type: foundation
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-VISION-THESIS-001
blocks:
  - PERSONAS-JOBS-PRIMARY-USE-CASES
  - SUCCESS-CRITERIA-LAUNCH-GATES
  - PAGE-TYPES-PUBLICATION-MODEL
  - CREATOR-WORKFLOWS
  - SUBSCRIPTION-PLAN-MODEL
  - PROJECT-ROADMAP
---

# Product Scope and Non-Goals

## 1. Bu belge nedir?

Bu belge, `product-showcase` icin ilk urun fazinda hangi capability'lerin kesin olarak gelistirilecegini, hangi capability'lerin bilincle sonraya birakilacagini ve hangi alanlarin urun tanimiyla uyumsuz oldugu icin kapsam disi tutulacagini tanimlayan resmi scope belgesidir.

Bu belge su sorulari kilitler:

- Ilk fazda ne kesinlikle olacak?
- Ilk fazda ne kesinlikle olmayacak?
- Hangi capability'ler "guzel olur" ama zorunlu degildir?
- Hangi capability'ler urunu yanlis sinifa iter?
- Scope degisikligi hangi testlerden gecerek kabul edilir?

Bu belge olmadan iki tehlike dogar:

1. Her mantikli gorunen fikir scope'a sizar
2. Uygulanabilir cekirdek urun yerine dağinik bir ozellik yığını birikir

Bu belge, tam olarak bu dagilmayi engellemek icin vardir.

---

## 2. Bu belge neden kritiktir?

Bu urun icin scope kontrolu hayati onemdedir.  
Cunku pazar komsu kategorilerle doludur:

- link araçlari
- storefront araçlari
- creator commerce suiteleri
- affiliate paneller
- shopping curation yuzeyleri

Bu kategorilerin her biri, urune dogal gorunen ama aslinda cekirdek degeri seyrelten capability baskisi yapar.

Ornek scope kaymalari:

- "Hazir urunler varken checkout da ekleyelim"
- "Creator magazasi dedigimiz icin sepet de olsun"
- "Rakipte analytics var, bizde de revenue dashboard olsun"
- "Madem page builder var, widget marketplace de acalim"
- "Kategori browse etme olmadan shopping hissi eksik kalir"

Bu onerilerin cogu tek tek mantikli gorunebilir.  
Ama hepsi birlikte urunu baska bir seye cevirir.

Bu nedenle scope belgesi, yalnizca "neler var?" listesi degil; ayni zamanda "neleri bilerek reddediyoruz?" belgesidir.

---

## 3. Scope kararinin ana ilkesi

Bu urunde bir capability'nin ilk faz scope'una girebilmesi icin asagidaki dort etkiden en az ikisini net bicimde saglamasi gerekir:

1. Creator'in publish suresini anlamli bicimde kisaltmak
2. Viewer'in urunu baglamiyla anlamasini iyilestirmek
3. Trust, disclosure veya stale-data guvenini artirmak
4. Import, support veya ops tarafinda kritik bir problem cozmeye yardim etmek

Asagidaki gerekceler tek basina scope'a girmek icin yeterli degildir:

- rakipte de var
- guzel gorunur
- ileride ise yarayabilir
- enterprise musteri belki ister
- gelir getirir gibi duruyor

Bu belgeye gore scope, arzu listesiyle degil; urunun cekirdek problemini cozme kuvvetiyle belirlenir.

---

## 4. Ilk fazin tam amaci nedir?

Ilk fazin amaci su degildir:

- olabilecek en genis creator suite'ini cikarmak
- tum commerce capability'lerini acmak
- tum creator segmentlerine ayni anda hitap etmek
- genis BI veya analytics paneli kurmak

Ilk fazin amaci sudur:

> Creator'in urunlerini hizli import edip dogrulayabildigi, tekrar kullanilabilir library uzerinden context-first sayfalarda yayinlayabildigi ve viewer'in bunu guvenilir public web deneyimi icinde tuketebildigi cekirdek recommendation publishing urununu kurmak.

Bu amac, scope icindeki her capability'nin referansidir.

---

## 5. Faz 1'de kesinlikle kapsam dahil olan capability'ler

Bu bolumde capability'ler yalnizca baslik olarak degil, neden zorunlu olduklariyla birlikte yazilir.

### 5.1. Identity ve ownership katmani

Kesinlikle scope dahil:

- creator account
- handle / slug secimi
- storefront ownership
- owner ve editor rol ayrimi

Neden:

- public kimlik handle olmadan kurulamaz
- ownership net olmadan domain, billing ve support akislari kirilir
- owner/editor ayrimi olmadan gercek kullanim desteklenmez

### 5.2. Storefront ve publication katmani

Kesinlikle scope dahil:

- storefront ana sayfasi
- shelf / collection olusturma
- content-linked page olusturma
- draft / publish / unpublish
- placement siralama ve duzenleme

Neden:

- urunun asil degeri yayin katmaninda uretilir
- content-linked page urunun farklastirici cekirdegi oldugu icin sonraya birakilamaz
- draft/publish ayrimi creator guveni icin zorunludur

### 5.3. Product library ve reuse katmani

Kesinlikle scope dahil:

- merkezi product library
- duplicate tespiti
- source-URL / canonical-URL baglama
- placement mantigi
- archive/remove etki gorunurlugu

Neden:

- ayni urunu yeniden yeniden girmek urunun ana degerini yok eder
- duplicate davranisi support ve stale-data riskini patlatir

### 5.4. Import ve verification katmani

Kesinlikle scope dahil:

- URL acceptance
- normalization
- safety check
- merchant capability registry
- extraction
- verification UI
- manual correction fallback
- failure reason classification

Neden:

- import bu urunun teknik cekirdegidir
- verification olmadan dogruluk guveni kurulamazi
- fallback olmadan unsupported merchant creator'i kitler

### 5.5. Public trust ve quality katmani

Kesinlikle scope dahil:

- disclosure kaydi
- disclosure gosterimi
- stale / missing price davranisi
- source merchant gorunurlugu
- public route ve canonical davranisi
- share preview / OG temel davranisi
- mobil performans standardi

Neden:

- recommendation urunu trust olmadan deger uretmez
- public web bu urunun asil tuketim yuzeyidir

### 5.6. Ops ve support readiness katmani

Kesinlikle scope dahil:

- import history
- issue classification
- basic runbooks
- support playbooks
- broken link ve stale pattern gorunurlugu

Neden:

- sorunlar launch sonrasi dogal olarak gelecek
- ekip ilk 15 dakikada neye bakacagini bilmek zorunda

---

## 6. Kapsam icinde ama sinirli olacak capability'ler

Bu bolum, "var ama tam kapsamli degil" alanlari tanimlar.  
Bu alanlarin siniri yazilmazsa sonradan sessizce buyurler.

### 6.1. Subscription ve plan modeli

Subscription vardir.  
Ama sinirlidir.

Ilk fazda kabul edilen:

- plan bazli limitler
- belirli ozellestirme farklari
- basic billing / entitlement mantigi

Ilk fazda kabul edilmeyen:

- agir invoicing
- advanced proration edge-case suite
- partner / enterprise contract logic

### 6.2. Search, filter ve tagging

Search ve tagging vardir.  
Ama IA omurgasi degildir.

Ilk fazda kabul edilen:

- creator tarafinda library search
- publicte yardimci filter / tag
- product ve page bulmayi kolaylastiran hafif faceting

Ilk fazda kabul edilmeyen:

- kategori browse home
- discovery feed mantigi
- shopping search engine davranisi

### 6.3. Template ve customization

Customization vardir.  
Ama kontrolludur.

Ilk fazda kabul edilen:

- preset secimi
- renk / tipografi / hero gibi kontrollu varyasyonlar
- markayi hissettiren ama yapiyi bozmayan ozellestirme

Ilk fazda kabul edilmeyen:

- drag-and-drop builder
- serbest layout editor
- disclosure ve trust alanlarini saklayacak esneklik

### 6.4. Mobile app

Mobile app vardir.  
Ama siniri nettir.

Ilk fazda kabul edilen:

- hizli import
- mini verification
- hizli publish
- son kullanilan page / shelf secimi

Ilk fazda kabul edilmeyen:

- tum bulk edit seti
- tum ops panelleri
- admin-grade deep configuration

---

## 7. Bilincli olarak sonraya birakilan alanlar

Bu alanlar "yanlis" degildir.  
Ama ilk fazin problemi olmadiklari icin ertelenir.

### 7.1. Advanced creator analytics

Neden ertelenir:

- ilk deger publish ve trust tarafinda uretilir
- creator retention dogrulanmadan analytics yatirimi erken kalir

Yeniden degerlendirme sinyali:

- private usage safhasinda duzenli kullanim ve tekrar ziyaret netlesirse

### 7.2. Multi-editor / agency-grade collaboration

Neden ertelenir:

- owner-first model once oturmalidir
- permission sistemi gereksiz erken karmasiklasir

Yeniden degerlendirme sinyali:

- anlamli sayida creator daha fazla editor talep ederse

### 7.3. White-label / brand-facing experiences

Neden ertelenir:

- B2B genisleme erken odagi dagitir
- template sistemini gereksiz buyutur

### 7.4. Viewer-side wishlist, alerts, notifications

Neden ertelenir:

- viewer utility degerli olabilir ama cekirdek problem degildir
- event ve privacy karmasikligini buyutur

### 7.5. Revenue attribution ve affiliate intelligence

Neden ertelenir:

- monetization-first yorum yaratir
- veri guvenilirligi ve entegrasyon maliyeti yuksektir

---

## 8. Bilincli non-goal listesi

Bu bolum, urunun kesinlikle gitmeyecegi alanlari baglar.

### 8.1. Checkout ve order operations non-goal'dur

Non-goal kapsamindadir:

- checkout
- cart
- order status
- fulfillment
- return / refund flows

Bu alanlar neden reddedilir:

- urunu commerce operations product'ina cevirir
- merchant ve legal yuku buyutur
- recommendation publishing tezini bozar

### 8.2. Marketplace feed non-goal'dur

Non-goal kapsamindadir:

- generic discovery home
- global creator ranking
- sponsored shopping feed

Bu alanlar neden reddedilir:

- creator-centered model ile celisir
- category-first kayma yaratir

### 8.3. Free-form website builder non-goal'dur

Non-goal kapsamindadir:

- drag-and-drop editor
- widget store
- custom page scripting

Bu alanlar neden reddedilir:

- kalite standardini ve trust gorunurlugunu bozar
- urunu yanlis kategoriye iter

### 8.4. Heavy BI suite non-goal'dur

Non-goal kapsamindadir:

- advanced revenue panel
- merchant-level conversion intelligence
- brand ops dashboard

Bu alanlar neden reddedilir:

- monetization-first urun algisi yaratir
- ilk faz degerini seyrelitir

---

## 9. Scope degisikligi nasil degerlendirilir?

Yeni bir capability onerisinde su test uygulanmak zorundadir.

### 9.1. Zorunlu sorular

1. Bu capability creator publish hizini nasil iyilestiriyor?
2. Viewer tarafinda hangi belirsizligi ortadan kaldiriyor?
3. Import, trust veya ops tarafinda hangi kritik problemi cozuluyor?
4. Hangi yeni edge-case ve support yuku getiriyor?
5. Bu capability icin hangi mevcut belge veya ADR degismek zorunda?

### 9.2. Otomatik red sinyalleri

Asagidaki cevaplar varsa varsayilan karar "red" olur:

- "rakipte var"
- "ileride lazim olabilir"
- "belki gelir getirir"
- "theme olarak daha premium hissettirir"
- "shopping hissi eksik kalmasin"

### 9.3. Scope degisikligi hangi belgeleri birlikte gunceller?

Gercek bir scope degisikligi yalnizca tek dokumana satir ekleyerek yapilamaz.  
Asgari olarak su belge ailesi birlikte etkilenir:

- bu belge
- `05-success-criteria-and-launch-gates.md`
- ilgili urun / import / design / operations belgesi
- gerekiyorsa `project/adr/` altinda yeni proje ADR'i

---

## 10. Scope kaymasi hangi orneklerde fark edilir?

### 10.1. Yanlis ornek: "Madem urunler var, sepet de ekleyelim"

Neden scope kaymasi:

- recommendation publishing yerine commerce transaction'a kayar
- merchant operasyonunu scope'a sokar

### 10.2. Yanlis ornek: "Creator'lar kendi landing page'lerini serbestce insa etsin"

Neden scope kaymasi:

- product-first / context-first yapidan builder mantigina kayar
- trust ve disclosure alanlarini zayiflatir

### 10.3. Yanlis ornek: "Launch'ta revenue dashboard olmadan pro plan satamayiz"

Neden scope kaymasi:

- monetization-first oncelik yaratir
- asil problemi cozmeyen agir analytics yukunu getirir

### 10.4. Dogru genisleme ornegi: "Unsupported merchant fallback'ini daha rehberli hale getirelim"

Neden dogru:

- creator'i cikissiz kalmaktan kurtarir
- import riskini azaltir
- support yukunu duzenler

---

## 11. Scope kararlarinin actor bazli etkisi

### 11.1. Creator owner icin

Launch gununde owner'in yapabilmesi gerekenler:

- URL ile urun eklemek
- urunu dogrulamak
- shelf veya content-linked page'e eklemek
- publish etmek
- disclosure belirtmek

Launch gununde owner'in yapmasi gerekmeyenler:

- revenue attribution okumak
- campaign ops yonetmek
- magazaya checkout eklemek

### 11.2. Viewer icin

Launch gununde viewer:

- urunu baglamiyla gorebilmeli
- trust bilgisini anlayabilmeli
- public web'de hizli deneyim yasayabilmeli

Launch gununde viewer'in beklememesi gerekenler:

- global product discovery
- account acip wishlist tutma
- shopping compare engine

### 11.3. Ops/support icin

Launch gununde ops/support:

- import issue tiplerini ayirabilmeli
- standard triage yoluna sahip olmali

Launch gununde ops/support'un sahip olmasi gerekmeyenler:

- genis BI pane ll eri
- advanced experimentation infrastructure

---

## 12. Bu belge hangi roadmap davranisini zorunlu kilar?

Roadmap:

- import ve verification once
- public trust ve page kalite once
- content-linked page once
- analytics ve genis monetization sonra

Yani roadmap'in ilk bloklari sunlarla dolu olmalidir:

- import core
- library/reuse
- page publication
- trust/disclosure
- public quality
- ops readiness

Roadmap'in ilk bloklari su alanlarla doluysa bu belge ihlal ediliyor demektir:

- checkout
- discovery feed
- heavy analytics
- builder freedoms

---

## 13. Bu belge sonraki belgelere ne emreder?

1. `03-personas-jobs-and-primary-use-cases.md` scope kararlarini actor ihtiyacina baglamalidir
2. `05-success-criteria-and-launch-gates.md` scope icindeki capability'leri launch gate'lere cevirmelidir
3. `23-creator-workflows.md` long-form manual girisi varsayilan yol yapamaz
4. `28-subscription-and-plan-model.md` plan farklarini temel urun degerinin onune koyamaz
5. `110-project-roadmap.md` scope disi alanlari ilk bloklara tasiyamaz

---

## 14. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ekip hangi capability'nin neden scope icinde oldugunu acikca savunabiliyorsa
- kapsam disi alanlar roadmap'e sessizce sizamiyorsa
- "guzel olur" talepleri urunun cekirdek problemini seyreltemiyorsa
- sonraki belgeler bu scope cizgisine gore daha detayli yazilabiliyorsa

Bu belge basarisiz sayilir, eger:

- roadmap feature enflasyonuna acik kalirsa
- checkout / marketplace / heavy analytics gibi alanlar tekrar tekrar geri donuyorsa
- context-first recommendation publishing yerine genel amacli creator suite mantigi baskinlasirsa

Bu nedenle bu belge, urunun yalnizca neleri yapacagini degil; neleri reddederek kendini koruyacagini da tanimlar.
