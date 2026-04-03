---
id: PROBLEM-VALIDATION-FRICTION-MAP-001
title: Problem Validation and User Friction Map
doc_type: research_validation
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - MARKET-LANDSCAPE-COMPETITOR-MAP-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
blocks:
  - CREATOR-WORKFLOWS
  - VIEWER-EXPERIENCE-SPEC
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC
  - EMPTY-LOADING-ERROR-STATE-SPEC
  - SUPPORT-PLAYBOOKS
---

# Problem Validation and User Friction Map

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun hangi gercek surtunmeleri cozdugunu, bu surtunmelerin hangi actor'lerde nasil görundugunu, hangi problemlerin en yuksek siddetli sayildigini ve bu problemlerin urun kararlarina nasil tercume edilmesi gerektigini tanimlayan resmi problem-validation belgesidir.

Bu belge su sorulara cevap verir:

- Creator tarafinda hangi acilar gercek ve tekrarli?
- Viewer tarafinda hangi belirsizlikler urun degerini dusuruyor?
- Ops ve support tarafinda hangi korlukler gercek risk yaratiyor?
- Hangi friksiyonlar birincil, hangileri ikincil?
- Hangi friksiyonlar ürün tarafinda capability'ye dönüşmek zorunda?

Bu belge olmadan problem dili yuzeysel kalir.  
Ve urun kararlari "guzel olur" seviyesi icgoruyle verilir.

Bu belge bunun yerine su sekilde konusur:

- sorun nedir
- kim icin sorundur
- nasil gorunur
- neden kritiktir
- urun cevabi ne olmali

---

## 2. Bu belge neden kritiktir?

Urun fikri tek basina dogru problem dogrulamasi sayilmaz.

`product-showcase` gibi bir urun icin en buyuk risklerden biri sudur:

> Gercek, tekrar eden ve pahali bir sürtünmeyi çözmek yerine; estetik ama ikincil bir rahatsizligi cozmeye calismak.

Ornek:

- "creator'lar daha guzel storefront istiyor" tek basina yeterli problem tanimi degildir
- "tek linkte urunler olsun" tek basina yeterli problem tanimi degildir

Gercek problem ancak aktor bazli goruldugunde aciga cikar:

- creator tekrarli urun ekleme maliyeti yasiyor mu?
- viewer baglam ve trust eksikligi yasiyor mu?
- ops quality issue'lari gorebiliyor mu?
- support issue tiplerini ayirabiliyor mu?

Bu belge bu sorulari urun kararina donusturur.

---

## 3. Problem validation'in ana karari

Bu belge icin en kritik karar sudur:

> Bu urunun birincil problemi estetik eksikligi degil; creator tarafinda publish sürtünmesi, viewer tarafinda context ve trust eksigi, operasyon tarafinda ise import ve issue gorunurlugu eksigidir.

Bu karar bağlayicidir.

Sonuclari:

1. Theme ve gorsel kalite onemlidir ama cekirdek problem degildir
2. URL import ve verification birincil problem alanidir
3. Context-linked page yalnizca "guzel ek sayfa" degil, friction cevabidir
4. Trust/disclosure ikincil compliance notu degil, viewer friction cevabidir
5. Support ve ops readiness launch sonrasi ek is degil, problem cozumunun parcasidir

---

## 4. Problem validation kaynaklari

Bu belge, su iki temel giris uzerinden yorumlanir:

1. `creator_product_vitrine_arastirma_raporu_2026.md`
2. `icerik-bazli-urun-vitrini.md`

Bu kaynaklardan cikan baglayici cikarimlar:

- kategori ana omurga olmamalidir
- creator once hiz, sonra tasarim ister
- viewer once baglam, sonra ekstra bilgi ister
- public web web-first dusunulmelidir
- import accuracy urunun kaderini belirler
- fitness ilk wedge olarak mantiklidir

Bu belge bu cikarimlari actor bazli surtunme haritasina cevirir.

---

## 5. Friction siddeti nasil okunur?

Bu belgede her friction su uc kriterle okunur:

1. **Siklik**: ne kadar tekrar eder?
2. **Etki**: actor davranisini ne kadar bozar?
3. **Guven etkisi**: urun algisini ne kadar hizli bozar?

Bu uc kriterle friction'ler su seviyelerde yorumlanir:

- `P1`: cekirdek ve launch once zorunlu
- `P2`: onemli ama ikinci halka
- `P3`: faydali ama cekirdek olmayan

---

## 6. Creator friction haritasi

### 6.1. Friction C1: Daginik urun anlatimi

Tanım:
Creator ayni urunleri farkli platformlarda, farkli postlarda, farkli linklerde daginik sekilde sunar.

Nasil gorunur:

- comment ve DM'de tekrarli "hangi urun?" sorusu
- eski video aciklamalarinda kopuk merchant linkleri
- bio linkte baglamsiz urun listesi

Siklik:
Yuksek

Etki:
Yuksek

Guven etkisi:
Orta

Oncelik:
`P1`

Urun cevabi:

- storefront
- shelf / collection
- content-linked page

### 6.2. Friction C2: Her urun icin yeniden veri girisi

Tanım:
Creator yeni urun ekleme isini zahmetli bulur; yeterli otomasyon yoksa davranis sürekliligi bozulur.

Nasil gorunur:

- urun eklemek ertelenir
- vitrin guncel kalmaz
- ayni urun tekrar tekrar manuel yazilir

Siklik:
Yuksek

Etki:
Cok yuksek

Guven etkisi:
Dolayli ama yuksek

Oncelik:
`P1`

Urun cevabi:

- URL-first import
- verification UI
- reusable product library

### 6.3. Friction C3: Baglamsiz link listesi

Tanım:
Creator urunu neden önerdiğini ya da hangi icerikte kullandigini tasiyamaz.

Nasil gorunur:

- urunler sadece merchant link olarak dizilir
- "used in this video" ihtiyaci cevaplanmaz

Siklik:
Yuksek

Etki:
Yuksek

Guven etkisi:
Orta

Oncelik:
`P1`

Urun cevabi:

- content-linked page
- creator note
- placement-level context

### 6.4. Friction C4: Yanlis veya stale fiyat korkusu

Tanım:
Creator fiyat bilgisini gosterirse stale olmasindan, gostermezse eksik görünmekten cekinir.

Nasil gorunur:

- price alanini tumden kapatma istegi
- publicte yanlış beklenti
- support ticket'lari

Siklik:
Orta

Etki:
Yuksek

Guven etkisi:
Cok yuksek

Oncelik:
`P1`

Urun cevabi:

- price freshness strategy
- stale / hidden / unavailable davranisi
- source timestamp gorunurlugu

### 6.5. Friction C5: Disclosure verme riski

Tanım:
Creator, affiliate/sponsored/gifted gibi durumlari düzgün göstermedigi durumda guven kaybi veya policy riski yasar.

Siklik:
Orta

Etki:
Yuksek

Guven etkisi:
Cok yuksek

Oncelik:
`P1`

Urun cevabi:

- disclosure data modeli
- visible trust layer

### 6.6. Friction C6: Ayni urunun birden fazla yerde yasamasi

Tanım:
Creator ayni urunu farkli context'lerde kullanirken, degisikligin nereye etki ettigini anlamayabilir.

Siklik:
Orta

Etki:
Yuksek

Guven etkisi:
Orta

Oncelik:
`P1`

Urun cevabi:

- product / placement ayrimi
- remove vs delete farki
- impact visibility

### 6.7. Friction C7: Unsupported merchant

Tanım:
Creator desteklenmeyen veya dusuk destekli merchant'ta ne yapacagini bilemez.

Siklik:
Orta

Etki:
Yuksek

Guven etkisi:
Orta

Oncelik:
`P1`

Urun cevabi:

- merchant capability registry
- unsupported merchant fallback
- manual correction guidance

---

## 7. Creator tarafinda en yuksek siddetli cikarimlar

Bu belgeye gore creator tarafinda en yuksek siddetli cikarimlar sunlardir:

1. En buyuk retention belirleyicisi onboarding degil, tekrarli urun ekleme maliyetidir
2. Library ve reuse yoksa urun duzenli kullanilmaz
3. Content-linked page olmayan model, urunun farklastirici degerini zayiflatir
4. Disclosure ve stale davranisi creator icin UX ayrintisi degil, guven gereksinimidir

---

## 8. Viewer friction haritasi

### 8.1. Friction V1: Icerikte gecen urunu bulamama

Tanım:
Viewer belirli bir urunu veya urun setini arar ama daginik linkler nedeniyle bulmakta zorlanir.

Nasil gorunur:

- yeniden sosyal platforma donup arama
- yorum / DM sorma
- sayfadan cikma

Siklik:
Yuksek

Etki:
Yuksek

Guven etkisi:
Orta

Oncelik:
`P1`

Urun cevabi:

- content-linked page
- clear shelf/page structure

### 8.2. Friction V2: Baglam eksigi

Tanım:
Viewer urunu gorur ama neden orada oldugunu anlamaz.

Nasil gorunur:

- urun kartlari sadece title + image + link olur
- recommendation hissi zayiflar

Siklik:
Yuksek

Etki:
Yuksek

Guven etkisi:
Yuksek

Oncelik:
`P1`

Urun cevabi:

- creator note
- placement context
- page-level intro

### 8.3. Friction V3: Trust/disclosure belirsizligi

Tanım:
Viewer urunun sponsorlu mu affiliate mi gerçek kullanima mi dayandigini anlayamaz.

Siklik:
Orta

Etki:
Yuksek

Guven etkisi:
Cok yuksek

Oncelik:
`P1`

Urun cevabi:

- visible disclosure
- trust layer

### 8.4. Friction V4: Yavas ve dağinik mobil public sayfa

Tanım:
Viewer sosyal platformdan cikar, public sayfa acilir ama yavas veya asiri daginiktir.

Siklik:
Yuksek

Etki:
Yuksek

Guven etkisi:
Yuksek

Oncelik:
`P1`

Urun cevabi:

- web-first performance
- public screen simplification

### 8.5. Friction V5: Stale veya missing price belirsizligi

Tanım:
Viewer price gorurse bunun guncelliginden emin degildir; gormezse urun eksik gibi hissedebilir.

Siklik:
Orta

Etki:
Orta

Guven etkisi:
Cok yuksek

Oncelik:
`P1`

Urun cevabi:

- stale policy
- hidden / unavailable copy strategy

### 8.6. Friction V6: Creator vanity page hissi

Tanım:
Viewer urun ararken buyuk bio/hero alanlari ve zayif urun gruplariyla karsilasir.

Siklik:
Orta

Etki:
Orta

Guven etkisi:
Orta

Oncelik:
`P2`

Urun cevabi:

- context/product-first public IA

---

## 9. Viewer tarafinda minimum bilgi ihtiyaci

Bu belgeye gore viewer'in karar verebilmesi icin asgari su alanlar gerekir:

1. urun basligi
2. ana gorsel
3. baglam veya creator note
4. disclosure / trust durumu
5. merchant kimligi
6. varsa price durumu ve guncellik sinyali

Bu alanlardan biri eksik olabilir; ama birden fazlasi eksildiginde "tek-link degeri" hizla zayiflar.

---

## 10. Ops ve support friction haritasi

### 10.1. Friction O1: Failed import nedeninin belirsizligi

Tanım:
Issue olusur ama "neden?" sorusu issue tipi bazli cevaplanamaz.

Siklik:
Orta

Etki:
Cok yuksek

Guven etkisi:
Dolayli ama yuksek

Oncelik:
`P1`

Urun cevabi:

- structured failure taxonomy
- import trail

### 10.2. Friction O2: Merchant support seviyesinin belirsizligi

Tanım:
Ekip bir merchant/domain icin sistemin ne kadar destek verdigini net bilmez.

Oncelik:
`P1`

Urun cevabi:

- capability registry
- tier tanimi

### 10.3. Friction O3: Unsafe link veya redirect riski

Tanım:
Zararli veya policy-riskli linkler normal import gibi ele alinabilir.

Oncelik:
`P1`

Urun cevabi:

- safety policy
- block / escalation yolu

### 10.4. Friction O4: Broken linklerin gec fark edilmesi

Tanım:
Viewer sorunu yasayana kadar ekip broken link'ten habersiz olabilir.

Oncelik:
`P1`

Urun cevabi:

- refresh / broken link izleme

### 10.5. Friction O5: Support'un issue tiplerini karistirmasi

Tanım:
Unsupported merchant, wrong extraction, duplicate confusion, stale price ve broken link tek issue gibi ele alinir.

Oncelik:
`P1`

Urun cevabi:

- support taxonomy
- playbook'lar

---

## 11. En kritik friction'lerin actor bazli öncelik matrisi

| Friction | Creator | Viewer | Ops | Support | Oncelik |
| --- | --- | --- | --- | --- | --- |
| Yeni urun ekleme maliyeti | Cok yuksek | Dolayli | Orta | Orta | P1 |
| Context eksigi | Orta | Cok yuksek | Dusuk | Dusuk | P1 |
| Trust / disclosure belirsizligi | Yuksek | Cok yuksek | Orta | Orta | P1 |
| Wrong extraction | Cok yuksek | Yuksek | Cok yuksek | Yuksek | P1 |
| Duplicate confusion | Yuksek | Dusuk | Orta | Yuksek | P1 |
| Broken link | Orta | Yuksek | Yuksek | Yuksek | P1 |
| Theme esnekligi eksigi | Dusuk | Dusuk | Dusuk | Dusuk | P3 |

Bu matris bir seyi acikca gosterir:

Theme ve kozmetik ozgurluk kritik problem degildir.  
Import, context, trust ve ops gorunurlugu kritik problemdir.

---

## 12. Problem validasyonundan cikan zorunlu urun cevaplari

Bu friction haritasi su capability'leri optional olmaktan cikarir:

1. URL-first import
2. verification UI
3. reusable product library
4. content-linked page
5. visible disclosure
6. stale / missing price behavior
7. issue taxonomy
8. broken link / failure observability

Bu maddeler "ileride eklenir" diye sonraya atilamaz.

---

## 13. Hangi friction'ler ikincildir?

Bu urunde su alanlar degerli olabilir ama ilk cekirdek problem degildir:

1. cok sayida theme secenegi
2. derin analytics dashboard
3. genis custom page builder
4. geniş social automation katmani

Bu alanlar friction olarak tamamen yok degildir; ama `P1` degildir.  
Bu ayrim roadmap'i korur.

---

## 14. Private testte yeniden dogrulanmasi gereken alanlar

Bu belge her seyi son kez kapatmaz.  
Private testte su varsayimlar tekrar ölçülmelidir:

### 14.1. Fitness wedge retention etkisi

Soru:
Fitness segmenti gerçekten daha duzenli tekrar kullanim uretir mi?

### 14.2. Price gosterme davranisi

Soru:
Creator'lar price'i ne kadar acik gostermek istiyor, ne kadar sik gizlemeyi tercih ediyor?

### 14.3. Editor ihtiyaci

Soru:
Editor role'u ilk dalgada ne kadar gercek kullanim görüyor?

### 14.4. Entry behavior

Soru:
Trafik daha cok storefront ana sayfaya mi geliyor, yoksa content page'lere mi?

### 14.5. Manual correction toleransi

Soru:
Creator hangi seviyeden sonra manual correction'ı yorucu buluyor?

Bu sorularin cevabi roadmap ve launch tuning icin gereklidir.

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `23-creator-workflows.md` yeni urun ekleme maliyetini minimum adimla cozmeye odaklanmalidir
2. `24-viewer-experience-spec.md` context ve trust alanlarini viewer minimum bilgi setine gore yazmalidir
3. `44-product-verification-ui-and-manual-correction-spec.md` wrong extraction ve low-confidence friction'lerine detayli cevap vermelidir
4. `56-empty-loading-error-and-state-spec.md` unsupported merchant, broken link ve removed content state'lerini acik yazmalidir
5. `103-support-playbooks.md` issue taxonomy'yi bu friction map ile uyumlu kurmalidir

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- urunun hangi gerçek sürtünmeleri cozdüğü actor bazli netlesiyorsa
- import, trust, context ve ops gorunurlugunun neden cekirdek oldugu acik hale geliyorsa
- tasarim ve scope tartismalarinda ikincil problemler ile birincil problemler karistirilmiyorsa

Bu belge basarisiz sayilir, eger:

- hala urunun en buyuk probleminin "daha guzel vitrin" oldugu dusunuluyorsa
- support ve ops friction'leri product problem olarak görülmuyorsa
- creator velocity ile viewer trust arasindaki bag yeterince kurulamiyorsa

Bu nedenle bu belge, urunun gercekten neyi cozmek zorunda oldugunu actor bazli baski haritasi olarak tanimlar.
