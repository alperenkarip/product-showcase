---
id: CREATOR-MOBILE-SCREEN-SPEC-001
title: Creator Mobile Screen Spec
doc_type: creator_mobile_design
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - CREATOR-WORKFLOWS-001
  - DESIGN-DIRECTION-BRAND-TRANSLATION-001
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC-001
blocks:
  - MOBILE-SURFACE-ARCHITECTURE
  - MOTION-FEEDBACK-MICROINTERACTION-SPEC
  - EMPTY-LOADING-ERROR-STATE-SPEC
---

# Creator Mobile Screen Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` mobil creator uygulamasindaki ana ekran ailelerini, hizli import ve verification odagini, adimli navigation yapisini, mobile ergonomi sinirlarini, owner/editor farklarinin mobile UI'a nasil yansiyacagini ve offline / retry / low-confidence gibi state'lerin nasıl tasarlanacagini tanimlayan resmi creator mobile design spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Mobil uygulama bu urunde tam editor mü, hizli operasyon araci mi?
- Quick add, processing, verification ve target picker ekranlari nasil ayrilmalidir?
- Mobile verification ekrani hangi alanlari gosterir, hangilerini web'e birakir?
- Offline, import bekleme ve unsupported merchant durumlari mobile'da nasil cozulur?
- Bottom-safe primary action ve tek-el kullanimi hangi ekranlarda kritik hale gelir?

Bu belge, mobile'i masaustunun kopyasi olmaktan cikarir.

---

## 2. Bu belge neden kritiktir?

Creator'in tekrarli kullanim davranisi buyuk olcude mobil hizina baglidir.

Mobil yuzey yanlis kurgulanirsa:

- import akisi uzun form duvarina doner
- verification sırasında kritik warning'ler gorunmez
- publish hissi belirsiz kalir
- kullanici web'e gecmeden isi tamamlayamaz

Bu urunde mobile'in gorevi "tum uygulamayi cepte tasimak" degil; en sik tekrar eden kritik creator aksiyonlarini hizlandirmaktir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Creator mobile, owner/editor actorleri icin hizli import, verification, target secimi ve hafif publish akislarinin birincil operasyon yuzeyidir; derin bulk edit, yogun organizasyon ve kapsamli ayar alanlari web'e birakilir; mobil ekranlar tek-el ergonomisi ve progressive disclosure mantigiyla tasarlanir.

Bu karar su sonuclari dogurur:

1. Mobile dashboard, vanity analytics paneli olmayacaktir.
2. Verification ekranlari tek ekranda her seyi yukleyen form olmayacaktir.
3. Kritik aksiyonlar alt bolgede ulasilabilir primary CTA ile kapanacaktir.
4. Web'e ait yogun table/bulk edit pattern'leri mobile'a zorla tasinmayacaktir.

---

## 4. Mobile tasarim ilkeleri

### 4.1. Tek-el aksiyon

Primary CTA, geri/ileri ve kritik secimler mümkün oldugunca thumb zone icinde kalmalidir.

### 4.2. Adimli derinlik

Tek ekranda her seyi gostermek yerine:

- quick add
- processing
- verification
- target selection
- confirmation

adimlari net ayrilir.

### 4.3. Correction over restart

Import zayif geldiginde creator'i basa dondurmek yerine:

- duzelt
- sec
- fallback'a gec

yollari sunulur.

### 4.4. Visible uncertainty

Low confidence durumlari mobile kucuk ekran gerekcesiyle saklanmaz.

---

## 5. Navigation modeli

Mobile navigation asgari olarak su ailelerden olusur:

1. auth/session
2. quick add/import
3. verification flow
4. library lightweight access
5. pages lightweight access
6. settings/account

### 5.1. Tab veya root aileleri

Launch icin root aileler:

- `Home/Quick Add`
- `Library`
- `Pages`
- `Settings`

### 5.2. Modal yerine full-screen flow

Asagidaki akislar modal yerine tam-screen adim olarak ele alinmalidir:

- verification
- target picker
- quick page create

Neden:

- daha net state sahipligi
- daha iyi geri donus kontrolu
- daha az modal zinciri

---

## 6. Screen family 1: Quick add entry

## 6.1. Amac

Creator'in urun eklemeye en hizli girdigi noktadir.

## 6.2. Asgari icerik

1. URL input / paste alanı
2. recent targets
3. recent imports veya pending review sinyali
4. clipboard/share intake algisi varsa hizli kabul yolu

## 6.3. Primary aksiyon

- `Import et`

### 6.4. Sekonder aksiyonlar

- `Library'den sec`
- `Manuel urun olustur`

### 6.5. Yapilmamasi gerekenler

- bu ekranı analytics summary ile doldurmak
- uzun onboarding hero'lari
- URL paste aksiyonunu ikinci plana itmek

---

## 7. Screen family 2: Import processing

## 7.1. Amac

Async job'in gorunur durumunu ve belirsizlik yönetimini saglamak.

## 7.2. Asgari icerik

1. submitted URL ozeti
2. stage bilgisi
3. bekleme / retry durumu
4. gerekiyorsa arka planda devam eder notu

## 7.3. Davranis

- kullanici ayni URL'yi tekrar spamlamak zorunda kalmaz
- processing state'i boş spinner degildir
- gecici mi kalici mi belirsizligi copy ile ayrilir

---

## 8. Screen family 3: Verification and correction

## 8.1. Amac

Import sonucunu guvenli sekilde onaylama veya duzeltme.

## 8.2. Ekran bolumleri

1. status strip
2. primary product block
3. image selection block
4. merchant/source block
5. price/availability block
6. duplicate/reuse block
7. next-step CTA area

## 8.3. Status strip

Su sinyalleri kompakt gosterir:

- confidence
- duplicate warning
- unsupported/fallback note

## 8.4. Mobile density kurali

Kurallar:

1. Tek ekranda okunabilir bloklar olmalidir.
2. Accordion kullanilabilir; ama kritik alanlar kapali baslamaz.
3. Low-confidence image/title alanlari fold altina gizlenmez.

## 8.5. Primary CTA

Duruma gore:

- `Devam et`
- `Kaydet`
- `Hedef sec`
- `Manuel duzelt`

### 8.6. Secondary CTA

- `Daha sonra tamamla`
- `Manuel urun olustur`

---

## 9. Screen family 4: Target picker

## 9.1. Amac

Creator'in urunu:

- library-only
- mevcut shelf
- mevcut content page
- yeni hedef

seceneklerinden birine hizli baglamasi.

## 9.2. Asgari icerik

1. recent targets
2. target search
3. quick create shelf
4. quick create content page
5. library-only secenegi

## 9.3. Kural

Hedef secmemek de gecerli karardir.  
Ekran creator'i zorla page olusturmaya itmez.

---

## 10. Screen family 5: Quick page create

## 10.1. Shelf quick create

Asgari alanlar:

- title
- short context

## 10.2. Content page quick create

Asgari alanlar:

- title
- content reference minimumu

## 10.3. Kural

Bu ekran tam builder degildir.  
Tam duzenleme web'e veya sonraki adima birakilir.

---

## 11. Screen family 6: Publish confirmation

## 11.1. Amac

Creator'in neyi basardigini ve sonraki adimi net gormesi.

## 11.2. Asgari icerik

1. sonuc ozeti
2. hangi target'a eklendigi
3. paylas / publicte gor / yeni urun ekle aksiyonlari

## 11.3. Yapilmamasi gerekenler

- generic success toast ile gecmek
- public etkisini anlatmadan kapatmak

---

## 12. Lightweight library ve pages access

Mobile library ve pages alanlari vardir; ama web kadar yogun degildir.

### 12.1. Library mobile

Amac:

- hizli arama
- reuse
- son eklenen urunlere donus

### 12.2. Pages mobile

Amac:

- son kullanilan shelf/content page'lere hizli erisim
- hafif edit
- publish durumu goruntuleme

### 12.3. Bilincli olarak hafif birakilanlar

- genis bulk edit
- table density
- kapsamli import history tanilama

---

## 13. Owner ve editor farkinin mobile'a yansimasi

### 13.1. Owner

Mobile'da su aksiyonlari gorebilir:

- publish
- unpublish
- archive
- kritik ayar entry'leri

### 13.2. Editor

Mobile'da su aksiyonlari gorebilir:

- import
- verify
- target secme
- draft hazirlama

Ama:

- publish final butonu
- domain/billing/ownership ile ilgili entry'ler

gorunmez veya disabled explanatory state ile gelir.

---

## 14. Offline, connectivity ve retry davranisi

### 14.1. Offline quick add

URL local draft olarak tutulabilir.  
Ama import worker sonucu offline uretilmez.

### 14.2. Verification sirasinda baglanti kesildi

Beklenen davranis:

- girilen duzeltmeler gecici olarak korunur
- yeniden baglaninca sync/retry teklifi sunulur

### 14.3. Publish sirasinda kopma

Beklenen davranis:

- sonuc bilinmiyorsa belirsizlik gizlenmez
- job/status kaydi uzerinden gercek durum tekrar okunur

---

## 15. State ve feedback ilkeleri

Mobile creator ekranlarinda su state'ler first-class gorunur:

- processing
- low confidence review required
- duplicate detected
- unsupported merchant
- offline pending
- saved as draft

Bu state'ler toast ile gecistirilmez.  
Gerekirse ekran seviyesi panel veya banner ile acikca gosterilir.

---

## 16. Visual density ve component ilkeleri

### 16.1. Cards

Cards:

- utility-first
- minimum copy
- net CTA

### 16.2. Forms

Kurallar:

1. Bir ekranda 3-5 karar grubundan fazlasi yigilmamalidir.
2. Text input sayisi minimum tutulur.
3. Default degerler creator'i yaniltmayacak sekilde kullanilir.

### 16.3. Safe area ve bottom action bar

Primary action bar:

- safe-area aware
- thumb friendly
- keyboard ile cakismayacak

---

## 17. Senaryolar

## 17.1. Senaryo A: Share sheet'ten gelen import

Beklenen deneyim:

- uygulama dogrudan quick add / processing akisine iner
- URL tekrar yazdirilmaz

## 17.2. Senaryo B: Dusuk confidence import

Beklenen deneyim:

- verification ekraninda warning görünur
- creator manual correction'a gecer

## 17.3. Senaryo C: Duplicate bulundu

Beklenen deneyim:

- mevcut product net ayirt edilir
- reuse veya new product karari kolay verilir

## 17.4. Senaryo D: Hedef sonra secilecek

Beklenen deneyim:

- library-only kaydetmek normal yoldur
- creator zorla page secmeye itilmez

---

## 18. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Mobile'ı web dashboard'un minik versiyonu gibi tasarlamak
2. Verification ekranina her alanı yığmak
3. Processing state'i boş spinner'a indirgemek
4. Primary CTA'yı ekranın üstüne taşımak ve thumb zone'u ihmal etmek
5. Editor ile owner arasındaki aksiyon farkını UI'da gizlemek

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `62-mobile-surface-architecture.md`, navigation ve local draft davranisini bu screen family'lerine gore detaylandirmalidir.
2. `56-empty-loading-error-and-state-spec.md`, mobile processing, low-confidence, unsupported ve offline state'lerini bu belgeyle uyumlu tasarlamalidir.
3. `57-motion-feedback-and-microinteraction-spec.md`, mobile verification ve publish confirmation feedback'lerini bu akislara gore belirlemelidir.

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator mobilde tekil import ve verification islerini web'e kacmadan tamamlayabiliyorsa
- low-confidence veya unsupported durumlarda cikissiz kalmiyorsa
- owner/editor farki aksiyon setinde net gorunuyorsa
- mobile yuzey utility-first kalirken urunun trust dili korunuyorsa

Bu belge basarisiz sayilir, eger:

- mobile yavas, form-agir veya modal-zincirli hale gelirse
- verification warning'leri kucuk ekran bahanesiyle kaybolursa
- publish ve save state'leri belirsiz kalirsa

