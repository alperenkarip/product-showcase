---
id: MEDIA-SELECTION-IMAGE-QUALITY-RULES-001
title: Media Selection and Image Quality Rules
doc_type: import_media_policy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - EXTRACTION-STRATEGY-FALLBACK-ORDER-001
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
blocks:
  - FILE-MEDIA-IMAGE-ASSET-ARCHITECTURE
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - IMPORT-ACCURACY-TEST-MATRIX
---

# Media Selection and Image Quality Rules

## 1. Bu belge nedir?

Bu belge, import pipeline'inda toplanan image adaylarinin hangi kurallarla degerlendirilecegini, hangi adaylarin otomatik primary image secimine uygun oldugunu, hangi gorsel siniflarinin reddedilecegini, creator review'da image ambiguity'nin nasil gosterilecegini ve publicte kullanilan primary product image'in trust ile performans arasindaki dengesini tanimlayan resmi media secim politikasidir.

Bu belge su sorulara cevap verir:

- Neden yanlis gorsel, yanlis fiyat kadar ciddi trust problemi yaratir?
- Hangi image kaynaklari daha guvenilir sayilir?
- Auto-select icin minimum kalite esigi nedir?
- Banner, logo, promo slide ve lifestyle visual'lar neden primary image olamaz?
- Varyant veya bundle image'lari nasil ele alinir?
- Creator'in manuel image secimi neyi override eder, neyi etmez?

Bu belge, image secimini estetik tercih degil, product identity policy'si olarak ele alir.

---

## 2. Bu belge neden kritiktir?

Viewer bir card'a ilk baktiginda once image'i gorur.  
Dolayisiyla su hatalar yuksek risklidir:

- urun yerine kampanya banner'ini gosterme
- lifestyle hero image'i product image sanma
- farkli varyantin gorselini secme
- logo veya watermark-heavy promo gorseli secme

Bu urunde image kalitesi yalniz "guzel gorunmek" degildir.  
"Bu dogru urun mu?" sorusunun ilk cevaplayicisidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Primary product image, en guzel gorunen dosya degil; urunun kendisini en dogru, en ayirt edilebilir ve performans-butcesine uygun sekilde temsil eden gorseldir; otomatik secim yalnizca belirli kalite ve relevance esiklerini gecen adaylarda yapilir, aksi durumda creator review veya no-image fallback devreye girer.

Bu karar su sonuclari dogurur:

1. OG image veya hero banner otomatik olarak primary olmaz.
2. Dusuk cozunurluklu veya text-heavy gorseller auto-select edilmez.
3. Creator manuel image secimi final authority olabilir; ama auditlenir.
4. Hiç uygun image yoksa hatali image secmek yerine controlled fallback tercih edilir.

---

## 4. Image'in urunsel rolu

Primary image su amaclara hizmet eder:

1. product identity'yi hizli aktarmak
2. duplicate/reuse kararlarinda creator'e ayirt edicilik vermek
3. public card ve share preview'de guvenli ilk gorus saglamak

Primary image su amaclara hizmet etmez:

1. markasal kampanya gorseli olmak
2. category hero gorevi gormek
3. creator page estegini saglamak icin urun gercegini feda etmek

---

## 5. Candidate kaynak hiyerarsisi

Image candidate kaynaklari asagidaki otorite sirasiyla degerlendirilir:

1. merchant adapter sonucu
2. structured data `image`
3. product detail gallery veya hero adayi
4. Open Graph image
5. creator manual upload veya secim

### 5.1. Kaynak hiyerarsisinin anlami

Bu siralama mutlak auto-select demek degildir.  
Yalnizca adayin semantic gucunu belirtir.

### 5.2. Creator manuel image neden sonda ama final authority?

Liste extraction aday hiyerarsisini anlatir.  
Creator manuel upload/seçim ise verification sonrasi final karar olarak digerlerini override edebilir.

---

## 6. Auto-select icin kalite esikleri

Bir image'in otomatik primary secilebilmesi icin asgari olarak su kosullari saglamasi gerekir:

1. shortest edge en az `800 px`
2. dosya acilabilir ve bozuk degil
3. urun ana nesnesi gorunur
4. promo text, logo veya banner baskin degil
5. image relevance puani kabul edilebilir

### 6.1. Sinirli kabul seviyesi

`600-799 px` arasi gorseller:

- creator review ile kabul edilebilir
- ama varsayilan auto-select adayi sayilmaz

### 6.2. Auto-reject seviyesi

`600 px` altindaki shortest edge:

- auto-select edilmez
- gerekiyorsa creator explicit onayi gerekir

---

## 7. Relevance scoring ilkeleri

Image secimi yalniz resolution ile belirlenmez.  
Asagidaki sinyaller birlikte degerlendirilir:

1. urun merkezde mi?
2. gorselin odagi product mi?
3. arka plan banner/promosyon mu?
4. birden cok product mi var?
5. varyant farki asiri belirgin mi?
6. crop kartta calisabilir mi?

### 7.1. Yuksek relevance sinyalleri

- tek product merkezi kadraj
- temiz urun packshot
- belirgin product isolation
- adapter veya structured data ile uyum

### 7.2. Dusuk relevance sinyalleri

- lifestyle sahne
- model/fon baskin
- birden fazla urun kolaji
- text overlay
- logo/sale sticker agirligi

---

## 8. Reddedilecek image siniflari

Asagidaki siniflar primary image olarak kabul edilmez:

1. marka logosu
2. category hero veya page banner
3. kampanya slider gorseli
4. watermark veya metin yogun promo gorseli
5. video thumbnail'i
6. asiri dusuk cozunurluklu image
7. sadece packaging detail olmayan ama urunu gostermeyen crop

### 8.1. Text overlay esigi

Promo metni veya badge alani gorunur image alaninin yaklasik `%20` veya daha fazlasini kapliyorsa auto-reject uygulanir.

### 8.2. Multi-product kolaj

Bir image birden fazla ayirt edilemez urun tasiyorsa:

- primary image olmaz
- ambiguity adayi sayilir

---

## 9. Aspect ratio ve crop kurallari

Public surfaces farkli oranlarda image kullanabilir.  
Ama primary image secimi crop'a kurban edilmemelidir.

### 9.1. Tercih edilen oran araligi

Asagidaki oranlar tercih edilir:

- `1:1`
- `4:5`
- `3:4`

### 9.2. Kabul edilebilir ama review isteyen oranlar

- `16:9`
- cok dar portrait oranlar

### 9.3. Crop ilkesi

Kurallar:

1. Product'in ana nesnesi crop sonrasi kaybolmamali.
2. Auto-crop sonucu urun kesiliyorsa image auto-select edilmez.
3. Public variant uretilirken safe crop mantigi kullanilir; source image tahrip edilmez.

---

## 10. Varyant ve bundle davranisi

### 10.1. Varyant image'i

Renk, beden veya model varyantini acikca gosteren image'ler:

- source variant bilgisi netse kabul edilebilir
- product identity belirsizse creator review ister

### 10.2. Bundle image'i

Birden fazla urunu ayni pakette gosteren image:

- tekil product import'ta primary secilmez
- bundle listing oldugu netse ayri product modeli gerektirir

### 10.3. Marketplace seller farki

Ayni urun farkli seller'larda farkli background veya promo sticker ile gelebilir.

Kurallar:

1. product identity korunuyorsa cleaner image secilebilir
2. seller-specific promo sticker primary image secimini bozmamalidir

---

## 11. Creator review davranisi

Image ambiguity varsa verification UI su imkanlari vermelidir:

1. birden fazla aday gosterme
2. sistemin onerilen secimini isaretleme
3. creator'in farkli aday secmesine izin verme
4. gerekirse manuel upload veya no-image onayi sunma

### 11.1. Creator override

Creator manuel secim yaptiginda:

- public primary image bu olur
- sonraki extraction refresh'leri bunu sessizce ezmez
- ama mevcut source image'lar candidate olarak kayitta kalabilir

### 11.2. Override siniri

Creator urunle tamamen ilgisiz dekoratif image'i primary yaparsa bu product trust'ini bozar.

Bu nedenle:

- manual upload serbesttir
- ama moderation/compliance veya support review gerektirebilecek abuse sinyali tutulur

---

## 12. No-image fallback

Bazen hicbir image adayi uygun olmaz.

Bu durumda:

1. hatali image secmek zorunlu degildir
2. controlled placeholder veya no-image state kullanilir
3. creator'e manual upload yolu sunulur

Kural:

Yanlis gorsel, hic gorselden daha kotu olabilir.

---

## 13. Performans ve asset maliyeti sinirlari

Primary image secimi kalite kadar performans da dikkate alir.

Kurallar:

1. Asiri buyuk orijinal dosya publicte dogrudan servis edilmez.
2. Variant ve optimized derivative'lar media architecture tarafinda uretilir.
3. Secilmeyen adaylar kalici ana asset gibi tutulmaz.

### 13.1. File size siniri

Auto-select edilen source image icin hedef optimize public varyant boyutu:

- ana card varyanti: `300 KB` alti
- detail/share varyanti: `600 KB` alti

Bu performans hedefidir; source image boyutuna bakilarak optimize edilir.

---

## 14. Senaryolar

## 14.1. Senaryo A: Structured data image net ve yuksek kalite

Beklenen davranis:

- auto-select olabilir
- creator review'da one cikar

## 14.2. Senaryo B: OG image guzel ama product degil

Beklenen davranis:

- candidate havuzunda kalir
- primary olmaz

## 14.3. Senaryo C: Coklu benzer gallery image

Beklenen davranis:

- AI ranking yardim edebilir
- creator review zorunlu olabilir

## 14.4. Senaryo D: Hic uygun image yok

Beklenen davranis:

- no-image fallback
- manual upload opsiyonu

---

## 15. Failure ve edge-case senaryolari

### 15.1. Source image sonradan silindi

Beklenen davranis:

- cached variant veya fallback devreye girer
- trust bozan broken-image deneyimi birinci tercih olmaz

### 15.2. Lifestyle image urun gorseli sanildi

Beklenen davranis:

- relevance puani dusurulur
- creator review gerekir

### 15.3. Product image'da watermark var

Beklenen davranis:

- text-heavy/promo reject sinyaline girer
- cleaner alternatif yoksa creator explicit karar verir

### 15.4. Low-res image tek secenek

Beklenen davranis:

- auto-select edilmez
- creator isterse bilincli kabul eder

---

## 16. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. En buyuk boyutlu image'i otomatik primary secmek
2. OG image'i sorgusuz kabul etmek
3. Logo, banner ve promo gorselleri product image yerine kullanmak
4. Yanlis image yerine no-image fallback'i reddetmek
5. Creator override'ini sonraki refresh ile sessizce ezmek
6. Performans butcesini gorsel kalite bahanesiyle yok saymak

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `66-file-media-and-image-asset-architecture.md`, source image ile optimized public asset ayrimini ve secilmeyen adaylarin lifecycle'ini bu policy'ye gore derinlestirmelidir.
2. `52-public-web-screen-spec.md`, no-image, stale image ve trust row davranisini bu belgeyle uyumlu tasarlamalidir.
3. `54-creator-web-screen-spec.md`, candidate picker ve manual override akislarini bu belgeye gore gostermelidir.
4. `83-import-accuracy-test-matrix.md`, wrong-OG-image, low-res-only, multi-product-collage ve variant-image vakalarini test etmelidir.

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- viewer ilk bakista dogru urunu gordugune guvenebiliyorsa
- image ambiguity verification ekraninda gercekten cozuluyorsa
- yanlis image secimi yerine kontrollu fallback tercih edilebiliyorsa
- kalite ve performans hedefleri birlikte korunuyorsa

Bu belge basarisiz sayilir, eger:

- promo/lifestyle gorseller product image diye cikiyorsa
- dusuk kalite image'lar sessizce auto-select ediliyorsa
- creator override ve source refresh surekli birbirini eziyorsa

