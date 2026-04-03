---
id: SUBSCRIPTION-BILLING-INTEGRATION-ARCHITECTURE-001
title: Subscription and Billing Integration Architecture
doc_type: monetization_architecture
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - SUBSCRIPTION-PLAN-MODEL-001
  - AUTH-IDENTITY-SESSION-MODEL-001
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
blocks:
  - WEBHOOK-EVENT-CONSUMER-SPEC
  - PLATFORM-STORE-REVIEW-RISK-NOTES
  - API-CONTRACTS
---

# Subscription and Billing Integration Architecture

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde subscription provider, entitlement service, billing state persistence, webhook consumer, grace period ve dunning davranisinin teknik olarak nasil kurulacagini, owner-only billing erişiminin nasil enforce edilecegini ve web/mobile/store policy sinirlarinin bu mimariye nasil yansiyacagini tanimlayan resmi billing integration architecture belgesidir.

Bu belge su sorulara cevap verir:

- Billing provider source of truth mudur, yoksa urun içindeki entitlement katmani mi?
- Plan değişikliği, ödeme başarısızlığı ve cancellation olayları sistemde nasıl işlenir?
- Web ve mobile billing deneyimi neden aynı değildir?
- Entitlement drift nasıl önlenir?
- Webhook ile UI state neden birbirine karıştırılamaz?

Bu belge, monetization katmanını urun mantigindan ayri ama sıkı baglı bir sistem olarak tanımlar.

---

## 2. Bu belge neden kritiktir?

Billing yanlış kurulduğunda tipik problemler:

1. kullanıcı ödemiştir ama entitlement güncellenmez
2. payment failure sonrası public yüzey aniden kırılır
3. mobile store policy ile web checkout dili çatışır
4. editor billing alanına yanlışlıkla erişir

Bu urunde subscription urunun kendisi degildir; ama yanlış mimari, urunu rastgele açılıp kapanan özellik setine dönüştürür.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Canonical subscription authority, boilerplate ADR-016 ile uyumlu `RevenueCat-class` entitlement ve subscription katmanidir; web checkout surface `Stripe-class` olabilir, ancak urun için gerçek erişim kaynağı yine `subscription state + entitlement service` katmanıdır; tüm billing olayları webhook/event akışıyla bu katmana yansıtılır ve UI bu entitlements üzerinden davranır.

Bu karar su sonuclari dogurur:

1. UI provider dashboard'una bakarak yetki vermez.
2. Webhook tek başına doğrudan UI state değildir; önce internal state güncellenir.
3. Owner dışındaki actor billing write aksiyonu alamaz.
4. Grace period ve downgrade davranışı domain mantığıyla ele alınır.
5. `Stripe-class` checkout surface, `RevenueCat-class` subscription truth'unun yerine gecmez.

---

## 4. Bileşenler

Billing entegrasyonu beş ana bileşenden oluşur:

1. billing provider adapter
2. subscription state persistence
3. entitlement service
4. webhook/event consumer
5. billing-facing UI entrypoints

### 4.1. Provider adapter

Gorevi:

- checkout/session creation
- provider customer/subscription mapping
- invoice/payment event uyumu
- `RevenueCat-class` subscription authority ile `Stripe-class` web checkout bridge'ini ayri ama bagli adapter'lar olarak tasimak

### 4.2. Subscription state persistence

Gorevi:

- provider state snapshot
- current plan
- grace/cancel state
- timestamps

### 4.3. Entitlement service

Gorevi:

- plan capability'lerini hesaplamak
- owner/editor erişim kararlarına yardımcı olmak
- UI ve API için tek erişim truth'u olmak

### 4.4. Webhook/event consumer

Gorevi:

- provider olaylarını doğrulamak
- idempotent işlemek
- subscription/entitlement state'i güncellemek

### 4.5. Billing UI

Gorevi:

- owner'a plan durumunu göstermek
- upgrade/downgrade/cancel akışını başlatmak

---

## 5. Source of truth ayrımı

### 5.1. Provider neyin source of truth'udur?

- ödeme hareketi
- fatura/renewal olayları
- subscription lifecycle event'leri

### 5.2. Product neyin source of truth'udur?

- şu anda ürün içinde hangi entitlement'lerin aktif olduğu
- grace period davranışı
- downgrade sonrası hangi page'lerin aktif kalacağı

### 5.3. Neden?

Provider event'i tek başına product behavior açıklamaz.  
Domain policy ve plan modeli ayrıca uygulanmalıdır.

---

## 6. Entitlement modeli

Entitlement aileleri:

1. capacity
2. branding/customization
3. collaboration
4. future premium utilities

### 6.1. Capacity

Ornek:

- aktif shelf limiti
- content page limiti
- import volume limiti

### 6.2. Branding

Ornek:

- custom domain
- template family erişimi

### 6.3. Collaboration

Ornek:

- editor seats

### 6.4. Kural

Trust/disclosure ve temel import güvenliği entitlement ile kapatılmaz.

---

## 7. Billing olayları ve state makinesi

Asgari lifecycle:

- `trialing`
- `active`
- `past_due`
- `grace_period`
- `canceled_pending_end`
- `expired`

### 7.1. `trialing`

Trial entitlements aktiftir.

### 7.2. `active`

Ücretli plan tam aktiftir.

### 7.3. `past_due`

Ödeme sorunu vardır; ama entitlements hemen sert kapanmaz.

### 7.4. `grace_period`

Creator veri kaybı yaşamadan aksiyon alma penceresi vardır.

### 7.5. `expired`

Yeni premium entitlement'ler kapanır; ama domain policy'ye göre public surface kontrollu davranır.

---

## 8. Webhook akışı

### 8.1. Giriş ilkeleri

Kurallar:

1. signature doğrulama zorunludur
2. raw payload auditlenir
3. idempotent event handling zorunludur

### 8.2. Olaylar

Asgari olay aileleri:

- trial started
- subscription created/renewed
- payment failed
- subscription canceled
- invoice paid
- grace period completed

### 8.3. İşleme zinciri

1. event verify
2. event dedupe
3. provider state normalize
4. subscription state update
5. entitlement recompute
6. internal event emit

---

## 9. Grace period ve downgrade mimarisi

### 9.1. Grace neden var?

Bu urunde creator'ın public surfaces'i olabilir.  
Billing failure anında her şeyi kırmak trust ve retention açısından yıkıcıdır.

### 9.2. Grace davranışı

Kurallar:

1. mevcut public yüzey anında yok edilmez
2. yeni premium aksiyonlar sınırlanabilir
3. creator'e açık next step gösterilir

### 9.3. Downgrade etkisi

Downgrade sonrası:

- limits aşımı varsa creator'e impact view gerekir
- sistem sessizce page kapatmaz

---

## 10. Web ve mobile ayrımı

### 10.1. Web billing

Web:

- plan yönetimi
- checkout başlatma
- billing history özeti

taşıyabilir.

### 10.2. Mobile billing

Mobile tarafı platform/store policy ile çelişmeyecek şekilde davranmalıdır.

Kural:

- aggressive external purchase dili mobile creator app içinde kullanılmaz
- mobile paid entry UI MVP kritik yoluna alinmasa bile canonical store purchase yolu mimariden silinmez
- store policy gerektiriyorsa native purchase adaptörü `RevenueCat-class` authority ile uyumlu sekilde ele alınır

### 10.3. Neden?

Mobile app creator utility yüzeyidir; public commerce shell gibi konumlanmaz.

---

## 11. Authorization ve owner-only erişim

### 11.1. Owner

Billing write yetkisi owner'a aittir.

### 11.2. Editor

Read-only özet görebilir veya hiç görmeyebilir.  
Write aksiyonu yoktur.

### 11.3. Support

Payment detaylarına sınırlı gözlemle erişebilir.  
Kart/fatura hassas alanları gereksiz geniş açılmaz.

---

## 12. Failure ve drift alanları

En kritik riskler:

1. webhook geldi ama entitlement güncellenmedi
2. payment failed ama grace policy uygulanmadı
3. provider state ile internal state ayrıştı
4. mobile yüzeyde yanlış billing copy'si store policy riski yarattı

### 12.1. Çözüm

- reconciliation jobs
- idempotent consumer
- audit events
- owner-facing billing health state

---

## 13. Reconciliation stratejisi

Webhook tek başına yeterli kabul edilmez.

Kurallar:

1. periyodik reconcile job olabilir
2. provider snapshot ile internal subscription state karşılaştırılır
3. drift varsa entitlement recompute edilir

---

## 14. Edge-case senaryolari

### 14.1. Payment failure kısa süreli

Beklenen davranis:

- immediate hard downgrade yok
- grace state görünür

### 14.2. Subscription canceled ama dönem bitmedi

Beklenen davranis:

- `canceled_pending_end`
- entitlement dönem sonuna kadar sürer

### 14.3. Webhook kaçırıldı

Beklenen davranis:

- reconcile job farkı bulur
- state düzeltilir

### 14.4. Editor billing ekranına geldi

Beklenen davranis:

- write aksiyonu görünmez veya açık read-only state ile gelir

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Provider dashboard verisini doğrudan UI truth'u saymak
2. Webhook gelince entitlements'i audit olmadan sessizce mutate etmek
3. Billing failure'da creator'in public surfaces'ini aniden kırmak
4. Mobile app'te store-policy riskli purchase dili kullanmak
5. Editor'e billing write erişimi vermek

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `75-webhook-and-event-consumer-spec.md`, billing event normalization ve idempotency'yi bu mimariye göre detaylandırmalıdır.
2. `94-platform-and-store-review-risk-notes.md`, mobile billing ve external purchase risklerini bu surface ayrımıyla uyumlu yazmalıdır.
3. `70-api-contracts.md`, owner-only billing endpoints ve entitlement read modellerini bu role modeline göre tanımlamalıdır.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- entitlements iç ürün davranışının gerçek kaynağı haline geldiyse
- webhook ve reconcile birlikte drift'i yönetebiliyorsa
- grace/downgrade davranışı creator için kontrollu ve öngörülebilir ise
- web/mobile/store policy ayrımı teknik seviyede korunuyorsa

Bu belge basarisiz sayilir, eger:

- provider ile internal state sık sık ayrışıyorsa
- billing write yetkisi owner dışına sızıyorsa
- billing failure yüzünden public kalite aniden kırılıyorsa
