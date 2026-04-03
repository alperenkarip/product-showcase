---
id: INTERNAL-TEST-PLAN-001
title: Internal Test Plan
doc_type: validation_program
status: ratified
version: 2.0.0
owner: product-quality
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-ROADMAP-001
  - FEATURE-SEQUENCING-DEPENDENCY-ORDER-001
  - INITIAL-SEED-CONTENT-DEMO-DATA-PLAN-001
  - TEST-STRATEGY-PROJECT-LAYER-001
  - IMPORT-ACCURACY-TEST-MATRIX-001
  - CROSS-PLATFORM-ACCEPTANCE-CHECKLIST-001
blocks:
  - LAUNCH-TRANSITION-PLAN
---

# Internal Test Plan

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun ekip ici dogfood, senaryo bazli acceptance, import quality sweep, support/ops dry run ve kapali rollout oncesi davranis kaniti uretmek icin izleyecegi ic test programini tanimlayan resmi validation planidir.

Bu belge su sorulara cevap verir:

- ic test ne zaman baslar?
- kimler hangi cohort'ta urunu kullanir?
- hangi senaryolar zorunlu olarak denenir?
- hangi veri seti kullanilir?
- bulgular nasil kayda alinip release kararina beslenir?
- hangi bulgu rollout'u durdurur?

Bu belge "biraz ekip ici deneyelim" notu degildir.  
Bu belge, launch oncesi davranis kaniti ureten sistematik test rejimidir.

---

## 2. Bu belge neden kritiktir?

Bu urun, belge ve unit testlerle tam dogrulanamaz.  
Ozellikle su alanlar gercek kullanima yakin ic test gerektirir:

1. link paste -> verify -> publish hiz hissi
2. mobile/web gecis davranisi
3. stale/disclosure/public trust yorumu
4. support ve ops issue family okunabilirligi
5. unsupported veya partial merchant davranislari

Ic test plansiz kalirsa:

1. ekip sadece en sevdigi ideal akisi dener
2. sorunlar support ticket gelmeden gorunmez
3. rollout oncesi kalite algisi subjektif kalir
4. import accuracy matrix'i kagit uzerinde kalir

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` ic test fazi yalniz UI kontrolu degil; seed veri setiyle beslenen, persona ve capability bazli cohort'lara ayrilan, gunluk kullanimi taklit eden, import dogrulugu, public trust, supportability ve rollout readiness ureten zaman kutulu bir validation programi olarak yurutulecektir; ic testten cikan bulgular backlog'a severity ve capability bagiyla geri donmeden faz kapanmayacaktir.

Bu karar su sonuclari dogurur:

1. Ic testte bulunan sorunlar "genel not" olarak kaybolmaz.
2. Her bulgu capability owner'ina geri baglanir.
3. Support ve ops dry run ic testin zorunlu parcasi olur.
4. Launch transition yalniz bu test programi kanit urettiyse acilir.

---

## 4. Ic testin amaci

Bu programin amaci:

1. cekirdek creator loop'unu gercekci sekilde sinamak
2. import quality ve trust davranisini gercek merchant karmasiyla gormek
3. support ve ops sinyallerinin okunabilir oldugunu kanitlamak
4. rollout oncesi stop condition'lari canli data olmadan once yakalamak

Bu programin amaci olmayanlar:

1. public acquisition deneyleri
2. buyuk hacimli load test
3. sonuclar guzel gorunsun diye edge-case gizlemek

---

## 5. Katilim cohort'lari

Ic test bes cohort ile yurur:

1. core product cohort
2. creator-simulator cohort
3. design/content cohort
4. support/ops cohort
5. leadership sign-off cohort

### 5.1. Core product cohort

Kimler:

- product
- backend
- frontend
- mobile

Amaç:

- capability sahibi ekiplerin gercek loop'u kendi elleriyle kullanmasi

### 5.2. Creator-simulator cohort

Kimler:

- urunu her gun kullanmayan ic ekip uyeleri
- gerekiyorsa secilmis guvenilir ic pilot kullanicilar

Amaç:

- system knowledge olmadan creator deneyimi sinamak

### 5.3. Design/content cohort

Amaç:

- copy, disclosure, empty/error state ve public algi testleri

### 5.4. Support/ops cohort

Amaç:

- issue family'lerin okunabilirligi
- runbook ve support playbook dry run

### 5.5. Leadership sign-off cohort

Amaç:

- release evidence'i ozet seviyede gorup go/no-go icin karar olgunlugu saglamak

---

## 6. On kosullar

Ic test baslamadan once asgari su kosullar saglanir:

1. `113-initial-seed-content-and-demo-data-plan.md` icindeki seed veri seti yuklenmis olur
2. launch-kritik capability'lerin internal test oncesi kapanis seti tamamlanmis olur
3. staging veya staging-benzeri ortam hazir olur
4. support ve ops panelleri minimum okunabilirlikte aktif olur
5. bulgu kayit semasi tanimlanir

Ic test baslatilmaz:

1. import sonucu generic hata ise
2. public trust state'leri data modelinde yoksa
3. support issue family'leri tooling'de temsil edilmiyorsa

---

## 7. Program yapisi

Ic test dort dalga halinde ilerler:

1. baseline dogfood
2. scenario deep-dive
3. support/ops dry run
4. stabilization retest

### 7.1. Dalga 1: baseline dogfood

Amaç:

- ana loop'un calisabildigini hizlica gormek

Zorunlu senaryolar:

1. link paste -> verify -> publish
2. page/shelf'e product ekleme
3. publicte sonucu gorme

### 7.2. Dalga 2: scenario deep-dive

Amaç:

- edge-case ve trust senaryolarini sistematik test etmek

Zorunlu senaryolar:

1. duplicate candidate
2. wrong image correction
3. stale price state
4. blocked link
5. archived/unpublished/removed page

### 7.3. Dalga 3: support/ops dry run

Amaç:

- support, runbook ve incident readiness'i gercek issue aileleriyle denemek

### 7.4. Dalga 4: stabilization retest

Amaç:

- oncelikli bulgular kapandiktan sonra regression kontrolu yapmak

---

## 8. Test sure ve ritim modeli

Asgari ic test ritmi:

1. her gun cohort bazli test slot'u
2. gun sonu bulgu triage oturumu
3. haftalik kalite ozet raporu

Program su sekilde akar:

- gun ici kullanim ve not toplama
- gun sonu severity atama
- ertesi gun fix/regression retest

Kural:

Bulgu triage'i birikerek haftanin sonuna birakilmaz.

---

## 9. Senaryo aileleri

Ic test asgari on senaryo ailesini kapsar:

1. onboarding ve auth
2. workspace/storefront kurulumu
3. import happy path
4. import ambiguity ve correction
5. reuse/duplicate
6. creator page composition
7. public trust and disclosure
8. policy and abuse
9. support and ops handling
10. billing ve ownership edge-case'leri, eger rollout kapsamindaysa

---

## 10. Senaryo 1: Onboarding ve auth

Zorunlu adimlar:

1. owner login
2. workspace secimi veya ilk kurulum
3. editor erisim kontrolu
4. logout/session restore

Beklenen sistem davranisi:

- owner/editor farki net
- session kaybi yaratmayan redirect zinciri
- mobile ve web auth dili tutarli

---

## 11. Senaryo 2: Import happy path

Zorunlu adimlar:

1. supported merchant URL paste
2. verification screen kontrolu
3. product apply
4. page'e ekleme
5. publish
6. public gorunum

Beklenen davranis:

- kritik alanlar creator'u gereksiz surtundurmadan dolar
- product dogru placement ile görünur
- publicte disclosure/trust row beklenen sekildedir

---

## 12. Senaryo 3: Import ambiguity ve correction

Zorunlu varyasyonlar:

1. wrong image candidate
2. missing price
3. variant conflict
4. `partial` tier merchant

Beklenen davranis:

- creator review ekraninda kaybolmaz
- correction sonucu kalici olur
- support issue'ya donusecek state okunabilir kalir

---

## 13. Senaryo 4: Reuse ve duplicate

Zorunlu adimlar:

1. ayni urunun farkli URL ile yeniden eklenmesi
2. duplicate adayin library icinde fark edilmesi
3. reuse veya yeni record kararinin izlenmesi

Beklenen davranis:

- duplicate enflasyonu olusmaz
- reuse karari page ve shelf baglamini bozmaz

---

## 14. Senaryo 5: Creator page composition

Zorunlu adimlar:

1. bir shelf olusturmak
2. product sira degistirmek
3. page'e aciklama eklemek
4. publish/unpublish yapmak

Beklenen davranis:

- mobile ve web arasi state kaybi olmaz
- bulk veya tekil duzenleme public truth'u bozmaz

---

## 15. Senaryo 6: Public trust ve disclosure

Zorunlu varyasyonlar:

1. affiliate disclosure
2. gifted disclosure
3. stale price warning
4. hidden price state
5. broken veya blocked link davranisi

Beklenen davranis:

- viewer neyin guncel, neyin belirsiz oldugunu anlar
- disclosure yokmus gibi bir his olusmaz
- link tiklama davranisi policy ile uyumludur

---

## 16. Senaryo 7: Policy ve abuse

Zorunlu varyasyonlar:

1. blocked domain girisi
2. removed-by-policy page
3. abuse report olusturma

Beklenen davranis:

- creator'a neden aciklanir
- support issue family dogru secilir
- compliance escalation zinciri nettir

---

## 17. Senaryo 8: Support ve ops dry run

Zorunlu issue aileleri:

1. `IMPORT_NOT_FETCHED`
2. `WRONG_IMAGE`
3. `PRICE_MISSING_OR_STALE`
4. `BROKEN_OR_BLOCKED_LINK`
5. `DUPLICATE_PRODUCT`
6. `PAGE_UNPUBLISHED_OR_REMOVED`
7. `OWNERSHIP_OR_BILLING`
8. `UNSAFE_OR_ABUSIVE_CONTENT`

Dry run adimlari:

1. ticket veya rapor kaydi ac
2. support summary oku
3. gerekli escalation zincirini uygula
4. ops dashboard ve runbook dogrulamasini yap

Beklenen davranis:

- support issue family'yi net secerek ilerler
- ops, semptomu dashboard ve runbook ile esleyebilir
- generic "bize bir ekran gorunuyor" seviyesi kalmaz

---

## 18. Senaryo 9: Billing ve ownership edge-case

Bu senaryo yalniz rollout kapsami ucretli capability veya team owner state'i iceriyorsa zorunludur.

Zorunlu varyasyonlar:

1. checkout bridge pending
2. authoritative entitlement acilisi
3. owner/editor capability farki
4. ownership recovery support vakasi

Beklenen davranis:

- access erken acilmaz
- support ownership truth'unu yanlis anlatmaz

---

## 19. Bulgularin kaydi

Her bulgu asgari su alanlarla kaydedilir:

1. bulgu kimligi
2. tarih ve cohort
3. etkilenen capability
4. surface
5. severity
6. tekrar adimi
7. beklenen davranis
8. gozlenen davranis
9. owner
10. retest sonucu

Kural:

"Ufak bug" notu severity ve capability baglantisi olmadan kayda giremez.

---

## 20. Severity modeli

Ic test bulgulari dort seviyede siniflanir:

1. `S1-launch-blocker`
2. `S2-major`
3. `S3-medium`
4. `S4-minor`

### 20.1. `S1-launch-blocker`

Ornek:

- import sonucunun guvenilmez olmasi
- public trust/disclosure yanlisligi
- ownership/billing truth bozulmasi
- support veya ops'in issue'yu okuyamamasi

### 20.2. `S2-major`

Ornek:

- kritik creator loop'ta tekrarli surtunme
- mobile/web state kaybi
- public performans veya metadata sorunu

### 20.3. `S3-medium`

Ornek:

- copy ve layout kaynakli ama geri donuslu sorunlar

### 20.4. `S4-minor`

Ornek:

- polish eksigi
- anlami bozmayan gorsel detay

---

## 21. Gunluk triage disiplini

Gun sonu triage'da:

1. yeni bulgular capability owner'ina atanir
2. ayni kok nedene bagli bulgular gruplanir
3. retest bekleyenler ayrilir
4. rollout ve launch etkisi olanlar isaretlenir

Kural:

Ic test bulgusu backlog disina "slack notu" olarak birakilmaz.

---

## 22. Ölculer ve kanit seti

Ic test boyunca asgari su sinyaller izlenir:

1. import success/failure dagilimi
2. review-required oranı
3. wrong-image ve stale-price bulgu sayisi
4. publish -> public gorunum gecikmesi
5. support issue family dagilimi
6. public trust/disclosure bug sayisi

### 22.1. Sayisal sinirlar

Sayisal threshold'larin source of truth'u:

- `83-import-accuracy-test-matrix.md`
- `84-cross-platform-acceptance-checklist.md`
- `85-performance-budgets.md`
- `88-release-readiness-checklist.md`

Bu belge threshold'lari tekrar tanimlamaz; ic testte nasil kullanilacagini baglar.

---

## 23. Stop kosullari

Ic test asamasinda asagidaki durumlar programi durdurur veya geriye iter:

1. `S1-launch-blocker` bulgu aciksa
2. ayni capability'de tekrar eden `S2-major` kumesi varsa
3. import kalite trendi kabul bandinin disina ciktiysa
4. support/ops dry run issue ailelerini okuyamiyorsa
5. stale/disclosure/public trust problemi tekrarliyorsa

Kural:

"Daha sonra bakariz" notuyla internal test fazi kapanmaz.

---

## 24. Retest kurallari

Her `S1` ve `S2` bulgu icin:

1. fix sonrasinda ayni senaryo tekrar kosulur
2. ilgili komsu senaryo da smoke edilir
3. regression riski olan capability ailesi isaretlenir

Ornek:

- wrong image fix'i sadece o merchant'ta degil, benzer partial/full merchant setinde de kontrol edilir

---

## 25. Support/ops dry run kurallari

Bu kisim yalnizca "ekranlar aciliyor mu?" testi degildir.

Zorunlu beklentiler:

1. support issue'yu family bazli siniflar
2. support, creator'a neden/ne yapabiliriz/biz ne yapiyoruz ayrimini kurar
3. ops ilgili metric ve runbook zincirini bulur
4. escalation gerektiren issue'lar dogru role gider

---

## 26. Ic test ciktilari

Program sonunda asgari su ciktilar uretir:

1. capability bazli bulgu listesi
2. fix ve retest ozet raporu
3. import quality sweep sonucu
4. support/ops dry run raporu
5. launch transition icin tavsiye notu

---

## 27. Ic testin bitti sayilma kosullari

Ic test ancak su durumda kapanir:

1. acik `S1-launch-blocker` yoksa
2. `S2-major` bulgular rollout'u tehdit etmeyecek seviyeye inmisse
3. import quality trendi kabul bandina girmisse
4. support ve ops dry run kabul seviyesindeyse
5. release evidence paketine girecek bulgular ve kararlar netlesmisse

---

## 28. Anti-pattern'ler

Asagidaki davranislar bu belgeye aykiridir:

1. ayni ekip uyelerinin ayni ideal akisi tekrar tekrar denemesi
2. seed veri yerine elle guzel gorunen data ile test yapmak
3. support/ops dry run'i "vakit kalirsa" seviyesine indirmek
4. bulgulari capability owner'ina baglamamak
5. retest yapmadan internal test fazini kapatmak

---

## 29. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ic test fazi:

1. urunun gunluk kullanim gercegini temsil etmeli
2. import/public trust/supportability sorunlarini rollout oncesi gorunur kilmali
3. launch transition kararini subjektif degil kanitli hale getirmelidir

---

## 30. Sonraki belgelere emirler

Bu belge asagidaki belge icin baglayicidir:

1. `115-launch-transition-plan.md`, cohort genisletme ve genel acilis kararlarini bu ic test programindan cikan kanitlar olmadan veremez.
