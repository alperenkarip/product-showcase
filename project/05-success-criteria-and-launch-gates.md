---
id: SUCCESS-CRITERIA-LAUNCH-GATES-001
title: Success Criteria and Launch Gates
doc_type: launch_governance
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-SCOPE-NON-GOALS-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
blocks:
  - TEST-STRATEGY-PROJECT-LAYER
  - IMPORT-ACCURACY-TEST-MATRIX
  - RELEASE-READINESS-CHECKLIST
  - INTERNAL-TEST-PLAN
  - LAUNCH-TRANSITION-PLAN
---

# Success Criteria and Launch Gates

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun hangi kalite, urun, trust, import ve operasyon esiklerini gecmeden ic kullanimdan private kullanima, private kullanımdan da dis lansmana tasinamayacagini tanimlayan resmi launch governance belgesidir.

Bu belge su sorulara cevap verir:

- Basari bu urunde ne demektir?
- Hangi gate'ler vardir?
- Her gate icin hangi capability'ler zorunludur?
- Hangi kusurlar otomatik no-go sayilir?
- Hangi veriler veya testler launch kaniti olarak kabul edilir?
- Risk kabul nasil yazilir?
- Launch sonrasi ilk 30 gunde hangi sinyaller izlenir?

Bu belge olmadan genellikle su yanlislar olur:

- "ekranlar bitti" diye launch karari verilir
- import quality ikinci plana atilir
- trust/disclosure eksikleri "beta" diye gecistirilir
- ops ve support readiness launch kriteri sayilmaz

Bu belge, tam olarak bu gevsek launch mantigini engellemek icin vardir.

---

## 2. Bu belge neden kritiktir?

Bu urunde launch basarisi feature sayisi ile okunamaz.  
Cunku urunun en tehlikeli kusurlari gorunur teknik crash degil; sessiz kalite ve guven kusurlaridir.

Ornek:

- sistem calisir ama yanlis urun ceker
- page acilir ama stale fiyat guncelmis gibi gorunur
- creator publish eder ama disclosure kaybolur
- support issue'yu siniflayamaz
- ops repeated failure pattern'ini goremez

Bunlarin hicbiri "uygulama acilmiyor" gibi sert crash degildir.  
Ama urunun degerini ve guvenini daha hizli bozar.

Bu nedenle bu urun icin basari:

- creator velocity,
- viewer trust,
- import accuracy,
- public quality,
- operations readiness

birlikte calistiginda olusur.

Bu belge, bu bes ekseni tek launch rejiminde birlestirir.

---

## 3. Basari bu urunde tam olarak ne demektir?

Bu urunde basari, "bir seyler yayinda" demek degildir.

Basari su bileşimin birlikte calismasi demektir:

1. Creator hizli import ve publish yapabilmeli
2. Viewer context'i ve trust bilgisini net anlayabilmeli
3. Import zinciri desteklenen merchant setinde guvenilir calismali
4. Public web guven verici ve hizli olmali
5. Support ve ops sorun ciktiginda kor kalmamali

Bu maddelerden biri eksikse urun tam degildir.

---

## 4. Basari eksenleri

Bu belge basariyi bes ana eksen uzerinden olcer.

### 4.1. Creator Success

Sorular:

- Creator urunu saniyeler-dakikalar araliginda yayina alabiliyor mu?
- Ayni urunu tekrar girmeden kullanabiliyor mu?
- Unsupported merchant'ta cikissiz kalmiyor mu?

### 4.2. Viewer Success

Sorular:

- Viewer urunu baglamiyla anliyor mu?
- Trust/disclosure sinyalini okuyabiliyor mu?
- Public page mobilde yeterince hizli mi?

### 4.3. Import Success

Sorular:

- Desteklenen merchant setinde publish-edilebilir import cikisi uretilebiliyor mu?
- Duplicate kontrolu calisiyor mu?
- Verification ve correction yolları net mi?

### 4.4. Trust and Compliance Success

Sorular:

- Disclosure kaydi dogru mu?
- Disclosure UI'da gorunur mu?
- Stale/missing price davranisi acik mi?

### 4.5. Operations Success

Sorular:

- Issue tipleri ayirt edilebiliyor mu?
- Runbook ve support playbook'lari var mi?
- Repeated failure pattern'i izlenebiliyor mu?

---

## 5. Gate modelinin ana karari

Bu urun icin dort gate modeli kullanilir:

1. Gate A - Foundation Ready
2. Gate B - Import and Trust Ready
3. Gate C - Private Usage Ready
4. Gate D - External Launch Ready

Bu gate'ler kronolojik checklist degil; olgunluk seviyesidir.

Bir gate gecilmeden sonrakine gecmek kural olarak yasaktir.

Istisna ancak:

- yazili risk kabul,
- dar rollout,
- acik owner tayini,
- olcum plani

ile yapilabilir.

---

## 6. Gate A - Foundation Ready

### 6.1. Gate A'nin amaci

Bu gate, urunun cekirdek publishing omurgasinin calisir hale geldigini ve artik salt fikir veya wireframe asamasinda olmadigini kanitlar.

### 6.2. Gate A'nin zorunlu capability'leri

1. Creator account ve handle mantigi
2. Storefront primitive'i
3. Shelf / collection primitive'i
4. Content-linked page primitive'i
5. Product library kavrami
6. Product placement kavrami
7. Draft / publish / unpublish state mantigi

### 6.3. Gate A icin zorunlu actor kaniti

Creator Owner su akisi tamamlayabilmelidir:

1. hesap kurma
2. handle secme
3. ilk shelf veya content page olusturma
4. bir urun ekleyip draft veya publish etme

Viewer tarafinda asgari kanit:

- page tipi ve context farki anlaşılır olmalidir

### 6.4. Gate A icin zorunlu belge kaniti

Asgari olarak su belgeler accepted/ratified seviyesinde olmalidir:

- `00-project-charter.md`
- `01-product-vision-and-thesis.md`
- `02-product-scope-and-non-goals.md`
- `03-personas-jobs-and-primary-use-cases.md`
- `20-product-information-architecture.md`
- `21-page-types-and-publication-model.md`

### 6.5. Gate A bloklayici kusurlari

Su kusurlar Gate A'yi bloke eder:

- product ile placement farkinin sistemde belirsiz olmasi
- content-linked page'in "sonra eklenir" durumda olmasi
- publish state'lerinin belli olmamasi
- creator'in ilk urununu ekleme yolunun tamamen manuel forma dayanmasi

---

## 7. Gate B - Import and Trust Ready

### 7.1. Gate B'nin amaci

Bu gate, urunun asil teknik ve guven risklerinin artik kontrolsuz olmadigini kanitlar.

### 7.2. Gate B'nin zorunlu capability'leri

1. URL normalization
2. Safety / blocked-domain kontrolu
3. Merchant capability registry
4. Extraction strategy
5. Verification UI
6. Manual correction fallback
7. Duplicate / reuse kontrolu
8. Disclosure data modeli
9. Disclosure UI
10. Stale/missing price davranisi

### 7.3. Gate B icin actor bazli kanit

Creator Owner:

- desteklenen merchant URL'si ile publish yapabilmeli
- low-confidence durumda verification veya correction gormeli
- unsupported merchant'ta fallback gormeli

Viewer:

- trust/disclosure sinyalini net gorebilmeli
- stale price varsa ayirt edebilmeli

Ops:

- import issue tipini gorebilmeli

### 7.4. Gate B icin kalite kaniti

Bu gate, yalnizca "demo calisiyor" ile gecilemez.  
Asgari kalite kaniti sunlari icermelidir:

- merchant bazli sample import matrix'i
- wrong title / wrong image / wrong merchant senaryolarinin testleri
- duplicate ve canonical URL kurallarinin dogrulanmasi
- disclosure ve stale davranisinin UI walkthrough'u

### 7.5. Gate B bloklayici kusurlari

1. Desteklenen merchant setinde sik yanlis urun extraction'i
2. Verification olmadan publish'e izin veren kirik yol
3. Disclosure'un kaybolmasi veya inconsistent davranmasi
4. Stale price'in guncelmis gibi gorunmesi
5. Unsupported merchant'ta cikissiz hata

---

## 8. Gate C - Private Usage Ready

### 8.1. Gate C'nin amaci

Bu gate, urunun sinirli creator grubuyla gercek kullanimda denenebilecek olgunluga geldigini kanitlar.

### 8.2. Gate C'nin zorunlu capability'leri

1. Creator mobile ana akislari
2. Creator web tarafinda library ve page duzenleme
3. Public route / canonical model
4. Basic OG / share preview davranisi
5. Support playbook'lari
6. Runbook'lar
7. Import history ve issue classification gorunurlugu

### 8.3. Gate C icin actor bazli kanit

Creator Owner:

- birden fazla urun ekleyip farkli context'lerde reuse edebilmeli

Editor:

- owner olmayan rolde curation yapabilmeli

Viewer:

- mobilde urunleri context'iyle anlayabilmeli

Support:

- issue tiplerini ayirabilmeli

Ops:

- repeated import sorunlarini gorebilmeli

### 8.4. Gate C icin operasyon kaniti

Asgari operasyon kanitlari:

- ilk 5 support issue tipi icin standard response
- import failure spike runbook'u
- broken link veya stale issue triage yolu
- merchant capability tier inceleme yolu

### 8.5. Gate C bloklayici kusurlari

1. Pilot kullanimda duplicate product patlamasi
2. Support'un unsupported merchant ile parser issue'yu karistirmasi
3. Public sayfalarin mobilde guven vermeyecek kadar kotu olmasi
4. Ops'un failure pattern'ini gorememesi

---

## 9. Gate D - External Launch Ready

### 9.1. Gate D'nin amaci

Bu gate, urunun kontrollu dis kullanim veya ucretli deneme seviyesinde acilabilecek olgunluga geldigini kanitlar.

### 9.2. Gate D'nin zorunlu capability'leri

1. Net plan ve entitlement sinirlari
2. Privacy ve disclosure policy belgeleri
3. Takedown / abuse policy
4. Incident response yapisi
5. Release readiness checklist
6. Risk kabul ve rollback mantigi

### 9.3. Gate D actor bazli kanit

Creator:

- urunun vaat ettigi cekirdek degeri gercek kullanimda aliyor olmali

Viewer:

- publicte guvenilir ve hizli deneyim yasiyor olmali

Support/Ops:

- ilk 30 gun issue artisini yonetebilir durumda olmali

### 9.4. Gate D stratejik kanit

Asgari kanitlar:

- launch review notu
- no-go kusurlarinin kapandigina dair teyit
- risk kabul listesi
- first-30-days monitoring plani

### 9.5. Gate D bloklayici kusurlari

1. Plan ve hak limitlerinin urunde tutarsiz gorunmesi
2. Compliance ve disclosure politikasinin eksik olmasi
3. Incident response yolunun belirsiz kalmasi
4. Rollout siniri olmadan tam acilimin planlanmasi

---

## 10. Sayisal ve gozlemsel esikler

Bu belge tam SLA seti degildir.  
Ama go/no-go kararinda alt sinirlar tanimlar.

### 10.1. Import publishability esigi

Desteklenen merchant setinde publish-edilebilir import cikisi:

- hedef: en az `%85`

Bu ne demektir?

- her import'un kusursuz olmasi beklenmez
- ama varsayilan deneyim correction gerektirmeyen veya hafif correction ile publish edilebilir olmalidir

### 10.2. Kritik alan dogrulugu

Asgari olarak su alanlarda yuksek guven gerekir:

- title
- primary image
- merchant

Price alaninda kural farklidir:

- her zaman var olmak zorunda degildir
- ama varsa stale davranisi dogru olmalidir

### 10.3. Duplicate control esigi

Ayni canonical URL icin:

- kontrolsuz cift product olusumu kritik bug sayilir

### 10.4. Public performance esigi

Bu belgede spesifik milisaniye SLA baglanmaz; ama su karar baglanir:

- mobilde guven vermeyecek kadar yavas public page ile launch yapilmaz

### 10.5. Support readiness esigi

Support en az su issue tiplerinde standard response sahibi olmalidir:

- unsupported merchant
- wrong extraction
- duplicate confusion
- broken link
- stale or missing price

---

## 11. Otomatik no-go kusurlari

Asagidaki kusurlar launch'i otomatik bloke eder.

### 11.1. Wrong Product Critical

Durum:

- viewer veya creator acikca yanlis urune yonleniyor

Neden no-go:

- recommendation urununde temel guveni yok eder

### 11.2. Disclosure Loss

Durum:

- disclosure data'si kayboluyor ya da page tipleri arasinda inconsistency var

Neden no-go:

- trust ve compliance cekirdegini bozar

### 11.3. Stale Price Misrepresentation

Durum:

- stale veya bilinmeyen price guncelmis gibi gorunuyor

Neden no-go:

- viewer aldatilmis hisseder

### 11.4. Unsupported Merchant Dead End

Durum:

- creator fallback goremeden akistan dusuyor

Neden no-go:

- product vaadi olan hizli publish coker

### 11.5. Invisible Failure

Durum:

- import issue'lari ops/support tarafinda issue tipi bazli gorunmuyor

Neden no-go:

- urun isletilemez hale gelir

### 11.6. Route / Canonical Breakage

Durum:

- public URL'ler veya canonical davranis bozuk

Neden no-go:

- public-web-first tezine aykiridir

---

## 12. Risk kabul rejimi

Her kusur launch'i otomatik bloke etmez.  
Ama bloklamayan kusurlar icin bile yazili risk kabul gerekir.

### 12.1. Risk kabulunde bulunmasi gerekenler

1. Kusurun tanimi
2. Etkilenen actor
3. Etki seviyesi
4. Olasilik seviyesi
5. Neden launch once degil sonra cozuldugu
6. Gecici koruma mekanizmasi
7. Hangi metrik izlenecek
8. Hangi tarihte tekrar gozden gecirilecek

### 12.2. Risk kabulunun yapamayacagi seyler

Risk kabul:

- disclosure kaybini mesrulastiramaz
- wrong product issue'sunu "beta" diye gecistiremez
- unsupported merchant dead-end'i tolere edemez
- ops gorunurluk eksigini yok sayamaz

### 12.3. Risk kabul owner'ligi

Her risk kabul notu icin owner acik olmalidir:

- product
- engineering
- operations

birinden biri net sahip olmalidir.

---

## 13. Rollout stratejisiyle iliskisi

Gate'lerin gecilmesi tek tip rollout anlamina gelmez.  
Bu belgede rollout asamalari da launch kararinin parcasi kabul edilir.

### 13.1. Internal Only

Yalnizca ekip ici kullanim.  
Ama Gate A ve belirli Gate B koşullari gerekir.

### 13.2. Pilot Creator Group

Sinirli creator grubu.  
Gate C seviyesinde readiness gerekir.

### 13.3. Controlled External Launch

Sinirli ama publice acik davet / kullanim.  
Gate D ve dar rollout planı gerekir.

### 13.4. Wider Rollout

Daha genis acilim.  
Ilk 30 gun sinyalleri olumlu olmadan yapilmamasi gerekir.

---

## 14. Launch sonrasi ilk 30 gun izleme alani

Ilk 30 gunde su sinyaller gunluk veya planli olarak izlenir:

1. merchant bazli import failure dagilimi
2. manual correction orani
3. duplicate issue orani
4. broken link issue sayisi
5. stale / missing price issue dagilimi
6. support issue kategori dagilimi
7. public page performans regressions
8. content page vs storefront giris davranisi

Bu sinyallerde ciddi bozulma varsa:

- rollout daraltilir
- yeni creator alimi yavaslatilir
- belirli merchant'lar downgrade edilir
- gerekirse launch geri cekilir

---

## 15. Actor bazli gate haritasi

Bu belgeye gore gate ilerlemesi actor bazli su sekilde okunur:

### 15.1. Creator Owner

- Gate A: ilk publish
- Gate B: import + trust
- Gate C: tekrarli kullanim ve reuse
- Gate D: plan / rollout tutarliligi

### 15.2. Viewer

- Gate A: page tipi anlasilirligi
- Gate B: trust sinyali
- Gate C: mobil kalite
- Gate D: public launch kalitesi

### 15.3. Editor

- Gate C ile anlamli hale gelir

### 15.4. Ops / Support

- Gate B'den itibaren zorunludur
- Gate C'de aktif readiness aranir
- Gate D'de production-like davranis beklenir

---

## 16. Hangi belgeler launch kaniti uretir?

Bu belge tek basina launch karari vermez.  
Asagidaki belge aileleri launch kaniti uretir:

- `project/product/20-28` -> urun davranisi ve actor deneyimi
- `project/import/40-48` -> import quality ve fallback davranisi
- `project/design/52-58` -> state ve surface kalite davranisi
- `project/quality/82-88` -> test ve acceptance evidence
- `project/compliance/90-94` -> trust, disclosure ve policy coverage
- `project/operations/100-104` -> runbook, support, restore ve incident readiness

Bu ailelerden kanit gelmeyen alan "hazir" sayilmaz.

---

## 17. Go / No-Go toplantisinda sorulacak zorunlu sorular

Launch karari verilmeden once su sorular tek tek cevaplanmalidir:

1. Creator desteklenen merchant setinde urunu guvenle yayina alabiliyor mu?
2. Ayni urunu tekrar kullanirken duplicate yerine reuse gorebiliyor mu?
3. Viewer urunu baglamiyla ve trust sinyaliyle anlayabiliyor mu?
4. Public page mobilde guven verici mi?
5. Unsupported merchant senaryosunda fallback var mi?
6. Support en sik issue tiplerine hazir mi?
7. Ops repeated failure pattern'lerini gorebiliyor mu?
8. Bilinen no-go kusuru var mi?

Bu sorulardan biri icin net "hayir" varsa varsayilan karar no-go'dur.

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `82-test-strategy-project-layer.md` test onceligini actor ve gate bazli kurgulamalidir
2. `83-import-accuracy-test-matrix.md` Gate B kaniti uretmek zorundadir
3. `88-release-readiness-checklist.md` bu belgedeki no-go kusurlarini checklist'e cevirmelidir
4. `101-runbooks.md` Gate C ve D operasyon readiness kaniti uretmelidir
5. `114-internal-test-plan.md` gate gecislerini dogrulayan test oturumlari planlamalidir
6. `115-launch-transition-plan.md` rollout kademelerini bu gate modeline baglamalidir

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- launch karari feature tamamlanmasi degil kanit ve risk rejimi uzerinden veriliyorsa
- import ve trust problemleri launch gate'lerinde merkezi yer tutuyorsa
- support ve ops readiness launch once zorunlu kabul ediliyorsa
- no-go kusurlari tartismasiz hale geliyorsa

Bu belge basarisiz sayilir, eger:

- "MVP cikalim sonra duzeltiriz" mantigi tekrar kapı buluyorsa
- viewer trust veya import accuracy ikincil gibi yorumlaniyorsa
- support ve ops readiness checklist dipnotu gibi kaliyorsa

Bu nedenle bu belge, projenin bitip bitmedigini degil; hangi kalite seviyesinde acilabilecegini tanimlayan ana karar katmanidir.
