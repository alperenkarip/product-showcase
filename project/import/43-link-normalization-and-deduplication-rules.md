---
id: LINK-NORMALIZATION-DEDUP-RULES-001
title: Link Normalization and Deduplication Rules
doc_type: import_identity_policy
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - PRODUCT-LIBRARY-REUSE-MODEL-001
  - DOMAIN-MODEL-001
blocks:
  - DATABASE-SCHEMA-SPEC
  - IMPORT-ACCURACY-TEST-MATRIX
  - API-CONTRACTS
---

# Link Normalization and Deduplication Rules

## 1. Bu belge nedir?

Bu belge, import edilen baglantilarin hangi kurallarla normalize edildigini, submitted URL, normalized URL ve canonical URL farkinin ne oldugunu, tracking ve affiliate katmanlarinin nasil temizlendigini, redirect zincirlerinin nasil yorumlandigini ve product deduplication kararinin hangi sinyal sirasiyla verildigini tanimlayan resmi link identity ve dedupe policy belgesidir.

Bu belge su sorulara cevap verir:

- Ayni urun neden farkli URL gorunumleriyle tekrar tekrar kayda donusmemelidir?
- `submitted_url`, `normalized_url` ve `canonical_url` ayni sey midir?
- Hangi query parametreleri temizlenir, hangileri korunur?
- Kisa link, affiliate wrapper ve mobile/desktop varyantlari nasil ele alinir?
- Exact duplicate, same product / different source ve true variant ayrimi nasil yapilir?
- Dedupe karari ne zaman otomatik, ne zaman creator review gerektirir?

Bu belge, yalnizca SEO canonical notu degildir.  
Bu belge, product identity ve reuse davranisinin import cephesindeki temelidir.

---

## 2. Bu belge neden kritiktir?

Normalization ve dedupe zayif olursa su problemler kacinilmaz hale gelir:

- ayni product ayni creator library icinde coklanir
- refresh ve stale politika ayni urune farkli kayitlar uzerinden uygulanir
- creator, reuse yerine yeniden ekleme davranisina kayar
- support "neden ayni urunun iki kaydi var?" sorunlarini cozemaz

Bu nedenle canonicalization burada estetik URL temizligi degil, domain butunlugu meselesidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Import edilen her link, once normalize edilir; sonra kanit hiyerarsisine gore canonical kimligi bulunur; product dedupe karari yalnizca URL string eslesmesine degil, canonical URL, merchant-level identifier, source metadata ve creator review'e dayanan cok katmanli bir modelle verilir.

Bu karar su sonuclari dogurur:

1. Submitted URL dogrudan source of truth degildir.
2. Canonical URL bulunmasi dedupe icin guclu ama tek basina mutlak sinyal degildir.
3. Query parametreleri kontrolsuzce ya hep silinmez ya da hep korunmaz.
4. Marketplace, regional ve varyantli merchant'larda URL esitligi her zaman ayni product anlamina gelmez.

---

## 4. Temel kavramlar

### 4.1. `submitted_url`

Creator'in sisteme gonderdigi ilk baglantidir.

Ozellikleri:

- audit ve support icin korunur
- tracking, affiliate veya shortener katmanlari icerebilir
- dedupe icin dogrudan kullanilmaz

### 4.2. `normalized_url`

URL parse, tracking temizligi ve temel host/path standardizasyonu sonrasi elde edilen ara kimliktir.

Ozellikleri:

- idempotency fingerprint icin kullanilir
- ilk asama duplicate submission kontrolunde degerlidir

### 4.3. `canonical_url`

Redirect cozumu, canonical link tag, adapter veya net merchant kimligi sonucu elde edilen asıl source URL'dir.

Ozellikleri:

- source-level identity icin en guclu URL sinyalidir
- her zaman bulunamayabilir
- bulunsa bile varyant ayrimi dikkate alinmalidir

### 4.4. `source_identity`

URL'nin de otesinde, merchant-level external id, SKU, product id veya adapter ciktisi ile desteklenen source kimligidir.

### 4.5. `product_identity`

Ayni gercek urunu temsil edip etmedigine dair daha ust seviye karardir.

URL esitligi her zaman product_identity esitligi demek degildir.  
Ayni sekilde URL farkliligi da her zaman farkli product demek degildir.

---

## 5. Normalization ilkeleri

### 5.1. Deterministik olma zorunlulugu

Ayni girdi her zaman ayni normalization sonucunu uretmelidir.

### 5.2. Geriye iz birakma zorunlulugu

`submitted_url` ve `normalized_url` farki kaybolmaz.

### 5.3. Product identity'yi bozmayacak temizlik

Tracking parametresini silmek dogrudur.  
Ama varyant veya region belirleyen parametreyi silmek yanlistir.

### 5.4. Safety once gelir

Normalization, security riskini atlayarak yapilmaz.  
Unsafe redirect veya loop normalization sonrasi gizlenmez; blocked/failure state'e doner.

---

## 6. URL normalization kurallari

### 6.1. Protokol normalize etme

Kurallar:

1. `https` tercih edilir.
2. `http` -> `https` gecisi merchant tarafinda resmi redirect ise canonicalization'a dahil edilir.
3. Protokol farki tek basina ayrik source identity yaratmaz.

### 6.2. Host normalize etme

Kurallar:

1. Host casing normalize edilir.
2. Bilinen `www` farklari registry ve canonical davranisa gore birlestirilebilir.
3. Regional alt domain'ler otomatik merge edilmez; registry sinyali gerekir.

### 6.3. Path normalize etme

Kurallar:

1. Gereksiz trailing slash farklari normalize edilir.
2. Known product path pattern'leri korunur.
3. Path segment'i product identity tasiyorsa kisa yol uygulanmaz.

### 6.4. Fragment temizleme

Varsayilan kural:

- `#fragment` urun kimligi tasimiyorsa silinir

### 6.5. Mobile/desktop varyant birlestirme

Kurallar:

1. Ayni merchant'in mobil ve desktop urun sayfalari ayni source'a isaret ediyorsa birlestirilir.
2. Mobile app deep-link pattern'i web detail page'e cozuluyorsa web canonical hedef tutulur.

### 6.6. Shortener ve wrapper link cozumleme

Kurallar:

1. Link shortener hedefi bulunmadan canonical karar verilmez.
2. Affiliate wrapper varsa hedef merchant URL cikarilmaya calisilir.
3. Wrapper cozumlenemiyorsa submitted URL korunur ama guven dusurulur.

---

## 7. Query parametre politikasi

Query parametreleri uc sinifa ayrilir.

### 7.1. Kesin silinecek tracking parametreleri

Ornekler:

- `utm_*`
- `fbclid`
- `gclid`
- click id, source, campaign ve benzeri marketing parametreleri

Kurallar:

1. Bunlar source identity sayilmaz.
2. Idempotency ve canonicalization'da yok sayilir.

### 7.2. Kosullu korunacak parametreler

Ornekler:

- varyant id
- renk/beden secimi
- region/locale secimi

Kurallar:

1. Parametre product variant veya regional listing degistiriyorsa korunur.
2. Parametrenin varyant etkisi kesin degilse auto-drop yerine review/log tercih edilir.

### 7.3. Bilinmeyen parametreler

Beklenen davranis:

- host bazli registry bilgisi kullanilir
- bilinmeyen parametreler rastgele silinmez
- sample telemetry ile review backlog'una dusurulebilir

---

## 8. Redirect politikasi

### 8.1. Redirect cozumu

Kurallar:

1. Kisa linkler nihai hedefe kadar cozulur.
2. Redirect zinciri en fazla 5 adim izlenir.
3. Loop tespit edilirse failure state olusur.

### 8.2. Redirect'in dedupe etkisi

Final hedef:

- canonical URL adayidir
- registry tier'ini degistirebilir
- merchant host'unu netlestirebilir

### 8.3. Unsafe redirect

Beklenen davranis:

- normalization basarisiz sayilir
- import `blocked` veya guvenlik failure koduna duser

---

## 9. Canonical URL belirleme hiyerarsisi

Canonical URL secimi asagidaki otorite sirasiyla yapilir:

1. merchant adapter canonical sonucu
2. nihai guvenli redirect hedefi
3. HTML `<link rel="canonical">`
4. structured data product URL alanlari
5. normalized final fetch URL

Kurallar:

1. Canonical tag ile adapter sonucu catisiyorsa adapter veya registry bilgisi daha gucludur.
2. Canonical URL'nin product detail yerine kategori/listing sayfasina ciktigi durumlar ambiguity yaratir.
3. Canonical URL bulunamadi diye dedupe tamamen kapatilmaz; alt sinyallere gecilir.

---

## 10. Dedupe sinyal hiyerarsisi

Product-level dedupe karari tek sinyale dayanmaz.

Resmi sinyal hiyerarsisi:

1. canonical URL eslesmesi
2. merchant-level external product identifier
3. structured SKU / GTIN / product code
4. normalized title + primary image similarity
5. creator manual secimi

Kurallar:

1. Alt sinyal, ust sinyali tek basina gecersiz kilmaz.
2. Ust sinyal net degilse alt sinyal review agirligini arttirir.
3. Creator manual karari domain butunlugunu bozuyorsa auditli exception olarak tutulur.

---

## 11. Duplicate siniflari

### 11.1. Exact duplicate

Tanim:

- ayni creator scope'u
- ayni canonical URL veya net external id

Beklenen davranis:

- yeni product acma
- mevcut product veya source'a baglan

### 11.2. Same product, different source

Tanim:

- ayni gercek product
- farkli merchant listing veya farkli region source

Beklenen davranis:

- tek product
- coklu source

### 11.3. Variant candidate

Tanim:

- ayni aile ama farkli renk, beden, bundle veya edition olabilir

Beklenen davranis:

- otomatik merge yapma
- creator review iste

### 11.4. Ambiguous near duplicate

Tanim:

- benzer title
- benzer image
- ama net kimlik kaniti yok

Beklenen davranis:

- reuse oner
- yeni product yaratmayi kilitleme
- ama risksiz gibi sunma

---

## 12. Reuse ve persistence iliskisi

Normalization ve dedupe, persistence'ten once calisir.

Kurallar:

1. Yeni product yazip sonra merge etmek varsayilan akıs olamaz.
2. Existing product'a source eklenmesi first-class mutasyondur.
3. Same product / different source durumu duplicate failure degil, dogru model davranisidir.

---

## 13. Senaryolar

## 13.1. Senaryo A: Tracking parametreli ayni URL

Ornek:

- `...?utm_source=x`
- `...?utm_source=y`

Beklenen davranis:

- normalized URL ayni olur
- duplicate submission veya same source kabul edilir

## 13.2. Senaryo B: Mobile ve desktop varyant

Beklenen davranis:

- ayni product page ise canonical birlesir
- farkli app deep-link'i ise web detail hedefi kullanilir

## 13.3. Senaryo C: Farkli region, ayni product

Beklenen davranis:

- product reuse guclu olabilir
- source ayri tutulur
- fiyat/availability karismaz

## 13.4. Senaryo D: Marketplace seller farki

Beklenen davranis:

- seller farki product kimligini degistirebilir ya da degistirmeyebilir
- otomatik merge icin net external id veya creator review gerekir

## 13.5. Senaryo E: Bundle vs single item

Beklenen davranis:

- title/image benzer diye otomatik merge edilmez
- variant/ambiguous duplicate olarak ele alinir

---

## 14. Failure ve edge-case senaryolari

### 14.1. Canonical tag yanlis sayfayi gosteriyor

Beklenen davranis:

- adapter veya structured kanitla conflict isaretlenir
- canonical tag sorgusuz source of truth kabul edilmez

### 14.2. Query parametresi varyant mi tracking mi belirsiz

Beklenen davranis:

- safety tarafinda sakli davran
- parametreyi kaybetmeden ambiguity logla
- auto-merge yapma

### 14.3. Redirect sonucu baska merchant'a gidiyor

Beklenen davranis:

- registry tekrar resolve edilir
- yeni merchant tier'i uygulanir

### 14.4. Ayni product eski ve yeni URL pattern'i ile gorunuyor

Beklenen davranis:

- canonical veya external id ile ayni product altinda toplanir
- eski source historical olarak tutulabilir

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. `submitted_url` ile `canonical_url` farkini yok saymak
2. Tum query parametrelerini korumak
3. Tum query parametrelerini silmek
4. URL esitligini product esitligiyle birebir ayni sanmak
5. Marketplace ve variant durumlarini auto-merge ile cozmeye calismak
6. Dedupe kararini persistence sonrasi cleanup isi gibi gormek

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `71-database-schema-spec.md`, submitted/normalized/canonical URL alanlarini ve source identity alanlarini ayri tutmalidir.
2. `83-import-accuracy-test-matrix.md`, query parametre, redirect, variant ve marketplace dedupe vakalarini ayri test kovasi yapmalidir.
3. `70-api-contracts.md`, duplicate submission ile duplicate product sonucunu ayri response davranislarina baglamalidir.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ayni product'in farkli URL varyasyonlari kontrolsuzce cokalmiyorsa
- same product / different source modeli dogru calisiyorsa
- creator'e reuse onerileri anlamli ve acik geliyorsa
- support bir linkin neden mevcut product'a baglandigini veya neden yeni source acildigini aciklayabiliyorsa

Bu belge basarisiz sayilir, eger:

- canonicalization sonucu gercek product identity bozuluyorsa
- query parametre kararlari tutarsizsa
- duplicate product problemi import'larda tekrarli goruluyorsa

