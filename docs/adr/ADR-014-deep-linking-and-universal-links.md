# ADR-014 — Deep Linking and Universal Links

## Doküman Kimliği

- **ADR ID:** ADR-014
- **Başlık:** Deep Linking and Universal Links
- **Durum:** Accepted
- **Tarih:** 2026-04-01
- **Karar türü:** Foundational runtime, cross-platform navigation, deep link routing ve verified link kararı
- **Karar alanı:** iOS Universal Links, Android App Links, URI scheme, deep link routing, deferred deep linking, attribution entegrasyonu, push notification ile deep link bütünlüğü
- **İlgili üst belgeler:**
  - `ADR-002-mobile-runtime-and-native-strategy.md`
  - `ADR-012-navigation-baseline.md`
  - `ADR-013-push-notification-strategy.md`
  - `08-navigation-and-flow-rules.md`
  - `26-platform-adaptation-rules.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`

---

# 1. Karar Özeti

Bu ADR ile aşağıdaki karar kabul edilmiştir:

- **Canonical deep link SDK:** `expo-linking` (Expo SDK entegrasyonu ve cross-platform URL handling uyumu nedeniyle)
- **Verified link stratejisi:** iOS Universal Links ve Android App Links platform-native verified link mekanizmaları kullanılır
- **URI scheme:** Custom URI scheme yalnızca development ve fallback senaryolarında kullanılır; production'da verified domain linking tercih edilir
- **Routing bütünlüğü:** Mobile'da React Navigation deep link config, web'de React Router URL routing ile hizalı tek routing tablosu
- **Deferred deep linking:** App yüklü olmadığında store yönlendirme ve yükleme sonrası hedef ekrana routing desteklenir
- **Push entegrasyonu:** Notification payload'ından gelen deep link'ler aynı routing mekanizmasından geçer (ADR-013 ile hizalı)
- **Attribution:** Lightweight attribution ihtiyaçları desteklenir; ağır vendor bağımlılığı reddedilmiştir

Bu ADR'nin ana hükmü şudur:

> Deep linking bu boilerplate'te ad hoc URL handling ile çözülen bir sorun değildir. `expo-linking` canonical SDK'dır; verified domain link'ler üretim standardıdır. Routing tablosu tek kaynaktan yönetilir, push notification ve external link'ler aynı deterministik routing pipeline'ından geçer.

---

# 2. Problem Tanımı

Deep linking kararı verilmezse aşağıdaki sorunlar kaçınılmazdır:

- URI scheme ve verified link ayrımı yapılmaz; güvenlik açıkları oluşur (URI scheme hijacking)
- Web ve mobile routing tabloları ayrışır; aynı URL farklı ekranlara yönlendirir
- Push notification tıklanması ve external link açılması farklı mekanizmalarla ele alınır; tutarsız davranış ortaya çıkar
- Deferred deep linking desteklenmez; yeni kullanıcı yükleme sonrası anasayfaya düşer
- Deep link → auth gate → hedef ekran zinciri düşünülmez; kullanıcı giriş sonrası yanlış ekrana yönlendirilir
- Attribution ve kampanya takibi baştan planlanmaz; sonradan entegrasyon maliyetli olur
- Platform-specific konfigürasyon dosyaları (apple-app-site-association, assetlinks.json) ihmal edilir

---

# 3. Bağlam

Bu boilerplate'in deep linking açısından taşıdığı zorunluluklar şunlardır:

1. **Cross-platform yapı:** Aynı deep link hem web hem mobile'da tutarlı davranmalı
2. **Expo-first runtime:** ADR-002 ile kilitlenmiş Expo SDK 55.x; deep link SDK'sı Expo uyumlu olmalı
3. **Navigation stack uyumu:** ADR-012 ile kilitlenmiş React Navigation 7.x (mobile) ve React Router 7.x (web) ile entegre çalışmalı
4. **Push notification bütünlüğü:** ADR-013 kapsamında push tıklanması deep link routing'den geçmeli
5. **Auth gate uyumu:** ADR-010 kapsamında auth durumuna göre deep link routing kararları verilmeli
6. **Güvenlik:** Verified link mekanizmaları URI scheme hijacking riskini ortadan kaldırmalı
7. **Store guideline uyumu:** Apple ve Google'ın verified link gereksinimleri karşılanmalı

---

# 4. Karar Kriterleri

1. **Expo SDK uyumu ve managed workflow desteği**
2. **iOS Universal Links ve Android App Links native desteği**
3. **React Navigation ve React Router ile entegrasyon kalitesi**
4. **Deferred deep linking desteği**
5. **Push notification routing ile bütünlük**
6. **URI scheme ve verified link ayrımı yönetimi**
7. **Auth gate ile deep link koordinasyonu**
8. **Attribution ve kampanya takibi esnekliği**
9. **Vendor lock-in riski**
10. **Bakım maliyeti ve community desteği**
11. **Güvenlik ve hijacking koruması**
12. **Web ve mobile routing parity'si**

---

# 5. Değerlendirilen Alternatifler

## 5.1. expo-linking + platform-native verified links

- Expo SDK ile doğal entegrasyon
- URL parsing, scheme handling ve verified link konfigürasyonu
- React Navigation linking config ile sorunsuz çalışır
- Lightweight, vendor bağımsız
- Deferred deep linking ek implementation gerektirir

## 5.2. Branch.io

- Full-stack deep linking ve attribution platformu
- Deferred deep linking kutudan gelir
- Dashboard, analytics ve kampanya yönetimi
- Ağır vendor lock-in
- SDK boyutu büyük
- Expo entegrasyonu mümkün ama ek native modül gerektirir
- Maliyet ölçekte artış gösterir

## 5.3. Adjust

- Attribution-first platform
- Deep linking yan özellik
- Expo resmi entegrasyonu sınırlı
- Ağırlıklı olarak reklam attribution odaklı

## 5.4. Firebase Dynamic Links

- Google tarafından deprecated edilmiştir (Eylül 2025 sonlandırma)
- Yeni projelerde kullanılamaz
- Migration zorunluluğu riski

## 5.5. Custom implementation (sıfırdan)

- Maksimum kontrol
- Her platform için ayrı native konfigürasyon ve URL handling
- React Navigation linking config manuel yazılmalı
- Bakım maliyeti çok yüksek
- Deferred deep linking tamamen sıfırdan geliştirilmeli

---

# 6. Seçilen Karar

Bu boilerplate için canonical deep linking kararı şu şekilde kabul edilmiştir:

## 6.1. Canonical SDK

`expo-linking` bu boilerplate'in deep link SDK'sıdır.

## 6.2. Verified link stratejisi

### 6.2.1. iOS Universal Links

- `.well-known/apple-app-site-association` (AASA) dosyası web sunucusunda host edilir
- AASA dosyası `applinks` service tanımlar; team ID ve bundle ID eşleşmesi zorunlu
- HTTPS zorunlu; HTTP fallback kabul edilmez
- AASA dosyası CDN cache policy'si ile yönetilir

### 6.2.2. Android App Links

- `.well-known/assetlinks.json` dosyası web sunucusunda host edilir
- `autoVerify: true` intent filter tanımlanır
- SHA-256 certificate fingerprint doğrulaması zorunlu
- HTTPS zorunlu

### 6.2.3. URI scheme

- Custom URI scheme (`myapp://`) yalnızca development ortamında ve verified link başarısız olduğunda fallback olarak kullanılır
- Production'da verified domain linking canonical tercih olarak kalır
- URI scheme hijacking riski nedeniyle hassas işlemler (auth callback, ödeme onayı) URI scheme ile tetiklenmez

## 6.3. Routing tablosu

- **Tek kaynak ilkesi:** Deep link URL pattern'leri ile ekran eşleşmeleri tek bir routing konfigürasyon dosyasında tanımlanır
- **Mobile:** React Navigation `linking` config üzerinden deep link → screen mapping yapılır
- **Web:** React Router route tanımları aynı URL pattern'leriyle hizalı tutulur
- **Parametre parsing:** URL parametreleri (path params, query params) type-safe şekilde parse edilir
- **Wildcard ve fallback:** Tanımlanmamış deep link'ler için fallback ekran (ana sayfa veya 404) belirlenir

## 6.4. Auth gate koordinasyonu

- Deep link hedefi auth-gated ekransa, kullanıcı önce login ekranına yönlendirilir
- Login başarılı olduktan sonra orijinal deep link hedefine redirect yapılır (pending deep link pattern)
- Pending deep link state session süresi boyunca korunur; session expiry'de temizlenir

## 6.5. Deferred deep linking

- Uygulama yüklü değilse kullanıcı store'a yönlendirilir
- Yükleme ve ilk açılış sonrası orijinal deep link hedefine routing yapılır
- Deferred deep link bilgisi platform clipboard API veya referrer mekanizması ile taşınır
- Bu özellik opsiyoneldir; boilerplate temel mekanizmayı sağlar, ürün ihtiyacına göre aktive edilir

## 6.6. Smart link stratejisi

- Paylaşılan link'ler web fallback URL taşır; uygulama yüklü değilse web versiyonuna düşer
- `<meta>` tag ve redirect mekanizması ile app yüklü kontrolü yapılır
- Platform detect: iOS → Universal Link, Android → App Link, diğer → web URL

## 6.7. Attribution ve kampanya takibi

- Deep link URL'lerine UTM parametreleri eklenir (utm_source, utm_medium, utm_campaign)
- UTM parametreleri analytics event'lerine propagate edilir (ADR-009 uyumlu)
- Ağır attribution vendor'ı (Branch, Adjust) canonical değildir; lightweight UTM-based attribution yeterlidir
- İleride ağır attribution ihtiyacı doğarsa ayrı ADR gerektirir

---

# 7. Neden Bu Karar?

## 7.1. Expo ekosistemi ile doğal uyum

`expo-linking` Expo SDK'nın birinci sınıf modülüdür. URL parsing, scheme handling ve platform-native link konfigürasyonu Expo managed workflow ile sorunsuz çalışır.

## 7.2. React Navigation ile entegrasyon

`expo-linking` React Navigation 7.x `linking` config ile doğrudan entegre olur. Deep link → screen mapping deklaratif olarak tanımlanır, custom URL parsing kodu yazılmaz.

## 7.3. Vendor lock-in yok

Platform-native verified link mekanizmaları (Universal Links, App Links) açık standartlardır. Backend veya attribution vendor değişikliği client SDK'yı etkilemez.

## 7.4. Güvenlik

Verified domain linking, URI scheme hijacking riskini ortadan kaldırır. Domain ownership doğrulaması platform seviyesinde yapılır.

## 7.5. Lightweight

Ağır attribution SDK'ları (Branch, Adjust) uygulamaya büyük dependency ve privacy riski ekler. UTM-based lightweight attribution boilerplate ihtiyaçlarını karşılar.

---

# 8. Reddedilen Yönler

## 8.1. Branch.io reddedilmiştir

- **Neden:** Ağır vendor lock-in. SDK boyutu büyük, privacy manifest gereksinimleri karmaşık. Tüm deep link routing vendor dashboard'una bağımlı hale gelir. Boilerplate seviyesinde kabul edilemez bağımlılık.
- **Ek risk:** Branch SDK veri toplama politikası GDPR/KVKK uyum yükünü artırır.

## 8.2. Adjust reddedilmiştir

- **Neden:** Attribution-first platform; deep linking yan özelliktir. Expo resmi entegrasyonu sınırlıdır. Reklam attribution odaklı yapısı boilerplate ihtiyaçlarını aşar.

## 8.3. Firebase Dynamic Links reddedilmiştir

- **Neden:** Google tarafından deprecated edilmiştir. Yeni projelerde kullanılamaz. Migration riski taşır.

## 8.4. Custom implementation reddedilmiştir

- **Neden:** Expo managed workflow ile uyumsuzluk riski. Her platform için ayrı native konfigürasyon, URL handling ve deferred deep linking sıfırdan yazılmalıdır. Bakım maliyeti boilerplate kapsamında kabul edilemez.

---

# 9. Riskler

## 9.1. Verified link konfigürasyon hatası

AASA veya assetlinks.json dosyalarındaki hata verified link'lerin çalışmamasına neden olur. Platform doğrulaması başarısız olursa URI scheme fallback'e düşer.

## 9.2. Deferred deep linking güvenilirliği

Platform clipboard ve referrer mekanizmaları %100 güvenilir değildir. Bazı senaryolarda deferred deep link bilgisi kaybolabilir.

## 9.3. Auth gate + deep link race condition

Deep link ile gelen kullanıcı auth gate'e takılırsa, pending deep link state yönetimi karmaşıklaşabilir. Session restore sırasında timing sorunları oluşabilir.

## 9.4. Routing tablosu tutarsızlığı

Web ve mobile routing tabloları ayrışırsa aynı URL farklı davranış gösterir. Tek kaynak ilkesi ihlal edilirse tutarsızlık kaçınılmazdır.

## 9.5. URL pattern güvenliği

Kötü niyetli deep link URL'leri ile injection veya phishing saldırısı riski vardır. URL parametreleri sanitize edilmezse güvenlik açığı oluşur.

---

# 10. Risk Azaltma Önlemleri

1. **Verified link doğrulama testi:** AASA ve assetlinks.json dosyaları CI pipeline'ında doğrulanır; Apple ve Google validator araçları kullanılır
2. **Deferred deep link fallback:** Deferred deep link bilgisi alınamazsa kullanıcı anasayfaya yönlendirilir; hata sessizce yutulmaz, analytics event loglanır
3. **Pending deep link timeout:** Auth gate sonrası pending deep link belirli süre (ör. 5 dakika) içinde kullanılmazsa temizlenir
4. **Routing tablosu test:** Web ve mobile routing tabloları arasındaki parity otomatik test ile doğrulanır
5. **URL sanitization:** Deep link parametreleri input validation ve sanitization'dan geçer; raw URL değerleri doğrudan navigation parametresi olarak kullanılmaz
6. **Monitoring:** Deep link başarı/başarısızlık oranları ADR-009 observability kapsamında izlenir

---

# 11. Non-Goals

Bu ADR aşağıdakileri çözmez:

- Ağır attribution platform seçimi (Branch, Adjust, AppsFlyer gibi)
- Reklam kampanya yönetimi ve conversion tracking
- QR code generation ve scanning stratejisi
- App Clip (iOS) ve Instant App (Android) stratejisi
- Social media preview (Open Graph) optimizasyonu
- Backend URL shortener servisi seçimi
- SEO ve crawlability stratejisi

---

# 12. Sonuç ve Etkiler

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. `expo-linking` canonical deep link SDK'sı olarak dependency policy'ye (37) ve compatibility matrix'e (38) eklenir
2. iOS Universal Links ve Android App Links konfigürasyon dosyaları repo'da tutulur ve CI'da doğrulanır
3. Routing tablosu tek kaynak ilkesiyle yönetilir; web ve mobile arasında parity zorunlu tutulur
4. Custom URI scheme yalnızca development ve fallback senaryolarıyla sınırlandırılır
5. Auth gate + deep link koordinasyonu pending deep link pattern ile çözülür
6. Push notification tıklanması aynı deep link routing pipeline'ından geçer (ADR-013 uyumu)
7. UTM-based lightweight attribution canonical olur; ağır vendor attribution ayrı ADR gerektirir
8. Deep link URL parametreleri sanitization zorunluluğu güvenlik baseline'a eklenir
9. Contribution guide ve audit checklist deep linking maddelerini içerir
10. Verified link konfigürasyonu deployment checklist'e eklenir

---

# 13. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Canonical SDK seçimi (`expo-linking`) ve gerekçesi açıkça yazılmışsa
2. Verified link stratejisi (Universal Links, App Links) detaylı tanımlanmışsa
3. URI scheme kullanım sınırları net belirtilmişse
4. Routing tablosu tek kaynak ilkesi ve web/mobile parity kuralı açıklanmışsa
5. Auth gate + deep link koordinasyonu tanımlanmışsa
6. Deferred deep linking stratejisi belirtilmişse
7. Push notification entegrasyonu ADR-013 ile bağlantılıysa
8. Attribution yaklaşımı (lightweight UTM vs ağır vendor) gerekçesiyle yazılmışsa
9. Alternatifler ve ret gerekçeleri dürüstçe sunulmuşsa
10. Riskler ve risk azaltma önlemleri somutsa
11. Bu karar, implementation ekibine deep link altyapısını kuracak netlikte baseline sağlıyorsa

---

# 14. Deep Link Debug Tooling Cheat Sheet

Development ortamında deep link test komutları ve kullanım rehberi.

## 14.1. iOS Simulator

```bash
# Custom URI scheme test
xcrun simctl openurl booted "myapp://profile/123"

# Universal Links test
xcrun simctl openurl booted "https://example.com/profile/123"

# Expo development client
npx uri-scheme open "myapp://profile/123" --ios
```

- `booted` parametresi halihazırda çalışan simulator'ı hedefler
- Universal Links test için `apple-app-site-association` dosyasının doğru configure edilmiş olması gerekir
- Simulator'da Universal Links çalışmazsa: Settings → Developer → Associated Domains Development bölümünü kontrol edin

## 14.2. Android Emulator

```bash
# Custom URI scheme test
adb shell am start -a android.intent.action.VIEW -d "myapp://profile/123"

# App Links test (verified domain)
adb shell am start -a android.intent.action.VIEW -d "https://example.com/profile/123"

# Expo development client
npx uri-scheme open "myapp://profile/123" --android
```

- `adb shell am start` ile intent gönderilir; uygulama çalışmıyorsa başlatılır
- App Links test için `assetlinks.json` dosyasının doğru sunulması gerekir
- Doğrulama durumu kontrolü: `adb shell pm get-app-links <package-name>`

## 14.3. Expo CLI

```bash
# iOS ve Android için platform-agnostic test
npx uri-scheme open "myapp://profile/123" --ios
npx uri-scheme open "myapp://profile/123" --android

# Development server üzerinden test
npx expo start --dev-client
# Ardından terminal'de URL yapıştırılarak test edilir
```

## 14.4. Link Doğrulama Araçları

```bash
# Apple AASA (Apple App Site Association) doğrulama
curl -v "https://example.com/.well-known/apple-app-site-association"
# JSON formatında ve doğru team ID ile app ID içermeli

# Google Assetlinks doğrulama
curl -v "https://example.com/.well-known/assetlinks.json"
# JSON formatında ve doğru package name + SHA-256 fingerprint içermeli

# Google Digital Asset Links tester
# https://developers.google.com/digital-asset-links/tools/generator
```

## 14.5. Debug Sıralaması

Deep link çalışmadığında aşağıdaki sırayla kontrol edilir:
1. URL format doğru mu? (scheme, host, path)
2. Uygulama doğru scheme/domain için register edilmiş mi? (app.json/app.config.js)
3. AASA/assetlinks.json dosyaları sunucuda mevcut ve doğru mu?
4. React Navigation linking config'de path tanımlı mı?
5. Auth gate deep link'i engelliyor mu?
6. Development build mi yoksa Expo Go mu? (Expo Go'da custom scheme çalışmayabilir)

---

# 15. Deferred Deep Link Stratejisi

Uygulama yüklü değilken gelen deep link'lerin yükleme sonrası hedef ekrana yönlendirmesi.

## 15.1. Senaryo

1. Kullanıcı bir link'e tıklar (ör. `https://example.com/product/456`)
2. Uygulama yüklü değildir → App Store / Play Store'a yönlendirilir
3. Kullanıcı uygulamayı yükler ve ilk kez açar
4. Uygulama açıldığında orijinal deep link hedefine (`/product/456`) götürülür

## 15.2. Implementasyon Seçenekleri

### Seçenek 1: Backend Referral Tracking (Önerilen)

- Web'de tıklanan link backend'e referral olarak kaydedilir (ör. `?ref=abc123` parametresi ile)
- Uygulama yüklendikten sonra ilk açılışta kullanıcı auth sonrası backend'den referral bilgisi alınır
- Backend referral'ı deep link hedefine çevirir ve client'a döner
- **Avantaj:** Güvenli, privacy-friendly, platform bağımsız
- **Dezavantaj:** Backend geliştirme gerektirir

### Seçenek 2: Clipboard-Based (Privacy Concern)

- Web sayfası tıklanan URL'yi clipboard'a kopyalar
- Uygulama ilk açılışta clipboard'dan URL kontrol eder
- **iOS 16+:** Clipboard erişiminde kullanıcıya izin sorar (UIPasteboard privacy prompt)
- **Avantaj:** Backend gerektirmez
- **Dezavantaj:** Kullanıcı deneyimi zayıf, privacy concern, iOS clipboard permission prompt

### Seçenek 3: Third-Party Attribution Service

- Branch.io, AppsFlyer gibi attribution servisleri deferred deep link desteği sunar
- **Avantaj:** Kapsamlı attribution, cross-platform
- **Dezavantaj:** Vendor lock-in, maliyet, SDK ekleme yükü, privacy concern
- **Not:** Firebase Dynamic Links deprecated edilmiştir (Ağustos 2025 sonrası yeni link oluşturulamaz)

## 15.3. Boilerplate Pozisyonu

Deferred deep link **derived project kararıdır**. Bu boilerplate temel deep link altyapısını sağlar (URI scheme + verified links + routing). Deferred deep link ihtiyacı derived project'te kesinleştiğinde yukarıdaki seçeneklerden biri uygulanır.

## 15.4. Fallback Davranışı

Deferred deep link çözülemezse (referral bulunamazsa, timeout yaşanırsa):
- Kullanıcı **onboarding flow'a** veya **home screen'e** yönlendirilir
- Error gösterilmez; kullanıcı normal akıştan devam eder
- Analytics'e `deferred_deep_link_fallback` event'i loglanır
