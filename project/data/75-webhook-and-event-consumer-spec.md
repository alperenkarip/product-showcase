---
id: WEBHOOK-EVENT-CONSUMER-SPEC-001
title: Webhook and Event Consumer Spec
doc_type: event_ingress_spec
status: ratified
version: 2.0.0
owner: backend
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - SUBSCRIPTION-BILLING-INTEGRATION-ARCHITECTURE-001
  - AUTH-IDENTITY-SESSION-MODEL-001
  - API-CONTRACTS-001
  - DATABASE-SCHEMA-SPEC-001
  - OBSERVABILITY-INTERNAL-EVENT-MODEL-001
blocks:
  - INCIDENT-RESPONSE-PROJECT-LAYER
  - RUNBOOKS
  - RELEASE-READINESS-CHECKLIST
---

# Webhook and Event Consumer Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` urunune dis sistemlerden gelen webhook ve benzeri olaylarin nasil kabul edilecegini, signature ve replay kontrollerinin nasil uygulanacagini, raw delivery ile normalized domain event arasindaki ayrimi, idempotency ve out-of-order davranisini, hangi olaylarin hangi internal workflow'lari tetikleyecegini ve parked/dead-letter cizgisinin nasil isletilecegini tanimlayan resmi event ingress spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Webhook success response ne zaman verilir?
- Raw provider payload'i ile uygulamanin normalized event'i nasil ayrilir?
- Duplicate veya replay event nasil engellenir?
- Out-of-order billing olaylari nasil islenir?
- Domain verification, email delivery veya extraction provider health sinyalleri nasil normalize edilir?
- Internal workflow event consumer'lari ile external webhook consumer'lari hangi ortak disiplini paylasir?

---

## 2. Bu belge neden kritiktir?

Bu urunde webhook ve event ingest hatalari sessiz ama yikici olabilir.

Tipik bozulmalar:

1. Duplicate billing event iki kez entitlement degistirir.
2. Checkout success sayfasi authoritative zannedilir ve webhook gelmeden access acilir.
3. Domain verification event'i sahte veya replay edilmis payload ile kabul edilir.
4. Email bounce event'i support veya invite akisini yanlis etkiler.
5. Raw payload kaydi olmadigi icin support olayi sonradan inceleyemez.

Bu nedenle webhook handling, basit `POST /webhook` controller'i degil; guvenlik, audit ve domain correctness katmanidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Dis olaylar once verify edilir, sonra durable sekilde kaydedilir, daha sonra normalized internal event'e donusturulur; provider payload'i dogrudan domain state mutation'u yapmaz; her olay provider-level idempotency ve app-level dedupe ile korunur; webhook ack, side effect'in bittigini degil, olayın guvenli bicimde kabul edildigini ifade eder.

Bu karar su sonuclari dogurur:

1. Signature dogrulama olmadan event apply edilmez.
2. Raw payload ve normalized event ayri veri katmanlarinda tutulur.
3. Checkout basarisi veya provider notice tek basina entitlement truth'u degildir.
4. Event replay ve duplicate delivery ayrik olarak izlenir.
5. Provider bozuk veya out-of-order davransa bile app-level state makinesi korunur.

---

## 4. Olay kaynagi aileleri

Launch icin asgari olay kaynagi aileleri:

1. billing subscription authority
2. web checkout surface
3. custom domain / DNS provider
4. transactional email provider
5. extraction/render provider health veya quota olaylari

Internal olarak ayni discipline uzerinden tuketilen olay aileleri:

6. outbox domain events
7. scheduler-produced operational events

Kural:

Client-originated olaylar webhook gibi muamele gormez.  
Webhook ailesi yalniz trusted external system'lerden gelen signed ingress'tir.

---

## 5. Ingress route aileleri

Asgari route aileleri:

- `POST /api/webhooks/billing`
- `POST /api/webhooks/web-checkout`
- `POST /api/webhooks/domain`
- `POST /api/webhooks/email`
- `POST /api/webhooks/extraction-provider`

Opsiyonel internal bridge veya provider-agnostic event gateway:

- `POST /api/internal/events/consume`

Kural:

External ve internal olaylar ayni normalize pipeline'ina girebilir; ama auth ve signature modeli ayri tutulur.

---

## 6. Ingress pipeline asamalari

Her external event asgari su pipeline'i izler:

1. request kabul
2. route-level provider cagrisi sinifi belirleme
3. signature / authenticity verify
4. raw payload hash ve provider event id cikarma
5. durable `webhook_events` kaydi
6. duplicate/replay kontrolu
7. normalized event mapleme
8. internal workflow veya state transition tetigi
9. apply sonucu kaydi
10. ack response

Kural:

Bu adimlardan biri atlanarak provider payload'i dogrudan domain service'e verilmez.

---

## 7. Raw delivery ve normalized event ayrimi

## 7.1. Raw delivery

Dis sistemin gonderdigi orijinal envelope.

Kaydedilen alanlar:

- provider
- provider_event_id
- received_at
- payload_hash
- masked_payload_json
- signature_verified
- delivery_state

## 7.2. Normalized event

Uygulamanin anladigi canonical olay.

Asgari alanlar:

- `normalized_event_name`
- `aggregate_type`
- `aggregate_id`
- `occurred_at`
- `provider`
- `provider_event_id`
- `dedup_key`
- `payload_summary_json`

## 7.3. Neden ayrim gerekir?

1. Provider format degisse de uygulama dili stabil kalir.
2. Audit ve support raw envelope'u okuyabilir.
3. Domain logic provider field isimlerine bagimli kalmaz.

---

## 8. Delivery state modeli

Her webhook delivery su state'lerden birinde olur:

- `received`
- `verified`
- `duplicate`
- `normalized`
- `applied`
- `parked`
- `rejected`
- `failed`

### 8.1. `received`

HTTP istegi alindi ama verify tamamlanmadi.

### 8.2. `verified`

Authenticity ve temel parse kontrolleri gecti.

### 8.3. `duplicate`

Ayni provider event daha once kayda alinmis veya islenmistir.

### 8.4. `normalized`

Domain event mapleme basariyla yapildi.

### 8.5. `applied`

Gerekli internal state transition veya workflow tetigi tamamlandi.

### 8.6. `parked`

Event gecerli ama hemen apply edilmesi dogru degil.

Ornek:

- out-of-order billing sequence
- eksik upstream state beklentisi

### 8.7. `rejected`

Signature gecersiz veya policy geregi kabul edilmeyen olay.

### 8.8. `failed`

Event gecerli ama apply sirasinda teknik hata oldu.

---

## 9. Guvenlik dogrulama ilkeleri

## 9.1. Signature zorunlulugu

Provider signature veya equivalent authenticity mekanizmasi olmadan olay apply edilmez.

## 9.2. Timestamp toleransi

Replay riskini azaltmak icin event timestamp veya signed age penceresi kontrol edilir.

## 9.3. IP allowlist

Varsa yardimci sinyal olabilir; ama ana guvenlik mekanizmasi sayilmaz.

## 9.4. Secret rotasyonu

Eski ve yeni webhook secret'i gecis penceresinde birlikte desteklenebilir.  
Ama rotasyon takibi kayitsiz olmaz.

## 9.5. Masking

Raw payload auditlenir; fakat hassas veri maskelenmeden uzun omurlu loglara yazilmaz.

---

## 10. Idempotency ve replay politikasi

Webhook ve event ingest tarafinda iki ayri koruma vardir:

1. provider-level duplicate kontrolu
2. application-level side effect dedupe

### 10.1. Provider-level duplicate kontrolu

Asgari anahtar:

- `provider + provider_event_id`

### 10.2. Application-level dedupe

Bazı provider'lar event id degistirse bile ayni anlami tekrar gonderebilir.

Bu nedenle ek dedupe sinyalleri kullanilabilir:

- aggregate id
- event type
- effective timestamp
- payload hash

### 10.3. Replay davranisi

Replay tespit edilirse:

1. yeni side effect uretilmez
2. delivery `duplicate` veya `rejected` semantigine cekilir
3. telemetry event uretilir

---

## 11. Ack semantigi

Webhook response'u asla "butun is bitti" gibi davranmaz.

### 11.1. Basarili ack ne zaman verilir?

Asgari su noktadan sonra:

1. signature verify edildi
2. durable delivery kaydi yazildi
3. duplicate/replay karari verildi
4. gerekiyorsa normalized event kaydi acildi

### 11.2. Ack response turu

Genellikle:

- `200 OK`
- `202 Accepted`

Semantik olarak:

- olay kabul edildi
- apply hemen bitmeyebilir

### 11.3. Ack vermemek ne zaman dogru?

- signature gecersiz
- payload parse edilemiyor
- kritik durability kaydi yazilamiyor

---

## 12. Billing authority event ailesi

Canonical normalized event aileleri:

- `billing.subscription_activated`
- `billing.subscription_renewed`
- `billing.subscription_past_due`
- `billing.subscription_grace_started`
- `billing.subscription_canceled`
- `billing.subscription_expired`
- `billing.payment_failed`
- `billing.refund_recorded` opsiyonel

### 12.1. Apply ilkeleri

1. Provider event'i dogrudan UI state'i degistirmez.
2. Once subscription mirror guncellenir.
3. Sonra entitlement recompute veya follow-up workflow tetiklenir.
4. Audit ve telemetry olayi yazilir.

### 12.2. Out-of-order billing olaylari

Ornek:

- `canceled` once gelir
- sonra gecikmeli `renewed` gelir

Beklenen davranis:

1. provider timestamp ve effective period okunur
2. mevcut internal state ile karsilastirilir
3. gec kalmis ama artik gecersiz event parked veya no-op olabilir

### 12.3. Kritiklik

Billing tarafinda duplicate veya out-of-order hatasi access drift uretir.  
Bu nedenle parked mantigi bu ailede ozellikle onemlidir.

---

## 13. Web checkout event ailesi

Web checkout provider ayriysa normalized olaylar su aileye iner:

- `checkout.session_created`
- `checkout.session_completed`
- `checkout.session_expired`

### 13.1. Bridge pending mantigi

`checkout.session_completed` oldugunda:

1. checkout session kaydi `completed` olabilir
2. ama entitlements hemen acilmaz
3. `bridge_pending` veya equivalent bekleme semantigi korunur
4. authoritative billing event veya reconcile tamamlaninca access degisir

### 13.2. Neden?

Checkout UI odemenin veya aboneligin product acisindan authoritative sonucu degildir.

### 13.3. Yasak davranis

Success page redirect'i gorup premium unlock yapmak.

---

## 14. Domain verification event ailesi

Canonical normalized event aileleri:

- `domain.verification_succeeded`
- `domain.verification_failed`
- `domain.configuration_invalid`

### 14.1. Apply mantigi

1. `custom_domains` state guncellenir
2. canonical URL secimi etkilenir
3. gerekli cache/metadata follow-up'lari tetiklenir

### 14.2. Edge case

Ayni domain farkli creator'a ait olmaya calisiyorsa apply durdurulur ve operator intervention gerekir.

---

## 15. Transactional email event ailesi

Canonical normalized event aileleri:

- `email.delivered`
- `email.bounced`
- `email.complained`
- `email.deferred`

### 15.1. Apply mantigi

Bu olaylar genellikle core domain truth degistirmez; ama operational flags etkileyebilir.

Ornek:

- invite email surekli bounce oluyorsa support veya resend stratejisi etkilenir
- security mail complaint olaylari abuse/risk sinyali olabilir

### 15.2. Kritik kural

Email bounce, kullaniciyi sessizce silme veya invite'i geri donulmez iptal etme bahanesi olmaz.

---

## 16. Extraction provider health event ailesi

Canonical normalized event aileleri:

- `provider.quota_near_limit`
- `provider.quota_exhausted`
- `provider.health_degraded`
- `provider.health_restored`

### 16.1. Apply mantigi

1. Ops telemetry ve vendor register etkilenir
2. Scheduler throttle veya kill-switch guncellenebilir
3. Import create davranisi kontrollu degrade olabilir

### 16.2. Kritik kural

Bu sinyaller product source truth'unu dogrudan degistirmez; operational davranisi degistirir.

---

## 17. Internal outbox ve event consumer disiplini

Webhook disindan gelen internal event tuketimi de benzer disipline uyar.

### 17.1. Internal event aileleri

- `page.published`
- `source.selected_changed`
- `import.applied`
- `billing.entitlement_changed`

### 17.2. Ortak disiplin

1. explicit event adi
2. aggregate kimligi
3. dedupe anahtari
4. telemetry
5. retry ve parked karari

### 17.3. Fark

Internal event'lerde signature gerekmez; ama auth/scope zinciri zaten upstream write tarafinda saglanmis olmalidir.

---

## 18. Retry, parked ve dead-letter politikasi

### 18.1. Retry edilen durumlar

- DB gecici yazma hatasi
- internal worker gecici kapasite sorunu
- downstream orchestrator gecici timeout

### 18.2. Retry edilmeyen durumlar

- signature invalid
- unsupported provider schema
- missing critical identity alanlari

### 18.3. Parked kullanilan durumlar

- out-of-order billing event
- iliskili aggregate henuz olusmamis ama beklenebilir
- short-lived provider inconsistency

### 18.4. Dead-letter kullanilan durumlar

Tekrarli teknik fail olup otomatik akistan cikarilan olaylar.

Kural:

Signature invalid event dead-letter yerine `rejected` sayilir.

---

## 19. Replay ve manuel reprocess

Ops/support belirli delivery'leri yeniden isletmek isteyebilir.

Kurallar:

1. Raw payload kaydi varsa kontrollu manual reprocess mumkun olabilir.
2. Reprocess yeni provider event gibi davranmaz; operator reason kaydi ister.
3. Reprocess duplicate side effect korumalarini bypass etmez.

---

## 20. Observability ve audit

Her delivery icin asgari telemetry alanlari:

- `provider`
- `provider_event_id`
- `normalized_event_name`
- `delivery_state`
- `request_id`
- `correlation_id`
- `target_aggregate_type`
- `target_aggregate_id`
- `failure_code`
- `processed_at`

Asgari metrikler:

1. event ingest hacmi
2. signature reject oranı
3. duplicate oranı
4. apply latency
5. parked backlog
6. dead-letter sayisi

---

## 21. Senaryo bazli akışlar

### 21.1. Senaryo: Billing provider ayni renewal event'ini iki kez gonderir

Beklenen davranis:

1. ilk delivery `applied`
2. ikinci delivery `duplicate`
3. ikinci olay yeni entitlement recompute tetiklemez

### 21.2. Senaryo: Checkout complete geldi ama billing authority henuz update gondermedi

Beklenen davranis:

1. checkout session `completed`
2. access `bridge_pending`
3. UI owner'a dogru state gosterir
4. billing authority olayi veya reconcile beklenir

### 21.3. Senaryo: Domain verification success out-of-order gelir

Beklenen davranis:

1. domain kaydi bulunur
2. state conflict varsa event parked edilir
3. operator inceleme gerekebilir

### 21.4. Senaryo: Signature invalid email webhook

Beklenen davranis:

1. event `rejected`
2. apply yok
3. security telemetry yazilir

### 21.5. Senaryo: Extraction provider quota exhausted event'i gelir

Beklenen davranis:

1. provider health operational state'i guncellenir
2. scheduler throttle veya import kill-switch devreye girer
3. mevcut public content etkilenmez

---

## 22. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Webhook payload'ini signature verify etmeden parse/apply etmek
2. Raw payload saklamadan normalized event uretmek
3. Checkout success'i premium unlock sanmak
4. Provider event id yoksa duplicate korumasini tamamen birakmak
5. Out-of-order olaylari son gelen kazanir mantigiyla korumasiz uygulamak
6. Rejected event'i retry kuyruğuna sokmak
7. Support'un duplicate korumalarini bypass ederek manuel apply yapmasi

---

## 23. Bu belge sonraki belgelere ne emreder?

### 23.1. Incident response belgesine

- signature reject spike, parked backlog ve billing drift durumlari icin ayri incident akislari yazilacak

### 23.2. Runbook'lara

- provider bazli replay/reprocess ve secret rotation runbook'lari eklenecek

### 23.3. Release readiness checklist'e

- duplicate billing event, checkout bridge pending ve invalid signature testleri zorunlu hale gelecek

---

## 24. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin su kosullar saglanmis olmalidir:

1. Her external olay ailesi icin verify -> durable record -> normalize -> apply zinciri nettir.
2. Duplicate, replay, parked ve rejected ayrimi operasyonel olarak uygulanabilir durumdadir.
3. Checkout ve billing authority arasindaki bridge mantigi acikca korunmustur.
4. Provider bozuk veya out-of-order davransa bile domain truth sessizce bozulmamaktadir.
5. Yeni bir backend muhendisi veya support sorumlusu, "bu webhook gelince sistem tam olarak ne yapar?" sorusunu ek aciklama istemeden cevaplayabilir.
