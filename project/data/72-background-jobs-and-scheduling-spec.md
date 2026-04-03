---
id: BACKGROUND-JOBS-SCHEDULING-SPEC-001
title: Background Jobs and Scheduling Spec
doc_type: async_processing_spec
status: ratified
version: 2.0.0
owner: backend
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - JOB-QUEUE-WORKER-REFRESH-ARCHITECTURE-001
  - PRICE-AVAILABILITY-REFRESH-POLICY-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
  - DATABASE-SCHEMA-SPEC-001
  - OBSERVABILITY-INTERNAL-EVENT-MODEL-001
blocks:
  - RUNBOOKS
  - INCIDENT-RESPONSE-PROJECT-LAYER
  - RELEASE-READINESS-CHECKLIST
---

# Background Jobs and Scheduling Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` urunundeki asenkron islerin hangi job siniflarina ayrilacagini, hangi event veya scheduler sinyaliyle tetiklenecegini, queue onceliklerini, concurrency ve dedup kurallarini, retry/backoff davranisini, dead-letter ile parked is ayrimini ve maintenance/scheduling pencerelerini tanimlayan resmi async processing spesifikasyonudur.

Bu belge yalnizca "hangi isler arkada calisir?" sorusunu cevaplamaz.  
Asagidaki sorulara da cevap verir:

- User-triggered import ile scheduled refresh neden farkli queue siniflarina ayrilir?
- Hangi job'lar event-driven, hangileri cron-driven, hangileri operator-driven olur?
- Selected public source refresh pencereleri hangi sayisal esiklerle planlanir?
- Retry edilecek ve edilmeyecek failure tipleri nasil ayrilir?
- Parked, dead-letter ve cancelled state'leri ne zaman kullanilir?
- Operator override hangi sinirlarla allowed olur?

---

## 2. Bu belge neden kritiktir?

Bu urunde asenkron katman yalniz performans optimizasyonu degildir.  
Import, refresh, media, OG, domain verification, billing reconcile ve retention purge gibi davranislar request-response icinde guvenli sekilde tamamlanamaz.

Job modeli yüzeysel kalirsa tipik bozulmalar sunlardir:

1. User import'lari stale maintenance tarafindan bogulur.
2. Ayni source icin coklu refresh ayni anda calisir.
3. Retry ile policy block ayrimi bozulur.
4. Publicte stale gorsel veya stale fiyat uzun sure kalir.
5. Support "neden bu job takildi?" sorusuna cevap veremez.
6. Queue provider metric'i var diye durable product truth'u var sanilir.

Bu nedenle background jobs katmani teknik detay degil, urun davranisinin operasyonel omurgasidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` asenkron isleri tek tip queue mantigiyla degil; user-critical import, publication-adjacent refresh/generation, background maintenance, governance ve provider-ingress aileleri olarak ayrisan; durable kayitli, idempotent, concurrency-controlled ve failure-code-aware bir job sistemi ile yurutecektir.

Bu karar su sonuclari dogurur:

1. `P0` user-critical isler scheduled sweep'ler tarafindan bloke edilmez.
2. Ayni entity icin paralel duplicate run engellenir.
3. Retry mantigi failure kodu ailesine gore belirlenir.
4. Scheduler, selected public source ile library-only source arasinda fark gonderir.
5. Ops override yalniz sinirli route ve reason code ile mumkun olur.

---

## 4. Async is aileleri

Bu urunde asenkron isler alti ana aileye ayrilir:

1. import lifecycle jobs
2. refresh and trust jobs
3. media and preview generation jobs
4. billing / provider sync jobs
5. governance jobs
6. maintenance and cleanup jobs

### 4.1. Import lifecycle jobs

Ornekler:

- initial import processing
- retry import processing
- manual refresh requested by creator
- verification expiry cleanup

### 4.2. Refresh and trust jobs

Ornekler:

- selected source scheduled refresh
- library-only source refresh
- broken link recheck
- blocked-but-reviewable source recheck

### 4.3. Media and preview generation jobs

Ornekler:

- media variant generation
- OG/share asset generation
- preview invalidation follow-up

### 4.4. Billing / provider sync jobs

Ornekler:

- entitlement recompute
- billing reconcile
- domain verification poll
- provider quota/health follow-up

### 4.5. Governance jobs

Ornekler:

- data export build
- deletion workflow process
- ownership recovery follow-up

### 4.6. Maintenance and cleanup jobs

Ornekler:

- temporary candidate purge
- orphan asset sweep
- expired verification sweep
- archive/purge eligibility sweep

---

## 5. Job topolojisi

Async akisin standart topolojisi su adimlari izler:

1. HTTP veya internal event bir command uretir
2. domain/application service durable kaydi yazar
3. gerekiyorsa outbox event yaratilir
4. worker/scheduler ilgili workflow'u kabul eder
5. run context ile asamalar isletilir
6. sonuc DB + telemetry + gerekli invalidation event'lerine yazilir

Kural:

Queue provider veya scheduler tek source of truth degildir.  
Durable state her zaman uygulamanin kendi veritabanindaki workflow tablolarinda tutulur.

---

## 6. Priority siniflari

Asgari priority aileleri:

- `P0-user-critical`
- `P1-user-visible`
- `P2-background`
- `P3-cleanup`

### 6.1. `P0-user-critical`

Isler:

- initial import
- creator-triggered retry
- creator-triggered manual refresh
- publish-on-demand critical validation refresh

Beklenti:

- dusuk queue bekleme suresi
- agresif observability
- concurrency guard zorunlu

### 6.2. `P1-user-visible`

Isler:

- public selected source refresh
- publish sonrasi OG generate
- custom domain verify retry
- billing entitlement sync follow-up

### 6.3. `P2-background`

Isler:

- library-only source refresh
- broken link periodic sweep
- merchant capability health checks
- operational reconcile isleri

### 6.4. `P3-cleanup`

Isler:

- temp candidate purge
- expired verification cleanup
- orphan media sweep
- retention purge

Kural:

`P2` ve `P3`, scheduler dolu olsa bile `P0` kapasitesini tuketemez.

---

## 7. Trigger tipleri

Her job bir trigger sinifina aittir:

1. request-driven
2. domain-event-driven
3. scheduled
4. provider-ingress-driven
5. operator-driven

### 7.1. Request-driven

HTTP istegi ile dogrudan job kabul edilir.

Ornek:

- import create
- import retry
- publish command'i sonrasi preview generation

### 7.2. Domain-event-driven

Uygulama icindeki event'ten dogar.

Ornek:

- `page.published`
- `source.selected_changed`
- `verification.expired`

### 7.3. Scheduled

Belirli zaman pencerelerinde eligibility sorgusuna gore calisir.

Ornek:

- stale source sweep
- expired session cleanup
- reconcile job'lari

### 7.4. Provider-ingress-driven

Webhook veya dis servis olaylari ile dogar.

Ornek:

- billing entitlement recompute
- domain verification follow-up
- extraction quota downgrade

### 7.5. Operator-driven

Ops/support kontrollu tetik.

Kural:

Operator-driven run, standard schedule'i bypass edebilir ama audit reason ve actor kaydi olmadan calismaz.

---

## 8. Job katalogu

Launch icin asgari job katalogu asagidadir.

### 8.1. Import ailesi

- `import.process.initial`
- `import.process.retry`
- `import.process.manual_refresh`
- `import.verification.expire`
- `import.review.reminder` opsiyonel sonraki faz

### 8.2. Refresh ailesi

- `source.refresh.public_selected`
- `source.refresh.library_selected`
- `source.refresh.manual_selected`
- `source.recheck.broken`
- `source.recheck.blocked_reviewable`

### 8.3. Generation ailesi

- `media.variant.generate`
- `og.generate.surface`
- `og.invalidate.followup`

### 8.4. Billing ve provider ailesi

- `billing.entitlement.recompute`
- `billing.subscription.reconcile`
- `domain.verification.retry`
- `provider.health.reconcile`

### 8.5. Governance ailesi

- `export.build`
- `deletion.process`
- `ownership.transfer.followup`

### 8.6. Cleanup ailesi

- `cleanup.temp_media_candidates`
- `cleanup.expired_verification_sessions`
- `cleanup.orphan_assets`
- `cleanup.retention_purge`

Kural:

Bu katalog disinda yeni job ailesi acmak, belge guncellemesi veya ADR gerektirir.  
`misc_task` benzeri genel is isimleri yasaktir.

---

## 9. Run context zorunlu alanlari

Her job run asgari su context'i tasir:

- `run_id`
- `job_type`
- `trigger_type`
- `priority_class`
- `workspace_id` varsa
- `actor_user_id` varsa
- `target_entity_type`
- `target_entity_id`
- `idempotency_key` veya `dedup_key`
- `attempt_number`
- `requested_at`
- `started_at`
- `reason_code`

Opsiyonel ama sik kullanilan alanlar:

- `merchant_key`
- `surface_type`
- `surface_id`
- `verification_session_id`
- `import_job_id`
- `publication_revision`

Kural:

Run context'siz generic worker execution kabul edilmez.  
Support ve telemetry korelasyonu icin bu alanlar zorunludur.

---

## 10. Concurrency ve dedup kurallari

## 10.1. Import concurrency

Ayni `creator_profile + normalized_url + intent + target_context` kombinasyonu icin aktif `P0` import calisirken yeni is:

1. ayni active job'a yonlendirilebilir
2. ya da `duplicate submission` semantigiyle engellenebilir

Ama ikinci ayri processing run yaratmak yasaktir.

## 10.2. Source refresh concurrency

Ayni `product_source_id` icin tek aktif refresh run olur.

Davranis:

- yeni request varsa coalesce edilir
- ya da mevcut run bitene kadar skip edilir

## 10.3. OG generation concurrency

Ayni `surface_type + surface_id + publication_revision` icin tek aktif generation olur.

## 10.4. Cleanup concurrency

Cleanup isleri entity-partition bazli parcali calisabilir; ama ayni entity icin duplicate destructive run acilmaz.

## 10.5. Billing reconcile concurrency

Ayni subscription veya creator profile icin overlap eden reconcile run'lari serialize edilir.

---

## 11. Schedule pencereleri

Scheduler cron gibi her satira tek tek alarm kurmak yerine eligibility-query modeli kullanir.

Yani:

1. periyodik secim job'i calisir
2. uygun entity'leri query ile bulur
3. priority ve budget kurallarina gore alt job uretir

Bu model daha kontrollu ve gozlemlenebilir kabul edilir.

---

## 12. Refresh cadans matrisi

Refresh sikligi sadece merchant tier'e degil, source'un urundeki rolune de baglidir.

### 12.1. Publicte secili source

#### Full tier

- hedef refresh: her `12` saat
- max kabul edilebilir gecikme: `24` saat

#### Partial tier

- hedef refresh: her `24` saat
- max kabul edilebilir gecikme: `36` saat

#### Fallback-only tier

- hedef refresh: her `18` saat
- max kabul edilebilir gecikme: `30` saat

Neden fallback-only daha kisa hedeflenir?

Cunku veri belirsizligi daha yuksek oldugu icin stale'e dusmeden once tekrar denemek gerekir.  
Bu "daha iyi kalite" degil, "daha ihtiyatli denetim" anlamina gelir.

### 12.2. Library'de secili ama publicte gorunmeyen source

#### Full tier

- hedef refresh: her `72` saat

#### Partial tier

- hedef refresh: her `96` saat

#### Fallback-only tier

- hedef refresh: her `120` saat

### 12.3. Publicte secili olmayan secondary source

Varsayilan:

- arka planda agressif refresh uygulanmaz
- explicit selection adayi veya ops inceleme konusu ise hedefli refresh alabilir

### 12.4. Broken source recheck

- ilk recheck: `6` saat sonra
- ikinci recheck: `24` saat sonra
- ucuncu recheck: `72` saat sonra

Sonrasinda sistem source'u stale/blocked semantigine gore pasife alir; sonsuz retry yapmaz.

### 12.5. Publish-on-demand guard refresh

Page publish aninda secili source:

- hic kontrol edilmemisse
- ya da kontrolu tier icin kabul edilen pencereyi asmis ise

`P0` veya `P1` acil refresh job'i tetiklenebilir.

---

## 13. Cleanup ve governance schedule'lari

### 13.1. Verification expiry sweep

- her `1` saat
- expiry gecen session'lari `expired` state'ine ceker

### 13.2. Temp media candidate purge

- her `6` saat
- secilmeyen ve retention penceresi dolan adaylari siler

### 13.3. Orphan asset sweep

- gunluk
- parent entity bagini kaybetmis ama purge icin uygun asset'leri listeler

### 13.4. Export artifact expiry

- gunluk
- download penceresi dolmus export artefact'larini temizler

### 13.5. Retention purge

- gunluk veya haftalik toplu pencere
- R2/R3/R4 policy'lerine gore eligibility query calistirir

### 13.6. Billing reconcile

- gunluk
- webhook kacirma veya provider drift ihtimaline karsi reconcile calisir

---

## 14. Retry politikasi

Retry karari generic exception uzerinden degil, failure family uzerinden verilir.

### 14.1. Retry edilen failure aileleri

- gecici network timeout
- upstream `429`
- upstream `5xx`
- gecici renderer kapasite sorunu
- object storage gecici yazma sorunu
- revalidation provider gecici timeout

### 14.2. Retry edilmeyen failure aileleri

- blocked domain
- unsupported merchant
- malformed URL
- manual review gerektiren ambiguity
- authorization/permission hatasi
- deterministic validation failure

### 14.3. Varsayilan backoff plani

`P0` ve `P1` icin:

1. `30` saniye
2. `2` dakika
3. `10` dakika

`P2` ve `P3` icin:

1. `5` dakika
2. `30` dakika
3. `2` saat

Max retry:

- kritik user-visible isler icin `3`
- maintenance isleri icin `3` veya `4`, ama reason'a bagli

### 14.4. Jitter

Upstream'e ayni anda yuklenmemek icin jitter zorunludur.

### 14.5. Retry state semantigi

Her retry attempt'i `import_job_attempts` veya ilgili workflow kaydina ayri yazilir.  
Tek satir ustunde counter artirmak yeterli kabul edilmez.

---

## 15. Parked, dead-letter ve cancelled ayrimi

Bu uc state ayni seyi ifade etmez.

### 15.1. Parked

Islem teknik olarak tekrar denenebilir ama otomatik retry mantigiyla devam etmesi dogru degildir.

Ornek:

- upstream drift supheli
- merchant capability downgrade bekleniyor
- insan incelemesi gerektiren sinir durumda

### 15.2. Dead-letter

Teknik olarak tekrarli fail etmis ve otomatik akistan cikarilmis run.

Ornek:

- ard arda render timeout
- sürekli storage write hatasi

### 15.3. Cancelled

Sistem veya actor islem devam etmeden once akisi iptal etmistir.

Ornek:

- creator retry yerine job'i iptal etti
- ownership scope degisti
- target entity archive edildi

Kural:

Parked job daha sonra operator karariyla yeniden kuyruga alinabilir.  
Dead-letter dogrudan user-facing success semantigi gibi davranmaz.

---

## 16. Operator override kurallari

Ops/support su override'lari yapabilir:

- parked job'i yeniden kuyruga almak
- belirli merchant icin refresh kampanyasi acmak
- import job retry reason'i ekleyerek tekrar denemek
- domain verify retry baslatmak

Yasak olanlar:

1. failure code'u sessizce temizlemek
2. dedup/concurrency guard'i tamamen kapatmak
3. billing entitlement'i webhook olmadan "sanki geldi" diye islemek
4. creator review gerektiren import'u user adina sessizce apply etmek

Her override icin zorunlu alanlar:

- operator user id
- reason code
- human note
- target entity
- override scope

---

## 17. Budget ve throttle kurallari

Scheduler yalniz zamanlamaya bakmaz; maliyet ve kapasite butcesine de bakar.

### 17.1. Throttle edilebilecek aileler

- library-only refresh
- secondary source refresh
- bulk OG regeneration
- non-urgent cleanup

### 17.2. Throttle edilemeyecek aileler

- active import processing
- publish-critical validation
- billing reconcile after webhook
- deletion process

### 17.3. Merchant-level circuit break

Belirli merchant'ta sistemik failure gorulurse:

1. bulk refresh yavaslatilir
2. yeni scheduled run acilmaz
3. publicte stale/trust state dogru yansitilir
4. ops alert uretilir

---

## 18. Job basari ve basarisizlik olcutleri

Her job ailesi icin asgari metrikler:

### 18.1. Import

- acceptance to completion median suresi
- review-required orani
- retry orani
- failure family dagilimi

### 18.2. Refresh

- target refresh SLA uyum orani
- stale'e dusen selected source sayisi
- broken source recheck basari orani

### 18.3. Generation

- OG generation latency
- variant generation failure rate

### 18.4. Governance

- export ready time
- deletion completion time

### 18.5. Cleanup

- purge backlog
- orphan asset count

---

## 19. Alert esikleri

Asgari alert aileleri:

1. `P0` queue backlog artisi
2. Import median duration belirgin bozulmasi
3. Selected public source stale count esigi
4. Webhook tetikli reconcile queue tikanmasi
5. Dead-letter sayisinda ani artis

Ornek esikler:

- `P0` backlog `5` dakikayi asarsa warning
- `P0` backlog `15` dakikayi asarsa incident-level alert
- selected public source stale oranı `%5` ustune cikarsa warning
- dead-letter bir merchant'ta `10` u asarsa ops inceleme

Bu sayilar implementasyon sirasinda calibration gorebilir; ama esik mantigi kaldirilmaz.

---

## 20. Senaryo bazli akışlar

### 20.1. Senaryo: Creator yeni URL import eder

Beklenen akış:

1. HTTP kabul olur
2. `import.process.initial` `P0` olarak kuyruga girer
3. concurrency/dedup guard calisir
4. fetch -> extraction -> reuse -> verification asamalari ilerler
5. verification gerekiyorsa job `needs_review` ile biter

Olasi sorunlar:

- renderer timeout
- merchant blocked
- duplicate submission

Beklenen sistem davranisi:

- retry edilen teknik failure'lar ayrik attempt kaydi alir
- `blocked` tier merchant retry'a sokulmaz
- duplicate run yeni processing baslatmaz

### 20.2. Senaryo: Publicte secili source stale'e yaklasir

Beklenen akış:

1. scheduler eligibility query calistirir
2. `source.refresh.public_selected` job'i `P1` olarak acilir
3. same source concurrency guard calisir
4. basariliysa freshness state guncellenir
5. threshold degisti ise revalidation event'i uretilir

### 20.3. Senaryo: Merchant sistemik `429` dondurur

Beklenen akış:

1. job temporary failure olarak isaretlenir
2. jitter'li backoff uygulanir
3. merchant-level error rate esigi asilirse circuit-break benzeri throttle devreye girer
4. stale truth publicte saklanmaz

### 20.4. Senaryo: Verification session expiry

Beklenen akış:

1. per-hour sweep calisir
2. expiry gecen session `expired` olur
3. import job read model'inde review yenileme ihtiyaci gorunur
4. apply endpoint stale session'i kabul etmez

### 20.5. Senaryo: Domain verification tekrar denemesi

Beklenen akış:

1. webhook veya scheduler pending domain'i bulur
2. `domain.verification.retry` acilir
3. provider sonucu kaydedilir
4. success ise public canonical/domain davranisi guncellenir
5. failure tekrarli ise parked veya operator review gerekir

---

## 21. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Her seyi tek queue'ya atmak
2. Retry edilmeyecek failure'lari sonsuza kadar denemek
3. Selected public source ile secondary source'a ayni refresh cadansini uygulamak
4. Queue provider dashboard'unu durable truth saymak
5. Operator'un review-required import'u user yerine sessizce apply etmesi
6. Dead-letter ile parked durumlarini ayni kabul etmek
7. Publish sirasinda gereken validation refresh'ini "sonra bakariz" diye atlamak
8. Upstream `429` durumunda ayni anda daha cok retry atmak

---

## 22. Bu belge sonraki belgelere ne emreder?

### 22.1. Runbook'lara

- her job ailesi icin kabul, retry, parked ve dead-letter proseduru yazilacak

### 22.2. Incident response belgesine

- hangi esiklerin incident seviyesine cikacagi bu priority ve alert mantigina gore kurulacak

### 22.3. Release readiness checklist'e

- `P0/P1` queue health ve refresh SLA kanitlari girilecek

---

## 23. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin su kosullar saglanmis olmalidir:

1. Hangi async isin neden ve nasil tetiklendigi nettir.
2. Refresh cadanslari source tier ve public exposure'a gore sayisal olarak tanimlanmistir.
3. Retry, parked ve dead-letter farki operasyonel olarak uygulanabilir hale gelmistir.
4. Operator override cizgisi aciktir.
5. Yeni bir muhendis veya ops sorumlusu, "bu is ne zaman calisir ve takilinca ne olur?" sorusunu ek aciklama istemeden cevaplayabilir.
