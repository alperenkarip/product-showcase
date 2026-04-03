# ADR-018 — New Architecture Migration and Readiness Strategy

## Doküman Kimliği

- **ADR ID:** ADR-018
- **Başlık:** New Architecture Migration and Readiness Strategy
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar türü:** Foundational runtime, migration strategy ve platform readiness kararı
- **Karar alanı:** React Native New Architecture (Fabric, JSI, TurboModules, Hermes V1), migration readiness, paket uyumluluk stratejisi, bootstrap doğrulama, performans beklentileri, kaldırılan API geçişi
- **İlgili üst belgeler:**
  - `ADR-002-mobile-runtime-and-native-strategy.md`
  - `36-canonical-stack-decision.md`
  - `38-version-compatibility-matrix.md`
  - `13-performance-standard.md`
  - `17-technology-decision-framework.md`
  - `37-dependency-policy.md`
- **Etkilediği belgeler:**
  - `19-roadmap-to-implementation.md`
  - `20-initial-implementation-checklist.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`
  - `28-observability-and-debugging.md`
  - `31-audit-checklist.md`

---

# 1. Karar Özeti

Bu ADR ile aşağıdaki karar kabul edilmiştir:

- **New Architecture zorunlu gerçeklik olarak kabul edilir:** Expo SDK 55 + React Native 0.83 hattında New Architecture kapatılamaz; bu bir tercih değil, platformun yeni gerçekliğidir
- **Fabric Renderer canonical render pipeline'dır:** Eski UIManager tabanlı render pipeline artık desteklenmez; Fabric tek renderer'dır
- **JSI canonical native iletişim katmanıdır:** Eski asenkron JSON bridge kaldırılmıştır; JavaScript ile native arasındaki tüm iletişim JSI üzerinden gerçekleşir
- **TurboModules canonical native modül sistemidir:** Eski NativeModules sistemi yerini TurboModules'a bırakmıştır; Codegen ile derleme zamanı tip güvenliği zorunludur
- **Hermes V1 canonical JavaScript engine'dir:** V8 veya JavaScriptCore kullanımı bu boilerplate'te söz konusu değildir; Hermes V1 zorunlu engine'dir
- **Paket uyumluluk doğrulaması bootstrap kapısının parçasıdır:** Her native bağımlılık New Architecture uyumluluğu açısından doğrulanmalıdır
- **Kaldırılan API'lerin migration yolları izlenir:** `setNativeProps`, `findNodeHandle` ve diğer legacy API'ler kullanılmaz; modern alternatifleri zorunludur

Bu ADR'nin ana hükmü şudur:

> New Architecture bu boilerplate'in "gelecekte geçilecek bir hedef" değil, "şu anda içinde bulunduğu gerçeklik"tir. Expo SDK 55 + React Native 0.83 hattında Fabric, JSI, TurboModules ve Hermes V1 varsayılan ve kapatılamaz mimaridir. Bu ADR bu gerçekliğin bütünsel stratejisini, teknik detaylarını, paket uyumluluk yaklaşımını, performans beklentilerini ve risk yönetimini tanımlar.

---

# 2. Problem Tanımı

New Architecture hakkında bütünsel bir strateji belgesi olmazsa aşağıdaki sorunlar kaçınılmazdır:

- Geliştiriciler New Architecture'ın ne olduğunu, neden zorunlu olduğunu ve hangi bileşenlerden oluştuğunu tam kavrayamaz; parçalı bilgiyle çalışmak zorunda kalır
- Eski bridge tabanlı paketler farkında olunmadan projeye eklenir; runtime hataları veya performans sorunları yaşanır
- `setNativeProps`, `findNodeHandle` gibi kaldırılan API'ler kullanılmaya devam eder; build veya runtime hataları oluşur
- Fabric'in concurrent rendering kabiliyetleri anlaşılmadığı için UI optimizasyonları kaçırılır
- JSI'ın doğrudan C++ obje erişim modeli bilinmediği için gereksiz veri kopyalama ve serialization yapılır
- TurboModules'ın lazy loading avantajı kullanılmaz; tüm native modüller uygulama başlangıcında yüklenir
- Hermes V1'in bytecode precompilation avantajı bilinmediği için startup performansı yanlış değerlendirilir
- Paket uyumluluk kontrolü yapılmadığı için üçüncü parti paketlerde beklenmedik crashler yaşanır
- Bootstrap doğrulama süreci eksik kalır; mobile foundation "çalışıyor gibi görünüp" runtime'da kırılan bir hale gelir
- Performans beklentileri somut veriye dayanmaz; iyileştirme fırsatları ve regresyon riskleri görünmez kalır

---

# 3. Bağlam

## 3.1. Platformun evrim bağlamı

React Native 2018'den bu yana New Architecture geçişini planlıyordu. Bu süreç şu aşamalardan geçti:

- **2018:** Facebook New Architecture vizyonunu duyurdu (Fabric, JSI, TurboModules)
- **2020-2022:** Hermes engine olgunlaştı, JSI altyapısı stabilize oldu
- **2022 (RN 0.68):** New Architecture ilk kez opt-in olarak kullanılabilir hale geldi
- **2023 (RN 0.73):** Hermes varsayılan engine oldu
- **2024 (RN 0.76):** New Architecture varsayılan olarak açık hale geldi (opt-out hâlâ mümkündü)
- **2025 (RN 0.78+):** Old Architecture desteği kademeli olarak kaldırılmaya başlandı
- **2025 (RN 0.83 / Expo SDK 55):** New Architecture kapatılamaz gerçeklik haline geldi; eski bridge tamamen kaldırıldı

Bu evrim, New Architecture'ın "deneysel" bir özellik olmadığını, React Native'in gelecek on yılının temel mimari omurgası olduğunu göstermektedir.

## 3.2. Bu boilerplate'in durumu

Bu boilerplate Expo SDK 55 + React Native 0.83 üzerine kurulmuştur (ADR-002, 36-canonical-stack-decision). Bu kombinasyonda:

- New Architecture kapatma seçeneği yoktur
- Eski bridge mekanizması runtime'da mevcut değildir
- Tüm native modüller TurboModules olarak yüklenir
- Tüm UI rendering Fabric üzerinden gerçekleşir
- JavaScript engine Hermes V1'dir
- Codegen derleme zamanında native binding'leri üretir

Bu durum bu ADR'nin "geçiş mi yapalım yapmayalım mı?" sorusunu anlamsız kılmaktadır. Soru şudur:

> "Bu zorunlu gerçekliği en iyi şekilde nasıl anlar, yönetir ve avantaja çeviririz?"

## 3.3. Ekosistem olgunluk bağlamı

New Architecture'ın npm ekosisteminde uyumluluk oranı 2026 Nisan itibarıyla yaklaşık %85 seviyesindedir. Bu:

- popüler paketlerin büyük çoğunluğunun uyumlu olduğunu
- ancak %15'lik bir dilimin hâlâ eski bridge-only çalıştığını veya uyumluluk durumunun belirsiz olduğunu
- yeni paket eklerken dikkatli bir uyumluluk kontrolünün zorunlu olduğunu

göstermektedir.

---

# 4. Karar Kriterleri

1. **Mimari tutarlılık:** New Architecture'ın tüm bileşenleri (Fabric, JSI, TurboModules, Hermes) birlikte ve tutarlı şekilde ele alınmalıdır
2. **Paket güvenliği:** Projeye eklenen her native bağımlılık New Architecture uyumluluğu doğrulanmış olmalıdır
3. **Performans şeffaflığı:** New Architecture'ın getirdiği performans iyileştirmeleri somut veriye dayalı ve ölçülebilir olmalıdır
4. **Geliştirici bilgisi:** Ekibin New Architecture bileşenlerini anlaması ve doğru kullanması sağlanmalıdır
5. **Migration güvenliği:** Kaldırılan API'lerin modern alternatifleri net olmalıdır; legacy kod kalıntısı bırakılmamalıdır
6. **Bootstrap doğrulanabilirlik:** Mobile foundation'ın New Architecture uyumluluğu sistematik olarak doğrulanabilir olmalıdır
7. **Risk görünürlüğü:** Ekosistem uyumluluk riskleri, performans regresyon riskleri ve operational riskler açıkça tanımlanmalıdır
8. **Uzun vadeli sürdürülebilirlik:** Kararlar React Native'in gelecek yönü ile hizalı olmalıdır

---

# 5. Değerlendirilen Alternatifler

New Architecture bu SDK/RN hattında zorunlu olduğu için "kullanmak ya da kullanmamak" şeklinde bir alternatif değerlendirmesi yoktur. Ancak bu bölüm eski mimari (Old Architecture) ile yeni mimari (New Architecture) arasındaki temel farkları karşılaştırır. Bu karşılaştırma, neden New Architecture'a geçildiğini ve eski mimarinin neden sürdürülebilir olmadığını somutlaştırır.

## 5.1. Eski Mimari (Old Architecture)

Eski mimari şu bileşenlerden oluşuyordu:

- **UIManager:** Tüm UI işlemlerinin tek bir asenkron bridge üzerinden seri biçimde iletildiği render sistemi. JavaScript thread bir UI güncellemesi istediğinde, bu istek JSON olarak serileştirilir, bridge üzerinden native thread'e gönderilir, native tarafta parse edilir ve uygulanırdı.
- **Asenkron JSON Bridge:** JavaScript ve native arasındaki tüm iletişim bu bridge üzerinden gerçekleşirdi. Her çağrı JSON serialization → transfer → deserialization döngüsünden geçerdi.
- **NativeModules:** Tüm native modüller uygulama başlangıcında eager loading ile yüklenirdi. Kullanılmayan modüller bile bellek tüketirdi.
- **JSC (JavaScriptCore):** iOS'ta sistem JSC'si, Android'de bundled JSC kullanılırdı. Bytecode precompilation yoktu; JS her uygulama başlangıcında parse edilirdi.

Eski mimarinin temel sorunları:

1. **Bridge darboğazı:** Tüm JS-native iletişimi tek bir asenkron kuyruktan geçtiği için yoğun etkileşimlerde gecikme ve frame drop kaçınılmazdı
2. **Serialization maliyeti:** Her çağrıda JSON serialization/deserialization yapılması CPU ve bellek maliyeti üretiyordu
3. **Eager loading israfı:** Tüm native modüllerin başlangıçta yüklenmesi startup süresini uzatıyordu
4. **Tip güvensizliği:** JS-native sınırında runtime tip kontrolü yoktu; tip hataları runtime'da crash olarak ortaya çıkıyordu
5. **Concurrent rendering imkânsızlığı:** Seri bridge yapısı nedeniyle React'in concurrent features'ları (Suspense, Transitions) native tarafta kullanılamıyordu

## 5.2. Yeni Mimari (New Architecture)

Yeni mimari bu sorunların her birini yapısal olarak çözmektedir:

- **Fabric Renderer:** Bridge'siz, senkron ve asenkron erişimi destekleyen modern render pipeline
- **JSI (JavaScript Interface):** JSON serialization olmadan doğrudan C++ obje erişimi sağlayan native iletişim katmanı
- **TurboModules:** Lazy loading, Codegen destekli, tip güvenli native modül sistemi
- **Hermes V1:** Bytecode precompilation, hızlı startup, düşük bellek footprint sunan JavaScript engine

Karşılaştırma tablosu:

| Alan | Eski Mimari | Yeni Mimari |
|------|-------------|-------------|
| Render pipeline | UIManager (seri, asenkron bridge) | Fabric (bridge'siz, concurrent-ready) |
| JS-Native iletişim | JSON bridge (serialization) | JSI (doğrudan C++ obje erişimi) |
| Native modül yüklemesi | Eager loading (tümü başlangıçta) | Lazy loading (ilk kullanımda) |
| Tip güvenliği | Runtime (crash riski) | Compile-time (Codegen) |
| JS engine | JSC (parse-at-startup) | Hermes V1 (bytecode precompiled) |
| Concurrent rendering | Desteklenmiyor | Destekleniyor |
| Bellek yönetimi | GC sınırlı | Hermes gelişmiş GC |
| View flattening | Yok | Otomatik (gereksiz view'lar kaldırılır) |

---

# 6. Seçilen Karar

New Architecture bu boilerplate'in canonical ve tek desteklenen mimarisidir. Aşağıdaki bölümlerde her bileşen detaylı olarak açıklanmaktadır.

---

# 7. Fabric Renderer — Detaylı Açıklama

## 7.1. Fabric nedir?

Fabric, React Native'in yeni render sistemidir. Eski UIManager'ın yerini almıştır. Adı "kumaş" anlamına gelir ve React'in UI ağacını native platforma "dokuyan" katmanı temsil eder.

Fabric'i anlamak için önce eski sistemin nasıl çalıştığını bilmek gerekir:

**Eski sistem (UIManager) nasıl çalışıyordu:**
1. React, JavaScript tarafında bir component ağacı oluşturur (virtual DOM benzeri)
2. Bu ağaçtaki değişiklikler JSON formatında serileştirilir
3. Serileştirilmiş komutlar asenkron bridge üzerinden native tarafına gönderilir
4. Native tarafta bu JSON parse edilir ve UI güncellemeleri uygulanır
5. Tüm bu süreç tek bir asenkron kuyruktan geçer; sıralıdır ve bloklanabilir

**Fabric nasıl çalışır:**
1. React, JavaScript tarafında component ağacını oluşturur
2. Fabric, JSI sayesinde bu ağacı doğrudan C++ katmanında tutar (Shadow Tree)
3. JavaScript ve native her ikisi de aynı Shadow Tree'ye erişebilir; bridge gerekmez
4. UI güncellemeleri senkron veya asenkron olarak yapılabilir; gerekirse JavaScript thread'den doğrudan native UI'a erişilebilir
5. React'in concurrent mode özelliklerini native rendering ile birleştirebilir

## 7.2. Fabric'in temel avantajları

### 7.2.1. Concurrent rendering desteği

Fabric, React 18/19'un concurrent features'larını native rendering'e taşır. Bu şu anlama gelir:

- **Suspense:** Veri yüklenirken fallback UI gösterme ve yükleme tamamlandığında sorunsuz geçiş yapma
- **Transitions:** Düşük öncelikli UI güncellemelerini erteleyerek yüksek öncelikli kullanıcı etkileşimlerinin aksamasını önleme
- **Automatic batching:** Birden fazla state güncellemesini tek bir render döngüsünde birleştirme

Eski UIManager'da bu mümkün değildi çünkü tüm UI güncellemeleri seri bir kuyruktan geçiyordu ve önceliklendirme yapılamıyordu.

### 7.2.2. Host components ve senkron erişim

Fabric'te JavaScript, native view'lara senkron olarak erişebilir. Bu:

- Scroll pozisyonu okuma
- View boyutlarını ölçme (layout measurement)
- Animasyon koordinasyonu

gibi işlemleri bridge gecikmesi olmadan mümkün kılar.

Eski sistemde örneğin bir view'ın boyutlarını okumak istediğinizde, istek bridge üzerinden gider, native tarafta ölçüm yapılır, sonuç bridge üzerinden geri dönerdi. Bu süre zarfında kullanıcı scroll etmiş veya layout değişmiş olabilirdi; okunan değer eski kalırdı.

### 7.2.3. View flattening

Fabric otomatik view flattening uygular. React Native'de iç içe `<View>` bileşenleri kullanıldığında, stil uygulanmayan ara `<View>`'lar gereksiz native view oluşturuyordu. Fabric bu gereksiz view'ları otomatik olarak kaldırır ve düzleştirir.

Pratik etki:
- Daha az native view = daha düşük bellek tüketimi
- Daha sığ view hiyerarşisi = daha hızlı layout hesaplama
- Daha az compositing = daha iyi frame performansı

### 7.2.4. Gelişmiş event sistemi

Fabric'in event sistemi eski asenkron bridge yerine Priority Queue modeli kullanır. Kullanıcı dokunma, kaydırma gibi yüksek öncelikli event'ler düşük öncelikli güncellemelerin önüne geçer. Bu, kullanıcı etkileşimlerinin her zaman hızlı yanıt almasını sağlar.

## 7.3. Geçiş sırasında dikkat edilecekler

### 7.3.1. Interop layer farkındalığı

React Native 0.83 hattında Fabric, eski UIManager bileşenleri için bir interop katmanı sağlar. Henüz Fabric'e migration yapmamış üçüncü parti bileşenler bu interop katmanı sayesinde çalışabilir. Ancak:

- Interop katmanı tam performans sağlamaz; bridge benzeri overhead ekler
- Interop katmanı geçici çözümdür; gelecekte kaldırılacaktır
- Yeni yazılan bileşenler doğrudan Fabric API'si ile yazılmalıdır

### 7.3.2. Custom native component migration

Eğer projede custom native UI component'ler yazılacaksa, bunlar Fabric'in `codegenNativeComponent` API'si ile tanımlanmalıdır. Eski `requireNativeComponent` kullanımı desteklenmez.

### 7.3.3. Shadow Tree ve layout

Fabric'in Shadow Tree'si C++ katmanında yaşar ve Yoga layout engine ile doğrudan çalışır. Bu, layout hesaplamalarının JavaScript thread'den bağımsız çalışabilmesi anlamına gelir. Geliştiricilerin layout performansını değerlendirirken bu mimari farkı bilmesi önemlidir.

---

# 8. JSI (JavaScript Interface) — Detaylı Açıklama

## 8.1. JSI nedir?

JSI (JavaScript Interface), JavaScript runtime ile native (C++) kod arasında doğrudan iletişim sağlayan bir katmandır. "Interface" kelimesi burada önemlidir: JSI, JavaScript'in native objelerine doğrudan erişmesini sağlayan bir arayüzdür.

Bunu anlamak için eski bridge ile karşılaştırmak gerekir:

**Eski bridge nasıl çalışıyordu:**
```
JavaScript → JSON.stringify(veri) → Bridge kuyruğu → JSON.parse(veri) → Native
Native → JSON.stringify(sonuç) → Bridge kuyruğu → JSON.parse(sonuç) → JavaScript
```

Her çağrıda:
1. Veri JavaScript tarafında JSON string'e dönüştürülür
2. String bridge kuyruğuna eklenir (asenkron)
3. Native tarafta string parse edilir
4. Sonuç aynı yoldan geri döner

**JSI nasıl çalışır:**
```
JavaScript → JSI Host Object (C++ referansı) → Doğrudan native çağrı
Native → JSI Host Object → Doğrudan JavaScript erişimi
```

JSI'da:
1. JavaScript, C++ objelerine doğrudan referans tutar (Host Object)
2. Bir fonksiyon çağrıldığında JSON serialization yapılmaz
3. Veri kopyalanmaz; doğrudan paylaşılır
4. Çağrı senkron veya asenkron olabilir (seçim geliştiriciye aittir)

## 8.2. Eski bridge ile farkı — somut örnek

Eski bridge'de bir native modül fonksiyonu çağırmak şöyle çalışıyordu:

1. JavaScript `NativeModules.MyModule.getData({id: 123})` çağırır
2. `{id: 123}` parametresi `'{"id":123}'` string'e dönüştürülür
3. Bu string asenkron bridge kuyruğuna eklenir
4. Native tarafta string parse edilir, `id` değeri çıkarılır
5. Native işlem yapılır, sonuç `'{"result":"data"}'` olarak serialize edilir
6. String bridge kuyruğuna eklenir
7. JavaScript tarafta parse edilir

JSI'da aynı işlem:

1. JavaScript `MyModule.getData({id: 123})` çağırır
2. JSI, parametreyi doğrudan C++ obje olarak native fonksiyona iletir
3. Native işlem yapılır, sonuç doğrudan JavaScript'e döner
4. Serialization yok, bridge kuyruğu yok

## 8.3. Performans farkları

JSI'ın getirdiği performans iyileştirmeleri şu alanlarda somutlaşır:

- **Serialization maliyetinin kaldırılması:** Her JS-native çağrısında yapılan `JSON.stringify` + `JSON.parse` işlemi tamamen ortadan kalkar. Küçük veri paketlerinde bile bu işlem mikrosaniyeler sürer; yoğun etkileşimde (animasyon, gesture, scroll) bu mikrosaniyeler toplanarak milisaniyeler seviyesinde gecikme üretir. JSI ile bu maliyet sıfırdır.
- **Bridge kuyruğu darboğazının kaldırılması:** Eski bridge'de tüm çağrılar tek bir asenkron kuyruktan geçerdi. Yoğun UI güncellemesi sırasında (örneğin hızlı scroll + animasyon + veri yükleme) kuyruk dolardı ve gecikmeler artardı. JSI'da kuyruk yoktur; çağrılar doğrudan yapılır.
- **Senkron erişim imkânı:** JSI, senkron çağrılara izin verir. Bu, layout ölçümü, animasyon frame hesaplaması gibi "anında sonuç gerekli" durumlarda kritiktir. Eski bridge'de her çağrı asenkrondu; "şu anda bu view kaç piksel genişliğinde?" sorusunun cevabı bir sonraki tick'te gelirdi.

Toplamda, JSI'ın kaldırdığı overhead yoğun etkileşim senaryolarında (60 FPS animasyonlar, karmaşık gesture handler'lar, büyük liste scroll'ları) en belirgin etkiyi gösterir.

## 8.4. JSI'ın native modül etkileşimini nasıl değiştirdiği

Eski modelde native modüller JavaScript'ten "uzak" nesnelerdi. Onlara erişmek her zaman asenkron bridge üzerinden olurdu. Bu, native modülleri bir nevi "uzak servis" gibi kullanmak zorunda bırakıyordu.

JSI ile native modüller JavaScript'in doğrudan erişebildiği nesneler haline gelir. Bir native modülün metodu çağrıldığında, bu çağrı fonksiyon çağrısı gibi gerçekleşir; HTTP isteği gibi değil.

Bu paradigma değişikliği şu sonuçları doğurur:
- Native modül çağrıları artık `async/await` gerektirmeyebilir (senkron erişim mümkün)
- Karmaşık veri yapıları serialization overhead olmadan geçirilebilir
- Native taraftaki hesaplama sonuçları anında kullanılabilir

## 8.5. Bellek yönetimi

JSI'ın doğrudan obje referansı paylaşım modeli bellek yönetimi açısından dikkat gerektirir:

- JSI Host Object'ler C++ tarafında yaşar ve JavaScript'in garbage collector'ı tarafından izlenir
- Bir Host Object'e JavaScript'ten referans kalmazsa, garbage collector C++ tarafını release etmek üzere callback'i tetikler
- Büyük binary veri (görüntü buffer'ları, ses dosyaları) JSI ile paylaşılırken kopyalama yerine referans paylaşımı yapılabilir; bu bellek tasarrufu sağlar ama referans yaşam döngüsüne dikkat gerektirir

---

# 9. TurboModules — Detaylı Açıklama

## 9.1. TurboModules nedir?

TurboModules, React Native'in yeni native modül sistemidir. Eski `NativeModules` API'sinin yerini almıştır. "Turbo" adı, JSI üzerinden doğrudan erişim ve lazy loading sayesinde gelen hız artışından gelir.

Eski ve yeni sistem arasındaki temel fark şudur:

**Eski NativeModules:**
- Uygulama başlangıcında TÜM native modüller yüklenir (eager loading)
- Modül tanımları runtime'da çözümlenir; tip kontrolü yoktur
- İletişim JSON bridge üzerinden asenkrondur
- Modül kayıt (registry) sistemi başlangıçta tüm modülleri tarar

**TurboModules:**
- Native modüller yalnızca ilk kullanıldığında yüklenir (lazy loading)
- Modül arayüzleri Codegen ile derleme zamanında üretilir; tip güvenliği compile-time'dadır
- İletişim JSI üzerinden doğrudandır
- Her modül bağımsız olarak başlatılır

## 9.2. Lazy loading — neden önemli?

Bir React Native uygulamasında onlarca native modül olabilir: kamera, konum, push notification, secure storage, analytics, crash reporting, biometric authentication ve daha fazlası.

Eski sistemde uygulama başlangıcında bu modüllerin tümü yüklenirdi. Kullanıcı henüz kamerayı açmamış olsa bile kamera modülü başlatılır, bellek ayırır ve native taraftaki ilgili sınıfları initialize ederdi.

TurboModules ile bir modül yalnızca JavaScript tarafından ilk kez çağrıldığında yüklenir. Örneğin:
- Kamera modülü, kullanıcı kamera ekranını açana kadar yüklenmez
- Push notification modülü, push izni istenene kadar yüklenmez
- Biometric modülü, giriş ekranına gelinene kadar yüklenmez

Bu lazy loading mekanizmasının pratik etkileri:
- **Startup süresi:** Uygulama başlangıcında yüklenen native modül sayısı azalır; cold start hızlanır
- **Bellek kullanımı:** Kullanılmayan modüller bellek tüketmez
- **Kaynak verimliliği:** Native taraftaki initialization maliyeti gerçek ihtiyaç anına ertelenir

## 9.3. Codegen nasıl çalışır?

Codegen (Code Generator), TurboModules sisteminin en önemli parçalarından biridir. İşlevi şudur:

1. Geliştirici, native modülün JavaScript arayüzünü bir TypeScript (veya Flow) spec dosyasında tanımlar
2. Codegen bu spec dosyasını okur ve şunları otomatik olarak üretir:
   - C++ binding kodu (JSI üzerinden native fonksiyon çağrılarını bağlar)
   - iOS tarafında Objective-C/Swift protocol tanımları
   - Android tarafında Java/Kotlin interface tanımları
3. Bu üretilen kod derleme zamanında native proje ile birleştirilir
4. Runtime'da JavaScript bir TurboModule fonksiyonu çağırdığında, Codegen'in ürettiği binding kodu çalışır

### 9.3.1. Spec dosyaları

Spec dosyası, bir TurboModule'ün JavaScript arayüzünü tanımlayan dosyadır. Bu dosya TypeScript ile yazılır ve şu bilgileri içerir:
- Modülün adı
- Modülün sunduğu fonksiyonlar
- Her fonksiyonun parametre tipleri ve dönüş tipi
- Senkron mu asenkron mu olduğu

Codegen bu spec dosyasını kaynak gerçeklik (source of truth) olarak kullanır. Native taraftaki implementasyon bu spec ile uyuşmazsa derleme hatası alınır. Bu, eski NativeModules'daki "runtime'da crash" sorununu "compile-time'da hata" seviyesine çeker.

## 9.4. Performans avantajları

TurboModules'ın performans avantajlarını somutlaştırmak gerekirse:

1. **Startup azalması:** 20+ native modülü olan bir uygulamada, eager loading yerine lazy loading ile startup'ta yalnızca gerçekten gerekli modüller (navigation, theme, auth session) yüklenir. Diğerleri kullanıcı etkileşimine göre tembel yüklenir.
2. **Çağrı maliyeti:** JSI üzerinden doğrudan erişim, her native modül çağrısında JSON serialization maliyetini kaldırır.
3. **Tip güvenliği:** Codegen'in derleme zamanı tip kontrolü, runtime tip hatalarından kaynaklanan beklenmedik crash'leri önler. Bu doğrudan performans kazancı değildir ama operasyonel güvenilirliği artırır.

---

# 10. Hermes V1 — Detaylı Açıklama

## 10.1. Hermes nedir?

Hermes, Meta (eski adıyla Facebook) tarafından React Native uygulamaları için özel olarak geliştirilmiş bir JavaScript engine'dir. Genel amaçlı JavaScript engine'lerden (V8, JavaScriptCore) farklı olarak, mobil ortamın kısıtlamalarını (sınırlı bellek, yavaş I/O, batarya hassasiyeti) birincil tasarım hedefi olarak ele alır.

Hermes V1, bu engine'in New Architecture ile tam entegre, olgunlaşmış sürümüdür.

## 10.2. V8 ve JSC ile karşılaştırma

### 10.2.1. V8 (Chrome, Node.js)

V8 genel amaçlı, yüksek performanslı bir JavaScript engine'dir. Güçlü yönleri:
- JIT (Just-In-Time) compilation ile çok hızlı çalışma süresi
- Gelişmiş optimizasyon pipeline'ları (TurboFan, Sparkplug)
- Büyük heap yönetimi

Ancak V8'in mobil için dezavantajları vardır:
- JIT compilation başlangıçta CPU ve bellek maliyeti üretir
- Büyük binary boyutu (engine kendisi ~10-15 MB)
- Bellek footprint yüksek
- Startup süresi uzun (JIT compilation warm-up gerektirir)

### 10.2.2. JavaScriptCore (Safari, eski React Native)

JSC, Apple'ın JavaScript engine'dir. iOS'ta sistem JSC'si kullanılabilir ama:
- Android'de ayrıca bundle edilmesi gerekir
- Bytecode precompilation desteği yoktur
- Bellek yönetimi mobile-optimized değildir
- Debugging araçları React Native ekosistemine tam entegre değildir

### 10.2.3. Hermes V1

Hermes'in temel farkları şunlardır:

**Bytecode precompilation:**
- JavaScript kodu build zamanında Hermes bytecode'una derlenir
- Uygulama başlangıcında JavaScript parse edilmez; hazır bytecode doğrudan çalıştırılır
- Bu, startup süresini dramatik şekilde azaltır

**AOT (Ahead-of-Time) yaklaşımı:**
- V8 JIT (runtime'da derleme) kullanırken, Hermes AOT (build zamanında derleme) kullanır
- AOT yaklaşımı startup'ta JIT warm-up süresini ortadan kaldırır
- Bellek tüketimi daha öngörülebilir olur

**Düşük bellek footprint:**
- Hermes, bellek sınırlı mobil cihazlar için optimize edilmiştir
- Engine binary boyutu V8'den önemli ölçüde küçüktür
- Runtime bellek kullanımı daha düşüktür

## 10.3. Bytecode precompilation avantajı — detaylı açıklama

Bytecode precompilation'ı anlamak için JavaScript'in normal çalışma sürecini bilmek gerekir:

**V8/JSC ile normal süreç:**
1. Uygulama başlar
2. JavaScript bundle dosyası diskten okunur (I/O)
3. Kaynak kod parse edilir (syntax analysis) → bu CPU yoğundur
4. Parse ağacından bytecode üretilir (compilation)
5. Bytecode çalıştırılır
6. (V8'de) Hot path'ler JIT ile optimize edilir

**Hermes ile süreç:**
1. BUILD zamanında JavaScript kaynak kodu Hermes bytecode'una derlenir
2. Uygulama başlar
3. Hazır bytecode dosyası diskten okunur (I/O) — parse ve compilation yok
4. Bytecode doğrudan çalıştırılır

Adım 3 ve 4 arasındaki fark kritiktir: parse + compilation adımları tamamen ortadan kalkar. Bu adımlar tipik olarak startup süresinin %30-50'sini oluşturur.

## 10.4. Startup süresi etkisi

Hermes V1'in startup performansına etkisi şu şekilde özetlenebilir:

- **Cold start:** Bytecode precompilation sayesinde JavaScript parse süresi sıfıra iner. Bu, 1 MB+ boyutundaki bundle'larda yüzlerce milisaniyelik tasarruf demektir.
- **TTI (Time to Interactive):** Daha hızlı JS execution başlangıcı, daha erken kullanıcı etkileşimi anlamına gelir.
- **İlk render:** JavaScript daha hızlı çalışmaya başladığı için ilk component tree oluşturma ve native render daha erken tamamlanır.

## 10.5. Bellek footprint

Hermes V1'in bellek avantajları:

- **Engine boyutu:** Hermes binary'si V8'den küçüktür; APK/IPA boyutuna daha az etki eder
- **Runtime heap:** Hermes'in bellek tahsis stratejisi mobil cihazlar için optimize edilmiştir
- **Bytecode memory mapping:** Hermes, bytecode dosyasını belleğe doğrudan map edebilir (mmap); tüm dosyayı belleğe kopyalamak gerekmez. Bu, büyük bundle'larda önemli bellek tasarrufu sağlar.

## 10.6. Garbage collection iyileştirmeleri

Hermes V1'in garbage collector'ı (GenGC — Generational Garbage Collector) mobil ortam için özel olarak tasarlanmıştır:

- **Generational collection:** Nesneler "genç" ve "yaşlı" nesillere ayrılır. Çoğu nesne kısa ömürlüdür; genç nesil sık ve hızlı toplanır. Yaşlı nesil nadiren ve daha kapsamlı toplanır.
- **Incremental collection:** GC işlemi tek seferde yapılmaz; küçük adımlara bölünür. Bu, uzun GC duraklamalarını (GC pauses) önler ve UI akıcılığını korur.
- **Düşük fragmentation:** Bellek fragmentation'ı minimize edilir; bu, uzun oturumlarda bellek verimliliğini korur.

Eski JSC'nin GC'si bu optimizasyonları mobil odaklı sunmuyordu. V8'in GC'si güçlüdür ama genel amaçlıdır; mobil ortamın sınırlı kaynak gerçekliğine göre tune edilmemiştir.

## 10.7. Neden zorunlu?

Hermes V1, Expo SDK 55 + React Native 0.83 hattında kapatılamaz. Bunun nedenleri:

1. **JSI entegrasyonu:** TurboModules ve Fabric, JSI üzerinden çalışır; JSI, Hermes ile en sıkı şekilde entegredir
2. **Codegen uyumu:** TurboModules'ın Codegen'i Hermes bytecode pipeline'ı ile optimize edilmiştir
3. **Debugging araçları:** React Native DevTools, Hermes'in debugging API'si ile çalışır; Chrome DevTools Protocol üzerinden Hermes profiling doğrudan desteklenir
4. **Ekosistem kararı:** React Native ekosistemi Hermes'i canonical engine olarak kabul etmiştir; V8/JSC desteği aktif olarak sürdürülmemektedir

---

# 11. Paket Uyumluluk Değerlendirmesi

## 11.1. Ekosistem uyumluluk gerçeği

2026 Nisan itibarıyla npm ekosistemindeki React Native paketlerinin yaklaşık %85'i New Architecture ile uyumludur. Bu:

- Popüler ve aktif olarak bakılan paketlerin büyük çoğunluğunun uyumlu olduğu
- Ancak %15'lik bir dilimin hâlâ uyumsuz veya uyumluluk durumu belirsiz olduğu

anlamına gelir.

## 11.2. Uyumsuz paket türleri

Bridge-only paketler şu özellikleri gösterir:

1. **Doğrudan UIManager erişimi:** Paket eski `UIManager.dispatchViewManagerCommand` veya `UIManager.measure` API'lerini kullanır
2. **Eski NativeModules bridge'i:** Paket `NativeModules.MyModule` şeklinde eski bridge üzerinden native erişim yapar
3. **setNativeProps kullanımı:** Paket doğrudan `setNativeProps` ile view prop'larını günceller
4. **findNodeHandle kullanımı:** Paket `findNodeHandle` ile native view referansı alır
5. **requireNativeComponent:** Paket eski API ile native component kaydeder

Bu paketler New Architecture'da:
- Çalışmayabilir (crash)
- Kısıtlı çalışabilir (interop layer üzerinden, performans düşüklüğüyle)
- Beklenmedik davranış gösterebilir

## 11.3. Paket uyumluluğunu kontrol etme yöntemleri

### 11.3.1. React Native Package Database

[reactnativepackagedb.com](https://reactnativepackagedb.com) adresinde React Native paketlerinin New Architecture uyumluluk durumu izlenebilir. Bu veritabanı:
- Paketlerin Fabric/TurboModules uyumluluğunu gösterir
- Uyumluluk test sonuçlarını paylaşır
- Alternatif paket önerilerinde bulunur

Her yeni native dependency eklemeden önce bu veritabanının kontrol edilmesi zorunludur.

### 11.3.2. expo-doctor kontrolü

`npx expo-doctor` komutu projedeki tüm bağımlılıkları tarar ve:
- Expo SDK versiyonu ile uyumsuz paketleri
- New Architecture ile bilinen uyumsuzlukları
- Versiyon conflict'lerini
raporlar.

### 11.3.3. Manual kaynak kod incelemesi

Şüpheli paketlerde kaynak kodun şu açılardan incelenmesi gerekir:
- `requireNativeComponent` kullanımı var mı? (eski API)
- `codegenNativeComponent` veya Fabric uyumlu tanımlama var mı? (yeni API)
- Codegen spec dosyaları (`*NativeComponent.ts`, `Native*.ts`) var mı?
- `setNativeProps` veya `findNodeHandle` kullanımı var mı?
- package.json'da `codegenConfig` alanı var mı?

### 11.3.4. Development build testi

Şüpheli paketler eklendikten sonra development build ile fiziksel cihaz veya emülatörde test edilmelidir. Yalnızca "build başarılı" yetmez; runtime davranışı doğrulanmalıdır.

## 11.4. Uyumsuz paket tespit edildiğinde adımlar

Bir paketin New Architecture ile uyumsuz olduğu tespit edildiğinde şu adımlar izlenir:

1. **Alternatif arama:** Aynı işlevi sağlayan New Architecture uyumlu bir alternatif paket araştırılır
2. **React Native Package Database kontrolü:** Alternatifler uyumluluk veritabanında doğrulanır
3. **Expo uyumlu çözüm:** Expo SDK'nın kendi modülleri bu ihtiyacı karşılıyor mu kontrol edilir (Expo-first ilkesi, ADR-002)
4. **Fork/patch değerlendirmesi:** Alternatif yoksa ve paket kritikse, fork edip New Architecture uyumlu hale getirme maliyeti değerlendirilir
5. **İhtiyacın gerçekliğinin sorgulanması:** Bu native capability gerçekten gerekli mi, JavaScript/web API ile çözülebilir mi sorulur
6. **Belgeleme:** Karar ne olursa olsun, uyumsuzluk durumu ve alınan aksiyon belgelenir (37-dependency-policy uyumu)

## 11.5. Dependency ekleme kuralı (37-dependency-policy genişletmesi)

Bu ADR ile 37-dependency-policy'ye şu kural eklenir:

> Native bağımlılık (React Native'e özgü native kodu olan paket) eklemeden önce New Architecture uyumluluğunun doğrulanması zorunludur. Doğrulama yöntemleri: reactnativepackagedb.com kontrolü, expo-doctor çıktısı, development build testi. Uyumluluk doğrulanmadan eklenen native paket review'dan geçemez.

---

# 12. Performans Beklentileri

## 12.1. Cold start iyileşmesi

New Architecture ile cold start'ta %30-43 arasında iyileşme beklenmektedir. Bu aralığın kaynakları:

- **Hermes bytecode precompilation:** JavaScript parse süresinin ortadan kalkması ile ~%15-25 startup kazancı
- **TurboModules lazy loading:** Tüm native modüllerin başlangıçta yüklenmemesi ile ~%10-15 startup kazancı
- **JSI doğrudan erişim:** Başlangıç sırasındaki JS-native çağrılarının serialization overhead'inin kalkması ile ~%5-8 kazanç

Bu rakamlar React Native ekibinin ve topluluk benchmark'larının birleşimidir. Gerçek kazanç uygulamanın boyutuna, native modül sayısına ve başlangıç akışına göre değişir.

Kural: Bu rakamlar garanti değil, beklentidir. Gerçek performans ölçümü 13-performance-standard'a göre yapılmalıdır.

## 12.2. Render performansı iyileşmesi

Fabric ile render performansında %39'a varan iyileşme beklenmektedir. Bu iyileşmenin kaynakları:

- **View flattening:** Gereksiz native view'ların otomatik kaldırılması → daha hızlı layout hesaplama
- **Bridge kuyruğunun kalkması:** UI güncellemelerinin seri kuyruktan geçmemesi → daha akıcı frame delivery
- **Concurrent rendering:** Düşük öncelikli güncellemelerin ertelenmesi → yüksek öncelikli etkileşimlerin aksamasının önlenmesi
- **Senkron layout okuma:** Scroll ve animasyon sırasında ölçüm gecikmesinin kalkması → daha doğru ve akıcı animasyonlar

## 12.3. JS-to-Native iletişim latans azalması

JSI ile JS-native arası iletişim latansında büyük düşüş beklenir:

- Eski bridge'de bir JS-native round trip: ~5-15ms (serialization + async queue + deserialization)
- JSI ile bir JS-native çağrı: ~0.01-0.1ms (doğrudan C++ fonksiyon çağrısı)

Bu fark özellikle şu senaryolarda belirgindir:
- 60 FPS animasyonlarda (her frame'de ~16.6ms bütçe)
- Gesture handler'larda (dokunma başına birden fazla JS-native round trip)
- Scroll event'lerinde (her scroll frame'de position okuma)

## 12.4. Bellek footprint karşılaştırması

- **Hermes V1 vs JSC:** Hermes'in runtime bellek kullanımı JSC'ye kıyasla daha düşüktür. Bytecode mmap özelliği büyük bundle'larda bellek tasarrufu sağlar.
- **TurboModules vs NativeModules:** Lazy loading ile başlangıçta daha az bellek tüketilir. Uygulama yaşam döngüsü boyunca yalnızca kullanılan modüller bellekte yaşar.
- **Fabric view flattening:** Daha az native view = daha düşük view hierarchy bellek kullanımı.

## 12.5. Bu rakamlar nereden geliyor?

Bu bölümdeki performans rakamları şu kaynaklardan derlenmiştir:

1. **React Native Core Team benchmark'ları:** Meta'nın kendi uygulamalarında (Facebook, Instagram, Messenger) yaptığı ve React Native blog'da paylaştığı ölçümler
2. **Topluluk benchmark'ları:** New Architecture geçişi yapan büyük ölçekli uygulamaların (Shopify, Microsoft, Coinbase) paylaştığı veriler
3. **Expo benchmark'ları:** Expo ekibinin SDK sürüm notlarında paylaştığı performans karşılaştırmaları
4. **Hermes benchmark'ları:** Hermes engine'in resmi benchmark suite sonuçları

Önemli uyarı: Bu rakamlar gösterge niteliğindedir. Gerçek performans kazancı uygulamanın mimarisine, component karmaşıklığına, native modül sayısına ve kullanım senaryolarına göre değişir. Bu boilerplate üzerindeki gerçek performans ölçümü 13-performance-standard'da tanımlanan yöntemlerle yapılmalıdır.

---

# 13. Kaldırılan API'ler ve Migration Yolları

## 13.1. setNativeProps

### Neydi?
`setNativeProps`, JavaScript tarafından doğrudan native view prop'larını güncellemek için kullanılan bir API'ydi. Bridge üzerinden geçmeden (bridge'i bypass ederek) view'ın native prop'larını değiştirmeyi sağlıyordu. Genellikle performans optimizasyonu amacıyla kullanılırdı: tam bir React render döngüsünden geçmek yerine doğrudan native view'ı güncellemek.

### Neden kaldırıldı?
- Fabric'in Shadow Tree modeli ile uyumsudur
- React'in reconciliation sürecini bypass ettiği için tutarsız state oluşturabilir
- Fabric'in concurrent rendering modeli ile çelişir
- JSI ve Fabric'in sağladığı performans ile bu hack'e ihtiyaç kalmamıştır

### Yerine ne kullanılır?
- **`useAnimatedStyle` (Reanimated):** Animasyon amaçlı prop güncellemeleri için
- **Normal React state/prop güncellemesi:** Fabric'in hızlı render pipeline'ı sayesinde tam render döngüsü artık yeterince hızlıdır
- **`useAnimatedProps` (Reanimated):** Non-layout prop'ların animasyonu için

## 13.2. findNodeHandle

### Neydi?
`findNodeHandle`, bir React component instance'ından native view referansı (tag/handle) almak için kullanılan bir API'ydi. Bu handle daha sonra `UIManager` ile doğrudan native komutlar göndermek için kullanılırdı.

### Neden kaldırıldı?
- Fabric'te view tag sistemi farklı çalışır
- Shadow Tree yapısında doğrudan node handle kavramı değişmiştir
- Bu API, eski UIManager'ın bridge-based command dispatch mekanizmasına bağımlıydı

### Yerine ne kullanılır?
- **React `ref` sistemi:** `useRef` + native component ref'leri doğrudan kullanılır
- **`measure` / `measureInWindow`:** View ölçümleri için ref üzerinden doğrudan çağrılır
- **Fabric native commands:** Custom native component komutları Codegen ile tanımlanır ve ref üzerinden çağrılır

## 13.3. UIManager.dispatchViewManagerCommand

### Neydi?
Native view manager'lara JavaScript'ten komut göndermek için kullanılan eski API.

### Neden kaldırıldı?
Eski bridge-based UIManager'a bağımlıydı; Fabric'te UIManager bu şekilde çalışmaz.

### Yerine ne kullanılır?
- **Codegen native commands:** Component spec'inde komutlar tanımlanır, Codegen binding üretir, ref üzerinden çağrılır

## 13.4. requireNativeComponent

### Neydi?
Eski native UI component'leri JavaScript tarafında kaydetmek için kullanılan API.

### Yerine ne kullanılır?
- **`codegenNativeComponent`:** Fabric uyumlu native component tanımlama API'si. Component spec'i yazılır, Codegen native binding'leri üretir.

## 13.5. AccessibilityInfo.fetch (eski API)

### Neydi?
Erişilebilirlik bilgilerini getiren eski API.

### Yerine ne kullanılır?
- **`AccessibilityInfo` event listener'ları:** Modern event-based API kullanılır

## 13.6. Genel migration kuralı

Bu boilerplate'te kaldırılan API'lerin kullanımı yasaktır. Kod review'da şu pattern'ler aranmalıdır:

- `setNativeProps` → red flag
- `findNodeHandle` → red flag
- `UIManager.dispatchViewManagerCommand` → red flag
- `requireNativeComponent` → red flag (Fabric uyumlu alternatif kullanılmalı)
- `NativeModules.` doğrudan erişim → sorgulanmalı (TurboModules spec üzerinden erişim tercih edilmeli)

---

# 14. Bootstrap Doğrulama Kapısı

ADR-002'de tanımlanan bootstrap doğrulama kapısı, bu ADR ile New Architecture özelinde genişletilmiştir.

## 14.1. New Architecture hazırlık kontrolü

Mobile bootstrap tamamlandı sayılmadan önce aşağıdaki New Architecture doğrulamaları zorunludur:

### 14.1.1. expo-doctor kontrolü

```bash
npx expo-doctor
```

Bu komut şunları doğrular:
- Expo SDK ile React Native sürüm uyumu
- Native bağımlılıkların uyumluluk durumu
- Bilinen uyumsuzluk uyarıları
- Config plugin tutarlılığı

expo-doctor çıktısında New Architecture ile ilgili herhangi bir uyarı veya hata varsa, bu çözülmeden mobile foundation hazır sayılmaz.

### 14.1.2. Native dependency audit

Projedeki tüm native bağımlılıklar (React Native'e özgü native kodu olan paketler) şu kontrol listesinden geçirilir:

1. Paket reactnativepackagedb.com'da "New Architecture Compatible" olarak işaretli mi?
2. Paketin en son sürümü Fabric ve TurboModules desteği sunuyor mu?
3. Paketin repository'sinde Codegen spec dosyaları var mı?
4. Paketin README veya changelog'unda New Architecture desteği belirtilmiş mi?
5. Paket interop layer üzerinden mi çalışıyor, yoksa native New Architecture desteği var mı?

### 14.1.3. Development build testi

Development build fiziksel cihaz veya emülatörde çalıştırılır ve şunlar doğrulanır:

- Uygulama crash olmadan açılıyor
- Tüm native modüller çağrıldığında çalışıyor
- UI rendering Fabric üzerinden sorunsuz gerçekleşiyor
- Console'da New Architecture ile ilgili uyarı veya hata yok
- Navigation geçişleri sorunsuz
- Temel etkileşimler (dokunma, kaydırma, metin girişi) çalışıyor

### 14.1.4. Hermes doğrulaması

```bash
# Hermes'in aktif olduğunu doğrulamak için JavaScript konsolunda:
# global.HermesInternal !== undefined → true dönmeli
```

Hermes V1'in aktif ve doğru çalıştığı doğrulanmalıdır.

## 14.2. Kural

Bu dört doğrulama adımından herhangi biri başarısız olursa mobile foundation New Architecture açısından hazır sayılmaz. Başarısız adım çözülene kadar bootstrap tamamlanmış kabul edilmez.

---

# 15. Risk ve Azaltma Önlemleri

## 15.1. Uyumsuz paket riski

### Risk tanımı
npm ekosistemindeki %15'lik uyumsuz paket dilimi, projeye eklenmek istenen bir paketin New Architecture ile çalışmama riskini taşır.

### Etki seviyesi
Yüksek. Uyumsuz bir paket runtime crash, performans regresyonu veya beklenmedik davranışa neden olabilir.

### Azaltma önlemleri
1. Her native dependency eklenmeden önce uyumluluk kontrolü zorunludur (bölüm 11.3)
2. expo-doctor CI pipeline'ına eklenir; her PR'da otomatik kontrol yapılır
3. Uyumsuz paket tespit edildiğinde bölüm 11.4'teki adımlar izlenir
4. reactnativepackagedb.com düzenli olarak kontrol edilir
5. Dependency policy (37) New Architecture uyumluluk kuralıyla genişletilir

## 15.2. Performans regresyon riski

### Risk tanımı
New Architecture genel olarak performans iyileştirmesi sağlar; ancak belirli senaryolarda (interop layer kullanan paketler, karmaşık native-JS etkileşimleri) regresyon yaşanabilir.

### Etki seviyesi
Orta. Regresyon genellikle izole senaryolarda gerçekleşir; sistem geneli performansı etkilemez.

### Azaltma önlemleri
1. Performans ölçümü 13-performance-standard'a göre yapılır
2. Cold start, render, navigation geçişleri için benchmark oluşturulur
3. Yeni native paket eklendikten sonra performans regresyon testi yapılır
4. Interop layer kullanan paketler takip edilir ve native New Architecture desteği geldiğinde güncellenir

## 15.3. Ekosistem olgunluk riski

### Risk tanımı
New Architecture göreceli olarak yeni bir ekosistemdir. Bazı edge case'ler, dokümantasyon eksiklikleri veya beklenmedik davranışlar hâlâ mümkündür.

### Etki seviyesi
Düşük-Orta. Ekosistem hızla olgunlaşmaktadır; büyük şirketler (Meta, Microsoft, Shopify, Coinbase) production'da kullanmaktadır.

### Azaltma önlemleri
1. React Native ve Expo'nun release note'ları yakından takip edilir
2. Bilinen sorunlar (known issues) proaktif olarak kontrol edilir
3. Topluluk tartışmaları (GitHub issues, Discord, Stack Overflow) izlenir
4. Expo SDK güncellemeleri zamanında uygulanır (uyumluluk matris kuralları çerçevesinde)

## 15.4. Interop layer bağımlılık riski

### Risk tanımı
Bazı üçüncü parti paketler doğrudan Fabric/TurboModules desteği sağlamaz ama interop layer (uyumluluk katmanı) sayesinde çalışır. Bu katman geçicidir ve gelecekte kaldırılabilir.

### Etki seviyesi
Orta. Interop layer kaldırıldığında bu paketler çalışmayı durduracaktır.

### Azaltma önlemleri
1. Interop layer üzerinden çalışan paketler listesi tutulur
2. Bu paketlerin native New Architecture desteği geldiğinde güncelleme planlanır
3. Kritik paketler için alternatif veya fork planı hazır tutulur
4. Interop layer deprecation duyuruları takip edilir

---

# 16. Non-Goals

Bu ADR aşağıdakileri çözmez:

- **Belirli native modül implementasyonu:** Bu ADR genel strateji ve hazırlık kapsamındadır; spesifik native modül yazımı (örneğin custom kamera modülü) bu ADR'nin scope'u dışındadır
- **Custom Fabric component geliştirme rehberi:** Fabric uyumlu custom native component yazma adımları bu ADR'de implementation-level detay olarak ele alınmaz; bu ayrı bir teknik rehber konusudur
- **Codegen spec yazma kılavuzu:** TurboModules spec dosyası yazım detayları bu ADR'nin scope'u dışındadır
- **Hermes bytecode optimizasyon teknikleri:** Hermes'in ileri seviye optimizasyon seçenekleri bu ADR'nin kapsamı dışındadır
- **React Compiler entegrasyonu:** React Compiler controlled opt-in watchlist'tedir (36-canonical-stack-decision); bu ADR React Compiler kararını vermez
- **Mobile E2E test tool seçimi:** Test tooling kararı ADR-008 kapsamındadır
- **Biome migration:** Biome 2.x pilot/watchlist'tedir; bu ADR Biome kararını vermez
- **Native performance profiling rehberi:** Detaylı profiling yöntemleri 13-performance-standard ve 28-observability-and-debugging kapsamındadır

---

# 17. Sonuç ve Etkiler

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. New Architecture bu boilerplate'in canonical ve kapatılamaz mimari gerçekliği olarak resmi kayda geçer
2. Fabric, JSI, TurboModules ve Hermes V1 hakkında ekip seviyesinde ortak bilgi tabanı oluşur
3. Her native dependency eklenmesinde New Architecture uyumluluk kontrolü zorunlu hale gelir (37-dependency-policy genişletmesi)
4. 38-version-compatibility-matrix New Architecture uyumluluk sütunu ile güncellenir
5. Bootstrap doğrulama kapısı New Architecture kontrolleri ile genişletilir (20-initial-implementation-checklist etkisi)
6. Kaldırılan API'lerin kullanımı code review'da red flag olarak işaretlenir
7. Performans beklentileri somut veriye dayalı olarak tanımlanır ve 13-performance-standard ile hizalanır
8. Interop layer bağımlılıkları takip listesine alınır
9. expo-doctor kontrolü CI pipeline kapsamına eklenir
10. 19-roadmap-to-implementation New Architecture readiness milestone'ı ile güncellenir
11. 31-audit-checklist New Architecture uyumluluk maddeleri ile güncellenir

---

# 18. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. New Architecture'ın zorunlu gerçeklik olma durumu net açıklanmışsa
2. Fabric, JSI, TurboModules ve Hermes V1 her biri ayrı ayrı ve yeterli derinlikte açıklanmışsa
3. Eski mimari ile yeni mimari arasındaki farklar somut ve anlaşılır şekilde karşılaştırılmışsa
4. Paket uyumluluk değerlendirme stratejisi, kontrol yöntemleri ve uyumsuzluk durumunda izlenecek adımlar tanımlanmışsa
5. Performans beklentileri rakamlarla desteklenmiş ve kaynaklarıyla birlikte sunulmuşsa
6. Kaldırılan API'lerin listesi ve modern alternatifleri açıkça yazılmışsa
7. Bootstrap doğrulama kapısı New Architecture kontrolleri ile genişletilmişse
8. Riskler dürüstçe tanımlanmış ve her risk için somut azaltma önlemi belirtilmişse
9. Non-goals açıkça tanımlanmışsa
10. Etkilediği belgeler ve sonuçlar görünür kılınmışsa
11. Bu ADR, implementation ekibine New Architecture gerçekliğini yönetecek netlikteyse

---

# 19. Kararın Kısa Hükmü

> New Architecture (Fabric + JSI + TurboModules + Hermes V1), Expo SDK 55 + React Native 0.83 hattında kapatılamaz canonical mimaridir. Bu boilerplate bu gerçekliği pasif olarak kabul etmekle kalmaz; bütünsel strateji, paket uyumluluk kontrolü, bootstrap doğrulaması, performans beklentileri ve risk yönetimi ile aktif olarak yönetir. Eski bridge mimarisi ve kaldırılan API'lerin kullanımı yasaktır.

---

# 20. Kısa Sonuç

Bu ADR'nin ana çıktısı şudur:

> New Architecture artık bir geçiş hedefi değil, mevcut gerçekliktir. Bu ADR, bu gerçekliğin Fabric renderer, JSI native iletişim katmanı, TurboModules modül sistemi ve Hermes V1 JavaScript engine bileşenlerini detaylı şekilde açıklar; paket uyumluluk stratejisini tanımlar; performans beklentilerini somutlaştırır; kaldırılan API'lerin migration yollarını gösterir; bootstrap doğrulama kapısını genişletir ve ekosistem risklerini yönetir. Bu boilerplate'te yazılacak her mobile kodun, eklenecek her native paketin ve yapılacak her performans değerlendirmesinin bu ADR'nin tanımladığı gerçeklik çerçevesinde ele alınması zorunludur.
