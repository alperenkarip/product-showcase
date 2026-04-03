---
id: DATA-BACKUP-RETENTION-RESTORE-001
title: Data Backup, Retention and Restore
doc_type: disaster_recovery_spec
status: ratified
version: 2.0.0
owner: platform-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DATABASE-SCHEMA-SPEC-001
  - DATA-LIFECYCLE-RETENTION-DELETION-RULES-001
  - PRIVACY-DATA-MAP-001
  - BACKGROUND-JOBS-SCHEDULING-SPEC-001
  - WEBHOOK-EVENT-CONSUMER-SPEC-001
  - ENVIRONMENT-AND-SECRETS-MATRIX-001
blocks:
  - RUNBOOKS
  - INCIDENT-RESPONSE-PROJECT-LAYER
  - RELEASE-READINESS-CHECKLIST
---

# Data Backup, Retention and Restore

## 1. Bu belge nedir?

Bu belge, `product-showcase` icinde hangi veri ailelerinin hangi yedekleme katmanlariyla korunacagini, backup retention pencerelerini, restore karar hiyerarsisini, disaster recovery sirasinda hangi adimlarin hangi duzende uygulanacagini ve uygulama-seviyesi restore ile altyapi-seviyesi backup restore arasindaki farki tanimlayan resmi operasyon ve disaster recovery belgesidir.

Bu belge su sorulara cevap verir:

- hangi veri ailesi backup kapsamindadir, hangisi bilincli olarak disaridadir?
- relational truth, object storage ve regenerable artefact'lar ayni sekilde mi korunur?
- accidental delete, sistemik veri bozulmasi ve provider kaybi ayni restore yoluyla mi ele alinir?
- soft delete penceresi varken backup restore ne zaman kullanilmaz?
- silme/purge talebi sonrasinda backup kopyasi olmasi ne anlama gelir, ne anlama gelmez?
- restore sonrasi queue, webhook, cache ve public trust state'i nasil stabilize edilir?

Bu belge, "snapshot acik olsun" notu degildir.  
Bu belge, verinin kurtarma mantigini ve kurtarma sinirlarini sabitleyen source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Bu urunde backup konusu yalnizca altyapi guvenligi degildir.  
Yanlis tasarlanmis backup/restore rejimi iki farkli tipte zarar uretir:

1. gercek kayipta veriyi geri getirememek
2. geri getirilmemesi gereken veriyi geri getirmek

Tipik bozulmalar:

1. soft-delete ile backup restore ayni sey sanilir ve gereksiz tam restore denenir
2. object storage variant kaybi icin tum veritabani geri alinir
3. purge edilmis creator verisi backup'ta var diye urune geri yuklenir
4. webhook dedupe tablosu restore edilmeden billing consumer yeniden acilir ve duplicate apply olusur
5. stale veya blocked source state'i restore sonrasi yanlis yorumlanir ve public trust bozulur

Bu belge bu nedenle yalniz "yedek var" demekle yetinmez;  
hangi durumda hangi yedekleme/geri yukleme yolunun kullanilacagini baglar.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icinde backup, uygulama-seviyesi geri alma dugmesi gibi kullanilmayacaktir; once entity'nin kendi lifecycle ve restore penceresi degerlendirilir, sonra gerekli ise veri ailesine uygun backup katmani secilir; canonical relational truth once kurtarilir, ardindan object storage pointer ve yeniden uretilebilir turevler senkronize edilir; purge edilmis veya policy geregi geri acilmasi yasak veri backup'ta bulunuyor olsa bile urunsel olarak restore edilmez.

Bu karar su sonuclari dogurur:

1. Backup restore, normal support talebinin varsayilan cozumu degildir.
2. `unpublish`, `archive`, `soft_delete` ve `restore` gibi urun akislari her zaman backup restore'dan once gelir.
3. DB restore ve object storage restore ayni operasyon degildir.
4. Regenerable turevler icin once yeniden uretim, sonra derin restore dusunulur.
5. Purge veya deletion policy backup retention ile override edilmez.

---

## 4. Temel kavramlar

### 4.1. Uygulama-seviyesi restore

Entity hala soft-delete veya archive penceresindeyse, geri alma urun davranisidir.  
Bu yol:

- uygulama state makinesi ile uyumludur
- audit izi birakir
- tekil entity geri donuslerinde tercih edilir

### 4.2. Backup restore

Disaster recovery veya sistemik veri bozulmasi durumunda, backup katmanindan veri kurtarmadir.

Bu yol:

- daha agirdir
- blast radius analizi ister
- queue, cache ve event replay riskleri uretir

### 4.3. Point-in-time recovery

Relational truth'u secilen bir zaman noktasina geri almadir.

Kullanim alani:

- operator kaynakli yaygin veri bozulmasi
- managed DB incident'i
- kritik tablo kaybi

### 4.4. Selective logical repair

Tum sistemi geri almadan, backup clone veya durable kayitlardan belirli entity setinin mantiksal olarak onarilmasidir.

Kullanim alani:

- tek workspace bozulmasi
- dar kapsamli publication veya placement kaybi
- yanlis script sonucu sinirli veri etkisi

### 4.5. Backup retention

Backup kopyasinin disaster recovery icin belirli sure saklanmasidir.

Kural:

Backup'ta tutuluyor olmak, kullaniciya geri acilabilir urun verisi hakki vermez.

---

## 5. Restore karar hiyerarsisi

Her veri kaybi veya bozulma olayinda su siralama zorunludur:

1. incident mi, support vakasi mi ayir
2. entity kendi lifecycle penceresinde mi kontrol et
3. turev veri mi, canonical truth mu ayir
4. blast radius ve policy kisitlarini belirle
5. sadece gerekli katmanda restore veya repair yap

### 5.1. Ilk soru: bu olay backup restore gerektiriyor mu?

Asagidaki durumlarda cevap genellikle `hayir`dir:

- page yanlislikla unpublished olduysa
- product soft-deleted durumdaysa
- image variant bozuldu ama original asset duruyorsa
- stale price state'i refresh ile duzelebilecekse

Asagidaki durumlarda cevap `muhtemelen evet` veya `degerlendirilir`dir:

- DB tablo ailesi bozulduysa
- object storage origin asset kaybi varsa
- PITR gerektiren operator/script hatasi olduysa
- provider kaynakli genis veri kaybi yasandiysa

### 5.2. Ikinci soru: restore policy olarak serbest mi?

Asagidaki durumlar restore'u sinirlar veya yasaklar:

- purge edilmis hesap/content
- takedown ile kalici kaldirilan public materyal
- privacy deletion sureci tamamlanmis actor verisi
- yasal olarak tutulabilir ama urune geri acilamaz finansal veya audit kayitlari

---

## 6. Veri aileleri ve backup kapsam modeli

Bu urunde backup stratejisi dort veri ailesine ayrilir:

1. canonical relational truth
2. durable operational truth
3. object/media truth
4. regenerable veya ephemeral turevler

### 6.1. Canonical relational truth

Kapsam:

- users, accounts, sessions
- workspaces, memberships, settings
- storefront, page, shelf, publication state
- product, product_source, placement
- disclosure ve trust state alanlari
- entitlements ve ownership-critical iliskiler

Bu aile urunun yasayan gercegidir.  
Kaybi en agir is etkisini uretir.

### 6.2. Durable operational truth

Kapsam:

- import jobs
- verification sessions
- webhook_events
- idempotency kayitlari
- workflow dedupe kayitlari
- outbox event kayitlari
- audit ve support action kayitlari

Bu aile supportability, replay guvenligi ve incident sonrasi teshis icin kritiktir.

### 6.3. Object/media truth

Kapsam:

- creator tarafindan secilmis original image asset'lari
- import edilen ve kabul edilen media origin dosyalari
- kalici asset variant'lari
- OG/share asset'lari, eger tek kaynaktan yeniden uretilemeyecek kadar ozel birlestirme tasiyorsa

Kural:

Object storage'taki binary ile DB'deki asset metadata ayni kurtarma penceresinde ele alinmazsa orphan veya broken pointer ortaya cikar.

### 6.4. Regenerable veya ephemeral turevler

Kapsam:

- cache katmani
- gecici extraction artefact'lari
- temporary fetched html veya render calisma dosyalari
- queue provider internal transient kayitlari
- image derivative'ler, original mevcutsa yeniden uretilebilir olanlar

Kural:

Bu ailede once yeniden uretim veya invalidation, backup restore'dan ustundur.

---

## 7. Nelerin backup'a girdigi ve girmedigi

| Veri ailesi | Backup kapsami | Restore tipi | Not |
| --- | --- | --- | --- |
| Core PostgreSQL verisi | tam | PITR + full snapshot + selective logical repair | ana source of truth |
| Audit/support olaylari | tam | PITR + selective repair | immutable karakter korunur |
| Webhook/idempotency kayitlari | tam | PITR + dikkatli replay kontrolu | duplicate apply riski yuksek |
| Original media asset'lari | tam | object restore + pointer dogrulama | origin kritik |
| Regenerable variant'lar | sinirli | once regen, origin eksigi surerse object restore | DB restore sebebi degil |
| CDN cache | yok | invalidation + yeniden isitma | backup sinifi degil |
| Temp processing dosyalari | yok veya kisa sureli | yeniden uretilir | kalici truth degil |
| Secret'lar | uygulama backup'inda yok | secret manager rotation/cold recovery | DB snapshot icine dahil edilmez |
| Preview/local ortam verisi | garanti verilmez | yeniden kurulum | DR hedefinin disinda |

---

## 8. Ortam bazli backup politikasi

### 8.1. Production

Production icin backup zorunludur.

Asgari beklenti:

- relational DB icin surekli PITR kabiliyeti
- gunluk tam snapshot
- object storage origin asset korumasi
- restore testi ile dogrulama

### 8.2. Staging

Staging production kadar uzun retention tasimaz.  
Ama release rehearsal ve restore tatbikati icin yeterli snapshot penceresi bulunur.

Asgari beklenti:

- gunluk DB snapshot
- kisa sureli object storage korumasi
- test restore senaryolari

### 8.3. Preview

Preview ortamlar ephemeraldir.

Kurallar:

1. preview icin production-grade DR taahhudu verilmez
2. preview bozulursa varsayilan hareket yeniden olusturmaktir
3. preview, production backup kaynaklarini kullanmaz

### 8.4. Local

Local ortam bireysel sorumluluktadir.  
Kurumsal DR taahhudu yoktur.

---

## 9. Backup mekanizmalari ve hedefler

### 9.1. Relational DB

Zorunlu katmanlar:

1. surekli write-ahead log tabanli point-in-time recovery
2. gunluk tam snapshot
3. ayri restore hedefi icin clone acabilme

Production hedefleri:

- hedef RPO: 15 dakika veya daha iyi
- hedef RTO: genis sistemik DB restore icin 90 dakika veya daha iyi
- tek workspace mantiksal repair icin karar suresi: 30 dakika icinde

Not:

Bu hedefler backup sisteminin varligini degil, dogrulanmis kurtarma yetenegini ifade eder.

### 9.2. Object storage

Zorunlu katmanlar:

1. original asset versioning veya esdeger durable kopya
2. kalici asset metadata ile hash dogrulama
3. restore sonrasi orphan taramasi

Production hedefleri:

- original asset kaybi icin RPO: 24 saatten kotu olamaz
- object restore sonrasi pointer reconciliation: 4 saat icinde tamamlanir

### 9.3. Audit ve billing verisi

Bu aileler relational truth icinde korunur.  
Ek beklenti:

- ayni recovery point ile birlikte geri alinmalari
- kismi restore sirasinda zaman kaymasi yaratmamasi

### 9.4. Regenerable turevler

Bu ailede hedef:

- restore degil, kontrollu yeniden uretim
- cache invalidation
- gerekiyorsa job replay

---

## 10. Backup retention pencereleri

Bu pencereler uygulama lifecycle suresi degil, disaster recovery saklama penceresidir.

| Katman | Production retention | Staging retention | Not |
| --- | --- | --- | --- |
| DB PITR log'lari | 35 gun | 14 gun | geriye donuk zaman secimi icin |
| DB full snapshot | 35 gun icinde gunluk | 14 gun icinde gunluk | aylik arsim zorunlu degil |
| Object origin version/kopya | 30 gun | 14 gun | purge policy override etmez |
| Regenerable variant kopyalari | 14 gun | 7 gun | regen tercih edilir |
| Temp artefact | 7 gun veya daha kisa | 7 gun veya daha kisa | supportability ihtiyaci kadar |

Kural:

Retention penceresi sona eren backup kopyasi tekrar acilamaz kabul edilir.  
Sonsuz backup arsivi bu urunun standardi degildir.

---

## 11. Restore uygunluk kurallari

### 11.1. Backup restore ne zaman uygundur?

Asagidaki vakalarda uygundur:

1. managed DB incident'i veya veri kaybi
2. operator script'i ile yaygin yanlis update/delete
3. object storage origin asset kaybi
4. bozulmus tablo ailesi nedeniyle urun truth'unun onarilamamasi

### 11.2. Backup restore ne zaman uygun degildir?

Asagidaki vakalarda backup restore varsayilan cozum olamaz:

1. tekil creator'in sildigi page'i geri getirme istegi, soft-delete penceresi duruyorsa
2. stale refresh sorunu
3. cache kaynakli eski gorsel
4. import sonucu yanlis image secimi
5. support'un hizli sonuc almak istemesi

### 11.3. Policy olarak yasak restore'lar

Asagidaki vakalar backup'ta bulunsa bile urune geri acilmaz:

1. privacy deletion sureci tamamlanmis account verisi
2. kalici takedown ile kaldirilan public materyal
3. purge edilmis creator content'i, yasal veya guvenlik acisindan geri acilmasi yasaklanmissa
4. secret veya credential verisi

---

## 12. Restore oncesi zorunlu kararlar

Her restore operasyonundan once asgari su kararlar yazili hale getirilir:

1. etkilenen veri ailesi
2. blast radius
3. secilen recovery point
4. restore tipi: tam, kismi, mantiksal repair, object restore
5. expected user impact
6. replay/duplicate riski
7. policy/retention kontrol sonucu

Kural:

Recovery point secmeden "son saglam yedege donelim" yaklasimi kabul edilmez.

---

## 13. Restore sirasi

Restore operasyonlari su sirayi izler:

1. yeni yazma akisini sinirla veya dondur
2. ilgili backup/clone ortamini olustur
3. canonical relational truth'u dogrula
4. object storage pointer ve binary durumunu esle
5. queue/webhook apply akislarini kontrollu kapida tut
6. cache ve derived state'leri yeniden kur
7. public ve creator akislarini kademe kademe ac

### 13.1. Yazma akisini sinirlama

Amac:

- daha fazla veri drift'ini engellemek
- restore sonrasi reconciliation'yi kolaylastirmak

Yontemler:

- belirli write route'lari maintenance moduna almak
- import create veya billing apply'i gecici dondurmak
- operator-only command akisini sinirlamak

### 13.2. Clone uzerinde dogrulama

Production'u dogrudan ustune yazmak yasaktir.  
Ilk dogrulama clone veya ayrik restore hedefinde yapilir.

Zorunlu kontroller:

1. principal ve workspace sayisi
2. storefront/page/product toplamlarinin anormal sapma gostermemesi
3. billing ve entitlement tutarliligi
4. webhook/idempotency kayit varligi

### 13.3. Canonical truth dogrulamasi

Restore edilen relational state icin asgari dogrulamalar:

1. owner/editor erisimi aciliyor mu
2. storefront -> page -> placement iliskileri saglam mi
3. selected source state'leri mantikli mi
4. audit ve support action kayitlari dogru zaman serisine sahip mi

### 13.4. Object pointer ve binary uyumu

DB'de asset metadata olup storage'da binary yoksa:

- pointer broken sayilir
- publicte rastgele bos gorsel yerine controlled unavailable state gosterilir
- regen veya object restore is akisi tetiklenir

### 13.5. Queue ve webhook kontrollu acilis

Restore sonrasi tum worker'lari ayni anda acmak yasaktir.

Sira:

1. ingestion kapida tutulur
2. durable tablolar dogrulanir
3. duplicate/replay riski olan consumer'lar en son ve sinif bazli cohort ile acilir
4. backlog kontrollu sekilde eritir

---

## 14. Veri ailesi bazli restore stratejileri

## 14.1. Auth, workspace ve membership

Bu aile once dogrulanir; cunku diger actor-scoped recovery'lerin temeli budur.

Kontroller:

1. owner login ve session yenileme
2. membership iliskileri
3. suspended/deleted actor state'leri

Yasak:

Purged account'i backup'tan geri acmak.

## 14.2. Storefront, page ve publication state

Bu aile public gorunurlugu etkiler.

Kontroller:

1. handle quarantine kurallari korunmus mu
2. unpublished ve archived state'ler karismis mi
3. removed/takedown state'i yanlis acilmis mi

Yasak:

Takedown ile kaldirilmis page'i publicte yeniden yayinlamak.

## 14.3. Product, source ve placement graph

Bu aile creator utility ve public trust cekirdegidir.

Kontroller:

1. placement orphan mi
2. selected source ve fallback source state'i tutarli mi
3. stale veya blocked source restore sonrasi active gibi davranmiyor mu
4. duplicate product cluster'i restore ile artiyor mu

## 14.4. Import jobs ve verification sessions

Bu aile supportability icin gereklidir.

Restore ilkeleri:

1. tarihi job kayitlari korunur
2. `in_progress` gorunen eski job'lar dogrudan devam ediyor sayilmaz
3. restore sonrasi bu kayitlar reconcile edilerek `failed`, `cancelled` veya `needs_retry_review` benzeri kesin state'e cekilir

## 14.5. Webhook, idempotency ve outbox

Bu aile en yuksek duplicate riskini tasir.

Kurallar:

1. billing veya domain webhook consumer'i, dedupe kayitlari dogrulanmadan acilmaz
2. outbox event tablosu restore sonrasi once fark analiziyle incelenir
3. replay gerekiyorsa event bazli, sinifli ve auditli yapilir

## 14.6. Media ve OG asset'lari

Kurallar:

1. original asset varsa variant'lar once yeniden uretilir
2. OG asset kaybi public route restore'unu tek basina bloke etmez
3. creator tarafindan manuel secilmis primary image state'i korunur

---

## 15. Senaryo bazli kararlar

## 15.1. Senaryo: Creator page'i yanlislikla sildi

Kosullar:

- page `soft_deleted`
- restore penceresi acik

Beklenen davranis:

1. backup restore uygulanmaz
2. uygulama-seviyesi restore akisi kullanilir
3. page publication, cache invalidation ve audit izi standart akistan ilerler

## 15.2. Senaryo: Yanlis script bir workspace'in placement graph'ini bozdu

Kosullar:

- dar blast radius
- canonical DB truth etkilenmis

Beklenen davranis:

1. once clone uzerinde recovery point bulunur
2. full DB restore yerine selective logical repair planlanir
3. repair sonrasi placement sayisi ve source secimleri dogrulanir

## 15.3. Senaryo: Regional DB incident'i

Beklenen davranis:

1. incident ilan edilir
2. uygun PITR noktasi secilir
3. clone dogrulanir
4. write akislar kontrollu durdurulur
5. cutover sonrasi cache invalidation ve worker warm-up yapilir

## 15.4. Senaryo: Object storage origin asset kaybi

Beklenen davranis:

1. asset metadata sayimi ve hash listesi cikartilir
2. object restore veya version rollback uygulanir
3. broken pointer kalanlar icin controlled unavailable state kullanilir
4. variant ve cache katmani yeniden uretilir

## 15.5. Senaryo: Webhook dedupe tablosu kayboldu

Beklenen davranis:

1. ilgili consumer durdurulur
2. raw `webhook_events` ve provider event id kayitlari kurtarilir
3. dedupe state restore veya kontrollu rebuild edilir
4. billing/domain apply yolu ancak tekrar dogrulamadan sonra acilir

## 15.6. Senaryo: Privacy deletion tamamlanmis account icin geri yukleme talebi geldi

Beklenen davranis:

1. backup kopyasi olsa bile restore reddedilir
2. support bu talebi normal recovery gibi ele almaz
3. compliance policy cevabi verilir

---

## 16. Restore sonrasi stabilizasyon adimlari

Restore teknik olarak tamamlandiginda sistem hemen "normal" sayilmaz.  
Su stabilizasyon adimlari zorunludur:

1. critical route smoke testi
2. selected source trust state audit'i
3. queue backlog ve worker latency kontrolu
4. webhook duplicate/replay metriği kontrolu
5. public cache/CDN invalidation
6. support bilgilendirmesi

### 16.1. Critical smoke seti

Asgari smoke kontroller:

1. owner login
2. creator dashboard acilisi
3. public storefront render
4. bir page detay route'u
5. import create kapaliysa bakim copy'si dogru mu
6. billing write veya webhook path kontrollu halde mi

### 16.2. Data integrity kontrol seti

Asgari veri kontrolleri:

1. orphan placement sayisi
2. missing asset pointer sayisi
3. stale source oraninda anormal sicrama
4. failed publication count
5. parked webhook count

### 16.3. Controlled reopen politikasi

Tum yazma akislarini bir anda acmak yerine:

1. read-only public acilir
2. creator read/write sinirli cohort ile acilir
3. import ve webhook consumer kademeli acilir
4. tam acilis izleme penceresi sonrasinda yapilir

---

## 17. Support, ops ve compliance rol ayrimi

### 17.1. Support

Yapabilir:

- kullanici etkisini toplamak
- restore status bilgisini iletmek
- application-level restore penceresini kontrol etmek

Yapamaz:

- backup restore emri vermek
- purge edilmis veriyi geri acma vaadi vermek
- recovery point secmek

### 17.2. Ops / platform

Yapabilir:

- backup health izlemek
- restore tatbikati yapmak
- incident altinda teknik restore planini uygulamak

### 17.3. Compliance / security

Zorunlu dahil olur:

- privacy deletion sonrasi restore talebi
- takedown ile kaldirilmis icerigin geri acilma riski
- audit veya billing geriye donuk duzeltme gerektiren olaylar

---

## 18. Backup ve lifecycle iliskisi

Bu belge ile `[35-data-lifecycle-retention-and-deletion-rules.md](/Users/alperenkarip/Projects/product-showcase/project/domain/35-data-lifecycle-retention-and-deletion-rules.md)` birlikte okunmalidir.

Baglayici ilkeler:

1. entity restore hakki lifecycle belgesinden gelir
2. backup retention suresi disaster recovery ihtiyacindan gelir
3. biri digerini override etmez

Ornek:

- product 30 gun soft-delete penceresinde restore edilebilir olabilir
- ayni product backup'ta 35 gun daha duruyor olabilir
- fakat purge gerceklestikten sonra urunsel restore hakki kapanmis olabilir

Bu uc cizgi karistirilmayacaktir.

---

## 19. Anti-pattern'ler

Asagidaki davranislar bu belgeye aykiridir:

1. backup'i support aracina donusturmek
2. DB restore ile cache sorununu cozmeye calismak
3. secret'lari app backup kapsaminda tutmak
4. purge edilmis veya takedown edilmis veriyi gizlice geri yuklemek
5. restore sonrasi webhook consumer'i dogrulama yapmadan acmak
6. clone uzerinde dogrulamadan production state'i degistirmek
7. regen ile duzelecek variant kaybi icin origin veya DB'yi geri almak

---

## 20. Restore tatbikati ve kanit zorunlulugu

Bu belge kagit uzerinde kalamaz.  
Launch oncesi ve sonrasinda restore tatbikati zorunludur.

Asgari disiplin:

1. production-benzeri staging restore tatbikati
2. DB PITR dogrulamasi
3. object storage origin restore dogrulamasi
4. webhook/idempotency kontrollu reopen provasi
5. smoke test ve veri butunlugu raporu

Siklik:

- launch oncesi en az bir tam prova
- sonrasinda ceyreklik restore tatbikati
- kritik schema veya provider degisikligi sonrasinda hedefli tekrar prova

---

## 21. Basari kriterleri

Bu belge basarili sayilmak icin su kosullar saglanmalidir:

1. ekip backup'i uygulama-seviyesi restore ile karistirmiyor olmalidir
2. production relational truth icin belirlenen RPO/RTO hedefleri kanitli olmalidir
3. object storage kaybi durumunda restore veya regen sirasi net uygulanabilmelidir
4. purge edilmis veya policy geregi kapali verinin geri acilmayacagi tum roller tarafindan bilinmelidir
5. restore sonrasi queue/webhook/cache stabilizasyon akisi ezbersiz uygulanabilmelidir

---

## 22. Sonraki belgelere emirler

Bu belge asagidaki belgeler icin baglayicidir:

1. `101-runbooks.md`, restore ve data-loss semptomlari icin ayri runbook aileleri cikaracaktir.
2. `102-incident-response-project-layer.md`, data loss ve trust bozulmasi olaylarinda bu belgedeki restore karar hiyerarsisini incident protokolune baglayacaktir.
3. `103-support-playbooks.md`, backup restore vaadi verilemeyecek issue tiplerini bu belgeyle uyumlu tutacaktir.
4. `88-release-readiness-checklist.md`, restore tatbikati kaniti olmadan launch gate vermez.
