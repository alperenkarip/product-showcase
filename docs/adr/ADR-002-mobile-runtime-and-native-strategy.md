# ADR-002 — Mobile Runtime and Native Strategy

## Doküman Kimliği

- **ADR ID:** ADR-002
- **Başlık:** Mobile Runtime and Native Strategy
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational runtime and platform strategy decision
- **Karar alanı:** Mobile runtime, Expo strategy, native escape hatch policy, mobile application shell baseline
- **İlgili üst belgeler:**
  - `17-technology-decision-framework.md`
  - `36-canonical-stack-decision.md`
  - `06-application-architecture.md`
  - `08-navigation-and-flow-rules.md`
  - `26-platform-adaptation-rules.md`
  - `27-security-and-secrets-baseline.md`
  - `ADR-018-new-architecture-migration-and-readiness-strategy.md`
- **Etkilediği belgeler:**
  - `19-roadmap-to-implementation.md`
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `24-motion-and-interaction-standard.md`
  - `28-observability-and-debugging.md`
  - `35-document-map.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında mobile runtime ve native strategy için aşağıdaki karar kabul edilmiştir:

- **Mobile UI/runtime foundation:** React Native
- **Primary mobile workflow/runtime platform:** Expo
- **Canonical mobile application shell:** Expo tabanlı, provider-composed, navigation-aware, design-system-first React Native shell
- **Native yaklaşım:** Expo-first, native escape hatch allowed but policy-controlled
- **Default native strategy:** Önce Expo uyumlu çözüm aranır, yalnızca gerçek gerekçe varsa native genişleme yapılır
- **Mobile platform hedefi:** iOS ve Android
- **Quality orientation:** iOS tarafında Apple HIG hassasiyeti yüksek; Android tarafında platform saygısı korunur ama ürün dili kopmaz

Bu kararın özü şudur:

> Mobile temel, çıplak React Native veya platforma dağılmış custom native wiring değil; Expo-first, React Native tabanlı, kontrollü native genişlemeye izin veren, documentation-first yönetilen bir foundation olacaktır.

**New Architecture zorunluluğu:** Expo SDK 55 ve React Native 0.82+ ile New Architecture (Fabric renderer + JSI + TurboModules + Hermes V1) artık kapatılamayan varsayılan gerçekliktir. Bu, projeye eklenen her native dependency'nin New Architecture uyumlu olmasını zorunlu kılar. Detaylı strateji ve uyumluluk kontrol süreci ADR-018'de tanımlanmıştır.

---

# 2. Problem Tanımı

Boilerplate için mobile tarafta verilmesi gereken en kritik erken kararlardan biri şudur:

> Mobile uygulamanın runtime ve native entegrasyon stratejisi ne olacak?

Bu karar net verilmezse şu sorunlar oluşur:

- repo topolojisi yanlış kurulur
- tooling ve CI karmaşıklaşır
- dependency seçimleri rastgeleleşir
- native ihtiyaçlar belgesiz ve hacky çözülür
- web-mobile parity belgesel olarak var ama pratikte mobile teknik borç altında ezilir
- design system ve shared logic doğru foundation bulamaz
- mobile build, config ve environment modeli bulanık kalır
- “Expo mu, bare mı?” tartışması her yeni ihtiyaçta tekrar açılır

Bu nedenle mobile runtime kararı boilerplate seviyesinde temel karar alanıdır.

---

# 3. Bağlam

Bu boilerplate’in mobile taraf için taşıdığı temel zorunluluklar şunlardır:

1. Premium hissiyatlı, yüksek kalite UI
2. Apple HIG duyarlılığı
3. Cross-platform davranış uyumu
4. Documentation-first / specification-first ilerleme
5. Design system-first geliştirme
6. Uzun vadeli bakım kolaylığı
7. Test edilebilir ve governance ile denetlenebilir yapı
8. Gerekli olduğunda native sınırları bilinçli açabilme

Bu bağlamda mobile runtime kararı şu dengeyi kurmalıdır:

- aşırı çıplak native/infra yükü getirmemeli
- ama “Expo var, her şeyi onun rahatlığına göre çözelim” seviyesine de düşmemeli
- native genişleme gerektiğinde sistemi bozmadan alan açabilmeli
- UI/interaction kalitesini düşürmeden hız sağlamalı

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle verilmiştir:

1. **Cross-platform React zihinsel modeli ile uyum**
2. **Apple HIG odaklı UI kalitesini destekleme gücü**
3. **Tooling ve DX olgunluğu**
4. **Build/config standardizasyonu**
5. **Native ihtiyaçlara kontrollü genişleme kabiliyeti**
6. **Design system-first yaklaşımı destekleme**
7. **TypeScript ve testing toolchain ile uyum**
8. **Monorepo/workspace modeli ile uyum**
9. **Bakım maliyeti**
10. **Team-level hız vs karmaşıklık dengesi**
11. **Documentation-first karar modeline uygunluk**
12. **Vendor/runtime lock-in riskinin makul oluşu**

---

# 5. Değerlendirilen Alternatifler

Bu karar öncesi ana alternatifler şunlardır:

1. React Native + Expo
2. Bare React Native (başlangıçtan itibaren)
3. Flutter
4. Kotlin Multiplatform + ayrı UI yaklaşımı
5. Web wrapper / hybrid yaklaşımı

Bu boilerplate’in hedefleri açısından en uygun seçimin neden React Native + Expo olduğu aşağıda açıklanmıştır.

---

# 6. Seçilen Karar: React Native + Expo

## 6.1. Neden React Native?

### 6.1.1. Cross-platform zihinsel model uyumu
Web tarafında React seçilmişken mobile tarafta React Native kullanmak:
- component modeli
- state/orchestration yaklaşımı
- shared domain mantığı
- bazı test ve tooling zihinsel modelleri
açısından güçlü uyum sağlar.

### 6.1.2. Gerçek native UI yüzeyi
Bu proje mobile tarafı “web görünümü sarmalayalım” mantığında ele almıyor.  
Gerçek mobil ergonomi, safe area, gesture, sheet, keyboard, native performance ve platform hissi önemlidir.  
React Native bu alanlarda doğru zemini sunar.

### 6.1.3. Design system-first yapı ile uyum
Shared token sistemi, semantic theming, reusable primitives ve cross-platform component family mantığı React Native ile doğal taşınabilir.

### 6.1.4. Ekosistem olgunluğu
React Native:
- geniş ekosistem,
- geniş topluluk,
- güçlü belgelendirme kaynakları,
- production-grade kullanım örnekleri
sunmaktadır.

---

## 6.2. Neden Expo?

Expo seçimi bu boilerplate için “kolay olsun diye” değil, **kontrollü foundation** sağladığı için yapılmıştır.

### 6.2.1. Standardize mobile bootstrap
Expo:
- config
- assets
- build pipeline
- environment wiring
- runtime ergonomisi
alanlarında başlangıç standardizasyonu sağlar.

### 6.2.2. Daha düşük erken bakım maliyeti
Bare RN başlangıçta şu yükleri artırır:
- native proje bakım yüzeyi
- iOS/Android toolchain hassasiyetleri
- config dağınıklığı
- setup/CI karmaşıklığı

Expo-first yaklaşım bu erken yükü azaltır.

### 6.2.3. Documentation-first akışla uyum
Bu boilerplate’in amacı önce foundation’ı sağlam kurmaktır.  
Expo, başlangıç foundation’ını daha öngörülebilir hale getirir ve erken native kaosa sürüklenmeyi azaltır.

### 6.2.4. Geniş production uygunluğu
Expo artık yalnızca prototipleme aracı gibi düşünülmemelidir.  
Doğru kullanıldığında production-grade ürünler için güçlü temeldir.

### 6.2.5. Controlled native expansion imkanı
Expo seçmek native sınırların sonsuza kadar kapalı olduğu anlamına gelmez.  
Doğru yaklaşım:
- varsayılan çözüm Expo-first
- gerçek ihtiyaçta documented native widening

### 6.2.6. Development-build-first çalışma kuralı

Expo ekosisteminde `Expo Go`, öğrenme ve sınırlı sandbox denemeleri için yararlı olabilir; ancak bu boilerplate için **production-grade mobile geliştirme baseline'ı değildir**. Canonical kural:
- günlük geliştirme ve gerçek feature doğrulaması development build üzerinde yapılır,
- native modül, config plugin, linking, push, auth, secure storage ve benzeri kabiliyetler Expo Go varsayımıyla tasarlanmaz,
- “Expo Go'da açılıyor” done kanıtı sayılmaz.

### 6.2.7. Bootstrap doğrulama kapısı

Mobile bootstrap tamamlandı sayılmadan önce şu doğrulamalar zorunludur:

**Temel doğrulamalar:**
- `expo-doctor` temiz geçer (New Architecture uyumsuzluğu dahil),
- development build fiziksel cihaz veya emülatörde açılır,
- config plugin zinciri ve autolinking beklenen paketleri görür,
- appearance/theming zinciri için `userInterfaceStyle: "automatic"` ve gerekli durumda `expo-system-ui` doğrulanır.

**New Architecture doğrulamaları (ADR-018 ile entegre):**
- Fabric renderer aktif olmalı (React DevTools'ta "Fabric: true" görünmeli),
- TurboModules lazy-loading çalışıyor olmalı,
- Hermes V1 aktif olmalı (`global.HermesInternal` mevcudiyeti ile doğrulanabilir),
- Bridge-only dependency kalmamış olmalı,
- New Architecture varsayımıyla çelişen bağımlılık kalmaz.

Bu sinyallerden herhangi biri yoksa mobile foundation hazır sayılmaz.

---

# 7. Neden Bare React Native Varsayılan Seçilmedi?

Bu karar çok kritik olduğu için doğrudan yanıtlanmalıdır.

## 7.1. Bare React Native yetersiz olduğu için değil

Bare RN güçlü olabilir.  
Ama bu boilerplate için varsayılan foundation olarak seçilmemesinin nedeni başka:

> Erken aşamada gereksiz teknik yük ve dağınık native karar yüzeyi üretmesi.

## 7.2. Nedenleri

### 7.2.1. Fazla erken altyapı maliyeti
Boilerplate şu anda şunları çözmek zorunda:
- mimari foundation
- design system
- quality gates
- cross-platform parity
- product shell modeli

Bare RN ise erken şu alanları büyütür:
- pod/gradle/native config
- build pipeline detayları
- platform-specific infra bakımı
- local dev kırılganlığı

### 7.2.2. Documentation-first akışa zarar verme riski
Native setup karmaşıklığı büyüdükçe konuşma mimari ve ürün kalitesinden toolchain söndürmeye kayar.  
Bu, bu projenin öncelikleriyle çelişir.

### 7.2.3. Ekip enerjisinin yanlış yere gitmesi
Boilerplate seviyesinde ilk problem native plumbing olmamalıdır.

## 7.3. Sonuç

Bare React Native reddedilmedi; yalnızca canonical default foundation olarak seçilmedi.

---

# 8. Neden Flutter Seçilmedi?

Bu kararın gerekçesi de açık yazılmalıdır.

## 8.1. Ana neden

Bu boilerplate’in ana omurgası React tabanlı cross-platform aile kurmaktır.  
Flutter seçimi şunları bozar:

- web tarafıyla zihinsel model uyumunu
- shared React/JS/TS toolchain mantığını
- ortak component felsefesini
- mevcut doküman setindeki React-merkezli düşünceyi

## 8.2. İkincil neden

Flutter kendi içinde güçlü olabilir.  
Ama bu proje zaten React + React Native çizgisinde ilerlemektedir.  
Flutter seçimi proje yönünü kökten değiştirir.

---

# 9. Neden Web Wrapper / Hybrid Yaklaşım Seçilmedi?

Bu boilerplate mobile’ı:
- embedded web shell,
- PWA-benzeri mobile shell,
- webview-heavy hybrid yaklaşım
olarak kurgulamaz.

Çünkü hedef:
- gerçek mobil UX,
- native ergonomi,
- kaliteli motion,
- safe area,
- keyboard,
- system integration
alanlarında taviz vermemektir.

Bu nedenle hybrid yaklaşım canonical mobile foundation değildir.

---

# 10. Mobile Application Shell Kararı

## 10.1. Karar

Mobile shell şu ilkelere göre kurulacaktır:

1. **Provider-composed root shell**
2. **Navigation-aware structure**
3. **Design-system-first UI infrastructure**
4. **App-wide concerns centrally wired**
5. **Feature logic shell’e sızmayacak**
6. **Platform-specific runtime wiring shell seviyesinde çözülecek**
7. **Safe area, theme, observability ve auth/session gate’leri root düzeyde ele alınacak**

## 10.2. Mobile shell neleri kapsar?

- app entry
- theme bootstrap
- safe area root composition
- navigation root
- app-level providers
- auth/session gate
- global error boundary
- observability bootstrap
- release/build metadata access
- feature flag / config bootstrap
- app-level permission strategy hooks (gerekli düzeyde)

## 10.3. Mobile shell neleri kapsamaz?

- feature-specific orchestration
- screen-local state
- UI component contract detayları
- domain rule implementation
- ham API çağrıları
- feature-private retry logic

---

# 11. Native Strategy Kararı

## 11.1. Ana ilke

Native strategy şu şekilde tanımlanır:

> **Expo-first, native-escape-hatch-allowed, but policy-controlled.**

Bu tek cümle çok önemlidir.

## 11.2. Ne anlama gelir?

### 11.2.1. Expo-first
Yeni mobile capability ihtiyacı doğduğunda ilk sorulan soru:
“Bunu Expo uyumlu ve mevcut stack ile çözebilir miyiz?”

### 11.2.2. Native escape hatch allowed
Cevap hayırsa, native düzeyde çözüm açmak otomatik olarak yasak değildir.

### 11.2.3. Policy-controlled
Ama bu karar:
- belgesiz,
- rastgele,
- “bu paketi kurdum oldu”
seviyesinde verilmez.

Native genişleme şu sorularla değerlendirilir:
- capability gerçekten gerekli mi?
- Expo uyumlu alternatif var mı?
- platform parity etkisi ne?
- bakım maliyeti ne?
- CI/build etkisi ne?
- güvenlik/performance etkisi ne?
- bu karar ADR gerektiriyor mu?

---

# 12. Native Escape Hatch Nedir?

## 12.1. Tanım

Expo baseline dışında native modül, custom native integration, config plugin, build-time platform özelleştirmesi veya low-level mobile capability gerektiğinde başvurulan kontrollü genişleme kapısıdır.

## 12.2. Ne zaman meşru olur?

Aşağıdaki durumlarda native escape hatch meşru aday olabilir:

- kritik ürün capability’si gerekiyorsa
- gerçek performance gerekçesi varsa
- güvenlik nedeniyle native-level çözüm zorunluysa
- system integration Expo-first çözümlerle yeterli değilse
- UX kalitesi aksi halde ciddi düşecekse

## 12.3. Ne zaman meşru değildir?

- “paket güzel duruyor”
- “native olunca daha havalı”
- “Expo çözümü var ama uğraşmak istemedim”
- “tek bir ekranda işime yaradı”
- “hızlıca geçelim”

---

# 13. Native Escape Hatch İçin Karar Soruları

Bir native widening kararı açılmadan önce en az şu sorular cevaplanmalıdır:

1. Problem tam olarak ne?
2. Expo-first çözüm neden yetmiyor?
3. Bu capability product-critical mi?
4. iOS ve Android etkisi ne?
5. CI/build/release karmaşıklığı ne kadar artıyor?
6. Bakım yükü ne?
7. Güvenlik etkisi ne?
8. Performance gerekçesi ölçülebilir mi?
9. Bu fark behavior parity’yi nasıl etkiliyor?
10. Bu karar ADR gerektiriyor mu?

Bu sorular cevapsızsa native widening erken ve zayıf karardır.

---

# 14. Mobile Navigation Baseline

## 14.1. Karar

Mobile navigation canonical olarak:
- native-feeling stack/tab/sheet modelini destekleyen
- React ekosisteminde olgun
- app shell ile uyumlu
bir runtime üzerinden kurulmalıdır.

Canonical stack decision bunu React Navigation yönünde kilitlemiştir.

## 14.2. Neden?

Çünkü mobile taraf:
- stack progression
- tab structure
- modal/sheet davranışı
- deep link handling
- nested flows
alanlarında güçlü navigation model ister.

## 14.3. Kural

Navigation runtime mobile shell’in parçasıdır.  
Feature logic navigation runtime detayını kendi içine gömmemelidir.

---

# 15. Mobile UI Kalite ve HIG Etkisi

## 15.1. Bu karar neden HIG ile ilişkilidir?

Çünkü mobile runtime seçimi yalnızca teknik karar değildir.  
Apple HIG’ye yakın premium kalite, aşağıdaki şeylerle doğrudan ilişkilidir:

- safe area davranışı
- gesture ve interaction fidelity
- typography rendering
- sheet/modal presentation
- focus/selection/feedback hissi
- motion discipline

Expo-first React Native foundation bu alanlarda güçlü temel sunar.

## 15.2. Kural

Mobile runtime kararı HIG enforcement stratejisinden bağımsız yorumlanamaz.

---

# 16. Mobile Styling ve Design System Üzerindeki Etki

Bu karar şu sonuçları doğurur:

1. mobile styling layer React Native uyumlu çalışmalıdır
2. semantic token consumption mobile-first düşünülmelidir
3. NativeWind uyumlu design token stratejisi kurulmalıdır
4. raw StyleSheet veya ad-hoc styling birikimi governance konusu olacaktır
5. component contracts mobile ergonomisine göre test edilmelidir

---

# 17. Mobile Runtime Kararının State ve Data Katmanına Etkisi

Bu ADR doğrudan state tool kararını vermez; ama şunu garanti eder:

- mobile taraf web ile ortak state/domain mantığını taşıyabilecek
- query/cache layer ile doğal çalışabilecek
- form runtime ile uyumlu
- feature orchestration’ı platform-specific native plumbing’e boğmayacak
bir foundation kurulacaktır.

Bu, Zustand + TanStack Query + RHF + Zod zincirinin mobile’da doğal çalışabilmesi için kritiktir.

---

# 18. Build, CI ve Release Üzerindeki Etki

## 18.1. Sonuçlar

Bu karar aşağıdaki CI/build etkilerini doğurur:

- Expo uyumlu build/release pipeline kurulmalıdır
- mobile shell sanity kontrolleri resmi kalite konusu olur
- native widening kararları CI ve release etkisiyle birlikte değerlendirilir
- config ve environment ayrımı mobile build süreciyle senkron kurulmalıdır

## 18.2. Kural

Expo-first kararına rağmen “build zaten sonra çözülür” yaklaşımı kabul edilmez.  
Mobile runtime kararı build/release disiplininin resmi parçasıdır.

---

# 19. Testing Üzerindeki Etki

Bu karar test stratejisinde şu sonuçları doğurur:

1. React Native uyumlu component/integration testing yaklaşımı gerekir
2. navigation-aware mobile flow testleri gerekecektir
3. safe area, keyboard, sheet/modal behavior alanları manual audit konusu olacaktır
4. mobile E2E tool kararı ayrı ADR ile kapatılacaktır
5. Expo-first foundation, mobile test stratejisinin ergonomisini etkiler

---

# 20. Security Üzerindeki Etki

Bu karar şu güvenlik etkilerini doğurur:

- secure storage seçimleri Expo uyumlu güvenli katmanla düşünülmelidir
- auth/session state sıradan persistence gibi ele alınmamalıdır
- native capability açma kararları güvenlik değerlendirmesi ile birlikte verilmelidir
- mobile debug yüzeyleri prod’a sızmamalıdır

Bu nedenle `27-security-and-secrets-baseline.md` ile bu ADR birlikte yorumlanmalıdır.

---

# 21. Güçlü Yanlar

Bu kararın ana avantajları şunlardır:

1. Mobile foundation erken dağılmaz
2. React tabanlı cross-platform düşünce korunur
3. DS-first ve HIG odaklı kalite zemini güçlenir
4. Native yük gereksiz yere erkenden büyümez
5. Tooling ve build standardizasyonu artar
6. Documentation-first ilerleme desteklenir
7. Controlled native expansion imkanı korunur

---

# 22. Riskler

Dürüst olmak gerekir. Bu kararın riskleri de vardır.

## 22.1. Expo bazı edge-case native ihtiyaçlarda sınır yaratabilir
Bu gerçek bir risktir.  
Ama bu risk native escape hatch policy ile yönetilir.

## 22.2. “Expo-first” yanlış anlaşılırsa ekipte rehavet oluşabilir
Yani insanlar şunu düşünebilir:
“Nasıl olsa Expo var, detayları sonra çözeriz.”

Bu yanlış yorumdur.  
Bu risk, contribution ve governance belgeleriyle kapatılmalıdır.

## 22.3. Native widening geç yapılırsa bazı kararlar pahalılaşabilir
Bu yüzden gerçek native ihtiyaçlar erken dürüstçe işaretlenmelidir.

## 22.4. Android ve iOS parity’si yanlış yorumlanabilir
Özellikle iOS HIG hassasiyeti yüksekken Android tarafı “ikinci sınıf” bırakılmamalıdır.

---

# 23. Risk Azaltma Önlemleri

Bu kararın risklerini azaltmak için şu önlemler gerekir:

1. Native widening için ADR zorunluluğu
2. Expo-first çözüm araştırma kuralı
3. Secure storage ve system integration için ayrı policy
4. Mobile HIG enforcement ve audit süreçleri
5. Repo structure içinde mobile adapters / app shell ayrımının net kurulması
6. Build/release sanity’nin erken kurulması
7. Mobile test strategy’nin Expo gerçekliği ile hizalanması

---

# 24. Non-Goals

Bu ADR aşağıdakileri çözmez:

- belirli her native modülün seçimi
- mobile E2E exact tool lock
- auth backend provider seçimi
- OTA policy detayları
- analytics vendor seçimi
- tüm device capability matrix’i
- New Architecture’ın tam paket uyumluluk stratejisi, migration detayları ve risk yönetimi (bu konular ADR-018’de tanımlanmıştır)

Bunlar sonraki ADR ve policy belgelerinde kapanmalıdır.

---

# 25. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. `apps/mobile` Expo-first React Native app olarak tasarlanır
2. Mobile shell provider-composed root olarak kurulur
3. Native widening kararları belgesiz verilemez
4. Shared package mimarisi mobile runtime ile uyumlu kurgulanır
5. Secure storage ve system capability decisions Expo reality ile birlikte değerlendirilir
6. Mobile foundation için bare RN varsayılan kabul edilmez

---

# 26. Reddedilen Alternatiflerin Kısa Özeti

## 26.1. Bare React Native as default
Reddedildi çünkü:
- erken bakım maliyeti yüksektir
- foundation aşamasında yanlış odak yaratır

## 26.2. Flutter
Reddedildi çünkü:
- React temelli cross-platform zihinsel modeli kırar
- mevcut belge seti ve canonical stack ile uyumsuzdur

## 26.3. Hybrid/web-wrapper mobile
Reddedildi çünkü:
- gerçek mobile UX hedefiyle uyumsuzdur
- native ergonomiyi zayıflatır

---

# 27. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki tür koşullarda bu ADR yeniden değerlendirilebilir:

- Expo-first yapı product-critical native ihtiyaçları sistematik olarak engelliyorsa
- maintenance yükü beklentilerin tersine aşırı artıyorsa
- mobile ürün hedefi native-heavy platform feature setine doğru kayıyorsa
- React Native + Expo kombinasyonu uzun vadeli ürün kalitesini taşımakta yetersiz kalıyorsa

Bu seviyedeki değişiklik major karar değişimidir ve yeni ADR + versioning etkisi gerektirir.

---

# 28. Kararın Kısa Hükmü

> Mobile runtime ve native strategy için canonical karar: React Native + Expo tabanlı, Expo-first ama native escape hatch’e policy-controlled biçimde izin veren, design-system-first, navigation-aware, provider-composed mobile application shell modelidir. Bare React Native varsayılan foundation olarak seçilmemiştir.

---

# 29. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Mobile runtime seçimi açıkça yazılmışsa
2. Expo-first strateji net tanımlanmışsa
3. Native escape hatch policy açıklanmışsa
4. Neden bare RN ve diğer alternatiflerin seçilmediği net gerekçelendirilmişse
5. Mobile shell etkisi ve quality/HIG bağlantısı görünür kılınmışsa
6. CI, build, testing ve security etkileri işaretlenmişse
7. Bu karar implementasyon öncesi kilitlenmiş baseline olarak kullanılabilecek netlikteyse

---

# 29.1. New Architecture Zorunluluğu ve Etkileri (2026-04 Güncellemesi)

## 29.1.1. New Architecture Artık Kapatılamaz

Expo SDK 55 ve React Native 0.82+ ile birlikte New Architecture (Fabric renderer + JSI + TurboModules + Hermes V1) artık opsiyonel bir özellik değil, kapatılamayan varsayılan gerçekliktir. Bu, ADR-002'nin "baseline" tanımını doğrudan etkiler:

- **Fabric renderer** artık tek ve varsayılan render motorudur. Eski UIManager kaldırılmıştır.
- **JSI (JavaScript Interface)** eski JSON-tabanlı bridge'in yerini almıştır. Native modüllerle iletişim artık C++ seviyesinde doğrudan obje erişimi ile sağlanır.
- **TurboModules** eski NativeModules'ın yerini almıştır. Native modüller lazy-loaded olarak yüklenir ve Codegen ile compile-time tip güvenliği sağlar.
- **Hermes V1** zorunlu ve varsayılan JavaScript engine'dir. V8 veya JavaScriptCore seçeneği yoktur.

Bu durum şu sonuçları doğurur:

1. app.json veya app.config.js'te `newArchEnabled: false` artık geçersizdir; bu ayar yok sayılır.
2. Tüm third-party native modüllerin New Architecture uyumlu olması gerekir.
3. `setNativeProps` ve `findNodeHandle` gibi eski API'ler kaldırılmıştır; bunları kullanan kod çalışmaz.
4. Bridge-only paketler (npm ekosisteminin yaklaşık %15'i) doğrudan kullanılamaz; uyumlu alternatif aranmalı veya sarmalayıcı (wrapper) yazılmalıdır.

## 29.1.2. Hermes V1 Zorunluluğu

Hermes V1, React Native 0.83+ ve Expo SDK 55+ ile zorunlu JavaScript engine'dir. Bu karar şu gerekçelere dayanır:

- **Bytecode precompilation:** JavaScript kaynak kodu derleme zamanında (build time) bytecode'a çevrilir. Bu sayede uygulama açılışında kaynak kod parse etme ve derleme adımı atlanır ve cold start süresi dramatik biçimde kısalır (benchmark'larda %30-43 iyileşme gözlemlenmiştir).
- **Daha düşük bellek tüketimi:** Hermes, V8 ve JSC'ye göre daha az RAM kullanır. Bu özellikle düşük ve orta segment cihazlarda kritiktir.
- **Geliştirilmiş garbage collection:** Hermes V1'in garbage collector'ı daha verimli çalışır ve GC pause'ları kısadır, bu da UI thread'inin daha az etkilenmesi anlamına gelir.
- **Expo ve React Native ekosistemiyle tam uyum:** Hermes, Meta ve Expo tarafından birincil engine olarak geliştirilmektedir.

## 29.1.3. Paket Uyumluluk Değerlendirme Zorunluluğu

Bootstrap öncesinde ve her yeni native dependency eklendiğinde şu doğrulama adımları zorunludur:

1. Paketin New Architecture uyumluluğunu kontrol et (reactnativepackagedb.com veya paket README/changelog)
2. Paketin Fabric renderer ile çalıştığını doğrula
3. Paketin JSI tabanlı veya TurboModule uyumlu olduğunu doğrula
4. Bridge-only paket tespit edilirse: uyumlu alternatif araştır, bulunamazsa wrapper yazımını veya fork'u değerlendir
5. expo-doctor raporunda ilgili paket uyarı vermemeli

Bu doğrulama süreci dependency policy (37) ve compatibility matrix (38) ile entegre çalışır. Detaylı strateji ADR-018'de tanımlanmıştır.

## 29.1.4. Bootstrap Doğrulama Kapısı Güncelleme

Bölüm 6.2.7'deki bootstrap doğrulama kapısına ek olarak, New Architecture bağlamında şu kontroller de zorunludur:

- `expo-doctor` New Architecture uyumsuzluğu bildirmemeli
- Development build'de Fabric renderer aktif olmalı (React DevTools'ta "Fabric: true" görünmeli)
- TurboModules lazy-loading çalışıyor olmalı
- Hermes V1 aktif olmalı (`global.HermesInternal` mevcudiyeti ile doğrulanabilir)
- Bridge-only dependency kalmamış olmalı

---

# 30. Expo UI (@expo/ui) Watchlist Pozisyonu

## 30.1. Durum

@expo/ui paketi şu anda **Watchlist** statüsündedir. Stable 1.0 release beklenmektedir. Canonical stack’e alınması için aşağıdaki koşulların karşılanması gerekir.

## 30.2. Ne Sağlar?

@expo/ui, SwiftUI (iOS) ve Jetpack Compose (Android) bileşenlerinin React Native içinden doğrudan kullanılmasını sağlayan bir köprü katmanıdır. Bu, platform-native UX kalitesini gerektiren belirli bileşenler için özellikle değerlidir:

- **DatePicker / TimePicker:** Platform-native tarih/saat seçici, her platformun kendi UX convention’ına uygun
- **SegmentedControl:** iOS’ta UISegmentedControl, Android’de MaterialSegmentedButton doğrudan kullanımı
- **ContextMenu:** iOS’ta native context menu (long press), Android’de popup menu
- **Picker / Wheel:** Platform-native döndürme ve seçim bileşenleri
- **SearchBar:** Platform-native arama çubuğu entegrasyonu

## 30.3. Canonical Olma Koşulları

@expo/ui’ın canonical stack’e alınabilmesi için şu koşulların tümü karşılanmalıdır:

1. **Stable API:** 1.0 veya üzeri stable release yayınlanmış olmalı; breaking change riski düşük olmalı
2. **NativeWind uyumu:** @expo/ui bileşenleri NativeWind (ADR-007) ile birlikte sorunsuz çalışabilmeli; token consumption desteği olmalı
3. **Design system entegrasyonu:** Mevcut design token katmanı ile uyumlu theming ve styling mümkün olmalı
4. **Expo SDK uyumu:** Canonical Expo SDK 55.x ile tam uyumlu olmalı
5. **New Architecture desteği:** Fabric renderer ve JSI ile tam uyumlu olmalı (ADR-018)
6. **Community adoption:** Yeterli npm downloads, GitHub stars ve production kullanımı gözlemlenmiş olmalı
7. **Test edilebilirlik:** Testing Library veya benzeri araçlarla test yazılabilir olmalı

## 30.4. Riskler

- **Platform-specific API yüzeyi artışı:** @expo/ui bileşenleri platforma özgü prop’lar ve davranışlar getirebilir; cross-platform tutarlılık kaybı riski
- **Design system kontrolü:** Platform-native bileşenler kendi görsel dilini taşır; boilerplate’in token-first yaklaşımı ile çelişebilir
- **Test karmaşıklığı:** Native bileşenlerin unit/integration testleri daha karmaşık olabilir
- **NativeWind çakışması:** Styling katmanında NativeWind ile @expo/ui’ın kendi styling mekanizması çakışabilir

## 30.5. Karar

@expo/ui stable release sonrası ADR-002 addendum olarak değerlendirilecektir. Değerlendirme sırasında yukarıdaki koşullar tek tek doğrulanacak ve pilot olarak 1-2 bileşen (ör. DatePicker, SegmentedControl) ile deneme yapılacaktır.

---

# 31. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Mobile taraf, erken native karmaşıklığa boğulmayan ama gerektiğinde native capability açabilen; React tabanlı cross-platform zihinsel modeli koruyan; HIG ve premium mobile UX hedeflerini taşıyabilen bir foundation üzerinde kurulacaktır. Bu foundation, React Native + Expo tabanlı, Expo-first ve policy-controlled native expansion modelidir.
