---
id: FEATURE-SEQUENCING-DEPENDENCY-ORDER-001
title: Feature Sequencing and Dependency Order
doc_type: dependency_plan
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-ROADMAP-001
  - WORK-BREAKDOWN-STRUCTURE-001
  - SYSTEM-ARCHITECTURE-001
  - URL-IMPORT-PIPELINE-SPEC-001
  - RELEASE-READINESS-CHECKLIST-001
blocks:
  - INTERNAL-TEST-PLAN
  - LAUNCH-TRANSITION-PLAN
---

# Feature Sequencing and Dependency Order

## 1. Bu belge nedir?

Bu belge, `product-showcase` backlog'undaki epic ve capability'lerin hangi sirayla acilacagini, hangi capability'nin hangi capability'ye sert veya yumusak bagimlilik tasidigini, hangi hatlarin paralel ilerleyebilecegini ve launch'a giden kritik zincirin nerede kirilamayacagini tanimlayan resmi sequencing belgesidir.

Bu belge su sorulara cevap verir:

- hangi capability once gelmelidir?
- hangi capability daha sonra gelse de launch'i bloklamaz?
- hangi isler paralel ilerleyebilir?
- hangi siralama hatasi urunun trust veya import kalitesini bozar?
- ic test ve rollout oncesi hangi capability'ler kapanmis olmalidir?

Bu belge backlog listesi degildir.  
Bu belge delivery sirasinin mantik haritasidir.

---

## 2. Bu belge neden kritiktir?

WBS capability'leri tanimlar, ama hepsinin ayni anda acilmasi mumkun degildir.  
Yanlis sequencing su zararlari uretir:

1. creator mobile hizli giris, import failure taxonomy olmadan acilir
2. public disclosure UI, trust state datasi yokken sahte davranir
3. billing UI once gelir ama authoritative webhook sync yoktur
4. ops ekranlari, gercek domain event omurgasi olusmadan maket gibi kalir

Bu belge delivery hizini dusurmek icin degil, yanlis hizlanmayi engellemek icin vardir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icinde sequencing contract -> identity/publication -> import -> creator loop -> public trust -> monetization/ops -> rollout kaniti sirasiyla ilerleyecektir; capability'ler sert bagimlilik, yumusak bagimlilik ve parallel-safe siniflarina ayrilacak; launch-kritik capability'ler kapanmadan, onlara bagli polish veya growth capability'leri oncelik kazanmayacaktir.

Bu karar su sonuclari dogurur:

1. UI-first yol secilmez.
2. Billing ve team expansion, creator utility ve trust sonrasina kalir.
3. Ops/compliance isleri launch sonrasina itilmez.
4. Paralel calisma yalnizca dependency zinciri korunarak yapilir.

---

## 4. Bagimlilik siniflari

Bu urunde uc tip bagimlilik vardir:

1. sert bagimlilik
2. yumusak bagimlilik
3. parallel-safe iliski

### 4.1. Sert bagimlilik

Upstream capability kapanmadan downstream capability kabul edilemez.

Ornek:

- route modeli olmadan public SEO capability'si kapanamaz
- webhook truth olmadan billing entitlement capability'si kapanamaz

### 4.2. Yumusak bagimlilik

Downstream capability baslayabilir; ama tam acceptance alamaz.

Ornek:

- creator mobile publish feedback ekranlari, public invalidation altyapisi bitmeden tasarlanabilir
- support tooling UI, import telemetry tamamlanmadan iskelet olarak cikabilir

### 4.3. Parallel-safe iliski

Iki capability ayni anda ilerleyebilir; cunku ortak truth dilini paylasir ama biri digerinin fonksiyonel kapanisina bagli degildir.

Ornek:

- creator web bulk edit ile public copy guidelines
- ops panel iskeleti ile release evidence template'i

---

## 5. Launch-kritik capability siniflari

Asagidaki capability aileleri launch-kritik kabul edilir:

1. identity/workspace/publication core
2. import verification ve dedupe
3. creator gunluk loop
4. public disclosure/trust/safety
5. support/ops minimumu
6. rollout evidence ve release readiness

Asagidaki aileler launch-kritik degildir:

1. ileri team collaboration
2. zengin template cesitleri
3. share extension
4. creator analytics
5. growth/discovery genislemeleri

---

## 6. Capability zinciri ozet gorunumu

Asagidaki zincir launch icin canonical sira kabul edilir:

1. `CAP-01-01` repo/app bootstrap
2. `CAP-01-02` environment and secrets discipline
3. `CAP-01-05` shared contracts and client plumbing
4. `CAP-02-01` identity and session lifecycle
5. `CAP-02-02` workspace, membership and role boundaries
6. `CAP-02-03` storefront and handle lifecycle
7. `CAP-02-04` page, shelf and publication state model
8. `CAP-03-01` product canonical record
9. `CAP-03-02` product source and selected source state
10. `CAP-04-01` URL normalization and dedupe entry
11. `CAP-04-02` merchant capability registry
12. `CAP-04-03` extraction fallback engine
13. `CAP-04-04` verification and manual correction
14. `CAP-04-06` import failure taxonomy and retry logic
15. `CAP-05-01` quick add flow
16. `CAP-06-01` library management
17. `CAP-06-03` page and shelf composition
18. `CAP-07-02` disclosure and trust row
19. `CAP-07-03` stale, hidden and removed state handling
20. `CAP-09-01` ops dashboards and failure triage
21. `CAP-09-02` support issue family tooling
22. `CAP-10-01` seed and demo data readiness
23. `CAP-10-02` internal test program
24. `CAP-10-04` release evidence package
25. `CAP-10-05` rollout pacing and stop conditions

Bu zincir her capability'nin tamamen bittigi anlamina gelmez; kritik acceptance sirasini gosterir.

---

## 7. Faz 0-1 sequencing

### 7.1. Once gelmesi zorunlu olanlar

1. repo/app bootstrap
2. environment and secrets discipline
3. auth shell and session wiring
4. shared contracts

Neden:

- sonraki tum runtime'lar buna dayanir
- import worker ve public render ayni config rejimine baglanir
- creator web ve mobile client'lar ayni auth contract'ini kullanir

### 7.2. Sert bagimliliklar

- `CAP-02-01` -> `CAP-01-03`
- `CAP-02-03` -> `CAP-02-02`
- `CAP-02-04` -> `CAP-02-03`
- `CAP-02-05` -> `CAP-02-03` ve `CAP-02-04`

### 7.3. Parallel-safe alanlar

- public shell layout
- creator web shell
- mobile navigation shell

Sart:

gercek domain action'lari mock yerine canonical contract isimleriyle baglanmalidir.

---

## 8. Faz 1-2 sequencing

### 8.1. Product graph import'tan once neden gelir?

Import engine ancak nereye yazacagini biliyorsa degerlidir.

Bu nedenle:

- product canonical record
- source state
- placement relation

import'tan once canonical hale gelir.

### 8.2. Sert bagimliliklar

- `CAP-04-01` -> `CAP-03-01` ve `CAP-03-02`
- `CAP-04-03` -> `CAP-04-02`
- `CAP-04-04` -> `CAP-04-03`
- `CAP-04-05` -> `CAP-04-04`
- `CAP-04-06` -> `CAP-04-03`
- `CAP-04-07` -> `CAP-01-04` ve `CAP-04-06`

### 8.3. Yumusak bagimliliklar

- verification UI tasarimi, extraction engine tamamlanmadan ilerleyebilir
- merchant capability registry UI/ops gorunumu, registry data modeliyle paralel cikabilir

### 8.4. Asla tersine cevrilmeyecek sira

Asagidaki sira tersine cevrilmez:

1. review/correction once, automation confidence sonra
2. failure taxonomy once, retry UX sonra
3. selected source truth once, stale render sonra

---

## 9. Faz 2-3 sequencing

### 9.1. Creator loop neden import sonrasina gelir?

Creator'in hizli ekleme deneyimi, import sonucu belirsizse degersizlesir.  
Bu nedenle mobile/web authoring once import'u tuketebilir hale gelmelidir.

### 9.2. Sert bagimliliklar

- `CAP-05-01` -> `CAP-04-04`
- `CAP-05-02` -> `CAP-04-06`
- `CAP-06-01` -> `CAP-03-05`
- `CAP-06-02` -> `CAP-03-03`
- `CAP-06-03` -> `CAP-02-04` ve `CAP-03-03`
- `CAP-06-04` -> `CAP-06-03`

### 9.3. Yumusak bagimliliklar

- mobile confirmation feedback ile public invalidation animation'lari paralel ilerleyebilir
- creator web settings ekranlari, custom domain entegrasyonu olmadan skeleton olarak gelisebilir

### 9.4. Kritik not

Creator mobile ile creator web farkli urunler gibi sira alamaz.  
Ikisi ayni creator operating loop'un iki ayagidir.

---

## 10. Faz 3-4 sequencing

### 10.1. Public trust neden authoring loop sonrasina bagli?

Public trust state'i ancak creator akislari gercek davranisla kullanildiginda dogrulanir:

- stale price ne zaman olusuyor?
- wrong image hangi correction'tan sonra duzeliyor?
- unpublished state hangi publish dengesinden geliyor?

Bu nedenle public trust capability'leri, creator loop ve import truth'tan sonra acceptance alir.

### 10.2. Sert bagimliliklar

- `CAP-07-02` -> `CAP-04-05`
- `CAP-07-03` -> `CAP-02-04` ve `CAP-04-06`
- `CAP-07-04` -> `CAP-02-05`
- `CAP-07-05` -> `CAP-07-01`

### 10.3. Parallel-safe alanlar

- copy guidelines
- motion/microinteraction katmani
- accessibility audit hazirligi

Sart:

state ve disclosure copy ana semantics'i degistiremez.

---

## 11. Faz 4-5 sequencing

### 11.1. Monetization neden public trust'tan sonra gelir?

Bu urun checkout olmayan recommendation surface'tir.  
Creator utility ve public trust oturmadan plan enforcement'i one almak urunun deger teklifini bozar.

### 11.2. Sert bagimliliklar

- `CAP-08-01` -> `CAP-02-02`
- `CAP-08-02` -> `CAP-01-03` ve `CAP-01-04`
- `CAP-08-02` -> `CAP-09-01` yumusak bagimlilik tasir; cunku billing olaylari ops gorunurlugu ister
- `CAP-09-02` -> `CAP-04-07`
- `CAP-09-03` -> `CAP-09-01`
- `CAP-09-05` -> `CAP-01-02` ve `CAP-01-04`

### 11.3. Asla atlanmayacaklar

1. checkout success, webhook authoritative sync'ten once entitlement acamaz
2. support tooling, issue family taxonomy olmadan generic ticket arayuzu olamaz
3. backup/restore tatbikati, release readiness oncesi atlanamaz

---

## 12. Faz 5-6 sequencing

### 12.1. Launch kaniti neden en sona gelir?

Cunku seed, internal test ve rollout pacing capability'leri onceki capability'lerin gercek davranisini olcer.  
Bunlar eksik bir urunu makyajla gecirecek katmanlar degildir.

### 12.2. Sert bagimliliklar

- `CAP-10-01` -> `CAP-04-04` ve `CAP-06-03`
- `CAP-10-02` -> `CAP-10-01`
- `CAP-10-03` -> `CAP-04-05` ve `CAP-07-05`
- `CAP-10-04` -> `CAP-09-01`, `CAP-09-03`, `CAP-09-05`
- `CAP-10-05` -> `CAP-10-02` ve `CAP-10-04`

### 12.3. Yumusak bagimliliklar

- release evidence template'leri daha erken hazirlanabilir
- rollout dashboard iskeleti internal test bitmeden hazırlanabilir

### 12.4. Kritik not

Internal test kaniti olmadan launch transition capability'si "hazir" sayilmaz.

---

## 13. Parallel lane modeli

Bu urunde dort ana paralel lane vardir:

1. domain/backend lane
2. creator surface lane
3. public trust lane
4. ops/quality lane

### 13.1. Domain/backend lane

Once:

- contracts
- schema
- auth
- import

tasir.

Bu lane kritik yolun omurgasidir.

### 13.2. Creator surface lane

Mobile ve web shell daha erken baslayabilir.  
Ama gercek interaction acceptance'i import ve publication capability'lerine baglidir.

### 13.3. Public trust lane

Public layout ve copy hazirligi paralel cikabilir.  
Ancak stale/disclosure/safety acceptance'i import truth olmadan kapanamaz.

### 13.4. Ops/quality lane

Observability, issue taxonomy, dashboards ve test evidence hatlari erken kurulabilir.  
Bu lane launch sonunda degil, ortasindan itibaren canli olmalidir.

---

## 14. Capability promotion kurali

Bir capability backlog'ta "aktif" statuye alinabilmesi icin:

1. upstream sert bagimliliklari en az skeleton seviyede kapanmis olmalidir
2. source-of-truth belge ratified olmalidir
3. acceptance sinyali tanimli olmalidir

Asagidaki durumda capability promote edilmez:

- upstream capability hala belge seviyesinde belirsizse
- urun state isimleri degisiyorsa
- owner net degilse

---

## 15. Capability freeze ve wait-state kurallari

Bazi capability'ler kismen ilerleyip wait-state'e alinabilir.

Ornekler:

1. creator web domain settings UI, domain verification backend'i bekleyebilir
2. share preview tasarimi, OG generate altyapisi hazir olana kadar wait-state'te kalabilir
3. billing UI, webhook authoritative state kanitlanana kadar feature-flag altinda tutulabilir

Kural:

Wait-state capability release kapsaminda "done" gibi raporlanmaz.

---

## 16. Anti-pattern sequencing ornekleri

Asagidaki sequencing hatalari yasaktir:

1. import review UI'yi extraction failure kodu olmadan release etmek
2. public disclosure alanini manual string ile cizip data modelini ardindan baglamak
3. mobile quick add'i page/publication graph dogrulanmadan launch etmek
4. support ekranini gercek issue family yerine serbest metin ticket ile acmak
5. rollout'u backup/incident evidence olmadan buyutmek

---

## 17. Ic test oncesi zorunlu kapanis seti

`114-internal-test-plan.md` aktiflestirilmeden once asgari su capability'ler kapanmis olmalidir:

1. `CAP-02-01`, `CAP-02-02`, `CAP-02-03`, `CAP-02-04`
2. `CAP-03-01`, `CAP-03-02`, `CAP-03-03`
3. `CAP-04-01`, `CAP-04-03`, `CAP-04-04`, `CAP-04-06`, `CAP-04-07`
4. `CAP-05-01` ve `CAP-06-03` minimum usable seviyede
5. `CAP-07-02` ve `CAP-07-03` minimum trust davranisiyla
6. `CAP-09-01` ve `CAP-09-02` minimum supportability seviyesinde

---

## 18. Genel acilis oncesi zorunlu kapanis seti

Genel erisim rollout'u icin asgari su capability'ler kapali olmalidir:

1. `CAP-08-02` authoritative billing sync, eger ucretli capability acik olacaksa
2. `CAP-09-03` runbook/incident execution support
3. `CAP-09-05` backup, restore ve governance operations
4. `CAP-10-02`, `CAP-10-03`, `CAP-10-04`, `CAP-10-05`

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip:

1. capability'leri rastgele degil dependency mantigiyla siralayabilmeli
2. paralel calisma ile sequencing ihlalini birbirinden ayirabilmeli
3. launch-kritik capability'leri polish/genisleme capability'lerinden net ayirabilmelidir

---

## 20. Sonraki belgelere emirler

Bu belge asagidaki belgeler icin baglayicidir:

1. `114-internal-test-plan.md`, test cohort siralamasi ve senaryo secimini burada belirtilen kapanis setine gore yapacaktir.
2. `115-launch-transition-plan.md`, rollout expansion oncesi hangi capability'lerin kapali olmasi gerektigini bu belgeyle hizalayacaktir.
