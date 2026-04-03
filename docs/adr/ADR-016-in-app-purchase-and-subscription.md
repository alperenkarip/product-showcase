# ADR-016 — In-App Purchase and Subscription Strategy

## Doküman Kimliği

- **ADR ID:** ADR-016
- **Başlık:** In-App Purchase and Subscription Strategy
- **Durum:** Accepted
- **Tarih:** 2026-04-01
- **Karar türü:** Foundational runtime, cross-platform monetizasyon, subscription lifecycle ve entitlement yönetimi kararı
- **Karar alanı:** In-app purchase altyapısı, subscription lifecycle, entitlement yönetimi, receipt validation, cross-platform sync, store guideline uyumu, pricing stratejisi ve sandbox test ortamı
- **İlgili üst belgeler:**
  - `ADR-002-mobile-runtime-and-native-strategy.md`
  - `ADR-009-observability-stack.md`
  - `ADR-010-auth-session-and-secure-storage-baseline.md`
  - `27-security-and-secrets-baseline.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`
  - `39-default-screens-and-components-spec.md`

---

# 1. Karar Özeti

Bu ADR ile aşağıdaki karar kabul edilmiştir:

- **Canonical IAP SDK:** RevenueCat (`react-native-purchases`) — cross-platform entitlement yönetimi, receipt validation ve subscription lifecycle için
- **Satın alma türleri:** Consumable, non-consumable ve subscription türleri desteklenir
- **Receipt validation:** Server-side validation zorunludur; client-side validation güvenlik açısından yeterli değildir
- **Cross-platform sync:** Mobil store billing (App Store, Google Play) ve web Stripe entegrasyonu aynı entitlement sistemi üzerinden yönetilir
- **Entitlement yönetimi:** Feature erişimi entitlement tabanlıdır; doğrudan ürün ID kontrolü yasaktır
- **Store guideline uyumu:** Apple App Store ve Google Play Store kurallarına tam uyum zorunludur
- **Sandbox test:** Store sandbox ortamları ve RevenueCat sandbox modu aktif kullanılır

Bu ADR'nin ana hükmü şudur:

> In-app purchase ve subscription bu boilerplate'te doğrudan store API'larıyla baş başa bırakılan bir sorun değildir. RevenueCat canonical entitlement ve subscription yönetim platformu olarak kabul edilmiştir; receipt validation server-side yapılır, entitlement tabanlı erişim kontrolü uygulanır ve cross-platform subscription sync tek kaynaktan yönetilir.

---

# 2. Problem Tanımı

In-app purchase kararı verilmezse aşağıdaki sorunlar kaçınılmazdır:

- iOS ve Android store API'ları ayrı ayrı entegre edilir; cross-platform parity bozulur
- Receipt validation client-side yapılır; sahte satın alma riski artar
- Subscription lifecycle (trial, renewal, cancellation, grace period) her platform için ayrı yönetilir; tutarsız davranış oluşur
- Entitlement yönetimi doğrudan ürün ID'lerine bağlanır; pricing ve ürün yapısı değişikliği tüm kodu etkiler
- Cross-platform subscription sync (web Stripe + mobile store) baştan planlanmaz; aynı kullanıcı farklı platformlarda farklı erişim hakları görür
- Store guideline ihlalleri review rejection'a neden olur
- Sandbox test ortamı kurulmaz; ödeme akışları production'da ilk kez test edilir
- Refund ve chargeback senaryoları düşünülmez

---

# 3. Bağlam

Bu boilerplate'in in-app purchase açısından taşıdığı zorunluluklar şunlardır:

1. **Cross-platform yapı:** Hem iOS hem Android store'larında tutarlı satın alma deneyimi
2. **Web + mobile monetizasyon:** Web (Stripe) ve mobile (store billing) kanallarının aynı entitlement sistemi altında birleşmesi
3. **Expo-first runtime:** ADR-002 ile kilitlenmiş Expo SDK 55.x; IAP SDK'sı Expo uyumlu olmalı
4. **Auth entegrasyonu:** ADR-010 kapsamında kullanıcı kimliği ile entitlement eşleşmesi güvenli yapılmalı
5. **Güvenlik:** Receipt validation server-side zorunlu; sahte satın alma riski minimize edilmeli
6. **Store compliance:** Apple ve Google store kurallarına tam uyum
7. **Subscription lifecycle:** Trial, renewal, cancellation, grace period, billing retry gibi karmaşık lifecycle durumları yönetilmeli
8. **EU DMA uyumu:** Apple'ın EU Digital Markets Act kapsamındaki alternatif ödeme yöntemleri ve komisyon değişiklikleri takip edilmeli

---

# 4. Karar Kriterleri

1. **Cross-platform entitlement yönetimi (iOS + Android + web)**
2. **Server-side receipt validation kalitesi**
3. **Subscription lifecycle desteği (trial, renewal, cancellation, grace period)**
4. **Expo SDK uyumu**
5. **Web billing (Stripe) entegrasyon desteği**
6. **Store guideline uyum kolaylığı**
7. **Sandbox ve test ortamı desteği**
8. **Analytics ve revenue metrikleri**
9. **Vendor lock-in riski ve exit stratejisi**
10. **Maliyet modeli ve ölçeklenebilirlik**
11. **Dokümantasyon ve community desteği**
12. **Güvenlik ve fraud koruması**

---

# 5. Değerlendirilen Alternatifler

## 5.1. RevenueCat (react-native-purchases)

- Cross-platform entitlement yönetimi (iOS, Android, web, Stripe)
- Server-side receipt validation kutudan gelir
- Subscription lifecycle (trial, renewal, grace period, billing retry) tam yönetim
- Entitlement tabanlı erişim kontrolü
- Dashboard, analytics ve revenue metrikleri
- Expo uyumlu (Expo config plugin desteği)
- Sandbox ve test modu desteği
- Webhook ile backend entegrasyonu
- Ücretsiz katman $2.5M MTR'ye kadar komisyon almaz

## 5.2. react-native-iap

- Düşük seviye store API wrapper'ı
- iOS StoreKit ve Android Billing Library doğrudan erişim
- Receipt validation tamamen kendi sorumluluğunuz
- Subscription lifecycle yönetimi manuel
- Entitlement sistemi yok; kendi altyapınızı inşa etmelisiniz
- Cross-platform sync yok
- Web billing desteği yok
- Bakım ve hata yönetimi yüksek maliyetli

## 5.3. Adapty

- RevenueCat'e benzer entitlement yönetimi
- A/B test ve paywall optimizasyonu
- Daha küçük community
- Expo entegrasyonu mevcut ama RevenueCat kadar olgun değil
- Maliyet modeli daha agresif

## 5.4. Qonversion

- Subscription analytics odaklı platform
- Cross-platform entitlement desteği
- Community küçük, production track record RevenueCat'in gerisinde
- Expo entegrasyonu sınırlı

## 5.5. Stripe-only yaklaşım

- Web billing için güçlü
- Mobile store billing desteği yok (Apple/Google store API'ları ayrıca entegre edilmeli)
- Store guideline gereği digital content satışında store billing zorunlu
- Cross-platform sync tamamen kendi altyapınız

---

# 6. Seçilen Karar

Bu boilerplate için canonical in-app purchase kararı şu şekilde kabul edilmiştir:

## 6.1. Canonical SDK

RevenueCat (`react-native-purchases`) bu boilerplate'in in-app purchase ve subscription yönetim SDK'sıdır.

## 6.2. Satın alma türleri

### 6.2.1. Consumable

- Tek kullanımlık satın almalar (jeton, kredi, sanal para)
- Her kullanımda tüketilir; tekrar satın alınabilir
- Entitlement değil, bakiye/stok olarak yönetilir

### 6.2.2. Non-consumable

- Kalıcı satın almalar (premium özellik kilidi açma, tema paketi)
- Bir kez satın alınır; kalıcı erişim sağlar
- Entitlement olarak yönetilir; restore purchase desteklenir

### 6.2.3. Subscription (auto-renewable)

- Periyodik yenilenen abonelikler (aylık, yıllık)
- Trial, introductory offer ve promotional offer desteği
- Lifecycle durumları: active, expired, in-billing-retry, in-grace-period, paused, revoked
- Entitlement tabanlı erişim kontrolü

## 6.3. Entitlement yönetimi

- **Entitlement-first ilke:** Feature erişimi doğrudan ürün ID veya SKU kontrolüne bağlanmaz. Entitlement katmanı üzerinden kontrol edilir
- **Neden:** Ürün yapısı, fiyatlandırma veya paketleme değiştiğinde kodda değişiklik gerekmez; yalnızca entitlement-product mapping güncellenir
- **Entitlement kontrol noktası:** UI katmanında entitlement durumuna göre özellik gösterimi/gizleme yapılır
- **Backend sync:** RevenueCat webhook'ları ile backend entitlement state senkronize edilir

## 6.4. Receipt validation

- **Server-side zorunlu:** Client tarafında receipt validation yapılmaz; tüm receipt'ler RevenueCat üzerinden server-side doğrulanır
- **Neden:** Client-side validation manipüle edilebilir; jailbreak/root cihazlarda sahte receipt oluşturulabilir
- **RevenueCat otomasyonu:** RevenueCat Apple ve Google receipt validation'ı otomatik yapar; kendi backend'inizde ek validation gerekmez

## 6.5. Cross-platform subscription sync

- **Mobile store billing:** iOS App Store ve Google Play billing RevenueCat SDK ile yönetilir
- **Web billing:** Stripe entegrasyonu RevenueCat web SDK veya Stripe webhook → RevenueCat API entegrasyonu ile sağlanır
- **Tek entitlement kaynağı:** Hangi platformdan satın alınırsa alınsın, entitlement RevenueCat üzerinden yönetilir
- **User identification:** RevenueCat app user ID, ADR-010 kapsamındaki auth user ID ile eşleştirilir; cross-platform user merge desteklenir

## 6.6. Subscription lifecycle yönetimi

- **Trial:** Deneme süresi başlangıcı ve bitişi izlenir; trial → paid geçişi entitlement olarak yansır
- **Renewal:** Otomatik yenileme başarılı/başarısız durumları izlenir
- **Cancellation:** İptal sonrası mevcut dönem sonuna kadar erişim devam eder; dönem bitiminde entitlement kaldırılır
- **Grace period:** Ödeme başarısız olduğunda grace period boyunca erişim korunur
- **Billing retry:** Store tarafındaki billing retry mekanizması izlenir; kullanıcıya ödeme güncelleme bildirimi gösterilebilir
- **Refund:** Apple/Google refund webhook'ları ile entitlement anında güncellenir
- **Upgrade/downgrade:** Plan değişiklikleri proration policy'ye göre yönetilir

## 6.7. Store guideline uyumu

- **Apple App Store:** Digital content ve servis satışlarında App Store billing zorunludur. Commission oranları (%30 standart, %15 Small Business Program) dikkate alınır
- **Google Play Store:** Play billing zorunluluğu geçerlidir. Service fee oranları uygulanır
- **EU DMA:** Apple'ın EU Digital Markets Act kapsamındaki alternatif ödeme yöntemleri ve değişen commission yapıları takip edilir; gerektiğinde ADR güncellenir
- **Restore purchase:** iOS'ta "Restore Purchases" butonu App Store guideline gereği zorunludur
- **Subscription management:** Kullanıcıya subscription yönetim ekranına (store ayarları) yönlendirme sağlanır

## 6.8. Pricing ve paywall

- **Paywall tasarımı:** RevenueCat Paywalls veya custom paywall; tasarım design system token'ları ile uyumlu olur
- **Pricing testi:** RevenueCat experiments ile A/B pricing testi desteklenir
- **Introductory offer:** Free trial, pay-up-front ve pay-as-you-go offer türleri desteklenir
- **Promotional offer:** Churn azaltma amaçlı win-back offer'ları desteklenir

## 6.9. Sandbox ve test ortamı

- **Store sandbox:** Apple Sandbox ve Google Play test ortamları aktif kullanılır
- **RevenueCat sandbox modu:** Development build'lerde RevenueCat sandbox modu aktiftir
- **Test hesapları:** Store sandbox test hesapları oluşturulur ve güvenli tutulur
- **Otomatik test:** Entitlement kontrolü unit test ile doğrulanır; sandbox entegrasyonu integration test kapsamındadır

---

# 7. Neden Bu Karar?

## 7.1. Cross-platform entitlement yönetimi

RevenueCat, iOS, Android ve web (Stripe) satın almalarını tek bir entitlement sistemi altında birleştirir. Kendi entitlement altyapınızı inşa etmek yerine kanıtlanmış bir çözüm kullanılır.

## 7.2. Server-side receipt validation kutudan gelir

Receipt validation karmaşık ve güvenlik-kritik bir alandır. RevenueCat Apple ve Google receipt'lerini otomatik doğrular; kendi validation altyapınızı inşa etmek zorunda kalmazsınız.

## 7.3. Subscription lifecycle karmaşıklığı

Trial, renewal, cancellation, grace period, billing retry, refund gibi durumların her biri farklı davranış gerektirir. RevenueCat bu lifecycle'ı SDK ve webhook seviyesinde yönetir.

## 7.4. Expo uyumu

RevenueCat Expo config plugin desteği sunar. Expo managed workflow ile sorunsuz çalışır. ADR-002 Expo-first ilkesiyle hizalıdır.

## 7.5. Düşük başlangıç maliyeti

RevenueCat $2.5M MTR'ye kadar ücretsiz katman sunar. Boilerplate ve erken aşama ürünler için maliyet engeli yoktur.

## 7.6. Analytics ve revenue metrikleri

MRR, churn rate, trial conversion, ARPU gibi temel subscription metrikleri dashboard üzerinden izlenebilir. Ek analytics altyapısı gerekmez.

---

# 8. Reddedilen Yönler

## 8.1. react-native-iap reddedilmiştir

- **Neden:** Düşük seviye store API wrapper'ıdır. Receipt validation, entitlement yönetimi, subscription lifecycle, cross-platform sync tamamen kendi sorumluluğunuzdur. Bu altyapıyı sıfırdan inşa etmek boilerplate kapsamında kabul edilemez maliyet ve risk taşır.
- **Ek risk:** Store API değişikliklerinde (StoreKit 2, Google Billing Library 7) kendi kodunuzu güncellemeniz gerekir; bakım maliyeti süreklidir.

## 8.2. Adapty reddedilmiştir

- **Neden:** RevenueCat'e benzer özellikler sunar ama community daha küçük, production track record daha kısadır. Expo entegrasyonu mevcut ama RevenueCat kadar olgun değildir. Maliyet modeli daha agresiftir.

## 8.3. Qonversion reddedilmiştir

- **Neden:** Subscription analytics odaklı platform; entitlement yönetimi tam kapsamlı değildir. Community küçük, Expo entegrasyonu sınırlıdır. Production'da kanıtlanma düzeyi yetersizdir.

## 8.4. Stripe-only yaklaşım reddedilmiştir

- **Neden:** Mobile store guideline'ları digital content satışında store billing zorunlu kılar. Stripe tek başına mobile in-app purchase ihtiyacını karşılamaz. Cross-platform entitlement sync tamamen kendi altyapınızı gerektirir.

---

# 9. Riskler

## 9.1. RevenueCat vendor lock-in

RevenueCat entitlement ve receipt validation merkezi olarak kullanılır. Vendor değişikliği migration maliyeti taşır.

## 9.2. Store commission değişiklikleri

Apple ve Google commission oranları ve kuralları değişebilir. EU DMA ve regülasyon değişiklikleri iş modelini etkileyebilir.

## 9.3. Store review rejection

IAP implementation store guideline'larına uymuyorsa review rejection riski vardır. Restore purchase butonu eksikliği, yanlış pricing gösterimi veya misleading subscription bilgisi rejection nedenleridir.

## 9.4. Cross-platform user merge karmaşıklığı

Aynı kullanıcının farklı platformlarda farklı store hesaplarıyla satın alma yapması user merge sorunlarına neden olabilir.

## 9.5. Maliyet ölçeklenebilirliği

RevenueCat $2.5M MTR üzerinde commission almaya başlar. Yüksek revenue uygulamalarında maliyet artışı önemli olabilir.

---

# 10. Risk Azaltma Önlemleri

1. **Entitlement abstraction:** Entitlement kontrolü uygulama kodunda abstraction katmanı üzerinden yapılır; vendor değişikliği durumunda yalnızca adapter değişir
2. **Store guideline review:** Her release öncesinde Apple ve Google store guideline'ları kontrol edilir; compliance checklist audit kapsamındadır
3. **EU DMA takibi:** Apple ve Google'ın regülasyon değişiklikleri düzenli takip edilir; gerektiğinde ADR güncellenir
4. **User identification stratejisi:** RevenueCat app user ID auth user ID ile eşleştirilir; anonymous → identified user transfer mekanizması kurulur
5. **Maliyet modeli review:** Revenue büyüdüğünde RevenueCat maliyet modeli değerlendirilir; gerekirse migration planı hazırlanır
6. **Sandbox test disiplini:** Tüm satın alma akışları sandbox ortamında test edilir; production'da ilk kez test yasaktır
7. **Webhook monitoring:** RevenueCat webhook'ları observability kapsamında izlenir; başarısız webhook'lar alert tetikler

---

# 11. Non-Goals

Bu ADR aşağıdakileri çözmez:

- Fiyatlandırma stratejisi ve ürün paketleme kararları
- Pazarlama ve conversion optimizasyonu
- Reklam gelir modeli (AdMob, mediation)
- Affiliate ve referral programı
- Kurumsal (B2B) lisanslama modeli
- Vergi hesaplama ve fatura düzenleme (store tarafından yönetilir)
- Payment fraud detection (store ve RevenueCat tarafından yönetilir)
- Finansal raporlama ve muhasebe entegrasyonu

---

# 12. Sonuç ve Etkiler

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. RevenueCat (`react-native-purchases`) canonical IAP SDK'sı olarak dependency policy'ye (37) ve compatibility matrix'e (38) eklenir
2. Entitlement-first erişim kontrolü tüm premium özellikler için zorunlu olur; doğrudan ürün ID kontrolü yasaktır
3. Server-side receipt validation canonical olur; client-side validation yasaktır
4. Cross-platform subscription sync RevenueCat üzerinden yönetilir; web Stripe entegrasyonu aynı entitlement sistemi altındadır
5. Store guideline compliance audit her release'te kontrol edilir
6. Sandbox test ortamı kurulur ve tüm satın alma akışları sandbox'ta test edilir
7. Subscription lifecycle durumları (trial, renewal, cancellation, grace period) kapsamlı olarak yönetilir
8. RevenueCat webhook'ları backend ile entegre edilir ve monitoring kapsamına alınır
9. Contribution guide ve audit checklist IAP maddelerini içerir
10. Paywall tasarımı design system token'ları ile uyumlu olur

---

# 13. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Canonical SDK seçimi (RevenueCat) ve gerekçesi açıkça yazılmışsa
2. Satın alma türleri (consumable, non-consumable, subscription) tanımlanmışsa
3. Entitlement-first erişim kontrolü ilkesi net açıklanmışsa
4. Server-side receipt validation zorunluluğu gerekçesiyle belirtilmişse
5. Cross-platform subscription sync stratejisi (mobile store + web Stripe) tanımlanmışsa
6. Subscription lifecycle durumları detaylı açıklanmışsa
7. Store guideline uyum gereksinimleri (Apple, Google, EU DMA) görünür kılınmışsa
8. Sandbox test stratejisi belirtilmişse
9. Alternatifler ve ret gerekçeleri dürüstçe sunulmuşsa
10. Riskler ve risk azaltma önlemleri somutsa
11. Bu karar, implementation ekibine IAP altyapısını kuracak netlikte baseline sağlıyorsa

---

# 14. Subscription Upgrade/Downgrade Flow

Plan değişikliği UX ve teknik akışı.

## 14.1. Upgrade (Basic → Premium)

### Proration Mekanizması
Kullanıcı mevcut döneminin ortasında upgrade yaptığında kalan süre oranında fark hesaplanır. Apple ve Google otomatik proration yapar:
- **Apple:** Immediate mode — hemen yeni plan başlar, kalan gün oranında ücret farkı tahsil edilir
- **Google:** `IMMEDIATE_WITH_TIME_PRORATION` — hemen yeni plan başlar, kalan süre oranında kredi uygulanır

### UX Akışı
1. Kullanıcı mevcut plan sayfasını açar
2. Upgrade butonuna tıklar
3. **Plan karşılaştırma ekranı** gösterilir: Mevcut plan vs yeni plan, özellik farkları, fiyat farkı
4. "Upgrade Et" onay butonu → RevenueCat `purchasePackage` veya `switchProduct` API'si çağrılır
5. Platform native ödeme ekranı açılır (App Store / Google Play)
6. Ödeme başarılı → entitlement anında güncellenir → UI yeni plana göre yenilenir
7. Ödeme başarısız → mevcut plan korunur, hata mesajı gösterilir

### RevenueCat API
```typescript
const { customerInfo } = await Purchases.purchasePackage(premiumPackage);
// veya mevcut subscription'dan geçiş:
const { customerInfo } = await Purchases.purchasePackage(premiumPackage, {
  oldProductIdentifier: 'basic_monthly',
});
```

## 14.2. Downgrade (Premium → Basic)

### Zamanlama
- Downgrade **mevcut dönem sonunda** uygulanır. Premium özelliklere mevcut dönem bitimine kadar erişim devam eder.
- Apple ve Google downgrade'i bir sonraki yenileme döneminde uygular.

### UX Akışı
1. Kullanıcı plan değişikliği sayfasını açar
2. Downgrade seçeneğini seçer
3. **Uyarı gösterilir:** "Premium özellikler [tarih] tarihine kadar aktif kalacak. Bu tarihten sonra Basic plana geçilecek."
4. Kullanıcı onaylar → RevenueCat API ile downgrade kaydedilir
5. Mevcut dönem boyunca premium erişim devam eder
6. Dönem sonunda otomatik olarak basic plana geçilir

## 14.3. Edge Case: Trial Döneminde Upgrade

- Kullanıcı trial dönemindeyken upgrade yaparsa **trial iptal olur** ve **hemen ödeme başlar**
- Bu davranış kullanıcıya açıkça bildirilmelidir: "Free trial'ınız sona erecek ve hemen ödeme alınacak."
- UX'te trial kalan gün sayısı gösterilmeli

## 14.4. Edge Case: Downgrade Sonrası Re-Upgrade

- Kullanıcı downgrade ettikten sonra (henüz dönem bitmeden) tekrar upgrade yaparsa, downgrade iptal edilir ve premium devam eder
- RevenueCat bu senaryoyu otomatik yönetir

---

# 15. Grace Period ve Billing Retry Yönetimi

Ödeme başarısızlığı durumunda kullanıcı deneyimi ve teknik yönetim.

## 15.1. Grace Period Süreleri

| Platform | Grace Period Süresi | Konfigürasyon |
|----------|-------------------|---------------|
| Apple App Store | 6-16 gün (Apple tarafından belirlenir) | App Store Connect'te etkinleştirilir |
| Google Play | 7-30 gün (konfigüre edilebilir) | Google Play Console'da ayarlanır |

Grace period boyunca kullanıcı **premium özelliklerine erişmeye devam eder**. Platform bu süre zarfında ödeme yöntemini otomatik olarak retry eder.

## 15.2. Billing Retry Mekanizması

Apple ve Google otomatik billing retry yapar:
- **Apple:** 60 gün boyunca periyodik retry. Kullanıcıya email ile bildirim gönderir.
- **Google:** 30 gün boyunca retry. Kullanıcıya Play Store üzerinden bildirim gönderir.
- Uygulama bu sürece müdahale edemez; platform mekanizmasına bırakılır.

## 15.3. Uygulama İçi Bilgilendirme

### Yumuşak Uyarı (Soft Banner)
Grace period başladığında ekranın üstünde non-blocking banner gösterilir:
- Mesaj: "Ödeme yönteminizi güncelleyin"
- Aksiyon: Platform ödeme ayarlarına yönlendirme (App Store / Google Play → Subscriptions)
- Dismissable: Kullanıcı kapatabilir, 24 saat sonra tekrar gösterilir

### Sert Uyarı (Modal)
Grace period sonuna 3 gün kala modal dialog gösterilir:
- Mesaj: "Ödeme yönteminiz güncel değil. [tarih] tarihine kadar güncellenmezse premium erişiminiz sona erecek."
- Aksiyon butonu: "Ödeme Yöntemini Güncelle"
- İkincil buton: "Sonra Hatırlat"
- Dismissable: Hayır (aksiyon veya sonra hatırlat zorunlu)

## 15.4. Subscription Expired

Grace period sona erdiğinde ve ödeme hâlâ başarısız ise:
- Premium özellikler kilitlenir
- Kullanıcı basic özelliklerine düşülür
- "Premium aboneliğiniz sona erdi" ekranı gösterilir
- Yeniden abone olma seçeneği sunulur

## 15.5. RevenueCat Webhook Entegrasyonu

Backend'de aşağıdaki RevenueCat webhook event'leri dinlenir:

| Event | Tetikleyici | Aksiyon |
|-------|------------|---------|
| `BILLING_ISSUE` | Ödeme başarısız | Uygulama içi yumuşak uyarı tetikle |
| `SUBSCRIBER_ENTERED_GRACE_PERIOD` | Grace period başladı | Grace period banner göster |
| `SUBSCRIPTION_EXPIRED` | Abonelik sona erdi | Premium özellikleri kilitle |
| `RENEWAL` | Yenileme başarılı | Uyarıları kaldır, premium devam |

## 15.6. Restore Flow

Kullanıcı ödeme yöntemini güncellerse:
- Platform otomatik retry yapar ve ödeme başarılı olursa subscription restore edilir
- RevenueCat `syncPurchases()` ile entitlement durumu güncellenir
- Uygulama UI anında premium erişimi yeniden aktif eder
- Tüm uyarı banner/modal'ları kaldırılır
