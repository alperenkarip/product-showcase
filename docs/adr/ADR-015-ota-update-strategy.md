# ADR-015 — OTA Update Strategy

## Doküman Kimliği

- **ADR ID:** ADR-015
- **Başlık:** OTA Update Strategy
- **Durum:** Accepted
- **Tarih:** 2026-04-01
- **Karar türü:** Foundational runtime, mobile update delivery, deployment ve rollback kararı
- **Karar alanı:** Over-the-air JavaScript bundle güncellemesi, update channel yönetimi, staged rollout, rollback stratejisi, crash monitoring entegrasyonu, kullanıcı bildirimi ve update lifecycle
- **İlgili üst belgeler:**
  - `ADR-002-mobile-runtime-and-native-strategy.md`
  - `ADR-009-observability-stack.md`
  - `29-release-and-versioning-rules.md`
  - `15-quality-gates-and-ci-rules.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `29-release-and-versioning-rules.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`

---

# 1. Karar Özeti

Bu ADR ile aşağıdaki karar kabul edilmiştir:

- **Canonical OTA update platformu:** EAS Update (Expo Application Services)
- **Update kapsamı:** Yalnızca JavaScript bundle ve asset güncellemeleri; native code değişiklikleri store submission gerektirir
- **Channel yönetimi:** Production, staging ve preview olmak üzere üç canonical update channel tanımlanır
- **Staged rollout:** Kanarya deployment stratejisi ile kademeli güncelleme dağıtımı zorunludur
- **Rollback:** Hatalı güncelleme tespit edildiğinde önceki kararlı sürüme anında geri dönüş mekanizması zorunludur
- **Crash monitoring:** OTA update sonrası crash rate artışı ADR-009 observability kapsamında izlenir ve otomatik rollback tetikleyebilir
- **Kullanıcı bildirimi:** Update hazır olduğunda kullanıcıya bilgi verilir; zorunlu ve opsiyonel güncelleme ayrımı yapılır

Bu ADR'nin ana hükmü şudur:

> OTA update bu boilerplate'te kontrolsüz deployment aracı değildir. EAS Update canonical platform olarak kabul edilmiştir; update channel'lar katmanlı yönetilir, staged rollout zorunludur, rollback mekanizması baştan kurulur ve crash monitoring ile entegre çalışır.

---

# 2. Problem Tanımı

OTA update kararı verilmezse aşağıdaki sorunlar kaçınılmazdır:

- Her küçük JS değişikliği için store submission yapılır; deployment hızı düşer
- Kritik bug fix'ler saatler yerine günler sürer; Apple review süreci darboğaz yaratır
- Update channel yapısı kurulmaz; staging ve production güncellemeleri karışır
- Staged rollout yapılmaz; hatalı güncelleme tüm kullanıcı tabanına anında yayılır
- Rollback mekanizması olmaz; hatalı update sonrası tek çare yeni store submission'dır
- Crash monitoring ile update ilişkilendirilmez; hangi güncellemenin crash artışına neden olduğu tespit edilemez
- Native ve JS update ayrımı yapılmaz; native değişiklik içeren güncelleme OTA ile gönderilmeye çalışılır ve crash'e neden olur

---

# 3. Bağlam

Bu boilerplate'in OTA update açısından taşıdığı zorunluluklar şunlardır:

1. **Expo-first runtime:** ADR-002 ile kilitlenmiş Expo SDK 55.x; OTA update çözümü Expo ekosistemi ile uyumlu olmalı
2. **Hızlı deployment ihtiyacı:** JS bundle değişiklikleri store review sürecinden bağımsız olarak kullanıcılara ulaşabilmeli
3. **Güvenli dağıtım:** Hatalı güncelleme riski staged rollout ve rollback ile minimize edilmeli
4. **Observability entegrasyonu:** ADR-009 kapsamında update sonrası crash ve performans metrikleri izlenebilmeli
5. **Release stratejisi uyumu:** 29-release-and-versioning-rules ile hizalı update lifecycle
6. **Kalite kapıları:** 15-quality-gates ile entegre update onay süreci
7. **Cross-platform:** iOS ve Android için tutarlı OTA update deneyimi

---

# 4. Karar Kriterleri

1. **Expo SDK uyumu ve managed workflow desteği**
2. **JS bundle ve asset güncelleme kapasitesi**
3. **Native vs JS update ayrımı yönetimi**
4. **Channel yönetimi (production, staging, preview)**
5. **Staged rollout (kanarya deployment) desteği**
6. **Rollback mekanizması ve hızı**
7. **Crash monitoring entegrasyonu**
8. **Global CDN ve delivery performansı**
9. **Update lifecycle ve kullanıcı bildirimi**
10. **Vendor lock-in riski ve exit stratejisi**
11. **Maliyet modeli ve ölçeklenebilirlik**
12. **Güvenlik (update signing, integrity doğrulama)**

---

# 5. Değerlendirilen Alternatifler

## 5.1. EAS Update

- Expo ekosisteminin birinci sınıf OTA update servisi
- Expo Updates protocol (açık standart) üzerine inşa edilmiş
- Managed ve bare workflow desteği
- Channel yönetimi, staged rollout, rollback kutudan gelir
- Global CDN ve HTTP/3 desteği
- Code signing ile update integrity doğrulaması
- Expo SDK ile doğal entegrasyon

## 5.2. CodePush (AppCenter)

- Microsoft AppCenter Mart 2025'te emekli edilmiştir
- CodePush servisi artık aktif değildir
- Migration zorunlu

## 5.3. Bitrise CodePush (CodePush fork)

- AppCenter CodePush'un community fork'u
- Uzun vadeli bakım garantisi belirsiz
- Expo managed workflow desteği sınırlı
- SDK entegrasyonu ek native modül gerektirir

## 5.4. Self-hosted (Expo Updates protocol)

- Expo Updates protocol açık standarttır; kendi sunucunuzda host edilebilir
- Maksimum kontrol, vendor bağımsızlık
- Altyapı yönetimi, CDN, monitoring tamamen kendi sorumluluğunuz
- Staged rollout ve analytics sıfırdan inşa edilmeli
- Operasyonel maliyet yüksek

## 5.5. AppZung

- CodePush alternatifi olarak konumlanan yeni servis
- Community küçük, production track record yetersiz
- Expo entegrasyonu resmi değil
- Uzun vadeli sürdürülebilirlik riski yüksek

---

# 6. Seçilen Karar

Bu boilerplate için canonical OTA update kararı şu şekilde kabul edilmiştir:

## 6.1. Canonical platform

EAS Update bu boilerplate'in OTA update platformudur.

## 6.2. JS bundle vs native code ayrımı

- **OTA ile güncellenebilir:** JavaScript kodu, TypeScript kodu, JSON konfigürasyon, resim ve font asset'leri
- **OTA ile güncellenemez:** Native modüller, Expo config plugin'leri, native dependency güncellemeleri, Expo SDK major versiyon değişiklikleri
- **Kural:** Her update öncesinde native değişiklik içerip içermediği kontrol edilir. Native değişiklik varsa store submission zorunludur; OTA gönderilmez
- **Runtime version:** `runtimeVersion` politikası native değişiklikleri takip eder; JS update yalnızca uyumlu runtime version'a teslim edilir

## 6.3. Update channel yönetimi

### 6.3.1. Production channel

- Gerçek kullanıcılara ulaşan güncellemeler bu kanaldan dağıtılır
- Staged rollout zorunludur
- Rollback mekanizması aktiftir

### 6.3.2. Staging channel

- QA ve iç test ekibinin kullandığı kanal
- Production öncesi doğrulama yapılır
- Tüm quality gate'ler bu kanalda kontrol edilir

### 6.3.3. Preview channel

- Geliştirme ve PR review amaçlı kanal
- Feature branch güncellemeleri bu kanala yayınlanabilir
- EAS Update preview ile PR bazlı test desteklenir

## 6.4. Staged rollout

- Güncelleme ilk olarak kullanıcı tabanının küçük bir yüzdesine (%5-10) dağıtılır
- Crash rate ve ANR (Application Not Responding) metrikleri izlenir
- Belirli süre (ör. 2-4 saat) sorunsuz geçerse dağıtım oranı kademeli artırılır
- Threshold aşılırsa rollout durdurulur ve rollback tetiklenir
- Kanarya grubu seçimi deterministik olur (device ID hash tabanlı); aynı cihaz tutarlı olarak aynı gruba düşer

## 6.5. Rollback stratejisi

- Hatalı güncelleme tespit edildiğinde önceki kararlı update anında yeniden aktif edilir
- Rollback işlemi EAS Update dashboard veya CLI üzerinden saniyeler içinde gerçekleştirilebilir
- Otomatik rollback: Crash rate belirli threshold'u aşarsa rollback otomatik tetiklenir (ADR-009 entegrasyonu)
- Rollback sonrası incident raporu oluşturulur

## 6.6. Crash monitoring entegrasyonu

- Her OTA update bir benzersiz update ID taşır
- Sentry (ADR-009) ile update ID ilişkilendirilir; crash'ler hangi update'e ait olduğuna göre gruplanır
- Update sonrası crash rate baseline'la karşılaştırılır
- Anormal artış tespit edildiğinde alert tetiklenir
- Rollback kararı bu metriklere dayanır

## 6.7. Update lifecycle ve kullanıcı bildirimi

### 6.7.1. Background update (varsayılan)

- Güncelleme arka planda indirilir
- Uygulama bir sonraki açılışta yeni bundle'ı yükler
- Kullanıcı herhangi bir şey yapmak zorunda değildir

### 6.7.2. Opsiyonel güncelleme bildirimi

- Güncelleme hazır olduğunda kullanıcıya "Yeni sürüm hazır, yeniden başlatmak ister misiniz?" bildirimi gösterilebilir
- Kullanıcı erteleyebilir; sonraki açılışta otomatik uygulanır

### 6.7.3. Zorunlu güncelleme

- Kritik güvenlik güncellemelerinde güncelleme zorunlu tutulabilir
- Kullanıcı güncellemeden uygulamayı kullanamaz
- Bu mod yalnızca güvenlik ve veri bütünlüğü gerektiren durumlarda kullanılır

## 6.8. Update güvenliği

- EAS Update code signing ile update integrity doğrulaması yapar
- Update payload'ları transit ve rest durumunda şifreli taşınır
- Manipüle edilmiş update runtime tarafından reddedilir

---

# 7. Neden Bu Karar?

## 7.1. Expo ekosistemi ile doğal uyum

EAS Update, Expo SDK'nın birinci sınıf OTA update servisidir. `expo-updates` modülü ile doğrudan entegre çalışır. Ek native modül veya custom bridge gerektirmez.

## 7.2. Açık standart üzerine inşa

Expo Updates protocol açık bir standarttır. EAS Update bu protokolün managed implementation'ıdır ama protokol kendisi vendor-bağımsızdır; gerektiğinde self-hosted sunucuya geçiş mümkündür.

## 7.3. Staged rollout ve rollback kutudan gelir

EAS Update channel yönetimi, kademeli dağıtım ve anında rollback yeteneklerini kutudan sunar. Bu özellikler sıfırdan inşa edilmek zorunda değildir.

## 7.4. Global CDN ve performans

EAS Update global CDN üzerinden dağıtım yapar. HTTP/3 desteği ile düşük latency ve yüksek throughput sağlar.

## 7.5. Code signing

Update integrity code signing ile doğrulanır. Man-in-the-middle veya supply chain saldırılarına karşı koruma sağlar.

## 7.6. CodePush alternatifi yoktur

AppCenter CodePush emekli olmuştur. Expo ekosistemi içinde EAS Update tek üretim kalitesinde alternatiftir.

---

# 8. Reddedilen Yönler

## 8.1. CodePush (AppCenter) reddedilmiştir

- **Neden:** Microsoft AppCenter Mart 2025'te emekli edilmiştir. CodePush servisi artık aktif değildir. Yeni projelerde kullanılamaz.

## 8.2. Bitrise CodePush reddedilmiştir

- **Neden:** AppCenter CodePush'un community fork'udur. Uzun vadeli bakım garantisi yoktur. Expo managed workflow desteği sınırlıdır. Ek native modül gerektirir; ADR-002 Expo-first ilkesiyle çelişir.

## 8.3. Self-hosted çözüm reddedilmiştir

- **Neden:** Operasyonel maliyet çok yüksektir. CDN, monitoring, staged rollout ve analytics sıfırdan inşa edilmelidir. Boilerplate kapsamında bu altyapı yükü kabul edilemez. Expo Updates protocol açık olduğu için gelecekte geçiş mümkündür ama canonical başlangıç noktası EAS Update'tir.

## 8.4. AppZung reddedilmiştir

- **Neden:** Yeni servis, production track record yetersizdir. Community küçük, Expo entegrasyonu resmi değildir. Uzun vadeli sürdürülebilirlik riski boilerplate için kabul edilemez.

---

# 9. Riskler

## 9.1. EAS Update servis bağımlılığı

EAS Update Expo'nun managed servisidir. Servis kesintisi OTA update dağıtımını engeller.

## 9.2. Native ve JS update ayrımı hatası

Runtime version yanlış yönetilirse JS update native uyumsuzluk nedeniyle crash'e neden olabilir.

## 9.3. Staged rollout kanarya grubunun temsil gücü

Küçük kanarya grubu tüm kullanıcı tabanını temsil etmeyebilir; bazı cihaz-spesifik sorunlar kanarya aşamasında tespit edilemeyebilir.

## 9.4. Zorunlu güncelleme kötüye kullanımı

Zorunlu güncelleme sık kullanılırsa kullanıcı deneyimi bozulur; uygulama her açılışta güncelleme bekler.

## 9.5. Update boyutu

Büyük asset değişiklikleri OTA update boyutunu artırır; düşük bant genişliğinde kullanıcı deneyimi kötüleşir.

---

# 10. Risk Azaltma Önlemleri

1. **Expo Updates protocol exit stratejisi:** Protokol açık standart olduğu için EAS Update'ten çıkış gerekirse self-hosted sunucuya migration mümkündür
2. **Runtime version otomasyonu:** Native değişiklik tespit eden CI kontrolü kurulur; native değişiklik içeren commit'ler otomatik olarak yeni runtime version oluşturur
3. **Kanarya grubu çeşitliliği:** Kanarya grubuna farklı cihaz modelleri ve OS versiyonları dahil edilir; device diversity metrikleri izlenir
4. **Zorunlu güncelleme politikası:** Zorunlu güncelleme yalnızca güvenlik ve veri bütünlüğü gerektiren durumlarda kullanılır; kullanım onay gerektirir
5. **Update boyutu kontrolü:** Asset değişiklikleri diff-based dağıtılır; büyük binary asset'ler mümkünse CDN referansı ile yönetilir
6. **Crash monitoring entegrasyonu:** Her update Sentry release ile ilişkilendirilir; crash rate threshold aşılırsa otomatik alert ve rollback tetiklenir
7. **CI/CD entegrasyonu:** Update yayınlama CI pipeline'ına entegre edilir; manuel yayınlama yasaktır

---

# 11. Non-Goals

Bu ADR aşağıdakileri çözmez:

- Native modül güncelleme stratejisi (store submission workflow)
- App Store ve Google Play review süreci optimizasyonu
- Feature flag yönetimi ve remote config
- A/B test altyapısı
- Backend deployment stratejisi
- Web uygulaması deployment stratejisi
- Expo SDK major versiyon upgrade prosedürü

---

# 12. Sonuç ve Etkiler

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. EAS Update canonical OTA update platformu olarak dependency policy'ye (37) ve compatibility matrix'e (38) eklenir
2. Üç update channel (production, staging, preview) tanımlanır ve CI/CD pipeline'a entegre edilir
3. Staged rollout kanarya deployment stratejisi tüm production güncellemelerinde zorunlu tutulur
4. Rollback mekanizması baştan kurulur; otomatik rollback threshold'ları tanımlanır
5. Her OTA update Sentry release ile ilişkilendirilir; crash monitoring entegrasyonu zorunludur
6. Native vs JS update ayrımı runtime version politikası ile yönetilir; CI kontrolü eklenir
7. Zorunlu güncelleme kullanım politikası tanımlanır ve onay gerektirir
8. Release ve versioning kuralları (29) OTA update lifecycle ile hizalanır
9. Quality gate'ler (15) staging channel'da OTA update onayını kapsar
10. Contribution guide ve audit checklist OTA update maddelerini içerir

---

# 13. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Canonical platform seçimi (EAS Update) ve gerekçesi açıkça yazılmışsa
2. JS bundle vs native code ayrımı ve runtime version politikası net tanımlanmışsa
3. Update channel yapısı (production, staging, preview) detaylı açıklanmışsa
4. Staged rollout stratejisi ve kanarya deployment kuralları belirtilmişse
5. Rollback mekanizması ve otomatik rollback koşulları tanımlanmışsa
6. Crash monitoring entegrasyonu ADR-009 ile bağlantılı olarak açıklanmışsa
7. Update lifecycle ve kullanıcı bildirimi (background, opsiyonel, zorunlu) tanımlanmışsa
8. Update güvenliği (code signing, integrity) belirtilmişse
9. Alternatifler ve ret gerekçeleri dürüstçe sunulmuşsa
10. Riskler ve risk azaltma önlemleri somutsa
11. Bu karar, implementation ekibine OTA update altyapısını kuracak netlikte baseline sağlıyorsa

---

# 14. Hermes Bytecode Diffing ile OTA Boyut Optimizasyonu

SDK 55'in diff bazlı OTA güncelleme mekanizması ve Hermes V1 bytecode avantajı.

## 14.1. Hermes V1 Bytecode Precompilation

Hermes V1 (ADR-018) JavaScript kaynak kodunu build aşamasında bytecode'a derler. Bu, OTA update için şu avantajı sağlar:

- **Daha küçük OTA bundle:** Bytecode formatı, minified JavaScript'ten daha kompakt olabilir ve diff mekanizması ile birleştiğinde dramatik boyut küçülmesi sağlar
- **Daha hızlı parse:** Kullanıcı cihazında JS parse adımı atlanır; bytecode doğrudan yürütülür

## 14.2. EAS Update Diff Mekanizması

EAS Update her güncellemede tam bundle göndermez. Bunun yerine önceki sürüm ile yeni sürüm arasındaki farkı (diff) hesaplar ve yalnızca değişen kısımları gönderir:

- **Tam bundle boyutu:** Tipik bir uygulama için 5-15MB
- **Diff boyutu:** Küçük-orta değişiklikler için 200KB-2MB
- **Bandwidth tasarrufu:** %70-95 arası tasarruf (değişiklik büyüklüğüne göre)

## 14.3. Kullanıcı Etkisi

- **İndirme süresi:** Tam bundle 3G'de 10-30 saniye → diff ile 1-5 saniye
- **Veri kullanımı:** Özellikle sınırlı data planı olan kullanıcılar için kritik
- **Background download:** Diff küçük olduğu için background'da fark edilmeden indirilebilir

## 14.4. Koşul ve Sınırlamalar

- **Yalnızca JavaScript değişiklikleri:** Native kod değişikliği (yeni native modül, Expo config plugin değişikliği) OTA ile gönderilemez; full binary store submission gerekir
- **Asset değişiklikleri:** Yeni resim, font veya media dosyası eklendiğinde diff büyüyebilir; asset değişiklikleri dikkatli yönetilmelidir
- **İlk yükleme:** Uygulamanın ilk kurulumunda diff mekanizması çalışmaz; embedded bundle kullanılır

## 14.5. Monitoring

EAS Update dashboard'dan aşağıdaki metrikler izlenir:
- **İndirme boyutu:** Her update'in ortalama indirme boyutu
- **Başarı oranı:** Update indirme ve uygulama başarı yüzdesi
- **İndirme süresi:** Ortalama indirme süresi (ms)
- **Rollback oranı:** Otomatik rollback tetiklenme yüzdesi

---

# 15. OTA Update Rollback Mekanizması

Bozuk OTA güncellemesinin tespit edilmesi ve güvenli geri dönüş stratejisi.

## 15.1. Otomatik Crash Tespiti

Uygulama **3 ardışık crash** yaparsa (app launch → crash döngüsü) mevcut OTA bozuk kabul edilir:
- React Native'in `ErrorUtils` veya Expo'nun error recovery mekanizması crash sayısını takip eder
- Her başarılı app launch'ta crash counter sıfırlanır
- 3. crash sonrasında rollback otomatik tetiklenir

## 15.2. Rollback Mekanizması

Otomatik rollback şu adımlarla gerçekleşir:
1. Crash threshold aşıldığında mevcut OTA bundle devre dışı bırakılır
2. Bir önceki bilinen kararlı sürüme (embedded bundle veya önceki başarılı OTA) geri dönülür
3. Uygulama kararlı sürümle yeniden başlatılır
4. Kullanıcıya bilgilendirilir: "Güncelleme geri alındı, önceki sürüme dönüldü" (non-blocking toast veya banner)

## 15.3. Sentry Entegrasyonu

OTA rollback event'i Sentry'ye raporlanır (ADR-009 uyumu):
- Event tipi: `ota_rollback`
- Payload: `update_id`, `previous_update_id`, `crash_count`, `rollback_reason`
- Bu event critical severity ile raporlanır ve anında alert tetikler
- Rollback sonrası crash rate izlenir; kararlı sürümde crash devam ediyorsa underlying bug araştırılır

## 15.4. Canary Deployment

Yeni OTA güncellemesi tüm kullanıcı tabanına birden yayılmaz:
1. **%5 rollout:** İlk aşamada güncelleme yalnızca %5 kullanıcıya dağıtılır
2. **Crash rate kontrolü:** 1-4 saat boyunca crash rate izlenir
3. **Eşik değer:** Crash rate %2'yi aşarsa rollout durdurulur ve güncelleme geri çekilir
4. **Kademeli genişleme:** Crash rate normal ise %25 → %50 → %100 kademeli genişleme
5. **Tam rollout:** Tüm aşamalar temiz geçerse 24-48 saat içinde %100 rollout tamamlanır

## 15.5. Kill Switch

EAS Update dashboard'dan bozuk güncelleme anında devre dışı bırakılabilir:
- Dashboard'da ilgili update seçilir ve "Rollback" aksiyonu tetiklenir
- Tüm kullanıcılar bir sonraki app launch'ta önceki kararlı sürüme döner
- Kill switch kullanımı Sentry alert ve Slack/email bildirim ile desteklenir

## 15.6. Recovery Süreci

Rollback sonrası fix süreci:
1. Bozuk update'in crash logları Sentry'den analiz edilir
2. Root cause tespit edilir ve düzeltme yapılır
3. Düzeltme staging channel'da test edilir
4. Yeni update canary deployment ile kademeli dağıtılır

---

# 16. Hermes Bytecode Diffing ve Bandwidth Optimizasyonu

Bu bölüm, Expo SDK 55 ve Hermes V1 ile kullanılabilen bytecode diffing mekanizmasının OTA update stratejisi üzerindeki etkisini tanımlar.

## 16.1. Hermes Bytecode Diffing Nedir?

Geleneksel OTA güncellemelerinde, JavaScript bundle'ının tamamı (veya büyük bölümü) yeniden indirilir. Hermes bytecode diffing, bunun yerine yalnızca değişen bytecode segmentlerini göndererek güncelleme boyutunu dramatik şekilde düşürür.

### Çalışma Prensibi

1. **Build zamanı:** JavaScript kaynak kodu Hermes tarafından bytecode'a derlenir
2. **Diff hesaplama:** EAS Update, önceki ve yeni bytecode arasındaki farkı (binary diff) hesaplar
3. **İndirme:** Cihaz yalnızca diff paketini indirir (tam bundle yerine)
4. **Uygulama:** Cihazda mevcut bytecode üzerine diff uygulanarak yeni versiyon oluşturulur

### Beklenen Kazanımlar

| Senaryo | Tam Bundle | Bytecode Diff | Tasarruf |
|---------|-----------|---------------|----------|
| Küçük bug fix (birkaç satır) | ~2-5 MB | ~50-200 KB | %90-95 |
| Orta feature ekleme | ~2-5 MB | ~200-800 KB | %60-85 |
| Büyük refactoring | ~2-5 MB | ~1-3 MB | %20-40 |

## 16.2. EAS Update Entegrasyonu

- Bytecode diffing EAS Update tarafından otomatik uygulanır; ek konfigürasyon gerekmez
- `expo-updates` SDK'sı diff indirme ve uygulama mekanizmasını yönetir
- Diff oluşturulamıyorsa (ör: ilk kurulum, runtimeVersion değişikliği) tam bundle indirilir

## 16.3. runtimeVersion Politikası ile İlişki

- **runtimeVersion değişmezse:** Bytecode diff uygulanabilir; OTA güncelleme sorunsuzdur
- **runtimeVersion değişirse:** Diff hesaplanamaz; tam bundle + native rebuild gerekir
- **Kural:** runtimeVersion değişikliği yalnızca native code değişikliğinde yapılır. JavaScript-only değişiklikler runtimeVersion'ı etkilememelidir

## 16.4. Monitoring ve Doğrulama

- EAS Update dashboard'unda diff boyutu vs tam bundle boyutu karşılaştırması izlenir
- Diff uygulama başarı oranı izlenir (başarısız diff → tam bundle fallback)
- Sentry'de OTA update sonrası crash rate izlenir (diff bozulması riski)
