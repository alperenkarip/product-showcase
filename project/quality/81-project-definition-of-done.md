---
id: PROJECT-DEFINITION-OF-DONE-001
title: Project Definition of Done
doc_type: quality_gate
status: ratified
version: 2.0.0
owner: product-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-DEFINITION-OF-READY-001
  - TEST-STRATEGY-PROJECT-LAYER-001
  - IMPORT-ACCURACY-TEST-MATRIX-001
  - RELEASE-READINESS-CHECKLIST-001
blocks:
  - CROSS-PLATFORM-ACCEPTANCE-CHECKLIST
  - PERFORMANCE-BUDGETS
  - ACCESSIBILITY-PROJECT-CHECKLIST
  - SECURITY-AND-ABUSE-CHECKLIST
---

# Project Definition of Done

## 1. Bu belge nedir?

Bu belge, `product-showcase` icinde bir is paketinin yalnizca "kod yazildi" degil, urun, trust, failure, test, observability ve rollout boyutlariyla gercekten tamamlandigini gosteren resmi Definition of Done belgesidir.

Bu belge su sorulara cevap verir:

- Bir capability veya slice ne zaman gercekten done sayilir?
- Test gecti ama trust davranisi eksikse is kapanabilir mi?
- Import, billing, public publish ve security etkili islerde hangi ek kanitlar gerekir?
- Done karari icin hangi artefact'lar zorunlu kabul edilir?
- Hangi eksikler "takip issue'suna acariz" diye gecistirilemez?

---

## 2. Bu belge neden kritiktir?

Bu projede done disiplini zayif kalirsa ekip tipik olarak su hatalara dusuncektir:

1. Feature calisir ama error/retry/policy block davranisi eksik kalir.
2. Public route yayina cikar ama metadata, stale trust ve disclosure zinciri tamamlanmamis olur.
3. Import sonucu kaydedilir ama duplicate/reuse edge-case'i test edilmemistir.
4. Owner/editor yetki farki koda vardir ama acceptance kaniti yoktur.
5. Ops/support etkisi kapanmadan ticket "done" diye kapatilir.

Bu belge, "kod merge oldu = bitti" anlayisini sistematik olarak reddeder.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icinde bir is paketi yalnizca fonksiyonel calisma ile done sayilmaz; ilgili actor ve state'lerde dogru davraniyor, trust ve compliance sinirlarini koruyor, gerekli test ve audit kanitlarini tasiyor, observability ve rollout etkisi kapatilmis bulunuyorsa done kabul edilir.

Bu karar su sonuclari dogurur:

1. "Happy path calisiyor" done icin yeterli degildir.
2. Kritik islerde test + manual audit + operasyon notu birlikte gerekir.
3. Support veya rollout etkisi acik olmayan isler done sayilmaz.

---

## 4. Done kavraminin kapsami

Done karari su seviyelerde kullanilir:

1. tekil story/slice
2. capability
3. release candidate

Bu belge oncelikle slice/capability seviyesini hedefler; release seviyesi son gate `[88-release-readiness-checklist.md](/Users/alperenkarip/Projects/product-showcase/project/quality/88-release-readiness-checklist.md)` belgesidir.

---

## 5. Done icin zorunlu kanit katmanlari

Bir is paketi done sayilmak icin asgari su dokuz kanit katmanindan gecmelidir:

1. fonksiyonel tamamlanma
2. state ve failure davranisi
3. actor / permission dogrulugu
4. veri ve migration butunlugu
5. trust / compliance gorunurlugu
6. test kaniti
7. observability / support hazirligi
8. rollout notu
9. dokuman senkronizasyonu

---

## 6. Fonksiyonel tamamlanma

Asgari kosullar:

1. Ready asamasinda tanimlanan scope tamamlanmistir.
2. In-scope davranislar calsir.
3. Out-of-scope alanlarda sessiz kapsam kaymasi yapilmamistir.

Done olmayan ornek:

- Mobile quick import girisi eklendi ama target-context secimi hala placeholder.

---

## 7. State ve failure davranisi

Done icin happy path disi state'ler de calisiyor olmalidir.

Asgari olarak kontrol edilmesi gereken aileler:

- loading
- validation error
- unauthorized/forbidden
- policy block
- retryable technical failure
- terminal failure
- empty state

Kural:

Hata mesajinin gorunmesi tek basina yeterli degildir; kullanici cikissiz kalmamalidir.

Ornek:

Import slice done sayilmak icin su hallerin davranisi acikca test veya audit edilmis olmalidir:

- blocked domain
- duplicate active job
- needs review
- review expired
- apply conflict

---

## 8. Actor ve permission dogrulugu

Done sayilmasi icin su actor kontrolleri kapanmis olmalidir:

1. anonymous vs signed-in ayrimi
2. owner vs editor ayrimi
3. support/ops alanlarinda audit izi
4. auth/session bozulumunda dogru degrade

Done olmayan ornek:

- Feature owner icin calisiyor ama editor'un hatasi kontrol edilmemis.

---

## 9. Veri, migration ve cache butunlugu

Asgari kosullar:

1. Yeni field/state/tablo gerekiyorsa migration veya schema guncellemesi tamamlanmistir.
2. Cache/revalidation etkisi test veya audit edilmis.
3. Stale-write veya idempotency gerektiren akislarda guard uygulanmistir.
4. Telemetry/event isimleri kararli ve belgelerle uyumludur.

Done olmayan ornek:

- selected source guncelleniyor ama ilgili public invalidation zinciri eklenmemis.

---

## 10. Trust ve compliance gorunurlugu

Bu proje icin done kavrami trust alanini explicit olarak kapsar.

Asgari kosullar:

1. Disclosure gerekiyorsa gorunur.
2. Stale veya hidden-by-policy davranisi dogru.
3. Publicte yaniltici current/fresh his uretilmiyor.
4. Unsafe link veya blocked domain durumunda cikis yolu guvenli.

Import, pricing, external link ve public viewer etkili islerde bu katman kapanmadan is done sayilmaz.

---

## 11. Test kaniti

Her is paketi Ready asamasinda secilen test katmanlarina gore kanit tasimalidir.

Asgari kanit turleri:

- unit
- integration
- workflow
- e2e
- manual audit

Kural:

Test secilmisse kanit gerekir; "zaman kalmadi" gerekcesiyle sessizce atlanamaz.

R3/R4 degisimlerde:

- yalniz unit test done icin yeterli degildir

---

## 12. Manual audit zorunlu alanlar

Asagidaki degisim ailelerinde manuel audit zorunludur:

1. public visual hierarchy degisikligi
2. disclosure/stale trust row degisikligi
3. import verification UI degisikligi
4. mobile share-entry veya paste-entry degisikligi
5. OG/share preview degisikligi
6. accessibility-impactful interaction degisikligi

Manual audit done kanitinda su bilgi bulunur:

- hangi platformlarda bakildi
- ne dogrulandi
- hangi riskler kontrol edildi

---

## 13. Observability ve support hazirligi

Done sayilmasi icin:

1. Gerekli event/metric/log alanlari eklenmis olmali.
2. Ops/support etkisi not edilmis olmali.
3. Yeni failure code aileleri gerekiyorsa dokumante edilmeli.

Ornek:

- yeni import failure code'u eklenmis ama ops read model'i ve alert notu yoksa is tam kapanmis sayilmaz

---

## 14. Rollout ve rollback notu

Asgari olarak su bilgi bulunur:

1. feature flag gerekiyor mu?
2. migration once/sonra sirasi var mi?
3. rollback'te veri riski var mi?
4. hangi ortamlarda dogrulandi?

Kural:

Rollout notu olmayan kritik is done sayilmaz.

---

## 15. Dokuman senkronizasyonu

Done sayilmasi icin:

1. Source-of-truth belge etkileniyorsa guncellenmis olmali.
2. Yeni davranis mevcut belgeye ters dusmemeli.
3. Test ve release checklist referanslari gerekiyorsa eklenmeli.

Yasak:

- uygulanan domain karari sadece PR yorumunda kalmak

---

## 16. Risk sinifina gore ek done gereksinimleri

### 16.1. Dusuk riskli degisim

Asgari:

- fonksiyonel kanit
- temel acceptance

### 16.2. Orta riskli degisim

Ek olarak:

- ilgili state/failure kaniti
- actor/performance etkisi gozden gecirilmis

### 16.3. Yuksek riskli degisim

Ornek:

- import pipeline
- public trust row
- selected source
- publish flow
- custom domain

Ek olarak:

- integration veya workflow kaniti
- manual audit
- ops/observability notu

### 16.4. Kritik riskli degisim

Ornek:

- billing
- auth/session
- ownership transfer
- webhook consumer

Ek olarak:

- security/compliance checklist maddeleri
- rollback ve incident notu
- gerekiyorsa cross-functional sign-off

---

## 17. Done checklist'i

Bir is paketi kapatilmadan once asgari su checklist gecilir:

1. Scope tamamlandi.
2. Failure ve edge-case davranislari kapandi.
3. Actor/permission kontrolleri dogrulandi.
4. Veri/cache/event etkisi kapandi.
5. Trust/compliance gorsel veya davranissal cizgiler tamamlandi.
6. Planlanan test katmanlari gecti.
7. Gerekli manual audit tamamlandi.
8. Observability ve support notu eklendi.
9. Rollout/rollback notu yazildi.
10. Belge referanslari guncellendi.

---

## 18. Done olmayan tipik durumlar

Asagidaki hallerde is kapatilamaz:

1. disclosure/trust row eksik
2. unsupported merchant fallback cikissiz
3. public metadata/share preview kontrol edilmemis
4. mobile ve web ayni data'yi tutarsiz gosteriyor
5. owner/editor yetki farki test edilmemis
6. import retry veya expiry davranisi belirsiz
7. support impact'i bilinmiyor

---

## 19. Senaryo bazli done ornekleri

### 19.1. Senaryo: Public content page redesign

Done icin:

1. mobil ve desktop acceptance bakildi
2. disclosure ve stale row kontrol edildi
3. metadata/OG sonucu dogrulandi
4. performance ve a11y riskleri incelendi

### 19.2. Senaryo: Import reuse iyilestirmesi

Done icin:

1. duplicate detection unit/integration testleri gecti
2. verification review path manuel bakildi
3. apply conflict ve expired session senaryolari kontrol edildi
4. import telemetry guncellendi

### 19.3. Senaryo: Owner-only billing portal action

Done icin:

1. editor denied davranisi test edildi
2. provider unavailable durumunda UI karsiligi goruldu
3. support ve release gate notu yazildi

---

## 20. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Yalniz happy path'i gorup is kapatmak
2. Test secildigi halde kanit eklememek
3. Import ve billing gibi riskli alanlari "follow-up issue" diye gevsetmek
4. Visual/trust degisikliklerinde manual audit'i atlamak
5. Dokuman cizgisi guncellenmeden ticket kapatmak

---

## 21. Bu belge sonraki belgelere ne emreder?

### 21.1. Cross-platform acceptance checklist'e

- parity ve semantic consistency maddeleri done kanitina baglanacak

### 21.2. Performance, accessibility, security checklist'lerine

- riskli degisimlerde bu checklist'lerden ilgili maddeler done kanitina dahil edilecek

### 21.3. Release readiness'e

- release'e girecek degisimler done belgesindeki kanitlari tasimak zorunda olacak

---

## 22. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin:

1. "Calisiyor" ile "guvenli ve tamamlanmis" arasindaki fark netlesmis olmali.
2. Ticket kapatma karari subjektif degil, kanit bazli veriliyor olmali.
3. Import, public trust, billing ve security alanlarinda done kalitesi yuksek tutuluyor olmali.
4. Yeni bir ekip uyesi, bir is neden kapanmiyor sorusunun cevabini bu belgeyle anlayabiliyor olmali.
