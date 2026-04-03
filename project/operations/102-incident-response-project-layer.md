---
id: INCIDENT-RESPONSE-PROJECT-LAYER-001
title: Incident Response - Project Layer
doc_type: incident_response_spec
status: ratified
version: 2.0.0
owner: engineering-ops
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - RUNBOOKS-001
  - OBSERVABILITY-INTERNAL-EVENT-MODEL-001
  - SECURITY-AND-ABUSE-CHECKLIST-001
  - REPORTING-TAKEDOWN-ABUSE-POLICY-001
blocks:
  - RELEASE-READINESS-CHECKLIST
  - SUPPORT-PLAYBOOKS
---

# Incident Response - Project Layer

## 1. Bu belge nedir?

Bu belge, `product-showcase` icin incident siniflarini, hangi operational anomaly'nin ne zaman gercek incident sayilacagini, SEV seviyelerini, komuta zincirini, ic ve dis iletisim kurallarini, trust/compliance etkili vakalarda nasil hareket edilecegini ve post-incident ciktilarini tanimlayan resmi incident response belgesidir.

Bu belge su sorulara cevap verir:

- Hangi vakalar bug degil incident sayilir?
- Public erisim kaybi ile trust misrepresentation ayni seviyede mi ele alinir?
- On-call, incident commander, support lead ve compliance owner ne zaman devreye girer?
- Incident sirasinda hangi bilgi ne hizda toplanir?
- Creator veya viewer etkisi varsa ne zaman iletisim kurulur?
- Incident kapandiktan sonra hangi follow-up'lar zorunludur?

---

## 2. Bu belge neden kritiktir?

Bu urunde incident yalniz tam cokus degildir.  
Bazı guven olaylari teknik olarak "sistem ayakta" olsa bile incident sayilmalidir.

Ornek:

1. stale price warning'leri kaybolmustur
2. unsafe link'ler publicte acilmaya baslamistir
3. checkout success authoritative zannedilerek entitlement drift olusmustur

Bu tip olaylar klasik uptime bakisiyla kucumsenirse urun guveni zarar gorur.  
Bu belge, availability incident'i ile trust incident'ini ayni ciddiyet haritasina oturtur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` incident response rejimi yalniz availability uzerinden kurulmaz; public trust, unsafe link, wrong entitlement ve widespread import correctness bozulmalari da incident sayilabilir; incident seviyesi blast radius, user harm, trust impact ve recovery karmaşıkligi birlikte degerlendirilerek atanir.

Bu karar su sonuclari dogurur:

1. "Sistem ayakta, incident degil" mantigi tek basina gecersizdir.
2. Trust ve compliance etkili anomaly'ler support issue seviyesine indirgenmez.
3. Incident response teknik ekip ile sinirli kalmaz; issue family support veya compliance alanina giriyorsa bu roller zincire zorunlu olarak eklenir.

---

## 4. Incident tanimi

Bu proje baglaminda incident:

> Creator, viewer, billing truth veya guvenlik/uyum boyutunda belirgin zarar, yaygin bozulma veya kontrolsuz risk ureten ve normal ticket akisi yerine koordine cevap gerektiren olaydir.

Incident olmayan ama izlenecek olaylar:

- tekil creator issue'su
- sistemik olmayan tek merchant bug'i
- lokal developer ortam arizasi

Not:

Tek merchant bug'i bile unsafe link veya widespread high-value merchant etkisi tasiyorsa incident sinifina yukselebilir.

---

## 5. Incident siniflari

Bu proje icin asgari incident seviyeleri:

- `SEV1-critical`
- `SEV2-high`
- `SEV3-moderate`
- `SEV4-observe-and-track`

### 5.1. `SEV1-critical`

Asagidaki ailelerden biri varsa:

1. public storefront genis erisim kaybi
2. unsafe link genis yayilimi
3. auth/session core cokusleri
4. billing entitlement genis drift
5. checkout veya webhook bozulmasi nedeniyle yaygin yanlis access state
6. canli kullanicida guveni dogrudan zedeleyen widespread trust misrepresentation

### 5.2. `SEV2-high`

Ornek:

1. belirli merchant grubunda toplu import kirilmasi
2. stale trust state'lerinin publicte yanlis gosterimi
3. OG/share metadata yaygin bozulmasi
4. custom domain verification sistemik takilma

### 5.3. `SEV3-moderate`

Ornek:

1. izole ama tekrar eden support issue cluster'i
2. belirli bir feature ailesinde ciddi ama gecici degrade
3. non-critical ama user-visible performance/regression olayi

### 5.4. `SEV4-observe-and-track`

Ornek:

1. blast radius dar anomaly
2. manual correction orani artis trendi
3. tekil vendor health warning

SEV4 olaylari incident room gerektirmeyebilir; ama risk olarak izlenir.

---

## 6. Incident degerlendirme eksenleri

Her olay su dort eksende puanlanir:

1. availability impact
2. trust / harm impact
3. blast radius
4. recovery complexity

Kural:

Availability dusuk olsa bile trust/harm yuksekse olay incident olabilir.

---

## 7. Rol ve komuta zinciri

Incident aninda asgari roller:

1. incident commander
2. technical lead
3. communications owner
4. support lead
5. compliance/security owner, gerekiyorsa

### 7.1. Incident commander

Gorevi:

- olay seviyesini ilan etmek
- action owner atamak
- bilgi dagilimini tek yerde tutmak

### 7.2. Technical lead

Gorevi:

- teknik teshis
- mitigasyon kararlari
- rollback veya throttle onerisi

### 7.3. Communications owner

Gorevi:

- ic paydas iletisimini
- creator/support-facing copy taslagini
- status update ritmini yonetmek

### 7.4. Support lead

Gorevi:

- gelen ticket temalarini toparlamak
- support macro'larini guncellemek
- support'un riskli operator aksiyonu almasini engellemek

### 7.5. Compliance/security owner

Asagidaki ailelerde zorunlu devreye girer:

- unsafe link
- takedown/trademark
- secret leak
- billing truth bozulmasi

---

## 8. Incident yasam dongusu

Her incident asgari su state'lerden gecer:

- `suspected`
- `declared`
- `investigating`
- `mitigating`
- `monitoring`
- `resolved`
- `postmortem_open`
- `closed`

Kural:

Incident state'i, teknik bug state'i ile karistirilmaz.

---

## 9. Ilk 30 dakika protokolu

### 9.1. Dakika 0-5

1. semptom adlandirilir
2. provisional sev atanir
3. incident commander belirlenir

### 9.2. Dakika 5-15

1. blast radius belirlenir
2. runbook secilir
3. riskli user harm durdurulabiliyorsa ilk mitigasyon uygulanir
4. support etkisi var mi degerlendirilir

### 9.3. Dakika 15-30

1. root-cause hipotezleri listele
2. owner bazli aksiyonlar dagit
3. ilk status notunu yaz
4. gerekiyorsa creator-facing ya da internal stakeholder iletişimini hazirla

---

## 10. Incident tiplerine gore ozel ilkeler

## 10.1. Availability incident'leri

Ornek:

- public route genis outage
- auth/session core failure
- API unresponsive

Oncelik:

- hizmeti geri getirmek
- guvenli degrade saglamak

## 10.2. Trust incident'leri

Ornek:

- stale price warning kaybi
- wrong selected source publicte
- disclosure loss

Oncelik:

- yaniltici sunumu durdurmak
- gerekiyorsa hide/degrade uygulamak
- sonra kok nedeni bulmak

## 10.3. Safety / abuse incident'leri

Ornek:

- phishing link
- unsafe redirect bypass
- abusive storefront yayilimi

Oncelik:

- public exposure'ı hizla kapatmak
- kaniti korumak
- compliance/security zincirini devreye almak

## 10.4. Billing / entitlement incident'leri

Ornek:

- duplicate webhook apply
- checkout bridge bozulmasi
- wrong premium unlock/lock

Oncelik:

- yanlış access genislemeyi durdurmak
- authoritative state'i korumak
- support'e net guidance vermek

---

## 11. Iletisim ilkeleri

### 11.1. Ic iletisim

Her update'te asgari su alanlar bulunur:

- incident seviyesi
- semptom
- blast radius
- aktif mitigasyon
- sonraki update zamani

### 11.2. Support iletisim

Support'e su bilgi verilir:

- kullaniciya ne denecek
- hangi aksiyon support'un yetkisinde
- hangi sorular escalate edilmeli

### 11.3. Creator / user iletisim

Public veya creator etkisi varsa:

- sorun tipi yalın anlatilir
- bilinen etki ve gecici davranis yazilir
- çözüldü demeden once kısmi varsayım kurulmaz

Kural:

Public etki varsa creator/support copy'si hazirlanmadan sessiz gecis yapilmaz.

---

## 12. Mitigasyon hiyerarsisi

Incident sirasinda aksiyonlar su sirayla tercih edilir:

1. blast radius daraltma
2. truth-preserving degrade
3. feature throttle / kill-switch
4. rollback
5. kalici fix

Kural:

Kalici fix beklerken yaniltici state'i acikta birakmak kabul edilmez.

Ornek:

- stale trust bug'inda once hide/degrade
- sonra refresh/invalidation kok nedeni

---

## 13. Incident closure kriterleri

Bir incident `resolved` sayilmak icin:

1. aktif user harm bitmis olmali
2. blast radius sabitlenmis olmali
3. telemetry normal banda donuyor olmali
4. support guidance guncellenmis olmali

`closed` sayilmak icin ek olarak:

5. postmortem veya incident note cikmis olmali
6. follow-up issue'lari owner'lanmis olmali

---

## 14. Postmortem zorunlulugu

Asagidaki incident ailelerinde postmortem zorunludur:

1. tum SEV1'ler
2. trust/compliance etkili tum SEV2'ler
3. ayni kok nedenden ikinci kez tekrarlayan olaylar

Postmortem asgari alanlari:

- zaman cizelgesi
- blast radius
- root cause
- neden daha erken fark edilmedi
- neyi degistiriyoruz

---

## 15. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Availability yok diye trust incident'i kucumsemek
2. Support'u teknik kok neden aramaya zorlamak
3. Incident devam ederken kesin olmayan sebebi kesinmis gibi duyurmak
4. Audit ve kanit toplamadan riskli state degisikligi yapmak
5. Postmortem'i "ticket acildi, yeter" diye gecistirmek

---

## 16. Bu belge sonraki belgelere ne emreder?

### 16.1. Support playbooks

- incident sirasinda support'un neyi soyleyip neyi yapamayacagi bu belgeye hizalanacak

### 16.2. Release readiness

- kritik incident aileleri icin rollback/kill-switch hazirligi release gate olacak

### 16.3. Runbooks

- her incident ailesi ilgili runbook'la eslesecek

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip "hangi olay incident, kim yonetecek, ilk 30 dakikada ne yapilacak ve ne zaman user-facing iletişim kuracagiz?" sorularini tartismasiz cevaplayabilmeli; trust ve safety olaylari availability kadar ciddiyetle ele alinabilmelidir.
