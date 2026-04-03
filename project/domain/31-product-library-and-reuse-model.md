---
id: PRODUCT-LIBRARY-REUSE-MODEL-001
title: Product Library and Reuse Model
doc_type: domain_behavior
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DOMAIN-MODEL-001
  - LINK-NORMALIZATION-DEDUP-RULES
  - CREATOR-WORKFLOWS-001
blocks:
  - DATABASE-SCHEMA-SPEC
  - PROJECT-ADR-005
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC
---

# Product Library and Reuse Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde product library'nin nasıl çalıştığını, neden creator retention için merkezde olduğunu, duplicate detection mantığını, reuse-first davranışın hangi kurallarla korunduğunu, merge ve split senaryolarını ve product ile placement ayrımının pratik ürün davranışına nasıl dönüştüğünü tanımlayan resmi reuse ve dedupe model belgesidir.

Bu belge su sorulara cevap verir:

- Aynı ürün neden tek entity altında tutulmalıdır?
- Sistem duplicate'i nasıl anlar?
- Otomatik merge ne zaman yapılır, ne zaman yapılmaz?
- Creator reuse'e nasıl yönlendirilir?
- Benzer ama farklı varyantlar nasıl ayrılır?

---

## 2. Bu belge neden kritiktir?

Bu urunde reuse modeli kırılırsa:

- creator sürekli aynı ürünü yeniden ekler
- library kirlenir
- stale bilgi farklı kayıtlarda çoğalır
- support duplicate confusion issue'ları ile dolar

Yani reuse davranışı lüks optimizasyon değildir.  
Creator retention, bakım maliyeti ve trust için çekirdek değerdir.

Bu nedenle bu belge, "duplicate olmasın" notu değil; domain davranış şartıdır.

---

## 3. Ana karar

Bu belge için ana karar sudur:

> Aynı creator library içinde aynı gerçek dünya ürününü temsil eden kayıt mümkün olduğunca tek `Product` entity'si altında tutulur; farklı context'lerdeki görünüm farkları `Product Placement` ile çözülür; farklı merchant listing'ler ise `Product Source` primitive'i altında yaşar.

Bu karar su sonuclari doğurur:

1. yeni page için yeni product açmak varsayilan davranis olamaz
2. source çoğalabilir, product mümkün olduğunca çoğalmaz
3. note / title varyasyonları placement seviyesine kayar

---

## 4. Product library'nin rolü

Product library'nin görevi:

1. creator'in tekrarli product varlıklarını merkezileştirmek
2. import'tan gelen product identity'yi tutmak
3. source ve freshness bakımını merkezi hale getirmek
4. placement'ların parent primitive'ini sağlamak

Library ne değildir:

- public shopping catalog
- page listesi
- sadece "geçmiş importlar" ekranı

---

## 5. Reuse neden çekirdektir?

Bu urunde creator şunları tekrar tekrar yapar:

- aynı tripod'u farklı videolarda kullanmak
- aynı supplement'i farklı routine'lerde göstermek
- aynı ürün için farklı note yazmak

Eğer bu davranış yeni product yaratmakla çözülürse:

- veri dağılır
- support zayıflar
- stale price ve broken source yönetimi zorlaşır

Bu nedenle reuse, UX tercihi değil; domain kuralıdır.

---

## 6. Duplicate detection sinyalleri

Duplicate detection tek sinyale dayanmaz.  
Sinyal ailesi birlikte yorumlanır.

### 6.1. Canonical URL eşleşmesi

En güçlü sinyallerden biridir.

Ama tek başına yeterli olmayabilir.  
Özellikle:

- variant ürünler
- bundle vs single item
- redirect farklılıkları

gibi durumlarda dikkat gerekir.

### 6.2. Merchant + external product identifier

Merchant'in sağladığı net external ID varsa güçlü eşleşme sinyali üretir.

### 6.3. Normalized title benzerliği

Yardımcı sinyaldir.  
Tek başına otomatik merge kararı vermemelidir.

### 6.4. Image similarity

Yardımcı sinyaldir.  
Variant confusion riski taşıdığı için tek başına yeterli değildir.

### 6.5. Creator confirmation

En son kalite kapısıdır.  
Sistem güçlü aday bulsa bile creator'e net reuse önerisi sunabilir.

---

## 7. Duplicate detection karar modeli

### 7.1. High-confidence duplicate

Örnek:

- aynı canonical URL
- aynı merchant
- güçlü title eşleşmesi

Varsayılan davranış:

- otomatik reuse öner
- yeni product oluşturmayı secondary path yap

### 7.2. Medium-confidence duplicate

Örnek:

- benzer title
- aynı merchant
- farklı URL varyasyonu

Varsayılan davranış:

- creator review ister

### 7.3. Low-confidence similarity

Örnek:

- aynı aileye ait ama farklı varyantlar

Varsayılan davranış:

- otomatik merge yapılmaz
- ayrı product olarak kalabilir

---

## 8. Reuse akışları

### 8.1. Import-time reuse

Normal akış:

1. URL gelir
2. normalization yapılır
3. duplicate adayları bulunur
4. creator'e mevcut product önerilir
5. yeni source eklenir veya yeni placement oluşturulur

### 8.2. Library-time reuse

Normal akış:

1. creator library'de arama yapar
2. product seçer
3. yeni shelf veya content page'e placement ekler

### 8.3. Content-first reuse

Content page açılırken:

- creator önce page oluşturur
- sonra existing library'den products çeker

Bu da reuse davranışıdır; import şart değildir.

---

## 9. Merge kuralları

### 9.1. Merge ne zaman yapılır?

Yalnızca şu durumda:

- iki kaydın aynı gerçek ürün olduğuna yeterli güven varsa

### 9.2. Merge edildiğinde ne olur?

1. source'lar tek product altında birleşir
2. placement'lar korunur
3. page-specific notes bozulmaz
4. audit izi tutulur

### 9.3. Merge neyi yapmamalıdır?

- placement notes'u ezmemeli
- context-specific title'ları silmemeli
- creator'in elle verdiği override'ları kaybetmemeli

---

## 10. Split / ayrışma kuralları

Benzer ama aynı olmayan ürünler zorla birleştirilmemelidir.

### 10.1. Split gerektirebilecek durumlar

- renk / beden varyantı
- bundle vs single product
- region-specific farklı listing
- aynı family içinde teknik olarak farklı SKU

### 10.2. Split kararı ne zaman gerekir?

Eğer birleşik product:

- creator'i yanıltıyorsa
- source freshness'i bozuyorsa
- yanlış merchant çıkışı yaratıyorsa

ayrı product açılmalıdır.

---

## 11. Source çoğulluğu kuralları

Bir product birden fazla source taşıyabilir.

Ornek:

- aynı ürün farklı merchant'larda satılıyor
- aynı ürünün resmi store ve marketplace listing'i var

Kural:

- source çoğulluğu product çoğulluğu anlamına gelmez
- source seçim ve ranking mantığı ayrıca yazılmalıdır

---

## 12. Placement-level esneklik

Reuse modeli ancak placement seviyesinde yeterli esneklik varsa çalışır.

Placement düzeyinde değişebilir alanlar:

- custom title
- short note
- order
- featured state
- page-specific emphasis

Bu alanlar product primitive'ine yazılırsa reuse mantığı kırılır.

---

## 13. Archive ve active placement ilişkisi

Bir product archived olduğunda:

- aktif placement'lar otomatik yok edilmez
- creator etkisini görür

Bir source broken/stale olduğunda:

- product doğrudan silinmez
- supportable recovery yolu sunulur

---

## 14. Reuse-first UX kuralları

Bu belge ürün tarafına şu emirleri verir:

1. duplicate bulunduğunda reuse önerisi baskın aksiyon olmalıdır
2. "clone product" varsayılan seçenek olmamalıdır
3. creator benzer ürünler arasında ayrım yapabilmek için yeterli metadata görmelidir

---

## 15. Edge-case listesi

### 15.1. Same product, different merchant

Tek product + çoklu source desteklenir.

### 15.2. Same product, different context notes

Tek product + çoklu placement desteklenir.

### 15.3. Similar title, different variant

Otomatik merge yapılmaz.

### 15.4. Archived product with active placements

Creator uyarılır; sessiz yok oluş olmaz.

---

## 16. Anti-pattern listesi

Bu belgeye göre su yaklasimlar yanlıştır:

1. her import için varsayılan yeni product yaratmak
2. page-specific note'ları product primitive'ine yazmak
3. farklı source'ları farklı product gibi modellemek
4. weak title similarity ile otomatik merge yapmak
5. creator'e reuse yerine clone'u öne çıkarmak

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `43-link-normalization-and-deduplication-rules.md` duplicate detection sinyallerini operasyonel kurallara çevirmelidir
2. `23-creator-workflows.md` reuse-first UX'i akış düzeyinde korumalıdır
3. `71-database-schema-spec.md` source ve placement çoğulluğunu bu primitive'lerle modellemelidir
4. `PROJECT-ADR-005-product-reuse-and-dedup-model.md` merge/split sınırlarını bu belgeyle hizalı tutmalıdır

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator aynı ürünü farklı context'lerde tekrar kullanırken sistem anlaşılır kalıyorsa
- duplicate oranı kontrol altına alınabiliyorsa
- source çoğulluğu product karmaşasına dönüşmüyorsa
- placement esnekliği reuse davranışını gerçekten destekliyorsa

Bu belge basarisiz sayilir, eger:

- library kısa sürede kopya ürünlerle doluyorsa
- source freshness yönetimi dağılıyorsa
- creator aynı ürünü yeniden kullanmak yerine yeni kayıt açmaya itiliyorsa

Bu nedenle bu belge, urunun tekrarli publish ekonomisini taşıyan davranış sözleşmesidir.
