---
id: DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
title: Disclosure, Trust and Credibility Layer
doc_type: trust_spec
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-VISION-THESIS-001
  - VIEWER-EXPERIENCE-SPEC-001
  - RISK-REGISTER-001
blocks:
  - DISCLOSURE-AFFILIATE-LABELING-POLICY
  - CONTENT-COPY-GUIDELINES
  - PROJECT-ADR-008
---

# Disclosure, Trust and Credibility Layer

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde disclosure, trust ve credibility katmaninin hangi veri primitive'lerinden oluştuğunu, bu primitive'lerin UI'da nasıl görünmesi gerektiğini, creator tarafında nasıl girildiğini, sayfa ve kart seviyesinde hangi kurallarla sunulduğunu ve trust bilgisinin hukuki dipnot değil ürünün çekirdek yüzeyi olduğunu tanımlayan resmi trust spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Trust layer tam olarak hangi bileşenlerden oluşur?
- Disclosure tipleri nelerdir?
- Kart seviyesinde ne görünmelidir?
- Page seviyesinde ne görünmelidir?
- Creator bu alanları nasıl girer ve override eder?
- Stale / missing price trust katmanina nasıl bağlanır?

---

## 2. Bu belge neden kritiktir?

Bu urun recommendation davranisi uzerinden deger urettigi için trust katmanı lüks değildir.

Viewer tarafinda su sorular her zaman vardır:

- Bu ürün sponsorlu mu?
- Affiliate link mi?
- Creator bunu gerçekten kullanıyor mu?
- Bu bilgi ne kadar güncel?
- Hangi merchant kaynağına gidiyorum?

Eğer ürün bu soruları saklar veya bulanık bırakırsa:

- creator tavsiyesi reklam gibi hissedilir
- viewer güven kaybeder
- support ve compliance yükü büyür

Bu nedenle trust layer, ürün çekirdeğine dahil edilir.

---

## 3. Ana karar

Bu belge için ana karar sudur:

> Disclosure, stale-price davranisi, source merchant ve creator note birlikte trust layer'i oluşturur; bu katman hiçbir page type'ta modal, dipnot veya settings-only bilgi seviyesine indirgenemez.

Bu karar su sonuclari doğurur:

1. disclosure data primitive'tir
2. trust badge sadece UI süsü değildir
3. stale/missing price trust problemidir
4. merchant identity trust katmanının parçasıdır

---

## 4. Trust layer'in bileşenleri

Trust layer asgari olarak su bileşenlerden oluşur:

1. disclosure tipi
2. creator note / reason layer
3. source merchant
4. price state ve freshness bilgisi
5. gerekiyorsa confidence veya source uncertainty notu

Bu parçalar birlikte güven üretir.  
Tek başına badge göstermek yeterli değildir.

---

## 5. Disclosure primitive'leri

### 5.1. Affiliate

Anlamı:

- creator veya platform ekonomik ilişki taşıyabilir

### 5.2. Sponsored

Anlamı:

- içerik veya product surface sponsorlu ilişki taşıyor olabilir

### 5.3. Gifted

Anlamı:

- ürün creator'a hediye edilmiş olabilir

### 5.4. Self Purchased

Anlamı:

- creator urunu kendi almis veya kendi gercek kullanimina dayandigini belirtiyor olabilir
- canonical data primitive'i `self_purchased` olarak tutulur, public copy daha sade yazilabilir

### 5.5. Brand Provided

Anlamı:

- ürün creator'a marka tarafından sağlanmış olabilir

### 5.6. Unknown Relationship

Anlami:

- creator iliski tipini henuz netlestirmemis olabilir
- sistem bunu sessizce baska disclosure tipine cevirmez

Kural:

- bu primitive'ler birbirine indirgenmez
- UI'da birincil / ikincil gösterim mantığı kurulabilir

---

## 6. Çoklu disclosure durumu

Bir ürün veya placement birden fazla trust sinyali taşıyabilir.

Ornek:

- gifted + personally tried
- affiliate + self_purchased

Kural:

- data modeli çoklu disclosure taşıyabilir
- UI'da öncelikli gösterim stratejisi gerekir
- bilgi kaybı pahasına tek etikete zorlanmamalıdır

---

## 7. Trust layer'in page seviyesinde davranışı

### 7.1. Storefront

Storefront'ta:

- creator'in genel disclosure yaklaşımı özetlenebilir
- ama bu product-level disclosure'un yerine geçmez

### 7.2. Shelf

Shelf'te:

- trust bilgisi card seviyesinde görünmelidir
- page intro trust açıklaması yardımcı olabilir

### 7.3. Content Page

Content page'te:

- context + trust birlikte görünür
- "bu içerikte kullanılanlar" hissi disclosure ile beraber çalışmalıdır

### 7.4. Product light detail

Varsa:

- daha detaylı trust açıklaması taşıyabilir
- ama creator note ile disclosure karışmamalıdır

---

## 8. Card seviyesinde trust kuralları

### 8.1. Card'in asgari trust bilgisi

Her product card veya placement render en az şunlardan anlamlı bir subset taşımak zorundadır:

1. merchant kimliği
2. disclosure signal
3. price state
4. kısa creator note veya context

### 8.2. Card trust row kuralı

Trust signal:

- kart içinde veya karta çok yakın ayrı bir row'da görünmelidir
- scroll derinliğine gömülmemelidir

### 8.3. Sadece tooltip yaklaşımı neden yanlıştır?

Cunku:

- viewer ilk bakışta güven bağlamını görmez
- disclosure görünürlüğü biçimsel ama işlevsiz olur

---

## 9. Creator note ile disclosure farkı

Bu iki alan aynı şey değildir.

### 9.1. Creator note

Amacı:

- kullanım nedeni
- öneri gerekçesi
- deneyim notu

### 9.2. Disclosure

Amacı:

- ticari/etik ilişki açıklığı

Kural:

- note disclosure yerine kullanılamaz
- disclosure note alanına gömülemez

---

## 10. Price ve freshness ilişkisi

### 10.1. Price trust'in bir parçasıdır

Fiyat bilgisi varsa viewer bunu güncel sanma eğilimindedir.  
Bu nedenle price trust katmanının bir bileşeni kabul edilir.

### 10.2. Price state aileleri

Asgari state düşüncesi:

- current / recently checked
- stale
- hidden by creator
- unavailable

### 10.3. Stale davranışı

Kural:

- stale bilgi gizlenmez
- current price hissi verilmez

### 10.4. Hidden davranışı

Kural:

- creator'in price göstermeme tercihi varsa boş alan bırakılmaz
- viewer saygılı ama net copy görür

---

## 11. Source merchant ve credibility ilişkisi

Source merchant trust katmanının ayrılmaz parçasıdır.

Viewer su soruya cevap bulmalıdır:

- bu link hangi merchant'a gidiyor?

Kural:

- merchant kimliği görünmelidir
- "dış link" hissi açık olmalıdır

---

## 12. Creator-side input kuralları

### 12.1. Creator disclosure ne zaman seçer?

Asgari olarak:

- import / verification aşamasında
- product / placement edit aşamasında

### 12.2. Varsayılan değer olabilir mi?

Evet.

Ama:

- profile-level default product/placement düzeyinde override edilebilir
- sistem creator kararı olmadan sponsorlu gibi ağır claim üretmez

### 12.3. Editor disclosure girebilir mi?

Evet, role modeline göre.

Ama:

- owner final kontrolü veya audit izi korunmalıdır

---

## 13. Validation ve guardrail kuralları

### 13.1. Disclosure seçilmeden publish

Kural:

- zorunlu warning gösterilir
- riskli durumlarda publish bloklanabilir

### 13.2. Affiliate parametresi otomatik inference

Kural:

- URL affiliate parametre taşısa bile sistem otomatik "sponsored" kararı vermez
- creator onayı gerekir

### 13.3. Çoklu trust sinyali çakışması

Kural:

- UI birincil / ikincil sıra belirlemelidir
- bilgi sessizce düşürülmez

---

## 14. Sayfa düzeyi trust özetleri

Creator genel disclosure policy'sini storefront veya content page üstünde özetleyebilir.

Ama bu özet:

- product-level trust row'un yerine geçmez
- global açıklama olarak kalır

Örnek doğru kullanım:

- "bazı linkler affiliate olabilir"

Örnek yanlış kullanım:

- sadece bu cümleyi yazıp kart level disclosure'u kaldırmak

---

## 15. Unsupported / low-confidence source durumları

Trust katmani sadece disclosure'dan ibaret değildir.  
Source belirsizliği de trust problemidir.

Ornek durumlar:

- `partial` tier merchant
- image selection belirsiz
- imported data eksik

Kural:

- bu uncertainty sessizce current/high-confidence gibi sunulamaz
- gerekiyorsa creator correction zorunlu hale gelir

---

## 16. Anti-pattern listesi

Bu belgeye göre su yaklasimlar yanlıştır:

1. disclosure bilgisini settings-only hale getirmek
2. sponsorlu ile affiliate'i aynı etiket gibi göstermek
3. stale price'i current price gibi göstermek
4. creator note'u disclosure yerine geçirmek
5. source merchant'i saklamak
6. trust bilgisini sadece tooltip / modal arkasına gizlemek

---

## 17. Compliance ile ilişkisi

Bu belge ürün davranışını tanımlar.  
Compliance policy bunu hukuki ve dilsel açıdan sabitler.

Kural:

- compliance policy ürünün görünürlüğünü düşüremez
- ürün trust layer'i compliance dipnotuna itemez

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `91-disclosure-and-affiliate-labeling-policy.md` disclosure primitive'lerini hukuk/policy diline dönüştürmelidir
2. `58-content-copy-guidelines.md` trust copy'lerini bu görünürlük seviyesine göre yazmalıdır
3. `PROJECT-ADR-008-disclosure-model.md` product-level trust kararlarını bu belgeyle hizalı tutmalıdır
4. `52-public-web-screen-spec.md` trust row ve disclosure placement'ini görünür tasarlamalıdır

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- viewer urunun hangi ilişkiyle önerildiğini hızlıca anlayabiliyorsa
- creator note ile disclosure karışmıyorsa
- stale veya missing price durumları gizlenmeden ama panik yaratmadan anlatılıyorsa
- source merchant ve trust row ürün deneyiminin doğal parçası gibi hissediyorsa

Bu belge basarisiz sayilir, eger:

- disclosure görünmezleşirse
- trust sadece hukuki dipnot gibi kalırsa
- price ve freshness birlikte doğru anlatılamazsa
- creator experience disclosure girisini yorucu bulup atlamaya başlarsa

Bu nedenle bu belge, etikete karar vermekten fazlasini yapar; recommendation ürününün güven mimarisini tanımlar.
