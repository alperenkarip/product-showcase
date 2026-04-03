---
id: PROJECT-CHARTER-001
title: Project Charter
doc_type: foundation
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on: []
blocks:
  - PRODUCT-VISION-THESIS
  - PRODUCT-SCOPE-NON-GOALS
  - PERSONAS-JOBS-PRIMARY-USE-CASES
  - SUCCESS-CRITERIA-LAUNCH-GATES
  - PRODUCT-INFORMATION-ARCHITECTURE
  - CREATOR-WORKFLOWS
  - URL-IMPORT-PIPELINE-SPEC
  - SYSTEM-ARCHITECTURE
---

# Project Charter

## 1. Bu belge nedir?

Bu belge, `product-showcase` icin en ust otorite urun belgesidir.

Bu belge:

- urunun neden var oldugunu,
- hangi problemi cozmeye geldigini,
- hangi urun sinifina ait oldugunu,
- hangi actor'ler icin ne deger uretmek zorunda oldugunu,
- hangi capability'lerin vazgecilmez oldugunu,
- hangi capability'lerin kapsam disi kaldigini,
- hangi risklerin launch oncesi bloke edici sayildigini,
- sonraki tum belgelerin hangi merkeze bagli kalmak zorunda oldugunu

resmi olarak kilitler.

Bu belge olmadan sonraki belge ailesi kolayca kayar.

Ornek kaymalar:

- urun bir link-in-bio aracina doner
- urun bir creator storefront'u gibi davranmaya baslar
- urun bir affiliate dashboard olarak yorumlanir
- urun kategori-first katalog mantigina kayar
- urun public web yerine mobile app etrafinda tanimlanir
- urun import ve trust problemini kucumseyip kozmetik bir vitrin aracina donusur

Bu belge, bu kaymalari bastan engellemek icin vardir.

Bu belge su sorulara baglayici cevap verir:

1. Bu urun neden var?
2. Bu urun hangi problemi cozer?
3. Bu urun tam olarak ne yapar?
4. Bu urun tam olarak ne yapmaz?
5. Bu urun hangi actor'ler icin tasarlanir?
6. Bu urunde hangi capability launch once zorunludur?
7. Hangi capability'ler ilk fazda bilincle disarida tutulur?
8. Hangi kusurlar launch'i otomatik bloke eder?
9. Sonraki belgeler hangi sinirlar icinde yazilmak zorundadir?

Bu belge bir tanitim metni degildir.  
Bu belge bir karar rejimidir.

---

## 2. Bu belge neden kritiktir?

Bu urunde en buyuk risk teknik hata degil, **urun kimligi kaymasidir**.

Bir urun teknik olarak iyi yazilmis olabilir ama yine de yanlis urun olabilir.

Bu projede asil risk sudur:

> Gercek problemi cozen zor urun yerine, ona benzeyen ama daha kolay yapilan yanlis urune kaymak.

Bu kayma cesitleri somuttur:

### 2.1. Link listesi urunune kaymak

Eger urun "tek linkte bir suru link" mantigina indirgenirse:

- product library ihtiyaci hafife alinir
- baglamli page yapisi zayiflar
- creator icin tekrar kullanilabilir publishing modeli kaybolur
- public deneyim karar verdiren vitrin degil, link cikisi listesi haline gelir

### 2.2. Storefront urunune kaymak

Eger urun "creator magazasi" gibi yorumlanirsa:

- checkout baskisi gelir
- order ve fulfillment beklentileri dogar
- merchant catalogue breadth baskisi artar
- recommendation publishing yerine commerce operations one cikar

### 2.3. Affiliate dashboard'a kaymak

Eger urun "gelir takip paneli" gibi anlatilirsa:

- attribution ve analytics ilk gunde scope'a sizmaya baslar
- asil problem olan hizli ve guvenilir urun yayinlama golgelenir
- creator utility yerine monetization tooling merkeze yerlesir

### 2.4. Category-first katalog urunune kaymak

Eger IA kategori etrafinda kurulursa:

- shelf ve content-linked page ikinci plana duser
- creator baglami yerine katalog duzeni baskin hale gelir
- urunun farklastirici degeri zayiflar

### 2.5. Gorsel tema urunune kaymak

Eger urun "sik vitrin" gibi algilanirsa:

- import accuracy riski geri plana itilir
- trust ve stale-data davranislari hafife alinir
- public web hiz ve guven yerine kozmetik kararlar one cikar

Bu belge, bu kaymalari normatif olarak kapatir.

---

## 3. Urunun tek cumlelik ana amaci

Bu urunun ana amaci sudur:

> Creator'in kullandigi veya onerdigi urunleri daginik, tekrarli ve baglamsiz linklerden kurtarip; tekrar kullanilabilir urun kutuphanesi, context-first sayfalar ve guvenilir public web yuzeyi uzerinden hizli sekilde yayinlamasini saglamak.

Bu cumledeki her parca baglayicidir:

### 3.1. "Creator'in kullandigi veya onerdigi urunler"

Bu urun generic shopping icin degil, creator recommendation davranisi icindir.

### 3.2. "Daginik, tekrarli ve baglamsiz linklerden kurtarmak"

Asil aci, link koyacak yer eksikligi degil; daginiklik, tekrar ve baglam kaybidir.

### 3.3. "Tekrar kullanilabilir urun kutuphanesi"

Bir urun bir kez girilmeli, sonra farkli context'lerde yeniden kullanilabilmelidir.

### 3.4. "Context-first sayfalar"

Bu urunde asil deger kategori degil, baglamdir.  
"Used in this video", "daily stack", "gym bag", "travel setup" gibi yapi tasiyan sayfalar cekirdektedir.

### 3.5. "Guvenilir public web yuzeyi"

Son tuketim noktasi public web'dir.  
Guven, hiz, disclosure, canonical URL ve shareability burada kazanilir veya kaybedilir.

### 3.6. "Hizli sekilde yayinlama"

Urunun cekirdek degeri import ve publish hizinda somutlasir.  
Uzun form ve tekrarli veri girisi varsayilan yol olamaz.

---

## 4. Bu urun hangi problemi cozmeye calisir?

Bu urunun cozmeye calistigi temel problem sudur:

> Creator'larin urun tavsiyeleri, bugun duzenli, tekrar kullanilabilir, guvenilir ve baglamli bir yayin sistemi icinde yasamaz; bu nedenle hem creator tarafinda tekrarli operasyon yuku hem de viewer tarafinda belirsizlik ve guven kaybi olusur.

Bu problemin alt katmanlari vardir.

### 4.1. Creator tarafinda tekrarli is yuku

Creator:

- ayni urunu birden fazla videoda tekrar anlatir
- her yeni icerik icin tekrar link toplar
- comment veya DM seviyesinde ayni sorulara cevap verir
- eski linklerin guncelligini kontrol etmekte zorlanir

Bu nedenle creator tarafinda asil eksik "link alanı" degil, **yapisal tekrar kullanim ve publish hizi**dir.

### 4.2. Viewer tarafinda baglam kaybi

Viewer:

- urunun ne icin onerildigini anlayamaz
- tekil merchant linkleri ile bas basa kalir
- "bu videoda gecen urunler" gibi toplu baglama erisemez
- disclosure ve trust bilgisini net goremez

Bu nedenle viewer tarafinda asil eksik "daha cok urun" degil, **daha az belirsizlik ve daha cok baglam**dir.

### 4.3. Teknik tarafta import guvenilirligi sorunu

Bir recommendation surface ancak dogru veri ile guvenilir olabilir. Bu urunde:

- yanlis title,
- yanlis image,
- yanlis merchant,
- stale veya missing price,
- unsupported merchant,
- redirect ve policy riskleri

core urun riskidir.

### 4.4. Operasyon tarafinda gorunurluk eksigi

Import bozulursa, support ve ops su sorulara cevap verebilmelidir:

- problem unsupported merchant mi?
- parser kalitesi mi?
- duplicate mi?
- blocked domain mi?
- stale veri mi?

Bu gorunurluk olmadan urun dogru isletilemez.

### 4.5. Problemin yalnizca estetik olmamasi

Bu urun guzel gorunmek zorundadir ama sorun sadece estetik degildir.

Sorun:

- tekrarli manuel operasyon,
- baglamsiz yayin,
- guven eksigi,
- veri dogrulugu,
- stale bilgi,
- support korlugu

karisimi olan sistem problemidir.

---

## 5. Urun tam olarak ne yapar?

Bu urun su isi yapar:

1. Creator'dan urun linki veya urun referansi alir
2. Bu girdiyi normalize eder ve guvenlik/policy kontrolunden gecirir
3. Merchant ve extraction katmani uzerinden aday urun verisi cikarir
4. Creator'a kritik alanlari dogrulayacagi veya duzeltecegi bir verification deneyimi sunar
5. Urunu creator'in kutuphanesine yerlestirir veya mevcut kutuphane kaydiyla esler
6. Urunu bir shelf veya content-linked page baglaminda placement olarak yayinlar
7. Public web'de creator baglami, trust bilgisi ve merchant cikis mantigi ile sunar
8. Sonradan stale, broken, duplicate veya policy sorunlari olursa bunlari operasyonel olarak gorunur kilar

Bu akisin ozeti:

> URL / referans -> extraction -> verification -> library -> placement -> public page -> operational follow-up

Bu zincirde herhangi bir halkayi "ikincil" gibi gormek urun tezi ile celisir.

---

## 6. Urun tam olarak ne degildir?

Bu bolum baglayicidir.  
Bu urun ileride bile asagidaki urun siniflarindan birine kaymamalidir.

### 6.1. Urun bir link-in-bio araci degildir

Neden degil:

- yalnizca link listesi sunmaz
- product library tasir
- content-linked page ve shelf yapisi vardir
- trust/disclosure ve import omurgasina sahiptir

### 6.2. Urun bir checkout storefront'u degildir

Neden degil:

- uygulama ici checkout yapmaz
- order, fulfillment, return tasimaz
- merchant operasyonunu kendi uzerine almaz

### 6.3. Urun bir marketplace degildir

Neden degil:

- creator-centric'tir
- global ranking ve discovery feed tasimaz
- urunler creator baglamindan bagimsiz katalog nesnesi olarak sunulmaz

### 6.4. Urun bir affiliate network degildir

Neden degil:

- asil deger recommendation publishing'dir
- komisyon dagitimi ve settlement tasimaz
- agir BI paneli ilk fazin merkezi degildir

### 6.5. Urun bir website builder degildir

Neden degil:

- free-form drag-and-drop builder tasimaz
- disclosure/trust alanlarini saklayacak kadar serbest custom layout vermez
- kaliteyi kontrolsuz custom bloklara feda etmez

### 6.6. Urun bir shopping search engine degildir

Neden degil:

- kategori ve arama omurga degildir
- viewer generic katalog taramak icin degil, creator baglamina girmek icin gelir

---

## 7. Urun kim icindir?

### 7.1. Birincil actor: Creator Owner

Bu urun birincil olarak su creator tipine yoneliktir:

- duzenli icerik ureten
- takipcilerinden tekrarlayan urun sorulari alan
- link daginikligi problemi yasayan
- tam e-ticaret magazasi istemeyen
- guvenilir ama hafif recommendation katmani isteyen

Bu actor icin asil deger:

- hiz
- tekrar kullanim
- guvenilir public sunum

### 7.2. Ikincil actor: Creator Editor / Assistant

Bu actor:

- owner adina curation yapar
- page hazirlar
- import duzeltmelerine yardim eder
- ama sahiplik ve kritik ayarlari degistirmez

### 7.3. Ikincil actor: Public Viewer

Bu actor:

- cogu zaman hesapsiz ve mobildedir
- sosyal platformdan gelir
- belirli bir urun veya belirli bir icerikte gecen urun setini arar

### 7.4. Ikincil actor: Ops / Admin

Bu actor:

- import kalitesini izler
- domain bazli pattern ayiklar
- retry / cooldown / block kararlariyla ilgilenir

### 7.5. Ikincil actor: Support

Bu actor:

- creator sorunlarini issue type bazli siniflar
- fallback ya da escalation yolunu secer
- unsupported merchant ile parser hatasini karistirmamalidir

---

## 8. Neden simdi?

Bu urunun savunulabilirligi su kosullarin kesisiminden gelir:

1. Creator economy buyurken arac yorgunlugu da buyuyor
2. Takipci, sadece tek-link degil; baglamli urun sunumu bekliyor
3. Platform-native shopping buyuse de creator'lar platformlar arasi bagimsiz recommendation katmani istiyor
4. Extraction ve structured-data tooling'i import problemini artik yonetilebilir hale getiriyor
5. Creator, tam magazadan once hafif ama kaliteli tavsiye altyapisina ihtiyac duyuyor

Bu "neden simdi" bolumu pazarda bosluk var demek degildir.  
Pazar vardir ama cogu cozum:

- ya cok hafif link aracina,
- ya cok agir storefront'a,
- ya da cok monetization-first affiliate paneline

kaymistir.

Bu urun o ucgenin ortasinda yeni bir denge arar.

---

## 9. Ilk wedge neden fitness creator segmentidir?

Fitness creator segmenti su nedenlerle ilk wedge olarak secilir:

1. "routine", "stack", "gym bag", "recovery" gibi context birimleri dogaldir
2. Ayni urunler farkli icerik baglamlarinda tekrar eder
3. Takipci urun sorulari yogun ve tekrarli olur
4. Trust ve "gercekten kullaniyor mu?" sinyali onemlidir
5. Shelf ve content-linked page farki bu segmentte daha net gorulur

Bu karar su anlama gelmez:

- domain model fitness'a kilitli degildir
- tasarim yalniz bu estetikte kalmaz
- diger creator turleri dislanmis degildir

Bu sadece ilk davranis dogrulama zemini olarak secilmistir.

---

## 10. Urunun asil degeri tam olarak nerede uretilir?

Bu urun icin deger tek noktada degil, asagidaki dort hat uzerinden uretilir:

### 10.1. Publish hizi

Creator icin "urun ekleme" bir angarya degil, kisa ve tekrar eden bir refleks haline gelmelidir.

### 10.2. Context-rich presentation

Viewer urunu yalnizca gormemeli; neden burada oldugunu, hangi baglamda onerildigini de anlamalidir.

### 10.3. Reuse

Bir urun bir kez library'ye girip sonra birden fazla shelf veya content page'de kullanilabilmelidir.

### 10.4. Trust

Disclosure, stale veri, source merchant ve public kalite guven yaratmak zorundadir.

Bu dort hattan biri eksikse urun degeri ciddi zayiflar.

---

## 11. Product modelinin merkezindeki ana kararlar

Bu belge, urunun alt sistemlerini tanimlayan temel karar ciftlerini baglar.

### 11.1. Creator-centered vs catalog-centered

Karar:
Creator-centered.

Anlami:

- public giris creator kimligi etrafinda kurulur
- global shopping katalogu mantigi kurulmaz

### 11.2. Context-first vs category-first

Karar:
Context-first.

Anlami:

- shelf ve content-linked page birincil varliktir
- kategori, tag, filter ve search yardimci katmandir

### 11.3. Library + placement vs duplicated cards

Karar:
Library + placement.

Anlami:

- ayni urun birden fazla context'te tekrar kullanilabilir
- her page icin yeni product kaydi acmak anti-pattern sayilir

### 11.4. Public web primary vs app primary

Karar:
Public web primary consumption, mobile app primary creator velocity.

Anlami:

- viewer experience web tarafinda optimize edilir
- mobile app creator operasyonuna hizmet eder

### 11.5. Trust visible vs trust hidden

Karar:
Trust visible.

Anlami:

- disclosure saklanmaz
- stale bilgi gizlenmez
- price yoksa sebebi veya durumu acik ifade edilir

### 11.6. Import as core vs import as helper

Karar:
Import as core.

Anlami:

- import teknik backlog'un yan basligi degildir
- ayri belge ailesi, ayri quality matrix ve ayri ops sahipligi gerekir

---

## 12. Public web neden birinci sinif yuzeydir?

Bu urun icin public web:

- creator'in sosyal trafikten getirdigi son duraktir
- urun kalitesinin disaridan gorunen yuzudur
- trust, disclosure ve page baglaminin algilandigi yerdir
- share preview ve SEO degerinin uretildigi yerdir

Bu nedenle public web'de asagidaki seyler "nice to have" degildir:

1. dogru route ve canonical davranisi
2. mobil performans
3. product-first ama context-rich layout
4. stale ve disclosure sinyalinin gorunurlugu
5. hatali / bos / kaldirilmis sayfa davranislarinin kontrollu olmasi

Public web zayifsa, creator tooling ne kadar iyi olursa olsun urun guven kaybeder.

---

## 13. Mobile app neden creator velocity yuzeyidir?

Bu urunde mobile app'in gorevi su degildir:

- tum product ops panelini kopyalamak
- tum admin / ops ekranlarini tasimak
- public consumption'i native app'a zorla cekmek

Mobile app'in asil gorevi:

1. hizli URL capture
2. share sheet uzerinden urun ekleme
3. kritik verification adimi
4. son kullanilan page / shelf secimi
5. mini edit ve publish

Yani mobile app, creator'in gunluk refleks araci; public web ise viewer'in karar verme yuzeyidir.

---

## 14. Import neden cekirdek urun problemidir?

Bu soru cunku butun proje planini belirler.

Import yanlis tasarlanirsa su olur:

- creator hizli publish edemez
- manual form ana yola doner
- support "yanlis urun geldi" talepleri ile dolar
- viewer yanlis urun veya yanlis merchant'a gider
- urun siradan bir theme editor'e indirgenir

Bu nedenle import su alt problemlere bolunmek zorundadir:

1. URL acceptance ve normalization
2. Safety / policy kontrolu
3. Merchant capability ayrimi
4. Extraction strategy ve fallback order
5. Verification UI
6. Duplicate ve reuse kontrolu
7. Failure classification
8. Refresh / stale management

Import problemini "later optimization" gibi ele almak charter ihlalidir.

---

## 15. Trust neden cekirdek urun problemidir?

Bu urun tavsiye davranisi uzerinden deger urettigi icin guven probleminden kacamaz.

Viewer acisindan kritik sorular:

- Bu urun sponsorlu mu?
- Bu urun affiliate link mi?
- Creator bunu bizzat kullanmis mi?
- Fiyat guncel mi?
- Merchant guvenilir mi?

Eger urun bu sorulari acikca tasimazsa:

- creator'in tavsiyesi reklam gibi hissedilir
- viewer kararsiz kalir
- support ve compliance yuku artar

Bu nedenle trust:

- ayarlar ekranina gizlenemez
- dipnot seviyesine itilemez
- yalnızca tek page tipine uygulanamaz

---

## 16. Zorunlu capability seti

Bu bolumde capability'ler yalnizca isim olarak degil, neden zorunlu olduklari ile birlikte baglanir.

### 16.1. Identity ve ownership capability'leri

Zorunlu capability'ler:

- creator account
- handle / slug
- storefront sahipligi
- owner/editor role ayrimi

Neden zorunlu:

- public kimlik zorunludur
- yetki siniri owner-first modelde net olmali
- domain, billing ve silme gibi konular sahipliksiz tasarlanamaz

### 16.2. Publishing capability'leri

Zorunlu capability'ler:

- storefront
- shelf / collection
- content-linked page
- draft / publish / unpublish
- placement siralama

Neden zorunlu:

- urunun degeri baglamli yayin yapisinda uretilir
- content-linked page farklastirici cekirdektir
- draft olmadan creator publish korkusu tasir

### 16.3. Library ve reuse capability'leri

Zorunlu capability'ler:

- product library
- duplicate detection
- canonical source tracking
- placement modeli
- archive ve remove impact visibility

Neden zorunlu:

- ayni urunu tekrar tekrar girmek kabul edilemez
- duplicate support ve stale veri riskini artirir

### 16.4. Import capability'leri

Zorunlu capability'ler:

- URL acceptance
- normalization
- capability registry
- extraction
- verification
- manual correction fallback
- failure classification

Neden zorunlu:

- hiz ve guven ancak bu zincirle birlikte korunabilir

### 16.5. Trust capability'leri

Zorunlu capability'ler:

- disclosure kaydi
- disclosure gosterimi
- price freshness sinyali
- source merchant gorunurlugu

### 16.6. Ops capability'leri

Zorunlu capability'ler:

- import history
- broken link ve stale pattern gorunurlugu
- issue classification
- retry / escalation destek akisi

---

## 17. Faz 1'de bilincli olarak kapsam disi kalanlar

Bu bolumde "simdilik yok" denmez; neden disarida oldugu yazilir.

### 17.1. Checkout ve order operations

Kapsam disi:

- checkout
- cart
- order history
- fulfillment
- returns

Neden disarida:

- urunu baska sinifa tasir
- merchant operasyonu yukler
- recommendation publishing fokusunu bozar

### 17.2. Marketplace / discovery feed

Kapsam disi:

- creatorlar arasi shopping feed
- algorithmic ranking
- generic discovery home

Neden disarida:

- creator-centric model ile celisir
- kategori ve katalog mantigini zorlar

### 17.3. Heavy analytics ve BI

Kapsam disi:

- creator revenue dashboards
- attribution-first analytics suite
- advanced cohort / BI paneli

Neden disarida:

- ilk urun degeri publish ve trust tarafinda
- analytics erken asamada scope dagitir

### 17.4. Free-form website builder

Kapsam disi:

- drag-and-drop full layout editor
- custom block marketplace
- disclosure saklayacak kadar serbest customisation

Neden disarida:

- kalite standardini bozar
- urunu website builder'a cevirir

---

## 18. Urunun asla donusmemesi gereken seyler

Bu bolum, anti-kayma guardrail'idir.

Bu urun:

- profile-heavy beauty page urunune donusmemeli
- monetization-first affiliate paneline donusmemeli
- category-driven shopping kataloguna donusmemeli
- free-form microsite builder'a donusmemeli
- public web'i ikinci plana atan app-only modele donusmemeli

Bu kaymalardan biri goruldugunde ilgili belge ailesi revize edilmeli ve gerekiyorsa ADR acilmalidir.

---

## 19. En kritik failure modlari

Bu urun icin kritik failure yalnizca teknik crash degildir.  
Asagidaki hatalar urun kimligini bozan failure sayilir.

### 19.1. Import calisiyor gorunurken yanlis calismasi

Tehlike:

- sessiz yanlis title
- alakasiz image
- yanlis merchant

### 19.2. Reuse yerine duplicate patlamasi

Tehlike:

- kutuphane kirlenir
- stale bilgi cifter cifter birikir
- creator ayni urunu yonetemez hale gelir

### 19.3. Context kaybi

Tehlike:

- product card'lar sayfadan bagimsizlasir
- shelf ve content-linked page anlami zayiflar
- urun sade link listesine doner

### 19.4. Trust kaybi

Tehlike:

- disclosure saklanir
- stale bilgi gosterilmez
- viewer reklam hissine kapilir

### 19.5. Operational blindness

Tehlike:

- support sorunu siniflayamaz
- ops tekrar eden pattern'i goremez
- merchant capability kararlari sezgisel kalir

---

## 20. Launch once gecilemeyecek kirmizi cizgiler

Asagidaki kusurlar launch'i otomatik bloke eder:

1. Desteklenen merchant setinde sik yanlis urun extraction'i
2. Unsupported merchant'ta creator'in cikissiz kalmasi
3. Disclosure bilgisinin kaybolmasi veya sayfalar arasi tutarsizlasmasi
4. Stale fiyatin guncelmis gibi gorunmesi
5. Public route / canonical modelinin bozuk olmasi
6. Duplicate product davranisinin kontrolsuz kalmasi
7. Import failure'in ops/support tarafinda gorunmez olmasi
8. Public web'in mobilde guven vermeyecek kadar zayif olmasi

Bu maddelerden biri varken "beta" veya "sonra duzeltiriz" dili yeterli mazaret sayilmaz.

---

## 21. Yeni ozellikler icin karar testi

Bu belge, gelecekteki her yeni capability icin su testin uygulanmasini zorunlu kilar.

### 21.1. Kabul yonunde sorular

1. Creator publish hizini anlamli bicimde iyilestiriyor mu?
2. Viewer'in baglami ve guveni anlamasina katkisi var mi?
3. Import, trust veya support operasyonunu iyilestiriyor mu?
4. Reuse ve stale-data problemini azaltmaya yardim ediyor mu?

### 21.2. Red yonunde sorular

1. Urunu checkout/storefront tarafina mi itiyor?
2. Kategori veya katalog merkezli IA'ya mi kaydiriyor?
3. Free-form builder veya kontrolsuz customisation mi aciyor?
4. Creator akisina form, ayar veya karar enflasyonu mu getiriyor?
5. Trust ve disclosure'u saklayacak alan mi yaratiyor?

Red yonunde guclu bir sinyal varsa varsayilan karar "hayir"dir.

---

## 22. Bu belge alt dokumanlardan ne ister?

Bu belge, sonraki belge ailesine su somut emirleri verir:

1. Her belge actor bazli yazilmak zorundadir.
2. Her belge normal akis, alternatif akis ve bozulma akislarini ayri ayri yazmak zorundadir.
3. Her belge ne yapilir kadar ne yapilmazi da belirtmek zorundadir.
4. Import ve trust alanlari hicbir belgede ikincil gibi ele alinamaz.
5. Public web kalite kurallari hicbir belgede "later polish" olarak gecistirilemez.
6. Kategori-first yorum hicbir belgede sizmamalidir.
7. Product ile placement ayrimi hicbir belgede bulanik kalmamalidir.
8. "Gerekirse", "uygun sekilde", "sonra bakilir" gibi bos ifadeler kullanilmamalidir.

---

## 23. Bu belge nasil kullanilir?

Bu belge su toplantilarda aktif referans olmalidir:

- yeni feature onceliklendirme
- IA tartismasi
- import / trust / compliance karar toplantilari
- launch readiness go / no-go degerlendirmesi
- roadmap ve scope review

Eger bir tartismada "bu urun aslinda neydi?" sorusu ortaya cikiyorsa, cevap ilk olarak bu belgeye donmelidir.

---

## 24. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- urunun ne oldugu ve ne olmadigi tek anlamli hale geliyorsa
- sonraki belgeler icin baglayici ama yeterince acik bir merkez kuruyorsa
- urun kaymasini erkenden tespit etmeyi sagliyorsa
- feature tartismalarinda pratik olarak kullanilabiliyorsa
- launch once hangi cizgilerin gecilemeyecegini tartismasiz hale getiriyorsa

Bu belge basarisiz sayilir, eger:

- hala "bu link araci mi yoksa storefront mu?" sorusu acik kaliyorsa
- import ve trust problemleri yeterince merkezi gorunmuyorsa
- product scope sonradan sessizce genisleyebilecek kadar muallak birakilmissa
- alt belge seti bu belgeyi acik kapilarla delip gecebilir durumdaysa

Bu nedenle bu belge, proje boyunca yalnizca okunacak degil; surekli referans alinacak ana kilit belgedir.
