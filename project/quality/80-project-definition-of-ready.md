---
id: PROJECT-DEFINITION-OF-READY-001
title: Project Definition of Ready
doc_type: quality_gate
status: ratified
version: 2.0.0
owner: product-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - SUCCESS-CRITERIA-LAUNCH-GATES-001
  - PRODUCT-SCOPE-NON-GOALS-001
  - API-CONTRACTS-001
  - DATABASE-SCHEMA-SPEC-001
blocks:
  - PROJECT-DEFINITION-OF-DONE
  - TEST-STRATEGY-PROJECT-LAYER
  - RELEASE-READINESS-CHECKLIST
---

# Project Definition of Ready

## 1. Bu belge nedir?

Bu belge, `product-showcase` icindeki herhangi bir capability, epic, spike, story veya teknik degisikligin implementasyona girmeden once hangi bilgi, karar, risk ve kabul kosullarina sahip olmasi gerektigini tanimlayan resmi Definition of Ready belgesidir.

Bu belge su sorulara cevap verir:

- "Baslayabiliriz" demek icin hangi girdi seti zorunludur?
- Dokuman zinciri ne zaman yeterli sayilir?
- Hangi isler tasarim/urun karari hazir olmadan koda girmemelidir?
- Import, public trust, billing veya security etkili bir is icin ek hazirlik kosullari nelerdir?
- Ready olmayan isi hiz icin baslatmanin bedeli nedir?

---

## 2. Bu belge neden kritiktir?

Bu projede ready disiplini zayif olursa tipik olarak su sorunlar cikar:

1. Koda baslanir ama actor/scope belirsiz oldugu icin permission modeli ortada kalir.
2. Public sayfa tasarlanir ama stale/disclosure/error state'leri sonra dusunulur.
3. Import ozelligi yazilir ama retry, review expiry ve duplicate davranisi tanimsiz kalir.
4. Test stratejisi en sona itilir ve feature "gorunurde calisiyor" seviyesinde kalir.
5. Support/ops etkisi belirsiz oldugu icin rollout sonrasi issue'lar costli hale gelir.

Bu belge, "brief var, haydi baslayalim" kulturunu degil; kaliteyi erken sabitleyen calisma disiplinini zorunlu kilmak icin vardir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icinde hicbir is paketi yalnizca ekran taslagi, kaba fikir veya teknik his ile implementasyona girmez; actor, surface, source of truth, failure mode, acceptance seviyesi, test niyeti ve rollout etkisi netlesmeden is ready sayilmaz.

Bu karar su sonuclari dogurur:

1. "UI belli, backend'i cikaririz" mantigi ready sayilmaz.
2. Import, billing, security ve public trust etkili isler icin ek hazirlik paketi gerekir.
3. Dokuman referansi olmayan kritik kararlar backlog item icine gizlenemez.

---

## 4. Ready kavraminin kapsami

Ready karari su seviyelerde kullanilir:

1. epic
2. capability
3. implementation slice
4. hotfix

Her seviyede ayni derinlik gerekmez.  
Ama hicbirinde temel actor/risk/test cizgisi atlanmaz.

### 4.1. Epic seviyesinde ready

Beklenen:

- kapsam
- non-goal
- ana actor'ler
- temel domain etkisi
- ana acceptance hatlari

### 4.2. Slice seviyesinde ready

Beklenen:

- exact surface
- exact mutation veya read modeli
- state/failure davranisi
- test seviyesi
- rollout veya migration etkisi

### 4.3. Hotfix seviyesinde ready

Daha kisa olabilir; ama su alanlar yine zorunludur:

- problem tanimi
- etkilenen actor/surface
- regresyon riski
- minimum test ve rollback plani

---

## 5. Ready icin zorunlu bilgi katmanlari

Bir is paketi ready sayilmak icin asgari sekiz bilgi katmani tamamlanmis olmalidir:

1. problem ve amac
2. scope ve non-goal
3. actor ve permission etkisi
4. surface ve state modeli
5. source of truth / veri etkisi
6. failure ve edge-case davranisi
7. test ve acceptance niyeti
8. rollout ve operasyon etkisi

---

## 6. Problem ve amac katmani

Asgari sorular:

- Ne problemi cozuyoruz?
- Bu degisiklik hangi kullanici veya sistem davranisini iyilestiriyor?
- Basari neye gore olculecek?
- Bu is neden simdi yapiliyor?

Ready olmayan ornek:

- "Import ekranini daha iyi yapalim"

Ready olan ornek:

- "Mobile quick import girisinde link yapistirma sonrasi hedef secimi belirsiz kaliyor; bu nedenle kullanicilar job'i library-only mi yoksa content page hedefli mi baslattigini anlayamiyor; hedef akisi iki adimli ama explicit hale getirilecek."

---

## 7. Scope ve non-goal katmani

Asgari sorular:

- Bu is tam olarak hangi surface'leri etkiliyor?
- Hangi surface'leri etkilemiyor?
- Bu is launch cekirdegine mi, sonraki faza mi ait?

Kural:

Scope taniminda "simdilik", "ilerde bakariz" gibi acik kapi birakan ifadeler yerine explicit disarida birakma gerekir.

Ornek:

- In scope: creator mobile quick import girisi
- Out of scope: public viewer import, toplu URL import, barcode entry

---

## 8. Actor ve permission katmani

Hazir sayilmasi icin su sorularin cevabi net olmalidir:

- anonymous viewer etkileniyor mu?
- owner ve editor farkli davranacak mi?
- support/ops route veya arac etkisi var mi?
- auth/session gereksinimi degisiyor mu?

Ready olmayan ornek:

- "Creator buradan da publish edebilir"

Eksik soru:

- Hangi creator? owner mi, editor mu?
- mobile publish owner-only mi?
- billing limiti publish'i etkiliyor mu?

---

## 9. Surface ve state modeli katmani

Asgari tanimlanmasi gerekenler:

1. happy path
2. empty state
3. loading state
4. validation error
5. policy block
6. retry/recover state
7. terminal failure

Kural:

Yalnizca ideal akisin cizilmis olmasi ready sayilmaz.

Ornek:

Bir import iyilestirmesi ready sayilmak icin su state'ler bilinmelidir:

- malformed URL
- blocked domain
- duplicate active job
- needs review
- review expired
- apply conflict

---

## 10. Source of truth ve veri etkisi katmani

Asgari sorular:

- Hangi entity veya tablo etkileniyor?
- Yeni field, yeni state veya yeni event gerekiyor mu?
- Data migration gerekiyor mu?
- Cache/revalidation etkisi var mi?

Ready olmayan ornek:

- "Source selection'i buradan update ederiz"

Eksik bilgiler:

- `products.selected_source_id` mi degisecek?
- hangi invalidation tag'leri tetiklenecek?
- stale-write guard alani ne olacak?

---

## 11. Failure ve edge-case katmani

Hazir sayilmasi icin en az su failure sorulari cevaplanmalidir:

- Kullanici neyi yanlis yapabilir?
- Harici servis neyi bozabilir?
- Veri eksikligi olursa ne gorulecek?
- Yetki yoksa sistem ne yapacak?
- Kismi basari var mi?
- Job async ise kullanici ne zaman bekler, ne zaman ayrilabilir?

Import, trust, pricing veya external link etkili islerde ek olarak:

- blocked vs failed ayrimi
- stale vs unavailable ayrimi
- review-required vs success ayrimi

netlesmis olmalidir.

---

## 12. Test ve acceptance niyeti katmani

Her is paketi ready asamasinda su test niyetini tasimak zorundadir:

1. hangi test katmanlari zorunlu
2. hangi manuel audit gerekli
3. hangi acceptance checklist maddeleri etkilenecek

Asgari etiketleme:

- `unit`
- `integration`
- `workflow`
- `e2e`
- `manual-audit`

Ready olmayan ornek:

- "Test ederiz"

Ready olan ornek:

- "URL normalization unit test, import->verification integration test, iOS share-entry manual audit, public stale trust rendering snapshot/E2E gerekecek."

---

## 13. Rollout ve operasyon katmani

Hazir sayilmasi icin su sorularin cevabi net olmalidir:

- feature flag gerekiyor mu?
- migration veya backfill var mi?
- support/ops playbook etkisi var mi?
- yeni telemetry gerekiyor mu?
- rollback yolu ne?

Kural:

Rollout etkisi unknown olan is ready sayilmaz; ozellikle billing, domain, publish ve import alanlarinda.

---

## 14. Risk sinifina gore ek hazirlik gereksinimleri

Tum isler ayni riskte degildir.

### 14.1. R1 - dusuk risk

Ornek:

- copy duzeltmesi
- internal non-critical label update

Beklenen:

- etkilenen surface net olsun
- basic acceptance belli olsun

### 14.2. R2 - orta risk

Ornek:

- creator list filter degisikligi
- non-billing settings paneli

Ek beklenti:

- state ve permission etkisi net
- test katmanlari secili

### 14.3. R3 - yuksek risk

Ornek:

- import behavior
- selected source mantigi
- publish flow
- custom domain behavior
- billing gating

Ek zorunluluk:

- ilgili source-of-truth belge referansi
- failure matrix
- telemetry ve rollback notu
- manual audit plani

### 14.4. R4 - kritik risk

Ornek:

- ownership transfer
- deletion workflow
- webhook/billing authority
- auth/session guvenligi

Ek zorunluluk:

- security/compliance etkisi
- ops signali
- explicit go/no-go kriteri

---

## 15. Ready checklist'i

Bir is paketi implementasyona alinmadan once asgari olarak su checklist gecilmelidir:

1. Problem tanimi tek cumlede net.
2. In-scope ve out-of-scope alanlar yazili.
3. Etkilenen actor'ler ve permission farklari yazili.
4. Happy path disi state'ler tanimli.
5. Veri/source-of-truth etkisi tanimli.
6. Test katmanlari secili.
7. Rollout/flag/migration etkisi not edilmis.
8. Gerekli belge referanslari eklenmis.

R3/R4 degisimlerde ek olarak:

9. Failure/edge-case maddeleri yazili.
10. Observability veya ops etkisi notlu.
11. Manual audit ihtiyaci secili.

---

## 16. Ready olmayan tipik durumlar

Asagidaki durumlar explicit olarak ready degildir:

1. ekran var ama hata/fallback davranisi yazilmamis
2. rol/permission etkisi belirsiz
3. public SEO/trust etkisi dusunulmemis
4. hangi test seviyesinde korunacagi secilmemis
5. async workflow ama expiry/retry davranisi tanimsiz
6. migration veya invalidation etkisi bilinmiyor
7. support/ops etkisi "bakariz" seviyesinde

---

## 17. Senaryo bazli ready ornekleri

### 17.1. Senaryo: Yeni blocked-domain yonetim paneli

Ready sayilmasi icin:

1. Ops actor modeli net
2. domain block'un import create ve refresh'e etkisi yazili
3. audit ve reason code gereksinimi tanimli
4. test stratejisi secili
5. rollout ile mevcut blocked source'lara etkisi acik

### 17.2. Senaryo: Public shelf kartinda stale price row redesign

Ready sayilmasi icin:

1. stale vs hidden-by-policy ayrimi net
2. a11y ve copy etkisi tanimli
3. public cache invalidation etkisi notlu
4. mobil web acceptance maddesi secili

### 17.3. Senaryo: Billing portal linki ekleme

Ready sayilmasi icin:

1. owner-only access net
2. provider error davranisi yazili
3. security ve abuse kontrolu notlu
4. release gating etkisi tanimli

---

## 18. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. "Kodlarken netlestiririz" diye riskli is baslatmak
2. Product ve design karari olmadan teknik slice acmak
3. Happy path cizimini ready sanmak
4. Import veya billing etkili ise support/ops etkisini yok saymak
5. Test seviyesi secmeden implementation'a girmek
6. Non-goal yazmadan scope'u acik birakmak

---

## 19. Bu belge sonraki belgelere ne emreder?

### 19.1. Definition of Done'a

- ready asamasinda secilen test, audit ve rollout kanitlari done asamasinda zorunlu kanita donusecek

### 19.2. Test strategy'ye

- risk sinifina gore test katmani secimi hizalanacak

### 19.3. Release readiness'e

- R3 ve R4 degisimlerin release sign-off zorunluluklari ayrik izlenecek

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin:

1. Backlog'a giren islerin "neden, kim icin, hangi sinirla" yapildigi netlesmis olmali.
2. Implementation baslamadan once actor, state, data, test ve rollout cizgisi hazir olmalı.
3. Riskli islerde dokuman ve acceptance eksigiyle koda atlama davranisi durdurulmali.
4. Ekip, "bu is ready mi?" sorusunu kisisel sezgiyle degil bu belgeyle cevaplayabiliyor olmali.
