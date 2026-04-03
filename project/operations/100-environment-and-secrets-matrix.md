---
id: ENVIRONMENT-AND-SECRETS-MATRIX-001
title: Environment and Secrets Matrix
doc_type: operations_platform_spec
status: ratified
version: 2.0.0
owner: platform-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - THIRD-PARTY-SERVICES-REGISTER-001
  - AUTH-IDENTITY-SESSION-MODEL-001
  - WEBHOOK-EVENT-CONSUMER-SPEC-001
  - PRIVACY-DATA-MAP-001
blocks:
  - RUNBOOKS
  - INCIDENT-RESPONSE-PROJECT-LAYER
  - RELEASE-READINESS-CHECKLIST
---

# Environment and Secrets Matrix

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun ortam topolojisini, config siniflarini, secret ailelerini, hangi degerlerin hangi runtime'a girebilecegini, rotasyon ve owner modelini, preview/staging/production ayrimini ve acil durumda secret/ortam davranisinin nasil yonetilecegini tanimlayan resmi platform operasyon belgesidir.

Bu belge su sorulara cevap verir:

- local, preview, staging ve production birbirinden tam olarak nasil ayrilir?
- hangi deger public config, hangi deger server secret, hangisi runtime secure value sayilir?
- mobile bundle'a ne girebilir, ne giremez?
- webhook, billing, extraction, storage ve observability secret'lari nasil siniflanir?
- ortamlar arasi veri ve secret karisimi nasil engellenir?
- secret rotasyonu ve acil iptal sureci nasil isler?

---

## 2. Bu belge neden kritiktir?

Bu urunde ortamlari ve secret'lari gelişi guzel ele almak su riskleri dogurur:

1. Client bundle'a server secret sizar.
2. Preview ortamindan canli merchant etkisi yaratan testler cikar.
3. Staging ile production arasindaki farklar release gunu surprise uretir.
4. Webhook secret rotasyonu oldugunda olay akisi sessizce kirilir.
5. Support veya ops icin gerekli environment ownership bilgisi bulunamaz.

Bu belge, "env dosyalarini bir yerlere koyduk" notu degil;  
hangi ortamda neyin gercek, neyin kontrollu, neyin asla acilmamasi gerektigini sabitler.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icin ortamlar tek bir "dev/prod" ayrimina indirgenmeyecek; local, preview, staging ve production ayrik davranis tasiyacak; public build config, server runtime secret, device-local secure value ve operator-only secret aileleri birbirine karistirilmayacak; production secret ve production benzeri veri yalnizca acik owner ve rotasyon disiplini ile kullanilacaktir.

Bu karar su sonuclari dogurur:

1. Client'a giren her config public kabul edilir.
2. Server secret'i mobile/web bundle'a koymak yapisal ihlal sayilir.
3. Staging production'a en yakin dogrulama ortami olarak zorunlu kalir.
4. Preview ve staging canli merchant/billing etkisini kontrolsuz uretmez.
5. Secret owner'i ve rotasyon tarihi olmayan deger "kullaniliyor" sayilmaz.

---

## 4. Ortam topolojisi

Bu proje icin asgari dort ortam vardir:

1. `local`
2. `preview`
3. `staging`
4. `production`

Opsiyonel ortak ekip entegrasyon ortami `development` benzeri ara isimle kullanilabilir; ama canonical release hattinda yukaridaki dort seviye korunur.

---

## 5. Ortamlarin amaci

### 5.1. `local`

Amaç:

- bireysel gelistirme
- hizli iterasyon
- kontrollu fixture veya sandbox entegrasyon

Ozellikler:

- local DB veya paylasimli dev DB kullanabilir
- mock webhook ve mock provider akislari kabul edilir
- gerçek production secret kullanilmaz

### 5.2. `preview`

Amaç:

- feature review
- PR / branch bazli urunsel dogrulama
- hedefli manual audit

Ozellikler:

- production'a yakin route ve config sekli olabilir
- production secret kullanmaz
- canli merchant etkisi yaratan agresif scheduler isleri kapali veya etiketli olur

### 5.3. `staging`

Amaç:

- production benzeri release rehearsal
- webhook, billing, import ve rollback provasini yapmak
- release readiness son kapisi olmak

Ozellikler:

- production'a en yakin config
- ayrik domain/host
- ayrik secret seti
- test billing/provider hesaplari

Kural:

Staging olmadan production release ciddi risk tasir.  
Bu proje icin staging zorunludur.

### 5.4. `production`

Amaç:

- gercek creator ve viewer trafigi
- gercek billing, retention ve audit yukumlulukleri

Ozellikler:

- en siki secret yonetimi
- en siki audit ve erişim disiplini
- kill-switch ve incident prosedurleri zorunlu

---

## 6. Ortamlar arasi davranis farklari

| Ortam | Veri gercekligi | Provider modu | Scheduler davranisi | Incident etkisi |
| --- | --- | --- | --- | --- |
| local | fixture/sandbox | mock veya sandbox | elle tetik veya kapali | bireysel |
| preview | test/ephemeral | sandbox | riskli maintenance kapali, hedefli akış acik | feature-level |
| staging | prod-benzeri test | sandbox ama gercek entegrasyon zinciri | release'e yakin | pre-release blocker |
| production | gercek | gercek | tam operasyonel | user-impacting |

Kural:

Production veri kopyasi preview veya local'a kontrolsuz indirilmez.  
Staging'e production benzeri data gerekiyorsa privacy ve governance kurallariyla maskeleme uygulanir.

---

## 7. Config siniflari

Bu urunde config dort sinifa ayrilir:

1. public build-time config
2. server runtime config
3. secure device/runtime values
4. operator-only secrets

### 7.1. Public build-time config

Client bundle'a girebilir.

Ornek:

- public app base URL
- public environment label
- public analytics key
- release channel name

Kural:

Bundle'a giren her sey okuyana aciktir.  
Bu nedenle "public config ama kimse bilmez" sinifi yoktur.

### 7.2. Server runtime config

Yalniz server/runtime proseslerinde okunur.

Ornek:

- DB connection string
- webhook verification secret
- billing private keys
- object storage credentials
- auth/session secrets

### 7.3. Secure device/runtime values

Login sonrasinda cihazda guvenli saklanabilen ama build config olmayan degerler.

Ornek:

- mobile secure session restore bilgisi
- gecici device-bound auth token/state

Kural:

Bu degerler env degiskeni degil; device runtime secret sinifidir.

### 7.4. Operator-only secrets

Sadece sinirli ops/platform baglaminda acilan degerler.

Ornek:

- migration admin credential
- disaster recovery credential
- vendor account recovery token'lari

---

## 8. Surface bazli config siniri

### 8.1. Public web client

Girebilir:

- public API URL
- public environment name
- public analytics/telemetry key

Giremez:

- DB URL
- billing secret
- webhook secret
- object storage write credential
- auth signing secret

### 8.2. Creator mobile bundle

Girebilir:

- public API endpoint
- public app env label
- public flag/analytics key

Giremez:

- provider private keys
- server secret'lari
- migration credential'lari
- signed internal tokens

### 8.3. API / server runtime

Okuyabilir:

- auth/session secrets
- DB creds
- webhook secrets
- billing private creds
- storage write creds
- vendor private keys

### 8.4. Jobs / worker runtime

Okuyabilir:

- API ile ortak server secret'larin gereken alt kumesi
- vendor worker-specific keys
- queue/orchestrator secret'lari

Kural:

Worker, principle of least privilege ile calisir.  
Tum server secret'larina otomatik erisim almaz.

### 8.5. Ops / support tools

Support araci secret gormek icin degil, state gormek icin vardir.  
Operator-only secret'lar support paneline yansitilmaz.

---

## 9. Secret aileleri

Bu proje icin asgari secret aileleri:

1. auth ve session
2. database
3. billing ve webhook
4. object storage ve CDN
5. extraction/render
6. domain and DNS
7. analytics ve observability
8. transactional email
9. operator-only recovery ve migration

### 9.1. Auth ve session

Ornek:

- session signing secret
- provider private auth credentials

### 9.2. Database

Ornek:

- primary write connection string
- read-only/reporting credential
- migration user credential

### 9.3. Billing ve webhook

Ornek:

- billing private API key
- billing webhook secret
- checkout provider webhook secret

### 9.4. Object storage ve CDN

Ornek:

- storage access key
- storage secret key
- signed URL/private bucket secret'lari

### 9.5. Extraction/render

Ornek:

- render provider token
- browser automation/service secret

### 9.6. Domain and DNS

Ornek:

- DNS provider API token
- domain verify service secret

### 9.7. Analytics ve observability

Ornek:

- observability private key
- source map upload token
- analytics private ingest key

### 9.8. Transactional email

Ornek:

- email send API key
- bounce webhook secret

### 9.9. Operator-only recovery ve migration

Ornek:

- break-glass database recovery credential
- vendor emergency recovery token

---

## 10. Secret owner modeli

Her secret ailesinin bir owner'i vardir:

| Secret ailesi | Primary owner | Secondary owner |
| --- | --- | --- |
| Auth/session | platform + security | backend lead |
| Database | platform | backend lead |
| Billing/webhook | backend + finance/billing ops | platform |
| Storage/CDN | platform | backend |
| Extraction/render | import ops | platform |
| Domain/DNS | platform | web lead |
| Observability | platform | ops |
| Transactional email | ops | support lead |
| Break-glass | platform lead | engineering manager |

Kural:

Owner'i olmayan secret aileleri production'a tasinamaz.

---

## 11. Rotasyon politikasi

Secret rotasyonu risk sinifina gore ayrilir.

### 11.1. Yuksek risk siniflari

Asagidaki secret'lar en az `90` gunde bir rotasyona tabi olur:

- auth/session signing secrets
- billing private keys
- webhook verification secrets
- operator recovery credentials

### 11.2. Orta risk siniflari

Asagidaki secret'lar en az `180` gunde bir gozden gecirilir ve gerekiyorsa rotate edilir:

- storage credentials
- extraction provider keys
- transactional email keys

### 11.3. Olay bazli anlik rotasyon

Asagidaki durumda takvim beklenmez:

- secret sizinti supheleri
- personel ayriligi/rol degisikligi
- vendor compromise bildirimi
- webhook replay/authenticity sorunu

### 11.4. Rotasyon ilkesi

1. Yeni secret devreye alinir
2. ciftli gecis penceresi olan yerde iki secret kisa sure birlikte desteklenir
3. eski secret kapatilir
4. telemetry ile bozulma kontrol edilir

---

## 12. Ortam bazli secret kullanimi

### 12.1. Local

- yalnizca local `.env.local` benzeri gitignore dosyalar
- production secret yasak

### 12.2. Preview

- branch/preview secret seti
- test provider hesaplari
- production webhook endpoint'leri yasak

### 12.3. Staging

- production'a yakin ama ayrik anahtarlar
- gerçek production billing/merchant etkisi yok
- webhook route'lari staging provider config ile test edilir

### 12.4. Production

- ayrik managed secret store
- inline shell history veya elle paste edilen terminal notlari ile tasinmaz

---

## 13. Config isimlendirme ilkeleri

1. public env explicit public prefix tasir
2. private env public prefix tasimaz
3. ayni degerin hem public hem private versiyonu karisik adlandirilmaz

Ornek mantik:

- `PUBLIC_*`, `VITE_*`, `EXPO_PUBLIC_*` aileleri publictir
- prefixsiz veya `SERVER_*`, `SECRET_*` benzeri aileler private kalir

Kural:

Isimden secret/public ayrimi anlasilmalidir.

---

## 14. Secret depolama ve dagitim kurallari

1. Secret repo'ya commit edilmez.
2. `.env.example` yalnizca isim ve aciklama tasir.
3. Secret chat, ticket veya plain doc icine deger olarak yapistirilmaz.
4. Production secret, preview veya local shell export komutlariyla paylasilmaz.

### 14.1. CI/CD

CI yalniz kendi ihtiyaci kadar secret okur.

Kurallar:

- source map upload token build job'ina scoped verilir
- deploy job billing secret okumaz
- test job production operator secret'i okumaz

### 14.2. Mobile build

Build-time config yalniz public veya build metadata degerlerini alir.  
Binary icinde private secret saklanmaz.

---

## 15. Veri ve ortam karisimini engelleme kurallari

1. Production DB backup'i preview ortamina dogrudan restore edilmez.
2. Production merchant etkili bulk job'lar staging veya preview'da canli provider'a gonderilmez.
3. Test billing olaylari production user veya workspace ile eslestirilmez.
4. Production analytics/observability project'leri staging ile ortak kullanilmaz.

---

## 16. Incident ve acil durum davranisi

### 16.1. Secret sizinti supheleri

Beklenen akış:

1. ilgili secret ailesi anlik iptal/rotate edilir
2. etkilenen servisler degrade veya maintenance moduna alınır
3. runbook ve incident response devreye girer
4. etki kapsami belirlenir

### 16.2. Webhook secret rotasyonu

Beklenen akış:

1. yeni secret eklenir
2. webhook consumer iki degeri kisa gecis penceresinde tanir
3. provider tarafi guncellenir
4. eski secret kapatilir

### 16.3. Break-glass erişim

Yalniz su kosullarda acilir:

- production outage
- backup/restore
- vendor account compromise recovery

Kural:

Break-glass kullanimi audit ve iki-kisi onayi ister.

---

## 17. Senaryo bazli ornekler

### 17.1. Senaryo: Preview build'de billing action test edilecek

Beklenen:

1. preview billing sandbox key kullanilir
2. production checkout endpoint'i veya production customer data kullanilmaz

### 17.2. Senaryo: Mobile bundle icinde secret leak bulundu

Beklenen:

1. ilgili key aninda rotate edilir
2. release veya OTA durdurulur
3. incident kaydi acilir

### 17.3. Senaryo: Staging'de webhook event gelmiyor

Beklenen:

1. staging webhook secret ve route config'i kontrol edilir
2. production secret ile "deneme" yapilmaz
3. issue staging runbook'u uzerinden cozulur

---

## 18. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Server secret'i client bundle'a gommek
2. Preview/staging için production anahtari kullanmak
3. Secret degerini README, ticket veya comment icine yazmak
4. Secret owner veya rotasyon tarihi olmadan production'a cikmak
5. Break-glass credential'i normal gelistirme islerinde kullanmak

---

## 19. Bu belge sonraki belgelere ne emreder?

### 19.1. Runbooks

- secret compromise, webhook drift, staging/prod config mismatch ve vendor outage runbook'lari bu matrise gore yazilacak

### 19.2. Incident response

- environment/secrets kaynakli incident siniflari bu owner ve rotasyon modeline gore yonetilecek

### 19.3. Release readiness

- staging parity ve secret ownership release gate sayilacak

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip, "hangi secret nerede kullanilir, kim sorumludur, nasil rotate edilir ve hangi ortam neyi temsil eder?" sorularini ek aciklama istemeden cevaplayabilmeli; release ve incident anlarinda ortamsal belirsizlik yasamamali; preview/staging/prod karisimi fiilen engellenmis olmalidir.
