---
id: WORK-BREAKDOWN-STRUCTURE-001
title: Work Breakdown Structure
doc_type: delivery_breakdown
status: ratified
version: 2.0.0
owner: product-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-ROADMAP-001
  - PROJECT-DEFINITION-OF-READY-001
  - PROJECT-DEFINITION-OF-DONE-001
  - SYSTEM-ARCHITECTURE-001
  - RELEASE-READINESS-CHECKLIST-001
blocks:
  - FEATURE-SEQUENCING-DEPENDENCY-ORDER
  - INTERNAL-TEST-PLAN
  - LAUNCH-TRANSITION-PLAN
---

# Work Breakdown Structure

## 1. Bu belge nedir?

Bu belge, `product-showcase` delivery planini epic -> capability -> task seviyesine indiren, her is kaleminin hangi urun amacina hizmet ettigini, hangi source-of-truth belgeye dayandigini, hangi owner tarafindan tasinacagini ve hangi tip kanitla kapatilacagini tanimlayan resmi work breakdown structure belgesidir.

Bu belge su sorulara cevap verir:

- roadmap'teki fazlar operasyonel is paketlerine nasil cevrilir?
- hangi epic hangi capability ailelerini tasir?
- capability ile task arasindaki sinir nerededir?
- spesifikasyon baglantisi olmayan is neden backlog'a giremez?
- support, compliance ve ops isleri hangi epic altinda temsil edilir?

Bu belge backlog dump'i degildir.  
Bu belge delivery kirilim mantigini sabitleyen source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Roadmap tek basina yeterli degildir.  
Is kalemleri yanlis kirilirse su sorunlar ortaya cikar:

1. public web polish task'i, import correctness capability'siyle ayni seviyede gorulur
2. creator mobile hizli giris, backend contracts kapanmadan gelistirilmeye baslanir
3. ops/compliance isleri backlog'un sonuna itilir
4. support tarafinda gerekli issue family'ler hic temsil edilmez
5. task'lar belgeye degil kisi hafizasina baglanir

Bu belge, backlog'u yalniz "yapilacaklar listesi" olmaktan cikarir;  
teslimat yapisini, owner'ligi ve kanit modelini kurar.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` backlog'u feature sayfasi mantigiyla degil; urunun truth, import, creator loop, public trust, operations ve rollout capability'leri etrafinda katmanli olarak kirilacaktir; her task bir capability'ye, her capability bir epic'e, her epic bir roadmap fazina bagli olacaktir; source-of-truth belgeye baglanmayan veya kabul kaniti tanimsiz is backlog'a girmeyecektir.

Bu karar su sonuclari dogurur:

1. Orphan task acilmaz.
2. "Ufak duzeltme" bile olsa capability ve kanit baglantisi kurulur.
3. Ops ve compliance isleri teknik backlog disi bir kuyruk gibi davranmaz.
4. Delivery gorunurlugu feature bazli degil, capability bazli olur.

---

## 4. WBS tasarim ilkeleri

Bu urunde WBS alti ilkeye dayanir:

1. phase-aligned
2. capability-centered
3. evidence-linked
4. owner-clear
5. cross-surface aware
6. supportable-by-design

### 4.1. Phase-aligned

Her epic, roadmap fazlarindan birine baskin olarak baglanir.  
Tek bir epic birden fazla faza dokunabilir; ama ana kapanis fazi nettir.

### 4.2. Capability-centered

Epic icinde isler ekranlara gore degil, capability'lere gore kirilir:

- import verification
- publication state
- disclosure rendering
- entitlement sync

### 4.3. Evidence-linked

Her capability icin:

- hangi belgeye dayandigi
- nasil test edilecegi
- hangi acceptance sinyaline bakilacagi

önceden yazilir.

### 4.4. Owner-clear

Capability tek owner'li olur.  
Birden cok ekip dokunsa bile "kapanis sahibi" tektir.

### 4.5. Cross-surface aware

Public web, creator web ve creator mobile ayrik gorevler gibi gozukebilir; ama capability ayniysa tek capability altinda toplanir.

### 4.6. Supportable-by-design

Import, billing, link safety ve restore etkili capability'lerde support/ops task'lari capability'nin ayrik parcasi olarak backlog'a girer.

---

## 5. Kullanim sozlugu

### 5.1. Epic

Ayri owner takibi, roadmap raporu ve capability paketi tasiyan en ust delivery toplulugudur.

### 5.2. Capability

Kullaniciya veya sisteme anlamli davranis kazandiran, tek acceptance cizgisi olan is paketidir.

### 5.3. Task

Capability'yi kapatmak icin gerekli kod, test, design, ops veya migration seviyesindeki uygulanabilir is kalemidir.

### 5.4. Subtask

Gerekirse task icindeki teknik parcadir.  
Bu belge canonical olarak subtask listesi tasimaz; task seviyesinde kalir.

---

## 6. Task acma kurallari

Bir task backlog'a girmeden once asgari su alanlari tasir:

1. bagli capability
2. referans belge
3. owner
4. surface veya runtime etkisi
5. risk sinifi
6. acceptance kaniti

Task acilamaz:

1. sadece "UI duzenle"
2. sadece "import iyilestir"
3. sadece "ops bakar"

gibi belirsiz ifadelerle.

---

## 7. Epic envanteri

Bu urunde on temel epic bulunur:

1. EPIC-01 platform foundation
2. EPIC-02 identity, workspace and publication core
3. EPIC-03 product library and content graph
4. EPIC-04 import, extraction and verification
5. EPIC-05 creator mobile workflow
6. EPIC-06 creator web workflow
7. EPIC-07 public web trust and discovery surface
8. EPIC-08 plans, billing and ownership operations
9. EPIC-09 support, ops and compliance
10. EPIC-10 quality, internal validation and launch

---

## 8. EPIC-01 Platform Foundation

### 8.1. Epic amaci

Tüm yuzeylerin ayni runtime, config, package ve deployment omurgasinda calismasini saglamak.

### 8.2. Capability'ler

1. CAP-01-01 repo/app/package bootstrap
2. CAP-01-02 environment and secrets discipline
3. CAP-01-03 auth shell and shared session wiring
4. CAP-01-04 observability baseline
5. CAP-01-05 shared contracts and client plumbing

### 8.3. Ornek task aileleri

`CAP-01-01` task'lari:

- app shell'lerini ayağa kaldirmak
- ortak config paketlerini kurmak
- route ve build bazli environment ayrimini oturtmak

`CAP-01-02` task'lari:

- `.env.example` alanlarini source-of-truth belgeyle hizalamak
- secret owner matrisi cikarmak
- preview/staging ayrimini enforce eden CI kontrolleri eklemek

`CAP-01-04` task'lari:

- request/job correlation id zinciri
- import, webhook, billing ve publish event loglamasi
- ops dashboard sinyal omurgasi

### 8.4. Acceptance cizgisi

Bu epic kapanmis sayilmak icin:

1. tum app shell'leri ayni contract omurgasiyla calisir
2. environment ihlali yoktur
3. observability, sonraki epic'leri koruyacak minimum seviyededir

---

## 9. EPIC-02 Identity, Workspace and Publication Core

### 9.1. Epic amaci

Creator kimligini, workspace yapisini ve public yayin iskeletini kurmak.

### 9.2. Capability'ler

1. CAP-02-01 user identity and session lifecycle
2. CAP-02-02 workspace, membership and role boundaries
3. CAP-02-03 storefront and handle lifecycle
4. CAP-02-04 page, shelf and publication state model
5. CAP-02-05 route, slug and public resolution

### 9.3. Task aileleri

`CAP-02-02` task'lari:

- owner/editor yetki matrisini route seviyesine indirmek
- invite ve membership recovery edge-case'lerini tanimlamak
- audit gerektiren role degisikliklerini kayda almak

`CAP-02-04` task'lari:

- draft/published/unpublished/archived state makinesi
- public render kararlarini route katmanina indirmek
- remove/takedown state'ini publication state'ten ayirmak

### 9.4. Acceptance cizgisi

1. creator auth ile workspace erisimi nettir
2. handle/storefront kimligi kararlidir
3. page ve shelf yayinlama davranisi publicte predictable'dir

---

## 10. EPIC-03 Product Library and Content Graph

### 10.1. Epic amaci

Product reuse, tagging, placement ve content-linked shelf modelini canonical hale getirmek.

### 10.2. Capability'ler

1. CAP-03-01 product canonical record
2. CAP-03-02 product source and selected source state
3. CAP-03-03 placement ordering and notes
4. CAP-03-04 tagging and classification
5. CAP-03-05 library reuse and duplicate prevention

### 10.3. Task aileleri

- product ile source'un ayri tablo ve UI summary'lerinde temsil edilmesi
- page icindeki placement relation'larin korunmasi
- duplicate merge veya reuse adaylarinin belirlenmesi
- tag taxonomy'nin search/filter katmanina indirilmesi

### 10.4. Acceptance cizgisi

1. ayni urun tekrar kopya kayda donusmez
2. placement graph public ve creator yuzeyde tutarlidir
3. selected source mantigi ilerleyen import capability'leriyle cakismaz

---

## 11. EPIC-04 Import, Extraction and Verification

### 11.1. Epic amaci

Urunun cekirdek utility'si olan URL import hattini guvenilir hale getirmek.

### 11.2. Capability'ler

1. CAP-04-01 URL normalization and dedupe entry
2. CAP-04-02 merchant capability registry
3. CAP-04-03 extraction fallback engine
4. CAP-04-04 verification and manual correction
5. CAP-04-05 price, image and trust state preservation
6. CAP-04-06 import failure taxonomy and retry logic
7. CAP-04-07 import supportability and telemetry

### 11.3. Task aileleri

`CAP-04-01`:

- tracking parametre temizligi
- canonical product candidate id uretimi
- varyant ve ayni urun ayrimi

`CAP-04-03`:

- merchant parser yolu
- structured data fallback
- og/html fallback
- AI boundary enforcement

`CAP-04-04`:

- review UI field confidence state'leri
- correction persistence
- apply sonrasinda source truth'un guncellenmesi

`CAP-04-06`:

- timeout, bot-block, partial extraction, ambiguous image failure kodlari
- retry/backoff politikasi
- blocked vs failed vs needs_review ayrimi

### 11.4. Acceptance cizgisi

1. import sonucu support ve creator tarafinda okunabilir state ile görünur
2. wrong image / wrong price / duplicate riskleri dogru siniflanir
3. import accuracy matrix'i bu epic icinde kanit uretir

---

## 12. EPIC-05 Creator Mobile Workflow

### 12.1. Epic amaci

Creator'in mobilde hizli ekleme, duzeltme ve hafif yonetim yapabilmesini saglamak.

### 12.2. Capability'ler

1. CAP-05-01 quick add flow
2. CAP-05-02 import review mobile handoff
3. CAP-05-03 lightweight library and page picker
4. CAP-05-04 mobile publish and confirmation feedback
5. CAP-05-05 mobile auth, deep link and resume states

### 12.3. Task aileleri

- URL paste / paylasim girisi
- page secimi ve placement ekleme
- review gerektiren alanlarda mobile correction
- deep link ile specific import veya page'e donus

### 12.4. Acceptance cizgisi

1. creator telefondan giris yapip urun ekleyebilir
2. verify gerektiren import'ta kaybolmaz
3. publish sonucu anlaşilir geri bildirim verir

---

## 13. EPIC-06 Creator Web Workflow

### 13.1. Epic amaci

Creator'in daha yogun duzenleme, organizasyon ve publish yonetimini webde yapabilmesini saglamak.

### 13.2. Capability'ler

1. CAP-06-01 library management
2. CAP-06-02 bulk edit and placement management
3. CAP-06-03 page and shelf composition
4. CAP-06-04 template and customization controls
5. CAP-06-05 domain and storefront settings

### 13.3. Task aileleri

- filtreli library listeleri
- sayfa icinde drag/order mantigi
- bulk note/tag/update akislari
- controlled template alanlari
- domain ve storefront genel ayarlari

### 13.4. Acceptance cizgisi

1. creator web, mobilin tamamlayicisi olarak agir isleri tasir
2. bulk duzenleme trust state'ini bozmaz
3. customization sinirlari product trust'u zedelemez

---

## 14. EPIC-07 Public Web Trust and Discovery Surface

### 14.1. Epic amaci

Public yuzeyi hizli, anlasilir ve guvenilir hale getirmek.

### 14.2. Capability'ler

1. CAP-07-01 public route rendering and navigation
2. CAP-07-02 disclosure and trust row
3. CAP-07-03 stale, hidden and removed state handling
4. CAP-07-04 SEO, OG and share preview
5. CAP-07-05 performance, accessibility and copy quality

### 14.3. Task aileleri

- shelf/page/storefront public layout
- external link CTA ve disclosure copy
- stale price, hidden price, broken link state render'lari
- OG image ve metadata generate
- Core Web Vitals ve a11y audit task'lari

### 14.4. Acceptance cizgisi

1. public kullanici neye tikladigini ve neyin ne kadar guncel oldugunu anlar
2. disclosure ve trust row eksiksizdir
3. public kalite budget'leri kabul bandindadir

---

## 15. EPIC-08 Plans, Billing and Ownership Operations

### 15.1. Epic amaci

Plan sinirlari, entitlement truth'u ve owner-odakli ticari davranisi canonical hale getirmek.

### 15.2. Capability'ler

1. CAP-08-01 plan model and feature entitlement
2. CAP-08-02 checkout and authoritative billing sync
3. CAP-08-03 ownership recovery and billing support cases
4. CAP-08-04 team/role expansion gates

### 15.3. Task aileleri

- plan capability matrisinin uygulama enforcement'i
- checkout bridge pending state'i
- webhook tabanli entitlement apply
- billing support summary ve ownership recovery akislari

### 15.4. Acceptance cizgisi

1. checkout success tek basina access acmaz
2. plan state'i creator capability'lerine dogru yansir
3. support ownership/billing issue'larini siniflandirabilir

---

## 16. EPIC-09 Support, Ops and Compliance

### 16.1. Epic amaci

Canli urunu desteklenebilir, gozlemlenebilir ve policy ile uyumlu yapmak.

### 16.2. Capability'ler

1. CAP-09-01 ops dashboards and failure triage
2. CAP-09-02 support issue family tooling
3. CAP-09-03 incident and runbook execution support
4. CAP-09-04 abuse, takedown and link safety workflow
5. CAP-09-05 backup, restore and governance operations

### 16.3. Task aileleri

- import failure ve queue backlog panelleri
- support issue detail summary
- abuse report review surface
- restore rehearsal checklist entegrasyonu
- audit ve action log kayitlari

### 16.4. Acceptance cizgisi

1. ops ekibi sistemik bozulmayi gorebilir
2. support issue aileleri urun truth'una bagli gorulur
3. compliance etkili akislarda actor ve policy zinciri vardir

---

## 17. EPIC-10 Quality, Internal Validation and Launch

### 17.1. Epic amaci

Gercek rollout'a gitmeden once ic kalite, kanit ve rollout pacing sistemini kurmak.

### 17.2. Capability'ler

1. CAP-10-01 seed and demo data readiness
2. CAP-10-02 internal test program
3. CAP-10-03 import accuracy and cross-platform audits
4. CAP-10-04 release evidence package
5. CAP-10-05 rollout pacing and stop conditions

### 17.3. Task aileleri

- seed creator/workspace veri seti olusturma
- dogfood cohort planlama
- import matrix ve manual audit calistirma
- release gate toplantisi icin kanit paketleme
- controlled rollout izleme dashboard'lari

### 17.4. Acceptance cizgisi

1. launch karari subjektif degil kanit bazlidir
2. rollout genislemesi stop condition'larla yonetilir
3. support kapasitesi ve kalite trendi ayni tabloda okunur

---

## 18. Capability -> task kirilim kurallari

Bir capability task'lara ayrilirken asagidaki kurallar zorunludur:

1. task tek owner ile kapanabilir olmalidir
2. task tek PR veya sinirli PR kumesiyle uygulanabilir olmalidir
3. task'in acceptance kaniti capability acceptance'ina baglanmalidir
4. task teknik, tasarim, veri, test veya ops turu tasiyabilir; ama capability disina tasamaz

Task siniri asildiginda:

- task capability'ye yukseltilir
- capability yeni capability'lere bolunur

---

## 19. Belge baglantisi zorunlulugu

Her capability birincil olarak en az bir source-of-truth belgeye baglanir.

Ornekler:

- `CAP-04-03 extraction fallback engine` -> `41-extraction-strategy-and-fallback-order.md`
- `CAP-07-02 disclosure and trust row` -> `27-disclosure-trust-and-credibility-layer.md` ve `91-disclosure-and-affiliate-labeling-policy.md`
- `CAP-09-05 backup, restore and governance operations` -> `104-data-backup-retention-and-restore.md`

Kural:

Belge baglantisi olmayan capability, product kararinin yoklugu anlamina gelir; implementasyona giremez.

---

## 20. Kanit ve done modeli

Capability kapanisi su kanit ailelerinden en az birini tasir:

1. contract/schema proof
2. integration/E2E proof
3. manual audit evidence
4. ops observability proof
5. support/compliance sign-off

Ornek:

- import capability'si sadece UI screenshot ile kapanamaz
- backup capability'si rehearsal kaniti olmadan kapanamaz
- disclosure capability'si policy + render audit olmadan kapanamaz

---

## 21. Anti-pattern'ler

Asagidaki davranislar bu belgeye aykiridir:

1. epic'leri ekran isimleriyle kurgulamak
2. support ve compliance islerini epic disi tutmak
3. tek capability icine birden cok acceptance cizgisi yigmak
4. "ufak task" diye source-of-truth belgeyi atlamak
5. import correctness task'larini public polish backlog'unda eritmek
6. kanit tanimi olmayan task kapatmak

---

## 22. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip:

1. hangi is kaleminin hangi epic/capability altina girecegini tartismasiz belirleyebilmeli
2. ops, support ve compliance islerini backlog'un yan urunu gibi degil, ana delivery parcasi olarak gorebilmeli
3. task kapatma sirasinda belge ve kanit bagini kaybetmemelidir

---

## 23. Sonraki belgelere emirler

Bu belge asagidaki belgeler icin baglayicidir:

1. `112-feature-sequencing-and-dependency-order.md`, burada tanimlanan epic ve capability'lerin sert ve yumusak bagimliliklarini cikaracaktir.
2. `113-initial-seed-content-and-demo-data-plan.md`, `EPIC-10` altindaki seed hazirliklarini capability bazli destekleyecektir.
3. `114-internal-test-plan.md`, `CAP-10-*` capability'lerini test cohort ve evidence planina cevirecektir.
4. `115-launch-transition-plan.md`, rollout genisleme kararlarini `EPIC-10` acceptance cizgisine baglayacaktir.
