# Creator ürün vitrini / tek bağlantı ürünü kapsamlı araştırma ve ürün raporu

> Tarih: 02 Nisan 2026
> Dil: Türkçe
> Kapsam: güncel internet araştırması + ürün stratejisi + boilerplate uyumlu teknik/ürün çerçevesi

> **Bağlayıcı çerçeve**
>
> Bu rapor kategori-first bir ürün önermiyor. Kategori, yalnızca opsiyonel filtre/etiket katmanı olarak ele alınıyor. Ürün omurgası; creator, vitrin, koleksiyon/shelf, içerik-bağlı sayfa, ürün kartı ve tek-link paylaşımı üzerine kuruluyor.

Bu raporun amacı; planlanan ürünün mevcut pazardaki yerini, doğrudan rakip kümelerini, teknik gerçeklerini, veri çekme mimarisini, cross-platform yüzeylerini ve senin mevcut boilerplate yaklaşımına nasıl oturacağını tek belgede bağlamaktır.

Belge, kamuya açık lansman öncesi içeride kapalı test ve kalite denetimi yapan; fakat dışarıya yarım ürün çıkarmayan bir geliştirme modelini esas alır.

## 1. Yönetici özeti

Net sonuç:

- Bu fikir çalışabilir; fakat 'bir creator linktree klonu' gibi konumlanırsa sıradanlaşır.

- Doğru konum: platform bağımsız, tek bağlantıdan yönetilen, ürün odaklı ama checkout olmayan, 'kullandığım / önerdiğim / bu içerikte geçen' vitrini.

- Kategori ana omurga olmamalı. Kategori sadece filtre, etiket veya görünüm yardımcı bilgisi olarak kalmalı.

- Asıl rekabet alanı link-in-bio/storefront ürünleri ile platform-native shopping araçlarıdır; dolayısıyla fark yaratan alan hız, otomatik ürün içe aktarma, temiz vitrin ve içerik-bağlı sayfa modelidir [K1][K2][K3][K4][K5][K6][K7].

- Bu ürünün teknik merkezi mobil uygulama değil; URL içe aktarma motorudur. Ürünün kaderini burada doğruluk, hız, maliyet ve hata toleransı belirler.

- Fiyat/hasılat/revenue dashboard'u ürün çekirdeği yapılmamalı. Kullanıcıya gösterilecek yüzey sade kalmalı. Operasyonel metrikler ise arka planda zorunludur.

- Boilerplate tabanından türetilecek en doğru model: public web vitrini + creator yönetim yüzeyi (web ve mobil) + sunucu tarafı içe aktarma/yenileme işleyicileri.

> **En kritik ürün cümlesi**
>
> Creator; herhangi bir platformdan tek bir ürün URL'sini paylaşır veya yapıştırır, sistem başlık/görsel/fiyat gibi alanları mümkün olduğunca otomatik çıkarır, creator bunu birkaç saniyede doğrular, sonra tek bağlantıda koleksiyon veya içerik sayfası olarak yayınlar.

## 2. Güncel pazar okuması

Bugün piyasada üç ayrı küme var ve bunları birbirine karıştırmak stratejik hata olur:

### 2.1 Link-in-bio / storefront araçları

- Linktree Shops: şoppable storefront, koleksiyon, analytics ve affiliate odaklı bir yapı sunuyor; ayrıca mevcut Linktree yüzeyine gömülü çalışıyor [K1].

- Beacons: link in bio, store, custom domain, e-posta ve analytics gibi daha geniş 'all-in-one creator platform' çerçevesiyle ilerliyor [K2].

- Stan Store: creator store mantığına yakın; harici URL / media ürünleri eklenebiliyor, farklı kart stilleri bulunuyor [K3].

### 2.2 Affiliate / creator commerce altyapıları

- ShopMy, creator storefront'una eklenen ürünleri affiliate programları üzerinden otomatik monetization çizgisine itiyor [K4].

- LTK, kişisel shop, retailer network, collections ve shoppable link tooling ile daha olgun bir creator commerce modeli sunuyor [K5].

### 2.3 Platform-native shopping yüzeyleri

- YouTube Shopping, creator'ın içerik içinde ürün tag'lemesine imkân veriyor; 2026'da uygun creator eşiği 500 aboneye kadar indirildi [K6].

- TikTok Shop creator sistemi, ürün marketplace'i ve creator bind mantığı ile platform içinde creator-product bağını derinleştiriyor [K7].

- Instagram tarafında shop linking ve creator-shop bağlama modelleri zaten mevcut; yani platform içi commerce mantığı büyüyor, küçülmüyor [K19].

Pazar sonucu şudur:

- Sıfırdan 'creator mağazası' fikri yeni değil.

- Ama platform bağımsız, dış link temelli, hızlı ürün içe aktarma odaklı, sade vitrin mantığı hâlâ savunulabilir.

- Senin ürünün; dijital ürün satışı, kurs satışı, üyelik satışı veya tam affiliate network kurma yerine; creator'ın öneri katmanını daha iyi paketlemeli.

- Rakiplerden kaçış noktası: karmaşık monetization suite değil, düzgün ürün toplama ve düzgün sunum.

### 2.4 Rakip matrisi

| Ürün kümesi | Örnek | Bugün görünen kuvvetli eksen | Bize etkisi |
| --- | --- | --- | --- |
| Link-in-bio / store | Linktree / Beacons / Stan | Storefront, theme, external link, collections, analytics, dijital ürün veya affiliate sunumu [K1][K2][K3]. | Bizim ürün bunlarla aynı sepete düşebilir; bu yüzden daha net öneri-vitrin ve import hızı gerekir. |
| Affiliate-first | ShopMy / LTK | Retailer ağları, otomatik monetization, shoppable link ve collections [K4][K5]. | İlk sürümde bunlarla doğrudan kapışmak yerine nötr link yönetimi ve basit subscription daha mantıklı. |
| Platform-native shopping | YouTube Shopping / TikTok Shop | İçerik içine ürün bağlama ve platform içi commerce akışı [K6][K7]. | Bizim katman platform dışı, tek-link ve çok platformlu olmalı; aksi hâlde platformların gölgesinde kalır. |

## 3. Ürün tezi ve positioning

Ürün tezi:

Creator'ların farklı platformlarda ürettikleri içeriklerde geçen ürünleri, tek bağlantı altında, otomatik veri çekme destekli, görsel olarak güçlü ve hızlı yönetilebilir vitrinde toplamak.

### 3.1 Ürünün ne olmadığı

- Tam e-ticaret checkout sistemi değil.

- Marketplace değil.

- Marka kampanya CRM'i değil.

- Retailer network / affiliate network işletmesi değil.

- Fiyat karşılaştırma motoru değil.

- Ağır analytics ürünü değil.

- Kategori-first katalog ürünü değil.

### 3.2 Ürünün ne olduğu

- Harici ürün linklerini tek yüzeyde toplayan creator vitrini.

- Ürünleri koleksiyon/shelf ve içerik-bağlı sayfalar altında düzenleyen yayın sistemi.

- Link yapıştırıldığında veri çekme ve ilk doldurma yapan creator tool.

- İzleyici tarafında temiz, hızlı, mobilde güçlü public web deneyimi.

- İster YouTube video açıklamasından, ister Instagram bio'sundan, ister TikTok link alanından ulaşılabilen tek-link çözümü.

### 3.3 Positioning cümlesi

> **Önerilen positioning**
>
> Tek linkte, kullandığın veya önerdiğin ürünleri otomatik toparlayan cross-platform creator vitrini.

### 3.4 Kategori konusu - bağlayıcı karar

Kategori, ana ürün omurgası yapılmamalıdır.

- Fitness, beauty, tech, home, fashion, books, office, tools gibi alanların hepsi aynı creator veya aynı vitrin içinde birlikte yaşayabilir.

- Ürünler birden fazla bağlama girebilir; örneğin aynı kamera hem 'çekim setup' hem 'travel kit' hem de belirli bir video sayfasında yer alabilir.

- Bu yüzden top-level IA kategori değil; shelf/collection ve content page olmalıdır.

- Kategori, yalnızca şu işlerde kullanılabilir: filtreleme, arama faceti, görsel badge, otomatik etiketleme, discovery.

## 4. Problem tanımı

### 4.1 Creator tarafındaki asıl problem

- Ürün önerileri farklı içeriklerde ve farklı platformlarda dağınık kalıyor.

- Aynı ürünler tekrar tekrar soruluyor.

- Birden çok link paylaşmak kötü görünüm ve düşük tıklama kalitesi yaratıyor.

- Mevcut link-in-bio/storefront ürünleri çoğu creator için ya fazla genel ya da satış odaklı; 'bu içerikte kullanılanlar' mantığını çekirdeğe koymuyor.

- Ürün ekleme süresi uzadığında creator davranışı bozulur; sistem kullanılsa bile düzenli güncellenmez.

### 4.2 İzleyici tarafındaki asıl problem

- Hangi ürünün gerçekten kullanıldığı veya sadece reklam amaçlı paylaşıldığı net değil.

- Ürün linkleri dağınık ve bağlamsız.

- Story / video / post gördükten sonra ilgili ürünleri tek yerde bulmak zor.

- Dış linkten açılan sayfaların çoğu mobilde yavaş veya dağınık.

### 4.3 İş açısından gerçek problem

- Ürünün asıl bariyeri tasarım değil, veri çekme maliyeti ve doğruluğudur.

- Yanlış ürün görseli veya yanlış fiyat, güveni çok hızlı bozar.

- Creator'ın ilk kurulumdan sonra devamlı kullanım alışkanlığı kazanması gerekir; aksi hâlde ürün bir kere kurulan ölü profile döner.

## 5. Çekirdek ürün ilkeleri

### 5.1 Kategori değil bağlam

Koleksiyon, içerik ve kullanım senaryosu merkezli model kurulmalı. Kategori yalnız yardımcı veri olmalı.

### 5.2 Tekrarsız ekleme

Aynı ürün creator kütüphanesine bir kez girildikten sonra tekrar kullanılabilmeli.

### 5.3 URL-first içe aktarma

Creator'a uzun form doldurtmak ana akış olmamalı. Form yalnız doğrulama ve düzeltme katmanı olmalı.

### 5.4 Varsayılan kalite

Creator hiç tema ince ayarı yapmasa bile vitrin iyi görünmeli.

### 5.5 Sade yüzey

Public sayfada izleyiciyi yoran analytics, gelir, kampanya jargonları görünmemeli.

### 5.6 Şeffaflık

Affiliate / sponsor / gifted / personally bought gibi disclosure alanları basit ama görünür olmalı.

### 5.7 Web-first yayın

Dış trafik önce web yüzeyine gelir. Mobil uygulama yönetim aracı olabilir; ama public tüketim yüzeyi webde kusursuz olmak zorundadır.

### 5.8 Hata toleransı

Veri çekme tam doğru olmazsa kullanıcı düzeltme yapabilmeli; sistem sessizce uydurma yapmamalıdır.

## 6. Yüzey mimarisi

| Yüzey | Kim için | Ana iş | Karar |
| --- | --- | --- | --- |
| Public web | İzleyici | Vitrin görüntüleme, koleksiyon gezme, dış linke çıkış | En kritik yüzey. SEO, hız ve share preview burada kazanılır. |
| Creator mobile app | Creator | Hızlı ürün ekleme, share sheet'den alma, küçük düzenlemeler, publish | Günlük kullanım için ana operasyon yüzeyi. |
| Creator web app | Creator | Toplu düzenleme, tema ayarı, domain, koleksiyon yönetimi | Masaüstünde yönetim kolaylığı. |
| Admin / ops | İç ekip | Domain destekleri, job kuyruğu, import başarısı, abuse yönetimi | Kullanıcı yüzeyinden ayrı tutulmalı. |

> **Bağlayıcı yüzey kararı**
>
> Ürün 'mobile app first' değil; 'creator workflow mobile-friendly, public consumption web-first' olarak tasarlanmalı.

## 7. Yayına çıkacak ürün kapsamı

Buradaki amaç dışarıya yarım ürün vermek değil; ama iç geliştirme akışını decompose etmek için kapsamın net çizilmesi gerekir.

### 7.1 Zorunlu çekirdek alanlar

| Alan | Açıklama | Durum |
| --- | --- | --- |
| Hesap ve erişim | E-posta / Google / Apple giriş, kullanıcı adı/slug, subscription durumu | Zorunlu |
| Storefront | Profil başlığı, kısa açıklama, avatar/kapak, link alanı, disclosure tercihleri | Zorunlu |
| Koleksiyon / shelf | Manuel ve sürükle-bırak sıralama, kapak görseli, başlık, kısa açıklama | Zorunlu |
| İçerik sayfası | Belirli video/story/post için özel sayfa; thumbnail veya kısa açıklama ile | Zorunlu |
| Ürün içe aktarma | Tek URL yapıştırma, veri çekme, doğrulama, yayınlama | Zorunlu |
| Ürün kütüphanesi | Tek ürünün tekrar kullanılabilmesi | Zorunlu |
| Tema / template | Az ama güçlü preset'ler | Zorunlu |
| Fiyat gösterimi | Para birimi, son kontrol zamanı, stale davranışı | Zorunlu |
| Disclosure | Affiliate / sponsor / gifted / own purchase gibi etiketler | Zorunlu |
| Derin link / paylaşım | Public URL, app link, paylaşıma uygun card | Zorunlu |
| Desteklenmeyen domain davranışı | Manuel giriş fallback'i, kullanıcıya net durum | Zorunlu |

### 7.2 Bilinçli olarak dışarıda bırakılması gerekenler

- Uygulama içi checkout

- Sipariş / kargo / iade yönetimi

- Tam affiliate ağ entegrasyonu ve ödeme dağıtımı

- Ağır gelir paneli ve hasılat muhasebesi

- Retailer stock intelligence ürünü

- Brand-campaign CRM

- Marketplace discovery feed

- UGC brief / campaign ops sistemi

### 7.3 Basit ama yeterli creator plan modeli

- Public free tier yerine kısa trial + ücretli plan daha mantıklı olabilir. Sebep: scraping/rendering maliyeti kullanıcı başına gerçek maliyet yaratır.

- Aşırı plan karmaşası gereksiz. Başlangıç için aylık ve yıllık tek creator planı yeterli olabilir.

- İleri dönemde ekip/assistant erişimi ayrı katman olabilir; ama ilk dış sürümde mecburi değildir.

## 8. Bilgi mimarisi ve yayın modeli

### 8.1 Temel varlıklar

- Creator

- Storefront

- Shelf / Collection

- Content Page

- Product

- Product Source

- Merchant Capability

- Theme Preset

- Disclosure Profile

- Import Job

### 8.2 Önerilen route modeli

> **/@kullaniciadi**
>
> /@kullaniciadi/shelf/daily-carry<br>/@kullaniciadi/content/my-desk-setup-video<br>/@kullaniciadi/product/sony-zv-e1<br>/r/abc123 -> canonical public URL'ye redirect

### 8.3 Sayfa tipleri

- Storefront ana sayfası: creator özet, öne çıkan shelf'ler, son içerik sayfaları.

- Shelf sayfası: seçili ürün grubu, grid/list toggle, filtreler.

- Content page: belirli bir video/post/story ile ilişkili ürünler. Bu sayfa ürünün esas farklılaştırıcı yüzeyi olmalı.

- Product detail / light detail: tek ürün için detay, not, dış link ve disclosure.

### 8.4 Kategori kullanımı

- Kategori tekil field olarak tutulabilir ama zorunlu olmamalı.

- Otomatik kategori tahmini yapılabilir fakat creator override edebilmelidir.

- Birden çok etiket desteği daha güçlüdür: örn. 'camera', 'travel', 'office', 'video'.

- Filtre mimarisi faceted search mantığında kurgulanmalı; kategori ağacı zorunlu değildir.

## 9. URL içe aktarma ve veri çıkarma mimarisi

Bu ürünün en kritik teknik hattı budur. Başarısız olursa vitrin ne kadar güzel olursa olsun ürün zayıflar.

### 9.1 Altın kural

> **İçe aktarma ilkesi**
>
> Structured veri varsa önce onu kullan. Yapısal veri yoksa HTML ve meta katmanlarına düş. AI yalnızca fallback ve normalizasyon katmanı olsun. AI fiyat uyduran kaynak değil, belirsizlik yöneten yardımcı katman olmalı.

### 9.2 Önerilen extraction sırası

- URL normalization: tracking parametrelerini temizle, canonical link'i bul, mobil/desktop varyasyonları normalize et.

- HTTP fetch + raw HTML al.

- JSON-LD / Microdata / RDFa Product alanlarını tara. Google, Product structured data ile price, availability, ratings, shipping info gibi alanların işaretlenebildiğini açıkça dokümante ediyor [K8][K9].

- Open Graph / Twitter card metadata'yı tara. Sosyal paylaşım preview altyapısının ana standardı Open Graph'tır [K11].

- Siteye özel merchant adapter varsa onu çalıştır.

- Dinamik içerik gerekiyorsa headless render (Playwright veya servis).

- Gerekirse CSS selector bazlı screenshot veya full-page screenshot alıp görüntü adayı seçimi yap. Yönetilen scraping servislerinde bu özellikler mevcut [K14].

- AI ile başlık temizleme, fiyat regex sonucu doğrulama, doğru görsel adayını seçme, kategori/etiket tahmini, duplicate tespiti yap.

- Creator doğrulama ekranına düş.

- Yayınlanabilir ürün kaydı oluştur.

### 9.3 Structured data neden kritik

- Google JSON-LD'yi öneriyor ve structured data'nın görünür içerikle uyuşmasını, güncel olmasını ve yanıltıcı olmamasını şart koşuyor [K9].

- Birçok ecommerce sayfasında Product markup zaten bulunuyor; bu yüzden ilk atak her zaman structured katman olmalı [K8][K10].

- Bu yaklaşım scraping maliyetini düşürür, doğruluğu artırır ve HTML kırıldığında daha dayanıklı olur.

### 9.4 Managed extraction servisleri konusunda net değerlendirme

- Evet, Playwright + proxy + ücretli scraping servisleri bu problemi gerçek dünyada yönetilebilir hâle getirebilir.

- Zyte gibi servisler ecommerce veri çıkarma için otomatik extraction sunuyor [K13].

- ScrapingBee gibi servisler render ve screenshot işlerini soyutluyor [K14].

- Ama bu, domain-farklılığı problemini tamamen ortadan kaldırmaz; yalnız operasyonel yükü düşürür.

- En doğru yaklaşım: önce ucuz ve deterministik katmanlar, sonra render, en sonda managed fallback.

### 9.5 Merchant capability registry

- Her domain için destek seviyesi tutulmalı: full, partial, fallback-only, blocked.

- Domain bazında hangi extractor sırasının kullanılacağı bilinebilir olmalı.

- Domain bazında yeniden deneme, cooldown, screenshot ihtiyacı ve fiyat güven puanı tutulmalı.

- Sorunlu domain'ler için kill switch olmalı.

### 9.6 Creator doğrulama ekranı ne göstermeli

- Başlık

- Ana görsel

- Fiyat

- Para birimi

- Merchant adı

- Kaynak URL

- Extraction confidence

- Son kontrol zamanı

- Varyant / beden / renk alanları gerekiyorsa opsiyonel not

### 9.7 Hatalı veya eksik extraction davranışı

- Eksik fiyat varsa ürün yine kaydedilebilir; fiyat alanı boş ve 'fiyat gösterme' kapalı olabilir.

- Görsel şüpheliyse creator seçimi istenmeli.

- Başlık kötü ise AI normalizasyon önerisi gösterilmeli ama sessizce overwrite yapılmamalı.

- Tam desteklenmeyen domain'lerde manuel kart oluşturma fallback'i her zaman mevcut olmalı.

### 9.8 Fiyat alanı için doğru yaklaşım

- Fiyat gösterilecekse yanında son doğrulama zamanı tutulmalı.

- Belirli süreyi geçen fiyat 'güncel olmayabilir' badge'i almalı.

- Gerekirse creator fiyatı tamamen gizleyebilmelidir.

- Fiyat ürünün ana vaat katmanı değil; yardımcı bilgidir. Fiyat yanlışsa güven kaybı daha büyük olduğundan gizleme seçeneği önemlidir.

## 10. AI'nin rolü

AI burada çekirdek veri kaynağı değil, kalite artırıcı yardımcı katmandır.

| Yapmalı | Yapmamalı |
| --- | --- |
| Başlık temizleme ve normalize etme | Fiyatı kafadan üretmek |
| Ürün tipi / etiket tahmini | Görsel emin değilse sanki doğruymuş gibi seçmek |
| Görsel adayları arasında en olası ana görseli sıralama | Merchant veya ürün modelini uydurmak |
| Duplicate tespiti | Yanlış structured data ile çelişen sessiz override yapmak |
| Aynı merchant'tan gelen varyantları bağlama önerisi | Creator onayı olmadan kritik alanları final kabul etmek |
| Creator notu için kısa taslak önerileri | Disclosure kararını tek başına vermek |

## 11. Ana kullanıcı akışları

### 11.1 İlk kurulum

- Kayıt ol / giriş yap

- Kullanıcı adı seç

- Storefront başlığı ve kısa bio gir

- Varsayılan tema seç

- İlk shelf oluştur veya geç

- İlk URL içe aktar

### 11.2 Hızlı ürün ekleme

- Creator linki yapıştırır veya paylaş menüsünden gönderir.

- Sistem ön doldurma yapar.

- Creator 1-2 kritik alanı kontrol eder.

- Hangi shelf veya content page'e gideceğini seçer.

- Publish eder.

### 11.3 İçerik-bağlı sayfa akışı

- Creator yeni içerik sayfası açar.

- İçeriğe başlık, thumbnail, kısa açıklama verir.

- Kendi kütüphanesinden ürün ekler veya yeni ürün import eder.

- Sayfa tek link olarak paylaşılır.

### 11.4 İzleyici akışı

- Sosyal platformdaki tek linke tıklar.

- Mobil uyumlu vitrine düşer.

- Shelf veya content page görür.

- Ürün notunu okur, disclosure badge'i görür.

- Harici merchant linkine çıkar.

### 11.5 Tasarımda kaçınılacak UX hataları

- Creator'a ilk aşamada çok fazla ayar sormak

- Her import sonrası zorunlu uzun form açmak

- Public sayfada çok büyük profil alanı ve ürünleri aşağı itmek

- Template özgürlüğünü kullanıcıyı boğacak kadar açmak

- Ürün kartını gereğinden fazla bilgi ile kalabalıklaştırmak

- Fiyat tazeliği belirsizken kesin fiyat gibi göstermek

## 12. Boilerplate ile hizalama

Bu proje mevcut boilerplate yaklaşımından türetileceği için ürün kararı yalnız iş kararı değildir; seçilen temel teknoloji ve kalite standartlarına da oturmalıdır.

### 12.1 Uygun mimari hizalama

- Cross-platform yüzey: Expo/React Native tabanı korunabilir.

- Public web: Expo Router web/static rendering çizgisi mantıklıdır; deep links ve route-based yapı bunun için güçlüdür [K18].

- Mobile yönetim yüzeyi: Expo Router route modeli ve typed routes daha sürdürülebilir olur [K18].

- Firebase Auth + Firestore ana ürün verisi için uygun; fakat scraping/rendering işçileri istemciye bırakılmamalı, sunucu tarafında ayrı servis olarak tutulmalıdır.

- Ağır import işleri için Cloud Run / queue worker tipi yapı, klasik istemci çağrısından daha uygundur.

- Design system tarafında NativeWind-first yaklaşım, tema preset'lerini yönetmek için avantaj sağlar.

### 12.2 HIG ve tasarım standardı etkisi

- Mobil creator yüzeyi HIG-first olmalı; ürün ekleme, seçme, düzenleme akışlarında iOS native hissi bozulmamalı.

- Aşırı dekoratif storefront template'leri yerine okunaklı, ritimli, dokunma hedefleri doğru preset'ler kullanılmalı.

- Sistem; erişilebilirlik label'ları, kontrast, touch target, safe area, reduce motion gibi guardrail'leri bozmadan genişlemeli.

- Public vitrin de aynı tasarım sisteminden türeyebilir; ama native bileşenlerin web karşılığında performans ve SEO gözetilmelidir.

### 12.3 Share extension konusu - kritik teknik not

- Apple'ın share extension modeli sistem seviyesinde güçlü ve resmîdir [K15]. Android tarafında da URL/text share alma intent temelli resmî akıştır [K16].

- Expo tarafında expo-sharing artık paylaşma/alma desteği sunuyor; ancak iOS incoming share akışı için dokümanda deneysel ve gelecekte kırılabilir uyarısı var [K18].

- Bu nedenle ürünün hızlı ekleme vaadi share sheet'e dayanacaksa, üretim kalitesinde ya native share extension plugin ya da özel native entegrasyon planlanmalıdır.

- Sadece clipboard/paste akışıyla kalınırsa ürün yine yaşar; ama günlük kullanım frekansı düşebilir.

### 12.4 Universal links / app links

- Public URL'nin app içine düşmesi için iOS Universal Links ve Android App Links yapılandırılmalı [K17][K18].

- Expo Router ve ilgili linking dökümantasyonu bunu destekliyor; iki yönlü association dosyaları ve route modeli düzgün kurulmalıdır [K18].

- Bu sayede kullanıcı web linkinden uygulamadaki ilgili shelf/content sayfasına sorunsuz geçebilir.

## 13. Public web, SEO ve paylaşım kartları

- Her public sayfanın OG meta verisi olmalı; aksi hâlde sosyal paylaşım kartı zayıf görünür [K11].

- Collection / content page düzeyinde dinamik OG image üretimi düşünülmeli.

- Google structured data tarafında; page type neyse ona uygun, görünür içerikle eşleşen JSON-LD kullanılmalı. JSON-LD önerilen formattır [K9].

- Tek ürün sayfalarında Product markup, koleksiyon sayfalarında liste yapısı ve görünür içerikle uyumlu item markup tercih edilebilir [K8][K10].

- Structured data görünmeyen veya güncel olmayan içeriği temsil etmemeli; aksi hâlde kalite sorunu ve güven sorunu doğar [K9].

## 14. Önerilen veri modeli

| Entity | Ana alanlar | Not |
| --- | --- | --- |
| users | displayName, handle, authProviders, plan | Auth ve plan durumu ayrı tutulur. |
| storefronts | userId, title, bio, avatar, cover, themeId | Public ana yüzey kaydı. |
| shelves | storefrontId, title, slug, description, hero, order | Kategori değil bağlam topluluğu. |
| contentPages | storefrontId, sourcePlatform, title, slug, cover, note | Belirli içerik için özel sayfa. |
| products | ownerId, canonicalTitle, primaryImage, notes, tags, disclosure | Creator'ın kendi kütüphanesindeki ürün kaydı. |
| productSources | productId, merchant, url, canonicalUrl, price, currency, lastCheckedAt, confidence | Kaynak merchant bağlantısı ve extraction sonucu. |
| productPlacements | productId, shelfId/contentPageId, position, customTitle, customNote | Aynı ürünün farklı yüzeylerde farklı sunumu. |
| importJobs | submittedBy, sourceUrl, status, extractorPath, errors | İçe aktarma izleme kaydı. |
| merchantCapabilities | domain, supportLevel, extractorType, refreshPolicy | Domain davranış kaydı. |
| themePresets | layout, cardStyle, typography, spacing | Preset mantığı; sonsuz özgürlük yerine kontrollü varyant. |

### 14.1 Önemli model kararı

Ürün ile ürünün placement'ı ayrı entity olmalıdır.

- Aynı ürün farklı shelf veya content page içinde farklı başlık/not ile gösterilebilir.

- Bu sayede creator aynı ürünü tekrar tekrar oluşturmadan bağlama göre sunabilir.

- Bu model aynı zamanda scraping maliyetini de düşürür; kaynak veri tek yerde tutulur.

## 15. Operasyon, güvenlik ve kalite guardrail'leri

### 15.1 Sunucu tarafı zorunlulukları

- Scraping anahtarları ve proxy erişimleri istemciye asla açılmamalı.

- Import job'ları kuyruk üzerinden yürümeli.

- Aynı URL için dedupe yapılmalı.

- Rate limiting kullanıcı, domain ve IP bazında düşünülmeli.

- Abuse eden domain/pattern için bloklama ve manual review imkânı olmalı.

### 15.2 İç kalite metrikleri

- Import success rate

- Price extraction success rate

- Image correctness dispute rate

- Manual correction frequency

- Domain-level failure distribution

- Median import time

- Publish completion rate

- Broken link rate

Not:

Bunlar kullanıcıya gösterilecek monetization analytics değil; ürün ekibinin kalite denetimi için iç operasyon metrikleridir.

### 15.3 Moderasyon ve abuse

- Yasak domain listesi

- Spam veya zararlı URL tespiti

- Açık yetişkin içerik veya illegal satış yüzeylerini engelleme

- Kötü niyetli redirect zincirlerini kesme

- Raporlama mekanizması

## 16. Uyum ve disclosure

Creator ürün öneriyorsa ve marka ilişkisi varsa disclosure alanı opsiyonel değil, çekirdek parça olmalıdır.

- FTC, marka ilişkilerinin açık ve anlaşılır şekilde disclose edilmesini bekliyor [K12].

- Bu yüzden ürün kartı veya sayfa seviyesinde basit disclosure badge sistemi gerekli.

- Önerilen alanlar: affiliate, sponsorlu, gifted, creator'ın kendi satın alımı, partner link.

- Disclosure görünmez veya ayar ekranının içine saklanmış olmamalı.

- Bölgesel mevzuat farklılaşabilir; bu nedenle metinler locale bazlı yönetilebilmelidir.

## 17. Template ve görsel sistem

- Çok sayıda zayıf template yerine 5-8 güçlü preset daha doğrudur.

- Preset'ler layout ve density farkı yaratmalı; brand eğlence parkına dönmemeli.

- Örnek preset kümeleri: minimal grid, editorial list, collage hero, stack cards, story-friendly compact.

- Creator'a renk/font sisteminde sınırlı ama kaliteli kontrol verilmeli.

- Bir preset hem storefront hem shelf hem content page üzerinde tutarlı davranmalıdır.

### 17.1 Kart bileşeninde önerilen alan sırası

- Görsel

- Başlık

- Creator kısa notu

- Fiyat (varsa ve tazeyse)

- Disclosure badge

- Merchant adı

- CTA

## 18. Yayın stratejisi: dışarıya MVP çıkmadan geliştirme

Bu rapor, kamuya yarım ürün çıkarma yaklaşımını esas almıyor. Bunun yerine iç kapalı geliştirme ve kalite kapıları öneriyor.

| Aşama | Amaç | Çıkış kriteri |
| --- | --- | --- |
| Foundation | Auth, storefront, shelf, product library, public routing, theme preset temeli | İçe aktarma hariç ürün omurgası tamam |
| Import Engine | URL pipeline, merchant registry, verification UI, stale price davranışı | Seçilen pilot domain setinde kabul edilebilir başarı |
| Creator Workflow | Mobil/web yönetim, share intake, hızlı publish, content page akışı | Günlük kullanım akışı akıcı |
| Quality Hardening | Broken links, abuse, performance, disclosure, copy polish | Kapalı testte sürekli kullanım |
| Launch Readiness | Subscription, legal pages, support flow, observability | Dış yayına hazır bütünlük |

### 18.1 Launch gate checklist

- Top merchant/domain setinde import doğruluğu kabul edilebilir olmalı.

- Yanlış görsel/fiyat oranı düşürülmüş olmalı.

- Public sayfalar mobilde hızlı olmalı.

- Universal/app links doğru çalışmalı.

- Template seti gerçekten tatmin edici görünmeli.

- Disclosure ve hukuki metinler hazır olmalı.

- Support / unsupported domain davranışı net olmalı.

## 19. Ana riskler ve karşı hamleler

| Risk | Ne olur | Karşı hamle |
| --- | --- | --- |
| Scraping kırılganlığı | Yanlış veri, yüksek maliyet, support yükü | Structured-first, registry, cache, managed fallback, manual correction |
| Platform klonu gibi görünmek | Ürün sıradanlaşır | Positioning'i recommendation shelf ve content page üstüne kur |
| Ağırlaştırılmış feature scope | Ürün gereksiz karmaşıklaşır | Checkout, full analytics, marketplace gibi alanları dışarıda tut |
| Yetersiz publish hızı | Creator düzenli kullanmaz | Paste/share -> verify -> publish akışını kısalt |
| Share extension kırılmaları | Mobil ekleme deneyimi bozulur | Native-grade extension planı ve clipboard fallback |
| Fiyat tazeliği sorunu | Güven bozulur | lastCheckedAt, stale badge, hide price opsiyonu |
| Abuse / spam URLs | Güvenlik ve itibar sorunu | Domain policy, scanning, rate limit, report flow |

## 20. Nihai öneri

Bu ürünü başlatmanın doğru yolu şudur:

- Kategori-temelli bir katalog ürünü kurma.

- Platformdan bağımsız bir creator recommendation / product shelf ürünü kur.

- Tek link + hızlı import + bağlamlı koleksiyon + içerik sayfası dörtlüsünü ürün çekirdeği yap.

- Checkout, ağır analytics ve affiliate network kurma işlerini sonraya bırak.

- Public experience'ı web-first tasarla; creator workflow'u mobilde çok hızlı yap.

- Scraping'i romantize etme ama abartıp da korkma; structured-first ve managed fallback ile bu alan yönetilebilir.

- Boilerplate'ten türetirken HIG, design system, Firebase boundary ve docs-first disiplinini bozmadan ilerle.

> **Tek cümlelik final karar**
>
> En doğru ürün; 'creator mağazası' değil, 'creator'ın kullandığı/önerdiği ürünleri tek linkte bağlamlı ve otomatik toplayan yayın sistemi' olmalıdır.

## Ek A. Stratejik ayrışma notları

- Linktree / Beacons / Stan kümesi daha genel creator monetization ürünleri gibi davranıyor [K1][K2][K3].

- ShopMy / LTK kümesi affiliate network ve retailer erişimi üzerinden güçleniyor [K4][K5].

- YouTube Shopping / TikTok Shop gibi platform-native araçlar içerik içi commerce'i büyütüyor [K6][K7].

- Bu yüzden senin ürünün; platform-neutral, external-link-first, simple-subscription ve creator-speed odaklı olmalı.

## Ek B. Kaynak notları ve araştırma yöntemi

Araştırma, mümkün olduğunca birincil kaynaklara ve resmi ürün/dokümantasyon sayfalarına dayanır. Rakip ürünlerde özellikle resmi feature/help/pricing sayfaları tercih edilmiştir.

- Resmî ürün sayfaları: Linktree, Beacons, Stan, ShopMy, LTK, TikTok Shop, YouTube.

- Resmî teknik dokümantasyon: Google Search Central, Schema.org, Open Graph, Apple Developer, Android Developers, Expo docs.

- Regülasyon / disclosure: FTC.

## Ek C. Kaynak listesi

- K1: Linktree Help Center / Linktree feature pages (erişim: 02 Nisan 2026): 'Linktree Shops: How to guide' ve 'Affiliate Storefront for Creators / Linktree Shops'.

- K2: Beacons resmî sayfaları (erişim: 02 Nisan 2026): ana ürün sayfası, pricing ve store açıklamaları.

- K3: Stan Store Help Center (erişim: 02 Nisan 2026): 'How to Create a URL / Media Product'.

- K4: ShopMy resmî creators sayfası (erişim: 02 Nisan 2026).

- K5: LTK Creator resmî sayfası (erişim: 02 Nisan 2026).

- K6: YouTube Help ve YouTube Blog (erişim: 02 Nisan 2026): YouTube Shopping affiliate overview ve Mart 2026 creator threshold güncellemesi.

- K7: TikTok Shop resmî creator sayfaları (erişim: 02 Nisan 2026): creator overview ve creator eligibility.

- K8: Google Search Central (erişim: 02 Nisan 2026): 'Introduction to Product structured data'.

- K9: Google Search Central (erişim: 02 Nisan 2026): 'General structured data guidelines'.

- K10: Schema.org (erişim: 02 Nisan 2026): Product ve ProductCollection tanımları.

- K11: Open Graph protocol resmî sitesi (erişim: 02 Nisan 2026).

- K12: FTC ve eCFR kaynakları (erişim: 02 Nisan 2026): influencer disclosures ve Endorsement Guides.

- K13: Zyte documentation (erişim: 02 Nisan 2026): automatic extraction.

- K14: ScrapingBee documentation (erişim: 02 Nisan 2026): HTML rendering ve screenshot yetenekleri.

- K15: Apple Developer documentation (erişim: 02 Nisan 2026): Share extensions / App Extension Programming Guide.

- K16: Android Developers (erişim: 02 Nisan 2026): shared data receive flow.

- K17: Android Developers (erişim: 02 Nisan 2026): deep links / app links.

- K18: Expo documentation (erişim: 02 Nisan 2026): expo-sharing, Expo Router, iOS Universal Links ve incoming link docs.

- K19: Instagram Help Center arama snippet'ları (erişim: 02 Nisan 2026): shop linking ve creator-shop bağlama yüzeyleri.
