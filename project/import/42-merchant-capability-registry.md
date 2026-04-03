---
id: MERCHANT-CAPABILITY-REGISTRY-001
title: Merchant Capability Registry
doc_type: import_governance
status: ratified
version: 2.0.0
owner: operations
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - EXTRACTION-STRATEGY-FALLBACK-ORDER-001
  - URL-IMPORT-PIPELINE-SPEC-001
  - RISK-REGISTER-001
blocks:
  - IMPORT-FAILURE-MODES-RECOVERY-RULES
  - RUNBOOKS
  - PROJECT-ADR-004
  - JOB-QUEUE-WORKER-REFRESH-ARCHITECTURE
---

# Merchant Capability Registry

## 1. Bu belge nedir?

Bu belge, hangi merchant/domain veya host-pattern icin ne seviyede import destegi verildigini, hangi extraction yolunun secilecegini, headless render gerekip gerekmedigini, confidence beklentilerinin ne oldugunu, refresh ve kill-switch davranisinin nasil belirlenecegini ve bu kararlarin nerede resmi olarak tutulacagini tanimlayan registry ve governance belgesidir.

Bu belge su sorulara cevap verir:

- Merchant destegi neden kod icine dagitilmis `if host === ...` kurallari olarak yasamamalidir?
- `full`, `partial`, `fallback-only` ve `blocked` tier'leri tam olarak ne anlama gelir?
- Marketplace veya regional domain'lerde host bazli karar neden bazen yetmez?
- Registry kaydinda hangi alanlar zorunludur?
- Tier promotion ve demotion hangi kalite verilerine bakilarak yapilir?
- Kill switch ne zaman devreye girer ve mevcut product/source davranisini nasil etkiler?

Bu belge, import davranisinin merchant bazli source of truth'udur.

---

## 2. Bu belge neden kritiktir?

Import kalitesi yalnizca extraction algoritmasi ile belirlenmez.  
Asil farki olusturan sey, sistemin bir merchant hakkinda ne bildigidir.

Registry belirsiz kalirsa:

- ayni domain bazen full bazen fallback-only gibi davranir
- support ve ops ayni merchant icin farkli cevap verir
- render, retry ve refresh maliyeti kontrolsuz buyur
- kill switch kararinin nereden geldigini kimse anlayamaz

Bu nedenle registry, ops notu degil; urunun davranis anahtaridir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Merchant destegi, kodun icinde daginik kurallar olarak degil; host veya host-pattern bazli resmi registry kayitlariyla yonetilir; import pipeline, extraction sirasi, refresh davranisi ve failure handling bu registry uzerinden kosullandirilir.

Bu karar su sonuclari dogurur:

1. Yeni merchant destegi registry kaydi olmadan aktif sayilmaz.
2. Tier degisikligi auditli bir operasyonel karardir.
3. `blocked` durumu teknik failure degil, policy state'idir.
4. Ayni ana domain altindaki regional veya path-level farkliliklar registry'de acikca tutulabilir.

---

## 4. Registry'nin amaci ve kapsam disi

### 4.1. Registry'nin amaci

Registry su kararlar icin vardir:

- extraction route secimi
- headless gereksinimi
- expected confidence
- refresh stratejisi
- safety ve kill-switch kontrolu
- support ve ops beklentisi

### 4.2. Registry'nin kapsam disi

Registry sunlari yapmaz:

- merchant ile resmi partnerlik verisi tutmaz
- urun katalog veritabani gibi davranmaz
- creator'a gore keyfi host davranişi belirlemez

---

## 5. Resmi tier modeli

Launch icin desteklenen tier'ler asagidadir.

| Tier | Anlami | Tipik extraction davranisi | Review agirligi | Refresh davranisi |
| --- | --- | --- | --- | --- |
| `full` | Yeterince kanitlanmis yuksek guvenli destek | Adapter-first | Dusuk/orta | Duzenli |
| `partial` | Bazi alanlar guvenilir, bazi alanlar belirsiz | Structured/generic agirlikli | Orta/yuksek | Kontrollu |
| `fallback-only` | Generic fallback import, guven dusuk | Generic + manual correction | Yuksek | Aggresif degil |
| `blocked` | Policy, safety veya kalite sebebiyle kapali | Extraction yok veya erkenden durur | N/A | Yok |

Bu tier'ler runtime davranisidir.  
Dokuman disi "gri alan tier" kullanilmaz.

---

## 6. Registry kaydinin veri modeli

Her registry kaydi asgari olarak su alanlari tasir:

- `merchant_key`
- `host_pattern`
- `path_constraints` opsiyonel
- `tier`
- `regions`
- `adapter_key` varsa
- `requires_headless`
- `expected_title_confidence`
- `expected_image_confidence`
- `expected_price_confidence`
- `refresh_policy`
- `manual_review_weight`
- `kill_switch_state`
- `blocked_reason_code` opsiyonel
- `owner_team`
- `last_reviewed_at`
- `notes_for_support`

### 6.1. `merchant_key`

Registry icinde canonical merchant kimligidir.

### 6.2. `host_pattern`

Tek host, wildcard alt domain veya bilinen canonical host grubunu temsil eder.

### 6.3. `path_constraints`

Marketplace veya mixed-content domain'lerde, yalnizca belirli path pattern'lerinin desteklendigini gostermek icin kullanilir.

Ornek:

- `/product/`
- `/dp/`
- `/p/`

### 6.4. `regions`

Regional farkliliklarin davranisi dogrudan etkiledigi domain'lerde zorunludur.

### 6.5. `manual_review_weight`

Verification UI ve support copy'sinde ne kadar ihtiyatli davranilacagini etkileyen policy sinyalidir.

---

## 7. Registry birimi: host, pattern ve path override

Merchant destegi her zaman yalnizca "root domain" seviyesinde okunmaz.

### 7.1. Host-level kayit

En yaygin ve varsayilan modeldir.

### 7.2. Host-pattern kaydi

Regional veya seller subdomain farklari olan yapilarda kullanilir.

### 7.3. Path-level override

Marketplace gibi karma domain'lerde gereklidir.

Ornek:

- ana domain genel olarak `partial`
- ama belirli product path'leri `full`
- listing/search path'leri `fallback-only` veya `blocked`

Bu override mantigi kayit disinda kod icinde hardcode yasamaz.

---

## 8. Tier davranis kurallari

## 8.1. `full`

`full` tier verilmesi icin asgari kosullar:

1. Belirgin adapter veya kanitlanmis extraction yolu vardir.
2. Pilot importlarda title dogrulugu en az `%90` seviyesindedir.
3. Primary image secim kalitesi en az `%85` seviyesindedir.
4. Manual correction gereksinimi kritik alanlarda kabul edilebilir araliktadir.

Beklenen runtime davranisi:

- adapter-first
- duzenli refresh destegi
- daha yuksek default confidence

## 8.2. `partial`

Bu tier su durumda kullanilir:

- bazi alanlar guclu, bazi alanlar sik bozuluyor
- adapter yok ama structured data anlamli
- image/title makul, price/availability daha zayif

Beklenen runtime davranisi:

- generic parse agirlikli
- verification review guclu
- refresh kisitli

## 8.3. `fallback-only`

Bu tier su durumlarda kullanilir:

- extraction bazen calisiyor ama guven dusuk
- domain kararsiz veya format surekli degisiyor
- support maliyeti yuksek, ama tamamen bloklamak icin sebep yok

Beklenen runtime davranisi:

- creator'e manual correction beklentisi acik gosterilir
- auto-apply yolu acilmaz
- refresh agresif calismaz

## 8.4. `blocked`

Bu tier su durumlarda kullanilir:

- policy veya guvenlik bloklari
- unsafe redirect/fraud paterni
- hukuki risk
- kabul edilemez yanlis extraction profili

Beklenen runtime davranisi:

- import job sync veya erken async asamada durur
- creator'e net neden veya standart destek copy'si gosterilir
- retry loop'a girilmez

---

## 9. Promotion ve demotion kurallari

### 9.1. Tier promotion

Bir merchant'in tier'i yalnizca su verilerle yukseltilir:

- minimum 50 ornek import incelemesi
- accuracy ve correction oran raporu
- support issue yogunlugu
- abuse/safety durumu

### 9.2. Tier demotion

Asagidaki durumlardan biri demotion sebebidir:

- title veya image accuracy'de belirgin dusus
- duplicate confusion spike
- unsafe redirect veya bot wall artisi
- refresh sonuc kalitesinin bozulmasi

### 9.3. Demotion davranisi

Tier dusunce:

- yeni import davranisi aninda degisir
- mevcut source'lar otomatik silinmez
- gerekiyorsa trust/freshness policy yeniden yorumlanir

---

## 10. Kill switch modeli

Kill switch registry'nin ayrik ve zorunlu alanidir.

### 10.1. Kill switch ne icin vardir?

Su durumlarda hızlı davranmak icin:

- domain beklenmedik sekilde bozuldu
- phishing/redirect riski cikti
- extraction kritik yanlis alanlar uretmeye basladi
- platform policy riski dogdu

### 10.2. Kill switch turleri

- `none`
- `import_blocked`
- `refresh_blocked`
- `full_blocked`

### 10.3. Etkileri

#### `import_blocked`
- yeni import kabul edilmez
- mevcut source'lar historical kalir

#### `refresh_blocked`
- yeni import acik olabilir
- scheduled refresh durur

#### `full_blocked`
- yeni import ve refresh durur
- mevcut source'larda trust warning artabilir

---

## 11. Refresh ve maintenance iliskisi

Registry yalnizca import anini degil, sonrasini da etkiler.

### 11.1. `full` merchant refresh

- scheduled refresh desteklenir
- price/availability politikasi daha aktif calisir

### 11.2. `partial` merchant refresh

- kontrollu ve daha seyrek refresh
- kritik alanlar icin ek review ihtimali

### 11.3. `fallback-only` merchant refresh

- refresh varsayilan olarak kapalidir veya creator talebiyle sinirlidir

### 11.4. `blocked` merchant refresh

- refresh yoktur

---

## 12. Support ve ops icin beklentiler

Registry kaydi teknik tablo olmaktan fazlasini tasir.

Support'in okuyabilmesi gereken alanlar:

- bu merchant destekli mi?
- beklenen failure profili nedir?
- creator'e ne soylenmeli?
- manual correction beklentisi ne kadar yuksek?

Ops'in okuyabilmesi gereken alanlar:

- tier
- kill switch
- review tarihi
- confidence beklentisi
- incident notlari

---

## 13. Senaryolar

## 13.1. Senaryo A: Regional alt domain farki

Ornek:

- `merchant.com` partial
- `tr.merchant.com` full
- `de.merchant.com` fallback-only

Beklenen davranis:

- tek root domain karariyla hepsini ayni tier'e zorlamamak

## 13.2. Senaryo B: Marketplace domain

Beklenen davranis:

- host-level kayit yeterli degilse path override kullanmak
- search/listing URL'leri ile product detail URL'lerini ayirmak

## 13.3. Senaryo C: Kalite ani bozuldu

Beklenen davranis:

- kill switch veya tier demotion devreye girer
- support/runbook ayni registry state'ini gorur

## 13.4. Senaryo D: Adapter hazir degil ama import talepleri geliyor

Beklenen davranis:

- sessizce full destegi acmamak
- `fallback-only` veya `partial` ile kontrollu deneme yapmak

---

## 14. Failure ve edge-case senaryolari

### 14.1. Ayni host hem product hem editorial content tasiyor

Beklenen davranis:

- path-level constraint zorunlu hale gelir
- kategori/blog sayfasi product import gibi ele alinmaz

### 14.2. Regional alt domain farki support'e yansimadi

Beklenen davranis:

- registry fields support copy ile senkron tutulur
- "neden bende calisiyor, onda calismiyor?" sorusu aciklanabilir olmalidir

### 14.3. Blocked merchant sonradan temizlendi

Beklenen davranis:

- block kaldirilsa bile tier otomatik full'a cikmaz
- kontrollu re-review gerekir

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Merchant destegini kod icindeki daginik host kontrolune birakmak
2. Tier degisikliklerini audit olmadan yapmak
3. `blocked` ile `failed` kavramlarini karistirmak
4. Marketplace path ayrimlarini yok saymak
5. Quality regression oldugu halde full tier'i korumak
6. Registry kaydini support ve ops icin okunamaz hale getirmek

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `48-import-failure-modes-and-recovery-rules.md`, blocked/unsupported/partial davranis farklarini registry tier'ine gore ayirmalidir.
2. `101-runbooks.md`, tier promotion/demotion ve kill-switch operasyonlarini bu belgeye gore yazmalidir.
3. `65-job-queue-worker-and-refresh-architecture.md`, refresh stratejisini registry alanlariyla uyumlu hale getirmelidir.
4. `83-import-accuracy-test-matrix.md`, tier bazli accuracy beklentilerini ayri test kovasi olarak tanimlamalidir.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- her merchant/domain icin beklenen davranis tek bir kayittan okunabiliyorsa
- support, ops ve worker ayni registry state'ini yorumluyorsa
- tier promotion/demotion kararlari veriyle veriliyor ve auditleniyorsa
- kill switch teknik panic butonu degil, kontrollu policy araci olarak calisiyorsa

Bu belge basarisiz sayilir, eger:

- ayni merchant farkli yerlerde farkli sekilde davranmaya devam ediyorsa
- registry kaydi olmadan yeni host destegi aciliyorsa
- block, partial ve fallback-only davranislari UI ve ops tarafinda karisiyorsa
