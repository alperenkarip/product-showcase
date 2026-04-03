---
id: RISK-REGISTER-001
title: Risk Register
doc_type: risk_governance
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - SUCCESS-CRITERIA-LAUNCH-GATES-001
  - MARKET-LANDSCAPE-COMPETITOR-MAP-001
  - PROBLEM-VALIDATION-FRICTION-MAP-001
blocks:
  - URL-IMPORT-PIPELINE-SPEC
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER
  - RUNBOOKS
  - INCIDENT-RESPONSE-PROJECT-LAYER
---

# Risk Register

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun teknik, urunsel, operasyonel, compliance, guven ve büyüme risklerini resmi olarak kayda alan; bu risklerin nasil fark edilecegini, nasil sahiplenilecegini, hangi countermeasure'lerin zorunlu oldugunu ve hangi risklerin launch once bloke edici sayildigini tanimlayan ana risk yonetim belgesidir.

Bu belge su sorulara cevap verir:

- Bu urunun en kritik riskleri nelerdir?
- Hangi riskler teknik, hangileri urun kimligi riski sayilir?
- Her risk hangi erken sinyallerle kendini gösterir?
- Hangi owner bu riski tasir?
- Hangi risk launch once kapanmali, hangisi kontrollu rollout ile tolere edilebilir?

Bu belge, "ileride bakariz" risk listesini degil; aktif yönlendirici risk rejimini tanimlar.

---

## 2. Bu belge neden kritiktir?

Bu urunde bazi riskler acik ve kolay gorunur:

- worker crash
- timeout
- broken build

Ama bazi riskler daha tehlikelidir cunku calisiyor gorunurken urunu bozar:

- wrong extraction
- stale price misrepresentation
- disclosure inconsistency
- duplicate birikimi
- platform klonu gibi algilanma

Bu ikinci grup riskler, salt engineering backlog maddesi olarak ele alinamaz.  
Urun kimligini, trust'i ve launch kalitesini bozar.

Bu nedenle bu belge sunu zorunlu kilar:

> Her kritik riskin bir adı, bir owner'ı, bir erken uyarı sinyali ve bir cevap mekanizması olmalıdır.

---

## 3. Risk yonetiminin ana ilkeleri

### 3.1. Owner'siz risk, yonetilmeyen risktir

Her riskin net owner'i olmali:

- product
- engineering
- import
- ops
- support
- compliance

rollerinden biri veya bir ortak sahiplik modeli.

### 3.2. Risk, sinyal olmadan izlenemez

"Bu risk var" demek yetmez.  
Hangi sinyalin bu riskin buyudugunu gosterdigi yazilmalidir.

### 3.3. Riskin launch etkisi acik olmalidir

Her risk icin su belirtilir:

- Gate A etkisi var mi?
- Gate B'yi bloke eder mi?
- Gate C veya D'de no-go sebebi olur mu?

### 3.4. Riskler sessizce kapanmis sayilmaz

Riskin durumu su sekilde yorumlanir:

- `open`
- `mitigating`
- `accepted-with-guardrails`
- `blocked-for-launch`
- `closed`

---

## 4. Risk siniflari

Bu urun icin riskler alti ana sinifa ayrilir:

1. Import ve data accuracy riskleri
2. Trust ve compliance riskleri
3. Scope ve positioning riskleri
4. Public quality ve performance riskleri
5. Operations ve support riskleri
6. Adoption ve retention riskleri

Bu siniflar birbirinden bagimsiz degildir.  
Ornek olarak wrong extraction hem import riski, hem trust riski, hem support riski yaratir.

---

## 5. Risk onceliklendirme modeli

Bu belge her risk icin su boyutlari kullanir:

1. **Olasilik**
2. **Etki**
3. **Guven etkisi**
4. **Launch etkisi**

Yorumlama:

- `Critical`: launch once kapanmali veya rollout çok dar tutulmali
- `High`: ciddi guardrail gerekir, launch kararinda acik not edilir
- `Medium`: owner takip eder, private usage'da test edilir
- `Low`: izlenir ama roadmap'i belirlemez

---

## 6. Risk kayit tablosu

| ID | Risk | Sinif | Olasilik | Etki | Seviye | Ilk owner | Launch etkisi |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | Wrong extraction / wrong product | Import | Yuksek | Cok yuksek | Critical | Import + Product | Gate B/D blocker |
| R-02 | Duplicate product birikimi | Import / Product | Orta-Yuksek | Yuksek | High | Product + Engineering | Gate B/C blocker |
| R-03 | Positioning'in "better storefront" seviyesine dusmesi | Strategy | Orta | Yuksek | High | Product | Scope/roadmap drift |
| R-04 | Checkout / analytics scope drift | Strategy | Orta | Yuksek | High | Product | Roadmap blocker |
| R-05 | Public web performance zayifligi | Public quality | Orta | Yuksek | High | Web | Gate C/D blocker |
| R-06 | Disclosure inconsistency veya loss | Trust / Compliance | Orta | Cok yuksek | Critical | Product + Compliance | Gate B/D blocker |
| R-07 | Unsafe / phishing URL riski | Safety | Orta | Cok yuksek | Critical | Ops | Gate C/D blocker |
| R-08 | Unsupported merchant dead-end | Product / Import | Orta | Yuksek | High | Product + Import | Gate B blocker |
| R-09 | Support team issue flood | Operations | Orta | Yuksek | High | Support + Ops | Gate C/D blocker |
| R-10 | Regional merchant variability | Import | Orta | Orta-Yuksek | Medium | Import | Pilot rollout riski |
| R-11 | Content-linked page adoption'in dusuk kalmasi | Product | Orta | Yuksek | High | Product | Differentiation riski |
| R-12 | Creator retention'in dusuk kalmasi | Product / Growth | Yuksek | Yuksek | Critical | Product | Launch growth riski |

---

## 7. Critical riskler

Bu bolumde kritik riskler detaylandirilir.

### 7.1. R-01 Wrong extraction / wrong product

Tanım:
Sistem URL'den yanlis urun, yanlis title, yanlis image veya yanlis merchant çıkarir.

Neden kritik:

- urunun en temel guven vaatlerinden birini bozar
- creator vakit kaybeder
- viewer yanlis yere gider
- support yükü artar

Erken sinyaller:

- manual correction oraninin yükselmesi
- same merchant için artan wrong-image vakalari
- support'ta "yanlis urun geldi" issue tipinin artmasi

Zorunlu karşı hamle:

- extraction strategy katmanli olmalı
- verification UI zorunlu olmalı
- confidence ve failure trail saklanmali

Launch etkisi:

- desteklenen merchant setinde belirginse Gate B ve Gate D blocker'dir

### 7.2. R-06 Disclosure inconsistency veya loss

Tanım:
Disclosure kaydi ile UI sunumu arasinda tutarsizlik olmasi veya disclosure bilgisinin kaybolmasi.

Neden kritik:

- trust ve compliance cekirdegi bozulur

Erken sinyaller:

- support'ta sponsorlu/affiliate belirsizlik sorulari
- QA'da page tipleri arasinda tutarsizlik

Zorunlu karşı hamle:

- disclosure veri modeli net olmalı
- trust layer UI primitive olarak tanimlanmali
- checklist ve acceptance test yazilmali

Launch etkisi:

- Gate B ve Gate D blocker

### 7.3. R-07 Unsafe / phishing URL riski

Tanım:
Creator'in guvensiz veya policy-riskli URL girisiyle urunun zararli cikisa donusme riski.

Neden kritik:

- guven ve itibar kaybı
- compliance ve abuse riski

Erken sinyaller:

- report edilen suspicious domain artisi
- redirect chain anomalileri
- policy block olaylari

Zorunlu karşı hamle:

- URL safety policy
- blocklist / ruleset
- issue escalation ve runbook

Launch etkisi:

- Gate C ve D blocker

### 7.4. R-12 Creator retention'in dusuk kalmasi

Tanım:
Creator ilk publish'i yapar ama tekrarli kullanim davranisi kurmaz.

Neden kritik:

- urun "bir kere kurulan ölü profil"e doner

Erken sinyaller:

- ilk publish var ama ikinci / ucuncu publish yok
- reuse kullanim orani dusuk
- import yerine manuel giris baskin

Zorunlu karşı hamle:

- short publish flow
- reusable library
- content-linked page utility
- broken/stale maintenance hygiene

Launch etkisi:

- external launch sonrasinda büyüme riskidir; ama Gate C private usage'da guclu sinyal aranir

---

## 8. High riskler

### 8.1. R-02 Duplicate product birikimi

Tanım:
Ayni product birden fazla kez farkli URL varyasyonlari veya zayif dedupe kurallari nedeniyle ayrica kaydolur.

Neden onemli:

- creator library kirlenir
- stale yönetimi zorlasir
- support confusions artar

Erken sinyal:

- canonical URL benzerliklerinde artan manual merges
- support'ta duplicate confusion issue'lari

Zorunlu karşı hamle:

- canonical URL politikasi
- duplicate detection
- reuse-first UI

### 8.2. R-03 Positioning'in "better storefront" seviyesine dusmesi

Tanım:
Urun mesajinin context-first recommendation publishing yerine theme/storefront seviyesine indirgenmesi.

Neden onemli:

- yanlış beklenti yaratir
- roadmap'i builder ve cosmetics tarafina ceker

Erken sinyal:

- marketing veya ürün cümlelerinde "store", "shop" ve "better Linktree" baskinligi
- content-linked page'in arka plana itilmesi

### 8.3. R-04 Checkout / analytics scope drift

Tanım:
Commerce veya BI capability'lerinin ilk faz scope'una sizmasi.

Neden onemli:

- çekirdek urun problemini gölgeler

Erken sinyal:

- backlog'ta checkout, revenue panel, attribution vb. taleplerin çoğalması

### 8.4. R-05 Public web performance zayifligi

Tanım:
Public sayfalarin sosyal trafikten gelen viewer icin yeterince hizli veya guven verici olmamasi.

Erken sinyal:

- yuksek bounce
- pilot testte "sayfa gec aciliyor" yorumu
- mobilde layout kaymasi

### 8.5. R-08 Unsupported merchant dead-end

Tanım:
Creator desteklenmeyen merchant'ta ne oldugunu ve sonraki adimi anlayamaz.

Erken sinyal:

- "neden import olmadi?" support issue'lari
- unsupported merchant'ta tekrar deneme davranisinin artmasi

### 8.6. R-09 Support team issue flood

Tanım:
Issue taxonomy zayif oldugu icin benzer sorunlar destek ekibini boğar.

Erken sinyal:

- ayni issue tipi farkli cevaplarla dönüyor
- escalation yükü artıyor

### 8.7. R-11 Content-linked page adoption'in dusuk kalmasi

Tanım:
Creator'lar differentiator yüzey olan content-linked page'i kullanmiyor; sadece storefront ana sayfa kullanıyor.

Erken sinyal:

- content page creation oraninin dusuk kalmasi
- trafik dagiliminda storefront ana sayfa baskinligi

---

## 9. Medium riskler

### 9.1. R-10 Regional merchant variability

Tanım:
Ayni merchant veya merchant sınıfının farklı bolgelerde farkli data davranisi gostermesi.

Neden onemli:

- parser kalitesi bölgesel olarak dalgalanabilir
- fiyat / currency / availability farklari gorunur

Erken sinyal:

- bolge bazli quality farki
- belirli ulkelerde artan manual correction

Zorunlu karşı hamle:

- locale-aware parsing
- region-scoped pilot

---

## 10. Risk sinyallerinin izlenmesi

Her risk icin asgari olarak bir "nasıl fark ederiz?" satiri olmalidir.

Zorunlu sinyal aileleri:

1. import quality signals
2. support issue signals
3. public trust signals
4. performance signals
5. adoption / retention signals

Bu sinyaller yazilmadan risk kaydı eksik kabul edilir.

---

## 11. Risk response stratejileri

Bu belgeye gore risk response türleri sunlardir:

### 11.1. Avoid

Riskli capability'yi kapsam disi birakmak.  
Ornek:

- checkout kapsam disi

### 11.2. Mitigate

Riskin olasiligini veya etkisini azaltmak.  
Ornek:

- verification UI ile wrong extraction riskini azaltmak

### 11.3. Accept with Guardrails

Riskin tamamen kapanmadigini bilip rollout siniri ve izleme ile kabul etmek.  
Ornek:

- belirli merchant'lar için `partial` tier ile pilot rollout

### 11.4. Block

Risk kapanmadan gate gecirmemek.  
Ornek:

- disclosure inconsistency

---

## 12. Risk review ritmi

Bu urun icin risk review ritmi su sekilde olmalidir:

### 12.1. Haftalik

- import issues
- duplicate issues
- broken links
- unsupported merchant issue dagilimi

### 12.2. Iki haftalik

- scope drift taramasi
- roadmap ve backlog review

### 12.3. Aylik

- compliance, abuse ve trust review
- retention trend review

### 12.4. Gate review oncesi

- tum critical ve high risklerin owner bazli tek tek yeniden degerlendirilmesi

---

## 13. Hangi riskler launch once mutlaka kapanmali?

Asagidaki riskler launch once kapanmali veya bloklayici olarak işlenmelidir:

1. wrong extraction kritik seviyede
2. disclosure inconsistency
3. unsafe/phishing URL kontrol eksigi
4. unsupported merchant dead-end
5. public performance'in guven vermeyecek kadar kotu olmasi
6. import issue taxonomy'nin olmamasi

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `40-url-import-pipeline-spec.md` wrong extraction ve unsupported merchant risklerini mitige edecek detayda yazilmalidir
2. `27-disclosure-trust-and-credibility-layer.md` trust risklerini dogrudan ele almalıdır
3. `101-runbooks.md` critical ve high risk'lerin ilk tepki adimlarini yazmalidir
4. `102-incident-response-project-layer.md` safety ve trust incident'larini ayri siniflamalidir
5. `83-import-accuracy-test-matrix.md` R-01 ve R-02 icin kanit üretmelidir

---

## 15. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- urundeki kritik riskler isimlendirilmis, sahiplenilmis ve izlenebilir hale geliyorsa
- launch once hangi risklerin bloke edici oldugu netse
- product ve engineering tartismalari risklerin diline baglanabiliyorsa
- support ve ops readiness risk register'a entegre oluyorsa

Bu belge basarisiz sayilir, eger:

- riskler genel ve muallak kalirsa
- owner belirtilmeyen riskler birikirse
- import, trust ve scope drift riskleri yeterince merkezi ele alinmazsa

Bu nedenle bu belge, "neler ters gidebilir?" listesinden fazlasidir; urunun nerelerde kirilabilecegini ve bunun nasil erken fark edilip kontrol altina alinacagini tanimlar.
