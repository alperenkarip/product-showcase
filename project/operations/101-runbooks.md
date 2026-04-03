---
id: RUNBOOKS-001
title: Runbooks
doc_type: operational_runbook_spec
status: ratified
version: 2.0.0
owner: operations
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - BACKGROUND-JOBS-SCHEDULING-SPEC-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
  - OBSERVABILITY-INTERNAL-EVENT-MODEL-001
  - WEBHOOK-EVENT-CONSUMER-SPEC-001
  - ENVIRONMENT-AND-SECRETS-MATRIX-001
blocks:
  - INCIDENT-RESPONSE-PROJECT-LAYER
  - SUPPORT-PLAYBOOKS
  - RELEASE-READINESS-CHECKLIST
---

# Runbooks

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde production veya production-benzeri operasyon sorunu ortaya ciktiginda hangi semptomun hangi runbook ailesine girdigini, her runbook'un hangi zorunlu bolumleri tasiyacagini, ilk 15 dakika icinde ne yapilacagini, hangi aksiyonlarin guvenli oldugunu ve hangi durumda incident response'a escalation gerekecegini tanimlayan resmi operasyon runbook belgesidir.

Bu belge su sorulara cevap verir:

- Import sistemi bozulursa ilk kim neye bakar?
- Queue backlog ile worker stuck ayni sey midir?
- Stale trust anomalisi gorulurse once product bug mi, refresh sorunu mu, cache sorunu mu aranir?
- Webhook lag veya duplicate storm nasil ayrilir?
- Domain verify olmazsa ne log'a, ne queue'ya, ne provider durumuna bakilir?
- Bir operator neyi guvenle yeniden deneyebilir, neyi tek basina yapamaz?

---

## 2. Bu belge neden kritiktir?

Bu urunde operasyonel sorunlar sadece "500 hatasi" olarak gorunmez.

Sessiz bozulmalar daha tehlikelidir:

1. import acceptance yuksektir ama review-required anormal artmistir
2. stale price warning kaybolmustur
3. webhook duplicate olaylari entitlement drift uretmistir
4. OG mismatch support tarafinda "gorsel yanlis" diye gorulur ama kok neden publish/invalidation zinciridir

Runbook olmazsa ekip:

- ayni sorunu her seferinde bastan tartisir
- riskli aksiyonlari paniğe kapilip uygular
- support ile ops ayni dili kullanamaz
- incident sinifi dogru okunmaz

Bu belge, "runbook sonra yazariz" yaklaşimini kapatan operatif source of truth'tur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` runbook'lari generic infra semptomlari degil, urun-semantic failure aileleri uzerinden yazilacaktir; her runbook ilk 15 dakika aksiyonlarini, guvenli/no-go operator hareketlerini, creator/viewer etkisini ve escalation cizgisini acikca tanimlayacaktir.

Bu karar su sonuclari dogurur:

1. `import failure spike` runbook'u yalniz error rate degil, wrong extraction ve review anomaly'yi de ele alir.
2. `stale trust anomaly` runbook'u yalniz cache temizleme rehberi olamaz.
3. Support'tan ops'a gecis dili standardized olur.

---

## 4. Runbook felsefesi

Bu proje icin runbook tasarimi bes ilkeye dayanir:

1. semptom-first
2. truth-preserving
3. blast-radius-aware
4. audit-aware
5. human-readable

### 4.1. Semptom-first

Runbook, operator'un gordugu semptomla baslar:

- "import accepted ama ilerlemiyor"
- "stale warning'ler kayboldu"
- "domain verify queue birikti"

### 4.2. Truth-preserving

Sorunu kapatirken public trust veya billing truth bozulmaz.

### 4.3. Blast-radius-aware

Sorun tek merchant mi, tek creator mi, yoksa sistemik mi?  
Runbook bunu erken ayrisir.

### 4.4. Audit-aware

Riskli aksiyonlar not birakmadan uygulanmaz.

### 4.5. Human-readable

Gece vardiyasindaki operator veya support, sistemi ezbere bilmeden ilk hareketi yapabilmelidir.

---

## 5. Her runbook'ta bulunacak zorunlu bolumler

Her tekil runbook asgari olarak su bolumleri tasir:

1. semptom
2. risk seviyesi
3. olasi blast radius
4. ilk 15 dakika adimlari
5. derin teshis akisi
6. guvenli aksiyonlar
7. yasak aksiyonlar
8. creator/support etkisi
9. escalation tetikleri
10. closure kriteri
11. post-incident notu

Kural:

Sadece "neleri kontrol et" listesi runbook sayilmaz.  
Hangi aksiyonun guvenli, hangisinin riskli oldugu yazilmalidir.

---

## 6. Runbook aileleri

Launch icin zorunlu runbook aileleri:

1. import failure spike
2. queue backlog / worker stuck
3. stale trust anomaly
4. broken link / unsafe redirect surge
5. domain verification stuck
6. webhook lag / duplicate storm
7. metadata / OG mismatch
8. storage/media degradation

Opsiyonel ama sonraki faza yaklasan aileler:

9. billing entitlement drift
10. support issue flood

---

## 7. Severity ve escalation cizgisi

Runbook icinde su seviyeler kullanilir:

- `R0-observe`
- `R1-operational`
- `R2-user-visible`
- `R3-incident-candidate`

### 7.1. `R0-observe`

Tekil veya dusuk etkili anomaly.  
Trend izlenir, anlik sevk gerekmez.

### 7.2. `R1-operational`

Operasyonel mudahale gerekir ama sistemik user-impact yoktur.

### 7.3. `R2-user-visible`

Creator veya viewer deneyimi belirgin etkilenmistir.  
Support koordinasyonu gerekir.

### 7.4. `R3-incident-candidate`

Blast radius veya guven etkisi yuksektir.  
Incident response tetiklenebilir.

---

## 8. Ortak ilk 15 dakika disiplinleri

Her runbook ilk 15 dakikada su ortak disiplini izler:

1. semptomu tek cümle ile adlandir
2. blast radius'u tahmin et
3. benzer alarm veya deploy degisikligi var mi bak
4. guvenli kill-switch veya throttle ihtiyacini degerlendir
5. support'e bilgi vermek gerekip gerekmedigini belirle

Kural:

Ilk 15 dakikada "bir seyler restart edelim" refleksi kabul edilmez.  
Once semptom ve etki sinifi adlandirilir.

---

## 9. Runbook 1: Import failure spike

### 9.1. Semptom

- `import.failed` veya `import.blocked` anomali artisi
- review-required orani beklenmedik sekilde sicradi
- belirli merchant veya tum sistem etkileniyor

### 9.2. Ilk 15 dakika

1. Failure family dagilimini cikar
2. Merchant bazli cluster var mi bak
3. Son deploy, registry change, provider health event ve secret rotation var mi kontrol et
4. Queue backlog ve worker latency normal mi bak
5. User-visible mi, yoksa sadece ops metric mi karar ver

### 9.3. Derin teshis akisi

Kontrol sirası:

1. provider health / quota
2. registry tier/kill-switch degisikligi
3. fetch/render failure dagilimi
4. extraction ambiguity artisi
5. persistence veya verification expiry etkisi

### 9.4. Guvenli aksiyonlar

- belirli merchant icin throttle
- belirli merchant icin temporary fallback-only downgrade
- retryable technical failure'larda kontrollu retry
- creator-facing status copy'larini guncel tutmak

### 9.5. Yasak aksiyonlar

- blocked domain'i hiz icin acmak
- review-required import'u creator yerine sessizce apply etmek
- duplicate korumalarini kapatmak

### 9.6. Escalation tetikleri

- `critical-fail` trendi
- wrong image / wrong merchant support issue artisi
- `P0` queue backlog ile birlikte import acceptance dususu

---

## 10. Runbook 2: Queue backlog / worker stuck

### 10.1. Semptom

- `P0` backlog warning veya blocker eşiği aşıldı
- jobs accepted ama ilerlemiyor
- webhook apply ya da refresh queue tıkalı

### 10.2. Ilk 15 dakika

1. Hangi priority sinifi tıkalı ayır
2. Aynı anda provider outage veya deploy var mı bak
3. Worker health ve orchestrator kabul oranını kontrol et
4. Dead-letter / parked artisi var mi bak
5. Backlog `P0` ise incident adayi olarak işaretle

### 10.3. Guvenli aksiyonlar

- `P2/P3` maintenance throttle
- non-critical generation job pause
- provider-health kaynakli bulk refresh durdurma

### 10.4. Yasak aksiyonlar

- durable state incelemeden queue'yu topluca temizlemek
- `P0` import job'larini iptal edip "yeniden denerler" demek

### 10.5. Escalation tetikleri

- `P0` backlog `15 dk` ustu
- billing/webhook queue ayni anda etkileniyorsa

---

## 11. Runbook 3: Stale trust anomaly

### 11.1. Semptom

- stale price warning'leri kayboldu
- hidden-by-policy yerine current gorunuyor
- selected source stale state gecisleri publicte yansimiyor

### 11.2. Ilk 15 dakika

1. Tek merchant mi, tum public surface mi ayir
2. Son refresh event'leri ve invalidation event'lerini incele
3. Public cache / revalidation gecikmesi var mi bak
4. Selected source degisimi veya source state map bozulmasi var mi kontrol et

### 11.3. Guvenli aksiyonlar

- etkilenen route tag ailelerinde kontrollu revalidation
- selected public source refresh onceligini yukselterek tekrar deneme
- gerekiyorsa trust-safe temporary hide state

### 11.4. Yasak aksiyonlar

- stale fiyatı "user görmesin" diye current gibi tutmak
- source freshness truth'unu elle temelsiz sekilde sifirlamak

### 11.5. Escalation tetikleri

- publicte yaniltici current state yayginlasiyorsa
- billing veya compliance ekibinin degerlendirmesini gerektiren trust etkisi varsa

---

## 12. Runbook 4: Broken link / unsafe redirect surge

### 12.1. Semptom

- broken link orani artiyor
- unsafe redirect veya policy block alarmlari geliyor
- support "link acilmiyor" veya "yanlis siteye gidiyor" sikayetlerini artan oranda aliyor

### 12.2. Ilk 15 dakika

1. Merchant veya host bazli cluster kontrolu
2. Redirect zinciri davranisinda deploy veya vendor degisikligi var mi bak
3. Blocked domain listesi / host kill-switch degisimi var mi incele
4. Viewer-facing blast radius'u belirle

### 12.3. Guvenli aksiyonlar

- ilgili host icin temporary block
- public CTA'lari disable etmek
- support macro'larini guncellemek

### 12.4. Yasak aksiyonlar

- viewer sikayetini azaltmak icin policy block'u kapatmak
- unsupported redirect davranisini whitelist'le gecistirmek

### 12.5. Escalation tetikleri

- phishing supheleri
- marka veya compliance sikayeti
- ayni pattern'in farkli merchant'larda yayginlasmasi

---

## 13. Runbook 5: Domain verification stuck

### 13.1. Semptom

- pending domain sayisi artiyor
- verify retry job'lari parked/fail oluyor
- creator custom domain'i aktif edemiyor

### 13.2. Ilk 15 dakika

1. Provider health ve DNS API durumu kontrol et
2. Son secret rotation veya token expiry var mi bak
3. Domain verify queue backlog'u incele
4. Tek account mu, sistemik mi karar ver

### 13.3. Guvenli aksiyonlar

- verify retry onceligini ayarlamak
- creator'a handle-based canonical ile devam etmesini saglayan bilgi vermek
- provider token/config duzeltmesi

### 13.4. Yasak aksiyonlar

- verify edilmemis domain'i aktif saymak
- DNS dogrulama olmadan canonical'i degistirmek

---

## 14. Runbook 6: Webhook lag / duplicate storm

### 14.1. Semptom

- webhook ingest delay artisi
- duplicate delivery orani sicradi
- billing veya email event'leri parked/failed artisi gosteriyor

### 14.2. Ilk 15 dakika

1. Hangi provider etkilendi ayir
2. Signature reject mi, duplicate mi, apply lag mi oldugunu ayikla
3. Son secret rotation veya provider deploy'larini kontrol et
4. Entitlement veya support etkisi var mi belirle

### 14.3. Guvenli aksiyonlar

- duplicate event apply'ini engelleyen guard'lari koruyarak backlog isleme
- provider bazli ingest throttle veya queue ayrimi
- checkout bridge pending durumunu creator'a net gostermek

### 14.4. Yasak aksiyonlar

- duplicate storm var diye idempotency'yi kapatmak
- checkout success'i authoritative kabul edip elle entitlement acmak

### 14.5. Escalation tetikleri

- billing access drift
- signature invalid spike
- parked backlog'un surekli buyumesi

---

## 15. Runbook 7: Metadata / OG mismatch

### 15.1. Semptom

- public page dogru ama share preview yanlis
- yeni cover yuklendi ama eski OG image gorunuyor
- slug/domain degisti ama eski canonical preview yasiyor

### 15.2. Ilk 15 dakika

1. Publication revision degisti mi kontrol et
2. OG generation queue ve asset state'e bak
3. Route metadata ve CDN propagation farkini ayir
4. tek page mi, family-level issue mu belirle

### 15.3. Guvenli aksiyonlar

- ilgili surface icin OG regenerate
- route metadata revalidation
- eski pointer'larin invalidate edilmesi

### 15.4. Yasak aksiyonlar

- dogru publication revision olmadan random cache flush
- eski asset'i overwrite edip immutable varsayimlarini bozmak

---

## 16. Runbook 8: Storage / media degradation

### 16.1. Semptom

- yeni upload'lar basarisiz
- generated asset write edilemiyor
- existing media serving anomali gosteriyor

### 16.2. Ilk 15 dakika

1. read mi write mi etkilendi ayir
2. storage provider health kontrol et
3. signed URL / credential expiry bak
4. blast radius public mi creator write mi belirle

### 16.3. Guvenli aksiyonlar

- yeni upload veya generation'i gecici kapatmak
- mevcut immutable serving'i korumak
- support copy'sini guncellemek

### 16.4. Yasak aksiyonlar

- broken storage durumunda merchant hotlink'i kalici cozum gibi kullanmak

---

## 17. Runbook ile support playbook ayrimi

Runbook:

- operator ve teknik ekip icindir
- root cause ve sistem davranisi uzerine kuruludur

Support playbook:

- creator/viewer iletisimini standardize eder
- support'un gorebilecegi ve yapabilecegi sinirlari tanimlar

Kural:

Support playbook runbook'un kopyasi olamaz.  
Teknik jargon ve riskli operator aksiyonlari support katmanina acilmaz.

---

## 18. Hangi aksiyonlar tek kisiyle yapilamaz?

Asagidaki aksiyonlar ikinci goz veya incident owner onayi ister:

1. production kill-switch degisimi
2. domain block listesinde toplu degisiklik
3. break-glass secret kullanimi
4. webhook secret rotasyonu
5. entitlement state'ini etkileyen operator hareketi

---

## 19. Runbook kapanis kriterleri

Bir runbook vakasi kapatilmis sayilmak icin:

1. semptom tekrar uretilemiyor olmali
2. blast radius daraltilmis veya bitmis olmali
3. creator/viewer-facing etki notu girilmis olmali
4. gerekiyorsa support makrosu guncellenmis olmali
5. post-incident veya follow-up issue olusturulmus olmali

---

## 20. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Semptomu adlandirmadan restart/retry yapmak
2. public trust sorunu varken "cache flush yap gecer" refleksi
3. blocked/policy state'i bypass ederek gecici cozum uretmek
4. support'u teknik kok neden aramaya zorlamak
5. runbook closure notu olmadan vaka kapatmak

---

## 21. Bu belge sonraki belgelere ne emreder?

### 21.1. Incident response

- incident siniflari bu runbook ailelerinden tureyecek

### 21.2. Support playbooks

- creator/viewer-facing cevaplar bu runbook'larda tanimlanan kok neden ve guvenli aksiyonlara hizalanacak

### 21.3. Release readiness

- launch oncesi en az cekirdek runbook aileleri okunabilir ve uygulanabilir halde olacak

---

## 22. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin operator, support lead veya on-call muhendis bir semptom gordugunde "once neye bakacagim, hangi aksiyon guvenli, ne zaman incident acacagim ve kullaniciya ne diyecegiz?" sorularina ek aciklama istemeden cevap bulabilmelidir.
