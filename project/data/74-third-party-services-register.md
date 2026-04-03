---
id: THIRD-PARTY-SERVICES-REGISTER-001
title: Third-Party Services Register
doc_type: vendor_dependency_register
status: ratified
version: 2.0.0
owner: engineering-operations
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - SYSTEM-ARCHITECTURE-001
  - RISK-REGISTER-001
  - PRIVACY-DATA-MAP-001
  - SUBSCRIPTION-BILLING-INTEGRATION-ARCHITECTURE-001
  - BACKGROUND-JOBS-SCHEDULING-SPEC-001
blocks:
  - ENVIRONMENT-AND-SECRETS-MATRIX
  - INCIDENT-RESPONSE-PROJECT-LAYER
---

# Third-Party Services Register

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun bagimli oldugu veya bagimli olmasi planlanan tum dis servis siniflarini, bu servislerin urundeki rollerini, hangi veri siniflarina dokunduklarini, senkron veya asenkron kritikligini, fallback ve kill-switch davranislarini, owner/sorumluluk cizgilerini ve yeni vendor kabul kurallarini tanimlayan resmi servis sicilidir.

Bu belge yalnizca "hangi servisleri kullaniyoruz?" listesi degildir.  
Su sorulara cevap verir:

- Bir SDK veya servis ne zaman gercek bagimlilik sayilir?
- Hangi servis slot'u launch icin zorunludur?
- Hangi servis down olursa urun tamamen durur, hangisinde kontrollu degrade mumkundur?
- Hangi vendor veri koruma ve compliance acisindan yuksek risklidir?
- Yeni vendor eklemek hangi kontrolleri gerektirir?
- Vendor degisimi yapildiginda hangi cikis stratejileri zorunludur?

---

## 2. Bu belge neden kritiktir?

Dis servis bagimliliklari kontrolsuzce buyurse urun fark edilmeyen teknik borca doner.

Tipik bozulmalar:

1. Production'da gercek kritik yol uzerinde olan servis kayda alinmaz.
2. Ayni problem icin iki farkli vendor sessizce kullanilmaya baslar.
3. PII veya finansal veri tasiyan bir entegrasyon compliance review olmadan acilir.
4. Servis bozuldugunda fallback veya kill switch olmadigi icin urun butun olarak kirilir.
5. Secret owner ve rotasyon bilgisi belli olmaz.

Bu nedenle vendor register, procurement notu degil; mimari ve operasyon cizgisidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icinde ag uzerinden cagrilan veya urunun kritik yolunu etkileyen her dis servis, provider-slot mantigiyla bu register'a girer; her slot icin veri sinifi, kritik yol etkisi, fallback modu, secret aileleri ve cikis stratejisi explicit tanimlanir; register disi gizli bagimlilik kabul edilmez.

Bu karar su sonuclari dogurur:

1. Frontend'e sessizce yeni analytics/chat/sdk eklenemez.
2. Critical path vendor'lari owner ve incident etkisiyle birlikte kayda alinir.
3. Servis secimi marka isminden once capability slot'u uzerinden tartisilir.
4. Ayni slot icin cift authoritative servis acmak belge guncellemesi ister.

---

## 4. Kapsam kurali

Bu register'a su tip bagimliliklar girer:

1. network uzerinden cagrilan harici servisler
2. managed altyapi servisleri
3. billing ve odeme servisleri
4. analytics/observability servisleri
5. domain, email, extraction/render ve benzeri operational servisler

Bu register'a normalde GİRMEYEN seyler:

1. yalnizca local derleme kutuphanesi
2. runtime'da dis ag cagrisi yapmayan UI library'leri
3. dev-only package'lar

Istisna:

Bir kutuphane runtime'da harici servise baglaniyor, veri topluyor veya urunun policy/authority katmanina giriyorsa register'a girmek zorundadir.

---

## 5. Siniflandirma eksenleri

Her servis slot'u dort eksende siniflanir:

1. kritik yol seviyesi
2. veri duyarlilik sinifi
3. ikame zorlugu
4. failure degrade modu

### 5.1. Kritik yol seviyesi

- `C0-core-blocker`: yoksa ana urun davranisi calismaz
- `C1-major-degradation`: urun acilir ama kritik alan ciddi degrade olur
- `C2-limited-degradation`: belirli yan akislarda bozulma olur
- `C3-optional`: kapatilabilir veya gecici devre disi kalabilir

### 5.2. Veri duyarlilik sinifi

- `D0-public`: public veya teknik onemsiz veri
- `D1-operational`: urun operasyon verisi
- `D2-account`: account ve workspace verisi
- `D3-financial`: billing ve odeme etkili veri
- `D4-sensitive`: yuksek denetimli veri veya support/audit etkisi yuksek veri

### 5.3. Ikame zorlugu

- `S1-low`: makul maliyetle degistirilebilir
- `S2-medium`: migration gerekir
- `S3-high`: veri/kontrat/uyarlama maliyeti yuksektir

### 5.4. Failure degrade modu

- `fail-closed`: servis yoksa aksiyon durur
- `degrade-read`: eski veri veya fallback okunur
- `degrade-write`: yeni write kabul edilmez ama read devam eder
- `feature-off`: ilgili capability kapatilir

---

## 6. Launch baseline servis slotlari

Launch icin asgari servis slotlari asagidadir:

1. managed relational database
2. object storage ve CDN
3. durable workflow / job orchestrator
4. billing subscription authority
5. web checkout surface
6. extraction-render provider
7. domain and DNS provider
8. error/performance observability
9. product analytics and flags
10. transactional email

Not:

Bu liste capability slot'udur.  
Exact vendor secimi implementasyon asamasinda kesinlesebilir; ama capability sinirlari bu belgede sabittir.

---

## 7. Servis slot ozeti

| Slot | Kritiklik | Veri sinifi | Ikame zorlugu | Varsayilan degrade |
| --- | --- | --- | --- | --- |
| Managed relational database | C0 | D2/D3/D4 | S3 | fail-closed |
| Object storage + CDN | C1 | D1/D2 | S2 | degrade-read |
| Workflow orchestrator | C1 | D1 | S2 | degrade-write |
| Billing subscription authority | C0 | D3 | S3 | fail-closed |
| Web checkout surface | C2 | D3 | S2 | feature-off |
| Extraction-render provider | C1 | D1 | S2 | degrade-write |
| Domain and DNS provider | C2 | D1/D2 | S2 | feature-off |
| Error/performance observability | C2 | D1/D2 | S1 | degrade-observe |
| Product analytics and flags | C3 | D1/D2 | S1 | feature-off |
| Transactional email | C2 | D2 | S1 | degrade-notify |

---

## 8. Managed relational database slot'u

### 8.1. Rol

Ana kalici source of truth verisini tutar.

Kapsanan veri aileleri:

- creator/workspace
- products/sources/placements
- import jobs
- publications
- billing mirrors
- audit ve webhook kayitlari

### 8.2. Preferred capability family

- PostgreSQL-compatible managed database

Ornek implementation ailesi:

- Neon-class
- RDS-class
- Supabase Postgres-class

### 8.3. Veri duyarlilik seviyesi

`D2`, `D3` ve `D4` siniflari vardir.

### 8.4. Failure etkisi

Bu slot bozulursa urunun write truth'u durur.  
Bu nedenle `C0-core-blocker` kabul edilir.

### 8.5. Fallback

Gercek fallback yoktur.  
Only:

- read replica veya backup/restore proseduru
- controlled maintenance mode

### 8.6. Secret ve owner

Secret aileleri:

- primary connection string
- migration user credentials
- read-only/reporting credentials varsa ayrik

Owner:

- engineering + operations

### 8.7. Cikis stratejisi

Zorunlu:

- standard PostgreSQL dump/restore cikisi
- schema migration portability
- vendor-lock deep proprietary feature kullaniminin sinirlanmasi

---

## 9. Object storage ve CDN slot'u

### 9.1. Rol

Media asset, derived variant, export artefact ve OG asset depolama/yayinlama katmani.

### 9.2. Preferred capability family

- S3-compatible object storage
- global edge delivery/CDN

Ornek implementation ailesi:

- R2-class
- S3 + CDN-class

### 9.3. Veri duyarlilik seviyesi

Genelde `D1` ve `D2`.

### 9.4. Failure etkisi

Public asset delivery degrade olur.  
Yazma tarafinda yeni upload ve variant generation etkilenir.

### 9.5. Fallback

- mevcut immutable asset'ler edge'te bir sure yasayabilir
- yeni upload/generation gecici kapatilabilir

### 9.6. Kritik notlar

1. Merchant hotlink'i bu slot'un yerine gecmez.
2. Export artefact ve public media ayni lifecycle kuralina tabi degildir.

### 9.7. Cikis stratejisi

- object key naming vendor'a bagli olmayan sekilde tasarlanir
- bulk export script'i olur
- signed URL veya public URL semantigi abstraction ile sarilir

---

## 10. Durable workflow / job orchestrator slot'u

### 10.1. Rol

Asenkron islerin durable execution, scheduling, retry ve orchestration katmani.

### 10.2. Preferred capability family

- event-driven durable workflow orchestrator

Ornek implementation ailesi:

- Inngest-class
- Temporal-class

### 10.3. Veri duyarlilik seviyesi

Genelde `D1`.  
Ama run metadata'si creator veya billing context tasiyabilir.

### 10.4. Failure etkisi

Import, refresh, cleanup ve webhook takip akislari yeni is kabul edemez veya isleyemez.

### 10.5. Fallback

- yeni background write'lar kontrollu kapatilabilir
- mevcut public read urunu bir sure yasar
- kritik user-visible command'ler `temporarily_unavailable` ile durdurulur

### 10.6. Zorunlu kosullar

1. provider outage durumunda durable DB truth kaydi korunmali
2. duplicate run korumalari app-level storage ile de desteklenmeli

### 10.7. Cikis stratejisi

- workflow input/output contract'lari vendor API'sine gomulmez
- application-side event ve dedup mantigi korunur

---

## 11. Billing subscription authority slot'u

### 11.1. Rol

Subscription lifecycle, billing olaylari ve entitlement tetiklerinin authoritative dis kaynagi.

### 11.2. Capability ihtiyaci

- subscription lifecycle event'leri
- invoice/payment state sinyalleri
- trial / renewal / cancel / grace iliskisi
- webhook veya equivalent server notification

### 11.3. Veri sinifi

`D3-financial`

### 11.4. Failure etkisi

Entitlement drift riski yaratir.  
Bu nedenle `C0-core-blocker` veya `C1` sinirinda kabul edilir.

### 11.5. Fallback

Gercek ticari truth fallback'i yoktur.  
Uygulama yalniz son bilinen entitlement snapshot ile kontrollu grace davranisi sunabilir.

### 11.6. Dikkat edilmesi gerekenler

1. Provider event'i ile product access truth'u ayni sey degildir.
2. Billing provider yokken entitlement uydurulmaz.
3. Web checkout provider ayriysa authoritative billing truth yine bu slot'ta toplanir.

### 11.7. Preferred implementation family

- subscription authority / entitlements aggregator
- mobile store billing launch sonrasinda acilirsa yeni provider degistirmeden receipt ve entitlement genislemesini tasiyabilecek bir aile

---

## 12. Web checkout surface slot'u

### 12.1. Rol

Owner icin web odeme baslatma ve checkout UX yuzeyi.

### 12.2. Veri sinifi

`D3-financial`

### 12.3. Failure etkisi

Mevcut subscriber read akisi yasamaya devam edebilir.  
Ama yeni web upgrade/downgrade veya odeme baslatma aksiyonlari etkilenir.

### 12.4. Fallback

- feature temporary off
- owner'a billing support veya daha sonra tekrar deneme mesaji

### 12.5. Kritik kural

Checkout basarisi access acma sinyali degildir.  
Subscription authority sync tamamlanmadan entitlement degisimi yapilmaz.

### 12.6. Preferred implementation family

- hosted checkout provider

Ornek aile:

- Stripe Checkout-class

---

## 13. Extraction-render provider slot'u

### 13.1. Rol

URL import sirasinda gereken browser render, HTML extraction veya screenshot benzeri yardimci capability.

### 13.2. Veri sinifi

Genelde `D1-operational`

### 13.3. Failure etkisi

Yeni import ve refresh kalitesi ciddi degrade olur.

### 13.4. Fallback

Asagidaki degrade zinciri kullanilir:

1. deterministic source parse
2. structured data / meta tag extraction
3. review-required path

Ama unsupported sayfayi destekliymis gibi gosteren fallback yasaktir.

### 13.5. Kritik notlar

1. Provider'a gereksiz PII gonderilmez.
2. Raw page artefact'i kalici saklama ihtiyaci minimumda tutulur.
3. Policy-block veya unsafe redirect durumunda provider'a bile gidilmez.

### 13.6. Cikis stratejisi

- provider-specific extraction wrapper abstraction kullanilir
- merchant capability registry app-side truth olarak kalir

---

## 14. Domain and DNS provider slot'u

### 14.1. Rol

Custom domain verification, DNS target bilgisi ve custom domain capability'si certificate/edge yonetimi gerektiriyorsa bu capability'nin de kapsanmasi.

### 14.2. Veri sinifi

`D1` ve `D2`

### 14.3. Failure etkisi

Yeni custom domain aktivasyonlari durur.  
Mevcut aktif domain'ler edge/hosting modeline gore etkilenebilir veya etkilenmeyebilir.

### 14.4. Fallback

- custom domain onboarding gecici kapatilabilir
- handle tabanli canonical domain calismaya devam eder

### 14.5. Kritik kural

Provider down olsa bile handle tabanli default public URL urunu ayakta tutmalidir.

---

## 15. Error/performance observability slot'u

### 15.1. Rol

Error tracking, trace, release correlation ve performans sinyalleri.

### 15.2. Veri sinifi

`D1` ve kontrollu `D2`

### 15.3. Failure etkisi

Urun calismaya devam edebilir; ama gorme kabiliyeti azalir.

### 15.4. Fallback

- app log ve internal metrics ile sinirli gozumleme
- incident sirasinda lokal/DB tabanli audit daha fazla onem kazanir

### 15.5. Kritik kural

Observability payload'ina tam request body, hassas token veya gereksiz PII atilmaz.

### 15.6. Preferred implementation family

- error/performance platform

Ornek aile:

- Sentry-class

---

## 16. Product analytics and flags slot'u

### 16.1. Rol

Feature flag, urun event analitigi ve bazen deney/rollout kontrolu.

### 16.2. Veri sinifi

`D1`, kontrollu `D2`

### 16.3. Failure etkisi

Urun core truth'u bozulmaz.  
Flags ve analytics gorunurlugu kaybolabilir.

### 16.4. Fallback

- default-safe flag davranisi
- analytics event drop veya local queue

### 16.5. Kritik kural

Analytics urun utility'si icin gerekli minimum sinirda tutulur.  
Shadow profiling veya gereksiz user tracking yasaktir.

### 16.6. Preferred implementation family

- product analytics and flag platform

Ornek aile:

- PostHog-class

---

## 17. Transactional email slot'u

### 17.1. Rol

Invite, billing notice, export ready, security ve ownership-related operational email.

### 17.2. Veri sinifi

`D2-account`

### 17.3. Failure etkisi

Core publish/import akisi calismaya devam edebilir; ama kritik bildirimler gecikir.

### 17.4. Fallback

- app icinde notification badge
- support-facing retry queue

### 17.5. Kritik kural

Invite ve security mesajlari marketing kanali ile karistirilmaz.

### 17.6. Preferred implementation family

- transactional email provider

Ornek aile:

- Resend-class

---

## 18. Yeni vendor kabul kurallari

Yeni vendor eklemek icin asgari su sorularin yazili cevabi gerekir:

1. Hangi capability slot'unu dolduruyor?
2. Mevcut bir slot'u duplicate mi ediyor?
3. Hangi veri sinifina dokunuyor?
4. Critical path'te mi, yoksa optional mi?
5. Secret aileleri neler?
6. Incident sirasinda kill switch veya fallback var mi?
7. Export/migration cikisi var mi?
8. DPA/privacy/compliance review gerekiyor mu?

Kural:

Bu sorular yazili degilse vendor adoption tamamlanmis sayilmaz.

---

## 19. Secret ve ortam ayrimi

Her servis slot'u icin su ayrim zorunludur:

1. local/dev
2. preview
3. staging
4. production

Kurallar:

1. Sandbox ve production ayrik hesap/anahtar kullanir.
2. Client-side expose edilmesi gereken public key ile private credential ayri tutulur.
3. Secret owner ve rotasyon sorumlusu kayitlidir.

Bu detaylarin canonical matrisi `[100-environment-and-secrets-matrix.md](/Users/alperenkarip/Projects/product-showcase/project/operations/100-environment-and-secrets-matrix.md)` belgesinde tutulur.

---

## 20. Incident ve kill-switch ilkeleri

Her kritik servis slot'u icin asgari bir fail-safe davranis tanimlidir:

### 20.1. Database

- maintenance mode veya fail-closed

### 20.2. Extraction-render

- yeni import gecici kapatma
- mevcut public content'i bozmama

### 20.3. Billing

- yeni checkout kapatma
- mevcut entitlement snapshot ile kontrollu davranis

### 20.4. Analytics

- event drop veya no-op

### 20.5. Email

- queue retry
- app-side notice

Kural:

Kill switch yoksa servis kritik yola alinmamalidir.

---

## 21. Vendor degisimi ve cikis stratejisi ilkeleri

Her slot icin migration yetenegi basindan dusunulur.

### 21.1. Zorunlu cikis unsurlari

1. veri export imkani
2. provider abstraction seviyesi
3. event/contract mapping dokumani
4. secret ve DNS cutover plani
5. rollback stratejisi

### 21.2. Yasak yaklasimlar

1. Vendor-specific object id'leri urun domain'ine source of truth diye gommeye calismak
2. Bir provider'in hosted UI veya hosted data modeli etrafinda butun domain'i sekillendirmek
3. Cikis imkani olmayan closed analytics veya rendering entegrasyonlarini kritik yol yapmak

---

## 22. Senaryo bazli degerlendirmeler

### 22.1. Senaryo: Extraction provider outage

Beklenen davranis:

1. yeni import create endpoint'i kontrollu degrade olur
2. supported deterministic parse yollarina dusulebilir
3. review-required oraninin arttigi telemetry ile gorulur
4. unsupported sayfaya yalanci basari verilmez

### 22.2. Senaryo: Billing provider webhook lag

Beklenen davranis:

1. checkout success tek basina access acmaz
2. son bilinen entitlement snapshot korunur
3. reconcile job devreye girer

### 22.3. Senaryo: Object storage write problemi

Beklenen davranis:

1. yeni upload veya generation write'lari fail eder
2. mevcut immutable asset delivery bir sure surer
3. creator'a state acikca gosterilir; sessiz veri kaybi olmaz

### 22.4. Senaryo: Analytics provider kapatildi

Beklenen davranis:

1. core urun calismaya devam eder
2. feature flag default-safe moda duser
3. compliance veya privacy acisindan riskli local mirror devreye alinmaz

---

## 23. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Frontend'e gizli analytics/chat/script vendor eklemek
2. Ayni capability slot'u icin cift authoritative servis acmak
3. Billing truth'u ile checkout provider truth'unu karistirmak
4. Migration veya export cikisi olmadan kritik vendor secmek
5. Secret owner belirlemeden production anahtari acmak
6. PII tasiyan vendor icin compliance review atlamak
7. Fail-closed gerektiren bir slot icin fallback varmis gibi davranmak

---

## 24. Bu belge sonraki belgelere ne emreder?

### 24.1. Environment and secrets matrix'e

- her slot icin secret aileleri ve ortam ayrimi yazilacak

### 24.2. Incident response belgesine

- C0 ve C1 slot'lar icin incident playbook yazilacak

### 24.3. Privacy/compliance baseline'a

- D2/D3/D4 dokunan vendor'lar veri isleme ve DPA acisindan siniflanacak

---

## 25. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin su kosullar saglanmis olmalidir:

1. Launch ve sonrasi icin gerekli dis servis slot'lari acikca kayda alinmistir.
2. Her slot'un kritikligi, veri sinifi ve fallback modu bellidir.
3. Gizli vendor adoption yolu kapanmistir.
4. Secret, compliance, incident ve exit planlari bu register ile hizalanmistir.
5. Yeni biri "hangi dis servis bozulursa urun nasil etkilenir?" sorusunu bu belgeyi okuyarak cevaplayabilir.
