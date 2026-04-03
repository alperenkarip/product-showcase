---
id: URL-IMPORT-PIPELINE-SPEC-001
title: URL Import Pipeline Spec
doc_type: import_architecture
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - CREATOR-WORKFLOWS-001
  - DOMAIN-MODEL-001
  - PRODUCT-LIBRARY-REUSE-MODEL-001
blocks:
  - EXTRACTION-STRATEGY-FALLBACK-ORDER
  - MERCHANT-CAPABILITY-REGISTRY
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC
  - JOB-QUEUE-WORKER-REFRESH-ARCHITECTURE
  - IMPORT-FAILURE-MODES-RECOVERY-RULES
---

# URL Import Pipeline Spec

## 1. Bu belge nedir?

Bu belge, creator tarafindan paylasilan bir URL'nin sistem tarafinda nasil kabul edildigini, hangi senkron ve asenkron asamalardan gectigini, ne zaman job olusturuldugunu, ne zaman reuse/duplicate kontrolune girdigini, verification payload'inin nasil olustugunu ve persistence'in hangi kosullarda tamamlandigini tanimlayan resmi import pipeline spesifikasyonudur.

Bu belge su sorulara cevap verir:

- URL import bu urunde neden tek adimli scraping degil, cok asamali pipeline'dir?
- Hangi asamalar istemci istegi icinde, hangileri worker tarafinda calisir?
- Job status'leri nelerdir ve hangi durumda creator ne gorur?
- Idempotency, duplicate submission ve duplicate product riski nasil kontrol edilir?
- Import sonucu ne zaman product/source/placement'e donusur, ne zaman sadece review payload olarak kalir?
- Fail veya partial success durumunda creator akisi nasil cikissiz kalmaz?

Bu belge, yalnizca "URL al, parse et, kaydet" notu degildir.  
Bu belge, urunun teknik omurgasi olan import davranisini tasiyan source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Bu urunde en buyuk teknik risk, URL import'un yanlis ama inandirici sekilde calismasidir.

Pipeline belirsiz kalirsa su hatalar dogar:

- ayni URL defalarca farkli product olarak kaydedilir
- unsupported merchant ile gecici timeout ayni sey sanilir
- worker ve UI arasindaki sorumluluk siniri kayar
- verification ekrani "sadece form"e donusur
- support, import nerede bozuldu sorusuna cevap veremez

Import bu urunde opsiyonel yan ozellik degildir.  
Creator retention'in merkezinde olan "hizli ama guvenli urun ekleme" davranis motorudur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> URL import, senkron kabul kapisi ile baslayan; normalization, policy, registry, extraction, reuse, verification ve persistence asamalarina ayrilmis asenkron bir pipeline'dir; extraction sonucu asla dogrudan public product'a donusmez, creator verification veya acik policy kurali ile kapanir.

Bu karar su sonuclari dogurur:

1. Import sonucu "tek shot scrape" olarak istemci thread'inde finalize edilmez.
2. URL kabul edilmesi ile verified product olusmasi ayni anlama gelmez.
3. Verification payload, product/source/placement persistence'ten once first-class artifact olarak vardir.
4. Duplicate product olusumu pipeline hatasi sayilir; duplicate submission ise idempotency kuraliyla ele alinir.
5. Unsupported veya belirsiz durumlarda creator'e her zaman manual correction cikis yolu sunulur.

---

## 4. Pipeline'in amaci ve non-goal'leri

### 4.1. Pipeline'in amaci

Pipeline su isleri yapar:

1. Girilen URL'nin urunsel olarak anlamli olup olmadigini kontrol etmek
2. Riskli veya unsupported baglantilari erken elemek
3. Deterministic ve policy-controlled extraction sonucunu toplamak
4. Reuse ve duplicate guardrail'larini calistirmak
5. Creator'e dogrulanabilir bir review paketi sunmak
6. Dogru entity'leri dogru sirayla persist etmek

### 4.2. Pipeline'in non-goal'leri

Pipeline sunlari yapmaz:

1. Checkout veya transaction baslatmaz
2. Creator review'u atlayarak guvensiz otomasyon yapmaz
3. Her URL'yi desteklenebilir kabul etmez
4. URL'den marketplace katalog taramasi cikarmaz
5. Coklu urun iceren listing sayfasini tekil product gibi zorla isleyip gizli hata yaratmaz

---

## 5. Girdi modeli

Bir import istegi asgari olarak su alanlari tasir:

- `submitted_url`
- `actor_id`
- `workspace_or_storefront_id`
- `intent`
- `target_context` opsiyonel

### 5.1. `intent`

Import niyetleri launch icin uc aileye ayrilir:

- `create_or_reuse_product`
- `attach_source_to_existing_product`
- `add_product_into_target_context`

### 5.2. `target_context`

Opsiyonel ama guclu baglam alanidir.

Ornekler:

- belirli shelf id
- belirli content page id
- library-only kaydetme niyeti

### 5.3. Ek creator girdileri

Import aninda creator su ek sinyalleri verebilir:

- hedef page'i sonra sececegim
- mevcut product'a source eklemek istiyorum
- duplicate cikarsa reuse oner

Bu sinyaller pipeline davranisini etkiler; ama extraction gercegini degistirmez.

---

## 6. Senkron kabul kapisi

Import'un ilk bolumu HTTP request icinde tamamlanir.  
Bu fazin amaci job baslatmadan once kesin reddedilmesi gereken durumlari ayiklamaktir.

### 6.1. Senkron kabul fazinda yapilanlar

1. URL parse
2. Protokol ve host kontrolu
3. temel malformed URL kontrolu
4. blocklist / unsafe redirect precheck
5. actor permission kontrolu
6. target context ownership kontrolu
7. idempotency fingerprint hesaplama

### 6.2. Aninda red kosullari

Asagidaki durumda job olusturulmaz:

- malformed URL
- desteklenmeyen protokol
- blocklist veya guvenlik bloklu domain
- actor'un ilgili target context uzerinde yetkisi yok
- URL bos veya parse edilemeyecek durumda

### 6.3. Senkron fazda yapilmayanlar

Bu fazda sunlar tamamlanmaz:

- agir fetch
- render
- extraction
- dedupe persistence

Bu sinir worker ve API maliyeti icin kritiktir.

---

## 7. Job state modeli

URL import job'u asagidaki durumlar arasinda gezer:

- `accepted`
- `queued`
- `processing`
- `needs_review`
- `ready_to_apply`
- `applied`
- `blocked`
- `failed`
- `expired`
- `cancelled`

### 7.1. State anlamlari

#### `accepted`
Senkron kabul fazi gecildi, job kimligi olustu.

#### `queued`
Worker sirasinda bekliyor.

#### `processing`
Fetch, extraction, normalization veya reuse analizi calisiyor.

#### `needs_review`
Verification payload hazir ama creator onayi veya duzeltmesi gerekiyor.

#### `ready_to_apply`
Rare path.  
Politika geregi verification tamamlanmis ya da creator hizli onayi alinmis, persistence uygulanabilir.

#### `applied`
Product/source/placement mutasyonu basariyla yapildi.

#### `blocked`
Policy veya safety gerekcesiyle durduruldu.

#### `failed`
Islem teknik veya domain-level failure ile tamamlanamadi.

#### `expired`
Review payload zaman asimina ugradi; yeniden review gerekir.

#### `cancelled`
Creator veya sistem kontrollu olarak iptal etti.

### 7.2. State gecis ilkeleri

1. `applied` durumundan sonra ayni job tekrar `processing`e donmez.
2. `blocked` ve `failed` farkli seydir; blocked retry edilmez, failed retry edilebilir.
3. `needs_review` sonsuza kadar acik kalmaz; review payload 7 gun sonra `expired` olur.

---

## 8. Uc ana sinir: sync, async ve human review

Pipeline uc net sorumluluk alanina ayrilir.

### 8.1. Sync kabul katmani

Ne ise yarar:

- hizli red
- idempotency
- permission ve target kontrolu

### 8.2. Async processing katmani

Ne ise yarar:

- fetch
- extraction
- normalization
- duplicate/reuse analizi
- verification payload assembly

### 8.3. Human review katmani

Ne ise yarar:

- title/image/source duzeltmesi
- duplicate tercihi
- manual fallback karari
- final persistence niyeti

Bu uc sinir birbirine karismamalidir.

---

## 9. Pipeline asamalari

## 9.1. Asama 0: Request kabul ve fingerprint olusturma

Asagidaki fingerprint kullanilir:

- `actor_id`
- `normalized_submitted_url` veya host bazli erken normalize url
- `intent`
- `target_context`

Kurallar:

1. Ayni fingerprint ile 10 dakika icinde acik job varsa yeni job acilmaz; mevcut job referanslanir.
2. Ayni URL 24 saat icinde uygulanmis ve ayni product'a baglanmis ise creator'e once mevcut sonucu kullanma yolu gosterilir.
3. Force refresh ayri bir niyet olarak kayda girer; normal import ile karistirilmaz.

## 9.2. Asama 1: URL normalization ve safety preflight

Bu asamada:

- tracking parametreleri temizlenir
- known mobile/desktop varyantlari normalize edilir
- shortener hedefi cikarilmaya calisilir
- affiliate wrapper yapilari cozulur
- redirect zinciri asiri veya unsafe ise durdurulur

Kural:

Normalization sonucu ve ilk submitted URL audit/debug icin birlikte tutulur.

## 9.3. Asama 2: Merchant capability resolution

Registry uzerinden su sorular cevaplanir:

- bu host icin tier nedir?
- adapter var mi?
- headless gerekli mi?
- price ve image alanlarina ne kadar guvenilir?
- kill switch aktif mi?

Bu cevaplar extraction stratejisini belirler.  
Registry olmadan extraction sira karari verilmez.

## 9.4. Asama 3: Fetch ve extraction orchestration

Worker:

1. policy'nin izin verdigi fetch modunu secer
2. extraction fallback sirasi ile alan adaylarini toplar
3. kanit izini ve extractor path bilgisini kaydeder

Bu asamanin ciktisi product degil, candidate bundle'dir.

## 9.5. Asama 4: Candidate assembly

Alanlar toplanir:

- canonical URL
- merchant
- title
- image candidates
- price/currency
- availability
- confidence breakdown
- extraction warnings

Kurallar:

1. Alan bazli kaynak izi tutulur.
2. Catisan alanlar gizlenmez; conflict olarak isaretlenir.
3. Eksik alanlar "uydurulmus tamamlama" ile doldurulmaz.

## 9.6. Asama 5: Reuse ve dedupe analizi

Candidate bundle hazir olduktan sonra:

- mevcut product library taranir
- canonical URL / merchant / title benzerligi kontrol edilir
- ayni product olasiligi hesaplanir
- existing product veya source attach onerisi hazirlanir

Bu asama persistence'ten once calisir.  
Once product yazip sonra duplicate cleanup yapmak launch modeline aykiridir.

## 9.7. Asama 6: Verification payload assembly

Creator review icin su paket olusur:

- field candidates
- selected defaults
- confidence ve warning bilgisi
- reuse suggestion
- manual correction gereken alanlar
- target context oneri veya mevcut intent

Bu payload first-class artifact'tir.  
Uygulamaya kaydedilir ve support/ops tarafindan yorumlanabilir olmalidir.

## 9.8. Asama 7: Creator review

Creator:

- alanlari dogrular
- duzeltir
- reuse veya new product karari verir
- page baglamini secip secmemeye karar verir
- manuel fallback'a donerse bunu acik secim olarak yapar

## 9.9. Asama 8: Persistence

Verification sonucu dogrultusunda su entity'ler olusur veya guncellenir:

- `Product`
- `Product Source`
- `Product Placement`
- ilgili audit / import outcome kaydi

Persistence sirasinda:

1. product ve source ayrimi korunur
2. placement target context'e gore opsiyonel olusur
3. duplicate engeli tekrar son kontrol olarak calisir

## 9.10. Asama 9: Post-apply sonuc

Job `applied` olduktan sonra:

- creator'e sonuc gosterilir
- target page etkisi net anlatilir
- gerekiyorsa publish henuz ayri workflow'da kalir

Import basarili oldu diye page otomatik publish edilmez.

---

## 10. Idempotency, duplicate submission ve duplicate product ayrimi

Bu uc kavram farklidir.

### 10.1. Duplicate submission

Ayni import isteginin kisa sure icinde tekrar gonderilmesidir.

Beklenen davranis:

- ayni acik job referanslanir
- creator "zaten isleniyor" veya "review hazir" durumunu gorur

### 10.2. Duplicate extraction result

Farkli fetch/extraction denemelerinde ayni normalized source sonucunun cikmasidir.

Beklenen davranis:

- onceki candidate bundle veya verification payload ile birlestirilebilir
- ayni kaynak icin tekrar tekrar bagimsiz persistence denenmez

### 10.3. Duplicate product

Ayni gercek urunun ayni creator library icinde ayrik product entity'leri olarak olusmasidir.

Beklenen davranis:

- kritik hata veya guardrail failure kabul edilir
- reuse/merge akisi devreye girer

---

## 11. Basari ciktisi tipleri

Pipeline asagidaki sonuc ailelerinden biriyle kapanir:

1. `product_created_source_attached_context_linked`
2. `product_created_source_attached_library_only`
3. `source_attached_to_existing_product`
4. `reuse_recommended_review_pending`
5. `manual_correction_required`
6. `manual_card_fallback_created`
7. `blocked`
8. `failed`

Belirsiz "import tamamlandi mi bilmiyoruz" durumu kabul edilmez.

---

## 12. Partial success davranisi

Import ikili basari/hatadan ibaret degildir.

### 12.1. Kabul edilen partial success ornekleri

- title ve image var, price yok
- source guvenilir ama availability belirsiz
- product reuse net, placement hedefi sonra secilecek

### 12.2. Kabul edilmeyen gizli partial success

- merchant belirsiz ama sanki netmis gibi ilerlemek
- duplicate conflict varken sessizce yeni product acmak
- verification gerektiren alanlari prefilled ve guvenli gibi gostermek

---

## 13. Timeout, retry ve expiration davranisi

### 13.1. Retry edilen durumlar

- gecici ag sorunu
- fetch timeout
- render altyapisinda gecici ariza

### 13.2. Retry edilmeyen durumlar

- malformed URL
- blocked domain
- unsupported protocol
- kill switch aktif host

### 13.3. Review expiration

`needs_review` payload'i 7 gun sonra `expired` olur.

Expiration sonrasi:

- eski payload apply edilemez
- creator isterse yeni refresh/re-import baslatir

---

## 14. Observability ve audit beklentileri

Her import job icin asgari olarak su alanlar tutulur:

- submitted URL
- normalized URL
- canonical URL varsa
- actor ve workspace baglami
- registry tier
- extractor path
- stage timings
- confidence breakdown
- failure code veya block reason
- verification sonucu
- persistence sonucu

Bu alanlar olmadan support ve ops ayni vakayi dogru yorumlayamaz.

---

## 15. Failure ve edge-case senaryolari

### 15.1. Shortener, affiliate wrapper veya redirect zinciri

Beklenen davranis:

- hedef URL bulunmaya calisilir
- unsafe pattern varsa job `blocked` olur
- redirect sonucu merchant host degistiyse registry yeniden resolve edilir

### 15.2. Product yerine kategori/search sayfasi geldi

Beklenen davranis:

- product page gibi davranilmaz
- verification'da net warning verilir veya unsupported path'e duser

### 15.3. Coklu urun iceren bundle veya collection page

Beklenen davranis:

- tekil product gibi sessizce parse edilmez
- ambiguity veya unsupported sonucu uretilir

### 15.4. Login wall veya region lock

Beklenen davranis:

- generic timeout diye gizlenmez
- reason code ile isaretlenir
- manual fallback cikis yolu korunur

### 15.5. Worker extraction basarili ama persistence cakti

Beklenen davranis:

- verification payload kaybolmaz
- creator tekrar extraction beklemez
- persistence hatasi ayri failure code ile kayda girer

---

## 16. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Import'u istemci thread'inde tamamlama
2. Extraction sonucunu verification olmadan product'a cevirme
3. Idempotency ile duplicate product problemini ayni sey sanma
4. Unsupported veya ambiguous durumda creator'i cikissiz birakma
5. Job state'lerini teknik debug ayrintisi gibi gormek
6. Reuse kontrolunu persistence sonrasi cleanup isi gibi ele almak
7. Submitted URL ile normalized/canonical URL farkini kaybetmek

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `41-extraction-strategy-and-fallback-order.md`, Asama 3 icindeki extraction sirasini ve alan bazli kaynak otoritesini baglayici hale getirmelidir.
2. `42-merchant-capability-registry.md`, Asama 2 icin gerekli tier, fetch mode ve kill-switch alanlarini tanimlamalidir.
3. `44-product-verification-ui-and-manual-correction-spec.md`, `needs_review` payload'inin ekran ve validasyon davranisini bu belgeye gore modellemelidir.
4. `65-job-queue-worker-and-refresh-architecture.md`, sync/async sinir ve job lifecycle'ini bu stage'lere gore tasarlamalidir.
5. `48-import-failure-modes-and-recovery-rules.md`, state ve failure code davranisini bu pipeline'e gore detaylandirmalidir.

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- import akisi stage bazli net ayrisiyorsa
- duplicate submission ve duplicate product problemleri birbirinden ayriliyorsa
- creator her failure veya partial success durumunda ne oldugunu anlayabiliyorsa
- support ve ops, bir import'un hangi asamada bozuldugunu job kaydindan anlayabiliyorsa

Bu belge basarisiz sayilir, eger:

- import hala "scrape edip kaydetme" yan ozelligi gibi duruyorsa
- verification payload first-class artifact olarak ele alinmiyorsa
- ayni URL'nin tekrarli gonderimi veya duplicate product riski belirsiz kaliyorsa

