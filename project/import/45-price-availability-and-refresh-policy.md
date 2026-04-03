---
id: PRICE-AVAILABILITY-REFRESH-POLICY-001
title: Price, Availability and Refresh Policy
doc_type: trust_freshness_policy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
  - MERCHANT-CAPABILITY-REGISTRY-001
blocks:
  - DATA-LIFECYCLE-RETENTION-DELETION-RULES
  - CACHE-REVALIDATION-STALENESS-RULES
  - PROJECT-ADR-007
  - IMPORT-ACCURACY-TEST-MATRIX
---

# Price, Availability and Refresh Policy

## 1. Bu belge nedir?

Bu belge, import edilen fiyat ve availability bilgisinin urunde ne anlam tasidigini, hangi veri alanlariyla saklanacagini, ne zaman publicte gosterilecegini, ne zaman stale veya gizli davranacagini, hangi merchant tier'lerinde ne siklikta yenilenmesi gerektigini ve coklu source durumunda hangi kaynagin fiyat/availability kaynagi olarak secilecegini tanimlayan resmi freshness ve trust policy belgesidir.

Bu belge su sorulara cevap verir:

- Fiyat bu urunde source of truth mudur, yardimci sinyal midir?
- `last_checked_at` neden fiyatin ayrilmaz parcasi sayilir?
- Hangi freshness penceresinde fiyat normal gorunur, hangi pencerede uyarili veya gizli hale gelir?
- Availability state hangi enum'a normalize edilir?
- Creator fiyat gostermeyi kapatabilir mi?
- Coklu source'lu product'ta hangi merchant verisi publicte kullanilir?
- Viewer request'i ile canli fiyat cekilir mi?

Bu belge, fiyat alanini urunun trust katmaniyla birlikte ele alan source of truth'tur.

---

## 2. Bu belge neden kritiktir?

`product-showcase` fiyat karsilastirma veya checkout urunu degildir.  
Ama viewer fiyat gordugunde bunu guncel ve anlamli sanma egilimi gosterir.

Bu nedenle su hatalar yuksek risklidir:

- stale fiyati current gibi gostermek
- currency olmadan numeric degeri fiyat gibi sunmak
- out-of-stock veya unknown state'i gizlemek
- farkli merchant source'lar arasinda public fiyati sessizce hoplatmak

Bu urunde trust, fiyat gosteriminden daha onceliklidir.  
Dolayisiyla fiyat politikasinin temel sorusu "gosterebiliyor muyuz?" degil, "guvenli sekilde gosterebiliyor muyuz?" olmalidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Fiyat ve availability, urunun ikincil ama trust-sensitive source snapshot verisidir; fiyat yalnizca secili source, acik currency, tanimli freshness penceresi ve uygun trust baglami varsa publicte gosterilir; viewer request'i ile canli fetch yapilmaz ve stale belirsizligi gizlenmez.

Bu karar su sonuclari dogurur:

1. Fiyat "her zaman gosterecegiz" verisi degildir.
2. `last_checked_at` olmadan current price hissi verilmez.
3. Fallback-only merchant'ta fiyat varsayilan olarak daha ihtiyatli ele alinir.
4. Source secimi public outbound target ile uyumlu tutulur; runtime'da sessiz merchant hop'u yapilmaz.

---

## 4. Temel kavramlar

### 4.1. Observed price

Import veya refresh aninda belirli bir merchant source'tan okunan fiyat snapshot'idir.

Kural:

- satis taahhudu degildir
- quote veya offer engine degildir

### 4.2. Selected display source

Bir product'in publicte hangi merchant/source uzerinden ciktigi ve fiyat gosterdigi kararini tasiyan kayittir.

### 4.3. Availability snapshot

Belirli bir anda source'tan cikan stok/erisilebilirlik yorumudur.

### 4.4. Freshness window

Price/availability verisinin ne kadar sure current sayilacagini belirleyen zaman penceresidir.

### 4.5. Hidden by creator

Creator'in fiyat gostermeme tercihidir.

### 4.6. Hidden by policy

Sistem, veri stale, guvensiz veya eksik oldugu icin fiyati publicten ceker.

---

## 5. Veri modeli ve saklama ilkeleri

Fiyat ve availability icin asgari olarak su alanlar tutulur:

- `source_id`
- `observed_price_amount`
- `observed_price_currency`
- `availability_state`
- `observed_at`
- `last_checked_at`
- `freshness_state`
- `display_state`
- `price_confidence`
- `price_hidden_by_creator`

### 5.1. Zorunlu alan baglari

Kurallar:

1. Currency olmadan numeric fiyat current price gibi gosterilmez.
2. `last_checked_at` olmadan current veya stale hesabi yapilmaz.
3. `source_id` bilinmeden public price row kurulmaz.

### 5.2. Snapshot ve current state ayrimi

Current state:

- su anda secili source icin gecerli kabul edilen son deger

Snapshot history:

- onceki refresh'lerde gozlenen historical kayitlar

Bu ikisi ayni tablo ya da ayrik yapida tutulabilir, ama semantic olarak karistirilmaz.

---

## 6. Fiyatin urunde ne anlama geldigi

Fiyat su anlama gelir:

1. creator'in tavsiyesine yardimci ticari sinyal
2. viewer'in click karari icin kabaca referans
3. trust katmaninin freshness ile bagli parcasi

Fiyatin anlamadigi sey:

1. real-time checkout guarantee
2. "en ucuz burada" iddiasi
3. inventory guaranteed commercial offer

---

## 7. Price display state modeli

Publicte fiyat row'u su state'lerden biriyle davranir:

- `show_current`
- `show_with_stale_notice`
- `hidden_by_creator`
- `hidden_by_policy`
- `unavailable`

### 7.1. `show_current`

Kosullar:

- secili source mevcut
- currency mevcut
- freshness window asilmamis
- source blocked degil
- creator hide tercihi yok

### 7.2. `show_with_stale_notice`

Kosullar:

- fiyat hala anlamli ama current penceresini asmıs
- stale threshold sonrasina henuz dusmemis

UI davranisi:

- last checked baglami gosterilir
- "guncel olmayabilir" copy'si acik olmalidir

### 7.3. `hidden_by_creator`

Kosullar:

- creator secili source icin fiyat gosterimini kapatmistir

UI davranisi:

- bos alan birakilmaz
- saygili ve net copy kullanilir

### 7.4. `hidden_by_policy`

Kosullar:

- stale threshold asildi
- currency yok
- source confidence kabul edilmez
- source blocked veya policy-unsafe

### 7.5. `unavailable`

Kosullar:

- price hic elde edilemedi
- ya da urun sayfasi bunu tasimiyor

Bu state hata sayilmaz; ama current price gibi sunulamaz.

---

## 8. Availability state modeli

Availability asagidaki canonical state'lere normalize edilir:

- `in_stock`
- `limited`
- `out_of_stock`
- `preorder`
- `unknown`

### 8.1. Mapping ilkeleri

Kurallar:

1. Net kanit yoksa `unknown` kullanilir.
2. "stokta var gibi gorunuyor" seklindeki sezgisel parse `in_stock` icin yeterli degildir.
3. `unknown` gizlenmez; viewer'a "stok durumu belirsiz" gibi trust baglami saglanir.

### 8.2. Availability ve stale iliskisi

Availability stale oldugunda:

- `out_of_stock` veya `in_stock` current gibi korunmaz
- stale notice veya `unknown` downgrade uygulanabilir

---

## 9. Freshness pencereleri

Freshness politikasinda iki esik vardir:

1. `current_window`
2. `stale_hide_window`

Bu esikler merchant tier'ine gore degisir.

### 9.1. Full tier

- current window: `48 saat`
- stale notice window: `48 saat - 7 gun`
- hide threshold: `7 gun` ustu

### 9.2. Partial tier

- current window: `72 saat`
- stale notice window: `72 saat - 10 gun`
- hide threshold: `10 gun` ustu

### 9.3. Fallback-only tier

- current window: `24 saat`
- stale notice window: `24 saat - 5 gun`
- hide threshold: `5 gun` ustu

### 9.4. Blocked tier

- public price yok
- refresh yok

Bu esikler launch icin baglayicidir.  
Revizyon gerekiyorsa ADR ve test matrisi birlikte guncellenir.

---

## 10. Refresh trigger'lari

Refresh su kaynaklardan tetiklenebilir:

1. yeni import
2. creator manuel refresh talebi
3. scheduled refresh
4. support/ops kontrollu retry
5. publication etkili quality trigger

### 10.1. Trigger olmayan sey

Viewer page acilisi price fetch trigger'i degildir.

Neden:

- maliyet kontrolu
- latency
- rate limit
- bot/merchant riski

---

## 11. Scheduled refresh politikasi

### 11.1. Hangi urunler refresh kuyusuna girer?

Varsayilan olarak yalnizca su urunler:

- aktif published page'de gorunen product'lar
- secili source'u publicte click alan product'lar
- creator'in aktif tuttugu library kayitlari

### 11.2. Tier bazli refresh araligi

#### Full tier

- aktif published source: `24 saatte bir`
- library-only source: `72 saatte bir`

#### Partial tier

- aktif published source: `72 saatte bir`
- library-only source: `7 gunde bir`

#### Fallback-only tier

- varsayilan scheduled refresh yok
- creator manuel talebi veya kritik quality trigger ile

### 11.3. Cooldown ve rate limit

Kurallar:

1. Ayni source icin iki refresh arasinda minimum `6 saat` cooldown vardir.
2. Manuel refresh ard arda spamlanamaz; creator tarafinda `15 dakika` cooldown vardir.
3. Rate-limit veya anti-bot failure artarsa registry tier'i yeniden degerlendirilir.

---

## 12. Coklu source ve secili merchant davranisi

Bir product birden fazla source tasiyabilir.  
Ama publicte price satiri ve outbound click davranisi kararsiz olmamalidir.

### 12.1. Selected display source ilkesi

Kurallar:

1. Publicte tek bir primary source belirlenir.
2. Price row bu source'a bagli kalir.
3. Runtime'da sessizce "daha yeni fiyat geldi" diye baska merchant'a ziplanmaz.

### 12.2. Alternate source onerisi

Sistem su durumda creator'e source degisikligi onerebilir:

- secili source stale veya blocked oldu
- alternatif source daha guncel ve guvenilir

Ama bu bir creator-side karar olarak yuzeye cikar.  
Publicte sessiz auto-switch yapilmaz.

### 12.3. Price conflict

Farkli source'larin fiyatlari farkliysa:

- bu normaldir
- tek primary source secimi korunur
- comparison urunu gibi coklu fiyat listeleme launch'ta acilmaz

---

## 13. Creator kontrol alanlari

Creator su tercihleri verebilir:

1. fiyat goster / gizle
2. secili source degistir
3. source stale olsa bile urunu tut
4. price'siz ama note'lu card ile devam et

Creator'in yapamayacagi sey:

1. stale veriyi current gibi isaretlemek
2. currency'siz numeric degeri gecerli fiyat gibi zorlamak
3. blocked source'u trust warning olmadan publicte current fiyat kaynagi yapmak

---

## 14. Public UI davranisi

### 14.1. Price row

Price gosteriliyorsa:

- currency net olmali
- stale durumunda notice olmali
- secili source merchant'i yakin baglamda gorunmeli

### 14.2. Hidden by creator

UI:

- bosluk birakmaz
- "fiyat gosterilmiyor" benzeri sade copy verir

### 14.3. Hidden by policy

UI:

- current price yeri bos kalmaz
- "guncel fiyat dogrulanamadi" veya benzeri trust baglami kullanilir

### 14.4. Availability

`unknown` state:

- gizlenmez
- kesin stok varmis gibi davranilmaz

---

## 15. Refresh failure davranisi

Refresh basarisiz oldugunda:

1. product silinmez
2. son current fiyat sonsuza kadar korunmaz
3. freshness state guncellenir
4. public row stale/hide politikasina gore degisir

### 15.1. Gecici fetch failure

Onceki veri hemen purge edilmez.  
Ama freshness penceresi devam ediyorsa current kalabilir; pencere asildiysa stale/hide uygulanir.

### 15.2. Tekrarlayan failure

Registry, tier veya refresh stratejisi yeniden degerlendirilir.

---

## 16. Senaryolar

## 16.1. Senaryo A: Full tier current price

Kosullar:

- 18 saat once refresh edildi
- currency net
- source aktif

Beklenen davranis:

- `show_current`
- merchant ve last checked baglami var

## 16.2. Senaryo B: Partial tier stale notice

Kosullar:

- 5 gun once refresh edildi
- price var
- source hala secili

Beklenen davranis:

- `show_with_stale_notice`
- current gibi vurgulanmaz

## 16.3. Senaryo C: Fallback-only eski fiyat

Kosullar:

- 8 gun once import edildi
- refresh yapilmadi

Beklenen davranis:

- `hidden_by_policy`
- creator isterse manuel refresh veya hide ile devam eder

## 16.4. Senaryo D: Coklu source, eski primary

Kosullar:

- primary source stale
- secondary source current

Beklenen davranis:

- publicte sessiz source hop'u yok
- creator'e source degistirme oneri gelir

---

## 17. Failure ve edge-case senaryolari

### 17.1. Price var ama currency yok

Beklenen davranis:

- numeric deger tek basina gosterilmez
- `hidden_by_policy` veya `unavailable`

### 17.2. Availability parse edilemiyor

Beklenen davranis:

- `unknown`
- stock varmis gibi davranilmaz

### 17.3. Source blocked oldu

Beklenen davranis:

- public price kapanir
- product kalir
- creator'e alternatif source onerisi cikarilabilir

### 17.4. Creator price hide acti ama source current

Beklenen davranis:

- creator tercihi kazanir
- stale/current farki creator-side'ta gorunmeye devam eder

### 17.5. Cache eski fiyati tutuyor

Beklenen davranis:

- cache invalidation freshness state degisimiyle tetiklenir
- current olmadigi halde eski current UI devam edemez

---

## 18. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Fiyati canli checkout sinyali gibi ele almak
2. Viewer request'inde anlik price fetch yapmak
3. Currency'siz numeric degeri fiyat gibi gostermek
4. Stale veriyi current gibi gosterip trust'i fiyata feda etmek
5. Primary source'u creator haberi olmadan sessizce degistirmek
6. `unknown` availability'yi gizlemek

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `73-cache-revalidation-and-staleness-rules.md`, freshness state degisimlerinin cache invalidation'a nasil yansiyacagini bu pencerelere gore yazmalidir.
2. `83-import-accuracy-test-matrix.md`, tier bazli current/stale/hide esiklerini ve currency/availability edge-case'lerini test etmelidir.
3. `52-public-web-screen-spec.md`, price row ve stale notice tasarimini bu state modeline gore gostermelidir.
4. `101-runbooks.md`, stale price spike ve refresh degradation vakalarini bu esiklere gore siniflandirmalidir.

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- viewer stale fiyati current sanmiyorsa
- creator fiyat gosterimi uzerinde kontrollu ama sinirli tercihe sahipse
- multi-source product'larda public merchant davranisi kararsiz degilse
- refresh maliyeti merchant tier'ine gore kontrollu kalirken trust bozulmuyorsa

Bu belge basarisiz sayilir, eger:

- eski fiyatlar current gibi gorunuyorsa
- currency veya freshness bilgisi eksik oldugu halde fiyat acik kalabiliyorsa
- publicte sessiz source hop'u yasaniyorsa

