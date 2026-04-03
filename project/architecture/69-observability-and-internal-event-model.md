---
id: OBSERVABILITY-INTERNAL-EVENT-MODEL-001
title: Observability and Internal Event Model
doc_type: observability_architecture
status: ratified
version: 2.1.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - RISK-REGISTER-001
  - SUCCESS-CRITERIA-LAUNCH-GATES-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
  - JOB-QUEUE-WORKER-REFRESH-ARCHITECTURE-001
blocks:
  - PERFORMANCE-BUDGETS
  - RUNBOOKS
  - INCIDENT-RESPONSE-PROJECT-LAYER
---

# Observability and Internal Event Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde teknik sağlık sinyalleri, import kalite sinyalleri, trust/freshness sinyalleri, internal event isimlendirme kuralları, request-job-actor korelasyonu, alert eşikleri ve support/ops ekiplerinin aynı vakayı aynı telemetry omurgasından okuyabilmesi için gerekli observability modelini tanımlayan resmi telemetry architecture belgesidir.

Bu belge su sorulara cevap verir:

- Hangi olaylar event olarak kaydedilmelidir?
- Teknik sağlık ile ürün kalitesi nasıl ayrılır?
- Import, refresh, publish ve support action'ları nasıl korele okunur?
- Hangi eşikler runbook/incident tetikler?
- Privacy çizgisi bozulmadan ne kadar gözlem yapabiliriz?

Bu belge, observability'yi yalnız log veya error tracking konusu olmaktan çıkarır.

---

## 2. Bu belge neden kritiktir?

Bu urunde en tehlikeli bozulmalar sessiz olabilir:

- manual correction oranı artar
- stale source sayısı yükselir
- duplicate confusion belirli merchant'ta patlar
- blocked domain'ler sessizce çoğalır

Sadece latency/error rate izlenirse bunlar kaçırılır.  
Dolayısıyla observability burada hem teknik sağlık hem ürün doğruluğu sorunudur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase`, yalnız teknik health metrikleriyle değil; import doğruluğu, manual correction, stale trust etkisi, failure taxonomy dağılımı ve supportable internal action visibility üzerinden de izlenecektir; tüm kritik olaylar request/job/actor/merchant korelasyonuyla kaydedilecektir.

Bu karar su sonuclari dogurur:

1. `import_failed` tek başına yeterli event değildir; failure code gerekir.
2. Support ve ops mutasyonları telemetry dışında kalmaz.
3. Technical health ve product quality dashboard'ları aynı event omurgasına dayanır.

---

## 4. Observability katmanları

Sistem dört katmanda izlenir:

1. technical health
2. product quality
3. trust and degradation
4. audit and internal action visibility

### 4.1. Technical health

Ornek:

- queue depth
- worker latency
- retry rate
- webhook delay

### 4.2. Product quality

Ornek:

- manual correction rate
- duplicate recommendation rate
- ambiguous extraction rate

### 4.3. Trust and degradation

Ornek:

- stale source count
- hidden-by-policy price count
- broken merchant link rate

### 4.4. Audit/internal action

Ornek:

- support action count
- kill switch changes
- ownership-sensitive actions

---

## 5. Event aileleri

### 5.1. Import events

- `import.submitted`
- `import.accepted`
- `import.queued`
- `import.processing`
- `import.review_required`
- `import.applied`
- `import.failed`
- `import.blocked`
- `import.expired`

### 5.2. Content/product lifecycle events

- `product.created`
- `product.archived`
- `page.published`
- `page.unpublished`
- `page.archived`

### 5.3. Refresh/trust events

- `refresh.started`
- `refresh.completed`
- `refresh.failed`
- `source.stale_threshold_reached`
- `source.blocked`

### 5.4. Auth/billing/internal events

- `session.revoked`
- `billing.entitlement_changed`
- `support.action_taken`
- `ops.kill_switch_changed`

---

## 6. Event adlandırma ilkeleri

### 6.1. Domain-first naming

Event adı teknik helper değil, anlamlı ürün olayı olmalıdır.

### 6.2. Past tense vs lifecycle

Durum event'leri ile mutation event'leri ayrılır:

- `import.processing`
- `page.published`

### 6.3. Yasak örnekler

- `do_work`
- `misc_error`
- `background_event`

---

## 7. Korelasyon modeli

Her kritik event asgari olarak şu alanları taşımalıdır:

- `request_id`
- `job_id` varsa
- `trace_id` veya eşdeğer correlation key
- `actor_type`
- `actor_id`
- `workspace_id`
- `merchant_key` veya host
- `target_entity_type`
- `target_entity_id`
- `failure_code` varsa
- `event_timestamp`

### Neden?

Support ve ops aynı vakanın request, job ve public etkisini zincir halinde okuyabilmelidir.

---

## 8. Teknik sağlık metrikleri

Asgari metric aileleri:

1. import acceptance rate
2. import median duration
3. queue backlog
4. retry rate
5. dead-letter count
6. webhook ingestion delay

### Kural

Teknik health iyi diye ürün kalitesi iyi varsayılmaz.

---

## 9. Ürün kalite metrikleri

Asgari metric aileleri:

1. manual correction rate
2. duplicate recommendation acceptance rate
3. unsupported merchant rate
4. ambiguous extraction rate
5. non-product-page rate

### Yorumu

Bu metrikler import modelinin ne kadar güvenli ve akışkan çalıştığını gösterir.

---

## 10. Trust ve degradation metrikleri

Asgari metric aileleri:

1. stale source count
2. hidden-by-policy price count
3. broken merchant link rate
4. blocked source count
5. archived content route hit ratio

### Neden?

Bu urunde public güven bozulmaları doğrudan retention ve support maliyeti üretir.

---

## 11. Supportability metrikleri

Asgari metric aileleri:

1. support issue taxonomy dağılımı
2. repeated merchant failures
3. support action -> resolve oranı
4. incident tetikleyen merchant kümeleri

---

## 12. Alert ve threshold modeli

### 12.1. Merchant-level failure spike

Eşik örneği:

- aynı merchant için 30 dakikada belirgin failure rate sıçraması

### 12.2. Queue backlog threshold

Eşik örneği:

- P0 queue bekleme süresi launch hedefini aşarsa

### 12.3. Stale source surge

Eşik örneği:

- selected/public source'larda stale threshold artışı

### 12.4. Unsafe redirect anomaly

Eşik örneği:

- policy/security code'larında ani yükseliş

Kural:

Alert aileleri runbook'larla eşlenmelidir.

---

## 13. Human action visibility

Support ve ops aksiyonları görünür kalmalıdır.

Asgari alanlar:

- who
- what
- why
- affected scope
- previous state summary
- resulting state summary

### Kural

Internal mutation'ı sadece audit log'da tutup telemetry'den gizlemek supportability'i düşürür.

---

## 14. Privacy ve minimization

Observability şu sınırlara uyar:

1. gereksiz PII toplamaz
2. raw payload gerekiyorsa maskeler
3. support ve ops için yeterli ama aşırı olmayan veri taşır
4. public analytics ile internal telemetry karışmaz

---

## 15. Dashboard tüketicileri

### 15.1. Product/engineering

- import kalite trendleri
- queue ve retry sağlık sinyali

### 15.2. Ops

- merchant-level incident kümeleri
- blocked/unsafe riskleri

### 15.3. Support

- kullanıcıya ne dendiği ile sistem event'leri korelasyonu

### 15.4. Leadership / launch readiness

- launch gate sağlık sinyalleri

---

## 16. Edge-case senaryolari

### 16.1. Failure event var ama failure code yok

Beklenen davranis:

- telemetry contract bug kabul edilir

### 16.2. Request id kayboldu

Beklenen davranis:

- high-priority observability issue
- supportability riski olarak işaretlenir

### 16.3. Aynı olay iki farklı isimle atılıyor

Beklenen davranis:

- taxonomy drift bug sayılır

---

## 17. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. yalnız latency/error rate izlemek
2. failure code'suz `import.failed` event'i atmak
3. support/ops aksiyonlarını telemetry dışında bırakmak
4. public vanity metrics'i ürün kalite metrikleriyle karıştırmak
5. merchant korelasyonu olmadan import sağlık yorumu yapmak

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `101-runbooks.md`, alert ailelerini ve eşik yorumlarını bu event modeline göre düzenlemelidir.
2. `102-incident-response-project-layer.md`, incident korelasyon alanlarını bu belgeyle uyumlu taşımalıdır.
3. `85-performance-budgets.md`, teknik performans metriklerini bu event omurgasıyla ilişkilendirmelidir.

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ops bir sorunun teknik mi quality mi trust mi olduğunu aynı telemetry omurgasından anlayabiliyorsa
- import, refresh, publish ve support action'ları korele okunabiliyorsa
- alert ve runbook eşleşmeleri sistematik çalışıyorsa
- privacy sınırı bozulmadan yeterli diagnosability sağlanıyorsa

Bu belge basarisiz sayilir, eger:

- observability hâlâ yalnız error logging seviyesinde kalıyorsa
- support ve ops aynı vakayı farklı event dilleriyle yorumluyorsa
- correlation alanları eksik olduğu için vakalar uçtan uca izlenemiyorsa

