# ADR-011 — Internationalization Baseline

## Doküman Kimliği

- **ADR ID:** ADR-011
- **Başlık:** Internationalization Baseline
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational content architecture, localization runtime and locale behavior decision
- **Karar alanı:** i18n altyapısı, localization runtime, message organization, locale resolution, formatting strategy, translation key policy, copy governance, cross-platform locale behavior
- **İlgili üst belgeler:**
  - `03-ui-ux-quality-standard.md`
  - `05-theming-and-visual-language.md`
  - `06-application-architecture.md`
  - `12-accessibility-standard.md`
  - `23-component-governance-rules.md`
  - `26-platform-adaptation-rules.md`
  - `32-definition-of-done.md`
  - `36-canonical-stack-decision.md`
  - `ADR-007-styling-tokens-and-theming-implementation.md`
  - `ADR-010-auth-session-and-secure-storage-baseline.md`
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

Bu boilerplate kapsamında internationalization için aşağıdaki karar kabul edilmiştir:

- **Canonical i18n runtime:** i18next tabanlı yaklaşım
- **Locale management modeli:** Explicit locale resolution + fallback policy + user preference override
- **Message organization modeli:** Namespace/tabakalı, feature-aware ve governance-friendly message yapısı
- **Formatting yaklaşımı:** Locale-aware formatting ayrı sorumluluktur; raw string interpolation ile karıştırılmaz
- **Translation key politikası:** Semantics-first, stable, feature/domain aware keys
- **Copy governance ilkesi:** UI metni rastgele inline string olarak kod içine dağılmaz; kontrollü içerik sözleşmesi olarak ele alınır
- **Cross-platform ilke:** Mesaj anlamı ve ürün dili ortak kalır; platforma özgü mikro-kopya yalnızca gerekçeli adaptation durumlarında ayrışır
- **Canonical ilke:** i18n yalnızca “çeviri desteği” değil; içerik yapısı, locale davranışı, formatting, a11y ve ürün dili tutarlılığını yöneten foundation katmanıdır

Bu ADR’nin ana hükmü şudur:

> Internationalization bu boilerplate’te sonradan eklenecek süs katmanı değildir. i18next tabanlı, namespace’lenmiş, locale-aware, formatting-disiplinli ve copy governance ile desteklenen bir içerik altyapısı ilk günden düşünülmüş canonical baseline olacaktır.

---

# 2. Problem Tanımı

Projelerde i18n çoğu zaman şu yanlış varsayımlarla ertelenir:

- “şimdilik Türkçe yazalım, sonra çeviririz”
- “string’leri sonra dışarı alırız”
- “bir `t()` fonksiyonu ekleriz, tamam”
- “formatting zaten string birleştirme”
- “web ve mobile’da küçük farklar sorun değil”
- “buton text’i inline olabilir, önemli olan büyük metinler”

Bu yaklaşım pratikte şu sorunları üretir:

- metinler component’lere ve ekranlara dağılır
- aynı kavram farklı yerlerde farklı kelimelerle geçer
- locale geçişi yarım çalışır
- pluralization ve interpolation hataları oluşur
- tarih/sayı/para formatı inconsistent olur
- çeviri anahtarları anlamsız veya kırılgan hale gelir
- platformlar arasında ürün dili kopar
- screen reader ve a11y copy kalitesi düşer
- future localization maliyeti katlanır
- test ve review süreçleri copy contract’ını göremez

Bu yüzden i18n kararı yalnızca “hangi kütüphane?” sorusu değildir.  
Asıl soru şudur:

> Metinler, locale, formatting, fallback, namespace, key yapısı ve cross-platform copy davranışı nasıl sistemli, güvenli ve sürdürülebilir şekilde yönetilecek?

Bu ADR tam olarak bunu kapatır.

---

# 3. Bağlam

Bu boilerplate’in internationalization açısından taşıdığı zorunluluklar şunlardır:

1. Web ve mobile arasında ortak ürün dili
2. Documentation-first ve governance-friendly copy yönetimi
3. Locale-aware formatting
4. Design system ve reusable component metin ihtiyacı
5. Accessibility ve assistive text kalitesi
6. Inline string kaosunun engellenmesi
7. Namespace ve feature-level message ownership
8. Future localization maliyetini erkenden düşürme
9. Right-to-left veya ek locale genişleme ihtimaline kapı bırakma
10. User preference, system locale ve fallback davranışının net olması

Bu bağlamda i18n yaklaşımı şu iki uçtan da kaçınmalıdır:

- her şeyi tek dev çeviri dosyasına yığmak
- “şimdilik inline yaz, sonra toplarız” kültürü

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Web ve mobile ile uyum**
2. **Olgun ekosistem**
3. **Namespace ve message organization desteği**
4. **Locale switching ve fallback yönetimi**
5. **Formatting stratejisine uyum**
6. **Testing ve maintainability**
7. **TypeScript ile çalışabilirlik**
8. **A11y ve copy governance ile uyum**
9. **Low vendor lock-in risk**
10. **Future locale expansion kolaylığı**
11. **Documentation-first yaklaşım ile uyum**
12. **Cross-platform semantic parity desteği**

---

# 5. Seçilen Karar

Bu boilerplate için canonical internationalization yaklaşımı şu şekilde kabul edilmiştir:

## 5.1. Runtime
- **i18next**

## 5.2. Message organization
- namespace-based
- feature-aware
- shared/common vs feature-local ayrımı olan yapı

## 5.3. Locale resolution
- system locale
- persisted user preference
- supported locale fallback zinciri

## 5.4. Formatting
- locale-aware formatting ayrı utility/contract katmanı
- date/number/currency/list/relative time formatting için raw string concat kullanılmaz

## 5.5. Copy governance
- inline literal UI strings canonical değildir
- translation keys semantics-first olur
- product terminology tutarlılığı resmi kalite konusu olur

---

# 6. Neden i18next?

## 6.1. Olgunluk

i18next uzun süredir güçlü ve geniş ekosistem desteği olan bir çözümdür.  
Bu boilerplate için önemli olan:
- popülerlik değil
- olgunluk,
- esneklik,
- namespace disiplini,
- cross-platform uyumudur.

## 6.2. Namespace desteği

Bu proje feature-heavy ve dokümantasyon-first olduğu için message’ların:
- feature bazlı,
- ortak/common bazlı,
- domain veya shell bazlı
ayrılabilmesi gerekir. i18next bu modeli güçlü taşır.

## 6.3. Locale ve fallback yönetimi

Desteklenen diller, fallback locale ve resolution mantığı için güçlü temel sunar.

## 6.4. Cross-platform zihinsel model

Web ve mobile için aynı içerik yönetim zihinsel modelini taşımaya uygundur.

## 6.5. Uzun vadeli esneklik

i18next canonical runtime olarak yeterince esnektir; erken gereksiz vendor lock-in üretmez.

---

# 7. Bu Karar Ne Anlama Gelmez?

Bu ADR kolay yanlış yorumlanabilir. Bu yüzden sınırlar açık yazılmalıdır.

## 7.1. “Artık tüm metin aynı dosyada olacak” demek değildir
Yanlış.  
Namespace ve ownership ayrımı gerekir.

## 7.2. “Her string translation key olmalı” demek değildir
Kod yorumları, internal test labels veya non-user-facing teknik sabitler aynı şey değildir.

## 7.3. “i18n var, copy kalitesi otomatik çözülür” demek değildir
Yanlış.  
Kötü copy, kötü copy’dir; yalnızca çevrilebilir hale gelmiş olur.

## 7.4. “Her platform tamamen aynı copy’yi kullanmak zorunda” demek değildir
Yanlış.  
Platform adaptation gerekçesi varsa mikrocopy ayrışabilir.

## 7.5. “Formatting, translation interpolation ile çözülür” demek değildir
Yanlış.  
Formatting ayrı sorumluluktur.

---

# 8. En Kritik İlke: Copy, UI Kodunun Çöplüğü Değildir

Bu ADR’nin kalbi şu cümledir:

> **User-facing copy, rastgele component içine gömülmüş literal metinler olarak yaşamamalıdır.**

Bu şu anlama gelir:

- button label’lar bile governance konusudur
- form helper/error text’leri sistem dışı düşünülemez
- screen title/subtitle/empty state copy ürün dilinin parçasıdır
- accessibility label/hint/metinleri “sonradan bakarız” alanı değildir

Bu ilke bozulursa i18n yalnızca çeviri tekniğine düşer ve ürün dili dağılır.

---

# 9. Message Organization Politikası

## 9.1. Kural

Mesajlar tek dev `translations.json` dosyasında yaşamaz.  
Ownership görünür olmalıdır.

## 9.2. Güçlü namespace aileleri

Aşağıdaki gibi bir düşünce canonical kabul edilir:

- `common`
- `shell`
- `auth`
- `forms`
- `errors`
- `feature-*`
- `settings`
- `accessibility` (gerektiğinde)
- `validation` (gerektiğinde)

## 9.3. Neden?

Çünkü:
- ownership netleşir
- aynı kelimeyi her yerde farklı yazma riski azalır
- refactor ve review kolaylaşır
- feature-level copy değişimi kontrollü yapılır

## 9.4. Zayıf davranışlar

- her şeyi `common` altında toplamak
- screen isimlerine göre key kaosu oluşturmak
- aynı kavramı her feature’da kendi key’i ile tekrar tanımlamak
- namespace yapısını yalnızca klasör düzeni gibi görmek

---

# 10. Translation Key Politikası

## 10.1. Kural

Translation key’ler semantics-first olmalıdır.

## 10.2. Ne demek?

Key şu soruya cevap vermelidir:
“Bu metin ürün içinde hangi rolü taşıyor?”

## 10.3. Güçlü key özellikleri

- stable
- anlaşılır
- presentation detayına aşırı bağımlı değil
- feature/domain bağlamı taşıyor
- refactor ile kolay çökmez

## 10.4. Zayıf key örnekleri

- `text1`
- `submit2`
- `newLabel`
- `headerFinal`
- `button_blue_primary`

## 10.5. Güçlü key yaklaşımı örnek mantığı

- `auth.signIn.submit`
- `auth.signIn.error.invalidCredentials`
- `common.actions.save`
- `settings.language.current`
- `profile.emptyState.title`

Burada önemli olan exact biçim değil, semantics-first düşüncedir.

---

# 11. Shared vs Feature-Local Copy Politikası

## 11.1. Kural

Her tekrar eden kelime otomatik shared yapılmaz.  
Her feature kendi copy evreni gibi de davranmaz.

## 11.2. Shared copy ne zaman meşru?

- gerçekten ürün genelinde aynı anlamı taşıyorsa
- aynı terminoloji tutarlı kalmalıysa
- action label standardı varsa
- feedback state copy’si ortak sistem parçasıysa

## 11.3. Feature-local copy ne zaman meşru?

- bağlam çok feature-specific ise
- domain anlamı farklıysa
- aynı kelime başka feature’da farklı nuance taşıyorsa

## 11.4. Zayıf davranışlar

- her “save” kelimesini shared yapmak
- her küçük fark için kopyayı bölmek
- product terminology’yi ortaklaştırmamak
- “copy reuse” adına anlamsız shared key biriktirmek

---

# 12. Locale Resolution Politikası

## 12.1. Kural

Locale seçimi deterministic olmalıdır.

## 12.2. Olası kaynaklar

- persisted user preference
- system locale
- account/workspace preference (ürüne göre)
- app default locale

## 12.3. Canonical çözüm sırası

Varsayılan mantık şuna yakın olmalıdır:

1. explicit user preference
2. supported system locale match
3. app default locale

## 12.4. Kural

Locale resolution “bazen böyle, bazen öyle” davranamaz.  
Boot davranışı açık olmalıdır.

---

# 13. Supported Locale Politikası

## 13.1. Kural

Desteklenen locale listesi açıkça tanımlanmalıdır.  
“Her locale’e açığız” soyutluğu canonical değildir.

## 13.2. Neden?

Çünkü:
- fallback davranışı
- formatting davranışı
- QA yüzeyi
- content completeness
desteklenen locale listesine bağlıdır.

## 13.3. Zayıf davranışlar

- resmi desteklenmeyen locale’i yarım göstermeye çalışmak
- desteklenmeyen locale’de kırık kopya bırakmak
- locale fallback zincirini tanımlamamak

---

# 14. Fallback Politikası

## 14.1. Kural

Fallback bir hata gizleme mekanizması değil, kontrollü güvenlik ağıdır.

## 14.2. Düşünülmesi gerekenler

- missing translation olduğunda ne olur?
- unsupported locale’de ne olur?
- namespace eksikse ne olur?
- interpolation parametresi eksikse ne olur?

## 14.3. Kural

Fallback sonucu kullanıcıya kırık key veya anlamsız placeholder göstermemelidir.

## 14.4. Zayıf davranışlar

- UI’da key string’i göstermek
- locale değişince yarısı eski dilde kalmak
- partial namespace load yüzünden ekranın parçalı görünmesi

---

# 15. Formatting Politikası

## 15.1. En kritik ayrım

Translation ve formatting aynı şey değildir.

## 15.2. Ayrı düşünülmesi gereken format aileleri

- date
- time
- number
- currency
- percent
- relative time
- list formatting
- pluralization
- ordinal/cardinal forms

## 15.3. Kural

Bu alanlar string concat ile çözülmez.

## 15.4. Neden?

Çünkü:
- locale kuralları değişir
- pluralization dilden dile farklıdır
- sayı/tarih para formatı kültürel bağlama bağlıdır
- metin düzgün görünse bile yanlış anlam üretebilir

---

# 16. Interpolation Politikası

## 16.1. Kural

Interpolation kontrollü, anlamlı ve güvenli olmalıdır.

## 16.2. Ne demek?

- placeholder isimleri anlamlı olmalı
- raw HTML-like hack’ler kullanılmamalı
- user-provided input dikkatle ele alınmalı
- metin yapısı translator-friendly olmalı

## 16.3. Zayıf davranışlar

- string birleştirerek sentence kurmak
- aynı cümleyi üç parçaya bölmek
- farklı dillerde cümle yapısı değişebileceğini yok saymak
- çevirmen veya bakım yapan kişi için anlamsız placeholder bırakmak

---

# 17. Pluralization Politikası

## 17.1. Kural

Singular/plural gibi sayısal dil kuralları ad-hoc if/else ile ekranda çözülmez.

## 17.2. Neden?

Çünkü:
- tüm diller aynı plural kurala sahip değildir
- “1 item / 2 items” tarzı İngilizce varsayımı genellenemez
- locale-aware çoğulluk kuralları gerekir

## 17.3. Zayıf davranışlar

- `count === 1 ? ... : ...` yaklaşımını evrensel sanmak
- pluralization’ı string birleştirme ile çözmek

---

# 18. Accessibility Copy Politikası

## 18.1. Kural

A11y metinleri de i18n kapsamındadır.

## 18.2. Neleri kapsar?

- accessibilityLabel
- accessibilityHint
- aria-label eşleniği olan metinler
- hidden assistive guidance
- screen reader only explanatory copy
- form helper/error text

## 18.3. Neden?

Çünkü bu metinler kullanıcıya dönük gerçek içeriktir; sıradan teknik string değildir.

## 18.4. Zayıf davranışlar

- UI metnini çevirmek ama a11y metnini inline bırakmak
- assistive labels’ı İngilizce/varsayılan dilde unutarak bırakmak
- a11y copy’yi tasarım metninden kopuk ve kötü tutmak

---

# 19. Validation ve Error Copy Politikası

## 19.1. Kural

Validation ve error metinleri teknik hata dump’ı değildir.

## 19.2. Ayrım

- domain/business validation
- field validation
- form-level validation
- network failure
- auth/session error
- unknown failure
farklı copy ihtiyaçları doğurur.

## 19.3. Kural

Aynı generic “Bir hata oluştu” metni her sorunu kapatmak için kullanılmaz.

## 19.4. Zayıf davranışlar

- ham backend mesajı göstermek
- validation message’ları inline string olarak saçmak
- aynı hata sınıfını her feature’da farklı copy ile anlatmak

---

# 20. Product Terminology Politikası

## 20.1. Kural

Ürün terminolojisi resmi kalite alanıdır.  
Aynı kavram ürünün farklı yerlerinde farklı adla geçmemelidir; geçiyorsa bu bilinçli karar olmalıdır.

## 20.2. Neden?

Çünkü:
- UX tutarlılığı
- support/documentation uyumu
- translation kalitesi
- onboarding ve discoverability
bu alana bağlıdır.

## 20.3. Zayıf davranışlar

- settings / preferences / options gibi kavramları rastgele karıştırmak
- aynı domain nesnesini farklı ekranlarda farklı isimle göstermek
- copy governance olmadan “her ekip kendi dilini yazsın” kültürü

---

# 21. Screen Title / CTA / Empty State Copy Politikası

## 21.1. Kural

Aşağıdaki yüzeyler ürün dili açısından yüksek önemdedir:

- screen title
- primary CTA
- empty state title/body
- destructive confirmation copy
- onboarding copy
- settings descriptions
- permission rationale copy

## 21.2. Sonuç

Bu metinler “nasıl olsa kısa” diye governance dışı bırakılmaz.

---

# 22. Web ve Mobile Arasında Copy Parity Politikası

## 22.1. Kural

Semantic parity korunmalıdır.

## 22.2. Bu ne demek?

Aynı feature aynı ürün anlamını taşımalıdır.  
Ama platform ergonomisi nedeniyle mikrocopy ayrışabilir.

## 22.3. Ayrışmanın meşru olduğu durumlar

- keyboard / gesture / touch farklılıkları
- mobile sheet / web dialog yüzeyi farkı
- platform-specific permission flows
- system integration farkları

## 22.4. Zayıf davranışlar

- web’de detaylı açıklama varken mobile’da anlamsız kısa copy
- mobile’da domain anlamını değiştiren sadeleştirme
- platform adaptation bahanesiyle ürün dili koparmak

---

# 23. Locale Switching Politikası

## 23.1. Kural

Locale değişimi runtime-supported olmalı ve deterministic davranmalıdır.

## 23.2. Düşünülmesi gerekenler

- switch sonrası hangi yüzeyler anında güncellenir?
- persisted preference nasıl yazılır?
- unsupported locale seçilirse ne olur?
- formatting surfaces nasıl yenilenir?

## 23.3. Zayıf davranışlar

- bazı ekranların yeni locale’e geçip bazılarının geçmemesi
- switch sonrası stale text kalması
- locale değişince navigation/shell’in yarım güncellenmesi

---

# 24. RTL / Layout Direction Hazırlığı

## 24.1. Kural

Bu ADR hemen tam RTL desteği verdiğini iddia etmez.  
Ama future RTL ihtimalini imkânsızlaştıran keyfi kararlar canonical değildir.

## 24.2. Ne anlama gelir?

- left/right hardcode bağımlılıkları azaltılmalıdır
- directional copy assumptions dikkatli düşünülmelidir
- icon/text order gibi alanlar future direction support düşünülerek tasarlanmalıdır

## 24.3. Zayıf davranışlar

- copy ve layout’u soldan-sağa varsayımıyla kalıcı sabitlemek
- direction-sensitive component’leri governance dışı bırakmak

---

# 25. Testing Üzerindeki Etki

Bu ADR test stratejisinde şu sonuçları doğurur:

1. Message key resolution kritik alanlarda testlenebilir olmalıdır
2. Locale fallback behavior testlenebilir olmalıdır
3. Formatting helpers deterministic test yüzeyi taşımalıdır
4. Missing translation failure mode görünür olmalıdır
5. Critical a11y copy surfaces audit/test konusu olabilir
6. Cross-platform copy parity kritik flows için audit konusu olur

---

# 26. Repo Yapısı Üzerindeki Etki

Bu ADR şu topolojik sonuçları doğurur:

- translations/messages rastgele app component’lerine dağılmaz
- shared/common ve feature-local message ownership ayrılır
- formatting helpers ayrı kontrollü utility/contract alanında yaşar
- locale resolution ve persistence mekanizması app shell’e yakın yaşar
- a11y copy ve validation copy aynı governance evreninin parçası olur

Bu nedenle `21-repo-structure-spec.md` bu ADR ile hizalanmalıdır.

---

# 27. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası contributor ve reviewer şu soruları sormalıdır:

1. Bu metin neden inline?
2. Bu key semantics-first mi, yoksa geçici isim mi?
3. Bu copy shared mi olmalı, feature-local mi?
4. Formatting burada yanlışlıkla string concat ile mi yapılıyor?
5. Fallback davranışı düşünülmüş mü?
6. A11y copy bu yüzeyde unutulmuş mu?
7. Locale switch bu ekranı doğru güncelliyor mu?
8. Web ve mobile semantik parity korunuyor mu?
9. Aynı kavram başka yerde farklı terimle mi geçiyor?
10. Bu metin future localization maliyetini büyütüyor mu?

---

# 28. Neden Inline Strings Yaklaşımı Reddedildi?

## 28.1. Gerekçe

Inline literal string kullanımı:
- localization maliyetini katlar
- terminoloji drift’i üretir
- review ve audit’i zorlaştırır
- a11y copy’yi unutturur
- formatting hatalarını artırır

## 28.2. Sonuç

User-facing copy için inline string canonical değildir.

---

# 29. Neden Formik/Yup Benzeri Form Layer Copy’sine Güvenilmiyor?

Bu ADR, validation ve form copy’sinin form library tarafından “bir şekilde çözülmesini” canonical kabul etmez.  
Çünkü copy governance ayrı problemdir.  
Form engine yalnızca mekanik çözüm sağlar; dil tutarlılığı ve localization contract ayrı tasarlanmalıdır.

---

# 30. Neden Analytics/Event Metinleri ile UI Copy Karıştırılmıyor?

UI copy, kullanıcıya dönüktür.  
Analytics event adları ise telemetry içindir.  
Bu ikisi aynı sözlükten beslenebilir ama aynı şey değildir.

Kural:
- translation key ile analytics event name aynı yönetim nesnesi değildir
- UI metnini event name’den türetmek canonical değildir

---

# 31. Riskler

Bu kararın da riskleri vardır.

## 31.1. i18next yanlış organize edilirse namespace kaosu oluşabilir
Bu gerçek risktir.

## 31.2. Her şey translation key yapılırsa bakım maliyeti gereksiz artabilir
Bu da risktir.

## 31.3. Shared vs feature-local copy ayrımı kötü kurulursa hem tekrar hem dağınıklık oluşur
İki uç da tehlikelidir.

## 31.4. Formatting utility’leri zayıf kurulursa i18n var gibi görünür ama kültürel doğruluk bozulur
Bu önemli risktir.

## 31.5. Locale switch ve fallback iyi test edilmezse kullanıcı yarım çevrilmiş yüzey görür
Bu da kritik UX sorunudur.

---

# 32. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. Namespace ve key policy contribution guide’a yazılmalı
2. Product terminology sözlüğü veya benzeri governance yüzeyi düşünülmeli
3. Formatting helper policy ayrıca görünür kılınmalı
4. Missing translation ve fallback davranışı audit checklist’e bağlanmalı
5. A11y copy surfaces review maddesi olmalı
6. Shared vs feature-local copy örnekleri dökümante edilmeli
7. Locale resolution ve persistence app shell seviyesinde net kurulmalı

---

# 33. Non-Goals

Bu ADR aşağıdakileri çözmez:

- exact folder names for translation files
- exact key naming punctuation rules
- translation management SaaS/vendor seçimi
- full content workflow with translators
- exact RTL implementation
- every formatting helper implementation detail
- copywriting tone guide’nin tamamı

Bu alanlar ilgili policy ve setup belgelerinde kapanacaktır.

---

# 34. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. i18next canonical i18n runtime olur
2. Inline user-facing strings canonical olmaktan çıkar
3. Namespace-based message organization resmi baseline olur
4. Locale resolution ve fallback deterministic tasarlanır
5. Formatting translation’dan ayrı sorumluluk olarak ele alınır
6. A11y, validation ve empty/error state copy’si i18n governance’in parçası olur
7. Web ve mobile arasında semantic copy parity resmi kalite konusu olur

---

# 35. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- i18next ekosistem/operasyon açısından belirgin dezavantaj üretirse
- ürün localization gereksinimleri farklı runtime modelini zorunlu kılarsa
- copy governance ve translation workflow başka yapıyı ciddi biçimde avantajlı hale getirirse
- cross-platform locale behavior bu modelle sürdürülemez hale gelirse

Bu seviyedeki değişiklik yeni ADR ve muhtemelen geniş content refactor’u gerektirir.

---

# 36. Kararın Kısa Hükmü

> Internationalization için canonical karar: i18next tabanlı, namespace’lenmiş, semantics-first key yapısına sahip, deterministic locale resolution ve fallback policy taşıyan, formatting’i translation’dan ayıran ve inline user-facing copy’yi canonical kabul etmeyen bir i18n foundation’dır.

---

# 37. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. i18next seçiminin kapsamı açıkça yazılmışsa
2. Message organization, locale resolution ve fallback yaklaşımı net tanımlanmışsa
3. Translation key, formatting ve copy governance politikaları görünür kılınmışsa
4. A11y, validation ve platform parity ile i18n ilişkisi kurulmuşsa
5. Neden inline string yaklaşımının canonical reddedildiği açıklanmışsa
6. Riskler ve mitigations görünürse
7. Bu karar implementasyon öncesi kilitlenmiş i18n baseline olarak kullanılabilecek netlikteyse

---

# 38. RTL (Right-to-Left) Layout Stratejisi

Arapça, İbranice, Farsça gibi sağdan sola yazılan diller için layout desteği.

## 38.1. Şu Anki Pozisyon

RTL desteği **derived project kararıdır**. Bu boilerplate RTL-ready altyapı sağlar; ancak RTL’i varsayılan olarak aktif etmez. Derived project’te RTL dil desteği gerektiğinde aşağıdaki rehber uygulanır.

## 38.2. Mobile RTL Altyapısı

### Uygulama Genelinde RTL Aktivasyonu
`I18nManager.forceRTL(true)` ile uygulama genelinde layout yönü değiştirilir. Bu çağrı app başlangıcında, locale değişikliğinde tetiklenir ve uygulama yeniden başlatılır (RTL değişikliği hot-reload ile uygulanamaz).

### Flexbox Davranışı
- `flexDirection: ‘row’` RTL modunda otomatik olarak `row-reverse` gibi davranır (`I18nManager.isRTL` aktifken)
- Layout yönü platform tarafından otomatik yönetilir; manuel reverse gereksizdir

### Text Alignment
- `textAlign: ‘left’` / `textAlign: ‘right’` yerine `textAlign: ‘start’` / `textAlign: ‘end’` kullanılır (uygun olan yerlerde)
- Bu sayede RTL’de metin otomatik doğru yöne hizalanır

### İkon Mirroring
- Yön bildiren ikonlar (geri oku, ileri oku, chevron, çıkış) RTL’de ayna görüntüsü olmalıdır
- Yön bağımsız ikonlar (kalp, yıldız, silme) mirror edilmemelidir
- `I18nManager.isRTL` kontrolü ile koşullu `transform: [{ scaleX: -1 }]` uygulanır

### Spacing
- `marginLeft` / `marginRight` yerine `marginStart` / `marginEnd` kullanılır
- `paddingLeft` / `paddingRight` yerine `paddingStart` / `paddingEnd` kullanılır
- Bu API’ler RTL’de otomatik yön değiştirir

## 38.3. Web RTL Altyapısı

- HTML `dir="rtl"` attribute’u ile document yönü değiştirilir
- Tailwind CSS `rtl:` prefix ile RTL-specific stiller yazılır (ör. `rtl:text-right`)
- CSS logical properties (`margin-inline-start`, `padding-inline-end`) tercih edilir
- `@layer` ile RTL override’lar organize edilir

## 38.4. NativeWind RTL Desteği

NativeWind’in `rtl:` prefix’i ile RTL-specific stiller yazılabilir:
- `rtl:flex-row-reverse` — RTL’de satır yönünü tersine çevir
- `rtl:mr-4` → `rtl:ml-4` — RTL’de margin yönünü değiştir
- Bu prefix’ler yalnızca RTL modunda aktif olur

## 38.5. Test Gereksinimleri

- RTL destekli her ekran **hem LTR hem RTL** modunda visual test gerektirir
- Storybook’ta RTL toggle ile her component’in RTL görünümü doğrulanır
- Navigation flow (back button, drawer direction) RTL’de doğru çalışmalıdır
- Sayılar ve tarihler RTL’de doğru formatta gösterilmelidir (bu i18next locale formatters ile sağlanır)

---

# 39. Namespace Lazy Loading

i18next namespace’lerinin ekran bazlı lazy load edilmesi, initial bundle boyutunu küçültür ve uygulama başlangıç süresini iyileştirir.

## 39.1. Varsayılan Namespace

`common` namespace’i app başlangıcında yüklenir. Bu namespace genel UI metinlerini içerir:
- Buton etiketleri (Kaydet, İptal, Tamam, Geri)
- Navigasyon etiketleri (Ana Sayfa, Ayarlar, Profil)
- Genel hata mesajları (Bir hata oluştu, Tekrar deneyin)
- Genel durum mesajları (Yükleniyor, Sonuç bulunamadı)

## 39.2. Feature Namespace’leri

Feature-specific namespace’ler ilgili ekran render edildiğinde dinamik olarak yüklenir:

| Namespace | Yükleme Zamanı | İçerik |
|-----------|---------------|--------|
| `auth` | Login/Register ekranı açıldığında | Giriş yap, Hesap oluştur, Şifremi unuttum |
| `profile` | Profil ekranı açıldığında | Profil düzenle, Hesap bilgileri, Abonelik |
| `settings` | Ayarlar ekranı açıldığında | Bildirim tercihleri, Dil seçimi, Tema |
| `payment` | Ödeme ekranı açıldığında | Ödeme yöntemi, Fatura bilgileri, Abonelik planları |
| `onboarding` | Onboarding flow’u başladığında | Hoş geldiniz, Adım 1/2/3 |

## 39.3. Lazy Loading Mekanizması

```typescript
// i18next konfigürasyonu
i18n.init({
  ns: [‘common’],           // Başlangıçta yüklenen namespace
  defaultNS: ‘common’,
  partialBundledLanguages: true,
  // ...
});

// Ekran seviyesinde namespace yükleme
function ProfileScreen() {
  const { t, ready } = useTranslation(‘profile’);

  if (!ready) return <LoadingSkeleton />;

  return <Text>{t(‘profile:editProfile’)}</Text>;
}
```

## 39.4. React.lazy + Suspense Entegrasyonu

Namespace yükleme sırasında Suspense fallback gösterilir. Bu, ekranın namespace yüklenene kadar loading skeleton göstermesini sağlar.

## 39.5. Bundle Boyutu Etkisi

- **Öncesi:** Tüm dil dosyaları (tüm namespace’ler × tüm diller) initial bundle’da → örneğin 200KB+ JSON
- **Sonrası:** Yalnızca `common` namespace initial bundle’da → örneğin 15KB JSON
- **Kazanım:** Initial bundle boyutu %90+ küçülür; kalan namespace’ler on-demand yüklenir

## 39.6. Cache

- Yüklenen namespace’ler memory’de tutulur; aynı ekrana tekrar gidildiğinde yeniden yüklenmez
- App restart’ta namespace’ler tekrar yüklenir (persist edilmez; translation dosyaları küçük olduğu için her seferinde yüklemek kabul edilir)

## 39.7. Backend Plugin (Opsiyonel)

`i18next-http-backend` plugin’i ile translation dosyaları remote server’dan çekilebilir:
- **Avantaj:** Yeni çeviri eklendiğinde app update gerekmez; OTA translation update mümkün olur
- **Dezavantaj:** Ağ bağımlılığı, ilk yüklemede gecikme riski
- **Boilerplate pozisyonu:** Bu özellik opsiyoneldir. Varsayılan olarak translation dosyaları bundle’da yaşar. Remote translation ihtiyacı derived project kararıdır.

---

# 40. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te internationalization sonradan yapıştırılacak çeviri katmanı değildir. i18next tabanlı, namespace’lenmiş, formatting-disiplinli, semantics-first key yapısına sahip ve copy governance ile desteklenen bir içerik altyapısı canonical baseline olarak kabul edilmiştir. Locale, fallback ve cross-platform ürün dili davranışı ilk günden tasarıma dahildir.
