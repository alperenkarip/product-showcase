---
id: VIEWER-EXPERIENCE-SPEC-001
title: Viewer Experience Spec
doc_type: public_experience
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
blocks:
  - PUBLIC-WEB-SCREEN-SPEC
  - EMPTY-LOADING-ERROR-STATE-SPEC
  - CROSS-PLATFORM-ACCEPTANCE-CHECKLIST
---

# Viewer Experience Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde public viewer'in storefront, shelf, content page ve varsa product detail yüzeylerinde nasıl bir deneyim yaşaması gerektigini; bu deneyimin hangi bilgi mimarisi, trust, performance, context ve outbound kurallarıyla korunacagini tanimlayan resmi public experience belgesidir.

Bu belge su sorulara cevap verir:

- Viewer bu urune hangi niyetle gelir?
- İlk ekranda ne görmelidir?
- Product card ne kadar bilgi tasimalidir?
- Trust/disclosure ne kadar görünür olmalıdır?
- Merchant'a cikis davranisi nasil olmalidir?
- Empty/error/removed state'lerde viewer'e ne gösterilmelidir?

Bu belge, "public web güzel görünmeli" seviyesinde kalmaz.  
Public web'in karar verdirici experience oldugunu varsayar.

---

## 2. Bu belge neden kritiktir?

Bu urunde viewer experience zayifsa creator tarafindaki tum emek deger kaybeder.

Creator:

- urun ekler
- context sayfasi hazirlar
- disclosure girer

Ama viewer:

- urunu bulamiyor
- context'i anlayamiyor
- trust bilgisini görmüyor
- sayfa mobilde geç açiliyorsa

urun degeri dışarıda üretilmez.

Bu nedenle viewer experience:

- ikincil ekran polish'i

degil,

- ürünün dış dünyadaki gerçekliği

sayılır.

---

## 3. Viewer experience'in ana karari

Bu belge için ana karar sudur:

> Viewer public sayfaya shopping browse için degil, belirli bir creator baglamindaki urunu veya urun setini anlamak ve güvenli şekilde merchant'a cikmak icin gelir.

Bu karar su sonuclari doğurur:

1. İlk ekranda context görünmelidir
2. Product card creator recommendation card'i gibi davranmalıdır
3. Trust/disclosure gizlenemez
4. Merchant exit açık ve tek anlamli olmalidir
5. Public performans launch seviyesinde önemlidir

---

## 4. Viewer mental modeli

Viewer urune geldiginde genelde su zihin haliyle gelir:

1. bir icerikte bir urun görmüştür
2. creator'a belli bir guven duymaktadır
3. ama merchant'a gitmeden once daha fazla bilgi ister

Viewer'in cevap aradığı ana sorular:

1. Bu tam olarak hangi urun?
2. Creator bunu hangi baglamda oneriyor veya kullaniyor?
3. Bu reklam mı, affiliate mi, gerçek kullanım mı?
4. Bu bilgi ne kadar güncel?
5. Tiklarsam nereye gidecegim?

Bu sorular ilk ekranlardan itibaren cevaplanmalıdır.

---

## 5. Entry intent tipleri

Viewer genelde public experience'e dört niyetle gelir:

### 5.1. Specific product intent

Belirli bir urunu arar.

Beklenti:

- product'i hizla bulmak
- note / trust bilgisini görmek

### 5.2. Context intent

Belirli bir icerikte gecen urun setini arar.

Beklenti:

- "used in this video" benzeri net bağlam

### 5.3. Creator universe intent

Creator'in genel tavsiye evrenine bakmak ister.

Beklenti:

- featured contexts
- featured shelves

### 5.4. Validation intent

Zaten urunu görmüştür; merchant'a gitmeden once güven almak ister.

Beklenti:

- disclosure
- creator note
- merchant bilgisi
- stale signal

---

## 6. Public surface bazli deneyim kurallari

### 6.1. Storefront experience

Viewer storefront'ta şunları ilk ekranda anlamalıdır:

1. Bu creator kim?
2. Ne tür product/context paylaşıyor?
3. Nereden başlamalıyım?

Storefront'ta baskin olması gerekenler:

- featured shelves
- featured content pages
- temiz creator identity

Storefront'ta baskin OLMAMASI gerekenler:

- dev biyografi bloklari
- category grid
- noise yaratan sosyal / vanity bloklar

### 6.2. Shelf experience

Viewer shelf'te şunları anlamalıdır:

1. Bu set hangi kullanım senaryosu için?
2. Listedeki urunler birbiriyle nasil iliskili?
3. Hangisi temel hangisi yardimci olabilir?

Shelf'te onemli olan:

- taranabilirlik
- karşılaştırılabilir bilgi yoğunluğu
- note ve trust sinyalinin card üstünde görünmesi

### 6.3. Content page experience

Bu urunun differentiator surface'i burada yaşar.

Viewer content page'te şunları ilk bakışta anlamalıdır:

1. Bu hangi içerik?
2. Bu içerikte geçen urunler hangileri?
3. Creator bu urunleri neden burada göstermiş?

Content page, urunleri creator bio'sunun altina iten bir layout kullanamaz.

### 6.4. Product light detail experience

Varsa:

- merchant'a cikmadan once daha fazla context sunar
- ama katalog ürünü gibi davranmaz

Viewer burada sunları görebilmelidir:

- uzun note
- disclosure detayları
- birden fazla context ilişkisi

---

## 7. Product card deneyimi

### 7.1. Product card'in asgari bilgi seti

Her product placement karti asgari olarak sunlari taşımalıdır:

1. primary image
2. title
3. creator note veya kisa context
4. merchant identity
5. disclosure / trust signal
6. varsa price durumu
7. primary CTA

### 7.2. Product card'in hissi nasıl olmalıdır?

Kart:

- shopping catalog card'i gibi degil
- creator recommendation card'i gibi hissettirmelidir

Bu ne anlama gelir?

- context taşır
- trust taşır
- görsel ama boş değildir

### 7.3. CTA kurali

CTA:

- merchant'a gidecegini açıkça hissettirmelidir
- ambiguity yaratmamalidir

Yanlış CTA örnekleri:

- product detail ile merchant exit arasini karistiran etiketler
- internal page açıyor gibi görünüp dışarı atan davranışlar

---

## 8. Trust ve credibility davranisi

### 8.1. Trust neden görünür olmalıdır?

Viewer recommendation experience'te güven arar.  
Bu nedenle disclosure ve stale bilgi dipnota saklanamaz.

### 8.2. Viewer'in ilk bakışta görebilmesi gereken trust soruları

1. Affiliate mi?
2. Sponsored mi?
3. Gifted mi?
4. Personally bought mi?
5. Fiyat guncel mi?
6. Merchant kim?

### 8.3. Trust visibility kurali

Kural:

- trust bilgisi en az kart veya immediately adjacent row seviyesinde görünmelidir
- modal arkasına gömülmemelidir

---

## 9. Price ve freshness davranisi

### 9.1. Price varsa

Viewer:

- price'i görebilir
- ama bunun ne kadar güncel oldugunu da anlamalıdır

### 9.2. Price stale ise

Kural:

- stale bilgi gizlenmez
- net current price hissi verilmez

### 9.3. Price yoksa

Kural:

- boş alan bırakılmaz
- hidden / unavailable mantigi anlaşılır copy ile ifade edilir

### 9.4. Price neden kritik?

Fiyat salt bilgi değildir.  
Yanlış price güveni doğrudan bozar.

---

## 10. Merchant exit davranisi

### 10.1. Outbound click neyi açık etmelidir?

Viewer merchant'a cikmadan once şunları anlamalıdır:

- dış siteye gittiğini
- hangi merchant'a gittiğini
- bunun creator tavsiye ilişkisi taşıyıp taşımadığını

### 10.2. Unsafe / blocked link davranisi

Unsafe veya policy-block durumunda:

- viewer sessizce merchant'a atılmaz
- controlled notice görür

### 10.3. Redirect deneyimi

Redirect zinciri:

- görünür derecede yavaş olmamalıdır
- güven kıran çok aşamalı geçiş hissi yaratmamalıdır

---

## 11. Performance davranisi

### 11.1. Performance neden UX'in cekirdeğidir?

Viewer cogu zaman sosyal akıştan gelir.  
Beklentisi düşük sabırdır.

Bu nedenle:

- meaningful content hızlı görünmeli
- product cards geç yüklenip kaymamalı
- media ağırlığı kontrol altında tutulmalı

### 11.2. Performance'in hissedilen kriterleri

Viewer açısından:

- sayfa hızlı geliyor mu?
- layout zıplıyor mu?
- kartlar geç mi doluyor?
- CTA'ya ulaşmak kolay mı?

Bu belge milisaniye SLA yazmaz; ama hissedilen kalite kriterini ürün şartı olarak koyar.

---

## 12. Accessibility ve okunabilirlik

Bu yüzey viewer tarafinda açık, hızlı ve güvenilir olmak zorundadır.  
Bu nedenle:

1. kart metinleri okunabilir yoğunlukta olmalı
2. trust badge'ler renk dışında da anlaşılır olmalı
3. CTA'lar dokunmatik hedef olarak yeterli olmalı
4. disclosure ve note tipografisi "yardimci ama görünmez" seviyesine itilmemelidir

---

## 13. Empty, removed ve error state davranislari

### 13.1. Empty storefront

Viewer:

- kirik veya sahte dolu bir sayfa gormemeli
- creator'in aktif vitrin hazırlamadigini net anlamalı

### 13.2. Archived content page

Viewer:

- sayfanin artık aktif olmadığını net görmeli
- varsa alternatif context'lere yönlendirilmeli

### 13.3. Removed product

Viewer:

- broken card veya eksik layout görmemeli
- controlled replacement veya açıklama görmeli

### 13.4. Missing image

Viewer:

- güveni kıran bozuk kutu görmemeli
- controlled placeholder veya alternate rendering görmeli

### 13.5. Broken outbound link

Viewer:

- sessiz failure yaşamamalı
- issue mümkünse creator tarafında bakım olayına dönüşmeli

---

## 14. Anti-pattern listesi

Bu belgeye göre su yaklasimlar viewer experience ihlalidir:

1. creator bio'yu product discovery'nin önüne koymak
2. product card'lari sadece image + button'a indirgemek
3. disclosure'u info modal'ina saklamak
4. stale price'i current price gibi hissettirmek
5. content page'i storefront'un alt menü detayı gibi göstermek
6. dış linke giderken viewer'in nereye gittiğini belirsiz bırakmak

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `52-public-web-screen-spec.md` product/context-first hierarchy kurmalıdır
2. `56-empty-loading-error-and-state-spec.md` removed, archived, broken ve empty state'leri açıkça tasarlamalıdır
3. `84-cross-platform-acceptance-checklist.md` viewer trust ve merchant exit acceptance maddeleri içermelidir
4. `27-disclosure-trust-and-credibility-layer.md` trust layer detayını bu görünürlük seviyesine göre yazmalıdır

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- viewer sosyal linkten geldikten sonra ikinci arama yapmadan baglamı anlayabiliyorsa
- product card'lar context ve trust bilgisini taşıyorsa
- outbound click oncesi gerekli minimum güven bilgisi açıkça görünüyorsa
- public experience mobilde recommendation surface gibi hissediyorsa

Bu belge basarisiz sayilir, eger:

- public sayfa creator vanity page'e dönüşüyorsa
- trust/disclosure yardimci metin gibi görünmezleşiyorsa
- merchant exit belirsizse
- content page differentiator olmaktan çıkıyorsa

Bu nedenle bu belge, public web'in nasıl görüneceğini değil; viewer'in karar anında ne hissetmesi ve neyi bilmesi gerektiğini tanımlar.
