---
id: INITIAL-SEED-CONTENT-DEMO-DATA-PLAN-001
title: Initial Seed Content and Demo Data Plan
doc_type: seed_data_plan
status: ratified
version: 2.0.0
owner: product-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-ROADMAP-001
  - WORK-BREAKDOWN-STRUCTURE-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
  - IMPORT-ACCURACY-TEST-MATRIX-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
blocks:
  - INTERNAL-TEST-PLAN
  - LAUNCH-TRANSITION-PLAN
---

# Initial Seed Content and Demo Data Plan

## 1. Bu belge nedir?

Bu belge, `product-showcase` icin ic test, demo, support dry run, import quality audit ve rollout oncesi acceptance senaryolarinda kullanilacak seed veri setinin hangi actor, storefront, page, shelf, product, merchant ve failure/trust durumlarini kapsayacagini tanimlayan resmi seed veri planidir.

Bu belge su sorulara cevap verir:

- hangi creator profilleri temsil edilecek?
- hangi merchant tier'leri seed veri setinde zorunlu olacak?
- sadece "guzel" urunler mi, yoksa stale/blocked/duplicate gibi bozulma durumlari da mi eklenecek?
- support ve ops ekranlari hangi issue aileleriyle beslenecek?
- demo verisi ile test verisi ayni sey mi?

Bu belge sample data listesi degildir.  
Bu belge, urunun gercek davranisini olcmeye yarayan kontrollu veri omurgasidir.

---

## 2. Bu belge neden kritiktir?

Seed veri seti zayif olursa su yanlis guven duygusu olusur:

1. supported merchant'ta tek duz urunler iyi gorunur, import zorlanmaz
2. duplicate, varyant, stale price, wrong image ve disclosure farklari hic gorulmez
3. support/ops ekranlari bos veya tek tip veriyle test edilir
4. creator loop'u sadece ideal akista sorunsuz sanilir

Bu urunde demo veri, delivery kanitinin parcasi oldugu icin seed seti estetik degil temsili olmak zorundadir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` seed veri seti yalnizca vitrine hos gelen urunlerden olusmayacak; `full`, `partial`, `fallback-only` ve `blocked` merchant davranislarini; duplicate ve varyant risklerini; stale, hidden, blocked ve disclosure state'lerini; farkli creator davranislarini ve support/ops issue ailelerini temsil eden, resetlenebilir ve tekrarlanabilir bir veri rejimi kuracaktir.

Bu karar su sonuclari dogurur:

1. Demo verisi gercek riskleri saklamaz.
2. Import kalite audit'i icin ayrik merchant ve state kapsami bulunur.
3. Support ve ops yuzeyleri bos data ile dogrulanmaz.
4. Launch oncesi cohort testleri ayni seed omurgasini kullanir.

---

## 4. Seed veri tasarim ilkeleri

Bu urunde seed veri bes ilkeye dayanir:

1. persona-gercekci
2. state-zengin
3. policy-farkindalikli
4. tekrar kurulabilir
5. supportable

### 4.1. Persona-gercekci

Her seed actor, tanimli persona veya use-case ailesine dayanir.

### 4.2. State-zengin

Seed set sadece `happy path` tasimaz:

- stale
- hidden
- blocked
- duplicate candidate
- removed/unpublished

gibi durumlari da tasir.

### 4.3. Policy-farkindalikli

Disclosure, external link ve abuse policy durumlari veri setine bilincle yerlestirilir.

### 4.4. Tekrar kurulabilir

Seed veri elle uydurulan bir birikim olmaz.  
Ayni veri ailesi tekrar yuklenebilir, resetlenebilir ve cohort testleri arasinda yeniden dogrulanabilir olur.

### 4.5. Supportable

Support ve ops ekranlari icin gerekli issue aileleri seed setten uretilir; ayri sahte ticket setiyle yamalanmaz.

---

## 5. Seed veri aileleri

Bu proje icin seed veri seti alti aileye ayrilir:

1. actor ve workspace seed'i
2. storefront/page/shelf seed'i
3. product/library seed'i
4. import source ve merchant seed'i
5. trust/disclosure/policy seed'i
6. support/ops incident seed'i

---

## 6. Actor ve workspace seed planı

Asgari dort creator workspace zorunludur:

1. `creator-fitness`
2. `creator-beauty`
3. `creator-tech`
4. `creator-lifestyle-mixed`

Her biri farkli davranis test eder.

### 6.1. `creator-fitness`

Amaç:

- rutin ekipman ve supplement benzeri tekrarli urun kullanimi
- ayni urunun farkli shelf/page baglamlarinda reuse testleri

Zorunlu ozellikler:

- 1 owner
- 1 editor
- tekrarli urun placement senaryolari

### 6.2. `creator-beauty`

Amaç:

- varyant, renk/secenek ve gorsel secimi riskleri
- disclosure ve gifted, sponsored, brand_provided ayrimi

Zorunlu ozellikler:

- wrong-image ve varyant conflict olusturacak ornekler
- disclosed ve undisclosed draft farklari

### 6.3. `creator-tech`

Amaç:

- fiyat ve stok degisimi daha sik olan urunler
- stale price warning testleri
- `partial` tier merchant'lar

### 6.4. `creator-lifestyle-mixed`

Amaç:

- farkli merchant tier'lerini karistiran genel kullanim
- content-linked page ve seasonal shelf birlikte testleri

### 6.5. Actor rol varyasyonlari

Her workspace'te asgari:

- 1 owner
- 1 editor

En az bir workspace'te:

- davet bekleyen uye
- suspended veya erişimi sinirli actor simulasyonu

bulunur.

---

## 7. Storefront, shelf ve page seed yapisi

Her workspace icin asgari su yapilar kurulur:

1. 1 aktif storefront
2. 2 aktif shelf
3. 1 content-linked page
4. 1 unpublished veya archived page

### 7.1. Shelf tipleri

Asgari temsiller:

- evergreen favorites shelf
- context-based shelf

### 7.2. Content-linked page tipleri

Asgari temsiller:

- "bu videoda kullandiklarim" benzeri icerik bagli sayfa
- editoryal aciklama ve disclosure tasiyan sayfa

### 7.3. Publication state seti

Seed veri icinde asgari su state'ler bulunur:

1. `published`
2. `draft`
3. `unpublished`
4. `archived`
5. `removed-by-policy`

Kural:

`removed-by-policy` state'i yalniz compliance test ve support dry run icin kontrollu ortamda kullanilir; public demo icinde varsayilan gorunum olarak sunulmaz.

---

## 8. Product ve library seed kurallari

Her workspace icin asgari product library yapisi:

- 12-20 product canonical record
- bunlarin icinde reuse, duplicate, stale ve hidden state tasiyan ornekler

### 8.1. Product siniflari

Asgari karisim:

1. evergreen product
2. hizli fiyat degisen product
3. image ambiguity riski yuksek product
4. duplicate candidate product
5. `fallback-only` tier merchant product

### 8.2. Placement karisimlari

Seed veri seti asgari su placement davranislarini tasir:

1. ayni product birden fazla shelf'te
2. ayni product hem shelf hem content page'te
3. page icinde farkli disclosure state'li placement'lar
4. archived product'in historical placement izleri

### 8.3. Duplicate ve varyant ornekleri

Zorunlu ornekler:

1. tracking parametresi farkli ama ayni urun URL'leri
2. renk/varyant farki tasiyan merchant URL'leri
3. canonical urune baglanmasi gereken duplicate candidate'ler

---

## 9. Merchant ve import seed karisimi

Seed veri seti merchant capability registry'yi temsil etmelidir.

Asgari karisim:

1. 3 `full` tier merchant
2. 2 `partial` tier merchant
3. 2 `fallback-only` tier merchant
4. 1 `blocked` tier veya disallow edilen merchant/ornek

### 9.1. `full` tier merchant seti

Bu grup:

- structured data
- parser stability
- image/price extraction

bakimindan en guvenilir seti temsil eder.

### 9.2. Partial support merchant seti

Bu grup:

- eksik fiyat
- zayif image secimi
- review-required oranı yuksek

senaryolarini tasir.

### 9.3. Best-effort merchant seti

Bu grup:

- fallback agirlikli extraction
- creator review ihtiyaci
- publicte hide/limited trust davranislari

icin kullanilir.

### 9.4. Blocked/disallow ornek

Bu ornek:

- abuse veya link safety politikasini
- creator-facing explanatory copy'yi
- support escalation yolunu

test etmek icin seed edilir.

---

## 10. Trust, disclosure ve policy state seti

Seed veri seti asgari su trust state'leri tasir:

1. `price_current`
2. `price_stale`
3. `price_hidden`
4. `link_blocked`
5. `removed_by_policy`

Disclosure tarafinda asgari:

1. affiliate
2. gifted
3. sponsored
4. brand_provided
5. self_purchased
6. unknown_relationship

### 10.1. Neden zorunlu?

Bu state'ler olmadan:

- disclosure UI
- stale copy
- support issue family
- policy enforcement

gercekten dogrulanamaz.

### 10.2. Gosterim kuralı

Demo icinde public gosteri icin secilen veri ile test icin saklanan policy edge-case veri ayrilir.  
Ama ikisi de seed rejiminin parcasi olur.

---

## 11. Support ve ops seed seti

Ops ve support yuzeyleri icin asgari asagidaki issue aileleri seed edilir:

1. `IMPORT_NOT_FETCHED`
2. `WRONG_IMAGE`
3. `PRICE_MISSING_OR_STALE`
4. `BROKEN_OR_BLOCKED_LINK`
5. `DUPLICATE_PRODUCT`
6. `PAGE_UNPUBLISHED_OR_REMOVED`
7. `OWNERSHIP_OR_BILLING`
8. `UNSAFE_OR_ABUSIVE_CONTENT`

### 11.1. Nasıl üretilecek?

Her issue family icin:

- en az 1 acik vaka
- en az 1 cozulmus vaka
- gerekiyorsa 1 escalation-required vaka

olur.

### 11.2. Ops metric seed'i

Asgari dashboard olaylari:

- import success/failure dagilimi
- queue backlog spike simulasyonu
- parked webhook ornegi
- stale trust anomaly ornegi

Kural:

Ops panelleri yalnizca "hepsi iyi" gorunen seed ile test edilmez.

---

## 12. Seed veri miktar hedefleri

Launch oncesi ic test icin minimum hacim:

- 4 workspace
- 8 aktif shelf
- 4 content-linked page
- 50-70 product record
- 80-120 product source kaydi
- 20+ import sonuc kaydi
- 10+ support issue kaydi

Bu hacim performans testi degil; product davranisini temsil etmek icin minimumdur.

---

## 13. Seed veri uretim kaynaklari

Seed veri uc farkli kaynaktan gelebilir:

1. kurgu creator ve storefront kayitlari
2. kontrollu import sonuc fixture'lari
3. gercek merchant URL'lerden elde edilmis ama gizlilik/policy filtresinden gecmis ornekler

Kural:

Uretimden kopyalanmis rastgele veri seed rejimi sayilmaz.

---

## 14. Demo veri ile test veri farki

### 14.1. Demo veri

Amaç:

- urunun deger teklifini gostermek
- visual akislari sergilemek

Ozellik:

- daha temiz
- ama yine de disclosure/trust gercegini saklamayan

### 14.2. Test veri

Amaç:

- failure, edge-case ve supportability dogrulamak

Ozellik:

- stale
- duplicate
- blocked
- removed
- parked webhook

gibi state'ler acikca bulunur.

### 14.3. Ortak nokta

Ikisi ayni canonical seed omurgasindan uretilir;  
ayri rastgele dataset'ler olmaz.

---

## 15. Seed reset ve tekrar kurulabilirlik kurallari

Her ic test turundan once seed veri su disiplinle yeniden kurulabilir olmalidir:

1. base seed actor ve workspace seti sabitlenir
2. import fixture ve support fixture katmanlari ayri uygulanir
3. policy edge-case fixture'lari kontrollu olarak eklenir
4. test turu sonrasinda reset script veya tekrarlanabilir workflow ile geri donulur

Kural:

Elle tek tek duzeltilen data seti canonical seed sayilmaz.

---

## 16. Seed veri icinde gizlilik ve policy sinirlari

Seed veri:

1. gercek kisi verisi tasimaz
2. gereksiz PII icermez
3. support/abuse fixture'larinda masked actor kullanir
4. merchant icerigi tam arsiv gibi biriktirmez

Kural:

Demo veya test kolayligi adina privacy-data-map ilkesine aykiri seed olusturulmaz.

---

## 17. Senaryo matrisi

Seed veri seti asgari asagidaki senaryolari desteklemelidir:

1. link paste -> verify -> publish
2. duplicate candidate -> reuse confirm
3. wrong image -> correction -> republish
4. stale price -> public warning render
5. blocked link -> creator notice + public hide
6. disclosure applied -> public badge render
7. owner/editor capability farki
8. support issue -> ops escalation
9. archived page -> restore penceresi
10. removed-by-policy page -> support/compliance handling

---

## 18. Basarisiz seed ornekleri

Asagidaki seed set "var" kabul edilmez:

1. sadece tek creator ve tek merchant'tan olusan set
2. hic stale veya duplicate state icermeyen set
3. support ve ops issue family'lerini beslemeyen set
4. creator mobile ile web gecisini test etmeyen set
5. disclosure ve link policy durumlarini hic gostermeyen set

---

## 19. Seed veri owner ve guncelleme rejimi

### 19.1. Product owner

- hangi use-case'in seed icinde zorunlu oldugunu belirler

### 19.2. Engineering owner

- tekrar kurulabilirligi saglar
- fixture ve script disiplinini korur

### 19.3. Design owner

- demo verisinin public ve creator yuzeyde gercekci gorunmesini saglar

### 19.4. Support/Ops owner

- issue family fixture'larinin okunabilirligini dogrular

### 19.5. Compliance owner

- policy edge-case seed'lerinin gizlilik ve takedown sinirlarini kontrol eder

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin seed veri seti:

1. urunun ana persona ve use-case'lerini temsil etmeli
2. import, trust ve support risklerini aciga cikarmali
3. tekrar kurulabilir ve resetlenebilir olmali
4. demo ve test ihtiyacini ayni canonical omurgadan beslemelidir

---

## 21. Sonraki belgelere emirler

Bu belge asagidaki belgeler icin baglayicidir:

1. `114-internal-test-plan.md`, cohort ve senaryo planini burada tanimlanan seed veri aileleriyle kuracaktir.
2. `115-launch-transition-plan.md`, rollout boyunca hangi veri setinin internal/demo/test amacli kullanilacagini bu belgeyle hizalayacaktir.
