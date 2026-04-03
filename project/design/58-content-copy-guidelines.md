---
id: CONTENT-COPY-GUIDELINES-001
title: Content Copy Guidelines
doc_type: ux_writing_policy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DESIGN-DIRECTION-BRAND-TRANSLATION-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
blocks:
  - DISCLOSURE-AFFILIATE-LABELING-POLICY
  - SUPPORT-PLAYBOOKS
  - PUBLIC-WEB-SCREEN-SPEC
  - EMPTY-LOADING-ERROR-STATE-SPEC
---

# Content Copy Guidelines

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde public, creator ve internal-support baglamlarinda kullanilan microcopy, CTA dili, disclosure ifadeleri, stale/failure mesajlari, empty state tonlamasi ve actor bazli yazim kurallarini tanimlayan resmi UX writing ve product language belgesidir.

Bu belge su sorulara cevap verir:

- Urunun sesi nasil bir ses olmalidir?
- Public copy ile creator copy neden ayni sertlikte veya ayni pazarlama tonunda olmamalidir?
- CTA'larda hangi kelimeler kullanilmaz?
- Disclosure ve stale price dili nasil net ama abartisiz olur?
- Error ve blocked state copy'leri nasil ayrisir?

Bu belge, "iyi yazariz" seviyesini baglayici yazim kararina cevirir.

---

## 2. Bu belge neden kritiktir?

Bu urunde copy yalniz arayuz etiketi degildir.  
Trust, recommendation ve correction davranisinin buyuk parcasi dille tasinir.

Yanlis copy su problemlere yol acar:

- CTA'lar shopping manipülasyonu gibi hissedilir
- stale warning panik yaratir veya kaybolur
- duplicate state error gibi okunur
- policy bloklari anlamsiz teknik jargona doner

Bu nedenle copy dili, product truth'u gizlemeyen sade ve net bir sistem olmak zorundadir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` copy dili acik, sakin, guven veren ve aksiyon odakli olur; shopping hype, startup jargon'u, euphemism ve teknik dumplardan kacınır; özellikle trust, stale, duplicate ve blocked state'lerde kullaniciya gercegi saklamadan sonraki dogru adimi gösterir.

Bu karar su sonuclari dogurur:

1. CTA'lar agresif commerce dili kullanmaz.
2. Disclosure euphemism ile yumuşatılmaz.
3. Error copy'leri "ne oldu / simdi ne yapabilirsin" ikilisini tasir.
4. Support ve product dili failure taxonomy ile uyumlu olur.

---

## 4. Ton karakteri

Urun dili su dort niteligi birlikte tasir:

1. `clear`
2. `direct`
3. `calm`
4. `trustworthy`

### 4.1. Clear

- muğlak kelime minimum
- bir cümlede bir ana mesaj

### 4.2. Direct

- ne oldugunu dolandirmadan söyler
- eylem onerir

### 4.3. Calm

- gereksiz alarm veya hype kullanmaz
- blocked/failure durumda bile panik dili kullanmaz

### 4.4. Trustworthy

- bilmedigini biliyormus gibi yazmaz
- stale veya hidden state'i gizlemez

---

## 5. Global yazim ilkeleri

### 5.1. Kisa ama eksiksiz

Copy kısa olabilir.  
Ama kritik anlamı atlayacak kadar kısa olmaz.

### 5.2. User-task first

Etiket ve mesajlar arayuzun degil, kullanicinin yapacagi isin diliyle yazilir.

### 5.3. No empty hype

Asagidaki dillerden kacınılır:

- "harika"
- "mukemmel"
- "sana ozel"
- "akilli sistem senin icin çözdü"

### 5.4. Same concept, same word

Ayni kavram farkli belgelerde farkli isimle yazilmaz.

Ornek:

- `archive`
- `unpublish`
- `delete`

ayni seyin eş anlamlisi gibi kullanılamaz.

---

## 6. Public copy kurallari

### 6.1. Storefront ve page copy

Publicte copy:

- creator'in neden bu urunu onerdigini destekler
- ama aşiri story-telling duvarina donmez

### 6.2. CTA dili

Uygun:

- `Merchant'ta gor`
- `Detaya bak`
- `Linke git`

Uygun degil:

- `Hemen satin al`
- `Firsati kacirma`
- `Sepete ekle`

### 6.3. Product note dili

Creator note:

- gerekceyi aciklar
- iddia veya reklam sloganina kaymaz

### 6.4. Trust row dili

Trust row:

- kisa
- dogrudan
- simgeye bagimli olmayan

olmalidir.

---

## 7. Creator copy kurallari

### 7.1. Import copy

Kurallar:

1. teknik extraction jargonunu minimumda tut
2. sonucu ve sonraki aksiyonu acik yaz
3. unsupported ile failed'i karistirma

### 7.2. Verification copy

Kurallar:

1. low-confidence alanlari net isaretle
2. duplicate state'i error gibi degil, karar gibi yaz
3. "yeniden başla" yerine correction odakli dil kullan

### 7.3. Publish copy

Kurallar:

1. neyin yayinlandigini acik yaz
2. draft/save/publish farki net olsun

---

## 8. Ops ve support copy kurallari

### 8.1. Support-facing copy

Support copy:

- teknik ama insana okunur
- failure taxonomy ile uyumlu
- creator'a verilecek next step'i aciklar

### 8.2. Ops/internal labels

Ops labels:

- kısa ama kesin
- ayni code ailesini her ekranda ayni adla gosterir

---

## 9. Disclosure ve trust dili

### 9.1. Disclosure terimleri

Launch icin standardize edilecek ana terimler:

- `Affiliate`
- `Sponsorlu`
- `Hediye edildi`
- `Kendi satin aldim`

### 9.2. Euphemism yasagi

Asagidaki gibi yuvarlatmalar kullanilmaz:

- `partner urunu`
- `marka dostu`
- `destekli urun`

Eger disclosure affiliate ise "affiliate" denir.

### 9.3. Merchant ve source dili

Publicte merchant'a cikildigi acik yazilir.  
"Detayi gör" deyip gerçekte dis siteye atmak güven kırar.

---

## 10. Price ve stale copy dili

### 10.1. Current price

Fiyat current görünüyorsa:

- currency net
- gerekiyorsa `son kontrol` bağlamı sade biçimde verilir

### 10.2. Stale warning

Copy:

- dramatik olmaz
- current hissini düzeltir

Uygun örnek:

- `Fiyat guncel olmayabilir`

Uygun olmayan:

- `Bu fiyat yanlis olabilir!!!`

### 10.3. Hidden by creator

Uygun örnek:

- `Fiyat gosterilmiyor`

### 10.4. Hidden by policy

Uygun örnek:

- `Guncel fiyat dogrulanamadi`

---

## 11. Error, blocked ve review copy ayrimi

### 11.1. Review required

Ton:

- yardimci
- karar odakli

Ornek:

- `Bazi alanlari kontrol etmen gerekiyor`

### 11.2. Failed

Ton:

- net
- cikis yolu gosterir

Ornek:

- `Bu linkten urun bilgisi cekilemedi. Istersen manuel urun olusturabilirsin.`

### 11.3. Blocked

Ton:

- daha kesin
- retry umudu satmaz

Ornek:

- `Bu alan adindan import su anda desteklenmiyor.`

### 11.4. Duplicate

Ton:

- cezalandirici degil
- reuse odakli

Ornek:

- `Bu urun kutuphanende zaten olabilir. Mevcut kaydi kullanmak ister misin?`

---

## 12. Empty state copy ilkeleri

### 12.1. Public empty

- saygili
- creator'i suclamaz
- 404 hissi vermez

### 12.2. Creator empty

- ilk adimi gosterir
- "hicbir sey yok" yerine "buradan baslayabilirsin" hissi verir

### 12.3. Ops empty

- basarisizlik yoklugunu saglikli durum olarak ifade edebilir

---

## 13. Yasakli dil

Asagidaki diller kullanilmaz:

1. startup hype
2. manipülatif sales urgency
3. teknik stack trace
4. gereksiz özür duvarı
5. creator'i suclayan ton

---

## 14. Senaryolar

## 14.1. Senaryo A: Unsupported merchant

Uygun:

- `Bu link turu su anda desteklenmiyor. Istersen urunu manuel ekleyebilirsin.`

## 14.2. Senaryo B: Duplicate önerisi

Uygun:

- `Mevcut kaydi kullanmak isteyebilirsin`

## 14.3. Senaryo C: Archived page

Uygun:

- `Bu sayfa artik yayinda degil.`

## 14.4. Senaryo D: Broken merchant link

Uygun:

- `Bu baglanti su anda acilmiyor. Daha sonra tekrar deneyebilirsin.`

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. CTA'larda shopping hype kullanmak
2. Disclosure dilini euphemism ile gizlemek
3. Duplicate'i hata gibi sunmak
4. Blocked ile failed ayrimini copy'de yok etmek
5. Error durumunda kullaniciya sonraki adimi vermemek

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `91-disclosure-and-affiliate-labeling-policy.md`, disclosure terimlerini bu belgeyle birebir uyumlu standardize etmelidir.
2. `103-support-playbooks.md`, creator-facing standart cevaplari bu tonal kurallara gore yazmalidir.
3. `52-public-web-screen-spec.md`, CTA ve trust row copy alanlarini bu belgeyle uyumlu tasarlamalidir.
4. `56-empty-loading-error-and-state-spec.md`, state aileleri icin copy tonunu bu belgeyle hizalamalidir.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- urunun sesi acik, sade ve guvenilir hissediliyorsa
- public ve creator copy'si actor ihtiyacina gore ayrisiyorsa
- stale, blocked, duplicate ve review durumlari copy tarafinda karismiyorsa
- trust/disclosure dili euphemism'e kaymiyorsa

Bu belge basarisiz sayilir, eger:

- copy hype, jargon veya teknik dump uretmeye baslarsa
- CTA'lar shopping manipulation diline kayarsa
- error ve blocked state'lerde kullanici ne yapacagini anlayamazsa

