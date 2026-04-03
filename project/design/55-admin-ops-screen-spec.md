---
id: ADMIN-OPS-SCREEN-SPEC-001
title: Admin and Ops Screen Spec
doc_type: internal_ops_design
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - RISK-REGISTER-001
  - MERCHANT-CAPABILITY-REGISTRY-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
blocks:
  - RUNBOOKS
  - SUPPORT-PLAYBOOKS
  - WEB-SURFACE-ARCHITECTURE
---

# Admin and Ops Screen Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` ic ekip yuzeylerinde kullanilacak import jobs dashboard, job detail, merchant registry, stale/broken source queue, unsafe link review ve support lookup console ekranlarinin bilgi yogunlugunu, utility-first layout kurallarini, auditli aksiyon modellerini ve support/ops ihtiyaclarinin creator yuzeylerinden nasil ayristigini tanimlayan resmi internal tooling design spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Ops ekranlari neden creator panelinin gizli varyanti gibi tasarlanamaz?
- Tekil import vakasi nasil okunur?
- Registry edit, retry ve kill-switch aksiyonlari hangi onay katmanlariyla gosterilir?
- Support lookup ekraninda ne gorunur, ne gorunmez?
- Internal yuzeylerde hangi bilgi yoğunlugu kabul edilir?

Bu belge, ic araclarin "guzel degilse olur" mantigiyla ihmal edilmesini engeller.

---

## 2. Bu belge neden kritiktir?

Import ve trust riskleri bu urunde ops kabiliyetiyle dogrudan baglidir.

Yanlis ops tasarimi su sorunlari dogurur:

- ayni vaka icin birden fazla log sistemine bakmak gerekir
- retry ve block aksiyonlari yanlis elde verilir
- support teknik jargonla creator'e doner
- registry, runbook ve job detail birbirinden kopar

Ops ekranlari brand hero tasimak zorunda degil; ama karar netligi ve denetlenebilirlik tasimak zorundadir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Admin/ops yuzeyleri utility-first, dense ve audit-aware tasarlanir; her kritik ic ekran, "ne oldu / neden oldu / simdi ne yapmaliyiz / bu kullanıcıya ne denmeli" sorularini tek gorunumde cevaplamaya calisir; destructive veya policy etkili aksiyonlar açik onay ve reason-code ile sunulur.

Bu karar su sonuclari dogurur:

1. Internal ekranlar public template dili tasimaz.
2. Retry, block ve tier degisikligi gibi aksiyonlar kolay ama izsiz olmaz.
3. Support lookup, owner/editor permission sinirlarini asacak sekilde tasarlanmaz.

---

## 4. Internal design ilkeleri

### 4.1. Density over decoration

Ops ekranlari daha yogun olabilir.  
Ama bu yogunluk anlamsiz tablo kalabaligi degil, karar netligi uretmelidir.

### 4.2. Single-case diagnosability

Tek bir import vakesi icin:

- stage
- failure code
- registry state
- recovery oneri

ayni yerde okunabilmelidir.

### 4.3. Audit-aware interaction

Policy veya data-mutating aksiyonlar:

- plain icon click ile sessizce tamamlanmaz
- onay ve reason ister

### 4.4. Role-bounded support

Support'e gosterilen araçlar, ops/admin break-glass gücünü taklit etmez.

---

## 5. Layout aileleri

Ops yuzeylerde üç ana layout kullanilir:

1. queue/list dashboard
2. detail inspector
3. policy editor / registry table

### 5.1. Queue/list dashboard

Sayi, trend ve filtered queue okumasi icin.

### 5.2. Detail inspector

Tekil import veya source vakasini incelemek icin.

### 5.3. Policy editor

Merchant registry ve kill-switch gibi karar alanlari icin.

---

## 6. Screen family 1: Import jobs dashboard

## 6.1. Amac

Import sagligini ve failure pattern'larini top-level okumak.

## 6.2. Asgari bolumler

1. status bazli queue dagilimi
2. merchant bazli failure cluster
3. recent systemic alerts
4. quick filters

## 6.3. Zorunlu filtreler

- status
- merchant
- failure code family
- time window
- tier

## 6.4. Kural

Dashboard sadece toplam sayı gosteren yüzey olmaz; operator'u sonraki aksiyona indirecek drill-down girisleri saglamalidir.

---

## 7. Screen family 2: Import job detail

## 7.1. Amac

Tekil vaka tanilama.

## 7.2. Asgari alanlar

1. submitted / normalized / canonical URL
2. actor ve workspace baglami
3. registry tier
4. stage timeline
5. extraction path
6. failure code veya review outcome
7. creator-facing recommended response

## 7.3. Action rail

Duruma gore:

- retry
- mark for review
- open registry
- open support note
- block host

### 7.4. Kural

Destructive/policy etkili aksiyonlar reason-code istemelidir.

---

## 8. Screen family 3: Merchant registry console

## 8.1. Amac

Tier, headless gereksinimi, kill-switch ve review tarihini yonetmek.

## 8.2. Layout

- searchable table
- detail side panel
- audit history section

## 8.3. Asgari alanlar

- merchant key
- host pattern
- tier
- requires headless
- expected confidence notes
- kill-switch state
- last reviewed at

### 8.4. Kural

Tier degisikligi "dropdown'dan sec bitti" seklinde tasarlanmaz; etkisi ve nedeni görünür olur.

---

## 9. Screen family 4: Stale / broken source queue

## 9.1. Amac

Trust riskine donusen refresh sorunlarini takip etmek.

## 9.2. Asgari alanlar

- source merchant
- selected/public usage durumu
- stale age
- current display state
- next action

## 9.3. Kural

Bu ekran yalniz teknik refresh failure listesi degil; public trust etkisini de gosterir.

---

## 10. Screen family 5: Unsafe link / abuse review

## 10.1. Amac

Unsafe redirect, blocked host ve abuse paternlerini yonetmek.

## 10.2. Asgari alanlar

- host/url summary
- trigger reason
- scope of impact
- current block state
- recommended runbook

## 10.3. Kural

Policy aksiyonlari plain retry butonlariyla ayni görsel öncelikte sunulmaz.

---

## 11. Screen family 6: Support lookup console

## 11.1. Amac

Support agent'in creator vakasini anlamasi.

## 11.2. Asgari alanlar

- creator workspace summary
- recent imports
- active failure/review states
- suggested response categories

## 11.3. Kural

Support:

- kritik owner-level mutasyon butonlari gormez
- gizli impersonation araci kullanmaz

---

## 12. Table ve detail davranis ilkeleri

### 12.1. Tables

Ops table'lari:

- sticky headers
- dense satirlar
- hızlı filtre
- export veya kopyalama yardimlari

tasiyabilir.

### 12.2. Detail views

Detail view:

- chronological timeline
- summary first
- raw-ish ama okunur data blocks

tasir.

### 12.3. Raw data siniri

Raw payload gerekiyorsa gösterilebilir.  
Ama secrets, cookie ve gereksiz PII maskeleme zorunludur.

---

## 13. Action confirmation ve audit notlari

Asagidaki aksiyonlar explicit confirmation ister:

- force retry
- kill switch ac/kapat
- tier demotion/promotion
- blocked host karari

Confirmation paneli asgari olarak sunlari gosterir:

- ne degisecek?
- kimi etkileyecek?
- neden yapiliyorsun?

---

## 14. Senaryolar

## 14.1. Senaryo A: Merchant'ta failure spike

Beklenen deneyim:

- dashboard spike'i gosterir
- bir tikla job detayina ve registry'ye gidilir

## 14.2. Senaryo B: Creator "neden import olmadi?" dedi

Beklenen deneyim:

- support lookup console failure code ve recommended response'u gosterir

## 14.3. Senaryo C: Kill switch gerekiyor

Beklenen deneyim:

- registry detail'den policy aksiyonu verilir
- reason-code zorunludur

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Ops ekranlarini creator panelinin gizli sekmesi gibi yapmak
2. Failure tani icin operator'u uc farkli araca gondermek
3. Retry, block ve tier aksiyonlarini izsiz hale getirmek
4. Support'e owner gibi davranan gizli mutasyon butonlari vermek
5. Policy ekranlarinda etkilenim alanini gostermemek

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `101-runbooks.md`, internal ekranlardan tetiklenecek standart ilk-15-dakika aksiyonlarini bu screen family'leriyle uyumlu yazmalidir.
2. `103-support-playbooks.md`, support lookup console'da gorunen failure categories ile ayni dili kullanmalidir.
3. `61-web-surface-architecture.md`, internal route ailelerini creator/public route'larindan net sekilde ayirmalidir.

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ops tek bir import veya merchant sorununu hizla tani koyabiliyorsa
- support kullaniciya ne denecegini ek arac gerektirmeden anlayabiliyorsa
- policy etkili aksiyonlar auditli ve kontrollu sekilde sunuluyorsa

Bu belge basarisiz sayilir, eger:

- ic ekranlar rastgele admin panel toplamina donusurse
- support ve ops ayni vakayi farkli dillerle yorumluyorsa
- block/retry/tier aksiyonlari fazla kolay ama izsiz hale gelirse

