---
id: JOB-QUEUE-WORKER-REFRESH-ARCHITECTURE-001
title: Job Queue, Worker and Refresh Architecture
doc_type: async_processing_architecture
status: ratified
version: 2.0.0
owner: backend
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - PRICE-AVAILABILITY-REFRESH-POLICY-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
blocks:
  - BACKGROUND-JOBS-SCHEDULING-SPEC
  - RUNBOOKS
  - OBSERVABILITY-INTERNAL-EVENT-MODEL
---

# Job Queue, Worker and Refresh Architecture

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde import, retry, source refresh, broken-link check, media/OG regeneration ve retention purge gibi asenkron islerin hangi job siniflarina ayrildigini, queue önceliklerini, concurrency ve idempotency kurallarini, worker stage'lerini ve refresh execution modelini tanimlayan resmi async processing architecture belgesidir.

Bu belge su sorulara cevap verir:

- Hangi işler neden queue'ya gider?
- User-triggered import ile scheduled refresh neden ayni öncelikte değildir?
- Concurrency key ve idempotency anahtarı nasıl kullanılır?
- Retry hangi sınıflarda anlamlıdır?
- Worker stage'leri ve run context alanları neler olmalıdır?
- Refresh neden viewer request'inde tetiklenmez?

Bu belge, worker katmanını "arka planda birkaç cron" seviyesinden çıkarır.

---

## 2. Bu belge neden kritiktir?

Import bu urunun teknik cekirdegidir.  
Async iş modeli yanlış kurulursa:

1. duplicate import run'ları oluşur
2. refresh queue user-critical import'ları boğar
3. retry ve policy block birbirine karışır
4. stale price davranışı yanlış zamanlanır
5. ops hangi işin neden takıldığını anlayamaz

Bu nedenle queue/worker mimarisi ops detayı değil, ürün davranışının parçasıdır.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` async iş hattı tek tip kuyruk mantığıyla değil; kullanıcı-etkili import işleri, bakım/refresh işleri, generation işleri ve governance/cleanup işleri olarak ayrı sınıflanan; idempotent, concurrency-controlled ve failure taxonomy-aware bir worker mimarisiyle çalışacaktır.

Bu karar su sonuclari dogurur:

1. User-triggered import işleri scheduled maintenance'i sollar.
2. Aynı source için gereksiz paralel refresh engellenir.
3. Policy block retry'a sokulmaz.
4. Worker telemetry, import failure taxonomy ile aynı dili kullanır.

---

## 4. İş sınıfları

Async işler dört ana aileye ayrılır:

1. user-triggered import jobs
2. refresh and maintenance jobs
3. generation jobs
4. governance / cleanup jobs

### 4.1. User-triggered import jobs

Ornekler:

- initial import
- explicit retry import
- manual refresh requested by creator

### 4.2. Refresh and maintenance jobs

Ornekler:

- scheduled source refresh
- broken link sweep
- stale source sweep

### 4.3. Generation jobs

Ornekler:

- OG/share image generation trigger
- transformed media regeneration

### 4.4. Governance / cleanup jobs

Ornekler:

- retention purge
- cleanup of temp extraction artefacts

---

## 5. Queue öncelik modeli

Asgari priority sınıfları:

- `P0-user-critical`
- `P1-user-visible-maintenance`
- `P2-background-maintenance`
- `P3-cleanup`

### 5.1. `P0-user-critical`

- initial import
- creator requested refresh

### 5.2. `P1-user-visible-maintenance`

- selected/public source refresh
- broken link recheck

### 5.3. `P2-background-maintenance`

- library-only refresh
- stale sweep

### 5.4. `P3-cleanup`

- purge
- temp file cleanup

Kural:

P2 ve P3, P0 kuyruğunu boğamaz.

---

## 6. Idempotency ve concurrency

### 6.1. Job identity

Her job asgari olarak şu context'i taşır:

- `job_type`
- `actor_id` varsa
- `target_entity_type`
- `target_entity_id`
- `idempotency_key`

### 6.2. Import idempotency

Ayni actor + normalized URL + intent + target context için kisa pencere icinde duplicate run engellenir.

### 6.3. Refresh concurrency

Ayni source için:

- tek aktif refresh run
- sonraki run coalesce veya drop

kuralı uygulanır.

### 6.4. Generation concurrency

Ayni asset icin ayni anda coklu derive/generate job acılmaz.

---

## 7. Worker stage modeli

### 7.1. Import job stage'leri

1. job accepted
2. fetch
3. extraction
4. candidate assembly
5. dedupe/reuse analysis
6. verification payload persist
7. apply if confirmed

### 7.2. Refresh job stage'leri

1. source eligibility check
2. fetch
3. field refresh
4. freshness state recompute
5. invalidation events

### 7.3. Cleanup stage'leri

1. candidate scan
2. eligibility check
3. purge or archive action
4. audit emit

---

## 8. Retry modeli

### 8.1. Retry edilen failure'lar

- transient network failure
- fetch timeout
- temporary renderer failure
- temporary provider outage

### 8.2. Retry edilmeyenler

- blocked domain
- unsupported protocol/path
- unsafe redirect
- deterministic policy block

### 8.3. Retry planı

Genel backoff:

1. 30 saniye
2. 2 dakika
3. 10 dakika

Max `3` deneme.

### 8.4. Dead-letter ilkesi

Tekrarli fail sonrası:

- dead-letter benzeri kayıt
- ops alert
- systematic cluster analizi

---

## 9. Refresh execution modeli

### 9.1. Refresh neden worker işi?

Cunku:

- external fetch
- rate limit
- anti-bot risk
- schedule ve freshness policy

API request'inde güvenli yönetilemez.

### 9.2. Refresh trigger'ları

- scheduled
- creator manual request
- support/ops controlled retry
- quality trigger

### 9.3. Viewer request neden trigger degil?

Viewer page acılışı gerçek zamanlı refresh tetiklemez.

Neden:

- latency
- cost
- risk

---

## 10. Merchant tier ile worker davranisi iliskisi

Worker runtime, registry tier'a göre davranır.

### 10.1. Full tier

- adapter-first
- regular refresh enabled

### 10.2. Partial tier

- generic parse ağırlıklı
- daha seyrek refresh

### 10.3. Fallback-only

- manual-review heavy
- scheduled refresh minimal veya yok

### 10.4. Blocked

- import/refresh durdurulur

---

## 11. Event ve telemetry yayılımı

Her job şu event ailelerini üretebilir:

- queued
- started
- stage completed
- failed
- blocked
- retried
- dead-lettered

### Kural

Request id, job id, source host, merchant tier ve failure code korelasyonu kaybolmaz.

---

## 12. Resource isolation

### 12.1. Import vs refresh

Scheduled refresh, active creator import kuyruğunu etkilememelidir.

### 12.2. Generation jobs

OG/media generation, import critical path dışında yürütülür.

### 12.3. Cleanup jobs

Cleanup işlerinin peak creator saatlerinde agresif çalışması gerekmez.

---

## 13. Failure konsantrasyon alanlari

Worker tarafında en kritik riskler:

1. duplicate import processing
2. stale retry loops
3. refresh queue starvation
4. policy block'ların retry ile boğulması
5. telemetry correlation kaybı

---

## 14. Edge-case senaryolari

### 14.1. Import extraction tamamlandı, apply aşamasında conflict çıktı

Beklenen davranis:

- verification payload korunur
- job partial failure olarak işaretlenir

### 14.2. Same source için user-triggered refresh varken scheduled refresh geldi

Beklenen davranis:

- scheduled refresh drop veya coalesce edilir

### 14.3. Merchant kill switch import sırasında aktif oldu

Beklenen davranis:

- sonraki stage policy block'a döner
- anlamsız retry olmaz

### 14.4. Worker crash sonrası restart

Beklenen davranis:

- durable job state üzerinden güvenli resume/retry
- duplicate apply engellenir

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Import ve refresh'i tek FIFO queue gibi ele almak
2. Ayni source'a paralel refresh izin vermek
3. Policy block'ları retry'a sokmak
4. Generation job'larını import critical path'ine bağlamak
5. Worker telemetry'yi failure taxonomy'den koparmak

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `72-background-jobs-and-scheduling-spec.md`, schedule ve ownership detaylarını bu queue sınıflarına göre yazmalıdır.
2. `101-runbooks.md`, retry/dead-letter/spike runbook'larını bu failure ve priority modeliyle uyumlu kurmalıdır.
3. `69-observability-and-internal-event-model.md`, job telemetry ve stage korelasyonunu bu belgeye göre tanımlamalıdır.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- import işleri kullanıcı açısından hızlı ve öngörülebilir kalıyorsa
- scheduled bakım işleri user-critical kuyruğu boğmuyorsa
- retry ve policy block davranışları karışmıyorsa
- ops tekil job ile sistemik spike'i aynı event modelinden okuyabiliyorsa

Bu belge basarisiz sayilir, eger:

- worker davranışı "arka planda ne olursa olsun" seviyesinde kalıyorsa
- duplicate processing ve starvation sorunları tasarım seviyesinde çözümsüz bırakılıyorsa

