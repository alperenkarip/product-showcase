---
id: PROJECT-ROADMAP-001
title: Project Roadmap
doc_type: delivery_plan
status: ratified
version: 2.0.0
owner: product-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-SCOPE-NON-GOALS-001
  - SUCCESS-CRITERIA-LAUNCH-GATES-001
  - SYSTEM-ARCHITECTURE-001
  - URL-IMPORT-PIPELINE-SPEC-001
  - CREATOR-WORKFLOWS-001
  - RELEASE-READINESS-CHECKLIST-001
blocks:
  - WORK-BREAKDOWN-STRUCTURE
  - FEATURE-SEQUENCING-DEPENDENCY-ORDER
  - INITIAL-SEED-CONTENT-DEMO-DATA-PLAN
  - INTERNAL-TEST-PLAN
  - LAUNCH-TRANSITION-PLAN
---

# Project Roadmap

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun delivery sirasini, hangi capability ailesinin hangi fazda acilacagini, hangi alanlarin kritik yol uzerinde oldugunu, hangi faz kapanmadan sonraki fazin acilamayacagini ve launch'a giden yolda hangi kanitlarin zorunlu oldugunu tanimlayan resmi proje yol haritasidir.

Bu belge su sorulara cevap verir:

- delivery hangi mantikla parcaliyor?
- hangi capability once, hangisi sonra gelecek?
- hangi isler paralel ilerleyebilir, hangileri birbirini bloke eder?
- "erken gosterisli ekran" ile "gercek calisan urun omurgasi" nasil ayriliyor?
- ic test, kapali rollout ve genel acilis oncesi hangi fazlar kapanmis olmali?

Bu belge feature wishlist degildir.  
Bu belge delivery sirasini ve faz kapilarini sabitleyen source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Bu urun en kolay su hataya duser:

1. once guzel public vitrin ekranlari yapilir
2. import dogrulugu ve trust state'i delivery'nin sonuna itilir
3. creator workflow'u iki yuzeyde ayrisinca operasyonda dagilir
4. billing veya launch baskisiyla quality gate'ler zayiflatilir

Sonuc:

1. creator link yapistirir ama urune guvenmez
2. public vitrin gorunur ama stale, wrong image veya disclosure problemi tasir
3. support ve ops urunun arkasindan kosar
4. dogru capability yerine goze hos gelen ama launch'i geciktiren isler one cikar

Bu belge bu dagilmayi durdurur.  
Roadmap burada "ne zaman ne yapariz?" degil, "hangi siradan saparsak urun dogasi bozulur?" sorusunun cevabidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` ekran-first degil, truth-first delivery modeliyle gelisecektir; once domain, auth, publication ve import omurgasi kapatilacak, ardindan creator gunluk kullanim dongusu saglamlastirilacak, sonra public trust/polish ve monetization-operasyon katmanlari eklenecek; launch dogrudan kod tamamlama ile degil, ic test ve rollout kaniti ile acilacaktir.

Bu karar su sonuclari dogurur:

1. Public vitrin tasarimi, import ve trust modelini bypass ederek tek basina faz kapatmaz.
2. Billing ve plan enforcement, creator'in cekirdek utility'si kanitlanmadan one alinmaz.
3. Share extension, custom domain veya ileri analytics gibi genislemeler kritik yol disinda tutulur.
4. Launch, release readiness ve internal test evidence olmadan acilmaz.

---

## 4. Roadmap tasarim ilkeleri

Bu proje icin roadmap bes delivery ilkesine dayanir:

1. contract ve invariant once gelir
2. public truth, visual polish'ten once gelir
3. creator'in gunluk loop'u launch'in merkezidir
4. support/ops/compliance launch'tan once hazir olur
5. rollout bir fazdir; final adim degil, kanit toplama rejimidir

### 4.1. Contract ve invariant once gelir

Asagidaki alanlar erken sabitlenmeden UI gelistirmesi kapatilmaz:

- route ve slug modeli
- storefront/page/product/source/placement iliskileri
- roles ve ownership
- import state makinesi
- disclosure ve trust state'i

### 4.2. Public truth, visual polish'ten once gelir

Publicte:

- neyin gosterilecegi
- neyin gizlenecegi
- stale ve blocked state'in nasil yansiyacagi

net degilse animasyon, template cesidi veya copy polish ile faz kapatilmaz.

### 4.3. Creator'in gunluk loop'u launch'in merkezidir

Bu urunde ana davranis:

1. link eklemek
2. veriyi dogrulamak
3. sayfaya veya shelf'e yerlestirmek
4. publish etmek
5. daha sonra duzenlemek

Bu loop rahat degilse "urun var" denmez.

### 4.4. Support/ops/compliance launch'tan once hazir olur

Asagidaki alanlar launch sonrasi dusunulecek isler degildir:

- runbook
- support playbook
- incident response
- backup/restore
- disclosure policy
- link safety/takedown flow

### 4.5. Rollout bir fazdir

Internal test, kapali creator denemesi ve sinirli rollout kendi basina delivery fazlaridir.  
Bunlar "kod bitti, biraz da canli bakalim" mantigina indirgenmez.

---

## 5. Kritik yol ozeti

Bu projede kritik yol su omurgadir:

1. repo ve runtime iskeleti
2. domain/auth/publication truth
3. import pipeline ve verification
4. creator operating loop
5. public trust ve safety hardening
6. launch operations ve rollout evidence

Bu hattin disindaki alanlar:

- ileri template cesitliligi
- agresif team collaboration genislemesi
- zengin analytics ve audience insight
- yeni growth surfaces

kritik yolun onune gecmez.

---

## 6. Faz modeli

Bu roadmap yedi delivery fazina ayrilir:

0. implementation bootstrap
1. core domain ve public skeleton
2. import ve verification engine
3. creator operating loop
4. public trust ve quality hardening
5. monetization, ops ve governance readiness
6. internal validation ve launch transition

Her faz:

- net amac
- zorunlu capability seti
- kapanis kriteri
- acilmamasi gereken riskli genislemeler

tasir.

---

## 7. Faz 0 — Implementation bootstrap

## 7.1. Amac

Uygulamanin calisabilecegi repo, runtime ve deployment omurgasini kurmak.

Bu fazin amaci demo ekran acmak degil; delivery zemini olusturmaktir.

## 7.2. Kapsam

- uygulama ve paket sinirlarinin olusmasi
- public web, creator web, creator mobile, API ve jobs shell'leri
- environment ayrimi
- auth baseline kurulumu
- observability ve logging iskeleti
- shared contract ve config paketleri

## 7.3. Zorunlu ciktılar

1. `apps/web`
2. `apps/mobile`
3. `apps/api`
4. `apps/jobs`
5. ortak contract/domain/config omurgasi
6. local/preview/staging boot disiplini

## 7.4. Faz kapanis kriterleri

1. uygulama yuzeyleri ayni dil ve config rejimiyle ayağa kalkar
2. auth ve session omurgasi en az skeleton seviyede calisir
3. environment separation ihlali yoktur
4. repo package sinirlari kalici sekilde sabitlenmistir

## 7.5. Bu fazda acilmayan alanlar

- import parser detaylari
- creator page editor polish'i
- billing/plan enforcement
- support tooling

---

## 8. Faz 1 — Core domain ve public skeleton

## 8.1. Amac

Storefront, page, shelf, product ve publication omurgasini canonical hale getirmek.

## 8.2. Neden Faz 1 budur?

Bu urunun publicte ne yayinlayacagini bilmeden import veya creator UI tasimak dogru degildir.  
Once "hangi entity'ler var ve nasil yayinlaniyor?" sorusu kapanir.

## 8.3. Zorunlu capability'ler

1. workspace ve ownership modeli
2. storefront + handle + route modeli
3. shelf ve content-linked page yapisi
4. product library ve placement omurgasi
5. publication state ve public route rendering
6. temel creator auth gate

## 8.4. Faz icinde yapilacak somut isler

- DB schema'nin core tablo aileleri
- public route resolution
- page types ve publication modeli
- slug/URL davranisi
- owner/editor yetki ayirimi
- minimal public render katmani

## 8.5. Kapanis kriterleri

1. owner bir workspace ve storefront olusturabilir
2. en az bir shelf ve bir content page yayinlanabilir
3. page icindeki placement'lar publicte dogru sirada render edilir
4. unpublished/archived/removed state'ler publicte karismaz
5. creator owner/editor ayrimi kritik aksiyonlarda dogru calisir

## 8.6. Bu faz kapanmadan acilmayacak alanlar

- otomatik import
- selected source mantigi
- disclosure/trust row final davranisi
- billing plan gating

---

## 9. Faz 2 — Import ve verification engine

## 9.1. Amac

Link yapistirma deneyimini urunun cekirdek utility'si haline getirmek.

## 9.2. Zorunlu capability'ler

1. URL normalization
2. merchant capability registry
3. extraction fallback order
4. verification UI
5. dedupe ve product reuse modeli
6. refresh ve failure code omurgasi
7. import queue/worker gozlemlenebilirligi

## 9.3. Faz icinde yapilacak somut isler

- request -> job -> extraction -> verification -> apply akisi
- `full` / `partial` / `fallback-only` tier davranislari
- wrong image, blocked domain, timeout, missing price gibi failure aileleri
- selected source secimi ve correction kaliciligi
- import artefact retention ve support okunabilirligi

## 9.4. Kapanis kriterleri

1. creator link yapistirdiginda import sonucu okunabilir state ile doner
2. auto extraction belirsiz oldugunda review/correction yolu vardir
3. ayni urunun duplicate olusumu kontrollu sekilde engellenir
4. import failure nedeni generic hata degil, sinifli state ile izlenir
5. selected source ve refresh omurgasi state olarak kurulmustur

## 9.5. Bu faz kapanmadan acilmayacak alanlar

- creator quick add'i launch-critical yol saymak
- publicte fiyat/disclosure davranisini stabil kabul etmek
- unsupported merchant'lara genis growth dagitimi yapmak

---

## 10. Faz 3 — Creator operating loop

## 10.1. Amac

Creator'in urunu haftalik degil gunluk kullanabilecegi authoring loop'u tamamlamak.

## 10.2. Zorunlu capability'ler

1. mobile quick add ve duzeltme
2. creator web library, placement ve page management
3. publish/unpublish/update akislari
4. template ve customization'in kontrollu sinirlari
5. empty/loading/error state'lerin creator tarafinda netlesmesi

## 10.3. Faz icinde yapilacak somut isler

- creator mobile import baslangici
- creator web bulk duzenleme
- page ve shelf yonetimi
- product reuse akisi
- manual notes, tags ve organizasyon davranisi
- publish sonrasi public yansima ve invalidation

## 10.4. Kapanis kriterleri

1. creator mobilde urun ekleyip sonra webden duzenleyebilir
2. page'e urun yerleştirme ve sira verme akisi akicidir
3. publish/unpublish islemleri predictable davranir
4. same product reuse farkli page ve shelf baglamlarinda calisir
5. creator, destek almadan temel authoring loop'unu tamamlayabilir

## 10.5. Bu faz kapanmadan acilmayacak alanlar

- genis team collaboration matrix
- share extension lansmani
- custom domain self-serve akisi

---

## 11. Faz 4 — Public trust ve quality hardening

## 11.1. Amac

Public yuzeyi yalniz gorunen degil, guvenilen bir recommendation storefront haline getirmek.

## 11.2. Zorunlu capability'ler

1. disclosure/trust row davranisi
2. price freshness ve hide kurallari
3. link safety ve external content policy enforcement
4. SEO, OG ve share preview dogrulugu
5. performance ve accessibility budget'leri
6. public empty/error state'ler

## 11.3. Faz icinde yapilacak somut isler

- stale price state render davranisi
- disclosure badge/copy kurallari
- broken/unsafe link handling
- metadata ve OG generate/invalidation
- mobile web kalite audit'i
- public performance budget optimizasyonu

## 11.4. Kapanis kriterleri

1. publicte wrong-current hissi veren state'ler temizlenmistir
2. stale veya hidden-by-policy durumlari net copy ile görünur
3. external link cikislari policy ve safety kontrolunden gecmektedir
4. share preview ve SEO metadata kararlidir
5. accessibility ve performance cap'leri kabul bandindadir

## 11.5. Bu faz kapanmadan acilmayacak alanlar

- genis creator onboarding
- buyuk hacimli rollout
- growth surface optimizasyonu

---

## 12. Faz 5 — Monetization, ops ve governance readiness

## 12.1. Amac

Urunu isletilebilir, desteklenebilir ve kontrollu ticari sinirlari olan bir sisteme cevirmek.

## 12.2. Zorunlu capability'ler

1. subscription ve entitlement omurgasi
2. role/ownership recovery edge-case'leri
3. ops/admin ekranlari
4. support playbook'lari
5. incident/runbook/backup restore rejimi
6. privacy, disclosure ve takedown politikalarinin uygulama baglantilari

## 12.3. Faz icinde yapilacak somut isler

- billing checkout -> authoritative entitlement zinciri
- support summary ekranlari
- import failure ve webhook ops akislarinin okunabilirligi
- abuse/takedown operasyon akislari
- backup/restore tatbikati
- release readiness evidence paketleri

## 12.4. Kapanis kriterleri

1. owner plan state'i yanlis entitlement uretmez
2. support kritik issue ailelerini standardize sekilde ele alir
3. incident halinde hangi runbook'un calisacagi nettir
4. backup restore sinirlari ve rehearsal kanitlari vardir
5. compliance etkili issue'larda actor ve policy zinciri hazirdir

## 12.5. Bu faz kapanmadan acilmayacak alanlar

- genel erisim rollout'u
- buyuk partner veya merchant onboarding'i
- agresif growth veya promo kampanyalari

---

## 13. Faz 6 — Internal validation ve launch transition

## 13.1. Amac

Kodun varligini degil, urunun canliya cikmaya hazir oldugunu kanitlamak.

## 13.2. Zorunlu capability'ler

1. seed/demo veri seti
2. ic test cohort ve senaryo programi
3. kapali creator rollout plani
4. rollout expansion ve durdurma kriterleri
5. release evidence ve sign-off paketi

## 13.3. Faz icinde yapilacak somut isler

- internal dogfood
- import accuracy sweep
- support/ops dry run
- limited creator program
- release gate toplantisi
- rollout pacing ve stop condition izleme

## 13.4. Kapanis kriterleri

1. ic testte tekrarli kullanim davranisi gorulmustur
2. kapali creator cohort'u desteklenebilir yogunlukta kalmistir
3. import accuracy threshold'lari kabul bandindadir
4. support ticket temalari ve incident sinyalleri yönetilebilir seviyededir
5. release readiness checklist tam kanitla kapanmistir

---

## 14. Fazlar arasi sert bagimliliklar

Bu roadmap'te su sert bagimliliklar vardir:

1. Faz 1 kapanmadan Faz 2 launch-critical kabul edilmez
2. Faz 2 kapanmadan Faz 3'teki creator quick add "gunluk kullanim" iddiasi tasiyamaz
3. Faz 3 kapanmadan Faz 4'teki public kalite gercek davranisla test edilemez
4. Faz 4 kapanmadan Faz 5'te monetization/genis rollout acilmaz
5. Faz 5 kapanmadan Faz 6 dis cohort genisletilmez

Kural:

Fazlar kismen paralel ilerleyebilir; ama kapanis iddiasi bu bagimliliklari atlayamaz.

---

## 15. Paralel calisabilecek hatlar

Bu urunde paralel calisma vardir ama kontrolsuz degildir.

### 15.1. Faz 1-2 civarinda paralel ilerleyebilecekler

- public web skeleton ve route rendering
- creator web temel shell
- import worker altyapisi

Sart:

Core contracts ve domain state isimleri sabit olmalidir.

### 15.2. Faz 3-4 civarinda paralel ilerleyebilecekler

- creator web bulk edit
- creator mobile hizli giris deneyimi
- public copy ve visual hardening

Sart:

Import verification ve publication state davranisi baglanmis olmalidir.

### 15.3. Faz 5 civarinda paralel ilerleyebilecekler

- ops ekranlari
- support playbook uygulanmasi
- release evidence toplama

Sart:

Ops tooling product truth'tan ayri sahte state uretmemelidir.

---

## 16. Bilincli olarak ertelenen alanlar

Asagidaki capability'ler degerli olabilir; ama bu roadmap'te kritik yol degildir:

1. creator audience analytics
2. ileri collaborator matrix ve cok karmasik team izinleri
3. zengin template marketplace mantigi
4. public recommendation feed veya discovery motoru
5. share extension'in ilk release'e zorla alinmasi
6. merchant bazli agresif affiliate optimizasyonlari

Bu alanlar ancak Faz 3-4 kalitesi ve Faz 6 rollout evidence'i goruldukten sonra tekrar degerlendirilir.

---

## 17. Roadmap anti-pattern'leri

Asagidaki davranislar bu belgeye aykiridir:

1. public marketing veya visual polish'i import correctness'in onune koymak
2. unsupported merchant coverage'i registry ve fallback disiplini olmadan genisletmek
3. creator mobile ve creator web'i farkli domain diliyle gelistirmek
4. support ve incident belgeleri olmadan canli cohort acmak
5. billing'i checkout success sinyaline bagli sanmak
6. release readiness'i "ekip iyi hissediyor" seviyesine indirmek

---

## 18. Faz bazli owner beklentileri

### 18.1. Product

- faz kapilarini acik tutar
- kapsam kaymasini durdurur
- cohort expansion kararlarini evidence ile verir

### 18.2. Engineering

- contract-first disiplini korur
- async ve import kritik yolunu onceliklendirir
- ops readiness'i launch sonrasi is sanmaz

### 18.3. Design

- creator ve public surface kararlarini faza gore derinlestirir
- trust ve state davranislarini polish'ten ayri ele alir

### 18.4. Support/Ops

- Faz 5 ve Faz 6'da pasif izleyici degil, aktif gate owner'dir

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip:

1. hangi capability'nin neden once geldigini tartismasiz anlayabilmeli
2. kritik yol ile ertelenmis alanlari ayirabilmeli
3. launch baskisinda trust, import veya ops kalitesini feda etmemeli
4. her fazi yalniz teslim edilen kodla degil, davranis kaniti ile kapatabilmelidir

---

## 20. Sonraki belgelere emirler

Bu belge asagidaki belgeler icin baglayicidir:

1. `111-work-breakdown-structure.md`, epic ve capability kirilimini bu faz yapisina gore kuracaktir.
2. `112-feature-sequencing-and-dependency-order.md`, burada verilen sert bagimliliklari capability seviyesine indirecektir.
3. `113-initial-seed-content-and-demo-data-plan.md`, Faz 6 kaniti icin gereken seed veri ailesini bu roadmap'in creator/use-case onceligine gore tasarlayacaktir.
4. `114-internal-test-plan.md`, Faz 6 internal validation rejimini bu roadmap'in faz kapanis kriterleriyle hizalayacaktir.
5. `115-launch-transition-plan.md`, cohort expansion ve rollout pacing kararlarini bu belgeye aykiri sekilde hizlandiramayacaktir.
