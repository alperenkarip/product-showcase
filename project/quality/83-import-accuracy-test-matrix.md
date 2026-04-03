---
id: IMPORT-ACCURACY-TEST-MATRIX-001
title: Import Accuracy Test Matrix
doc_type: evaluation_matrix
status: ratified
version: 2.0.0
owner: product-quality
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - EXTRACTION-STRATEGY-FALLBACK-ORDER-001
  - MERCHANT-CAPABILITY-REGISTRY-001
  - MEDIA-SELECTION-IMAGE-QUALITY-RULES-001
  - TEST-STRATEGY-PROJECT-LAYER-001
blocks:
  - RELEASE-READINESS-CHECKLIST
  - RISK-REGISTER
---

# Import Accuracy Test Matrix

## 1. Bu belge nedir?

Bu belge, `product-showcase` import sisteminin hangi alanlarda hangi dogruluk beklentisini karsilamasi gerektigini, merchant tier'lerine gore hangi alanlarda tam otomasyon beklenip hangi alanlarda review-required davranisinin kabul edilebilir sayildigini, fail siniflarini ve tier promotion/demotion kararlarinda hangi test paketlerinin kullanilacagini tanimlayan resmi import kalite matrisidir.

Bu belge su sorulara cevap verir:

- Import kalitesini neye gore olcuyoruz?
- Title, merchant, canonical URL, image, price, availability ve variant gibi alanlarda beklenti nedir?
- Full, partial ve fallback-only tier'lerde acceptance cizgisi nasil degisir?
- Hangi hata sessiz kabul edilebilir, hangi hata mutlak fail sayilir?
- Review-required davranisi ne zaman pass, ne zaman fail kabul edilir?
- Bir merchant ne zaman tier promotion veya tier downgrade alir?

---

## 2. Bu belge neden kritiktir?

Bu urunde import kaliteyi yalniz "ne kadar alan doldurduk?" uzerinden okumak tehlikelidir.

Yanlis ama dolu bir import, eksik ama durust bir import'tan daha zararlidir.

Tipik riskler:

1. Wrong product page'i supported saymak
2. Primary image'i yanlis secmek
3. Canonical URL'yi tracking varyasyonu sanip duplicate product uretmek
4. Price'ı current gibi gostermek ama currency veya freshness kaniti olmamak
5. Variant ambiguity'yi sessizce tek product'a gommek

Bu nedenle bu matris completeness degil, correctness + honesty uzerine kuruludur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Import basarisi yalnizca alan cikarimi ile degil, belirsizlik aninda dogru davranisla olculur; `full` tier merchant'larda kritik alanlarda yuksek otomatik dogruluk beklenir, `partial` tier'de insan review'u ile destekli kalite modeli kabul edilir, `fallback-only` tier'de ise completeness yerine guvenli degrade zorunludur.

Bu karar su sonuclari dogurur:

1. Review-required sonuc bazi durumlarda pass olabilir.
2. Wrong-merchant, wrong-product, wrong-primary-image ve dangerous-price-state her tier'de agir fail sayilir.
3. Tier promotion yalniz happy path ile degil, adversarial vaka setiyle verilir.

---

## 4. Degerlendirme eksenleri

Import kalite matrisi on ana eksende olculur:

1. merchant identity
2. canonical URL
3. product title
4. brand / variant understanding
5. primary image selection
6. price extraction
7. currency extraction
8. availability extraction
9. duplicate/reuse candidate quality
10. honesty / degrade behavior

Kural:

Son madde digerlerinden ayrik degildir.  
Belirsizlikte review-required veya hide davranisi yoksa alan dogrulugu yuksek olsa bile kalite zayif sayilabilir.

---

## 5. Kritik alanlar ve fail agirligi

Kritik alanlar:

- merchant identity
- canonical URL
- primary image
- wrong-product detection
- selected source suitability

Bu alanlardaki hatalar:

- `critical fail`
- `tier downgrade trigger`
- `release blocker` olabilir

Orta kritik alanlar:

- title
- brand
- price
- availability

Dusuk ama izlenen alanlar:

- subtitle benzeri yancil metinler
- nice-to-have meta alanlar

---

## 6. Merchant tier bazli kalite modeli

### 6.1. Full tier ne demektir?

Deterministic ve guvenilir extraction davranisi beklenen merchant.

### 6.2. Partial tier ne demektir?

Bazi alanlar guvenilir, bazilari review ile kapanan merchant.

### 6.3. Fallback-only ne demektir?

Deterministic extraction zayif; sistemin esas gorevi dogru degrade olup creator'i review/correction ile guvenli yola sokmaktir.

---

## 7. Alan bazli beklenti matrisi

| Alan | Full tier hedefi | Partial tier hedefi | Fallback-only hedefi |
| --- | --- | --- | --- |
| Merchant | `%100` dogru | `%100` dogru | `%100` dogru |
| Canonical URL | `%99+` | `%95+` | `%90+` veya review-required |
| Product title | `%98+` anlamsal dogruluk | `%92+` | `%80+` veya review-required |
| Brand | `%95+` | `%85+` | review ile kabul |
| Primary image | `%97+` dogru urun gorseli | `%90+` veya review-required | otomatik secim zorunlu degil, review/human secimi kabul |
| Price + currency | mevcutsa `%95+` dogru parse | mevcutsa `%85+`, yoksa durust hide | otomatik price pass zorunlu degil, false-current yasak |
| Availability | `%90+` | `%75+` veya `unknown` degrade | `unknown` degrade kabul |
| Variant understanding | yanlis merge yok | ambigu ise review-required | review-required varsayilan |
| Reuse suggestion | yuksek precision | orta-yuksek precision | dusuk recall kabul, yanlis otomatik merge yasak |

Not:

Yuzdeler salt string eslesmesi degil, insan audit ve rule-based scoring ile yorumlanir.

---

## 8. Dogruluk tanimlari

### 8.1. Merchant dogrulugu

Source'un hangi merchant'a ait oldugunu yanlissiz anlamak.

Fail ornekleri:

- marketplace icindeki seller domain'ini merchant sanmak
- redirect hedefini dogru okuyamamak

### 8.2. Canonical URL dogrulugu

Tracking, affiliate veya kampanya parametrelerinden temizlenmis, duplicate anahtarina uygun URL uretmek.

Fail ornekleri:

- ayni product icin iki farkli canonical kayit cikarmak
- non-product page'i canonical sanmak

### 8.3. Title dogrulugu

Anlamsal olarak dogru urun basligini cikarmak.

Fail ornekleri:

- page heading yerine kategori basligini title sanmak
- bundle / set bilgisini dusurmek

### 8.4. Primary image dogrulugu

Secilen gorselin gercek urunu ve varyanti temsil etmesi.

Fail ornekleri:

- lifestyle banner'i primary image secmek
- farkli renkte/farkli varyant gorseli secmek

### 8.5. Honesty / degrade dogrulugu

Belirsizligi review-required, hidden-by-policy veya `unknown` ile dogru ifade etmek.

Fail ornekleri:

- currency bilinmiyorken current price gibi gostermek
- wrong image secip confidence'i yuksek gostermek

---

## 9. Pass / fail siniflari

Her vaka sonucu asagidaki siniflardan birine girer:

- `pass`
- `pass-with-review`
- `soft-fail`
- `critical-fail`

### 9.1. `pass`

Beklenen alanlar tier hedefini karsilar, trust degrade gerekmez.

### 9.2. `pass-with-review`

Sistem gerekli belirsizligi dogru tespit eder ve review-required davranisla guvenli cikis sunar.

### 9.3. `soft-fail`

Kritik olmayan alan yanlistir veya eksiktir; tier health'i izlenir ama tek basina release blocker olmayabilir.

### 9.4. `critical-fail`

Asagidaki ailelerden biri varsa:

- wrong merchant
- wrong product page
- wrong primary image
- dangerous current price state
- variant confusion ile yanlis merge/reuse

---

## 10. Tier promotion kurallari

Bir merchant'in tier promotion almasi icin asgari su kanit gerekir:

### 10.1. Fallback-only -> Partial

- en az `30` gercek vaka
- son `20` vakada `critical-fail = 0`
- canonical merchant alaninda `%95+`
- review-required davranisi dogru

### 10.2. Partial -> Full

- en az `50` gercek vaka
- en az `10` farkli urun/varyant
- `critical-fail = 0`
- title/canonical/image alanlarinda full hedeflerine yakin performans
- duplicate/reuse precision kabul edilir seviyede

### 10.3. Promotion notu

Happy path tek basina yetmez.  
Asagidaki adversarial vakalar da pakette bulunur:

- tracking URL
- redirect
- missing price
- wrong OG image adayi
- variant ambiguity

---

## 11. Tier downgrade kurallari

Asagidaki durumlar downgrade veya kill-switch review tetikler:

1. Son `20` vakada `2+` critical fail
2. Ayni merchant'ta wrong primary image trendi
3. Canonical dedupe bozulmasi
4. Dangerous price state artisi
5. Non-product page acceptance oraninin artmasi

Downgrade davranisi:

- full -> partial
- partial -> fallback-only
- tekrarli kritik riskte temporary block

---

## 12. Senaryo paketleri

Bu matrisi besleyen asgari senaryo paketleri sunlardir:

1. supported merchant happy path
2. same product different tracking URL
3. redirect chain
4. wrong OG / lifestyle banner image
5. price missing but page valid
6. currency present degil
7. blocked domain
8. variant ambiguity
9. marketplace listing vs single product detail
10. out-of-stock / preorder / unknown state
11. existing library product ile reuse
12. broken structured data ama recoverable page

---

## 13. Alan bazli kabul notlari

### 13.1. Title

Full tier'de title eksigi veya anlam kaybi izole istisna olabilir; tekrarlaniyorsa tier health bozulur.

### 13.2. Primary image

Wrong image her tier'de yuksek risklidir.

Fallback-only'de otomatik secimden kacmak, yanlis secimden iyidir.

### 13.3. Price

Price yoksa her zaman fail degildir.  
Ama wrong-current hissi her zaman agir fail sayilir.

### 13.4. Availability

`unknown` bazen saglikli degrade olabilir.  
Yanlis `in_stock` iddiasi daha buyuk risktir.

### 13.5. Reuse suggestion

Yanlis otomatik merge, yeni product acmaktan daha tehlikelidir.

---

## 14. Review-required davranisinin degerlendirilmesi

Review-required sonuc su kosullarda PASS sayilabilir:

1. Belirsizlik gercek ve anlamlidir
2. Sistem bunu dogru fark etmistir
3. Creator'e cikissiz durum yaratmiyordur
4. Yanlis auto-apply yapmiyordur

Review-required sonuc su kosullarda FAIL sayilir:

1. Aslinda deterministic full-tier senaryo iken sistem gereksiz review istiyordur
2. Review ekrani gerekli alanlari gostermiyordur
3. Hata aslinda wrong parse iken review-required ile maskeleniyordur

---

## 15. Manual correction'a izin veren pass mantigi

Partial ve fallback-only tier icin su alanlarda creator correction ile accept edilebilirlik vardir:

- title ince duzeltmesi
- brand düzeltmesi
- image secimi
- page target secimi

Ama su alanlarda correction'a dayanmak kaliteyi kurtarmaz:

- wrong merchant
- wrong product page
- dangerous price state

---

## 16. Ornek scoring mantigi

Case bazli puanlama ornegi:

- merchant dogru: `+25`
- canonical dogru: `+20`
- title anlamsal dogru: `+15`
- primary image dogru: `+20`
- price/currency guvenli: `+10`
- availability guvenli: `+5`
- honesty/degrade dogru: `+5`

Yorum:

- critical fail varsa toplam puan anlamsizlasir, case otomatik fail olur
- tam puan olmasa da `pass-with-review` mumkun olabilir

Bu scoring release robot'u degil; kalite yorumunu standardize eden yardimci mekanizmadir.

---

## 17. Sample size ve tekrar sikligi

### 17.1. Launch oncesi

Her aktif merchant tier'i icin asgari:

- full tier: `20+` kontrollu vaka
- partial tier: `15+`
- fallback-only: `10+`

### 17.2. Release sonrasi

Periyodik audit:

- yuksek trafik merchant'lar haftalik
- digerleri iki haftalik veya aylik

### 17.3. Triggered audit

Asagidaki sinyallerde yeniden audit gerekir:

- manual correction rate artisi
- wrong image support sikayeti
- duplicate/reuse issue artisi
- stale/dangerous price incident'i

---

## 18. Senaryo bazli ornek kararlar

### 18.1. Senaryo: `full` tier merchant, title dogru, image dogru, price yok

Sonuc:

- `pass` olabilir

Sart:

- price row current gibi gosterilmez

### 18.2. Senaryo: `partial` tier merchant, title orta, image belirsiz, review aciliyor

Sonuc:

- `pass-with-review`

Sart:

- review payload acik ve dogru yonlendirici

### 18.3. Senaryo: Fallback-only merchant, wrong lifestyle image otomatik secildi

Sonuc:

- `critical-fail`

### 18.4. Senaryo: Supported merchant, tracking URL nedeniyle duplicate product olustu

Sonuc:

- `critical-fail`

---

## 19. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Completeness'i correctness'in yerine koymak
2. Review-required sonucu her durumda fail saymak
3. Wrong image veya wrong merchant gibi kritik fail'leri "creator duzeltir" diye kabul etmek
4. Full tier promotion'u yalniz happy path ornekleriyle yapmak
5. Fallback-only tier'de false-current price state'i toleransli gormek

---

## 20. Bu belge sonraki belgelere ne emreder?

### 20.1. Release readiness'e

- aktif merchant tier'leri icin bu matristen gecen kanit seti release gate olacak

### 20.2. Risk register'a

- critical fail trendleri risk kaydina donecek

### 20.3. Merchant capability registry'e

- promotion ve downgrade kararlari bu belgeye baglanacak

---

## 21. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin:

1. Import kalitesi completeness degil correctness + honesty ekseninde olculuyor olmali.
2. Tier promotion ve downgrade kararlarinda ortak standart saglamali.
3. Wrong product / wrong image / dangerous price gibi kritik riskleri acik sekilde blocker olarak siniflamali.
4. Ekip, bir import sonucunun neden pass, review veya fail oldugunu bu belgeyle aciklayabiliyor olmali.
