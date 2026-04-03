---
id: PERSONAS-JOBS-PRIMARY-USE-CASES-001
title: Personas, Jobs and Primary Use Cases
doc_type: research_spec
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-VISION-THESIS-001
  - PRODUCT-SCOPE-NON-GOALS-001
blocks:
  - DOMAIN-GLOSSARY
  - CREATOR-WORKFLOWS
  - VIEWER-EXPERIENCE-SPEC
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL
  - SCREEN-INVENTORY
  - SUPPORT-PLAYBOOKS
---

# Personas, Jobs and Primary Use Cases

## 1. Bu belge nedir?

Bu belge, `product-showcase` urunundeki actor'leri, bu actor'lerin asil ihtiyaclarini, korkularini, karar anlarini, normal ve bozulma senaryolarini ve urunun actor bazli kabul kriterlerini tanimlayan resmi actor ve kullanim belgesidir.

Bu belge su sorulara cevap verir:

- Bu urunun gercek kullanicilari kimlerdir?
- Her actor urunden hangi isi cozemek ister?
- Hangi actor birincildir, hangileri ikincil ama zorunludur?
- Hangi actor hangi hata tipine daha dusuk tolerans gosterir?
- Hangi actor'ler arasinda gerilim vardir?
- Hangi kullanim senaryolari launch once mutlaka calismalidir?

Bu belge, "kullanici" kelimesini tekil ve soyut kullanmayi yasaklar.

Bu urunde "kullanici" dendiginde kimden bahsedildigi net olmak zorundadir:

- creator owner mi,
- creator editor mu,
- public viewer mi,
- ops/admin mi,
- support mu.

Bu ayrim net yazilmazsa sonraki belgeler actor'ler arasi farki siler ve urun kararlarinda karmasa olusur.

---

## 2. Bu belge neden kritiktir?

Bu urun bir actor icin tasarlanmis gibi gorunse de, degeri ancak actor'ler arasi zincir calistiginda ortaya cikar.

Ornek zincir:

1. Creator URL ile urun ekler
2. Import pipeline veriyi ceker
3. Creator verify eder
4. Viewer publicte tuketir
5. Bir sorun varsa support veya ops devreye girer

Bu zincirin herhangi bir halkasi actor bazli dusunulmezse:

- creator akisi guzel olur ama viewer urunu anlayamaz
- viewer deneyimi guzel olur ama creator urun eklemekten bikar
- creator ve viewer iyi olur ama ops failure'i goremez
- support issue tiplerini ayiramaz

Bu nedenle actor'ler sadece "hedef kitle" olarak degil, urunun birbirine bagli calisma zinciri olarak ele alinmalidir.

Bu belge olmadan yaygin hatalar sunlardir:

### 2.1. Tum urunu creator etrafinda kurup viewer degerini zayiflatmak

Bu hata sonucunda:

- public page creator vanity page'e doner
- urun kartlari zayiflar
- trust ve context ikinci plana duser

### 2.2. Viewer icin asiri sade deneyim kurgularken creator araclarini zorlastirmak

Bu hata sonucunda:

- creator her is icin uzun form gormeye baslar
- product library ve reuse davranisi zayiflar

### 2.3. Ops ve support actor'lerini "sonra bakariz" diye ele almak

Bu hata sonucunda:

- issue tipleri karisir
- merchant bazli pattern'ler gec fark edilir
- support tutarsiz cevap verir

Bu belge, bu actor korlugunu bastan engeller.

---

## 3. Actor haritasinin ana karari

Bu urun icin actor haritasi su sekildedir:

1. Birincil actor: Creator Owner
2. Ikincil ama zorunlu actor: Public Viewer
3. Ikincil ama zorunlu actor: Creator Editor / Assistant
4. Operasyonel actor: Ops / Admin
5. Operasyonel actor: Support

Bu siralama onemlidir.

Bu siralama su anlama gelir:

- urunun en cok optimize edilecegi actor `Creator Owner`'dir
- ama public viewer deneyimi ikinci sinif degildir
- editor, ops ve support launch sonrasi dusunulecek actor'ler degildir

Bu urunde basari, yalnizca creator memnuniyetine bakilarak okunmaz.  
Basari, creator'in hizli yayin yapmasi ile viewer'in guvenli tuketim yapmasi arasindaki denge uzerinden okunur.

---

## 4. Actor'ler arasi iliski modeli

Bu urunde actor'ler birbirinden bagimsiz degildir.  
Her actor diger actor icin bir on-kosul veya sonuc uretir.

### 4.1. Creator Owner -> Viewer

Creator owner:

- dogru product verisi,
- dogru context,
- dogru disclosure,
- temiz page yapisi

uretirse viewer deger gorur.

### 4.2. Creator Editor -> Creator Owner

Editor:

- owner adina operasyonel yuk alir
- ama sahiplik ve kritik karar alanlarini gecmemelidir

### 4.3. Ops -> Creator ve Viewer

Ops:

- import kalitesini,
- broken link davranisini,
- unsupported merchant stratejisini,
- unsafe link kontrolunu

yoneterek hem creator hem viewer guvenini dolayli olarak korur.

### 4.4. Support -> Creator

Support:

- issue turunu dogru siniflayamazsa
- creator yanlis fallback ile zaman kaybeder
- urunun guvenilirlik algisi duser

Bu nedenle support bir "yardim masasi" degil, urun deneyiminin uzantisi kabul edilir.

---

## 5. Persona A: Creator Owner

### 5.1. Kimdir?

Creator Owner:

- storefront'un asil sahibidir
- urunun en sik kullanim davranisini tasir
- urun tavsiyesinin dis dunyadaki guven kaynagidir
- genellikle sosyal platformlarda aktif icerik uretir

Bu actor'un tipik profili:

- takipcilerinden duzenli urun sorulari alir
- ayni urunu birden fazla icerikte tekrar kullanir
- tam e-ticaret kurmak istemez
- guzel ama hafif recommendation presence ister
- operasyonu buyutmeden tavsiyelerini daha duzenli sunmak ister

### 5.2. Bu actor urune ne zaman gelir?

Creator Owner urune genelde su tetikleyicilerle gelir:

1. "Bu videoda ne kullandin?" sorulari tekrar tekrar artmistir
2. Elindeki bio link araci yetersiz kalmaya baslamistir
3. Ayni urunleri farkli postlarda tekrar tekrar anlatmaktan yorulmustur
4. Tavsiyeleri daha guvenilir ve toplu gostermek ister
5. Affiliate veya sponsorlu iliskilerini duzenli gostermek ister ama reklam gibi hissettirmek istemez

### 5.3. Bu actor neyi basarmak ister?

Creator Owner icin asil "job" su sekilde yazilmalidir:

> Yeni veya mevcut iceriklerimde gecen urunleri, tekrar tekrar veri girmeden, dogru baglamla ve guven veren bir public sayfada saniyeler seviyesinde yayina alabilmek istiyorum.

Bu job alt parcalara ayrilir:

1. hizli urun ekleme
2. minimum manuel veri girisi
3. tekrar kullanilabilir library
4. context page yayinlama
5. guvenli disclosure gosterimi
6. stale ve broken bilgi riskini azaltma

### 5.4. Bu actor'un en sik yaptigi isler nelerdir?

Gunluk / haftalik frekansta beklenen isler:

- yeni URL yapistirma
- import sonucunu kontrol etme
- urunu shelf veya content page'e ekleme
- ayni urunu farkli context'te kullanma
- kucuk duzenleme yapma
- yeni icerik icin page acma

Daha dusuk frekansta ama kritik isler:

- storefront'u yeniden duzenleme
- template / preset secimi
- archive veya remove karari
- stale veya broken link duzeltme

### 5.5. Bu actor'un asil korkulari nelerdir?

1. Yanlis urun import edilmesi
2. Yanlis gorsel veya yanlis merchant cikmasi
3. Her urun icin form doldurmak zorunda kalmak
4. Ayni urunu farkli yerlerde ayri ayri guncellemek
5. Yanlis disclosure yüzünden guven kaybetmek
6. Bir urunu silerken diger sayfalari da fark etmeden bozmak

### 5.6. Bu actor'un hata toleransi dusuk oldugu alanlar nelerdir?

Creator Owner su alanlarda dusuk hata toleransi gosterir:

- import accuracy
- duplicate olusumu
- publish sonrasi public görünüm
- disclosure hatasi
- remove/archive etkisinin belirsizligi

Bu actor su alanlarda bir miktar tolerans gosterir:

- gelismis analytics'in eksigi
- daha derin customisation'in olmayisi

### 5.7. Bu actor icin kabul edilemez deneyimler nelerdir?

- "URL yapistir, sonra 10+ alan doldur"
- unsupported merchant'ta cikissiz hata
- ayni URL'den durmadan yeni product olusmasi
- stale bilgi oldugu halde sistemin sessiz kalmasi
- product/library/placement ayriminin karisik olmasi

### 5.8. Bu actor icin launch once minimum kabul kriteri nedir?

Launch once creator owner:

1. Desteklenen bir merchant URL'sini import edebilmeli
2. Verification UI'da kritik alanlari dogrulayabilmeli
3. Urunu library'ye kaydedebilmeli
4. Shelf veya content page'e ekleyip publish edebilmeli
5. Ayni urunu ikinci kez kullanirken reuse gorebilmeli

Bu bes adimdan biri kıriksa creator owner icin urun cekirdegi eksik sayilir.

---

## 6. Persona B: Creator Editor / Assistant

### 6.1. Kimdir?

Creator Editor:

- owner adina operasyonel is yapan
- ama account sahibi olmayan
- curation, siralama ve hazirlik islerinde destek veren roldur

Bu rol gercek hayatta su tiplerde gorulebilir:

- creator'in asistanı
- editor arkadası
- ajans ya da ekip ici operasyon kisisi

### 6.2. Bu actor neden onemlidir?

Ilk faz owner-first olsa da, editor davranisini hesaba katmamak iki problem yaratir:

1. owner'in ustune tum is yuklenir
2. permission sistemi sonradan aceleyle eklenir ve kirik olur

Bu actor launch'ta tam enterprise collaboration istemez; ama role clarity ister.

### 6.3. Bu actor neyi basarmak ister?

> Owner adina urunleri, shelf'leri ve content page'leri hizla hazirlamak istiyorum; ama sahiplik, billing veya geri donusu zor ayarlari yanlislikla degistirmek istemiyorum.

### 6.4. Bu actor'un tipik gorevleri nelerdir?

- product library icinde arama
- mevcut urunleri yeni context'lere ekleme
- siralama ve note guncelleme
- draft content page hazirlama
- verification sonrasi owner'a review birakma

### 6.5. Bu actor'un ana korkulari nelerdir?

1. Yetki siniri belirsizligi
2. Yanlis sayfada yayinlama
3. Disclosure veya merchant kaynagini yanlis yorumlama
4. Yanlis urunu silme veya archive etme
5. Owner'in kritik ayar alanlarina istemeden dokunma

### 6.6. Bu actor'un ihtiyac duydugu guardrail'ler nelerdir?

- net role-based UI
- owner'a ayrilmis kritik aksiyonlar
- bulk edit tarafinda geri alinabilir davranis
- remove / archive oncesi etki alani gosteren confirmation

### 6.7. Bu actor icin kabul edilemez deneyimler nelerdir?

- owner ve editor yetkilerinin ayni menude karismasi
- draft ile publish durumunun net ayirt edilmemesi
- bulk edit yaparken etkiledigi placement'lari gorememek
- kendi yetkisinin disindaki ayarlarla ayni ekrana maruz kalmak

### 6.8. Bu actor icin launch once minimum kabul kriteri nedir?

Editor:

1. Product library'de arama yapabilmeli
2. Shelf veya content page duzenleyebilmeli
3. Draft hazirlayabilmeli
4. Owner'a ayrilmis ayarlari degistirememeli

---

## 7. Persona C: Public Viewer

### 7.1. Kimdir?

Public Viewer:

- cogu zaman account acmayan
- sosyal platformdan gelen
- mobilde olan
- tek amaci ilgili urunu veya urun setini bulmak olan ziyaretcidir

Bu actor shopping meraklisi genel browse kullanicisi degildir.  
Genellikle belirli bir creator baglamindan gelir.

### 7.2. Bu actor urune ne zaman gelir?

Tipik tetikleyiciler:

1. Creator bir video, reel, story veya post paylasmistir
2. Viewer belirli bir urunu merak etmistir
3. Viewer toplu bir setup veya rutin listesini gormek istemektedir
4. Creator'in tavsiyesine guvenmektedir ama merchant'a gitmeden once daha fazla bilgi ister

### 7.3. Bu actor neyi basarmak ister?

> Creator'in soz ettigi urunu veya urun setini tek yerde, ne oldugunu ve neden onerildigini anlayarak gormek; merchant'a gitmeden once yeterli guven bilgisini almak istiyorum.

### 7.4. Bu actor'un en sik gorevleri nelerdir?

- social linke tiklamak
- storefront veya content page'i acmak
- urun kartini incelemek
- note ve disclosure okumak
- dis merchant linkine cikmak

### 7.5. Bu actor'un temel karar sorulari nelerdir?

Viewer urun sayfasinda su sorulara cevap arar:

1. Bu tam olarak hangi urun?
2. Bu urun hangi baglamda oneriliyor?
3. Creator bunu gercekten kullaniyor mu?
4. Bu sponsorlu mu yoksa affiliate mi?
5. Fiyat bilgisi varsa guncel mi?
6. Bu linke tiklarsam nereye gidecegim?

### 7.6. Bu actor'un en buyuk hayal kirikliklari nelerdir?

1. Sadece link listesi gormek
2. Buyuk hero alanlari ama zayif urun kartlari
3. Context bilgisinin olmamasi
4. Price ve disclosure bilgisinin belirsiz olmasi
5. Sayfanin yavas veya spam gibi hissettirmesi
6. Kirik veya kaldirilmis sayfada neden-sonuc gorememek

### 7.7. Bu actor'un hata toleransi dusuk oldugu alanlar nelerdir?

- public hiz
- urun karti okunabilirligi
- trust/disclosure gorunurlugu
- merchant cikisinin tahmin edilebilir olmasi

### 7.8. Bu actor icin kabul edilemez deneyimler nelerdir?

- creator biyosunun urunleri asagi itmesi
- urun kartlarinin cok az bilgi vermesi
- stale price bilgisinin hic gosterilmemesi
- page tipinin anlasilmamasi
- broken link'te aciklama olmamasi

### 7.9. Bu actor icin launch once minimum kabul kriteri nedir?

Viewer:

1. Storefront veya content page baglamini anlayabilmeli
2. Product kartinda temel karar bilgisini gorebilmeli
3. Disclosure ve stale/missing price sinyalini ayirt edebilmeli
4. Mobilde kabul edilebilir hizda deneyim yasamali

---

## 8. Persona D: Ops / Admin

### 8.1. Kimdir?

Ops / Admin:

- import kalitesini izleyen
- merchant support tier'larini yoneten
- broken link, stale veri ve unsafe link pattern'lerini takip eden
- gerektiğinde retry, cooldown veya block karari veren ic roldur

### 8.2. Bu actor neden launch once gereklidir?

Ops'u sonraya birakmak su yanlis varsayima dayanir:

> "Sorun olursa engineering bakar."

Bu varsayim yanlistir.  
Cunku urunun pek cok sorunu:

- teknik crash degil,
- kalite pattern'i,
- merchant support siniri,
- trust regression,
- stale veri birikmesi

sekilde ortaya cikar.

Ops actor'u olmadan bu pattern'ler adlandirilamaz.

### 8.3. Bu actor neyi basarmak ister?

> Import veya guvenlik davranisinda bozulma oldugunda, olay engineering'e yazilmadan once sorunun ne oldugunu, hangi sinifa girdigini ve ilk aksiyonun ne olmasi gerektigini gorebilmek istiyorum.

### 8.4. Bu actor'un tipik gorevleri nelerdir?

- import failure inceleme
- merchant bazli support tier guncelleme
- repeated timeout veya parse hatalarini ayiklama
- broken link spike gormek
- unsafe URL / domain olaylarini incelemek

### 8.5. Bu actor'un ana riskleri nelerdir?

1. Failure reason gorunmezligi
2. Import trail'in eksik olmasi
3. Low-confidence import ile unsupported merchant'in karismasi
4. Support'un issue tiplerini yanlis siniflamasi

### 8.6. Bu actor hangi verileri gormek zorundadir?

Asgari olarak:

- submitted URL
- canonical URL
- merchant
- support tier
- extractor path
- confidence
- failure reason
- creator review sonucu

### 8.7. Bu actor icin kabul edilemez deneyimler nelerdir?

- issue tipinin "unknown error" olarak kalmasi
- ayni problem tekrar ederken trend gorunmemesi
- blocked domain ile parsing hatasinin ayni yerde erimesi
- broken link artisini ancak kullanici sikayetiyle fark etmek

### 8.8. Bu actor icin launch once minimum kabul kriteri nedir?

Ops:

1. Import failure'i issue type bazli gorebilmeli
2. Merchant tier baglamini gorebilmeli
3. Retry veya escalation kararini destekleyecek trail'e sahip olmali
4. Unsafe link olayini diger import sorunlarindan ayirabilmeli

---

## 9. Persona E: Support

### 9.1. Kimdir?

Support:

- creator ve bazen viewer tarafindan gelen issue'lari ilk hat seviyesinde ele alan
- problemi sade dille aciklayan
- dogru fallback veya escalation yolunu secen roldur

### 9.2. Bu actor neden urunun parcasidir?

Support sadece operasyonel fonksiyon degildir.  
Support'un kalitesi:

- creator'in urune guvenini
- fallback anlarindaki memnuniyeti
- unsupported merchant algisini
- stale veya broken link olaylarinin duzelme hizini

dogrudan etkiler.

### 9.3. Bu actor neyi basarmak ister?

> "Linkim calismiyor" veya "yanlis urun geldi" diyen creator'a, sorunun ne oldugunu hizla ayirip teknik detaya bogmadan dogru adimi vermek istiyorum.

### 9.4. Bu actor'un tipik gorevleri nelerdir?

- issue intake
- issue type classification
- standard response secimi
- creator'i manual correction / retry / wait / escalation akislari arasinda yonlendirme

### 9.5. Bu actor'un ana riskleri nelerdir?

1. Unsupported merchant ile parser kalitesini karistirmak
2. Broken link ile stale price'i ayni issue gibi ele almak
3. Creator'e yanlis neden sunmak
4. Ayni issue tipi icin tutarsiz cevap vermek

### 9.6. Bu actor hangi issue tiplerini ayirabilmelidir?

Asgari olarak:

- unsupported merchant
- low-confidence extraction
- wrong image / wrong title
- duplicate confusion
- broken outbound link
- stale / missing price
- disclosure mismatch
- blocked / unsafe link

### 9.7. Bu actor icin kabul edilemez deneyimler nelerdir?

- failure trail gorememe
- issue tiplerinin tek sepet halinde durmasi
- escalation koşullarinin yazili olmamasi
- creator'e "tekrar dene" disinda anlamli yol verememek

### 9.8. Bu actor icin launch once minimum kabul kriteri nedir?

Support:

1. En sik gelen issue tiplerini ayirabilmeli
2. Her issue tipi icin standard yanit sahibi olmali
3. Hangi durumda ops'e, hangi durumda engineering'e gidecegini bilmelidir

---

## 10. Actor bazli ana kullanim fazlari

Bu urunde actor davranisi yalnizca tek tek ekranlarla degil, fazlarla anlasilir.

### 10.1. Faz A: Setup

Actor merkezi:

- Creator Owner

Kritik isler:

- account
- handle
- storefront baslangici
- ilk shelf/page
- ilk urun import'u

### 10.2. Faz B: Repeat publishing

Actor merkezi:

- Creator Owner
- Creator Editor

Kritik isler:

- yeni urun ekleme
- mevcut urun reuse
- yeni content page hazirlama
- siralama ve note duzenleme

### 10.3. Faz C: Public consumption

Actor merkezi:

- Viewer

Kritik isler:

- context'i anlama
- urunu bulma
- trust sinyalini okuma
- merchant'a cikma

### 10.4. Faz D: Failure and recovery

Actor merkezi:

- Creator Owner
- Support
- Ops

Kritik isler:

- issue classification
- retry / correction / fallback
- broken link veya stale veri giderme

---

## 11. Primary use case seti

Bu bolumde launch once mutlaka desteklenmesi gereken ana kullanim senaryolari actor bazli tanimlanir.

### 11.1. Use case 1: Creator Owner ilk urununu yayina alir

Normal akis:

1. account / giris
2. handle secimi
3. temel storefront olusumu
4. URL yapistirma
5. verification
6. shelf veya content page secimi
7. publish

Alternatif akislar:

- handle dolu
- import confidence dusuk
- price bilgisi gelmedi
- ayni URL daha once import edilmis

Bozulma akislar:

- unsupported merchant
- timeout
- wrong image
- auth callback failure

Beklenen sistem davranisi:

- creator cikissiz kalmaz
- import bozulursa fallback gorur
- duplicate varsa reuse onerisi alir

### 11.2. Use case 2: Creator mevcut urunu yeni bir content page'e ekler

Normal akis:

1. content page acar
2. library'de urunu arar
3. secip placement olusturur
4. note veya custom title ekler
5. publish eder

Alternatif akis:

- product library'de birden fazla benzer urun vardir
- ilgili urun archive durumundadir

Bozulma akis:

- editor yetkisi yetersiz
- content page draft degil, halihazirda yayinlidir ve degisiklik etkisi sorulur

Beklenen davranis:

- product ve placement farki acik olur
- mevcut product'in kopyasi olusturulmaz

### 11.3. Use case 3: Viewer sosyal linkten belirli urunu bulur

Normal akis:

1. content page veya storefront'a gelir
2. context'i anlar
3. product kartina bakar
4. trust/disclosure okur
5. merchant'a gider

Alternatif akis:

- urun price'sizdir
- page archived content'e referans vermektedir

Bozulma akis:

- merchant link broken
- urun kaldirilmistir

Beklenen davranis:

- viewer bos veya anlamsiz sayfa gormez
- alternatif / related path varsa gosterilir

### 11.4. Use case 4: Support "yanlis urun geldi" issue'sini siniflar

Normal akis:

1. issue alinir
2. import job trail gorulur
3. low-confidence mi wrong extraction mi ayrilir
4. creator'e standard cevap verilir

Bozulma akis:

- trail eksik
- issue tipi belirsiz

Beklenen davranis:

- support tek basina engineering'e paslamadan once dogru issue tipini ayirmis olur

### 11.5. Use case 5: Ops repeated import failure pattern'ini fark eder

Normal akis:

1. failure dashboard / listede artis gorulur
2. domain bazli pattern ayiklanir
3. support tier veya block karari gozden gecirilir
4. runbook uygulanir

Bozulma akis:

- issue tipi karisik
- confidence / extractor path eksik

Beklenen davranis:

- ops pattern'i kullanici sikayetinden once veya en gec onunla ayni anda gorebilmelidir

---

## 12. Actor'ler arasi gerilimler

Bu urunde actor'ler arasinda dogal gerilim vardir.  
Bu gerilimler saklanmamali; tasarim ve scope tarafinda acikca yonetilmelidir.

### 12.1. Creator hizi vs viewer trust

Gerilim:

- creator daha az adim ister
- viewer daha acik bilgi ister

Karar:

- trust/disclosure saklanmaz
- cozum daha az trust degil, daha az tekrarli giristir

### 12.2. Editor verimliligi vs owner guvenligi

Gerilim:

- editor hiz ister
- owner kritik ayarlari korumak ister

Karar:

- curation editor'a acik olabilir
- ownership, billing, domain ve account deletion owner'a ayrilir

### 12.3. Viewer sadeligi vs creator branding

Gerilim:

- creator markasini gormek ister
- viewer urune hizli ulasmak ister

Karar:

- branding urunleri itemez
- public page profile-heavy olamaz

### 12.4. Creator ozgurlugu vs ops guvenligi

Gerilim:

- creator her linki yayinlamak isteyebilir
- ops unsafe veya risky link'i durdurmak zorundadir

Karar:

- policy / safety bloklari actor rahatliginin onune gecebilir
- ama neden-sonuc UI'da acik anlatilmak zorundadir

---

## 13. Actor bazli hata toleransi matrisi

| Actor | Dusuk tolerans gosterdigi alan | Orta tolerans gosterebildigi alan |
| --- | --- | --- |
| Creator Owner | import accuracy, duplicate, disclosure, publish sonrası görünüm | advanced analytics eksigi |
| Creator Editor | role clarity, bulk edit safety, impact visibility | ekstra tema özgürlüğü eksigi |
| Viewer | page speed, trust visibility, context clarity | derin personalisation eksigi |
| Ops / Admin | failure classification, observability, tier visibility | görsel panel cilasi eksigi |
| Support | issue taxonomy, escalation clarity, response consistency | tam otomasyon eksigi |

Bu matris, hangi actor icin hangi kusurun kritik sayilacagini belirler.

---

## 14. Actor bazli launch acceptance kurallari

### 14.1. Creator Owner acceptance

Launch once owner:

- desteklenen URL ile publish yapabilmeli
- duplicate yerine reuse gorebilmeli
- unsupported merchant'ta fallback gorebilmeli

### 14.2. Viewer acceptance

Launch once viewer:

- context'i anlamali
- trust/disclosure gorebilmeli
- mobile page quality yeterli olmali

### 14.3. Editor acceptance

Launch once editor:

- curation yapabilmeli
- ama kritik ownership alanlarina dokunamamali

### 14.4. Ops acceptance

Launch once ops:

- import failure'i ayirabilmeli
- merchant bazli pattern gorebilmeli

### 14.5. Support acceptance

Launch once support:

- en sik issue tiplerine standard yanit verebilmeli
- escalation yolunu bilmeli

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `04-domain-glossary.md` actor terimlerini tek anlamli hale getirmelidir
2. `23-creator-workflows.md` owner ve editor farkini net tasimalidir
3. `24-viewer-experience-spec.md` viewer'in trust ve context ihtiyacini merkeze almalidir
4. `34-roles-permissions-and-ownership-model.md` permission guardrail'larini actor bazli tanimlamalidir
5. `103-support-playbooks.md` issue taxonomy'yi bu belgeyle uyumlu yazmalidir
6. `51-screen-inventory.md` actor kritik ekranlarini eksiksiz saymalidir

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ekip "kullanici" yerine dogru actor ismini kullanmaya basliyorsa
- actor'ler arasi gerilimler urun kararlarinda acikca gorulebiliyorsa
- launch once hangi actor icin hangi deneyimin zorunlu oldugu tartismasiz hale geliyorsa
- support ve ops actor'leri ilk gunden belge sistemine dahil oluyorsa

Bu belge basarisiz sayilir, eger:

- tum actor'ler tek kullanici gibi anlatilmaya devam ederse
- creator hizina odaklanirken viewer guveni unutulursa
- ops ve support actor'leri launch sonrasi varsayilmis alanlar gibi kalirsa
- role clarity tasarim ve permission belgelerine aktarilamazsa

Bu nedenle bu belge, urunun "kime" hizmet ettigini degil; actor'lerin birbiriyle nasil bir urun sistemi olusturdugunu da tanimlar.
