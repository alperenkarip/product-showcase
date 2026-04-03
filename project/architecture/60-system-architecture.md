---
id: SYSTEM-ARCHITECTURE-001
title: System Architecture
doc_type: technical_foundation
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - URL-IMPORT-PIPELINE-SPEC-001
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
blocks:
  - WEB-SURFACE-ARCHITECTURE
  - MOBILE-SURFACE-ARCHITECTURE
  - AUTH-IDENTITY-SESSION-MODEL
  - JOB-QUEUE-WORKER-REFRESH-ARCHITECTURE
  - OBSERVABILITY-INTERNAL-EVENT-MODEL
---

# System Architecture

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun teknik mimarisini en ust seviyede tanimlayan ana teknik omurga belgesidir. Sistem hangi runtime katmanlarindan olusur, public web, creator web, creator mobile, API, worker, media ve observability katmanlari nasil birbirine baglanir, hangi sorumluluk hangi runtime'da kalir ve hangi sinirlarin asla bulanıklaşmaması gerekir sorularina cevap verir.

Bu belge su sorulara cevap verir:

- Urun tek uygulama midir, yoksa birbirine bagli birden fazla runtime mi vardir?
- Public ve creator yuzeyleri neden ayni deploy/runtime olsa bile ayni urun davranisi sayilmaz?
- Import pipeline neden API request icine sikistirilamaz?
- Product, source ve placement ayrimi mimariye nasil yansir?
- Ops, support ve observability neden sonradan eklenen katmanlar degil, sistemin ilk sınıf parcasidir?

Bu belge, teknik slogan degil; sonraki mimari ve veri belgelerini baglayan source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Bu urun sıradan bir CRUD vitrini degildir.  
Sistem ayni anda su problemleri cozer:

- creator-centric recommendation publishing
- import ve extraction
- reuse / dedupe
- trust ve stale state management
- public SEO/share surfaces
- owner/editor authorization
- ops ve support tanilama

Bu kadar farkli ekseni tek "uygulama" zihniyetiyle toplarsak tipik olarak su hatalar olur:

1. public ve creator deneyimi birbirini bozar
2. import worker isleri request-response'a taşınır
3. auth ve permission logic UI katmanina yayilir
4. observability teknik log seviyesinde kalir
5. media, SEO ve share preview sonradan yamalanir

Bu nedenle system architecture belgesi, sonraki her teknik karar icin bağlayıcı çerçevedir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase`, tek runtime'a sikismis bir uygulama degil; public web, authenticated web, creator mobile, API/BFF, background worker/job hattı, media pipeline ve observability katmanlarindan olusan, domain primitive'lerini ortak paylasan ama surface sorumluluklarini bilincli ayrıştıran bir sistem olarak kurulacaktır.

Bu karar su sonuclari dogurur:

1. Public consumption web-first kalir.
2. Creator mobile hizli operasyon yuzeyi olur; public consumption mobile app'e zorlanmaz.
3. Import, refresh ve cleanup isleri worker katmaninda yasar.
4. Authorization karar zinciri API/domain katmaninda verilir; UI yalniz yansitir.
5. Media, SEO/share ve observability ayri uzmanlik katmanlari olarak modellenir.

---

## 4. Mimari tasarim ilkeleri

### 4.1. Surface separation

Public viewer, creator ve ops actor'leri ayni veriyi farkli sorularla gorur.  
Bu nedenle ayni route veya ayni screen shell'e zorlanmazlar.

### 4.2. Domain-first sharing

Paylasilacak asil katman UI degil, domain mantigidir.

Paylasilan alanlar:

- entity tanimlari
- contracts
- permission mantigi
- import outcome taxonomy
- trust state modeli

### 4.3. Async by default for external variability

Dis kaynaklara bagli veya maliyetli her iş:

- import
- refresh
- media derive
- metadata regenerate

request-response icine zorlanmaz.

### 4.4. Trust-preserving architecture

Fiyat, disclosure, stale state ve source secimi gibi guven sinyalleri cache, worker ve public render boyunca korunmalidir.

### 4.5. Auditability

Support ve ops icin "ne oldu?" sorusunun cevabi sistemde okunabilir kalmalidir.

---

## 5. Sistem bileşenleri

Sistem yedi ana bilesene ayrilir:

1. public web runtime
2. creator/ops web runtime
3. creator mobile runtime
4. API/BFF katmani
5. background jobs ve worker katmani
6. media/storage katmani
7. observability/internal event katmani

### 5.1. Public web runtime

Gorevi:

- storefront, shelf, content page ve light product detail render etmek
- SEO, canonical ve OG/share gereksinimlerini tasimak
- stale/disclosure/trust state'leri publicte dogru gostermek

### 5.2. Creator/ops web runtime

Gorevi:

- authenticated creator workspace
- library ve page editing
- billing/settings
- ops/support console

Bu runtime publicten farkli route guards ve data loading davranisi taşir.

### 5.3. Creator mobile runtime

Gorevi:

- quick import
- verification
- target secimi
- hafif page/storefront aksiyonlari

Viewer consumption'u tasimaz.

### 5.4. API/BFF katmani

Gorevi:

- auth/session uçlari
- domain write/read entrypoints
- permission kontrolu
- billing integration entrypoints
- public ve creator data composition

### 5.5. Background jobs / worker

Gorevi:

- import pipeline processing
- scheduled refresh
- retry/backoff
- cleanup / retention purge
- media / OG regeneration tetikleri

### 5.6. Media/storage katmani

Gorevi:

- imported product image'lar
- creator uploaded covers
- transformed variants
- generated OG/share assets

### 5.7. Observability/internal events

Gorevi:

- import stage telemetry
- failure taxonomy
- ops dashboard sinyalleri
- audit trail

---

## 6. Runtime topolojisi

### 6.1. Web

Web runtime mantiksal olarak uc route ailesine ayrilir:

- public
- creator authenticated
- internal ops/admin

Bu uc aile deploy seviyesi ayrik olmak zorunda degildir.  
Ama route ve permission duzeyinde ayrik kabul edilir.

### 6.2. Mobile

Mobile runtime yalniz creator actor'e hizli operasyon saglar.

### 6.3. API

API/BFF:

- web ve mobile icin ortak domain kapisidir
- ama surface-spesifik response composition yapabilir

### 6.4. Worker

Worker:

- API request'inden bagimsiz calisir
- queue, retry ve concurrency kontrolunu tasir

---

## 7. Web-first consumption karari

Bu urunde viewer consumption icin canonical surface public web'dir.

### Neden?

1. SEO ve share preview ihtiyaci
2. custom domain
3. frictionless anonymous access
4. app installation zorunlulugundan kacınma

### Sonuc

- deep link varsa app acilabilir
- ama canonical consumption URL her zaman webdir

---

## 8. Creator surface ayrimi

Creator actor iki ana yuzeyde calisir:

### 8.1. Mobile

Guc noktasi:

- hizli add
- verify
- publish continuation

### 8.2. Web

Guc noktasi:

- library organization
- bulk edit
- shelf/content page builder
- import history
- settings/billing

Bu fark mimari karardir; tasarim tercihi degil.

---

## 9. Domain primitive'lerin mimariye yansimasi

Bu urunde su ayrimlar tum katmanlarda korunur:

1. `Product`
2. `Product Source`
3. `Product Placement`
4. `Storefront`
5. `Shelf`
6. `Content Page`
7. `Import Job`

### 9.1. Neden kritik?

Cunku tipik mimari hata su olur:

- URL import sonucu doğrudan "product card" sanilir
- page üzerindeki gorunum product'in kendisiyle karistirilir

Bu belge bunu yasaklar.

### 9.2. Mimari sonucu

- API contracts bu primitive'leri ayri tasir
- worker yalnız source/import tarafini isler
- public render placement ve selected source uzerinden calisir

---

## 10. Request-response sinirlari

### 10.1. Senkron request'te kalanlar

- auth/session kararları
- basic CRUD validation
- permission check
- import request kabulü ve job create
- page save/draft/publish mutasyonlari

### 10.2. Asenkron hatta gidenler

- import extraction
- refresh
- broken link checks
- OG asset regeneration
- retention purge

### 10.3. Neden?

External variability, maliyet ve retry mantigi worker'a aittir.

---

## 11. API/BFF'in rolu

API yalniz veritabanı onunde ince bir proxy degildir.

Gorevleri:

1. authorization ve ownership enforcement
2. surface-appropriate response assembly
3. import job entrypoint
4. public read model composition
5. billing/webhook entitlements tarafina kapı olma

### 11.1. Neyi yapmaz?

- ağır extraction
- media dönüşüm
- uzun running maintenance işleri

---

## 12. Worker/job katmaninin rolu

Worker, import urununun teknik cekirdegidir.

Tasiyacagi işler:

1. initial import
2. retry import
3. source refresh
4. broken link check
5. stale cleanup
6. OG/media generation trigger
7. retention purge

### 12.1. Kural

API ve worker ayri sorumluluklar tasir.  
Worker, kullanıcı yüzeyi gibi davranmaz.  
API de kuyruk motoru gibi davranmaz.

---

## 13. Storage ve media katmani

### 13.1. Kalıcı veri

Product, source, placement, page, user, audit ve entitlements gibi kalıcı veriler domain storage'da tutulur.

### 13.2. Blob/media veri

Image ve generated asset'ler blob/object storage mantiginda tutulur.

### 13.3. Kural

- hotlink source-of-truth degildir
- optimize türevler ve originals ayrik yönetilir

---

## 14. Cache ve revalidation katmani

Bu sistemde cache yalniz performans konusu degildir; trust etkisi tasir.

Ornek:

- stale price state degisti
- page içeriği degismedi

Bu durumda full page payload degil, ilgili trust/source baglami invalidate edilmelidir.

### Kural

Cache politikasi domain semantics'i bozmamalidir.

---

## 15. Event ve observability katmani

Bu urunde teknik log yeterli degildir.

Gerekli event aileleri:

- import submitted/processing/review/applied/failed/blocked
- publish/unpublish/archive
- source stale/blocked
- billing entitlement changed
- support/ops action

### Kural

Request id, job id, actor id, merchant ve failure code baglari korunur.

---

## 16. Güvenlik ve yetki sinirlari

Authorization mimarinin tasarim sonrasi katmani degildir.

### 16.1. Public

- anonymous read
- canonical route behavior

### 16.2. Creator

- owner/editor role farkı
- workspace/storefront scope

### 16.3. Ops/admin

- internal route
- break-glass audit
- restricted mutation

Kural:

Permission karari domain/API katmaninda verilir.  
UI gizleme tek guvenlik katmani olamaz.

---

## 17. Deployment ve scaling dusuncesi

Bu belge exact infra vendor secimi yapmaz.  
Ama şu scaling mantığını bağlar:

1. public web traffic ile worker load'u ayrik düsünülecek
2. mobile client sayisi arttiginda auth/API load'u worker load'undan bagimsiz yönetilecek
3. import spike'lari public page latency'yi bozmayacak

### Sonuc

- queue backlog, public render'i kilitlememeli
- media generation, import critical path'i bloke etmemeli

---

## 18. Kritik failure konsantrasyon alanlari

Sistemin en hassas alanlari:

1. import ve extraction
2. stale/freshness management
3. auth/session + ownership
4. SEO/share preview doğruluğu
5. broken source ve outbound link safety
6. billing entitlement drift

Bu alanlar sonraki architecture/data/quality belgelerinde özel guardrail ister.

---

## 19. Non-goals

Bu belge su yaklasimlari reddeder:

1. her şeyi tek SPA + tek process'te eritmeyi
2. viewer consumption'u mobile app'e zorlamayi
3. import worker mantigini API request icine gömmeyi
4. public, creator ve ops surface'lerini tek UI mantiginda toplamayI

---

## 20. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Public ve creator surface'leri ayni route shell gibi ele almak
2. Worker'ı "arka planda biraz script" gibi görmek
3. Product/source/placement ayrimini API veya UI convenience uğruna ezmek
4. Observability'i yalnız error logging saymak
5. SEO/share metadata'yı page render bittikten sonra düşünmek

---

## 21. Bu belge sonraki belgelere ne emreder?

1. `61-web-surface-architecture.md`, public, creator ve ops route ailelerini bu surface ayrimina gore netlestirmelidir.
2. `62-mobile-surface-architecture.md`, creator-only mobile runtime kararini navigation ve offline sinirlariyla detaylandirmalidir.
3. `63-auth-identity-and-session-model.md`, owner/editor scope ve web/mobile session farkini teknik security modeline dönüştürmelidir.
4. `65-job-queue-worker-and-refresh-architecture.md`, import ve refresh işleri icin async execution modelini bu belgeye gore detaylandirmalidir.
5. `69-observability-and-internal-event-model.md`, event korelasyonunu bu bileşen topolojisiyle uyumlu kurmalidir.

---

## 22. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ekip hangi sorumlulugun hangi runtime'da yasadigini tek bakista anlayabiliyorsa
- public/creator/ops surface'leri ile API/worker/media/event katmanlari birbirine karismiyorsa
- import ve trust gibi kritik davranislar request-response kolayciligina kurban edilmiyorsa

Bu belge basarisiz sayilir, eger:

- mimari hala "tek uygulama, sonrasina bakariz" seviyesinde kalıyorsa
- worker, auth, media veya observability sonradan eklenecek detay gibi gorunuyorsa

