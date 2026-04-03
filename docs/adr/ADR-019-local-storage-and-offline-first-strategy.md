# ADR-019 — Local Storage and Offline-First Strategy

## Doküman Kimliği

- **ADR ID:** ADR-019
- **Başlık:** Local Storage and Offline-First Strategy
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar türü:** Foundational local persistence, offline-first mimari, storage katmanı ve queue/replay stratejisi kararı
- **Karar alanı:** Local storage katmanları, MMKV vs AsyncStorage seçimi, Zustand persistence entegrasyonu, TanStack Query offline mutation queue, şifreleme gereksinimleri, platform farkları, ağ kesintisi UX stratejisi
- **İlgili üst belgeler:**
  - `ADR-004-state-management.md`
  - `ADR-005-data-fetching-cache-and-mutation-model.md`
  - `ADR-010-auth-session-and-secure-storage-baseline.md`
  - `09-state-management-strategy.md`
  - `10-data-fetching-cache-sync.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `19-roadmap.md`
  - `20-initial-implementation-checklist.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında local storage ve offline-first stratejisi için aşağıdaki karar kabul edilmiştir:

- **Canonical non-secure persistence aracı (mobile):** react-native-mmkv (MMKV) varsayılan local persistence aracıdır
- **Legacy uyumluluk aracı (mobile):** AsyncStorage yalnızca üçüncü parti kütüphane uyumluluğu gerektirdiğinde kullanılır; yeni kod için canonical seçim değildir
- **Hassas veri persistence (mobile):** Expo SecureStore canonical güvenli depolama aracıdır (ADR-010 ile hizalı)
- **Web persistence:** localStorage varsayılan non-sensitive persistence; IndexedDB büyük yapısal veri için; HttpOnly cookie auth artefact'ları için (ADR-010 ile hizalı)
- **Zustand persistence:** zustand/middleware persist + MMKV storage adapter ile kontrollü persistence; selective partialize zorunludur
- **TanStack Query offline mutation:** Mutation queue persistence + network-aware retry + conflict resolution stratejisi
- **Şifreleme:** MMKV encryption (AES-256) hassas kullanıcı tercihleri için; encryption key yönetimi platform keychain/keystore üzerinden
- **Storage katmanları:** Dört katmanlı mimari (SecureStore → MMKV encrypted → MMKV plain → TanStack Query cache)
- **Canonical ilke:** Persistence bu boilerplate'te "her şeyi diske yaz" rahatlığıyla kurulmaz; her veri parçasının hangi katmanda, ne kadar süre, hangi güvenlik seviyesinde ve hangi lifecycle ile yaşayacağı bilinçli karardır

Bu ADR'nin ana hükmü şudur:

> Local storage ve offline-first davranış bu boilerplate'te rastgele AsyncStorage.setItem çağrılarıyla çözülmeyecektir. Mobile'da MMKV varsayılan non-secure persistence aracıdır; hassas veri SecureStore'da, şifrelenmiş tercihler MMKV encrypted instance'ında yaşar. Zustand persist middleware kontrollü ve selective uygulanır. TanStack Query mutation queue offline senaryolarda persist edilir ve network recovery sonrası replay edilir. Her storage kararı ownership, security, staleness ve cleanup disipliniyle verilir.

---

# 2. Problem Tanımı

Local storage ve offline-first stratejisi kararı verilmezse veya yarım verilirse aşağıdaki bozulmalar kaçınılmazdır:

- Kullanıcı uygulamayı açtığında önceki oturumdan kalan tercihler (tema, dil, bildirim ayarları) sıfırlanır; kullanıcı her seferinde yeniden ayar yapar
- Ağ bağlantısı kesildiğinde uygulama tamamen çalışmaz hale gelir; kullanıcı hiçbir işlem yapamaz
- Offline durumda yapılan değişiklikler kaybolur; kullanıcı bağlantı geldiğinde işlemleri tekrar yapmak zorunda kalır
- AsyncStorage'ın yavaş read/write performansı (5-10ms per read) nedeniyle uygulama açılışında gecikme yaşanır; hydration süresi kullanıcıyı bekletir
- Hassas kullanıcı verisi (tercihler, draft içerikler) şifrelenmeden düz metin olarak cihazda saklanır; cihaz ele geçirildiğinde veri ifşa olur
- Auth token'ları yanlışlıkla generic storage'a yazılır; güvenlik ihlali oluşur
- Logout veya kullanıcı değişikliğinde eski kullanıcının persist edilmiş verisi temizlenmez; wrong-user data leak oluşur
- Farklı geliştiriciler farklı storage çözümleri kullanır (biri AsyncStorage, biri MMKV, biri localStorage); tutarsızlık ve bakım kabusu oluşur
- Offline mutation'lar yönetilmez; ağ geldiğinde kullanıcı verisi kaybolmuş olur
- Web ve mobile arasında storage davranış farkları düşünülmez; platform-specific bug'lar oluşur
- Storage quota aşımı ele alınmaz; uygulama beklenmedik hatalar üretir

Bu yüzden local storage kararı yalnızca "hangi kütüphane?" sorusu değildir.
Asıl soru şudur:

> Hangi veri nerede, hangi güvenlik seviyesinde, ne kadar süre yaşayacak; offline durumda uygulama nasıl davranacak; mutation queue nasıl yönetilecek ve persistence lifecycle'ı kullanıcı değişikliği, logout ve app restart durumlarında nasıl temizlenecek?

Bu ADR tam olarak bunu kapatır.

---

# 3. Bağlam

Bu boilerplate'in local storage ve offline-first açısından taşıdığı zorunluluklar şunlardır:

1. **Cross-platform yapı:** Web (React + Vite) ve mobile (React Native + Expo SDK 55) arasında storage davranışsal uyum gerekir; ama platform-specific implementation farkları doğaldır
2. **Zustand persistence ihtiyacı:** ADR-004 kapsamında app-global preferences (tema, dil, UI tercihleri) persist edilmelidir; ama her store persist edilmemelidir
3. **TanStack Query offline desteği:** ADR-005 kapsamında offline mutation queue ve cache persistence ihtiyacı vardır
4. **SecureStore zaten canonical:** ADR-010 kapsamında auth artefact'ları Expo SecureStore'da yaşar; bu ADR o kararı bozmaz, tamamlar
5. **Performans beklentisi:** Uygulama açılışında hydration süresi kullanıcıyı fark edilir şekilde bekletmemelidir
6. **New Architecture uyumu:** React Native New Architecture (JSI tabanlı) ile uyumlu araçlar tercih edilmelidir
7. **Güvenlik ve gizlilik:** GDPR/KVKK uyumu (ADR-017) gereği cihazda saklanan kişisel veri korunmalıdır
8. **Mevcut boşluk:** Projede AsyncStorage referansları mevcut ancak MMKV, offline-first mimari, queue/replay ve persistence için canonical karar bulunmamaktadır

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Read/write performansı (hydration hızı)**
2. **New Architecture (JSI) uyumu**
3. **Şifreleme desteği (at-rest encryption)**
4. **Zustand persist middleware ile entegrasyon kolaylığı**
5. **TanStack Query cache/mutation persistence desteği**
6. **Cross-platform (web/mobile) davranış tutarlılığı**
7. **Expo SDK 55 ile uyumluluk**
8. **Üçüncü parti kütüphane ekosistemi uyumu**
9. **Storage quota yönetimi**
10. **Logout/user switch cleanup disiplini**
11. **TypeScript desteği ve type safety**
12. **Bundle size etkisi**
13. **Bakım ve community olgunluğu**

---

# 5. Değerlendirilen Alternatifler

Bu karar öncesi ana alternatifler şunlardır:

1. MMKV (react-native-mmkv)
2. AsyncStorage (@react-native-async-storage/async-storage)
3. Expo SecureStore (expo-secure-store) — tek başına tüm persistence için
4. WatermelonDB / SQLite — yapısal offline veritabanı
5. "Her feature kendi storage çözümünü seçsin" yaklaşımı

Bu alternatiflerin neden seçilmediği veya seçildiği aşağıda açıklanmıştır.

---

# 6. AsyncStorage vs MMKV Karşılaştırması — Detaylı Analiz

Bu bölüm, storage kararının temelini oluşturan iki aracın kapsamlı karşılaştırmasını içerir. Karar yalnızca "MMKV daha hızlı" cümlesiyle alınmamıştır; mimari, güvenlik, uyumluluk ve lifecycle farkları da hesaba katılmıştır.

## 6.1. AsyncStorage nedir?

AsyncStorage, React Native ekosistemindeki en eski ve en yaygın bilinen key-value storage çözümüdür.

### 6.1.1. Teknik yapısı

- **Asenkron API:** Tüm read/write işlemleri Promise döner; `await AsyncStorage.getItem('key')` şeklinde kullanılır
- **JSON serialization zorunluluğu:** Tüm değerler string olarak saklanır; obje veya dizi saklamak için `JSON.stringify` / `JSON.parse` çağrısı gerekir
- **SQLite tabanlı (iOS/Android):** Arka planda SQLite veritabanı kullanır; bu da her okuma/yazma işleminin disk I/O + SQLite sorgusu + bridge geçişi gerektirdiği anlamına gelir
- **Bridge tabanlı iletişim:** React Native'in eski mimarisinde (bridge architecture), JavaScript tarafından native tarafa mesaj gönderilir, native tarafta işlem yapılır, sonuç tekrar bridge üzerinden JavaScript'e döner. Bu gidiş-dönüş her işlem için ek maliyet üretir
- **Batch desteği:** `multiGet` ve `multiSet` ile toplu işlem yapılabilir; ama her biri yine asenkron ve bridge üzerinden çalışır

### 6.1.2. Performans profili

- **Ortalama read süresi:** 5-10ms per key (cihaz performansına göre değişir)
- **Ortalama write süresi:** 5-15ms per key
- **Batch read (10 key):** 15-30ms
- **JSON parse overhead:** Büyük objelerde ek 1-5ms
- **Toplam hydration etkisi:** 10 ayrı store'un rehydrate edilmesi 50-150ms sürebilir; bu süre kullanıcıya fark edilir gecikme olarak yansıyabilir

### 6.1.3. Ne zaman yeterlidir?

- Üçüncü parti kütüphane zorunlu olarak AsyncStorage adapter bekliyorsa
- Legacy kod migration sürecinde geçici uyumluluk gerekiyorsa
- Çok nadir okunan, performans-kritik olmayan veriler için

### 6.1.4. Zayıf yönleri

- Bridge overhead her işlemde maliyet üretir
- Senkron okuma yapılamaz; bu da hydration sırasında UI'ın "henüz veri yok" durumunda kalmasına neden olabilir
- JSON serialization/deserialization her işlemde CPU maliyeti üretir
- Şifreleme desteği yoktur; veri düz metin olarak SQLite'ta saklanır
- New Architecture (JSI tabanlı) ile doğrudan uyumlu değildir; bridge geçişi devam eder

## 6.2. MMKV nedir?

MMKV (Memory-Mapped Key-Value), WeChat tarafından geliştirilen ve react-native-mmkv paketi ile React Native'e taşınan yüksek performanslı key-value storage çözümüdür.

### 6.2.1. Teknik yapısı

- **Senkron API:** Tüm read/write işlemleri senkron çalışır; `storage.getString('key')` şeklinde kullanılır, Promise döndürmez
- **Memory-mapped file I/O:** Dosya doğrudan belleğe (memory) map edilir; okuma ve yazma işlemleri bellek üzerinden gerçekleşir, her seferinde disk I/O sorgusu yapılmaz. İşletim sistemi değişiklikleri arka planda diske yazar (write-back)
- **C++ tabanlı:** Native C++ ile yazılmıştır; JavaScript tarafından JSI (JavaScript Interface) üzerinden doğrudan çağrılır
- **JSI tabanlı iletişim:** Bridge kullanmaz; JavaScript'ten doğrudan native C++ fonksiyonlarına erişir. Bu, bridge overhead'ini tamamen ortadan kaldırır
- **Protobuf encoding:** Veriyi JSON yerine protobuf benzeri binary format ile encode eder; serialization maliyeti çok düşüktür
- **Birden fazla instance desteği:** Farklı amaçlar için ayrı MMKV instance'ları oluşturulabilir (örneğin: `new MMKV({ id: 'user-preferences' })`, `new MMKV({ id: 'app-cache' })`)

### 6.2.2. Performans profili

- **Ortalama read süresi:** ~0.01ms per key (AsyncStorage'a göre ~500-1000x daha hızlı)
- **Ortalama write süresi:** ~0.02ms per key
- **Batch read (10 key):** ~0.1ms
- **Serialization overhead:** Protobuf encoding sayesinde ihmal edilebilir düzeyde
- **Toplam hydration etkisi:** 10 ayrı store'un rehydrate edilmesi <1ms sürer; kullanıcı hiçbir gecikme hissetmez

### 6.2.3. Güçlü yönleri

- JSI tabanlı; New Architecture ile doğal uyumlu
- Senkron API; hydration sırasında veri anında mevcut, UI "henüz yükleniyor" durumuna düşmez
- Memory-mapped I/O; disk erişim maliyeti minimize edilmiş
- Built-in AES-256 şifreleme desteği
- Birden fazla izole instance; veri ayrımı ve per-user isolation kolayca sağlanabilir
- WeChat'in 1 milyardan fazla kullanıcısıyla production-tested
- TypeScript desteği güçlü

### 6.2.4. Dikkat edilmesi gerekenler

- Native modül gerektirdiği için Expo Go'da doğrudan çalışmaz; Expo Dev Client veya prebuild gerekir (bu boilerplate Expo prebuild modeli kullandığından sorun teşkil etmez)
- Çok büyük veri parçaları (>10MB) için uygun değildir; bu tür veriler dosya sistemi veya SQLite tercih edilmelidir
- Web'de çalışmaz; web için ayrı persistence stratejisi gerekir (bu ADR bunu kapsar)

## 6.3. Karşılaştırma tablosu

| Kriter | AsyncStorage | MMKV |
|--------|-------------|------|
| API türü | Asenkron (Promise) | Senkron |
| Mimari | Bridge tabanlı | JSI tabanlı |
| Ortalama read | 5-10ms | ~0.01ms |
| Ortalama write | 5-15ms | ~0.02ms |
| Serialization | JSON (yavaş) | Protobuf (hızlı) |
| Şifreleme | Yok | AES-256 built-in |
| New Architecture | Bridge devam eder | Doğal uyumlu |
| Multi-instance | Yok | Var |
| Web desteği | Yok (mobile only) | Yok (mobile only) |
| Expo Go | Çalışır | Çalışmaz (Dev Client gerekir) |
| Bundle size | ~50KB | ~150KB |

## 6.4. Canonical karar

- **MMKV:** Varsayılan non-secure mobile persistence aracıdır. Yeni kod MMKV kullanır.
- **AsyncStorage:** Yalnızca üçüncü parti kütüphane uyumluluğu zorunlu kıldığında kullanılır. Yeni feature geliştirmede AsyncStorage tercih edilmez.
- **SecureStore:** Auth token, biometric key gibi hassas güvenlik artefact'ları için. ADR-010 ile hizalı; bu ADR onu değiştirmez.

## 6.5. Hangi veri türü nereye yazılmalı?

| Veri türü | Storage aracı | Gerekçe |
|-----------|--------------|---------|
| Auth token (access/refresh) | Expo SecureStore | Güvenlik-kritik; keychain/keystore koruması |
| Biometric key | Expo SecureStore | Güvenlik-kritik; hardware-backed |
| Kullanıcı tercihleri (hassas) | MMKV encrypted | Şifrelenmeli; performanslı erişim gerekli |
| Tema, dil, UI tercihleri | MMKV plain | Hassas değil; hızlı hydration gerekli |
| Draft içerikler | MMKV plain veya encrypted | İçeriğe göre; kullanıcı beklentisi persist |
| TanStack Query cache | MMKV veya AsyncStorage adapter | Performans öncelikli; büyük payload'larda dikkatli |
| Üçüncü parti kütüphane verisi | AsyncStorage (uyumluluk) | Kütüphane zorunlu kılıyorsa |
| Büyük medya/dosya | Dosya sistemi (expo-file-system) | Storage kütüphaneleri için uygun değil |

---

# 7. Zustand + MMKV Persistence Entegrasyonu

Bu bölüm, ADR-004'te kabul edilen Zustand state management ile MMKV persistence'ın nasıl birlikte çalışacağını detaylı olarak açıklar.

## 7.1. zustand/middleware persist nasıl çalışır?

Zustand, `persist` middleware'i ile store verilerinin bir storage backend'ine yazılmasını ve uygulama restart'ında geri yüklenmesini (rehydration) sağlar.

Temel çalışma prensibi şudur:

1. Store oluşturulurken `persist` middleware'i sarılır
2. Her state değişikliğinde middleware, belirlenen storage'a güncel state'i yazar
3. Uygulama yeniden açıldığında middleware, storage'dan veriyi okur ve store'u geri yükler (rehydrate eder)
4. Rehydration tamamlanana kadar store default değerleriyle çalışır; rehydration sonrası persist edilmiş değerler uygulanır

Middleware şu konfigürasyon seçeneklerini sunar:

- **name:** Storage'da kullanılacak key adı
- **storage:** Kullanılacak storage backend (localStorage, AsyncStorage, MMKV adapter vb.)
- **partialize:** Store'un hangi alanlarının persist edileceğini belirleyen fonksiyon
- **version:** Migration desteği için versiyon numarası
- **migrate:** Versiyon değişikliğinde veri dönüşümü yapan fonksiyon
- **onRehydrateStorage:** Rehydration lifecycle hook'u

## 7.2. MMKV storage adapter oluşturma

Zustand persist middleware'i `getItem`, `setItem` ve `removeItem` fonksiyonlarını içeren bir storage interface bekler. MMKV bu interface'e uyarlanmalıdır.

MMKV storage adapter'ı şu üç fonksiyonu sağlar:

- **getItem(name):** MMKV'den senkron olarak veriyi okur, JSON parse eder ve döner
- **setItem(name, value):** Veriyi JSON stringify edip MMKV'ye senkron olarak yazar
- **removeItem(name):** MMKV'den ilgili key'i siler

MMKV senkron olduğu için adapter'ın Promise döndürmesine gerek yoktur. Bu, hydration'ın anında gerçekleşmesini sağlar ve "henüz yükleniyor" durumunu minimize eder.

Her store için ayrı MMKV instance kullanılması önerilir. Bu sayede:
- Store'lar birbirinden izole olur
- Bir store'un temizlenmesi diğerini etkilemez
- Per-user isolation kolaylaşır

## 7.3. Hangi store'lar persist edilmelidir?

ADR-004'teki persistence politikası burada da geçerlidir. Persist edilmesi meşru olan store'lar:

### 7.3.1. Persist edilMELİ olanlar

- **Theme store:** Kullanıcının seçtiği tema (light/dark/system) uygulama restart'ında korunmalıdır; aksi halde her açılışta varsayılan temaya düşer
- **Locale store:** Kullanıcının seçtiği dil tercihi korunmalıdır
- **UI preferences store:** Display density, sidebar durumu, bildirim tercihleri gibi kullanıcı kişiselleştirmeleri
- **Onboarding/tutorial state:** Kullanıcının onboarding'i tamamlayıp tamamlamadığı bilgisi; aksi halde her açılışta onboarding gösterilir
- **Dismissed banners/notices:** Kullanıcının kapatılan banner'ları tekrar görmemesi için

### 7.3.2. Persist edilMEMELİ olanlar

- **Auth token'ları:** Bunlar generic MMKV'ye değil, SecureStore'a yazılır (ADR-010)
- **Ephemeral UI state:** Modal açık/kapalı, dropdown görünürlüğü, geçici seçim durumları
- **Server-owned veri kopyaları:** Query cache'ten kopyalanan veri store'da persist edilmez (ADR-005)
- **Form state:** Field values, touched, dirty gibi form engine state'i persist edilmez (ADR-006)
- **Hassas kullanıcı verisi:** Kişisel bilgiler (e-posta, telefon) generic persist'e yazılmaz
- **Session-specific geçici context:** Tek session'lık navigation state, geçici seçimler

## 7.4. Selective persistence (partialize)

Persist middleware'inin `partialize` seçeneği kullanılmalıdır. Bu seçenek, store'un tamamını değil, yalnızca belirlenen alanlarını persist eder.

Neden zorunludur:

- Store'da hem persist edilmesi gereken hem de edilmemesi gereken alanlar bir arada yaşayabilir
- Tüm store'u persist etmek gereksiz veri yazmaya, stale risk artışına ve cleanup karmaşıklığına yol açar
- Partialize ile yalnızca gerçekten kalıcı olması gereken veriler diske yazılır

Örnek senaryo: Bir theme store'da `mode` (light/dark/system) persist edilmeli, ama `isTransitioning` (tema geçiş animasyonu durumu) persist edilmemelidir.

## 7.5. Migration stratejisi (version field)

Persist edilen veri yapısı zamanla değişebilir (yeni alanlar eklenir, eskiler kaldırılır, yapı dönüşür). Bu durumda uyumsuz veri hydration hatasına yol açar.

Çözüm: `version` ve `migrate` seçenekleri birlikte kullanılır.

- **version:** Her persist şeması değişikliğinde artırılır (1 → 2 → 3)
- **migrate:** Eski versiyon verisi okunduğunda yeni yapıya dönüştüren fonksiyon

Migration kuralları:

1. Her persist edilmiş store'un versiyon numarası olmalıdır
2. Şema değişikliğinde versiyon artırılır ve migrate fonksiyonu yazılır
3. Migrate fonksiyonu geriye dönük uyumlu olmalıdır (v1 → v3 geçişi de çalışmalıdır)
4. Migrate fonksiyonu hata fırlatırsa store varsayılan değerlerine geri döner (veri kaybı riski bilinmelidir)
5. Migration testleri yazılmalıdır

## 7.6. Hydration lifecycle (onRehydrateStorage)

Persist middleware'inin `onRehydrateStorage` hook'u rehydration lifecycle'ını yönetir.

Bu hook iki aşamalı çalışır:

1. **Başlangıç aşaması:** Rehydration başladığında çağrılır; loading state ayarlanabilir
2. **Tamamlanma aşaması:** Rehydration bittiğinde (başarılı veya hatalı) çağrılır; error handling yapılabilir

Bu hook şu amaçlarla kullanılmalıdır:

- Rehydration sırasında splash screen veya loading indicator gösterimi kontrol edilir
- Rehydration hatası durumunda graceful fallback uygulanır (varsayılan değerlere dönüş)
- Rehydration tamamlandıktan sonra app initialization akışı tetiklenir
- Rehydration metriği observability katmanına raporlanır

Önemli: MMKV senkron olduğu için rehydration neredeyse anında tamamlanır. Ama migration veya büyük veri durumlarında yine de lifecycle hook'u kontrollü davranış sağlar.

---

# 8. TanStack Query Offline Mutation Queue

Bu bölüm, ADR-005'te kabul edilen TanStack Query'nin offline senaryolardaki davranışını detaylı olarak açıklar.

## 8.1. Offline mutation nedir?

Kullanıcı ağ bağlantısı olmadığında (uçak modu, tünel, zayıf sinyal) bir yazma işlemi tetiklediğinde (form gönderme, içerik oluşturma, ayar değiştirme), bu işlemin kaybolmaması ve ağ geldiğinde otomatik olarak sunucuya iletilmesi gerekliliğidir.

TanStack Query'nin mutation sistemi bu senaryoyu şu şekilde destekler:

1. Mutation tetiklenir ama ağ yoktur
2. Mutation bir kuyruğa (queue) eklenir
3. Kuyruk cihazda persist edilir (app kapansa bile kaybolmaz)
4. Ağ bağlantısı geri geldiğinde kuyruk sırayla işlenir (replay)
5. Her mutation sonucu (başarı/hata) normal lifecycle'ı izler

## 8.2. Online Mutation Manager

TanStack Query'nin `onlineManager` modülü ağ durumunu yönetir:

- **Ağ durumu tespiti:** `@react-native-community/netinfo` (mobile) veya `navigator.onLine` (web) ile ağ durumu izlenir
- **Otomatik pause/resume:** Ağ yokken mutation'lar pause edilir; ağ gelince resume edilir
- **Custom network detection:** Varsayılan ağ tespiti yetersiz kalırsa custom listener eklenebilir

NetInfo entegrasyonu şu bilgileri sağlar:

- İnternet bağlantısı var mı? (`isConnected`)
- Bağlantı türü nedir? (wifi, cellular, ethernet)
- İnternet gerçekten erişilebilir mi? (`isInternetReachable` — bağlantı var ama sunucuya ulaşılamıyor durumunu tespit eder)

## 8.3. Mutation queue persistence

Mutation kuyruğunun cihazda persist edilmesi kritiktir. Çünkü:

- Kullanıcı offline durumda mutation tetikler
- Uygulama arka plana alınır veya kapanır
- Uygulama tekrar açıldığında kuyrukta bekleyen mutation'lar kaybolmamalıdır

Persistence için iki seçenek mevcuttur:

### 8.3.1. MMKV ile persistence (önerilen)

- Senkron read/write sayesinde kuyruk anında yüklenir
- Hydration gecikmesi yok
- Küçük-orta boyutlu mutation payload'ları için idealdir

### 8.3.2. AsyncStorage ile persistence (uyumluluk)

- TanStack Query'nin resmi `@tanstack/query-async-storage-persister` paketi AsyncStorage ile çalışır
- Eğer mevcut AsyncStorage adapter zaten kullanılıyorsa uyumluluk avantajı sunar
- Performans dezavantajı mevcuttur

Canonical tercih: Yeni implementasyonlarda MMKV adapter kullanılır. AsyncStorage yalnızca migration sürecinde veya zorunlu uyumluluk durumunda kabul edilir.

## 8.4. Retry stratejisi

Offline mutation'lar ağ geldiğinde tekrar denenirken şu kurallar uygulanır:

### 8.4.1. Exponential backoff

- İlk deneme: anında
- İkinci deneme: 1 saniye sonra
- Üçüncü deneme: 2 saniye sonra
- Dördüncü deneme: 4 saniye sonra
- Maksimum bekleme: 30 saniye
- Maksimum deneme sayısı: bağlama göre 3-5 arası

### 8.4.2. Hata türüne göre retry kararı

- **Network error (timeout, connection refused):** Retry uygulanır
- **401 Unauthorized:** Retry uygulanmaz; auth refresh akışı tetiklenir
- **400 Validation error:** Retry uygulanmaz; kullanıcıya hata gösterilir
- **409 Conflict:** Retry uygulanmaz; conflict resolution akışı tetiklenir
- **500 Server error:** Sınırlı retry uygulanır (max 2)
- **404 Not found:** Retry uygulanmaz; kaynak artık mevcut değil

### 8.4.3. Mutation türüne göre retry kararı

- **Idempotent işlemler (PUT, DELETE):** Retry güvenlidir
- **Non-idempotent işlemler (POST):** Retry dikkatli yapılmalıdır; duplicate oluşma riski değerlendirilmelidir
- **Finansal/kritik işlemler:** Otomatik retry yerine kullanıcı onayı ile manual retry tercih edilmelidir

## 8.5. Conflict resolution yaklaşımları

Offline durumda birden fazla kullanıcı veya cihaz aynı veriyi değiştirmiş olabilir. Ağ geldiğinde bu çakışmalar çözülmelidir.

### 8.5.1. Last-write-wins (varsayılan)

- En basit yaklaşım; son yazma kazanır
- Timestamp karşılaştırması ile belirlenir
- Veri kaybı riski vardır ama implementasyon karmaşıklığı düşüktür
- Boilerplate varsayılanı olarak kabul edilir

### 8.5.2. Merge stratejisi (ileri seviye)

- Field bazlı merge; çakışan alanlar ayrı ayrı değerlendirilir
- Daha karmaşık ama veri kaybı riski düşüktür
- Ürün bağlamına göre gerektiğinde uygulanır
- Boilerplate'te hazır altyapı sunulur ama varsayılan olarak etkin değildir

### 8.5.3. Kullanıcıya sor (interactive conflict resolution)

- Çakışma tespit edildiğinde kullanıcıya her iki versiyon gösterilir
- Kullanıcı hangisini kabul edeceğini seçer
- En güvenli ama en yavaş yaklaşımdır
- Kritik veriler için önerilir

## 8.6. gcTime ve staleTime offline bağlamda ayarlanması

TanStack Query'nin cache davranışını kontrol eden iki kritik parametre offline senaryolarda dikkatle ayarlanmalıdır:

### 8.6.1. staleTime

- **Tanım:** Verinin "taze" sayılma süresi; bu süre içinde refetch yapılmaz
- **Offline etkisi:** Offline durumda refetch zaten yapılamayacağı için staleTime'ın kısa olması gereksiz refetch tetikleme girişimleri üretir
- **Öneri:** Offline-aware uygulamalarda staleTime daha yüksek tutulmalıdır (5-30 dakika); çünkü stale data göstermek hiç data göstermemekten iyidir
- **Bağlama göre ayar:** Sık değişen veriler (chat, bildirim) için daha kısa; nadir değişen veriler (profil, ayarlar) için daha uzun

### 8.6.2. gcTime (garbage collection time)

- **Tanım:** Cache'ten çıkarılan (unmount olan) verinin bellekte tutulma süresi; bu süre sonunda veri tamamen silinir
- **Offline etkisi:** gcTime çok kısa olursa offline durumda kullanıcı ekranlar arası geçiş yaptığında veri kaybolur ve gösterilemez
- **Öneri:** Offline-aware uygulamalarda gcTime yüksek tutulmalıdır (30 dakika - 24 saat); persist edilmiş cache ile birlikte çalıştığında Infinity bile düşünülebilir (ama storage quota dikkate alınmalıdır)
- **Cleanup:** gcTime yüksek tutulduğunda periyodik cleanup mekanizması gerekir; logout ve user switch'te tüm cache temizlenir

## 8.7. Network state detection

Ağ durumu tespiti offline-first mimarinin temelidir.

### 8.7.1. Mobile (@react-native-community/netinfo)

- `addEventListener` ile ağ durumu değişikliklerini izler
- `isConnected`: fiziksel bağlantı durumu
- `isInternetReachable`: gerçek internet erişimi (DNS çözümlemesi yaparak doğrular)
- `type`: wifi, cellular, ethernet, bluetooth, vpn
- `details.cellularGeneration`: 2g, 3g, 4g, 5g (bağlantı kalitesi tahmini)

### 8.7.2. Web (navigator.onLine + fetch probe)

- `navigator.onLine`: tarayıcının bildirdiği bağlantı durumu (güvenilirliği sınırlı)
- `online`/`offline` event listener'ları
- Gerçek erişim testi: periyodik lightweight fetch probe (ör. /api/health endpoint)

### 8.7.3. TanStack Query entegrasyonu

- `onlineManager.setOnline(isOnline)`: Manual ağ durumu ayarı
- `onlineManager.setEventListener(setOnline)`: Custom event listener
- NetInfo değişikliği → onlineManager güncelleme → mutation queue resume/pause

---

# 9. Ağ Kesintisi Sırasında Kullanıcı Deneyimi

Offline durumda uygulamanın kullanıcıya nasıl davranacağı teknik karardan daha önemlidir. Kullanıcı ağ olmadığında uygulamanın çalışmadığını değil, sınırlı ama güvenilir çalıştığını hissetmelidir.

## 9.1. Offline indicator tasarımı

### 9.1.1. Banner yaklaşımı (canonical varsayılan)

- Ekranın üstünde veya altında sabit, küçük bir banner gösterilir
- "Çevrimdışısınız — değişiklikleriniz kaydedildi, bağlantı geldiğinde senkronize edilecek" mesajı
- Banner rengi uyarı seviyesinde olmalıdır (amber/sarı tonları); kırmızı değil, çünkü bu bir hata değil, bilgilendirmedir
- Banner, bağlantı geri geldiğinde otomatik olarak kaybolur
- Banner kullanıcının işlemini engellememeli; sadece bilgilendirmelidir

### 9.1.2. Toast yaklaşımı (geçiş anları için)

- Offline'a geçiş ve online'a dönüş anlarında kısa süreli toast gösterilir
- "Bağlantı kesildi" ve "Bağlantı geri geldi — senkronize ediliyor..." mesajları
- Toast, banner'ın yanı sıra geçiş anlarını vurgulamak için kullanılır

### 9.1.3. Icon yaklaşımı (minimal)

- Navigation bar veya status bar'da küçük offline icon (bulut + çizgi) gösterilir
- En az yer kaplayan yaklaşım; minimal bilgilendirme
- Banner veya toast ile birlikte kullanılabilir

## 9.2. Cached data gösterimi

### 9.2.1. Stale data gösterimi (varsayılan)

- Offline durumda cache'te bulunan veri gösterilir; veri eski olsa bile
- "Son güncelleme: 5 dakika önce" gibi zaman bilgisi gösterilerek verinin tazeliği belirtilir
- Stale data göstermek, boş ekran göstermekten her zaman tercih edilir

### 9.2.2. No data durumu

- Cache'te hiç veri yoksa ve ağ da yoksa, anlamlı empty state gösterilir
- "Veri yüklemek için internet bağlantısı gerekiyor" mesajı ile retry butonu
- Retry butonu ağ durumunu kontrol eder; ağ varsa fetch tetikler

### 9.2.3. Kısmi data durumu

- Bazı veriler cache'te mevcut, bazıları değil
- Mevcut veriler gösterilir; eksik alanlar için placeholder veya "yüklenemedi" gösterilir
- Kısmi data, tamamen boş ekrandan her zaman daha iyi UX sunar

## 9.3. Optimistic updates

Offline durumda optimistic update özellikle değerlidir:

- Kullanıcı bir işlem yapar (beğeni, yorum, ayar değişikliği)
- UI anında güncellenir (optimistic)
- Mutation kuyruğa eklenir
- Ağ geldiğinde sunucuya iletilir
- Sunucu onaylarsa hiçbir şey olmaz (UI zaten güncel)
- Sunucu reddederse rollback yapılır ve kullanıcıya bildirilir

Optimistic update kuralları (ADR-005 ile hizalı):

- Basit, düşük riskli işlemler için uygulanır (toggle, beğeni, basit güncelleme)
- Karmaşık, yüksek riskli işlemler için uygulanmaz (ödeme, silme, toplu güncelleme)
- Rollback stratejisi her optimistic update için açık tanımlanır

## 9.4. Sync progress göstergesi

Ağ geri geldiğinde kuyruktaki mutation'lar senkronize edilirken:

- Progress indicator gösterilir: "3 değişiklik senkronize ediliyor..."
- Her başarılı mutation için sayaç güncellenir: "2/3 tamamlandı"
- Tüm senkronizasyon tamamlandığında onay mesajı: "Tüm değişiklikler senkronize edildi"
- Bir mutation başarısız olursa kullanıcıya bildirilir ve manual retry seçeneği sunulur

## 9.5. Conflict notification

Senkronizasyon sırasında conflict tespit edilirse:

- Kullanıcıya anlaşılır mesaj gösterilir: "Bu içerik başka bir cihazdan değiştirilmiş"
- Last-write-wins varsayılanında: "Sizin değişikliğiniz uygulandı" veya "Daha güncel versiyon uygulandı"
- Merge yaklaşımında: her iki versiyon gösterilir ve kullanıcı seçim yapar
- Conflict geçmişi loglanır; observability katmanına raporlanır

---

# 10. Şifreleme Gereksinimleri

Bu bölüm, cihazda saklanan verilerin at-rest encryption stratejisini açıklar. GDPR/KVKK uyumu (ADR-017) ve güvenlik baseline'ı (27-security-and-secrets-baseline) ile hizalıdır.

## 10.1. MMKV encryption nedir?

MMKV, built-in AES-256 şifreleme desteği sunar. Bu şifreleme "at-rest encryption" olarak adlandırılır; yani veri diske yazılırken şifrelenir, okunurken çözülür.

### 10.1.1. AES-256 ne demek?

- Advanced Encryption Standard, 256-bit anahtar uzunluğu
- Askeri seviye şifreleme olarak kabul edilir
- Kaba kuvvet saldırısı ile kırılması pratikte mümkün değildir
- Simetrik şifreleme: aynı anahtar hem şifreleme hem çözme için kullanılır

### 10.1.2. Nasıl etkinleştirilir?

MMKV instance oluşturulurken `encryptionKey` parametresi verilir. Bu key verildiğinde tüm veriler otomatik olarak AES-256 ile şifrelenir.

### 10.1.3. Performans etkisi

Şifreleme/çözme işlemi çok hafif bir overhead ekler (~%5-10 ek süre); ama MMKV zaten o kadar hızlıdır ki bu fark pratikte hissedilmez. Şifreli MMKV hâlâ AsyncStorage'dan yüzlerce kat hızlıdır.

## 10.2. Encryption key yönetimi

Şifreleme anahtarının kendisi güvenli saklanmalıdır. Anahtarı düz metin olarak cihazda saklamak şifrelemeyi anlamsız kılar.

### 10.2.1. iOS: Keychain

- iOS Keychain, donanım destekli güvenli anahtar deposudur
- Encryption key Keychain'de saklanır
- Uygulama kaldırılsa bile Keychain verisi kalabilir (dikkatli cleanup gerekir)
- Expo SecureStore, Keychain'i sarmalar; encryption key için SecureStore kullanılır

### 10.2.2. Android: Keystore

- Android Keystore, donanım destekli güvenli anahtar deposudur (TEE veya StrongBox)
- Encryption key Keystore'da saklanır
- Expo SecureStore, Android Keystore'u sarmalar
- Android 6.0+ gereklidir (bu boilerplate'in minimum hedefi zaten bu üstüdür)

### 10.2.3. Anahtar lifecycle

1. İlk kullanımda rastgele encryption key üretilir
2. Key, SecureStore'a (Keychain/Keystore) yazılır
3. Her MMKV encrypted instance açılışında key SecureStore'dan okunur
4. Key kaybı durumunda (Keychain reset, cihaz sıfırlama) şifreli veri okunamaz; graceful fallback uygulanır (varsayılan değerlere dönüş)

## 10.3. Hangi veriler şifrelenMELİ?

| Veri türü | Şifreleme | Gerekçe |
|-----------|-----------|---------|
| Auth token | SecureStore (keychain/keystore) | En yüksek güvenlik; ADR-010 |
| Biometric key | SecureStore | Hardware-backed |
| Kullanıcı adı, e-posta cache | MMKV encrypted | Kişisel veri; GDPR/KVKK |
| Hassas tercihler (konum izni, bildirim tercihi) | MMKV encrypted | Kullanıcı gizliliği |
| Draft içerik (kişisel notlar, mesaj taslakları) | MMKV encrypted | İçerik gizliliği |
| Tema, dil | MMKV plain | Hassas değil |
| Dismissed banner ID'leri | MMKV plain | Hassas değil |
| TanStack Query generic cache | Şifrelenmemiş | Performans öncelikli; hassas veri sorgu düzeyinde filtrelenir |

## 10.4. SecureStore vs MMKV encrypted farkları

| Kriter | Expo SecureStore | MMKV Encrypted |
|--------|-----------------|----------------|
| Amaç | Yüksek güvenlikli küçük artefact'lar | Orta güvenlikli hızlı persistence |
| Backend | OS Keychain / Keystore | Memory-mapped file + AES-256 |
| Kapasite | ~2KB per item (iOS), platform sınırları | Pratikte sınırsız (disk alanı kadar) |
| Performans | Yavaş (keychain erişimi ~1-5ms) | Çok hızlı (~0.02ms) |
| API | Asenkron | Senkron |
| Kullanım alanı | Token, key, credential | Tercih, profil cache, draft |
| Hardware backing | Evet (Secure Enclave / TEE) | Hayır (software encryption) |
| Cihaz kilidi entegrasyonu | Evet (biometric/PIN gerektirebilir) | Hayır |

Kural: Auth artefact'ları ve kriptografik anahtarlar SecureStore'da, geniş hacimli hassas kullanıcı verisi MMKV encrypted'da yaşar. Bu iki katman birbirini tamamlar, birbirinin yerine geçmez.

## 10.5. Per-user encryption isolation

Birden fazla kullanıcının aynı cihazı kullanabileceği senaryolarda:

- Her kullanıcı için ayrı MMKV instance oluşturulur (`new MMKV({ id: 'user-{userId}' })`)
- Her instance'ın kendi encryption key'i olur
- Kullanıcı değişikliğinde önceki kullanıcının instance'ı unmount edilir
- Logout'ta ilgili kullanıcının MMKV instance'ı ve encryption key'i tamamen silinir
- Bu sayede bir kullanıcının verisi diğer kullanıcı tarafından okunamaz

---

# 11. Storage Katmanları Mimarisi

Bu boilerplate'te local storage dört katmanlı bir mimariyle organize edilir. Her katmanın sorumluluğu, güvenlik seviyesi, lifecycle'ı ve cleanup kuralları nettir.

## 11.1. Katman 1: SecureStore (en yüksek güvenlik)

### 11.1.1. Ne saklar?

- Access token
- Refresh token
- Biometric authentication key
- Encryption key'ler (MMKV encrypted instance'lar için)
- OAuth state/nonce
- Cihaz kayıt token'ı (push notification)

### 11.1.2. Güvenlik seviyesi

- Hardware-backed (iOS Secure Enclave, Android TEE/StrongBox)
- OS-level encryption
- Cihaz kilidi (PIN/biometric) ile korunabilir
- App sandbox dışından erişilemez

### 11.1.3. Lifecycle ve cleanup

- **Login:** Token'lar SecureStore'a yazılır
- **Token refresh:** Eski token silinir, yeni token yazılır
- **Logout:** Tüm SecureStore verileri temizlenir
- **User switch:** Önceki kullanıcının tüm SecureStore verileri silinir, yeni kullanıcınınkiler yazılır
- **App uninstall:** iOS'ta Keychain verisi kalabilir; Android'de silinir. iOS için ilk açılışta stale Keychain kontrolü yapılmalıdır

## 11.2. Katman 2: MMKV Encrypted (orta güvenlik)

### 11.2.1. Ne saklar?

- Kullanıcı profil cache'i (ad, e-posta, avatar URL)
- Hassas kullanıcı tercihleri
- Draft içerikler (kişisel notlar, mesaj taslakları)
- Consent state (GDPR/KVKK onay durumu)
- Son görüntülenen hassas içerik metadata

### 11.2.2. Güvenlik seviyesi

- AES-256 software encryption
- Encryption key SecureStore'da (hardware-backed)
- Memory-mapped file; bellekte şifreli yaşar
- App sandbox dışından okunamaz (şifreli olduğu için root erişiminde bile korumalı)

### 11.2.3. Lifecycle ve cleanup

- **Login:** Kullanıcıya özel encrypted MMKV instance oluşturulur
- **Kullanım:** Veriler otomatik şifrelenerek yazılır/okunur
- **Logout:** Encrypted MMKV instance tamamen silinir; encryption key SecureStore'dan kaldırılır
- **User switch:** Önceki kullanıcının instance'ı silinir; yeni kullanıcı için yeni instance oluşturulur
- **Retention:** Consent state backend'e senkronize edildikten sonra bile local kopyası tutulur (offline erişim için)

## 11.3. Katman 3: MMKV Plain (düşük güvenlik, yüksek performans)

### 11.3.1. Ne saklar?

- Tema tercihi (light/dark/system)
- Dil tercihi (locale)
- Display density
- Sidebar açık/kapalı durumu
- Onboarding tamamlandı flag'i
- Dismissed banner/notice ID'leri
- Son kullanılan workspace/tab seçimi
- UI layout tercihleri

### 11.3.2. Güvenlik seviyesi

- Şifrelenmemiş; düz metin olarak saklanır
- App sandbox koruması var; diğer uygulamalar erişemez
- Ama root/jailbreak erişiminde okunabilir
- Yalnızca hassas olmayan veri için kullanılır

### 11.3.3. Lifecycle ve cleanup

- **İlk açılış:** Varsayılan değerler uygulanır
- **Kullanım:** Tercih değişikliklerinde anında güncellenir
- **Logout:** Kullanıcı-bağımsız tercihler (tema, dil) kalabilir; kullanıcıya özel tercihler temizlenir
- **User switch:** Kullanıcıya özel tercihler yeni kullanıcının verileriyle değiştirilir
- **App uninstall:** Tüm MMKV verileri silinir

## 11.4. Katman 4: TanStack Query Cache (geçici, performans odaklı)

### 11.4.1. Ne saklar?

- API response cache'leri
- Liste verileri
- Detail response'ları
- Pagination state'leri
- Offline mutation kuyruğu

### 11.4.2. Güvenlik seviyesi

- Şifrelenmemiş (varsayılan)
- Query düzeyinde hassas veri filtrelenmeli (response'ta PII varsa cache'lemeden önce maskelenmeli)
- Geçici yapıda; uzun ömürlü olmamalıdır

### 11.4.3. Lifecycle ve cleanup

- **gcTime:** Bağlama göre 5 dakika - 24 saat
- **staleTime:** Bağlama göre 30 saniye - 30 dakika
- **Logout:** Tüm query cache temizlenir (`queryClient.clear()`)
- **User switch:** Tüm query cache temizlenir
- **Offline:** Cache persist edilir; ağ yokken stale data gösterilir
- **Online dönüş:** Stale query'ler otomatik refetch edilir

## 11.5. Katmanlar arası ilişki özeti

```
┌─────────────────────────────────────────────────┐
│  Katman 1: SecureStore                          │
│  ├── Auth token, biometric key                  │
│  ├── Encryption key'ler                         │
│  └── Güvenlik: Hardware-backed, en yüksek       │
├─────────────────────────────────────────────────┤
│  Katman 2: MMKV Encrypted                       │
│  ├── Profil cache, hassas tercihler             │
│  ├── Draft içerikler, consent state             │
│  └── Güvenlik: AES-256, key → SecureStore       │
├─────────────────────────────────────────────────┤
│  Katman 3: MMKV Plain                           │
│  ├── Tema, dil, UI tercihleri                   │
│  ├── Onboarding state, dismissed notices        │
│  └── Güvenlik: App sandbox, şifrelenmemiş       │
├─────────────────────────────────────────────────┤
│  Katman 4: TanStack Query Cache                 │
│  ├── API response'ları, liste verileri          │
│  ├── Offline mutation kuyruğu                   │
│  └── Güvenlik: Geçici, şifrelenmemiş            │
└─────────────────────────────────────────────────┘
```

---

# 12. Platform Farkları

Bu boilerplate cross-platform olduğu için web ve mobile'da storage davranışları farklılık gösterir. Bu farklar bilinçli yönetilmelidir.

## 12.1. Web storage mekanizmaları

### 12.1.1. localStorage

- **Kapasite:** ~5-10MB (tarayıcıya göre değişir)
- **API:** Senkron (`localStorage.getItem`, `localStorage.setItem`)
- **Yapı:** Key-value, yalnızca string
- **Şifreleme:** Yok (tarayıcı sandbox'u ile korunur)
- **Kullanım alanı:** Tema, dil, basit UI tercihleri
- **Zustand entegrasyonu:** Zustand persist middleware'inin varsayılan web storage'ıdır

### 12.1.2. IndexedDB

- **Kapasite:** Çok yüksek (yüzlerce MB, tarayıcıya göre değişir)
- **API:** Asenkron, transaction tabanlı
- **Yapı:** Key-value ve object store; karmaşık sorgular destekler
- **Şifreleme:** Yok (varsayılan; Web Crypto API ile custom şifreleme eklenebilir)
- **Kullanım alanı:** TanStack Query cache persistence, büyük yapısal veriler, offline data store
- **Zustand entegrasyonu:** Custom adapter gerekir

### 12.1.3. HttpOnly Cookie

- **Kullanım alanı:** Auth session (ADR-010 ile hizalı)
- **Avantaj:** JavaScript'ten erişilemez; XSS saldırılarına karşı korumalı
- **Bu ADR'nin kapsamı dışında:** ADR-010 tarafından yönetilir

### 12.1.4. sessionStorage

- **Kullanım alanı:** Tab-scoped geçici veri
- **Ömür:** Tab kapatılınca silinir
- **Bu ADR'nin kapsamı:** Sınırlı; yalnızca tek session'lık geçici state için

## 12.2. Mobile storage mekanizmaları

### 12.2.1. MMKV (canonical)

- Bu ADR'de detaylı açıklanmıştır (Bölüm 6.2)
- Mobile'da varsayılan non-secure persistence

### 12.2.2. Expo SecureStore (canonical güvenli)

- Bu ADR'de detaylı açıklanmıştır (Bölüm 10.4)
- Auth artefact'ları ve encryption key'ler için

### 12.2.3. AsyncStorage (legacy uyumluluk)

- Bu ADR'de detaylı açıklanmıştır (Bölüm 6.1)
- Yalnızca üçüncü parti kütüphane zorunlu kıldığında

### 12.2.4. Dosya sistemi (expo-file-system)

- Büyük dosyalar, medya, export/import verileri için
- Bu ADR'nin ana kapsamı dışında; ama storage mimarisinin bir parçası

## 12.3. Platform-specific storage mapping

| Amaç | Web | Mobile |
|------|-----|--------|
| Auth session | HttpOnly cookie (ADR-010) | SecureStore (ADR-010) |
| Encryption key | N/A (web'de hardware keychain yok) | SecureStore |
| Hassas tercihler | localStorage + dikkat | MMKV encrypted |
| Genel tercihler | localStorage | MMKV plain |
| API cache | IndexedDB | MMKV veya AsyncStorage adapter |
| Offline mutation queue | IndexedDB | MMKV veya AsyncStorage adapter |
| Büyük dosyalar | IndexedDB veya File API | expo-file-system |
| Session-scoped geçici | sessionStorage | Bellekte (persist yok) |

## 12.4. Cross-platform abstraction

Web ve mobile arasında storage farklılıklarını yönetmek için:

- Shared package'larda storage erişimi doğrudan yapılmaz; platform-agnostic storage interface kullanılır
- Storage interface `getItem`, `setItem`, `removeItem`, `clear` metodlarını tanımlar
- Web implementasyonu localStorage/IndexedDB kullanır
- Mobile implementasyonu MMKV kullanır
- Zustand persist middleware bu abstraction üzerinden çalışır
- Feature kodu storage implementasyonunu bilmez; yalnızca interface'i tüketir

---

# 13. Seçilen Karar

Bu boilerplate için canonical local storage ve offline-first stratejisi şu şekilde kabul edilmiştir:

## 13.1. Mobile persistence canonical stack

1. **SecureStore:** Auth artefact'ları ve encryption key'ler (ADR-010)
2. **MMKV encrypted:** Hassas kullanıcı verisi ve tercihleri
3. **MMKV plain:** Genel tercihler ve UI state
4. **AsyncStorage:** Yalnızca üçüncü parti kütüphane uyumluluğu (yeni kod için kullanılmaz)

## 13.2. Web persistence canonical stack

1. **HttpOnly cookie:** Auth session (ADR-010)
2. **localStorage:** Genel tercihler ve Zustand persist
3. **IndexedDB:** API cache persistence ve büyük yapısal veri
4. **sessionStorage:** Tab-scoped geçici veri

## 13.3. Zustand persistence stratejisi

- `zustand/middleware` persist ile kontrollü persistence
- MMKV storage adapter (mobile), localStorage (web)
- `partialize` ile selective persistence zorunlu
- `version` + `migrate` ile migration desteği zorunlu
- `onRehydrateStorage` ile lifecycle yönetimi
- Auth token ve hassas veri persist edilmez

## 13.4. TanStack Query offline stratejisi

- Mutation queue persistence (MMKV adapter)
- `onlineManager` + NetInfo entegrasyonu
- Exponential backoff retry
- Last-write-wins varsayılan conflict resolution
- gcTime ve staleTime offline-aware ayarlanması

## 13.5. Şifreleme stratejisi

- MMKV AES-256 encryption hassas veriler için
- Encryption key SecureStore'da (keychain/keystore)
- Per-user encryption isolation
- Web'de localStorage şifrelenmez; hassas veri web'de dikkatli ele alınır

---

# 14. Neden Bu Karar?

## 14.1. Performans gerçekliği

AsyncStorage'ın 5-10ms read performansı, 10+ store'un rehydrate edildiği bir uygulamada 50-150ms gecikme üretir. MMKV'nin ~0.01ms read performansı bu sorunu tamamen ortadan kaldırır. Kullanıcı uygulama açılışında herhangi bir gecikme hissetmez.

## 14.2. New Architecture uyumu

React Native New Architecture (JSI tabanlı) bridge'i kaldırıyor. MMKV zaten JSI tabanlı olduğu için bu geçişle doğal uyumludur. AsyncStorage bridge tabanlı kalmaya devam eder; gelecekte uyumluluk riski taşır.

## 14.3. Güvenlik katmanlama ihtiyacı

Tek bir storage çözümü her güvenlik seviyesini karşılayamaz. Dört katmanlı mimari her veri türünün doğru güvenlik seviyesinde yaşamasını sağlar. Bu, ADR-010 (auth security) ve ADR-017 (privacy/GDPR) ile hizalıdır.

## 14.4. Offline-first kullanıcı beklentisi

Modern kullanıcılar ağ kesintisinde uygulamanın tamamen çökmesini kabul etmez. Offline mutation queue ve cache persistence sayesinde uygulama kesintisiz deneyim sunar.

## 14.5. Cross-platform tutarlılık

Web ve mobile arasında storage davranışı farklı olsa bile, storage abstraction ile feature kodu platform farkını bilmez. Bu, ADR-004 ve ADR-005 ile uyumlu behavior parity sağlar.

---

# 15. Reddedilen Yönler

## 15.1. AsyncStorage varsayılan persistence olarak reddedilmiştir

- **Neden:** Performans yetersizliği (bridge overhead, async API, JSON serialization)
- **Neden:** New Architecture uyumsuzluğu riski
- **Neden:** Şifreleme desteği yokluğu
- **Neden:** MMKV her açıdan daha güçlü alternatif

## 15.2. SecureStore'un tüm persistence için kullanılması reddedilmiştir

- **Neden:** SecureStore küçük artefact'lar için tasarlanmıştır (~2KB per item limiti)
- **Neden:** Asenkron API; büyük veri setleri için yavaş
- **Neden:** Genel tercihler (tema, dil) için aşırı güvenlik seviyesi; gereksiz maliyet
- **Neden:** Batch işlem desteği zayıf

## 15.3. WatermelonDB / SQLite varsayılan olarak reddedilmiştir

- **Neden:** Bu boilerplate'in offline-first ihtiyacı key-value düzeyindedir; ilişkisel veritabanı karmaşıklığı gereksiz
- **Neden:** Setup ve migration maliyeti yüksek
- **Neden:** Boilerplate düzeyinde aşırı opinionated; derived project gerekirse ayrı karar verir
- **Not:** Gelecekte yoğun offline-first ilişkisel veri ihtiyacı doğarsa ayrı ADR ile değerlendirilebilir

## 15.4. "Her feature kendi storage çözümünü seçsin" yaklaşımı reddedilmiştir

- **Neden:** Tutarsızlık ve bakım kabusu üretir
- **Neden:** Güvenlik standartları parçalanır
- **Neden:** Cleanup ve lifecycle yönetimi imkansızlaşır
- **Neden:** Code review ve audit maliyeti artar

---

# 16. Riskler

## 16.1. MMKV native modül gerektirmesi

MMKV bir native modüldür; Expo Go'da çalışmaz. Bu, geliştirici deneyimini etkileyebilir çünkü Expo Go yerine Expo Dev Client veya prebuild kullanmak gerekir.

## 16.2. Data corruption riski

Memory-mapped I/O sırasında beklenmedik uygulama çökmesi veya cihaz kapanması veri bozulmasına yol açabilir. MMKV'nin dahili CRC checksum mekanizması bu riski azaltır ama tamamen ortadan kaldırmaz.

## 16.3. Encryption key kaybı

SecureStore'da saklanan encryption key'in kaybolması (cihaz sıfırlama, Keychain temizleme) durumunda şifreli MMKV verileri okunamaz. Bu durumda graceful fallback (varsayılan değerlere dönüş) uygulanmalıdır; ama kullanıcı verileri (draft'lar, tercihler) kaybolmuş olur.

## 16.4. Storage quota aşımı

Mobilde MMKV disk alanı kadar büyüyebilir; ama cihaz depolama alanı dolduğunda write işlemleri başarısız olabilir. Web'de localStorage ~5-10MB, IndexedDB daha yüksek ama tarayıcı sınırları mevcuttur.

## 16.5. Migration hataları

Persist edilen veri yapısı değiştiğinde migrate fonksiyonu hatalı çalışırsa veri kaybı oluşabilir. Özellikle birden fazla versiyon atlayan migration'lar (v1 → v4) risklidir.

## 16.6. Wrong-user data leak

Logout veya user switch'te cleanup eksik kalırsa önceki kullanıcının persist edilmiş verisi yeni kullanıcıya görünebilir. Bu ciddi güvenlik ve gizlilik ihlalidir.

## 16.7. Offline mutation kuyruğu büyümesi

Kullanıcı uzun süre offline kalıp çok sayıda mutation biriktirirse kuyruk çok büyüyebilir. Ağ geldiğinde toplu replay sunucu üzerinde yük oluşturabilir.

## 16.8. Conflict resolution karmaşıklığı

Last-write-wins basit ama veri kaybı riski taşır. Merge stratejisi güvenli ama implementasyon karmaşıklığı yüksektir. Yanlış seçim kullanıcı memnuniyetsizliğine yol açar.

---

# 17. Risk Azaltma Önlemleri

1. **Expo Dev Client zorunluluğu:** Boilerplate zaten Expo prebuild modeli kullandığından MMKV uyumludur; geliştirici onboarding dokümanlarında Dev Client kurulumu açıklanır
2. **CRC checksum ve recovery:** MMKV'nin dahili CRC checksum mekanizması etkin tutulur; bozuk veri tespit edildiğinde ilgili instance temizlenir ve varsayılan değerlere dönülür
3. **Encryption key backup stratejisi:** Key kaybı durumunda graceful degradation uygulanır; kullanıcı bilgilendirilir; tercihleri yeniden ayarlaması istenir; backend'de varsa kullanıcı tercihleri sunucudan geri yüklenir
4. **Storage quota monitoring:** Periyodik storage kullanım kontrolü yapılır; %80 eşiğinde uyarı üretilir; eski cache verileri proaktif temizlenir
5. **Migration test zorunluluğu:** Her migration fonksiyonu için birim test yazılması zorunludur; v(n) → v(n+1) ve v(1) → v(n) geçişleri test edilir
6. **Deterministic cleanup:** Logout ve user switch akışlarında tüm storage katmanlarının cleanup'ı tek bir fonksiyonla yönetilir; cleanup fonksiyonu integration test konusudur
7. **Mutation queue limiti:** Offline mutation kuyruğunda maksimum item sayısı belirlenir (varsayılan: 100); limit aşılırsa en eski mutation'lar kullanıcıya bildirilir ve silinir
8. **Conflict resolution politikası:** Varsayılan last-write-wins seçimi ürün bağlamına göre override edilebilir; critical veriler için interactive conflict resolution altyapısı hazır tutulur

---

# 18. Non-Goals

Bu ADR aşağıdakileri çözmez:

- Belirli bir veritabanı (SQLite, WatermelonDB, Realm) seçimi ve implementasyonu
- Dosya sistemi depolama stratejisi (medya, büyük dosyalar)
- Backend sync protokolü ve real-time sync mimarisi
- WebSocket veya Server-Sent Events ile canlı veri senkronizasyonu
- Offline-first uygulama mimarisinin tamamı (bu ADR storage ve mutation queue odaklıdır)
- CRDT (Conflict-free Replicated Data Type) implementasyonu
- Belirli bir TanStack Query cache persister kütüphanesi seçimi (adapter pattern tanımlar; kütüphane seçimi implementation aşamasında yapılır)
- Web crypto API ile client-side encryption detayları
- Push notification ile sync tetikleme mekanizması
- Background fetch/sync scheduling detayları
- Specific query key naming convention'ları (ADR-005 kapsamında)

---

# 19. Sonuç ve Etkiler

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. **MMKV canonical non-secure mobile persistence** olarak kabul edilir; yeni kod MMKV kullanır
2. **AsyncStorage yalnızca legacy uyumluluk** için kabul edilir; yeni feature'larda kullanılmaz
3. **Dört katmanlı storage mimarisi** (SecureStore → MMKV encrypted → MMKV plain → TanStack Query cache) resmi baseline olur
4. **Zustand persist middleware** MMKV adapter ile çalışır; partialize ve migration zorunludur
5. **TanStack Query offline mutation queue** persist edilir; retry ve conflict resolution stratejisi tanımlıdır
6. **Şifreleme** hassas veriler için zorunludur; encryption key SecureStore'da yaşar
7. **Platform abstraction** web ve mobile storage farkını feature kodundan gizler
8. **Cleanup disiplini** (logout, user switch) tüm storage katmanlarını kapsar; deterministic ve test edilmiştir
9. **Offline UX** (banner, optimistic update, sync progress) kullanıcıya kesintisiz deneyim sunar
10. **37-dependency-policy** react-native-mmkv ve @react-native-community/netinfo eklenmesiyle güncellenir
11. **38-version-compatibility-matrix** MMKV ve NetInfo versiyon uyumluluğunu içerecek şekilde güncellenir
12. **20-initial-implementation-checklist** storage katmanı kurulumunu içerecek şekilde güncellenir

---

# 20. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. MMKV'nin canonical non-secure persistence olarak seçim gerekçesi ve kapsamı açıkça yazılmışsa
2. AsyncStorage ile MMKV karşılaştırması performans, mimari ve güvenlik açısından detaylı açıklanmışsa
3. Dört katmanlı storage mimarisi net tanımlanmışsa ve her katmanın sorumluluğu, güvenlik seviyesi ve lifecycle'ı görünürse
4. Zustand + MMKV persistence entegrasyonu (adapter, partialize, migration, hydration) detaylı açıklanmışsa
5. TanStack Query offline mutation queue (persist, retry, conflict resolution, gcTime/staleTime) açıklanmışsa
6. Şifreleme gereksinimleri (MMKV encryption, key yönetimi, hangi veri şifrelenmeli) netse
7. Ağ kesintisi UX stratejisi (offline indicator, stale data, optimistic update, sync progress) tanımlıysa
8. Web ve mobile platform farkları ve cross-platform abstraction açıklanmışsa
9. Riskler (corruption, key kaybı, quota, migration, wrong-user leak) ve risk azaltma önlemleri somutsa
10. Bu karar, implementasyon ekibine storage katmanını ve offline-first davranışı kuracak netlikte baseline sağlıyorsa
