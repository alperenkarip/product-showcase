---
id: TEST-STRATEGY-PROJECT-LAYER-001
title: Test Strategy - Project Layer
doc_type: evaluation_spec
status: ratified
version: 2.0.0
owner: quality-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-DEFINITION-OF-READY-001
  - PROJECT-DEFINITION-OF-DONE-001
  - API-CONTRACTS-001
  - URL-IMPORT-PIPELINE-SPEC-001
  - CACHE-REVALIDATION-STALENESS-RULES-001
blocks:
  - IMPORT-ACCURACY-TEST-MATRIX
  - CROSS-PLATFORM-ACCEPTANCE-CHECKLIST
  - RELEASE-READINESS-CHECKLIST
---

# Test Strategy - Project Layer

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun proje-ozel test stratejisini, hangi risk alanlarinin hangi test katmanlariyla korunacagini, import/public trust/cross-surface consistency gibi alanlarda neyin otomasyonla neyin manuel audit ile dogrulanacagini ve release'e giden yolun hangi kanitlarla beslenecegini tanimlayan resmi test strateji belgesidir.

Bu belge su sorulara cevap verir:

- Bu urunde testin ana amaci nedir?
- Hangi riskler unit test ile, hangileri workflow veya E2E ile korunur?
- Import accuracy ve trust rendering nasil test edilir?
- Mobile ve web arasindaki semantic consistency nasil dogrulanir?
- Hangi alanlarda manual audit zorunludur?
- Coverage oranindan bagimsiz olarak hangi akislarda "testsiz cikamaz" kuralimiz vardir?

---

## 2. Bu belge neden kritiktir?

Bu urunde test stratejisi yüzeysel kalirsa sorun yalniz bug sayisinin artmasi degildir.

Asil riskler:

1. Import sonucu teknik olarak parse olur ama yanlis urunu onerir.
2. Publicte stale price trust row'u render edilir ama yanlis state gosterir.
3. Web ve mobile ayni entity'yi farkli truth ile sunar.
4. Publish cache invalidation zinciri sessizce bozulur.
5. Owner-only bir aksiyon editor tarafinda da calisabilir.

Bu nedenle bu projede test, yalniz "bu fonksiyon dogru mu?" degil;  
"bu urun dogru, guvenilir ve tutarli davraniyor mu?" sorusunun operasyonel cevabidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` test stratejisi coverage-first degil risk-first kurulacaktir; import pipeline, duplicate/reuse, trust/disclosure, public publication, actor authorization ve cross-surface consistency en yuksek oncelikli test alanlari olacak; bu alanlar yalniz unit test ile korunmus sayilmayacaktir.

Bu karar su sonuclari dogurur:

1. Yuzde coverage tek basina kalite sinyali sayilmaz.
2. Import ve publish alanlari workflow/integration test olmadan yeterli korunmus kabul edilmez.
3. Public trust ve visual semantics alanlarinda manual audit zorunlu kalir.

---

## 4. Test felsefesi

Bu proje icin test felsefesi bes ilkeye dayanir:

1. Truth-first
2. risk-first
3. contract-first
4. scenario-first
5. evidence-first

### 4.1. Truth-first

Dogru response kadar dogru state semantigi de test edilir.

### 4.2. Risk-first

En cok zarar verecek alanlar en cok test yatirimini alir.

### 4.3. Contract-first

API ve event kontratlari test edilmeden UI green olsa bile feature tamamlanmis sayilmaz.

### 4.4. Scenario-first

Test yalniz isolated helper uzerinden degil; gercek actor ve state gecisleri uzerinden kurulmalidir.

### 4.5. Evidence-first

"Bence oldu" yerine saklanabilir test/audit kaniti uretilir.

---

## 5. Yüksek riskli test alanlari

Bu proje icin en yuksek oncelikli risk alanlari sunlardir:

1. URL import pipeline logic
2. duplicate/reuse kararlari
3. selected source ve trust derivation
4. disclosure ve stale price rendering
5. publish/unpublish + cache invalidation zinciri
6. owner/editor permission farklari
7. webhook ve billing bridge davranisi
8. custom domain/canonical davranisi

Bu alanlar icin yalniz smoke test yeterli kabul edilmez.

---

## 6. Test katmanlari

Bu proje icin test katmanlari alti aileye ayrilir:

1. static/contract verification
2. unit tests
3. integration tests
4. workflow/async tests
5. E2E tests
6. manual audit

---

## 7. Static ve contract verification

Amaç:

- schema drift'i erken yakalamak
- route ve event kontratlarini sabitlemek

Kapsam:

- API request/response schema
- event payload schema
- enum/state mapping
- permission matrix config veya rule mapping

Bu katmanin korudugu riskler:

1. client/server shape drift
2. webhook payload normalization hatasi
3. stale-write guard veya idempotency alaninin unutulmasi

---

## 8. Unit test katmani

Unit test yalniz saf helper seviyesinde degerlidir.  
Bu proje icin uygun unit alanlari:

- URL normalization
- merchant key extraction
- canonical dedupe key hesaplama
- freshness/trust state derivation
- permission helper'lari
- copy/state mapping helper'lari

Unit test'in tek basina yetmeyecegi alanlar:

- import apply
- publish invalidation zinciri
- billing bridge
- cross-surface parity

---

## 9. Integration test katmani

Integration test, DB ve application service katmaninin birlikte calistigi kanit katmanidir.

Asgari integration aileleri:

1. import -> verification creation
2. verification apply -> product/source/placement persistence
3. publish -> publication record + outbox event
4. selected source update -> cache invalidation event
5. team invite -> membership state
6. billing event -> subscription mirror + entitlement snapshot

Integration test zorunlu sorusu:

> Bu degisiklik DB state veya multi-service application flow degistiriyor mu?

Cevap evetse integration test gerekir.

---

## 10. Workflow / async test katmani

Import, refresh, OG generation, webhook follow-up gibi alanlarda asenkron davranis kritik oldugu icin workflow seviyesi test gerekir.

Asgari workflow aileleri:

1. import accepted -> processing -> needs_review
2. import retry ve parked/dead-letter davranisi
3. refresh scheduler eligibility
4. publish sonrasi OG/invalidation follow-up
5. billing webhook -> reconcile -> entitlement guncelleme

Kural:

Async workflow alanlarinda sadece synchronous service testleri yeterli kabul edilmez.

---

## 11. E2E test katmani

E2E test yalniz smoke degil, actor odakli kritik yol kanitidir.

Launch icin asgari E2E aileleri:

### 11.1. Creator web

- sign-in -> dashboard -> import create -> review ekranina ulasim
- product library'den shelf'e placement ekleme
- content page publish

### 11.2. Public web

- storefront route resolve
- shelf ve content page public render
- disclosure/stale trust row gorunurlugu
- canonical/redirect temel davranisi

### 11.3. Creator mobile

- paste/share entry
- import job detayina ulasim
- target secimi ve verification temel akisi

Kural:

Platform sayisi artiyor diye semantic core yollarin E2E kaniti kaldirilmaz.

---

## 12. Manual audit katmani

Bu projede manuel audit opsiyonel estetik kontrol degildir.  
Asagidaki alanlarda zorunludur:

1. primary image dogrulugu
2. disclosure copy ve gorunurlugu
3. stale trust ve hidden-by-policy ayrimi
4. public page hierarchy ve CTA netligi
5. mobile import hissi
6. a11y ve motion kritik akislari
7. share preview ve OG dogrulugu

Manual audit'te kaydedilmesi gerekenler:

- hangi build
- hangi platform
- hangi senaryolar
- bulunan riskler

---

## 13. Test veri aileleri

Bu proje icin test verisi asgari su fixture ailelerini kapsar:

1. supported merchant product page
2. tracking parametreli ayni URL varyasyonlari
3. redirect chain iceren URL
4. blocked domain
5. listing page / non-product page
6. missing price / missing currency
7. wrong primary image / low quality image
8. variant ambiguity
9. existing product reuse durumu
10. archived page / unpublished surface
11. owner vs editor actor varyasyonlari
12. stale source states

Kural:

Yalnizca temiz happy path fixture'larla test stratejisi tamamlanmis sayilmaz.

---

## 14. Degisiklik turune gore zorunlu test katmanlari

### 14.1. Import behavior degisikligi

Zorunlu:

- unit
- integration
- workflow
- import accuracy matrix etkileniyorsa ilgili kanit
- manual audit

### 14.2. Public UI / trust rendering degisikligi

Zorunlu:

- component/state testleri uygun oldugunda
- public E2E
- manual audit
- a11y kontrolu

### 14.3. Authorization / billing / webhook degisikligi

Zorunlu:

- contract verification
- integration
- workflow
- security checklist dogrulamasi

### 14.4. Copy-only gibi gorunen ama trust etkili degisiklik

Zorunlu:

- manual audit
- gerekiyorsa snapshot veya assertion

---

## 15. Import ve trust odakli ozel test ilkeleri

Bu proje icin en kritik alan import accuracy ile trust davranisidir.

Kural:

Tam extraction yapamamak bazen kabul edilebilir;  
ama yanlis ve inandirici extraction kabul edilemez.

Bu nedenle testler iki eksende olculur:

1. alan dogrulugu
2. belirsizlik durumunda dogru degrade

Ornek:

- `partial` veya `fallback-only` tier merchant'ta review-required davranisi pass olabilir
- ama sessizce yanlis primary image secmek fail sayilir

---

## 16. Cross-surface consistency ilkesi

Ayni product veya page truth'u farkli yuzeylerde farkli semantik tasimamalidir.

Test edilmesi gereken eksenler:

1. selected source / stale row web ve mobile uyumu
2. archived/unpublished state uyumu
3. owner/editor capability farklarinin her yuzeyde dogru yansimasi
4. custom domain ve canonical davranisi

---

## 17. Performance ve resilience testleri

Bu proje icin performans testleri yalniz lab metric'i degil, operasyonel davranis testi de icerir.

Asgari alanlar:

1. public page performance budget
2. creator dashboard responsiveness
3. import kabul ve median completion sureleri
4. queue backlog sirasinda degrade davranisi
5. revalidation latency

Kural:

Performans butcesi ayrik belgede tanimlansa da test stratejisi bu butcelerin nasil kanitlanacagini sahiplenir.

---

## 18. Manual vs automated siniri

Asagidaki alanlar otomasyonla guclu korunabilir:

- normalization
- state derivation
- permission karar mantigi
- publication ve webhook data flow

Asagidaki alanlar insan gozu ister:

- image semantic dogrulugu
- copy netligi
- trust hissi
- motion hissi
- mobile tactile akis

Yasak:

- insan audit isteyen alanlarda "snapshot aldik, yeter" demek

---

## 19. Test ortamlari

Asgari ortam ayrimi:

1. local/dev
2. preview
3. staging

### 19.1. Local/dev

Unit, integration ve belirli workflow testleri.

### 19.2. Preview

Feature branch acceptance ve hedefli manual audit.

### 19.3. Staging

Release adayi, webhook, billing, custom domain ve cross-platform kabul testleri.

Kural:

Webhook/billing/domain gibi provider etkili alanlar yalniz local mock ile kapanmis sayilmaz.

---

## 20. Basarisizlik siniflari

Test sonucu su siniflarda yorumlanir:

- blocker-fail
- release-risk
- accepted-with-followup

### 20.1. Blocker-fail

Ornek:

- wrong selected source
- owner-only action editor'da acik
- publicte stale current price yanlis gosterim

### 20.2. Release-risk

Ornek:

- belirli merchant'ta import latency bozulmasi
- OG preview bazen gec gelmesi

### 20.3. Accepted-with-followup

Ornek:

- non-critical copy refinement
- low-risk analytics event eksigi

Kural:

Release-risk ve blocker-fail kararlarini product + engineering birlikte degerlendirir.

---

## 21. Senaryo bazli zorunlu test paketleri

### 21.1. Senaryo: Supported merchant happy path

Beklenen:

1. import accepted
2. processing
3. needs_review veya auto-ready
4. apply
5. page placement
6. public trust row dogru

### 21.2. Senaryo: Ayni urun farkli tracking URL

Beklenen:

1. normalization ayni canonical key'e duser
2. duplicate/reuse davranisi dogru

### 21.3. Senaryo: Wrong OG image adayi

Beklenen:

1. quality rule reject veya review-required
2. yanlis gorsel sessizce primary olmaz

### 21.4. Senaryo: Price missing ama publish izinli

Beklenen:

1. current price hissi verilmez
2. public trust row dogru degrade olur

### 21.5. Senaryo: Blocked domain

Beklenen:

1. import create policy block
2. retry veya support aciklamasi net

---

## 22. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Coverage artisini kalite yerine koymak
2. Import alaninda yalniz unit test ile yetinmek
3. Public trust row degisikligini manuel audit olmadan gecirmek
4. Mobile ve web semantic consistency kontrolunu atlamak
5. Provider etkili akislari yalniz mock ile bitmis saymak
6. "Testsiz ama dusuk risk" diyerek aslinda yuksek riskli degisimi gecirmek

---

## 23. Bu belge sonraki belgelere ne emreder?

### 23.1. Import accuracy matrix'e

- alan bazli ve tier bazli dogruluk hedefleri burada tanimli test katmanlariyla kanitlanacak

### 23.2. Cross-platform acceptance checklist'e

- semantic parity ve actor flow maddeleri buradaki yuksek risk alanlariyla hizalanacak

### 23.3. Release readiness'e

- release adayinda hangi kanit setlerinin zorunlu olacagi bu belgeye dayanacak

---

## 24. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin:

1. Yüksek riskli alanlar net sekilde test sahipligi kazanmis olmali.
2. Otomasyon ve manual audit siniri acik sekilde cizilmis olmali.
3. Import/public trust/cross-surface consistency alanlari yeterince korunuyor olmali.
4. Ekip, "bu degisiklik hangi test katmanlarindan gecmeli?" sorusunu bu belgeyle hizli cevaplayabiliyor olmali.
