---
id: MOTION-FEEDBACK-MICROINTERACTION-SPEC-001
title: Motion, Feedback and Microinteraction Spec
doc_type: interaction_design
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DESIGN-DIRECTION-BRAND-TRANSLATION-001
  - EMPTY-LOADING-ERROR-STATE-SPEC-001
  - CREATOR-MOBILE-SCREEN-SPEC-001
blocks:
  - CREATOR-MOBILE-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - PUBLIC-WEB-SCREEN-SPEC
---

# Motion, Feedback and Microinteraction Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde public ve creator yuzeylerinde motion'un hangi amacla kullanilacagini, processing, verification, duplicate, reorder, publish ve error gibi kritik anlarda hangi microinteraction'larin zorunlu oldugunu, reduce-motion tercihinde neyin nasil sadeleşecegini ve feedback mekanizmasinin dekoratif animasyon degil durum anlatimi olarak nasil calisacagini tanimlayan resmi interaction design belgesidir.

Bu belge su sorulara cevap verir:

- Motion bu urunde neden "guzel gorunsun" aracindan cok state anlatim araci sayilir?
- Hangi etkileşimlerde animation gerekir, hangilerinde gereksizdir?
- Processing ve success feedback'i nasil ayrisir?
- Duplicate reveal, drag/reorder ve publish confirmation gibi anlarda ne tur motion beklenir?
- Reduced motion aktif oldugunda neyi kapatir, neyi koruruz?

Bu belge, UI hareketini sonradan eklenen efektten cikartip davranis standardina donusturur.

---

## 2. Bu belge neden kritiktir?

Bu urunde durum degisiklikleri cok onemlidir:

- import processing
- review required
- duplicate bulundu
- reorder tamamlandi
- publish oldu
- blocked veya failed sonuc geldi

Motion ve feedback zayif olursa:

- kullanici aksiyonunun karsiligini algilamaz
- processing ile donma birbirine karisir
- success ve warning ayni agirlikta hissedilir

Bu nedenle motion burada kozmetik degil, state netligi aracidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` motion dili, latency'yi gizlemek veya yuzeyi eğlenceli gostermek icin degil; kullaniciya state gecisini, eylem sonucunu ve degisen baglamı net anlatmak icin kullanilir; publicte hafif, creator tarafinda ise daha islevsel feedback odakli davranir.

Bu karar su sonuclari dogurur:

1. Long hero/page transitions yoktur.
2. Processing state motion ile maskeleme yapilmaz; status copy ile birlikte kullanilir.
3. Success, warning ve error feedback'leri ton ve ritim olarak ayrisir.

---

## 4. Motion ilkeleri

### 4.1. Purpose first

Her hareket su sorulardan en az birine cevap vermelidir:

- ne degisti?
- neyin sonucu alindi?
- kullanicinin dikkati nereye gitmeli?

### 4.2. Short and legible

Animation suresi kisa ve okunur olmalidir.

### 4.3. Do not hide system truth

Uzun beklemeyi guzel animasyonla saklamak yasaktir.

### 4.4. Spatial continuity

Ozellikle reorder, side panel, duplicate reveal ve target selection gibi durumlarda nereden nereye gectigimiz hissedilmelidir.

---

## 5. Global motion token yonu

Bu belge exact code token'i degil, davranis araligi tanimlar.

### 5.1. Hız bantlari

- fast feedback: `120-160ms`
- standard transition: `180-240ms`
- contextual reveal: `220-320ms`

### 5.2. Easing yonu

- girislerde yumusak ama kisa ease-out
- cikislarda daha hizli ease-in
- drag/reorder feedback'te fiziksel his ama abartisiz snap

### 5.3. Gecis siniri

`350ms` ustu gecisler varsayilan olarak yasaktir.  
Sadece nadir ve anlamli staged confirmation anlarinda acikca gerekcelendirilebilir.

---

## 6. Public yuzey motion kurallari

### 6.1. Page load

Publicte:

- fade/opacity tabanli hafif yukleme
- layout shifting minimum
- skeleton, final yapıya sadik

### 6.2. Card hover/press

Kurallar:

1. hafif elevation veya border emphasis olabilir
2. aggressive scale/jump kullanilmaz

### 6.3. Filter/tag interaction

Kurallar:

1. filtre degisimi sakin ama hissedilir olmalidir
2. grid tamamen patlayip tekrar kuruluyormus hissi vermemelidir

### 6.4. CTA interaction

Outbound CTA:

- press feedback verir
- ama fake "buy now urgency" animasyonu kullanmaz

---

## 7. Creator mobile motion kurallari

### 7.1. Quick add -> processing

Beklenen davranis:

- aksiyon kabul edildiği hissedilir
- tam ekran processing'e net gecis olur

### 7.2. Processing -> verification

Beklenen davranis:

- bir adim tamamlandi hissi
- sudden hard cut yerine kisa continuity

### 7.3. Duplicate reveal

Beklenen davranis:

- warning band'i veya comparison card'i belirgin ama paniksiz acilir

### 7.4. Publish confirmation

Beklenen davranis:

- kısa success confirmation
- sonraki aksiyonlar one cikar

---

## 8. Creator web motion kurallari

### 8.1. Side panel acilis/kapanis

Kurallar:

1. panel hangi listedeki secimden acildigi hissettirilir
2. panel acilisi 240ms civarini gecmez

### 8.2. Drag/reorder

Kurallar:

1. drag state net gorunur
2. drop sonrasi yeni siralama hizli ve tutarli settle olur
3. save / autosave feedback'i açık olur

### 8.3. Bulk action feedback

Kurallar:

- arka planda sessiz mutasyon yerine satir/selection feedback olur

---

## 9. Import ve verification odakli feedback

### 9.1. Processing

Gerekli feedback:

- status label
- hareketli ama sade progress hissi
- belirsiz sonsuz spinner degil

### 9.2. Review required

Gerekli feedback:

- warning emphasis
- sorunlu alanlara scroll/focus yardimi

### 9.3. Manual fallback gecisi

Gerekli feedback:

- "artik farkli moda gectik" hissi
- context kaybi yok

---

## 10. Success, warning ve error ayrimi

### 10.1. Success

Hissi:

- temiz
- kisa
- rahatlatan

### 10.2. Warning

Hissi:

- dikkat ceker
- ama panik yaratmaz

### 10.3. Error / blocked

Hissi:

- net ve sabit
- shakelı/gürültülü animasyonla dramatize edilmez

---

## 11. Microinteraction aileleri

### 11.1. Input acceptance

Paste, save, select gibi eylemlerde mikro onay gerekir.

### 11.2. Selection state

Image candidate, target picker veya duplicate seçiminde aktif durum net görünmelidir.

### 11.3. Persistence feedback

Save/publish tetiklendikten sonra:

- button disabled state
- loading label
- sonuc feedback'i

zinciri eksiksiz olmali.

---

## 12. Reduced motion kurallari

Reduced motion acikken:

1. decorative transitions kapanir
2. panel ve ekran gecisleri fade/sade crossfade'a doner
3. reorder'da minimal positional feedback korunur
4. success/error feedback renk, ikon ve copy ile tasinmaya devam eder

Kural:

Reduce motion = feedback yok demek degildir.

---

## 13. Senaryolar

## 13.1. Senaryo A: Import processing uzun surdu

Beklenen davranis:

- mikro animasyon status copy ile birlikte calisir
- kullanici sistemin dondugunu dusunmez

## 13.2. Senaryo B: Duplicate bulundu

Beklenen davranis:

- comparison area kontrollu reveal ile belirir
- dikkati yeni karar alanina tasir

## 13.3. Senaryo C: Shelf reorder

Beklenen davranis:

- drag hissi tutarli
- drop sonrasi siralama yerli yerine oturur

---

## 14. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Latency'yi animasyonla gizlemek
2. Uzun page transition'lari kullanmak
3. Success ve error için ayni feedback ritmini kullanmak
4. Drag/reorder gibi kritik eylemlerde feedback'i toast'a birakmak
5. Reduced motion modunda tum feedback'i yok etmek

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `53-creator-mobile-screen-spec.md`, processing, verification ve publish anlarini bu motion kurallariyla uyumlu ekranlamalidir.
2. `54-creator-web-screen-spec.md`, side panel, bulk action ve reorder geri bildirimini bu belgeye gore kurmalidir.
3. `52-public-web-screen-spec.md`, public hover/load/filter davranislarini bu hafif motion cizgisine gore tasarlamalidir.

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- motion kullaniciya state degisimini net anlatiyorsa
- creator akislari daha anlasilir hale geliyorsa
- public yuzeylerde hareket hafif ama anlamli kalıyorsa
- reduce motion modunda deneyim körleşmiyorsa

Bu belge basarisiz sayilir, eger:

- motion dekoratif gosteriye donusurse
- loading ile donma hissi karisiyorsa
- critical feedback yalnız renge veya yalnız toast'a birakiliyorsa

