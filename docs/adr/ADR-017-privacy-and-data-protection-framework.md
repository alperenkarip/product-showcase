# ADR-017 — Privacy and Data Protection Framework

## Doküman Kimliği

- **ADR ID:** ADR-017
- **Başlık:** Privacy and Data Protection Framework
- **Durum:** Accepted
- **Tarih:** 2026-04-01
- **Karar türü:** Foundational governance, privacy compliance, veri koruma ve consent yönetimi kararı
- **Karar alanı:** GDPR uyumu, KVKK uyumu, consent management, data minimization, right to erasure, SDK governance, privacy manifest, data retention ve consent state yönetimi
- **İlgili üst belgeler:**
  - `ADR-009-observability-stack.md`
  - `ADR-010-auth-session-and-secure-storage-baseline.md`
  - `27-security-and-secrets-baseline.md`
  - `28-observability-and-debugging.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `27-security-and-secrets-baseline.md`
  - `28-observability-and-debugging.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`

---

# 1. Karar Özeti

Bu ADR ile aşağıdaki karar kabul edilmiştir:

- **Privacy-by-design ilkesi:** Veri koruma ürün geliştirmenin temel parçasıdır; sonradan eklenen bir katman değildir
- **GDPR ve KVKK uyumu:** Her iki regülasyonun gereksinimleri baştan karşılanır
- **Consent management:** Kullanıcı onayı granüler, açık ve geri alınabilir şekilde yönetilir
- **Data minimization:** Yalnızca gerekli veri toplanır; fazla veri toplama yasaktır
- **Right to erasure:** Kullanıcının veri silme hakkı tam olarak desteklenir
- **SDK governance:** Üçüncü parti SDK'ların veri işleme davranışları denetlenir ve dokümante edilir
- **Privacy manifest:** Apple App Privacy ve Google Data Safety gereksinimleri karşılanır
- **Data retention:** Verinin ne kadar süre tutulacağı ve ne zaman silineceği politika ile belirlenir
- **Consent state persistence:** Kullanıcı onay durumu güvenli ve tutarlı şekilde saklanır

Bu ADR teknoloji seçimi yapmaz. Consent management platform (CMP) seçimi için kriter tanımlar ve privacy framework'ünün mimari sınırlarını çizer.

Bu ADR'nin ana hükmü şudur:

> Privacy bu boilerplate'te hukuki checklist olarak ele alınan bir son adım değildir. Veri koruma privacy-by-design ilkesiyle baştan tasarlanır; consent yönetimi granüler ve geri alınabilir olur; üçüncü parti SDK'ların veri davranışları denetlenir; platform privacy manifest gereksinimleri karşılanır; kullanıcının veri silme hakkı tam olarak desteklenir.

---

# 2. Problem Tanımı

Privacy ve veri koruma kararı verilmezse aşağıdaki sorunlar kaçınılmazdır:

- Kullanıcı onayı alınmadan veri toplanır; GDPR/KVKK ihlali riski doğar
- Consent yönetimi ad hoc yapılır; kullanıcı tercihlerini değiştirme imkanı sunulmaz
- Üçüncü parti SDK'lar kontrolsüz veri toplar; veri işleme envanteri çıkarılamaz
- Veri minimization ilkesi uygulanmaz; gereğinden fazla kişisel veri tutulur
- Veri silme talepleri karşılanamaz; right to erasure ihlali oluşur
- Apple App Privacy ve Google Data Safety manifest'leri yanlış veya eksik doldurulur; store rejection riski artar
- Data retention politikası tanımlanmaz; veriler süresiz tutulur
- Privacy policy ve terms of service uygulamayla tutarsız kalır
- Farklı pazarlar için farklı privacy gereksinimleri (GDPR, KVKK, CCPA) baştan planlanmaz

---

# 3. Bağlam

Bu boilerplate'in privacy ve veri koruma açısından taşıdığı zorunluluklar şunlardır:

1. **Multi-market dağıtım:** Uygulama birden fazla ülkede dağıtılabilir; GDPR (AB), KVKK (Türkiye) ve potansiyel olarak diğer regülasyonlar geçerlidir
2. **Cross-platform yapı:** Web ve mobile platformlarında farklı consent mekanizmaları gerekir (cookie consent web, tracking consent mobile)
3. **Üçüncü parti SDK ekosistemi:** Analytics, crash reporting, push notification ve diğer SDK'lar veri toplar; her birinin veri işleme davranışı denetlenmelidir
4. **Store gereksinimleri:** Apple App Privacy ve Google Data Safety manifest'leri doğru ve güncel tutulmalıdır
5. **Auth entegrasyonu:** ADR-010 kapsamında kullanıcı kimlik bilgileri privacy ilkelerine uygun yönetilmelidir
6. **Observability uyumu:** ADR-009 kapsamında analytics ve crash reporting PII sızıntısından korunmalıdır
7. **Security baseline:** 27-security-and-secrets-baseline ile hizalı veri koruma

---

# 4. Karar Kriterleri

1. **GDPR tam uyum kapasitesi**
2. **KVKK tam uyum kapasitesi**
3. **Consent yönetimi granülerliği (purpose-based)**
4. **Consent geri alma kolaylığı ve hızı**
5. **Data minimization uygulanabilirliği**
6. **Right to erasure tam desteği**
7. **Üçüncü parti SDK veri denetimi**
8. **Apple ve Google privacy manifest uyumu**
9. **Cross-platform consent state tutarlılığı**
10. **Data retention politikası esnekliği**
11. **Audit trail ve compliance kanıtı**
12. **Developer deneyimi ve uygulama kolaylığı**

---

# 5. Değerlendirilen Yaklaşımlar

Bu ADR belirli bir CMP (Consent Management Platform) seçimi yapmaz. Aşağıdaki yaklaşımlar değerlendirilmiştir:

## 5.1. Managed CMP (OneTrust, Cookiebot, Usercentrics)

- Hazır consent UI ve yönetim paneli
- GDPR/KVKK compliance şablonları
- Vendor lock-in riski
- Maliyet ölçekte artış
- Mobile SDK entegrasyonu kalitesi değişken

## 5.2. Lightweight CMP (custom veya open-source)

- Tam kontrol ve esneklik
- Vendor bağımsız
- Compliance doğrulaması kendi sorumluluğunuz
- Development maliyeti yüksek

## 5.3. Platform-native consent (ATT, Android consent)

- Platform tarafından zorunlu kılınan consent mekanizmaları
- ATT (App Tracking Transparency) iOS'ta zorunlu
- Granüler purpose-based consent için yetersiz
- Yalnızca tracking izni; analytics, crash reporting gibi alanlar kapsamaz

---

# 6. Seçilen Karar

Bu boilerplate için canonical privacy ve veri koruma framework'ü şu şekilde kabul edilmiştir:

## 6.1. Privacy-by-design ilkesi

- Veri koruma geliştirme sürecinin her aşamasında düşünülür
- Yeni özellik veya SDK eklerken privacy impact assessment zorunludur
- "Önce topla, sonra düşün" yaklaşımı yasaktır

## 6.2. GDPR uyum gereksinimleri

### 6.2.1. Lawful basis (hukuki dayanak)

- Her veri işleme faaliyeti için hukuki dayanak belirlenir: consent, legitimate interest, contract, legal obligation
- Consent dayanaklı işlemler için açık ve özgür onay alınır
- Legitimate interest kullanılacaksa LIA (Legitimate Interest Assessment) yapılır

### 6.2.2. Transparency (şeffaflık)

- Hangi verinin, neden, nasıl ve ne kadar süre toplandığı kullanıcıya açıklanır
- Privacy policy uygulamadaki gerçek veri işleme ile tutarlı tutulur

### 6.2.3. Data subject rights (veri sahibi hakları)

- Erişim hakkı (right of access)
- Düzeltme hakkı (right to rectification)
- Silme hakkı (right to erasure / right to be forgotten)
- İşlemeyi kısıtlama hakkı (right to restriction)
- Veri taşınabilirliği hakkı (right to data portability)
- İtiraz hakkı (right to object)

### 6.2.4. Data breach notification

- Veri ihlali durumunda 72 saat içinde yetkili makama bildirim
- Yüksek risk durumunda veri sahiplerine bildirim

## 6.3. KVKK uyum gereksinimleri (Türkiye özel)

### 6.3.1. Açık rıza

- Kişisel veri işleme için açık rıza alınır
- Açık rıza belirli konuya ilişkin, bilgilendirilmeye dayanan ve özgür iradeyle açıklanan onay olmalıdır
- Özel nitelikli kişisel veriler (sağlık, biyometrik, din vb.) için ayrı ve açık rıza zorunludur

### 6.3.2. Aydınlatma yükümlülüğü

- Veri sorumlusunun kimliği
- Kişisel verilerin hangi amaçla işleneceği
- İşlenen kişisel verilerin kimlere ve hangi amaçla aktarılabileceği
- Veri toplamanın yöntemi ve hukuki sebebi
- Veri sahibinin hakları

### 6.3.3. VERBİS kaydı

- Veri Sorumluları Sicil Bilgi Sistemi kaydı gerekiyorsa yapılır
- Kayıt gerekliliği ürün ve şirket ölçeğine göre değerlendirilir

### 6.3.4. Yurt dışı veri aktarımı

- Kişisel verilerin yurt dışına aktarımı KVKK m.9 kapsamında değerlendirilir
- Yeterli koruma bulunan ülkeler veya taahhütname mekanizması kullanılır

## 6.4. Consent management

### 6.4.1. Granüler consent

- Consent amaç bazlı (purpose-based) alınır:
  - **Zorunlu (essential):** Uygulamanın temel işlevselliği için gerekli; consent gerekmez
  - **Analytics:** Kullanım analizi ve performans ölçümü
  - **Marketing:** Hedefli reklam ve pazarlama
  - **Third-party sharing:** Üçüncü parti veri paylaşımı
- Her amaç için ayrı toggle sunulur; blanket consent yasaktır

### 6.4.2. Consent toplama zamanlaması

- **Web:** İlk sayfa yüklemesinde cookie consent banner gösterilir; consent alınana kadar non-essential cookie/tracker yüklenmez
- **Mobile:** App Tracking Transparency (ATT) iOS'ta zorunlu; tracking consent ilk ilgili işlem öncesinde istenir
- **Pre-consent bilgilendirme:** Consent istenmeden önce ne için istendiği açıklanır

### 6.4.3. Consent geri alma

- Kullanıcı verdiği onayı istediği zaman geri alabilir
- Consent geri alma uygulama ayarlarından erişilebilir olur
- Geri alma anında ilgili veri işleme faaliyetleri durdurulur
- Geri alma işlemi consent vermek kadar kolay olmalıdır

### 6.4.4. Consent versiyonlama

- Consent metni değiştiğinde yeni versiyon oluşturulur
- Eski consent versiyonu ile verilen onaylar geçerliliğini korur ama yeni amaçlar için yeniden onay istenir
- Consent geçmişi audit trail olarak tutulur

## 6.5. Data minimization

- Yalnızca belirtilen amaç için gerekli olan minimum veri toplanır
- Gereksiz kişisel veri alanları form ve API'lardan kaldırılır
- Analytics event'lerinde PII (Personally Identifiable Information) bulunmaz
- Log ve debug çıktılarında kişisel veri maskelenir
- Crash report'larda hassas veri (e-posta, telefon, finansal bilgi) bulunmaması sağlanır

## 6.6. Right to erasure implementasyonu

- Kullanıcı veri silme talebinde bulunabilir
- Silme talebi tüm veri depolama noktalarını kapsar:
  - Backend veritabanı
  - Analytics platformları (Sentry user data, analytics user profile)
  - Üçüncü parti servisler (RevenueCat, push notification service)
  - Yerel cihaz depolaması (secure storage, cache)
- Silme talebi 30 gün içinde gerçekleştirilir (GDPR süresi)
- KVKK kapsamında silme talebi "en kısa sürede" karşılanır
- Silme sonrası doğrulama yapılır; veri kalıntısı bırakılmaz
- Yasal saklama zorunluluğu olan veriler (fatura, vergi kaydı) silme kapsamı dışındadır; bunlar ayrıca dokümante edilir

## 6.7. SDK governance

### 6.7.1. SDK veri denetimi

- Her üçüncü parti SDK'nın topladığı veri türleri dokümante edilir
- SDK'ların privacy policy'leri incelenir ve uyumluluk doğrulanır
- Yeni SDK eklenmeden önce privacy impact assessment yapılır (37-dependency-policy ile hizalı)

### 6.7.2. SDK veri işleme envanteri

- Tüm SDK'ların veri işleme davranışları bir envanterde tutulur:
  - SDK adı ve versiyonu
  - Topladığı veri türleri
  - Veri işleme amacı
  - Veri aktarım hedefleri (ülke, şirket)
  - Retention süresi
  - Kullanıcı consent gereksinimi

### 6.7.3. SDK güncelleme ve denetim

- SDK güncellemelerinde veri işleme davranış değişiklikleri kontrol edilir
- Privacy-breaking SDK güncellemeleri review ve onay gerektirir

## 6.8. Privacy manifest

### 6.8.1. Apple App Privacy

- App Store Connect'te App Privacy bilgileri doğru ve güncel tutulur
- Toplanan veri türleri, kullanım amaçları ve tracking durumu beyan edilir
- NSPrivacyTracking ve NSPrivacyTrackingDomains plist değerleri yönetilir
- Required reason API kullanımları beyan edilir

### 6.8.2. Google Data Safety

- Google Play Console'da Data Safety bilgileri doğru ve güncel tutulur
- Toplanan ve paylaşılan veri türleri, amaçlar ve güvenlik önlemleri beyan edilir
- Data deletion request mekanizması sağlanır

### 6.8.3. Privacy manifest güncelliği

- Her yeni SDK eklenmesinde veya veri işleme değişikliğinde privacy manifest güncellenir
- Release öncesi privacy manifest doğruluğu audit checklist'te kontrol edilir

## 6.9. Data retention politikası

- Her veri türü için retention süresi tanımlanır
- Retention süresi dolan veriler otomatik veya kontrollü şekilde silinir/anonimleştirilir
- Analytics verileri anonimleştirilerek daha uzun tutulabilir
- Yasal zorunluluk olan veriler (fatura, vergi) ayrı retention politikasına tabidir
- Retention politikası dokümante edilir ve audit kapsamındadır

## 6.10. Consent state yönetimi ve persistence

- Consent durumu cihazda güvenli şekilde saklanır
- Web: consent state cookie veya localStorage'da tutulur (consent cookie'si kendisi essential kabul edilir)
- Mobile: consent state secure storage veya encrypted preferences'ta tutulur
- Backend sync: consent state backend'e senkronize edilir; cross-device tutarlılık sağlanır
- Consent state format: amaç bazlı (analytics: true, marketing: false) granüler yapıda tutulur
- Consent timestamp ve versiyon bilgisi saklanır; audit trail oluşturulur

---

# 7. Neden Bu Karar?

## 7.1. Regülasyon uyumu zorunluluktur

GDPR ve KVKK ihlalleri ciddi finansal ve hukuki yaptırımlar getirir. Privacy-by-design baştan uygulanması, sonradan uyum maliyetini minimize eder.

## 7.2. Store gereksinimleri

Apple ve Google privacy manifest gereksinimleri karşılanmazsa store rejection riski vardır. App Privacy ve Data Safety beyanları güncel ve doğru tutulmalıdır.

## 7.3. Kullanıcı güveni

Privacy-first yaklaşım kullanıcı güvenini artırır. Şeffaf consent yönetimi ve veri kontrolü kullanıcı memnuniyetini yükseltir.

## 7.4. SDK ekosistemi kontrolü

Üçüncü parti SDK'lar kontrolsüz veri toplayabilir. SDK governance ile veri işleme davranışları denetlenir ve ürün privacy policy'si ile tutarlılık sağlanır.

## 7.5. Teknik borç önleme

Privacy sonradan eklenmeye çalışıldığında mimari değişiklik gerektirir. Baştan tasarlanması teknik borcu önler.

---

# 8. Reddedilen Yönler

## 8.1. Blanket consent (tek onay ile tüm amaçlar) reddedilmiştir

- **Neden:** GDPR ve KVKK granüler, amaç bazlı consent gerektirir. Tek buton ile tüm veri işleme faaliyetlerine onay almak hukuki olarak geçersizdir.

## 8.2. Consent-free tracking reddedilmiştir

- **Neden:** iOS ATT zorunluluğu ve GDPR consent gereksinimleri nedeniyle consent alınmadan tracking yapılamaz. First-party analytics bile consent gerektirebilir.

## 8.3. Client-only consent yönetimi reddedilmiştir

- **Neden:** Consent state yalnızca client'ta tutulursa audit trail oluşturulamaz, cross-device tutarlılık sağlanamaz ve consent kanıtı sunulamaz. Backend sync zorunludur.

## 8.4. Privacy-last yaklaşımı reddedilmiştir

- **Neden:** Privacy'yi ürün tamamlandıktan sonra eklemeye çalışmak mimari değişiklik, veri migration ve hukuki risk getirir. Privacy-by-design baştan uygulanır.

---

# 9. Riskler

## 9.1. CMP seçimi gecikmesi

Bu ADR CMP seçimi yapmaz. CMP seçiminin gecikmesi consent UI ve yönetim altyapısının gecikmesine neden olabilir.

## 9.2. SDK veri denetimi maliyeti

Her SDK'nın veri işleme davranışını incelemek ve dokümante etmek zaman ve efor gerektirir.

## 9.3. Cross-jurisdictional karmaşıklık

GDPR, KVKK, CCPA ve diğer regülasyonlar farklı gereksinimler taşır. Multi-market uyum karmaşıklık yaratır.

## 9.4. Consent fatigue

Çok fazla consent seçeneği kullanıcıda yorgunluk yaratır; kullanıcı tüm consent'leri reddedebilir.

## 9.5. Right to erasure teknik karmaşıklığı

Tüm veri depolama noktalarından eksiksiz veri silme teknik olarak karmaşıktır; backup'lar ve üçüncü parti servisler zorluk yaratır.

## 9.6. Privacy manifest güncelliği

SDK güncellemeleri ve yeni veri işleme faaliyetleri privacy manifest'in sürekli güncellenmesini gerektirir; güncel tutma ihmal edilebilir.

---

# 10. Risk Azaltma Önlemleri

1. **CMP seçim kriterleri:** Bu ADR CMP seçim kriterlerini tanımlar (granüler consent, geri alma, versiyonlama, audit trail, cross-platform, mobile SDK kalitesi); ürün bağlamına göre seçim yapılır
2. **SDK privacy review template:** Yeni SDK eklenmesinde kullanılacak privacy impact assessment şablonu oluşturulur
3. **Jurisdictional mapping:** Hedef pazarların privacy gereksinimleri haritalanır; en sıkı regülasyon baseline olarak kabul edilir
4. **Consent UX optimizasyonu:** Consent UI basit, anlaşılır ve kullanıcı dostu tasarlanır; purpose sayısı makul tutulur
5. **Erasure playbook:** Veri silme talebi için adım adım playbook hazırlanır; tüm veri depolama noktaları listelenir
6. **Privacy manifest CI kontrolü:** Release pipeline'ında privacy manifest güncelliği kontrol edilir
7. **Periyodik privacy audit:** Düzenli aralıklarla privacy uyum denetimi yapılır; bulgular dokümante edilir

---

# 11. Non-Goals

Bu ADR aşağıdakileri çözmez:

- Belirli bir CMP vendor seçimi (OneTrust, Cookiebot, custom çözüm)
- Cookie policy ve cookie banner exact tasarımı
- CCPA (California), LGPD (Brezilya) ve diğer spesifik regülasyon detayları
- DPO (Data Protection Officer) atama ve organizasyonel süreçler
- Hukuki metin (privacy policy, terms of service) yazımı
- Veri işleme sözleşmeleri (DPA) içeriği
- DPIA (Data Protection Impact Assessment) tam prosedürü
- Siber güvenlik altyapısı (firewall, intrusion detection)

---

# 12. Sonuç ve Etkiler

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. Privacy-by-design ilkesi tüm geliştirme sürecinde zorunlu uygulanır
2. Her yeni SDK eklenmesinde privacy impact assessment yapılır (37-dependency-policy ile hizalı)
3. Consent yönetimi granüler ve amaç bazlı olur; blanket consent yasaktır
4. Right to erasure için veri silme playbook'u hazırlanır ve tüm veri noktaları listelenir
5. SDK veri işleme envanteri oluşturulur ve güncel tutulur
6. Apple App Privacy ve Google Data Safety manifest'leri her release'te doğrulanır
7. Data retention politikası tanımlanır ve periyodik olarak uygulanır
8. Consent state backend'e senkronize edilir; audit trail oluşturulur
9. Analytics ve crash reporting'de PII maskeleme zorunlu olur (ADR-009 uyumu)
10. Security baseline (27) privacy gereksinimleriyle genişletilir
11. Contribution guide ve audit checklist privacy maddelerini içerir
12. CMP seçim kriterleri bu ADR'de tanımlanır; ürün bağlamına göre seçim yapılır

---

# 13. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Privacy-by-design ilkesi ve uygulanma biçimi açıkça yazılmışsa
2. GDPR ve KVKK uyum gereksinimleri detaylı tanımlanmışsa
3. Consent management (granüler, geri alınabilir, versiyonlu) net açıklanmışsa
4. Data minimization ilkesi somut kurallarla belirtilmişse
5. Right to erasure implementasyon yaklaşımı tanımlanmışsa
6. SDK governance (veri denetimi, envanter, privacy review) açıklanmışsa
7. Privacy manifest (Apple, Google) gereksinimleri görünür kılınmışsa
8. Data retention politikası tanımlanmışsa
9. Consent state yönetimi ve persistence stratejisi belirtilmişse
10. CMP seçim kriterleri tanımlanmışsa (seçim yapılmasa bile)
11. Riskler ve risk azaltma önlemleri somutsa
12. Bu karar, implementation ekibine privacy framework'ünü kuracak netlikte baseline sağlıyorsa

---

# 14. Consent Management UI Pattern

GDPR/KVKK uyumlu izin yönetimi ekranı tasarım ve implementasyon rehberi.

## 14.1. İzin Kategorileri

| Kategori | Açıklama | Devre Dışı Bırakılabilir mi? | Varsayılan (GDPR) | Varsayılan (KVKK) |
|----------|----------|------------------------------|--------------------|--------------------|
| **Zorunlu (Essential)** | Uygulamanın temel işlevleri için gerekli (auth, güvenlik, tercih saklama) | Hayır — toggle disabled, her zaman aktif | Aktif | Aktif |
| **Analytics** | Kullanım istatistikleri, performans metrikleri, crash raporlama | Evet | Kapalı (opt-in) | Açık (opt-out) |
| **Reklam/Pazarlama** | Kişiselleştirilmiş reklam, remarketing, kampanya tracking | Evet | Kapalı (opt-in) | Kapalı (opt-in) |
| **Third-party Paylaşım** | Üçüncü taraf veri paylaşımı, partner entegrasyonları | Evet | Kapalı (opt-in) | Kapalı (opt-in) |

## 14.2. UI Pattern

### İlk Açılış Consent Ekranı
- **Format:** Full-screen bottom sheet veya modal (platform convention'a uygun)
- **İçerik:**
  - Başlık: "Gizlilik Tercihleri"
  - Her kategori için açıklama ve toggle
  - Zorunlu kategorinin toggle'ı disabled ve aktif
  - Detaylı bilgi linki (privacy policy)
- **Kısayol butonları:**
  - "Tümünü Kabul Et" — tüm kategorileri aktif eder
  - "Sadece Zorunlu" — yalnızca essential aktif, diğerleri kapalı
  - "Tercihleri Kaydet" — granüler seçimleri kaydeder
- **Kural:** Consent ekranı dismiss edilemez; kullanıcı bir seçim yapmalıdır

### Settings Ekranında Consent Yönetimi
- Settings → Gizlilik → İzin Tercihleri yolunda her zaman erişilebilir
- Mevcut consent durumu gösterilir
- Kullanıcı istediği zaman tercihlerini değiştirebilir
- Değişiklik anında uygulanır (analytics SDK kapatılır/açılır)

## 14.3. Teknik Implementasyon

### Consent State Saklama
- Consent durumu **MMKV**'de saklanır (ADR-019 uyumu)
- Yapı: `{ analytics: true, marketing: false, thirdParty: false, version: 2, timestamp: "2026-04-01T12:00:00Z" }`
- Her consent değişikliğinde `version` artırılır ve `timestamp` güncellenir

### SDK İnitialization Gate
- Analytics SDK'lar (Sentry analytics, custom analytics) consent durumuna göre **koşullu** initialize edilir
- Consent verilmeden SDK başlatılmaz ve veri toplanmaz
- Consent geri çekildiğinde SDK deactivate edilir ve toplanan veri silinir (teknik olarak mümkün olduğu ölçüde)

### Audit Trail
- Her consent değişikliği timestamp + action olarak loglanır
- Format: `{ userId, action: "consent_updated", categories: { analytics: true }, timestamp, appVersion }`
- Bu kayıtlar GDPR/KVKK compliance kanıtı olarak **5 yıl** saklanır
- Backend'e sync edilir (derived project sorumluluğu)

## 14.4. Consent Versiyonlama

Privacy policy veya consent kategorileri değiştiğinde:
- Consent version artırılır
- Mevcut kullanıcılara yeni consent ekranı gösterilir (re-consent)
- Önceki consent kayıtları korunur; yeni versiyon üzerine yazılmaz

---

# 15. Data Retention Policy

Kullanıcı verilerinin saklama süresi yönetimi ve otomatik temizlik stratejisi.

## 15.1. Canonical Retention Tablosu

| Veri Türü | Saklama Süresi | İşlem Sonunda | Gerekçe |
|-----------|---------------|---------------|---------|
| Hesap verileri (profil, tercihler) | Hesap silinene kadar | Silme talebiyle tamamen kaldırılır | Aktif kullanıcı verisi |
| Analytics event'leri | 24 ay | Otomatik anonimleştirme → aggregate veri olarak kalır | İstatistiksel analiz için yeterli süre |
| Crash raporları (Sentry) | 12 ay | Otomatik silme | Debug için yeterli süre |
| Application log kayıtları | 6 ay | Otomatik silme | Operasyonel analiz süresi |
| Oturum verileri (session) | 30 gün | Otomatik silme | Aktif oturum süresi |
| Consent kayıtları | 5 yıl | Arşivleme | GDPR/KVKK yasal zorunluluk |
| Push notification token'ları | Son etkileşimden 90 gün sonra | Otomatik silme | Inactive kullanıcı temizliği |
| Backup ve geçici dosyalar | 7 gün | Otomatik silme | Geçici operasyonel ihtiyaç |

## 15.2. Hesap Silme (Right to Erasure)

GDPR Madde 17 ve KVKK Madde 7 kapsamında kullanıcının veri silme hakkı tam olarak desteklenir:

### Silme Süreci
1. Kullanıcı Settings → Hesap → "Hesabımı Sil" seçeneğini kullanır
2. Onay ekranı gösterilir: "Tüm verileriniz kalıcı olarak silinecek. Bu işlem geri alınamaz."
3. Kullanıcı şifre veya biometric ile kimliğini doğrular
4. Silme talebi backend'e gönderilir
5. **30 gün** içinde tüm kişisel veri silinir (GDPR requirement)
6. Kullanıcıya email ile silme onayı gönderilir

### Silinecek Veriler
- Profil bilgileri (isim, email, telefon, adres)
- Kullanıcı tercihleri ve ayarları
- Satın alma geçmişi (kişisel veri kısmı)
- Push notification token'ları
- Analytics event'lerindeki kullanıcı tanımlayıcıları
- Local storage'daki tüm kullanıcı verisi (MMKV, SecureStore)

### Silinemeyecek Veriler (Anonimleştirme)
- Aggregate analytics verisi (kullanıcı tanımlayıcısı olmadan)
- Finansal kayıtlar (yasal zorunluluk — anonimleştirilerek saklanır)
- Consent kayıtları (yasal zorunluluk — 5 yıl arşiv)

## 15.3. Anonimleştirme Standardı

Anonimleştirme geri dönüşü olmayan şekilde yapılmalıdır:
- Kullanıcı ID'si hash'lenir ve ardından silinir (one-way)
- Email, telefon, isim gibi tanımlayıcılar tamamen kaldırılır
- IP adresleri truncate edilir (son oktet silinir)
- Cihaz tanımlayıcıları kaldırılır
- Kalan veri yalnızca aggregate istatistik olarak kullanılabilir

## 15.4. Backend Tetikleme

Retention süresi dolan verilerin temizlenmesi **scheduled job** ile yapılır:
- Günlük çalışan cron job expired veriyi tarar
- Batch silme ile performans korunur
- Silme işlemi audit log'a kaydedilir
- Bu mekanizmanın implementasyonu **derived project sorumluluğudur**; boilerplate yalnızca retention policy ve silme API contract'ını tanımlar
