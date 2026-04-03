---
id: IMPORT-FAILURE-MODES-RECOVERY-RULES-001
title: Import Failure Modes and Recovery Rules
doc_type: risk_operations_spec
status: ratified
version: 2.0.0
owner: operations
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - MERCHANT-CAPABILITY-REGISTRY-001
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC-001
blocks:
  - RUNBOOKS
  - SUPPORT-PLAYBOOKS
  - EMPTY-LOADING-ERROR-STATE-SPEC
  - IMPORT-ACCURACY-TEST-MATRIX
---

# Import Failure Modes and Recovery Rules

## 1. Bu belge nedir?

Bu belge, import pipeline'inda ortaya cikabilecek hata siniflarini, bu hata siniflarinin ne zaman teknik failure, ne zaman policy block, ne zaman human-review gerektiren kontrollu sonuca donustugunu, hangi failure code ailelerinin standart oldugunu, creator'e ne gosterilecegini, hangi durumlarda otomatik retry yapilacagini ve support/ops ekibinin hangi sinyalde hangi recovery yolunu izlemesi gerektigini tanimlayan resmi failure ve recovery belgesidir.

Bu belge su sorulara cevap verir:

- Import failure tam olarak ne demektir?
- `blocked`, `failed`, `needs_review` ve `expired` neden farkli seylerdir?
- Hangi hata siniflarinda retry mantiklidir, hangilerinde anlamsizdir?
- Creator hangi durumlarda manual fallback ile cikis bulur?
- Support ile ops ayni failure vakasini nasil isimlendirir?
- Tekil failure ile sistemik incident nasil ayrilir?

Bu belge, import hattinin curume bicimlerini adlandiran source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Import alaninda en tehlikeli sey sadece exception almak degildir.  
Daha tehlikeli olan, farkli hata tiplerini ayni "bir seyler ters gitti" torbasina atmaktir.

Bu yapildiginda:

- invalid URL ile blocked domain ayni copy'yi alir
- duplicate tespiti teknik hata gibi gorunur
- unsupported merchant retry loop'una girer
- creator ne yapacagini bilmez
- support ve ops failure paterni okuyamaz

Bu nedenle failure mode belgesi, import akisinin ikinci yarisi kadar kritiktir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Import'ta her olumsuz sonuc `failure` degildir; product-uygun olmayan input, policy block, transient teknik ariza, ambiguity, duplicate/reuse ve human-review gereksinimi ayrik outcome siniflari olarak modellenir; her sinifin ayri creator copy'si, retry politikasi ve operasyonel tepkisi vardir.

Bu karar su sonuclari dogurur:

1. `blocked` ile `failed` karistirilmaz.
2. `needs_review` kontrollu outcome'tur; hata sayilmaz.
3. Duplicate tespiti recovery path'tir; teknik error degildir.
4. Retry yalnizca transient failure siniflarinda uygulanir.

---

## 4. Temel outcome siniflari

Import sonucu asagidaki outcome ailelerine ayrilir:

- `accepted`
- `needs_review`
- `applied`
- `blocked`
- `failed`
- `expired`
- `cancelled`

### 4.1. `needs_review`

Bu outcome, import'in cikissiz kaldigi degil; creator review veya correction gerektigi anlamina gelir.

### 4.2. `blocked`

Policy, guvenlik veya capability gerekcesiyle ilerlemeyen durumdur.

### 4.3. `failed`

Teknik veya domain-seviyesi islem basarisizligi nedeniyle beklenen ara artefact'in uretilemedigi durumdur.

### 4.4. `expired`

Review payload'in zaman penceresini kacirdigi ama extraction sonucunun bir zamanlar var oldugu durumdur.

---

## 5. Failure mode siniflari

Import failure aileleri pipeline asamasina gore ayrilir.

1. input failure'lari
2. policy failure'lari
3. capability failure'lari
4. fetch/render failure'lari
5. extraction failure'lari
6. identity/dedupe failure'lari
7. review lifecycle failure'lari
8. persistence failure'lari
9. refresh/maintenance failure'lari

---

## 6. Resmi failure code aileleri

Asagidaki kodlar launch icin standarttir.

### 6.1. Input failure kodlari

- `INPUT_INVALID_URL`
- `INPUT_UNSUPPORTED_PROTOCOL`
- `INPUT_EMPTY_VALUE`

### 6.2. Policy failure kodlari

- `POLICY_BLOCKED_DOMAIN`
- `POLICY_UNSAFE_REDIRECT`
- `POLICY_HOST_KILL_SWITCH`

### 6.3. Capability failure kodlari

- `CAPABILITY_UNSUPPORTED_MERCHANT`
- `CAPABILITY_PATH_NOT_SUPPORTED`
- `CAPABILITY_REGION_NOT_SUPPORTED`

### 6.4. Fetch/render failure kodlari

- `FETCH_TIMEOUT`
- `FETCH_NETWORK_ERROR`
- `FETCH_LOGIN_WALL`
- `FETCH_REGION_LOCK`
- `RENDER_REQUIRED`
- `RENDER_TIMEOUT`

### 6.5. Extraction failure kodlari

- `EXTRACTION_EMPTY_RESULT`
- `EXTRACTION_AMBIGUOUS_RESULT`
- `EXTRACTION_CONFLICTING_FIELDS`
- `EXTRACTION_NON_PRODUCT_PAGE`

### 6.6. Identity/dedupe kodlari

- `DEDUPE_EXACT_DUPLICATE`
- `DEDUPE_POTENTIAL_REUSE`
- `DEDUPE_VARIANT_AMBIGUITY`

### 6.7. Review lifecycle kodlari

- `REVIEW_REQUIRED`
- `REVIEW_PAYLOAD_EXPIRED`
- `REVIEW_VALIDATION_FAILED`

### 6.8. Persistence failure kodlari

- `PERSISTENCE_CONFLICT`
- `PERSISTENCE_SOURCE_ATTACH_FAILED`
- `PERSISTENCE_CONTEXT_ATTACH_FORBIDDEN`

### 6.9. Refresh/maintenance failure kodlari

- `REFRESH_FETCH_FAILED`
- `REFRESH_STALE_THRESHOLD_REACHED`
- `REFRESH_SOURCE_BLOCKED`

---

## 7. Input failure'lari

### 7.1. Tanim

Import'un daha baslangicta urunsel olarak gecersiz girdi nedeniyle ilerleyememesidir.

### 7.2. Creator davranisi

- net hata mesajı
- job acilmaz
- duzelt ve tekrar dene onerisi

### 7.3. Retry politikasi

- otomatik retry yok
- yalnizca creator duzeltip yeniden gonderebilir

### 7.4. Ornek

- bos URL
- parse edilemeyen URL
- unsupported protocol

---

## 8. Policy failure'lari

### 8.1. Tanim

Guvenlik, abuse, hukuki veya runtime kill-switch nedeniyle import'un bilerek durdurulmasidir.

### 8.2. Creator davranisi

- neden tipi olabildigince acik anlatilir
- generic retry onerilmez
- gerekiyorsa support rotasi sunulur

### 8.3. Retry politikasi

- otomatik retry yok
- creator-side tekrar deneme tavsiye edilmez

### 8.4. Ornek

- blocked domain
- unsafe redirect
- merchant kill switch

---

## 9. Capability failure'lari

### 9.1. Tanim

Merchant veya path destek kapsami disinda oldugu icin import'un dogru kaliteyle islenememesidir.

### 9.2. Creator davranisi

- "desteklenmiyor" veya "bu sayfa tipi desteklenmiyor" acikligi verilir
- manual fallback sunulur

### 9.3. Retry politikasi

- otomatik retry yok
- ayni input'u tekrar islemek anlamsizdir

### 9.4. Ornek

- path not supported
- region not supported
- fallback-only degil, tamamen unsupported merchant

---

## 10. Fetch/render failure'lari

### 10.1. Tanim

Ag, fetch, render veya bot bariyeri gibi nedenlerle candidate artefact'larin toplanamamasidir.

### 10.2. Creator davranisi

- gecici mi kalici mi oldugu copy'de ayristirilir
- gerekiyorsa "arkaplanda tekrar deniyoruz" bilgisi gosterilir

### 10.3. Retry politikasi

Asagidaki backoff modeli uygulanir:

1. ilk retry: `30 saniye`
2. ikinci retry: `2 dakika`
3. ucuncu retry: `10 dakika`

Toplam `3` otomatik deneme sonrasi job `failed` olur.

### 10.4. Retry edilmeyen fetch/render durumlari

- login wall
- region lock
- bilinen blocked anti-bot state

Bunlar transient sayilmaz; capability/policy benzeri islenir.

---

## 11. Extraction failure'lari

### 11.1. Tanim

Fetch edilmis materyal var ama product icin anlamli candidate bundle olusturulamamistir.

### 11.2. Alt tipler

#### `EXTRACTION_EMPTY_RESULT`
Sayfa var ama anlamli field cikmadi.

#### `EXTRACTION_AMBIGUOUS_RESULT`
Birden fazla olasi product/image/title var.

#### `EXTRACTION_CONFLICTING_FIELDS`
Kritik alanlar birbirini ciddi sekilde yalanliyor.

#### `EXTRACTION_NON_PRODUCT_PAGE`
Listing/search/editorial page tespit edildi.

### 11.3. Recovery

- manual correction
- manual card fallback
- gerekiyorsa review payload ile kontrollu devam

### 11.4. Kritik kural

Ambiguity, teknik failure gibi davranilip retry loop'una sokulmaz.  
Bu durumun recovery yolu human review'dur.

---

## 12. Identity ve dedupe outcome'lari

Bu ailede her sonuc failure degildir.

### 12.1. `DEDUPE_EXACT_DUPLICATE`

Anlam:

- ayni source veya product zaten vardir

Recovery:

- existing kayda baglan
- creator'e mevcut sonucu goster

### 12.2. `DEDUPE_POTENTIAL_REUSE`

Anlam:

- reuse kuvvetli ihtimaldir

Recovery:

- verification UI reuse karari ister

### 12.3. `DEDUPE_VARIANT_AMBIGUITY`

Anlam:

- ayni aile ama farkli varyant olabilir

Recovery:

- creator review gerekir

Kural:

Duplicate tespiti teknik bug gibi islenmez; domain-level recovery yoludur.

---

## 13. Review lifecycle failure'lari

### 13.1. `REVIEW_REQUIRED`

Bu bir failure degil, kontrollu bekleme sonucudur.

### 13.2. `REVIEW_VALIDATION_FAILED`

Creator gerekli alanlari tamamlamadan apply etmeye calisti.

Recovery:

- field-level hata goster
- payload korunur

### 13.3. `REVIEW_PAYLOAD_EXPIRED`

Review payload 7 gunluk pencereyi asti.

Recovery:

- eski payload apply edilmez
- creator'e refresh/re-import yolu sunulur

---

## 14. Persistence failure'lari

### 14.1. Tanim

Verification sonucu var ama domain mutasyonu tamamlaniyor iken hata oldu.

### 14.2. Ornekler

- optimistic conflict
- source attach hatasi
- target context permission sorunu

### 14.3. Recovery ilkesi

1. verification payload kaybolmaz
2. idempotent safe retry varsa denenir
3. creator ayni extraction'i tekrar beklemek zorunda kalmaz

### 14.4. Retry

- tek seferlik idempotent retry uygulanabilir
- tekrar conflict olursa job `failed` olur ve support sinyali uretir

---

## 15. Refresh ve maintenance failure'lari

Bu failure'lar initial import'tan sonra olusur.

### 15.1. `REFRESH_FETCH_FAILED`

Source yenilenemedi.

Beklenen davranis:

- current data hemen silinmez
- freshness state policy'ye gore stale/hide'a gider

### 15.2. `REFRESH_STALE_THRESHOLD_REACHED`

Bu teknik failure degil, policy sonucu outcome'tur.

### 15.3. `REFRESH_SOURCE_BLOCKED`

Merchant/source artk policy geregi kullanilamiyor.

Beklenen davranis:

- public trust state guncellenir
- product kaydi korunur

---

## 16. Creator-facing copy ilkeleri

Creator'e gosterilen hata veya warning copy'si su uc soruya cevap vermelidir:

1. ne oldu?
2. bu gecici mi kalici mi?
3. simdi ne yapabilirim?

### 16.1. Kullanilmayacak dil

- generic "bir seyler ters gitti"
- teknik stack trace
- action'siz failure mesajı

### 16.2. Kullanilacak dil

- "bu link desteklenmiyor, istersen manuel urun olustur"
- "sayfadan net urun bilgisi cikarilamadi, kontrol edip duzeltmen gerekiyor"
- "bu urun zaten kutuphanende olabilir, mevcut kaydi kullanmak ister misin?"

---

## 17. Recovery yollarinin resmi sirasi

Failure sinifina gore recovery yollari su ailelerden birine duser:

1. duzelt ve yeniden gonder
2. bekle, sistem retry etsin
3. review/correction ile devam et
4. manual fallback ile ilerle
5. mevcut product/source'a baglan
6. support/ops escalation

Bu yollar birbirine karistirilmaz.

---

## 18. Sistemik failure tanimi

Tekil failure ile sistemik failure farklidir.

### 18.1. Isolated failure

Tekil veya nadir durum.  
Runbook acmaz.

### 18.2. Repeated failure

Ayni merchant ve ayni code ailesinde `15 dakika` icinde `10+` failure.

Beklenen davranis:

- warning alert
- registry veya worker incelemesi

### 18.3. Systemic failure

Asagidaki esiklerden biri:

- ayni merchant icin `30 dakika` icinde `%25+` failure rate
- global import queue'da `15 dakika` boyunca backlog artisi ile birlikte fetch/render fail spike'i
- unsafe redirect/policy block code'larinda ani artis

Beklenen davranis:

- runbook tetiklenir
- gerekiyorsa tier demotion veya kill switch değerlendirilir

---

## 19. Support ve ops beklentileri

### 19.1. Support ne gormelidir?

- submitted URL
- failure code
- stage
- recovery onerisi
- manual fallback kullanildi mi
- creator review durumu

### 19.2. Ops ne gormelidir?

- merchant bazli failure dagilimi
- retry queue etkisi
- render/fetch latency
- kill switch veya tier review ihtiyaci

---

## 20. Senaryolar

## 20.1. Senaryo A: Invalid URL

Beklenen davranis:

- job acilmaz
- creator duzeltip tekrar dener

## 20.2. Senaryo B: Blocked merchant

Beklenen davranis:

- aninda `blocked`
- manual fallback bile policy geregi kapali olabilir

## 20.3. Senaryo C: Timeout sonra basarili retry

Beklenen davranis:

- creator "isleniyor" durumunu gorur
- ayni import'u tekrar spamlamaz

## 20.4. Senaryo D: Ambiguous extraction

Beklenen davranis:

- `needs_review`
- manual correction ile devam

## 20.5. Senaryo E: Exact duplicate

Beklenen davranis:

- mevcut product/source'a baglan
- yeni product yaratma

## 20.6. Senaryo F: Persistence conflict

Beklenen davranis:

- payload korunur
- safe retry veya creator'e tekrar deneme yolu sunulur

---

## 21. Failure ve edge-case senaryolari

### 21.1. Job processing tamamlandi ama UI response kayboldu

Beklenen davranis:

- job state source of truth olur
- creator ayni import'u tekrar gonderdiginde mevcut job referanslanir

### 21.2. Manual fallback acildi ama save sirasinda hata oldu

Beklenen davranis:

- girilen field'ler kaybolmaz
- creator yeniden sifirdan baslamaz

### 21.3. Region lock bazen aciliyor bazen kapanıyor

Beklenen davranis:

- transient ile capability ayrimi telemetry'de izlenir
- tekrar eden pattern registry review'una gider

### 21.4. Duplicate suggestion yanlis cikip creator yeni product acti

Beklenen davranis:

- teknik failure sayilmaz
- quality observation olarak kayda girer

---

## 22. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Tum olumsuz sonuclari tek `failed` durumuna gommek
2. Unsupported merchant'i timeout gibi retry etmek
3. Ambiguous extraction'i teknik failure gibi gormek
4. Duplicate detection'i error copy'siyle sunmak
5. Persistence failure'da verification payload'i kaybetmek
6. Systemic failure esikleri olmadan operasyon yurütmek

---

## 23. Bu belge sonraki belgelere ne emreder?

1. `101-runbooks.md`, failure code ailelerini ve systemic esikleri kullanarak operasyonel ilk-15-dakika adimlarini yazmalidir.
2. `103-support-playbooks.md`, creator-facing response sablonlarini bu failure taxonomy ile birebir eslemelidir.
3. `56-empty-loading-error-and-state-spec.md`, `blocked`, `failed`, `needs_review`, `expired` ve `manual_fallback` state'lerini birbirinden ayri tasarlamalidir.
4. `83-import-accuracy-test-matrix.md`, her failure class icin en az bir acceptance ve bir edge-case testi icermelidir.

---

## 24. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator hata aninda ne oldugunu ve ne yapabilecegini anlayabiliyorsa
- support ve ops ayni vakayi ayni failure code diliyle yorumlayabiliyorsa
- retry yalnizca anlamli yerlerde calisiyor, gereksiz loop olusturmuyorsa
- duplicate, ambiguity ve blocked durumlari teknik ariza ile karismiyorsa

Bu belge basarisiz sayilir, eger:

- hala genis bir "import fail" torbasi kullaniyorsak
- manual fallback ve reuse recovery yollari failure mesajlari icinde kayboluyorsa
- hangi failure'in sistemik incident sayildigi belirsizse

