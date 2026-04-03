---
id: PRODUCT-VISION-THESIS-001
title: Product Vision and Thesis
doc_type: foundation
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
blocks:
  - PRODUCT-SCOPE-NON-GOALS
  - PERSONAS-JOBS-PRIMARY-USE-CASES
  - PRODUCT-INFORMATION-ARCHITECTURE
  - PAGE-TYPES-PUBLICATION-MODEL
  - CREATOR-WORKFLOWS
  - VIEWER-EXPERIENCE-SPEC
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER
---

# Product Vision and Thesis

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun stratejik tez katmanidir.

Bu belge:

- urunun dis dunyaya nasil konumlanacagini,
- ekip icinde nasil dusunulecegini,
- hangi urun kategorilerine benzeyip hangi kategorilerden ayrildigini,
- urunun neden var oldugunu,
- urunun asil degeri nerede urettigini,
- urunun ileride neye donusmemesi gerektigini

resmi olarak baglar.

Bu belge charter'dan farkli olarak, kapsam veya launch kurali anlatmaz.  
Bunun yerine:

- urunun kimligini,
- urunun savunulabilir tezlerini,
- rakip kategorilerle farkini,
- positioning dilini,
- urun kararlarina yon verecek yorum eksenlerini

tanımlar.

Bu belge olmadan sonraki urun belgelerinde su kaymalar kolayca olur:

- urun bir "guzel storefront" gibi anlatilir
- urun "tek link araci" gibi konumlanir
- urun "affiliate geliri paneli" gibi genisletilir
- urunun asil degerinin baglam degil tema oldugu sanilir
- import ve trust problemleri ikinci sinif sayilir

Bu belge, urunun stratejik merkezini sabitler.

---

## 2. Bu belge neden kritiktir?

Bu urunde en buyuk stratejik risk, urunun teknik olarak ne oldugunu degil; **kategori olarak ne sayilacagini** karistirmaktir.

Pazardaki yakin kategoriler aldatıcı derecede benzerdir:

- link-in-bio araclari
- storefront cozumleri
- creator commerce araçlari
- affiliate-first paneller
- shopping curation ve recommendation araclari

Bu urun bunlarla bir miktar kesişir; ama hicbirine tam olarak indirgenemez.

Eger bu ayrim net yazilmazsa:

- tasarim baska bir urune hizmet eder
- IA baska bir urune hizmet eder
- roadmap baska bir urune hizmet eder
- support ve pricing dili baska bir urune hizmet eder

Yani teknik olarak ayni repo uzerinde calisiyor oluruz ama stratejik olarak farkli urunler uretmeye baslariz.

Bu belge, "biz aslinda hangi urunu kuruyoruz?" sorusunu tek anlamli hale getirir.

---

## 3. Urunun tek cumlelik stratejik tanimi

Bu urunun stratejik tanimi sudur:

> `product-showcase`, creator'in kullandigi veya onerdigi urunleri tekil ve daginik linkler yerine, tekrar kullanilabilir urun kutuphanesi ve context-first public sayfalar uzerinden hizli, guvenilir ve guven verici bicimde yayinlamasini saglayan recommendation publishing sistemidir.

Bu tanim, urunun butun ana gerilimlerini birlikte tasir:

- recommendation
- publishing
- reuse
- context
- trust
- speed

Bu alt basliklardan biri cikarildiginda urun baska bir seye kayar.

---

## 4. Vizyon ifadesi

Bu urunun uzun vadeli vizyonu sudur:

> Creator'in urun tavsiyelerini, sosyal platformlardan bagimsiz ama onlarla uyumlu sekilde; tekrar kullanilabilir, baglamli ve guvenilir bir web varligi haline getiren en net recommendation publishing katmanini kurmak.

Bu vizyonun icindeki her kavram bilinclidir.

### 4.1. "Sosyal platformlardan bagimsiz ama onlarla uyumlu"

Bu urun sosyal platformlara rakip olmaz.  
Onlardan trafik alir, onlarla baglam kurar, ama creator'i tek bir platformun shopping primitive'lerine kilitlemez.

### 4.2. "Tekrar kullanilabilir"

Bir urun bir defa library'ye girer; sonra farkli sayfalarda tekrar kullanilabilir.  
Bu yoksa urunun operasyon degeri coker.

### 4.3. "Baglamli"

Product cards tek basina degil, context ile birlikte degerlidir.  
"Used in this video", "daily stack", "travel setup", "leg day kit" gibi yapilar bu yuzden stratejik deger tasir.

### 4.4. "Guvenilir"

Extraction dogrulugu, disclosure, stale-data davranisi, source merchant ve public kalite birlikte guven uretir.

### 4.5. "Web varligi"

Bu urun uygulama ici deneyime degil, public webde yasayan ve paylasilan bir recommendation presence'e donusur.

---

## 5. Urunun ana tezi nedir?

Bu urunun ana tezi su sekildedir:

> Creator'in asil problemi daha fazla link alani degil; urun tavsiyelerini daha az tekrarli, daha baglamli, daha guvenilir ve daha hizli sekilde yayinlayabilecegi bir sisteme sahip olmamasidir.

Bu tez neden dogrudur?

### 5.1. Link problemi tek basina degildir

Bugun creator cogu zaman tek-link aracina zaten sahiptir.  
Ama problem cozulmez.  
Cunku sorun:

- linkin nereye konulacagi degil,
- linklerin nasıl organize oldugu,
- ayni urunun nasil tekrar kullanildigi,
- hangi baglamda sunuldugu,
- ne kadar guven verdigi

sorunudur.

### 5.2. Storefront problemi tek basina degildir

Creator'a magaza gorunumu vermek sorunu cozmeyebilir.  
Cunku creator'in asil ihtiyaci:

- cekirdek urun data'sini yonetmek
- tekrar kullanmak
- sosyal iceriklere bagli sayfalar uretmek

gibi publishing davranislaridir.

### 5.3. Monetization problemi birincil problem degildir

Affiliate ve sponsorlu iliskiler vardir; ama bunlar urunun varlik nedeni degildir.  
Asil varlik nedeni: tavsiyeyi duzenli, kullanisli ve guvenilir hale getirmektir.

---

## 6. Urun neden vardir?

Bu urun su nedenle vardir:

Creator tarafinda daginik urun tavsiyeleri vardir.  
Viewer tarafinda baglamsiz linkler ve trust belirsizligi vardir.  
Pazardaki cozumler bu iki problemi ayni anda yeterince iyi cozmez.

Bu urun:

- creator'a publishing hiz ve tekrar kullanim saglar
- viewer'a context ve trust saglar
- ops tarafa failure ve quality gorunurlugu saglar

Bu ucgen birlikte kuruldugunda urun anlamlidir.

Sadece biri varsa urun eksik kalir:

- yalniz creator hizi varsa ama trust yoksa urun reklam araci gibi hissedilir
- yalniz guzel public page varsa ama import/reuse yoksa creator için angaryaya doner
- yalniz import varsa ama context ve public kalite yoksa viewer degeri olusmaz

---

## 7. Urun tam olarak hangi kategoriye aittir?

Bu urun tek bir mevcut kategoriye sigmaz.  
Ama en yakin kategori tanimi sunlardir:

- creator recommendation infrastructure
- context-first product publishing
- lightweight commerce-adjacent showcase

Bu ifade bilinclidir.  
Cunku urun:

- recommendation behavior tasir
- publishing behavior tasir
- commerce ile temas eder ama commerce product'i degildir

---

## 8. Urun hangi kategorilere benzese de onlar degildir?

### 8.1. Linktree / Beacons benzeri araclara benzer ama onlar degildir

Benzerlik:

- creator'in tek-link mantigi vardir
- dis platformlardan trafik alir

Temel ayrim:

- product library vardir
- content-linked page vardir
- trust/disclosure sistematiktir
- import omurgasi vardir

### 8.2. Storefront urunlerine benzer ama onlar degildir

Benzerlik:

- creator markali public sayfa uretir
- urun showcase eder

Temel ayrim:

- checkout tasimaz
- order ve fulfillment tasimaz
- recommendation context'i merkezdedir

### 8.3. Affiliate panellerine benzer ama onlar degildir

Benzerlik:

- dis merchant cikisi vardir
- gelir iliskisi olabilir

Temel ayrim:

- monetization ana anlatim degildir
- agir attribution paneli urunun cekirdegi degildir
- publishing hızı ve trust daha once gelir

### 8.4. Shopping curation sayfalarina benzer ama onlar degildir

Benzerlik:

- urun secimi ve vitrinleme vardir

Temel ayrim:

- creator-specific reuse modeli vardir
- dynamic import ve verification vardir
- content-linked page urunun merkezi rol oynar

---

## 9. Bu urunun asil farklastirici tezleri nelerdir?

Bu urun birden fazla farklastirici hat uzerinden savunulur.

### 9.1. Context-first tez

Viewer urunu kategori icinde degil, baglam icinde anlamak ister.  
Bu nedenle context-first page'ler stratejik olarak product page kadar onemlidir.

Bu tez olmasa:

- urun kategori kataloguna duser
- urunun "used in this video" degeri kaybolur

### 9.2. Reuse tez

Creator tarafinda en kritik verimlilik kaynagi reuse'dur.  
Bir urun bir kez girilmeli, sonra birden fazla context'te kullanilabilmelidir.

Bu tez olmasa:

- duplicate urunler artar
- stale veri riski buyur
- creator zaman kaybeder

### 9.3. Trust-visible tez

Trust saklanmaz; tasarimin bir parcasi haline getirilir.

Bu tez olmasa:

- recommendation yuzeyi reklam gibi hissedilir
- viewer guveni duser
- compliance ve support yuku artar

### 9.4. Public-web-first tez

Asil tuketim ve guven anı public web'de yasar.  
Bu nedenle public web performansi, route modeli ve shareability stratejik olarak birinci siniftir.

Bu tez olmasa:

- urun mobile tooling etrafinda yanlis optimize edilir
- viewer experience zayiflar

### 9.5. Import-as-core tez

Bu urun tasarimla degil, veri dogruluguyla kazanir veya kaybeder.  
Bu nedenle import teknik yardimci degil, core product function sayilir.

---

## 10. Urunun dis dunyaya verdigi temel vaat nedir?

Dis dunyaya verilecek ana vaat su olmalidir:

> Kullandigin veya onerdigin urunleri tek linkte toplamakla kalma; bunlari baglamli, guvenilir ve tekrar kullanilabilir bir recommendation vitrinine donustur.

Bu vaat su alt vaatlere ayrilir:

1. hizli kurulum
2. hizli urun ekleme
3. tekrar kullanim
4. context page olusturma
5. trust ve disclosure gorunurlugu

Bu vaat su vaatlere donusmez:

- tum commerce isini tek yerden yonet
- tum affiliate gelirini optimize et
- kendi magazani kur
- marketplace'te one cik

---

## 11. Urunun ekip ici karar cumlesi nedir?

Ekip ici kullanilacak karar cumlesi su olmalidir:

> Bu urun storefront estetine sahip olabilir; ama cekirdek degeri guzel profil sayfasi degil, context-first recommendation publishing hizidir.

Bu cumlenin ekip ici kullanim amaci sudur:

- tasarim kararlarini hizaya sokmak
- roadmap'i theme-first kaymadan korumak
- import ve trust alanlarini merkeze almak

---

## 12. Bu urun neden "recommendation publishing" urunudur?

Bu ifade keyfi secilmemistir.

### 12.1. Recommendation

Urun, creator'in onerisi veya kullandigi urun etrafinda deger uretir.  
Bu nedenle trust, disclosure ve source bilgisi onemlidir.

### 12.2. Publishing

Urunun asil degeri urunu depolamak degil, yayinlanabilir hale getirmektir.  
Library tek basina deger degil; publish flow ile birlikte degerdir.

### 12.3. Recommendation publishing ifadesinin sonucu

Bu urun:

- CMS'e benzer bazı ozellikler tasir
- commerce'e benzer bazı ozellikler tasir
- social linking'e benzer bazı ozellikler tasir

Ama hicbirine tam donusmez.

---

## 13. Bu urun neden "context-first" olmalidir?

Context-first kararinin stratejik gerekceleri vardir.

### 13.1. Viewer'in arama niyeti context ile gelir

Viewer cogu zaman "beauty" veya "fitness" kategorisi aramaz.  
Sunlari arar:

- bu videoda ne kullanildi
- gunluk rutini ne
- seyahatte ne tasiyor
- bu setup'taki urunler ne

### 13.2. Creator'in anlatim dili context ile gelir

Creator da urunlerini kategori diliyle degil, rutin ve icerik diliyle anlatir.

### 13.3. Kategori yardimci olabilir ama omurga olamaz

Kategori:

- tag olarak olabilir
- filter olarak olabilir
- arama yardimcisi olarak olabilir

Ama ust mimari iskelet category-first olursa urunun asil farki kaybolur.

---

## 14. Bu urun neden "creator-centered" olmak zorundadir?

Bu urun generic katalog ya da marketplace degildir.  
Viewer urune cogu zaman belirli bir creator baglamindan gelir.

Bu nedenle creator-centered olmanin sonuclari:

1. Creator kimligi giris katmanidir
2. Storefront creator baglamini tasir
3. Product recommendation bir creator trust iliskisi icinde deger kazanir
4. Global shopping browse deneyimi omurga yapilmaz

Creator-centered olmak su anlama gelmez:

- creator biyografisini urunlerden daha buyuk gostermek
- urunu influencer vanity page'ine cevirmek

Tam tersi:

- creator trust kaynagi olur
- ama urunleri ezmez

---

## 15. Bu urun neden public-web-first olmak zorundadir?

Viewer:

- sosyal platformdan gelir
- cogu zaman hesapsizdir
- cogu zaman mobildedir
- hizli karar vermek ister

Bu nedenle asil tuketim ani uygulama icinde degil, public web'dedir.

Public-web-first kararinin sonuclari:

1. SEO ve share preview stratejik karardir
2. Route ve canonical model cok onemlidir
3. Public sayfa performansi launch kriteridir
4. Content-linked page ve shelf publicte birinci sinif nesnelerdir

Bu karar, mobile app'i degersizlestirmez.  
Sadece mobile app'in gorevini dogru yere koyar: creator velocity.

---

## 16. Bu urun neden import-first dusunulmelidir?

Import su nedenle stratejik cekirdektir:

- creator'in hizini belirler
- support yukunu belirler
- trust'i belirler
- duplicate ve stale veri riskini belirler

Import'in basarisiz oldugu bir urunde:

- library anlami zayiflar
- context page olusturmak yorucu hale gelir
- creator tekrar manuel form'a doner

Bu nedenle import:

- backend backlog'un alt maddesi degil,
- urun kalbinin bir parcasi olarak ele alinmalidir.

---

## 17. Bu urun neden trust-visible olmak zorundadir?

Recommendation urunu olup trust bilgisini saklamak stratejik olarak yanlistir.

Viewer tarafinda kritik trust sorulari:

- bu urun sponsorlu mu?
- affiliate mi?
- creator bunu gercekten kullandi mi?
- fiyat guncel mi?
- hangi merchant kaynagi kullaniliyor?

Bu nedenle trust-visible kararinin sonuclari:

1. Disclosure UI'da gorunur olur
2. Stale-price signal tasarimda yer bulur
3. Source merchant bilgisi belirsiz kalmaz
4. Compliance belgeleri urun icine baglanir

---

## 18. Urunun neden monetization-first anlatilmamasi gerekir?

Bu urunde para iliskisi vardir.  
Ama para iliskisi urunun varlik nedeni degildir.

Monetization-first anlatim neden tehlikelidir:

- creator utility geri plana itilir
- viewer trust'i zayiflatir
- urun affiliate paneli gibi algilanir
- analytics ve attribution erken scope'a sizar

Dogru sira sunlar olmalidir:

1. creator utility
2. context-rich publishing
3. trust
4. sonra plan ve gelir etkileri

---

## 19. Urun neye donusmemelidir?

Bu bolum stratejik anti-kayma listesidir.

Urun:

- "all-in-one creator commerce suite" diye anlatilmamalidir
- "AI shopping assistant" diye anlatilmamalidir
- "influencer marketplace" diye anlatilmamalidir
- "creator mini-store" diye merkezlesen dil kullanmamalidir
- "monetization command center" diye anlatilmamalidir

Bu ifadeler:

- yanlis beklenti uretir
- yanlis roadmap ceker
- yanlis buyer segmenti yaratir

---

## 20. Positioning dilinde hangi kelimeler tercih edilmeli?

Tercih edilmesi gereken kelimeler:

- recommendation
- showcase
- context
- used in this video
- routine
- collection
- creator picks
- trusted links
- publish
- reuse

Temkinli kullanilmasi gereken kelimeler:

- store
- shop
- buy now
- sales
- commission

Yasak veya sadece sinirli baglamda kullanilmasi gereken kelimeler:

- marketplace
- checkout
- order
- campaign management
- affiliate command center

---

## 21. Bu tez tasarima nasil yansir?

Bu tez tasarim tarafina su emirleri verir:

1. Public sayfalar profile-heavy degil product/context-first olur
2. Content-linked page ikincil degil birincil tasarlanir
3. Trust ve disclosure dipnot gibi saklanmaz
4. Template sistemi quality-preserving ama controlled olur
5. Theme secimi urun baglaminin onune gecmez

---

## 22. Bu tez bilgi mimarisine nasil yansir?

Bu tez IA tarafina su emirleri verir:

1. Creator -> storefront -> shelf/content page -> product placement omurgasi kurulmalidir
2. Kategori ana navigation olamaz
3. Search ve tags yardimci katmanda kalmalidir
4. Product library creator tarafinda merkezde ama public tarafta zorunlu ana yuzey olmayabilir
5. Product ve placement farki UI'da acik olmalidir

---

## 23. Bu tez teknik mimariye nasil yansir?

Bu tez mimariye su sonuclari getirir:

1. Import pipeline ayri bir core domain gibi ele alinmalidir
2. Queue, retry, failure classification ve observability gereklidir
3. Public web rendering ve metadata stratejik rol oynar
4. Library, source, placement ve disclosure ayri varliklar olarak dusunulmelidir
5. Stale-data ve broken-link sinyalleri operasyonel izlenmelidir

---

## 24. Bu tez product scope'a nasil yansir?

Bu tez scope tarafina su sonucu verir:

1. Checkout kapsam disi kalir
2. Marketplace feed kapsam disi kalir
3. Heavy analytics suite sonraya birakilir
4. Free-form builder kapsam disi kalir
5. Import, verification, trust ve context pages ilk fazda zorunlu olur

---

## 25. Ilk yil tezinin pratik karsiligi nedir?

Ilk yil boyunca bu urunde "basari" sunlarla okunur:

1. Creator link yapistirarak urun ekleyebiliyor mu?
2. Ayni urunu farkli context'lerde tekrar kullanabiliyor mu?
3. Content-linked page gercekten kullaniliyor mu?
4. Viewer urunu baglamiyla gorup guven duyuyor mu?
5. Ops import sorunlarini siniflayip iyilestirebiliyor mu?

Ilk yil hedefi su degildir:

- tum creator kategorilerini acmak
- tum commerce capability'lerini kurmak
- agir monetization paneli yapmak

Ilk yil hedefi:

> Belirli creator tipleri icin vazgecilmez recommendation publishing davranisi olusturmak.

---

## 26. Bu vizyon hangi sinyallerde bozulmus sayilir?

Asagidaki sinyaller urun tezinin bozuldugunu gosterir:

1. Onboarding tema secimine urun eklemeden daha fazla zaman ayiriyorsa
2. Product library yerine her page'de yeni kart olusuyorsa
3. Content-linked page nadiren kullanilan ikincil bir alan haline geldiyse
4. Public sayfa creator profil gosterisine donuyorsa
5. Trust/disclosure alanlari ayarlar arkasina gomulduyse
6. Roadmap checkout veya marketplace ozellikleriyle dolmaya basladiysa
7. Urunun pazarlama dili monetization merkezli olmaya basladiysa

Bu sinyaller goruldugunde ilgili belge ailesi gozden gecirilmelidir.

---

## 27. Bu belge sonraki belgelere ne emreder?

Bu belge sonraki urun belgelerine su emirleri verir:

1. `02-product-scope-and-non-goals.md` bu tezi scope kurallarina cevirmelidir
2. `03-personas-jobs-and-primary-use-cases.md` actor bazli ihtiyaclari bu tezle uyumlu yazmalidir
3. `20-product-information-architecture.md` context-first karari omurgaya cevirmelidir
4. `23-creator-workflows.md` paste/share + verify + reuse modelini varsayilan akis kabul etmelidir
5. `24-viewer-experience-spec.md` viewer trust ve context anlayisini merkeze almalidir
6. `27-disclosure-trust-and-credibility-layer.md` trust-visible karari UI ve data modeline cevirmelidir

---

## 28. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- urunun hangi kategoriye ait oldugu tek anlamli hale geliyorsa
- urunun ne oldugu kadar ne olmadigi da netlesiyorsa
- sonraki urun kararlarina stratejik test sagliyorsa
- ekip yeni fikirleri bu tezle degerlendirebiliyorsa
- tasarim, IA, import ve trust kararlarinin ortak bir merkezi olusuyorsa

Bu belge basarisiz sayilir, eger:

- hala urun link araci mi storefront mu diye tartisiliyorsa
- urunun farki "guzel gorunum" gibi yuzeysel bir dile sikisiyorsa
- import ve trust'in merkezi rolu stratejik anlatimda yeterince yer almiyorsa
- monetization-first veya marketplace-first yorumlar belge icinde acik kapilar bulabiliyorsa

Bu nedenle bu belge, urunun yalnizca nerede durdugunu degil; nereye kaymamasi gerektigini de resmi olarak tanimlar.
