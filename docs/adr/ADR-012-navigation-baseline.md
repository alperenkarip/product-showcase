# ADR-012 — Navigation Baseline

## Doküman Kimliği

- **ADR ID:** ADR-012
- **Başlık:** Navigation Baseline
- **Durum:** Accepted
- **Tarih:** 2026-04-01
- **Karar türü:** Foundational navigation technology and routing baseline decision
- **Karar alanı:** Web routing, mobile navigation, navigator pattern, deep link strategy, cross-platform navigation parity
- **İlgili üst belgeler:**
  - `08-navigation-and-flow-rules.md`
  - `17-technology-decision-framework.md`
  - `36-canonical-stack-decision.md`
  - `38-version-compatibility-matrix.md`
  - `ADR-001-web-runtime-and-application-shell.md`
  - `ADR-002-mobile-runtime-and-native-strategy.md`
- **Etkilediği belgeler:**
  - `19-roadmap-to-implementation.md`
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `35-document-map.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında navigation baseline için aşağıdaki karar kabul edilmiştir:

- **Web navigation:** React Router 7.x — SPA-first client-side routing (ADR-001 ile uyumlu)
- **Mobile navigation:** React Navigation 7.x stable baseline
- **React Navigation 8.x:** Watchlist — pre-release statüsündedir, canonical baseline değildir
- **Expo Router:** Bu baseline'da canonical seçim yapılmamıştır
- **Tek router abstraction katmanı:** Bu baseline'da bilinçli olarak seçilmemiştir
- **Navigator pattern:** Stack, tab, drawer ve modal pattern'leri platform-native convention'lara uygun biçimde kullanılacaktır
- **Deep link stratejisi:** Tek URL şeması, Universal Links / App Links odaklı, cross-platform tutarlı

Bu karar, web ve mobile navigation'ı aynı router soyutlamasına kilitlemeden, her platformun güçlü yönlerini koruyarak davranışsal parity sağlamak için verilmiştir.

---

# 2. Problem Tanımı

Boilerplate için navigation tarafında verilmesi gereken kritik erken kararlardan biri şudur:

> Web ve mobile platformlarda hangi navigation runtime ve routing altyapısı canonical baseline kabul edilecek?

Bu karar erken verilmezse şu sorunlar çıkar:

- web tarafında routing modeli, mobile'daki navigation modeli ile zihinsel olarak kopar,
- navigator pattern'leri (stack, tab, modal, drawer) platform düzeyinde keyfileşir,
- deep link stratejisi web ve mobile arasında tutarsızlaşır,
- mobile navigation kütüphanesi seçimi "sonra bakarız" mantığıyla gecikir ve refactor maliyeti büyür,
- React Navigation 8.x gibi pre-release hatlar yanlışlıkla canonical baseline gibi kullanılır,
- Expo Router ve React Navigation arasındaki karar belirsiz kalır,
- route tanımları web ve mobile'da bağımsız, birbiriyle uyumsuz yapılara sürüklenir,
- app shell ve navigation wiring arasındaki sorumluluk sınırı bulanıklaşır,
- testing stratejisinde navigation-aware test kapsamı tanımsız kalır.

Bu nedenle navigation baseline kararı boilerplate seviyesinde bilinçli ve erken kilitlenmelidir.

---

# 3. Bağlam

Bu boilerplate'in navigation kararını çevreleyen temel gerçeklikler şunlardır:

1. **Web runtime kararı verilmiştir (ADR-001):** React + Vite + React Router 7.x tabanlı SPA-first application shell. Web routing bu karar ile kilitlenmiştir.

2. **Mobile runtime kararı verilmiştir (ADR-002):** React Native + Expo tabanlı, Expo-first managed/development-build workflow. Mobile navigation runtime bu zemin üzerine oturmalıdır.

3. **Canonical stack navigation hattı belirlenmiştir (36-canonical-stack-decision.md, bölüm 13):** React Router 7 (web), React Navigation 7 stable baseline (mobile), React Navigation 8 watchlist.

4. **Version compatibility matrix navigation hattı tanımlanmıştır (38-version-compatibility-matrix.md):** React Router 7.x web baseline, React Navigation 7.x stable mobile baseline, 8.x watchlist.

5. **Navigation technology decision framework'te kapalı alan olarak işaretlenmiştir (17-technology-decision-framework.md):** Navigation baseline React Router 7 (web) + React Navigation 7 (mobile) olarak kapalı alana alınmıştır. Değişiklik ADR ve compatibility revalidation gerektirir.

6. **Navigation ve flow kuralları belirlenmiştir (08-navigation-and-flow-rules.md):** Behavior parity, navigator pattern'leri, deep link stratejisi, back davranışı standardı ve UX governance bu belgede tanımlanmıştır. Bu ADR, 08'in teknik tool kararıdır.

7. **Cross-platform parity hedefi aktiftir:** Web ve mobile aynı ürün ailesinin parçasıdır. Navigation runtime'ları farklı olabilir ama ürün davranışı tutarlı olmalıdır.

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Platform-native navigation hissiyatını koruma gücü**
2. **Cross-platform behavior parity sağlama yeteneği**
3. **ADR-001 ve ADR-002 ile mimari uyum**
4. **Deep link ve Universal Links / App Links desteği**
5. **Navigator pattern desteği (stack, tab, modal, drawer, sheet)**
6. **TypeScript type safety ve typed navigation desteği**
7. **Ekosistem olgunluğu ve bakım sürekliliği**
8. **Expo SDK 55 ile doğrudan uyumluluk**
9. **React 19.2.x ile uyumluluk**
10. **Testing stack ile uyum (navigation-aware test yazılabilirliği)**
11. **Gereksiz abstraction ve lock-in riski**
12. **Documentation-first karar modeli ile uyum**

---

# 5. Değerlendirilen Alternatifler

Bu karar verilmeden önce aşağıdaki ana alternatifler düşünülmüştür:

1. React Router 7.x (web) + React Navigation 7.x (mobile) — ayrı canonical baseline
2. Expo Router (web + mobile birleşik router)
3. React Navigation 8.x (mobile canonical baseline)
4. Tek router abstraction katmanı (web ve mobile'ı saran ortak soyutlama)
5. React Router (web) + React Navigation 8.x (mobile)

Aşağıda neden seçildikleri veya seçilmedikleri açıklanmıştır.

---

# 6. Seçilen Karar: React Router 7.x (Web) + React Navigation 7.x (Mobile)

## 6.1. Web Navigation: React Router 7.x

### 6.1.1. Neden React Router 7.x?

React Router 7.x seçimi ADR-001 ile doğrudan uyumludur. Bu karar burada tekrar kilitlenmektedir:

- **SPA-first routing modeli:** Bu boilerplate'in web tarafı SSR-first değil, SPA-first application shell modelidir. React Router bu modele doğal uyum sağlar.
- **Nested route desteği:** Feature-aware, route-group destekli yapı React Router ile olgun biçimde kurulur.
- **Route-level composition:** App shell → route groups → feature screens zinciri doğal çalışır.
- **Typed route desteği:** TypeScript ile route parametrelerinin type-safe kullanımını destekler.
- **Web URL modeli ile doğal uyum:** Path-based routing, query parameters, hash navigation doğal çalışır.
- **Deep link eşleşmesi:** Web URL yapısı aynı zamanda cross-platform deep link şemasının temeli olur.

### 6.1.2. Web routing'in navigation parity'deki rolü

Web routing, mobile navigation ile birebir aynı container kullanmaz. Ama aynı ürün akışını yansıtır:

- aynı route path yapısı kullanılır (`/profile/:id`, `/settings`, `/order/:id`),
- behavior parity korunur (aynı görev aynı mantıkla tamamlanır),
- deep link şeması her iki platformda aynı URL yapısına dayanır,
- presentation farklılığı (web'de side panel, mobile'da stack push) kabul edilir.

---

## 6.2. Mobile Navigation: React Navigation 7.x

### 6.2.1. Neden React Navigation 7.x?

React Navigation 7.x, mobile navigation baseline olarak seçilmiştir. Nedenleri şunlardır:

#### 6.2.1.1. Platform-native navigation hissiyatı

React Navigation, mobile platformlarda native-feeling navigation deneyimi sunar:
- iOS'ta UINavigationController benzeri stack push/pop animasyonları,
- Android'de Material Design uyumlu geçişler,
- gesture-based back navigation (iOS edge swipe),
- native header bar desteği,
- tab bar, drawer ve modal presentation native pattern'leri.

Bu hissiyat, Apple HIG ve Android platform beklentileriyle doğrudan uyumludur.

#### 6.2.1.2. Navigator pattern zenginliği

React Navigation 7.x aşağıdaki navigator pattern'lerini olgun biçimde destekler:

- **Stack Navigator:** Hiyerarşik ve ardışık ilerleyen akışlar (liste → detay → düzenle)
- **Tab Navigator (Bottom Tabs):** Ana çalışma alanları arası geçiş
- **Drawer Navigator:** Yan panel navigation (belirli use-case'ler için)
- **Modal presentation:** Ana akış üzerinde geçici bağlam gerektiren akışlar
- **Nested navigators:** Stack içinde tab, tab içinde stack gibi kompozit yapılar

Bu pattern'ler `08-navigation-and-flow-rules.md` bölüm 10'da tanımlanan kullanım ilkeleriyle doğrudan eşleşir.

#### 6.2.1.3. Deep link entegrasyonu

React Navigation 7.x, `expo-linking` ile birlikte güçlü deep link desteği sunar:
- path-based linking configuration,
- nested navigator'lar için çok katmanlı deep link çözümleme,
- Universal Links / App Links desteği,
- auth-gated deep link (deferred deep link) pattern'i için state persistence.

#### 6.2.1.4. Ekosistem olgunluğu

React Navigation:
- React Native ekosisteminin en olgun ve en geniş topluluk destekli navigation çözümüdür,
- çok geniş production kullanımı vardır,
- belgelendirme kalitesi yüksektir,
- React Native yeni sürümleriyle uyum çabası süreklidir.

#### 6.2.1.5. Expo SDK 55 ile doğrudan uyum

React Navigation 7.x, Expo SDK 55 ile sorunsuz çalışır:
- Expo managed workflow'da tam desteklenmiştir,
- `react-native-screens`, `react-native-safe-area-context` ve `react-native-gesture-handler` ile doğal entegrasyonu vardır,
- bu kütüphaneler Expo SDK 55'te bundled olarak gelir.

#### 6.2.1.6. TypeScript desteği

React Navigation 7.x, typed navigation için güçlü altyapı sunar:
- `RootStackParamList` gibi merkezi type tanımları,
- `useNavigation<T>()` ve `useRoute<T>()` hook'ları ile type-safe navigation,
- screen props'ları için otomatik type inference.

---

## 6.3. Navigator Pattern Kararı

### 6.3.1. Stack Navigator

**Kullanım alanı:** Hiyerarşik ilerleme gerektiren tüm akışlar.

**Kurallar:**
- Liste → detay → düzenle gibi doğal derinleşme akışları stack ile kurulur.
- Stack derinliği makul tutulmalıdır; 4+ seviye derin stack zincirleri sorgulanmalıdır.
- Her stack screen geri dönülebilir olmalıdır.
- Stack screen'ler arası veri taşıma route params ile yapılır, global state'e gereksiz bağımlılık oluşturulmaz.

### 6.3.2. Bottom Tab Navigator

**Kullanım alanı:** Uygulamanın eşit ağırlıkta ve sık erişilen ana çalışma alanları.

**Kurallar:**
- Tab sayısı makul olmalıdır (3-5 tab ideal aralıktır).
- Utility veya nadir kullanılan alanlar tab'a konulmaz.
- Her tab kendi stack navigator'ını barındırabilir.
- Tab değişimi state sıfırlama veya veri kaybı üretmemelidir.
- Badge ve unread count gibi göstergeler tab bar üzerinde desteklenir.

### 6.3.3. Modal Presentation

**Kullanım alanı:** Ana akış üzerinde geçici ama kritik bağlam gerektiren işler.

**Kurallar:**
- Modal, kısa ve bağımsız görevler için kullanılır (onay, kısa form, kritik müdahale).
- Modal içinde modal kesinlikle yasaktır.
- Uzun form akışları veya karmaşık nested görevler modal yerine stack screen ile çözülür.
- Dismiss davranışı açık ve tahmin edilebilir olmalıdır.

### 6.3.4. Bottom Sheet

**Kullanım alanı:** Mobile'da kısa seçim, hafif aksiyon, bağlamsal aksiyonlar.

**Kurallar:**
- `@gorhom/bottom-sheet` canonical bottom sheet runtime'ıdır.
- Snap point'ler tanımlı olmalıdır.
- Gesture dismiss desteklenmelidir.
- Çok uzun akışlar veya karmaşık formlar bottom sheet'e sığdırılmaz.

### 6.3.5. Drawer Navigator

**Kullanım alanı:** Web tarafında side navigation, mobile'da belirli use-case'ler.

**Kurallar:**
- Mobile'da drawer kullanımı istisnaidir; bottom tab çoğu durumda daha doğru tercihtir.
- Web'de drawer/side panel, geniş alan avantajı olan durumlarda değerlidir.
- Drawer, bilgi yoğunluğunu iyileştiriyorsa kullanılır; sırf modern görünsün diye açılmaz.

---

## 6.4. Deep Link Stratejisi

### 6.4.1. Temel ilke

Deep link stratejisi `08-navigation-and-flow-rules.md` bölüm 14'te tanımlanan kuralları teknik düzeyde uygular:

> Tek URL şeması tanımlanır ve hem web hem mobile bu yapıyı parse eder.

### 6.4.2. URL şeması

Web URL yapısı aynı zamanda mobile deep link şemasının temelidir:

- `/profile/:id` — profil detayı
- `/order/:id` — sipariş detayı
- `/settings` — ayarlar
- `/chat/:id` — sohbet ekranı

Bu path yapısı web'de React Router route tanımlarıyla, mobile'da React Navigation linking configuration ile birebir eşleşir.

### 6.4.3. Universal Links ve App Links

- iOS tarafında Universal Links (`apple-app-site-association` dosyası ile)
- Android tarafında App Links (`assetlinks.json` dosyası ile)
- Custom URL scheme (`myapp://`) ikincil fallback olarak tutulur ama primary mekanizma değildir
- Expo'da `expo-linking` kütüphanesi bu entegrasyonu sağlar

### 6.4.4. Auth-gated deep link (deferred deep link)

Auth gerektiren deep link hedefleri için:
1. Deep link hedefi geçici olarak saklanır.
2. Kullanıcı login/register akışına yönlendirilir.
3. Auth tamamlandıktan sonra orijinal hedefe otomatik yönlendirme yapılır.
4. Login sonrası kullanıcının ana sayfaya düşmesi kabul edilmez.

### 6.4.5. Fallback davranışı

- Geçersiz ID: "Bu içerik bulunamadı" ekranı gösterilir.
- Yetkisiz erişim: "Bu içeriğe erişim yetkiniz yok" mesajı gösterilir.
- Tanımsız route: Ana sayfaya yönlendirme yapılır.
- Boş ekran veya crash kesinlikle kabul edilmez.

---

## 6.5. Web-Mobile Parity Yaklaşımı

### 6.5.1. Behavior parity önceliklidir

Aynı ürün görevi her iki platformda aynı mantıkla tamamlanabilir olmalıdır. `08-navigation-and-flow-rules.md` bölüm 7'deki parity ilkesi bu ADR'nin teknik kararını yönlendirir:

1. Görev sonucu aynı olmalıdır.
2. Akış mantığı benzer olmalıdır.
3. Hata/geri/iptal davranışı çelişmemelidir.
4. Kullanıcı bağlamı korunmalıdır.
5. Sunum biçimi platforma uygun olmalıdır.

### 6.5.2. Presentation parity zorunlu değildir

Aynı akış farklı navigation container'larla çözülebilir:

| Akış | Web | Mobile |
|---|---|---|
| Detaydan düzenlemeye geçiş | Route change veya side panel | Stack push |
| Hızlı seçim | Dialog veya dropdown | Bottom sheet |
| Ayarlar | Route change | Stack push veya tab |
| Onay akışı | Dialog | Modal veya alert |
| Ana alan geçişi | Sidebar veya top nav | Bottom tab |

Bu farklılık, behavior parity bozulmadığı sürece kabul edilir ve doğaldır.

### 6.5.3. Route path eşleşmesi

Web ve mobile aynı route path yapısını kullanır. Bu eşleşme deep link tutarlılığı, link paylaşımı ve cross-platform test kapsamı için zorunludur.

---

# 7. Neden React Navigation 8.x Canonical Baseline Değil?

Bu soru doğrudan ve açıkça cevaplanmalıdır. Çünkü "neden en yeni sürüm değil?" en doğal itirazlardan biridir.

## 7.1. Karar

React Navigation 8.x bu baseline'da canonical kabul edilmez; **watchlist** statüsündedir.

## 7.2. Nedenleri

### 7.2.1. Pre-release statüsü

`36-canonical-stack-decision.md` bölüm 13.2'de açıkça belirtilmiştir:

> Güncel resmi durumda React Navigation 8 hâlâ pre-release statüsündedir.

Pre-release olan bir kütüphane canonical boilerplate baseline'ı olamaz. Bu proje documentation-first ve stability-first ilkeleriyle ilerler; pre-release hatlara canonical bağımlılık kurmak bu ilkelerle çelişir.

### 7.2.2. Yeni minimum gereksinimler

React Navigation 8.x aşağıdaki minimum gereksinimleri getirir:
- **Expo SDK 55+**
- **React Native 0.83+**
- **TypeScript 5.9.2+**
- **Development build gereksinimi**

Bu gereksinimler mevcut canonical stack ile örtüşse de, pre-release bir kütüphanenin bu gereksinimleri dayatması ayrı bir risk katmanı oluşturur. Canonical stack zinciri (Expo SDK 55 + RN 0.83 + React 19.2) kendi iç uyumuyla stabil çalışmalıdır; pre-release navigation runtime'ının bu zinciri germesi kabul edilmez.

### 7.2.3. API değişiklik riski

Pre-release sürümlerde API yüzeyi henüz kesinleşmemiştir. Canonical baseline'a pre-release almak şu riskleri doğurur:
- breaking API change'ler,
- typed navigation contract'larının kırılması,
- deep link configuration API'sinde değişiklikler,
- navigator pattern API'lerinde uyumsuzluklar.

### 7.2.4. Ekosistem uyumluluk belirsizliği

React Navigation 8.x ile aşağıdaki ekosistem bileşenlerinin uyumluluğu henüz tam doğrulanmamıştır:
- `@react-navigation/bottom-tabs` 8.x hattı,
- `@react-navigation/drawer` 8.x hattı,
- `@react-navigation/native-stack` 8.x hattı,
- `react-native-screens` uyumluluğu,
- third-party navigation helper kütüphaneleri.

### 7.2.5. Static API değişikliği

React Navigation 8.x, static navigation API yönünde önemli değişiklikler getirmektedir. Bu API değişikliği navigation tanım biçimini, deep link configuration modelini ve type inference mekanizmasını etkiler. Bu ölçekte bir API geçişi, repo bootstrap aşamasında değil, stabil sürüm sonrası bilinçli migration olarak yapılmalıdır.

## 7.3. Watchlist ne anlama gelir?

- React Navigation 8.x üzerinde spike / POC yapılabilir.
- Ayrı branch'te deneme yapılması yasak değildir.
- Ama repo başlangıcı 8.x varsayımıyla kurulmaz.
- Production code'da 8.x API'leri kullanılmaz.
- 8.x stable release olduktan sonra resmi değerlendirme başlar.
- Değerlendirme sonucu olumlu ise yeni ADR ile baseline güncellenir.

## 7.4. Sonuç

React Navigation 8.x reddedilmedi; canonical baseline olmaya henüz hazır değildir. Stable release, ekosistem uyumluluğu doğrulaması ve compatibility revalidation sonrası değerlendirilecektir.

---

# 8. Neden Expo Router Seçilmedi?

Bu karar da açıkça gerekçelendirilmelidir.

## 8.1. Karar

Expo Router bu baseline'da canonical navigation seçimi olarak kabul edilmemiştir.

## 8.2. Nedenleri

### 8.2.1. Web ve mobile'da ayrı navigation authority

`36-canonical-stack-decision.md` bölüm 13.4'te bu kararın temel gerekçesi açıkça yazılmıştır:

> Bu boilerplate'in mevcut karar setinde navigation authority şu ayrımla kurulmuştur: web routing ayrı, mobile navigation ayrı, parity behaviour karar seviyesinde korunur, aynı router abstraction'ına gereksiz erken kilitlenilmez.

Bu ayrım bilinçli bir mimari tercihtir.

### 8.2.2. File-based routing erken kısıtlama yaratır

Expo Router, file-system based routing modelini dayatır. Bu model bazı projelerde güçlü olabilir. Ama bu boilerplate için şu sorunları çıkarır:

- route tanımları dosya sistemi yapısına kilitlenir,
- route grouping ve nested navigator composition esnekliği azalır,
- web ve mobile'da aynı route dosya yapısını zorlamak presentation parity'yi gereksiz yere dayatır,
- feature-aware route organization, file-based convention'dan daha esnek olmalıdır.

### 8.2.3. React Router kararı ile çelişir

ADR-001 web tarafında React Router 7.x'i canonical olarak kilitlemiştir. Expo Router seçmek, web tarafında iki farklı routing paradigması veya Expo Router'ın web routing'i devralması anlamına gelir. İkisi de bu boilerplate'in mimari sadelik hedefiyle çelişir.

### 8.2.4. Boilerplate seviyesinde gereksiz router lock-in

Expo Router seçmek, navigation katmanını tek bir framework'e tamamen kilitler. Bu boilerplate, platform-aware navigation kararları vermek için esneklik korumaktadır. Web'de React Router, mobile'da React Navigation bu esnekliği sağlar.

## 8.3. Sonuç

Expo Router reddedilmedi; bu baseline'ın navigation authority modeliyle uyumsuz olduğu için canonical seçim yapılmamıştır. Gelecekte Expo Router olgunlaşır ve file-based routing ile explicit configuration arasında daha esnek bir denge kurarsa, yeniden değerlendirilebilir.

---

# 9. Neden Tek Router Abstraction Katmanı Seçilmedi?

## 9.1. Tanım

Tek router abstraction, web ve mobile navigation'ı saran ortak bir soyutlama katmanıdır. Amaç, feature code'un platform-specific navigation API'lerini bilmemesi ve tek bir navigate() çağrısı ile her iki platformda çalışmasıdır.

## 9.2. Neden seçilmedi?

### 9.2.1. Gereksiz erken soyutlama

Bu tür bir katman, boilerplate'in ilk versiyonunda gereksiz karmaşıklık üretir:
- abstraction API'si tasarlanmalı,
- her iki platformun edge case'leri sarılmalı,
- typed navigation contract'ları çift katmanlı hale gelmeli,
- bakım yüzeyini artırır.

### 9.2.2. Presentation farkları sarılamaz

Web'de dialog açmak ile mobile'da bottom sheet açmak farklı navigation eylemleridir. Tek bir navigate() çağrısı bu farkı sağlıklı biçimde saramaz. Platform-aware navigation kararları feature seviyesinde verilmelidir; abstraction seviyesinde değil.

### 9.2.3. Behavior parity zaten korunuyor

`08-navigation-and-flow-rules.md` ile tanımlanan behavior parity kuralları, ortak router abstraction olmadan da korunabilir. Parity, teknik runtime birliği değil, ürün davranışı tutarlılığıdır.

## 9.3. Sonuç

Tek router abstraction bu aşamada yanlış soyutlama seviyesidir. Navigation shared contracts (route path tanımları, deep link şeması, navigation intent types) paylaşılabilir; ama navigation runtime abstraction'ı gereksiz katmandır.

---

# 10. Navigation ve App Shell İlişkisi

## 10.1. Web

Web'de navigation runtime, application shell'in parçasıdır (ADR-001, bölüm 11-12):
- `createBrowserRouter` + `RouterProvider` root app entry'de kurulur,
- route tanımları app shell tarafından yönetilir,
- feature screen'ler route tanımlarına kayıtlanır,
- app-level error boundary ve auth gate navigation root seviyesinde çözülür.

## 10.2. Mobile

Mobile'da navigation runtime, app shell'in merkezi parçasıdır (ADR-002, bölüm 10):
- `NavigationContainer` root shell'de kurulur,
- linking configuration root seviyesinde tanımlanır,
- root navigator (genellikle stack) auth/main akış ayrımını yönetir,
- tab navigator, main app içindeki ana alan geçişlerini yönetir,
- feature screen'ler ilgili navigator'lara kayıtlanır.

## 10.3. Kural

Navigation runtime mobile ve web shell'in parçasıdır. Feature logic navigation runtime detayını kendi içine gömmemelidir. Feature, navigation intent'i bilir; navigation container detayını bilmez.

---

# 11. Navigation ve Design System İlişkisi

## 11.1. Kural

Navigation chrome (header bar, tab bar, back button, dismiss button) design system governance kapsamındadır:
- Header / NavigationBar component DS tarafından tanımlanır,
- TabBar component DS tarafından tanımlanır,
- navigation geçiş animasyonları motion standard ile uyumlu olmalıdır (`24-motion-and-interaction-standard.md`),
- back/dismiss icon'ları ve aksiyonları DS icon set'inden gelir.

## 11.2. Sonuç

Navigation implementasyonu, design system'den bağımsız visual kararlar almaz. `39-default-screens-and-components-spec.md` bölüm 15'teki canonical navigation component başlangıç seti (C40-C46) bu ilkeyi uygular.

---

# 12. Testing Üzerindeki Etkiler

Bu karar test stratejisinde şu sonuçları doğurur:

1. **Web routing testleri:** React Router ile route rendering, route params, navigation state ve redirect davranışları test edilmelidir.
2. **Mobile navigation testleri:** React Navigation ile screen rendering, navigation actions, deep link resolution ve navigator state testleri yazılmalıdır.
3. **Deep link testleri:** Her deep link route'u, normal akış, auth-gated akış, geçersiz ID ve tanımsız route senaryolarında web ve mobile'da test edilmelidir.
4. **Navigation-aware integration testleri:** App shell wiring, auth gate ve route guard davranışları integration seviyesinde test edilmelidir.
5. **E2E navigation testleri:** Playwright (web) ile user journey doğrulaması, mobile E2E tool ile navigation flow doğrulaması yapılmalıdır.

---

# 13. Repo Yapısı Üzerindeki Etkiler

Bu karar doğrudan şu repo alanlarını etkiler:

- `apps/web` — React Router route tanımları, web shell router setup
- `apps/mobile` — React Navigation navigator tanımları, linking configuration, navigation types
- `packages/shared` — route path constants, deep link şeması, navigation intent types (paylaşılan)
- navigation-related type tanımları (`RootStackParamList`, route params)

`21-repo-structure-spec.md` bu kararla birlikte yorumlanmalıdır.

---

# 14. CI / Build Üzerindeki Etkiler

Bu karar aşağıdaki CI/build sonuçlarını doğurur:

- web route sanity (tüm tanımlı route'ların render edilebilirliği) CI gate olabilir,
- mobile navigation wiring sanity kontrolü CI'da koşulmalıdır,
- deep link configuration ile route tanımları arasındaki tutarlılık doğrulanmalıdır,
- React Navigation 7.x version pin `38-version-compatibility-matrix.md` ile uyumlu tutulmalıdır,
- React Router 7.x version pin `38-version-compatibility-matrix.md` ile uyumlu tutulmalıdır.

---

# 15. Güçlü Yanlar

Bu kararın ana avantajları:

1. **Platform-native navigation korunur:** Her platform kendi güçlü navigation runtime'ını kullanır.
2. **Behavior parity sağlanır:** Aynı ürün davranışı her iki platformda korunur; teknik birebirlik dayatılmaz.
3. **Deep link stratejisi tutarlıdır:** Tek URL şeması her iki platformda çalışır.
4. **Stable baseline kullanılır:** Pre-release veya unproven hatlar canonical kabul edilmez.
5. **Gereksiz abstraction yoktur:** Tek router abstraction katmanı erken soyutlama olarak reddedilmiştir.
6. **Ekosistem olgunluğu yüksektir:** React Router ve React Navigation en olgun seçimlerdir.
7. **ADR-001 ve ADR-002 ile tam uyumludur.**
8. **Type-safe navigation desteklenir:** Her iki runtime typed navigation contract'larını destekler.
9. **Expo SDK 55 ile doğal çalışır.**
10. **08-navigation-and-flow-rules.md ile doğrudan uyumludur.**

---

# 16. Riskler

Bu karar risksiz değildir.

## 16.1. İki ayrı navigation runtime bakım yüzeyini artırır

Web'de React Router, mobile'da React Navigation kullanmak iki farklı API, iki farklı convention ve iki farklı configuration modeli anlamına gelir. Bu, ekip için ek zihinsel yük oluşturabilir.

## 16.2. Route path eşleşmesi manuel korunmalıdır

Web ve mobile'da aynı route path yapısını kullanmak otomatik enforce edilmez. Bu eşleşme disiplin ve test ile korunmalıdır.

## 16.3. React Navigation 7.x → 8.x geçişi gelecekte gerekecektir

React Navigation 8.x stable olduğunda migration gerekecektir. Bu migration navigator API değişikliklerini, deep link configuration güncellemelerini ve type tanım değişikliklerini içerebilir.

## 16.4. Expo Router ekosistem momentum kazanabilir

Expo Router olgunlaştıkça, React Navigation yerine Expo Router'a geçiş baskısı oluşabilir. Bu durumda navigation baseline yeniden değerlendirilmelidir.

## 16.5. Deep link konfigürasyonu karmaşıklaşabilir

Nested navigator yapılarında deep link resolution karmaşıklaşabilir. Bu risk, net ve flat deep link path yapısı ile azaltılır.

---

# 17. Risk Azaltma Önlemleri

Bu kararın risklerini azaltmak için aşağıdaki önlemler zorunludur:

1. **Route path constants paylaşılmalıdır:** `packages/shared` içinde route path tanımları tek kaynaktan yönetilir. Web ve mobile bu tanımları kullanır.
2. **Deep link tutarlılık testi yazılmalıdır:** Web route tanımları ile mobile linking configuration arasındaki eşleşme test ile doğrulanır.
3. **Navigation type tanımları merkezi tutulmalıdır:** `RootStackParamList` ve route params type'ları tek yerde tanımlanır.
4. **08-navigation-and-flow-rules.md ile uyum audit edilmelidir:** Navigation implementasyonu, 08'deki UX governance kurallarına uyumlu olmalıdır.
5. **React Navigation 8.x izlenmelidir:** Stable release ve ekosistem uyumluluğu düzenli takip edilmelidir.
6. **Compatibility matrix korunmalıdır:** React Router ve React Navigation sürüm pinleri `38-version-compatibility-matrix.md` ile senkron tutulmalıdır.

---

# 18. Bu Kararın Non-Goals Alanları

Bu ADR aşağıdakileri çözmez:

- her ekranın exact navigator placement kararı,
- tab bar'da hangi tab'ların olacağı (bu ürün kararıdır),
- navigation animasyonlarının exact spec'i (bu `24-motion-and-interaction-standard.md` alanıdır),
- auth flow'un exact implementasyonu (bu ayrı ADR alanıdır),
- OTA update sonrası navigation state recovery detayları,
- analytics event tanımlarının exact listesi (bu `08-navigation-and-flow-rules.md` bölüm 14.5.8'de başlar),
- server-driven navigation modeli,
- microfrontend navigation stratejisi.

---

# 19. Bu Kararın Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar resmen doğar:

1. Web routing React Router 7.x ile kurulur; alternatif web router eklenmez.
2. Mobile navigation React Navigation 7.x ile kurulur; 8.x canonical baseline değildir.
3. Expo Router bu baseline'da canonical seçim değildir; web routing React Router'da kalır, mobile navigation React Navigation'da kalır.
4. Navigator pattern'leri (stack, tab, modal, bottom sheet, drawer) bu ADR'deki kullanım kurallarına uygun kullanılır.
5. Deep link stratejisi tek URL şeması üzerine kurulur; Universal Links / App Links birincil mekanizmadır.
6. Route path tanımları web ve mobile'da aynı yapıyı kullanır; shared constants olarak yönetilir.
7. Navigation runtime, app shell'in parçasıdır; feature logic navigation container detayını bilmez.
8. React Navigation 8.x watchlist'te izlenir; stable release sonrası değerlendirme yapılır.
9. Navigation implementasyonu `08-navigation-and-flow-rules.md` UX governance kurallarına uymalıdır.
10. Compatibility matrix (`38-version-compatibility-matrix.md`) navigation sürüm pinlerini yönetir.

---

# 20. Reddedilen Alternatiflerin Kısa Özeti

## 20.1. React Navigation 8.x (canonical baseline olarak)
Reddedildi çünkü:
- pre-release statüsündedir,
- API yüzeyi kesinleşmemiştir,
- ekosistem uyumluluğu tam doğrulanmamıştır,
- canonical baseline stability-first ilkesiyle çelişir.

## 20.2. Expo Router (canonical navigation olarak)
Seçilmedi çünkü:
- web ve mobile'da ayrı navigation authority kararı verilmiştir,
- file-based routing erken kısıtlama yaratır,
- ADR-001'deki React Router kararıyla çelişir,
- tek router lock-in riski taşır.

## 20.3. Tek router abstraction katmanı
Seçilmedi çünkü:
- gereksiz erken soyutlamadır,
- presentation farkları sağlıklı biçimde sarılamaz,
- behavior parity zaten ayrı mekanizmalarla korunur,
- bakım yüzeyini artırır.

---

# 21. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki tür durumlarda bu ADR yeniden değerlendirilebilir:

- React Navigation 8.x stable release olursa ve ekosistem uyumluluğu doğrulanırsa (7 → 8 migration değerlendirmesi),
- Expo Router olgunlaşır ve file-based routing ile explicit configuration arasında daha esnek denge kurarsa,
- web tarafında React Router yerine farklı bir routing paradigması gerekirse,
- mobile navigation gereksinimleri React Navigation 7.x'in kapasitesini aşarsa,
- tek router abstraction katmanının gerçek değer üreteceği somut kanıt oluşursa,
- cross-platform navigation parity'nin mevcut ayrık model ile sürdürülemez hale geldiği kanıtlanırsa.

Bu seviyedeki değişiklik yeni ADR ve `38-version-compatibility-matrix.md` güncellemesi gerektirir.

---

# 22. Kararın Kısa Hükmü

> Navigation baseline için canonical karar: Web'de React Router 7.x (SPA-first client-side routing), mobile'da React Navigation 7.x (stable baseline, native-feeling navigation) ile ayrık ama davranışsal olarak uyumlu navigation modeli kurulacaktır. Deep link stratejisi tek URL şeması üzerine inşa edilir. React Navigation 8.x watchlist'te izlenir. Expo Router bu baseline'da canonical seçim değildir. Tek router abstraction katmanı bilinçli olarak seçilmemiştir.

---

# 23. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Web ve mobile navigation baseline'ları açıkça tanımlanmışsa
2. Navigator pattern kullanım kuralları (stack, tab, modal, sheet, drawer) yazılmışsa
3. Deep link stratejisi (URL şeması, Universal Links, auth-gated deep link, fallback) tanımlanmışsa
4. Web-mobile parity yaklaşımı (behavior parity vs presentation parity) netleştirilmişse
5. Neden React Navigation 8.x canonical baseline olmadığı gerekçelendirilmişse
6. Neden Expo Router seçilmediği gerekçelendirilmişse
7. Neden tek router abstraction seçilmediği gerekçelendirilmişse
8. App shell, design system, testing, repo yapısı ve CI etkileri işaretlenmişse
9. Risk ve risk azaltma önlemleri tanımlanmışsa
10. Bu karar implementasyon öncesi kilitlenmiş baseline olarak kullanılabilecek netlikteyse

---

# 24. React Navigation 8.x Migration Checklist

Watchlist'teki React Navigation 8.x stable olduğunda uygulanacak migration adımları. Bu checklist 8.x stable release + 1 ay community stabilizasyon süresi sonrasında aktif hale gelir.

## 24.1. Değerlendirme Kontrol Listesi

- [ ] **Static navigation API değerlendirmesi:** `createStaticNavigation` API'sinin mevcut dynamic navigation yapısına göre avantaj/dezavantaj analizi. Static API daha iyi type inference ve daha az boilerplate sunar; ancak dinamik navigator oluşturma esnekliğini kısıtlayabilir.
- [ ] **Deep link konfigürasyonu yeni format'a migration:** 8.x'in linking config formatı değişikliklerinin mevcut deep link yapısına (ADR-014) etkisi. Yeni format ile mevcut URL şeması korunabilir mi?
- [ ] **Screen options API değişikliklerinin uygulanması:** Header, tab bar ve drawer konfigürasyonlarında API değişiklikleri. Mevcut screen options'ların yeni API'ya uyumlanması.
- [ ] **TypeScript tiplendirme güncellemeleri:** `RootStackParamList` ve navigation prop tiplendirmelerinin yeni type system ile uyumlanması. 8.x'in geliştirilmiş type inference'ından faydalanma.
- [ ] **Custom navigator'ların yeni API'ya uyumlanması:** Varsa custom navigator implementasyonlarının 8.x API'sına migration edilmesi.
- [ ] **Bottom tab bar ve drawer navigator API değişiklikleri:** Tab bar ve drawer konfigürasyonlarının yeni API ile güncellenmesi. Custom tab bar component'lerinin uyumluluğu.
- [ ] **Test suite'in güncellenmesi ve geçirilmesi:** Navigation-aware testlerin yeni API'ya uyumlanması. Mock navigation container'ların güncellenmesi.
- [ ] **Performance benchmark karşılaştırması:** 7.x vs 8.x arasında navigation geçiş süreleri, memory kullanımı ve startup etkisi benchmark'ı. Regression olmadığının doğrulanması.
- [ ] **Expo SDK uyumluluğu:** 8.x'in canonical Expo SDK versiyonu ile tam uyumlu olduğunun doğrulanması.
- [ ] **Third-party entegrasyon uyumu:** react-native-screens, react-native-safe-area-context ve diğer navigation-adjacent paketlerin 8.x ile uyumu.

## 24.2. Migration Stratejisi

Migration single-step değil, **kademeli** yapılır:
1. Önce yeni bir feature branch'te 8.x kurulur ve tüm mevcut ekranlar çalıştırılır
2. Breaking change'ler tespit edilir ve düzeltilir
3. Deep link routing doğrulanır
4. Performance benchmark yapılır
5. Test suite güncellenir ve geçirilir
6. Review sonrası merge edilir

---

# 25. Navigation Analytics Entegrasyonu

Her ekran geçişinde otomatik tracking ile kullanıcı navigation davranışının ölçülmesi.

## 25.1. Mobile: NavigationContainer onStateChange

React Navigation'ın `NavigationContainer` component'inde `onStateChange` listener'ı ile her navigation state değişikliğinde `screen_view` event'i ateşlenir:

```typescript
function onNavigationStateChange(state: NavigationState) {
  const currentScreen = getActiveRouteName(state);
  const previousScreen = navigationRef.current?.getCurrentRoute()?.name;

  analytics.track('screen_view', {
    screen_name: currentScreen,
    previous_screen: previousScreen,
    timestamp: Date.now(),
    navigation_type: determineNavigationType(state), // push, pop, tab_switch, modal_open
  });
}
```

## 25.2. Navigation Type Sınıflandırması

| navigation_type | Tetikleyici | Açıklama |
|----------------|------------|----------|
| `push` | Stack'e yeni ekran eklenmesi | Kullanıcı derinleşiyor |
| `pop` | Stack'ten ekran çıkarılması | Kullanıcı geri dönüyor |
| `tab_switch` | Bottom tab değişikliği | Kullanıcı ana bölümler arası geçiyor |
| `modal_open` | Modal/sheet açılması | Overlay ekran açılıyor |
| `modal_close` | Modal/sheet kapanması | Overlay ekran kapanıyor |
| `deep_link` | External deep link ile açılma | Dış kaynak yönlendirmesi |
| `drawer_open` | Drawer açılması | Side menu açılıyor |

## 25.3. Duration Tracking

Kullanıcının bir ekranda kalma süresi ölçülür:
- `focus` event'inde başlangıç timestamp'i kaydedilir
- `blur` event'inde bitiş timestamp'i kaydedilir
- Fark `duration_ms` olarak bir sonraki `screen_view` event'ine eklenir
- Bu metrik hangi ekranların kullanıcıyı uzun süre tuttuğunu ve hangilerinin hızlı terk edildiğini gösterir

## 25.4. Filtered Screens

Aşağıdaki geçici ekranlar analytics'ten hariç tutulur:
- Splash screen
- Loading screen
- Biometric prompt
- Permission dialog
- App update screen

Bu ekranlar kullanıcı aksiyonu değil, sistem davranışı olduğu için analytics noise üretir.

## 25.5. Web: React Router useLocation

Web tarafında aynı pattern `useLocation` hook'u ile uygulanır:

```typescript
function usePageTracking() {
  const location = useLocation();
  const previousPath = useRef(location.pathname);

  useEffect(() => {
    analytics.track('screen_view', {
      screen_name: location.pathname,
      previous_screen: previousPath.current,
      timestamp: Date.now(),
      navigation_type: 'push', // web'de genellikle push
    });
    previousPath.current = location.pathname;
  }, [location.pathname]);
}
```

## 25.6. ADR-009 Uyumu

Bu analytics event'leri ADR-009'daki vendor-agnostic analytics event şemasının `screen_view` event'i ile tam uyumludur. Payload yapısı ve naming convention ADR-009'daki standarda uyar.

---

# 26. Kısa Sonuç

Bu ADR'nin ana çıktısı şudur:

> Navigation baseline, web ve mobile'ı aynı router soyutlamasına kilitlemeden, her platformun güçlü navigation runtime'ını koruyarak, davranışsal parity'yi ürün seviyesinde sağlayan bir model üzerine kurulacaktır. Web'de React Router 7.x, mobile'da React Navigation 7.x canonical baseline'dır. Deep link stratejisi tek URL şeması ile cross-platform tutarlılık sağlar. React Navigation 8.x ve Expo Router geleceğe dönük izlenen hatlar olarak değerlendirilir; ama canonical baseline'a bu aşamada alınmamıştır.
