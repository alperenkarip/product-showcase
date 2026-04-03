---
id: PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC-001
title: Product Verification UI and Manual Correction Spec
doc_type: import_review_spec
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - CREATOR-WORKFLOWS-001
  - LINK-NORMALIZATION-DEDUP-RULES-001
blocks:
  - CREATOR-MOBILE-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - IMPORT-ACCURACY-TEST-MATRIX
  - MEDIA-SELECTION-IMAGE-QUALITY-RULES
---

# Product Verification UI and Manual Correction Spec

## 1. Bu belge nedir?

Bu belge, import pipeline'indan gelen verification payload'inin creator'a nasil sunulacagini, hangi alanlarin zorunlu olarak review edilecegini, confidence ve warning bilgisinin ne sekilde gosterilecegini, duplicate/reuse kararinin nasil yuzeye cikarilacagini, manual correction ve manual card fallback akisinin hangi kosullarda acilacagini tanimlayan resmi import review ve correction belgesidir.

Bu belge su sorulara cevap verir:

- Verification ekraninin ana gorevi hiz mi, dogruluk mu, yoksa ikisinin dengesi mi?
- Hangi alanlar publish veya library save icin zorunludur?
- Creator medium/dusuk confidence alanlari nasil anlamalidir?
- Reuse onerisi ekranda nasil sunulmali, ne zaman zorlayici olmalidir?
- Manual fallback ne zaman devreye girer?
- Verification UI neden basit bir CRUD formu sayilamaz?

Bu belge, import'tan sonraki kalite kapisini tanimlar.

---

## 2. Bu belge neden kritiktir?

Import kalitesi yalnizca extraction ile belirlenmez.  
Asil kalite kapisi creator review'dur.

Verification UI zayif tasarlanirsa:

- creator hiza zorlanir ama yanlis veri onaylar
- duplicate onerisi gormeden yeni product acar
- low-confidence alanlar sanki netmis gibi algilanir
- unsupported import'ta cikissiz kalir

Bu nedenle verification ekranı basit form degil, trust ve retention kapisidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Verification UI, import sonucunu "duzenlenebilir alan listesi" olarak degil; alan kaynaklari, confidence, duplicate riski ve publication etkisi acikca gorunen hizli ama guvenli bir karar ekrani olarak tasarlanir; creator kritik alanlari anlamadan tek-tik onay ile gecemez.

Bu karar su sonuclari dogurur:

1. Verification ekraninda source-of-truth ipuclari gizlenmez.
2. Dusuk confidence alanlar normal field gibi sessizce prefill edilmez.
3. Duplicate/reuse karari ekrandan ayrik dusunulmez.
4. Manual fallback istisna degil, resmi recovery yoludur.

---

## 4. Verification UI'nin amaci

Ekranin amaci su dort isi ayni anda yapmaktir:

1. Creator'e hizli review imkani vermek
2. Kritik belirsizlikleri gorunur kilmak
3. Reuse ve duplicate guardrail'ini uygulatmak
4. Persistence oncesi guvenli kapanis saglamak

Bu ekranin amaci degildir:

- exhaustive product editing studio olmak
- tasarim ozgurlugu saglamak
- her seyi tek sayfaya yigmak

---

## 5. Verification payload modeli

Verification UI asagidaki veri ailelerini gormelidir:

- normalized source bilgisi
- title ve kaynak izi
- image candidate seti
- merchant ve canonical URL
- price / currency / availability
- confidence seviyesi
- extraction warning'leri
- duplicate/reuse onerisi
- target context niyeti
- disclosure varsayilani veya gereksinimi

Kurallar:

1. Creator'e tek bir "hazir urun" degil, kanitli review nesnesi sunulur.
2. Alanin nereden geldigini UI copy olarak asiri teknik anlatmak zorunlu degildir; ama "review gerekir" mantigi gorunur olmalidir.

---

## 6. Ekran bolumleri

Verification ekraninin asgari bolumleri asagidadir.

### 6.1. Ust durum ozeti

Asagidaki sinyaller burada ozetlenir:

- merchant support seviyesi
- import confidence
- duplicate warning var mi
- manual correction zorunlu mu

### 6.2. Cekirdek product alanlari

- title
- merchant
- source URL
- primary image

Bu alanlar her zaman ilk gorunen blokta yer alir.

### 6.3. Ticari sinyaller

- price
- currency
- availability
- last checked bilgisi gerekiyorsa

### 6.4. Reuse / duplicate bolumu

Varsa mevcut product adaylari burada sunulur.

### 6.5. Hedef baglam bolumu

Creator:

- library-only kaydetme
- mevcut shelf'e ekleme
- mevcut content page'e ekleme
- hedefi sonra secme

kararini verir.

### 6.6. Gelişmis duzeltmeler

- ek image secimi
- title duzeltmesi
- merchant/source duzeltmesi
- manual fallback gecisi

---

## 7. Zorunlu alanlar ve gating kurallari

### 7.1. Library save icin zorunlu alanlar

Asgari olarak:

- title
- merchant veya anlamli source tanimi
- source URL veya manual source notu
- primary image veya bilincli gorselsiz onay

### 7.2. Target context'e placement eklemek icin ek kosullar

- hedef baglam secilmis olmali
- duplicate/reuse karari kapanmis olmali
- product minimum identity alanlari tamamlanmis olmali

### 7.3. Publish icin zorunlu olmayan ama guclu alanlar

- price
- availability
- tags
- custom note

Kural:

Price eksigi tek basina akisi bloklamaz.  
Ama price varsa yanlis guven yaratmadan gosterilmelidir.

---

## 8. Confidence ve warning davranisi

Confidence, yalnizca internal metric olarak kalmaz; UI davranisini etkiler.

### 8.1. Yuksek confidence

Beklenen davranis:

- alanlar prefill gelir
- hizli onay yolu acik olabilir
- yine de kritik alanlar gizlenmez

### 8.2. Orta confidence

Beklenen davranis:

- sorunlu alanlar vurgulanir
- creator review tavsiye edilmez, fiilen beklenir
- "kontrol etmeden gec" yolu baskin olmamalidir

### 8.3. Dusuk confidence

Beklenen davranis:

- manual correction veya manual fallback baskin cikis olur
- title/image/merchant conflict'leri acik sunulur

### 8.4. Conflict warning'leri

Ornek warning'ler:

- image ambiguity
- merchant mismatch
- duplicate candidate found
- category/listing page olabilir

Warning teknik exception diliyle degil, creator eylemini anlatan dille yazilir.

---

## 9. Reuse ve duplicate UX kurallari

### 9.1. Reuse bolumu ne zaman gosterilir?

Asagidaki durumda:

- same product olasiligi yuksek
- mevcut source veya canonical URL eslesmesi bulundu
- title/image/merchant kombinasyonu guclu duplicate sinyali veriyor

### 9.2. Reuse onerisi ne yapmalidir?

1. mevcut product'i ayirt edici veriyle gostermeli
2. neden onerildigini aciklamali
3. "yeni product ac" kararini tamamen gizlememeli

### 9.3. Reuse onerisi ne yapmamalidir?

1. creator'i zorla mevcut product'a kilitlemek
2. mevcut product hakkinda ayirt edici bilgi vermemek
3. duplicate riskini saklamak

### 9.4. Yeni product actirma guardrail'i

Creator reuse onerisine ragmen yeni product acmak isterse:

- hafif bir onay/why prompt kullanilabilir
- ama akış cezalandirici olmamalidir

---

## 10. Manual correction kurallari

### 10.1. Duzeltilebilir alanlar

Creator asgari olarak su alanlari duzeltebilir:

- title
- primary image secimi
- merchant display name veya source tercihi
- price goster / gizle karari
- availability review notu
- tag duzeltmesi

### 10.2. Duzeltme davranisi

Kurallar:

1. Original extracted deger gerekirse referans olarak gorulebilmelidir.
2. Creator override auditlenir.
3. Sonraki refresh'ler creator override'ini sessizce ezmez.

### 10.3. Duzeltme sinirlari

Verification UI tam product editor degildir.

Bu nedenle:

- template secimi burada yapilmaz
- uzun form page tasarimi burada yapilmaz
- ileri library organizasyonu burada cozulmez

---

## 11. Manual card fallback

### 11.1. Ne zaman acilir?

Asagidaki durumlarda:

- unsupported merchant
- extraction sonucu asiri zayif
- source page product detail degil
- creator extraction sonucuna guvenmiyor

### 11.2. Asgari manual card alanlari

- title
- image veya gorselsiz onay
- merchant name
- source URL
- opsiyonel price

### 11.3. Kural

Manual fallback, "basarisiz importin cop kutusu" degildir.  
Urunun resmi kurtarma yoludur.

### 11.4. Manual fallback neyi cozmez?

- unsupported merchant'i supported gibi gostermeyi
- canonical/source guvensizligini sihirli sekilde yok etmeyi

---

## 12. Save sonuc tipleri

Verification ekrani su sonuclardan biriyle kapanir:

1. `verified_saved_to_library`
2. `verified_saved_and_attached_to_context`
3. `source_attached_to_existing_product`
4. `saved_as_draft_for_later_completion`
5. `manual_card_created`
6. `import_rejected_by_creator`

Bu durumlar creator'a ve support'a ayri ayrı okunabilir olmalidir.

---

## 13. Validasyon ve hata copy kurallari

### 13.1. Teknik dili saklama kurali

Creator'e exception dump gosterilmez.

### 13.2. Eylem odakli copy

Hata veya warning su sorulara cevap vermelidir:

- ne eksik?
- neden onemli?
- simdi ne yapabilirim?

### 13.3. Ornek validasyon siniflari

- title bos
- source URL gecersiz
- `blocked` tier merchant
- duplicate tercihi kapanmadi
- image secimi gerekli
- target context yetkisiz

---

## 14. Akislar

## 14.1. Akis A: Yuksek confidence hizli review

Normal akis:

1. Creator ekranı acar.
2. Cekirdek alanlar dogru gorunur.
3. Reuse warning yoktur.
4. Creator library'e kaydeder veya hedef baglama ekler.

Beklenen davranis:

- gereksiz form duvari olusmaz
- ama kritik alanlar yine de gorunur

## 14.2. Akis B: Duplicate/reuse karari

Normal akis:

1. Sistem mevcut product onerir.
2. Creator mevcut product detayini gorur.
3. Reuse veya new product karari verir.
4. Source attach veya yeni product persistence buna gore yapilir.

## 14.3. Akis C: Dusuk confidence duzeltme

Normal akis:

1. Creator medium/low confidence warning gorur.
2. Title/image/merchant alanlarini duzeltir.
3. Gerekirse manual fallback'a duser.
4. Sonucu draft veya library save ile kapatir.

## 14.4. Akis D: Hedef baglam sonradan secilecek

Normal akis:

1. Creator urunu library'ye kaydeder.
2. Placement'i daha sonra olusturur.

Beklenen davranis:

- verification ekrani bunu dogal yol olarak destekler
- "hemen page sec" zorlamasi yapmaz

---

## 15. Failure ve edge-case senaryolari

### 15.1. Hiçbir image adayi iyi degil

Beklenen davranis:

- creator'e gorselsiz kaydetme veya manuel upload secenegi sunulur
- yanlis lifestyle image zorla secilmez

### 15.2. Merchant ve source conflict

Beklenen davranis:

- merchant mismatch warning'i acik gorunur
- creator birini secmeden otomatik persist olmaz

### 15.3. Duplicate onerisi guclu ama creator katilmiyor

Beklenen davranis:

- new product acabilir
- karar auditlenir
- sistem bunu support/gozlem icin saklar

### 15.4. Review payload eskidi

Beklenen davranis:

- creator apply etmeye calistiginda payload'in expired oldugu anlatilir
- gerekirse refresh/re-import yolu sunulur

### 15.5. Target context yetkisi yok

Beklenen davranis:

- field-level kaydetme yerine context attach adimi reddedilir
- urunu library'ye kaydetme yolu gerekiyorsa acik kalir

---

## 16. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Verification ekranini basit CRUD formu gibi tasarlamak
2. Confidence ve warning bilgisini gizlemek
3. Duplicate/reuse kararini ekran disina itmek
4. Manual fallback'i istisna veya support'e havale edilen yol gibi gormek
5. Creator override'larini sonraki refresh'te sessizce ezmek
6. Hedef baglam secimini her zaman zorunlu kilmak

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `53-creator-mobile-screen-spec.md`, hizli review ve low-confidence correction yolunu bu belgeye gore ekranlara ayirmalidir.
2. `54-creator-web-screen-spec.md`, duplicate/reuse, field evidence ve target context alanlarini masaustu yogunlugunda modellemelidir.
3. `46-media-selection-and-image-quality-rules.md`, image candidate UX ve rejection mantigini bu verification akisiyla uyumlu yazmalidir.
4. `83-import-accuracy-test-matrix.md`, field-level correction, duplicate choice ve expired payload vakalarini test etmelidir.

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator hizli review ile guvenli correction arasinda dogal bir akista hareket edebiliyorsa
- duplicate/reuse karari ekranda gercekten gorunur ve anlasilir ise
- low-confidence import'ta creator cikissiz kalmiyorsa
- manual fallback gercek bir kurtarma yolu olarak calisiyorsa

Bu belge basarisiz sayilir, eger:

- creator neyi onayladigini anlamadan import'u tamamlayabiliyorsa
- duplicate onerileri yuzeysel veya fark edilmez haldeyse
- warning ve confidence katmani sadece teknik debug verisi olarak kalip UX'e yansimiyorsa
