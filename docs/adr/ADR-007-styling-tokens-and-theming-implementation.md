# ADR-007 — Styling, Tokens and Theming Implementation

## Doküman Kimliği

- **ADR ID:** ADR-007
- **Başlık:** Styling, Tokens and Theming Implementation
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational UI implementation, styling runtime and token-consumption decision
- **Karar alanı:** Web styling implementation, mobile styling implementation, token consumption modeli, semantic token runtime, theme switching yaklaşımı, style escape hatch policy
- **İlgili üst belgeler:**
  - `04-design-system-architecture.md`
  - `05-theming-and-visual-language.md`
  - `22-design-tokens-spec.md`
  - `23-component-governance-rules.md`
  - `24-motion-and-interaction-standard.md`
  - `33-visual-implementation-contract.md`
  - `34-hig-enforcement-strategy.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `23-component-governance-rules.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında styling, tokens ve theming implementation için aşağıdaki karar kabul edilmiştir:

- **Web styling runtime:** Tailwind CSS
- **Mobile styling runtime:** NativeWind
- **Token authority:** Shared token source
- **Color/theme consumption modeli:** Semantic token-first
- **Web theme runtime:** CSS variables / semantic theme variables
- **Mobile theme runtime:** Semantic token mapping + NativeWind-uyumlu consumption
- **Canonical ilke:** Raw color, raw spacing, raw typography ve keyfi stil kararları doğrudan component içinde yazılmaz; token ve semantic token katmanından geçer
- **Escape hatch policy:** Mümkün olduğunca yasaklı / son çare; gerekçesiz raw style kullanımına izin verilmez
- **Design system implementation hedefi:** UI estetiği değil; denetlenebilir, tekrar üretilebilir, cross-platform uyumlu, premium kaliteyi koruyan görsel ve davranışsal foundation

Bu ADR’nin ana hükmü şudur:

> Styling implementation bu boilerplate’te “istediğimiz gibi class yazalım” veya “RN’de StyleSheet geçer, web’de CSS geçer” mantığıyla kurulmayacaktır. Web’de Tailwind CSS, mobilde NativeWind kullanılacak; ancak bunlar utility serbestliği değil, shared token source ve semantic token disiplininin taşıyıcısı olarak çalışacaktır.

---

# 2. Problem Tanımı

Tasarım sistemi dokümanı yazmak, tek başına doğru UI implementation üretmez.  
Asıl problem genellikle burada başlar:

- web’de token var ama insanlar raw Tailwind utility basıyor
- mobile’da NativeWind var ama zorlanınca StyleSheet ile kaçılıyor
- semantic token yerine hex/rgb/hardcoded değerler kullanılıyor
- theme mantığı kağıtta var ama runtime tüketim dağınık
- component variant’ları token değil keyfi stillerle büyüyor
- state stilleri (hover/focus/pressed/disabled/error) sistemik değil
- dark mode desteği var deniyor ama gerçek semantic mapping yok
- platform farkı bahanesiyle görsel dil kopuyor
- styling runtime, design system disiplinini enforce etmek yerine delmeye başlıyor

Bu yüzden styling kararı yalnızca “hangi stil aracı?” sorusu değildir.  
Asıl soru şudur:

> Token’lar ve semantic görsel dil, web ve mobile’da teknik olarak nasıl uygulanacak, nasıl denetlenecek ve keyfi stil kararları nasıl engellenecek?

Bu ADR tam olarak bunu kapatır.

---

# 3. Bağlam

Bu boilerplate’in styling ve theming açısından taşıdığı zorunluluklar şunlardır:

1. Cross-platform görsel ve davranışsal uyum
2. Design system-first yaklaşım
3. Semantic token disiplini
4. Hardcoded stil kararlarından kaçınma
5. Premium UI kalitesini sistemle üretme
6. Apple HIG duyarlılığıyla çelişmeyen mobile implementation
7. Accessibility, contrast ve state visibility’yi sistemik ele alma
8. Reusable component API’lerini stil kaosuna dönüştürmeme
9. Theming’i gerçek runtime davranışı haline getirme
10. Styling layer’i lint/audit/governance ile denetlenebilir kılma

Bu bağlamda seçilecek çözüm şu iki uçtan da kaçınmalıdır:

- utility/class serbestliği adı altında kuralsız stil yazımı
- her şeyi CSS-in-JS veya ad-hoc style object’lerle çözüp token disiplinini fiilen bozmak

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Token-first yaklaşımı teknik olarak destekleme**
2. **Semantic token consumption’a uygunluk**
3. **Web ve mobile arasında benzer consumption mental modeli kurabilme**
4. **Design system governance ile enforce edilebilir olma**
5. **Type-safe ve maintainable component APIs**
6. **Theming ve dark mode desteği**
7. **State styling (hover/focus/pressed/disabled/error) desteği**
8. **Performance ve runtime maliyeti**
9. **Developer ergonomisi**
10. **A11y ve HIG ile uyum**
11. **Long-term refactor safety**
12. **Monorepo token pipeline ile çalışma uygunluğu**

---

# 5. Değerlendirilen Alternatifler

Bu karar öncesi ana alternatifler şunlardır:

1. Tailwind CSS + NativeWind + shared semantic token strategy
2. CSS Modules / plain CSS + RN StyleSheet
3. styled-components / emotion
4. Tam custom token-to-style object sistemi
5. MUI / Chakra / ağır component framework tabanlı yaklaşım
6. Web ve mobile’da tamamen farklı styling paradigması
7. Mobile tarafı ağırlıklı StyleSheet, web tarafı ağırlıklı utility class yaklaşımı

Bu alternatiflerin neden seçilmediği veya seçildiği aşağıda açıklanmıştır.

---

# 6. Seçilen Karar: Tailwind CSS + NativeWind + Shared Semantic Token Runtime

## 6.1. Neden bu kombinasyon?

Bu kararın ana amacı şu iki şeyi aynı anda elde etmektir:

1. **Hızlı ama kurallı UI üretimi**
2. **Token ve semantic token disiplininin teknik olarak sürdürülebilmesi**

Bu kombinasyon doğru kurulduğunda:
- web ve mobile için benzer consumption mental modeli sunar
- reusable component implementasyonunu hızlandırır
- design token katmanını component kullanımına yaklaştırır
- hardcoded stil kararlarını azaltmaya yardımcı olur
- governance ve lint ile birlikte çalışabilir

## 6.2. En kritik uyarı

Bu karar kesinlikle şu anlama gelmez:

- “Tailwind var, herkes istediği utility’yi yazar”
- “NativeWind var, artık DS kuralı gereksiz”
- “raw utility zaten token gibi”
- “biraz class string, biraz inline style, biraz StyleSheet karışık gider”

Tam tersine, doğru yorum şudur:

> Utility runtime yalnızca taşıyıcıdır. Karar otoritesi token ve semantic token sistemidir.

---

# 7. Token Authority Kararı

## 7.1. En kritik ilke

Bu ADR’nin kalbi şu cümledir:

> **Tek kaynak otorite shared token source’tur.**

Bu şu anlama gelir:

- renk kararları component içinde verilmez
- spacing kararları screen bazında doğaçlama verilmez
- typography rolleri text component içinde keyfi tanımlanmaz
- border/radius/shadow/surface/state kararları utility seçimiyle yeniden icat edilmez

## 7.2. Token aileleri

Canonical token katmanı en az aşağıdaki aileleri içermelidir:

- color tokens
- semantic color tokens
- spacing tokens
- size/dimension tokens
- radius tokens
- border width tokens
- typography tokens
- motion/duration/easing tokens
- opacity/z-index/elevation benzeri sistemik token’lar (gerektiği ölçüde)

## 7.3. Kural

Raw değerler canonical kaynak değildir.  
Hex, px, arbitrary spacing, random font-size, rastgele radius ve local shadow kararları sistem dışı kabul edilir.

---

# 8. Semantic Token Kararı

## 8.1. Neden semantic token şart?

Çünkü raw token ile semantic kullanım aynı şey değildir.

Örnek:
- `blue-500` veya `neutral-900` düzeyi yalnızca ham malzemedir
- gerçek UI kararı ise: `surface-primary`, `text-secondary`, `border-subtle`, `action-primary-bg`, `feedback-error-text`

## 8.2. Kural

Component ve screen implementasyonu mümkün olduğunca raw token’ı değil semantic token’ı tüketmelidir.

## 8.3. Neden?

Çünkü semantic token:
- tasarım dilini korur
- theme değişimine dayanıklıdır
- dark/light eşleşmesini sistemik hale getirir
- component’i palette bilgisine bağımlı olmaktan çıkarır

## 8.4. Zayıf davranışlar

- component içinde palette renk seçmek
- `bg-blue-500` gibi raw brand kararlarını doğrudan UI surface’e gömmek
- border/text/background için aynı raw renk mantığını farklı yorumlamak
- semantic yerine utility shortcut’la karar vermek

---

# 9. Web Styling Runtime Kararı: Tailwind CSS

## 9.1. Karar

Web tarafında canonical styling runtime:
- **Tailwind CSS**

## 9.2. Neden Tailwind?

### 9.2.1. Utility consumption hızı
Component ve screen implementasyonu hızlıdır.

### 9.2.2. Design token pipeline ile uyum
Tailwind config ve CSS variable modeli ile token tüketim katmanı sistemleştirilebilir.

### 9.2.3. Reusable component katmanında tutarlılık
Primitive ve component seviyesinde state/variant yüzeyleri kontrollü üretilebilir.

### 9.2.4. Modern frontend ekosistemiyle güçlü uyum
React + Vite + Storybook / test / design system dokümantasyonu ile doğal çalışır.

## 9.3. Tailwind neden tek başına çözüm değildir?

Çünkü Tailwind raw utility serbestliği bırakılırsa design system’i güçlendirmez, bozar.

Bu yüzden Tailwind ancak şu koşulla doğrudur:
- raw utility değil
- tokenized / semantic consumption katmanı ile
- restricted utility policy ile
- component-first usage modeliyle

---

# 10. Mobile Styling Runtime Kararı: NativeWind

## 10.1. Karar

Mobile tarafında canonical styling runtime:
- **NativeWind**

## 10.2. Neden NativeWind?

### 10.2.1. Web ile benzer consumption mental modeli
Web ve mobile aynı utility grammar ailesi içinde çalışır; bu baseline bunu mümkün kılar.

### 10.2.2. Token ve semantic consumption için ortak zemin
Token dilini iki platformda benzer zihinsel modelle tüketmek mümkün olur.

### 10.2.3. React Native component geliştirme hızı
Primitive ve reusable component geliştirme akışını hızlandırır.

### 10.2.4. Design system enforcement ile uyum
Doğru policy kurulursa StyleSheet-first kaosunu ciddi ölçüde azaltır.

## 10.3. NativeWind neden otomatik doğru değildir?

Çünkü NativeWind kötü kullanılırsa:
- dev class string’ler
- token kaçakları
- semantics yerine raw utility
- her component’te stil kaosu
üretir.

Bu yüzden NativeWind, strict governance altında meşrudur.

---

# 11. Web ve Mobile Arasında Ortak Styling Mental Modeli

## 11.1. Amaç

Aynı utility runtime’ı birebir kopyalamak değil; aynı **tasarım sistemi düşüncesi**ni taşıyan benzer tüketim modelini kurmak.

## 11.2. Ortak kalması gerekenler

- token authority
- semantic token kullanımı
- component variant mantığı
- state styling yaklaşımı
- visual hierarchy disiplini
- theming mantığı
- hardcoded yasağı

## 11.3. Farklılaşabilecekler

- hover/pointer states
- mobile pressed/focus-visible farkları
- layout density
- safe area ve sheet ergonomisi
- platform-specific style escape gerektiren çok istisnai noktalar

---

# 12. Web Theme Runtime Kararı

## 12.1. Karar

Web tarafında theme runtime:
- **CSS variables / semantic theme variables**
üzerinden kurulacaktır.

## 12.2. Neden?

Çünkü theme’in yalnızca build-time utility üretimi değil, runtime semantic swap kabiliyeti olması gerekir.

## 12.3. Sonuç

- light/dark veya future theme variations
- semantic surface/text/border/feedback rolleri
- component’lerin palette yerine role tüketmesi
daha sağlıklı hale gelir.

## 12.4. Kural

Theme değişimi component içinde raw class override ile değil, semantic variable mapping ile yönetilmelidir.

---

# 13. Mobile Theme Runtime Kararı

## 13.1. Karar

Mobile tarafında theme runtime:
- shared semantic token mapping
- NativeWind uyumlu token consumption
- controlled runtime theme resolution
üzerinden kurulacaktır.

## 13.2. Neden?

React Native tarafında web’deki CSS variable modeli birebir yoktur.  
Bu nedenle semantic token role → concrete runtime value mapping dikkatli kurulmalıdır.

## 13.3. Kural

Mobile component’ler mümkün olduğunca “hangi renk?” değil, “hangi rol?” tüketmelidir.

## 13.4. Zayıf davranışlar

- component içinde dark mode if-else ile renk kararını dağınık çözmek
- raw palette değerleriyle varyant üretmek
- semantic role yerine local theme branching yazmak

---

# 14. Theme Switching Politikası

## 14.1. Kural

Theme switching:
- runtime-supported
- semantic-role-based
- flicker ve partial mismatch üretmeyen
bir modelde çalışmalıdır.

## 14.2. Düşünülmesi gerekenler

- initial theme resolution
- persisted preference
- system preference fallback
- cross-platform parity
- transition davranışı
- screenshots/storybook/test surfaces

## 14.3. Zayıf davranışlar

- bazı component’lerin theme’e uyup bazılarının uymaması
- dark mode’da contrast bozulması
- theme değişince only-some-surfaces update
- component-level ad-hoc theme override

---

# 15. Raw Utility Kullanım Politikası

## 15.1. En kritik kural

Tailwind / NativeWind kullanmak, raw utility serbestliği vermez.

## 15.2. Kural

Aşağıdaki alanlarda raw utility kullanımı mümkün olduğunca kısıtlanmalı veya yasaklanmalıdır:

- raw colors
- arbitrary spacing values
- arbitrary font sizes
- rastgele radius
- component seviyesinde palette hardcode
- token sistemini bypass eden utility kararları

## 15.3. Hangi utility’ler daha kabul edilebilir?

Bağlama göre:
- layout primitives
- flex/grid positioning
- semantic class aliases
- controlled spacing scale usage
- DS-approved state/layout helpers

## 15.4. Hangi utility’ler daha risklidir?

- arbitrary values
- palette-driven styling
- component internals’ında duygusal/random seçimler
- class string içinde DS yerine doğrudan görünüm kararı

---

# 16. Escape Hatch Policy

## 16.1. Tanım

Escape hatch, canonical styling runtime dışında raw style object, StyleSheet, inline style, ad-hoc CSS veya özel platform-specific stil çözümüne başvurmaktır.

## 16.2. Varsayılan tutum

Escape hatch:
- varsayılan çözüm değildir
- son çaredir
- belgelenmelidir
- gerekçeli olmalıdır

## 16.3. Ne zaman meşru olabilir?

- platform limitation
- animation or measurement constraint
- 3rd-party integration necessity
- RN-native style interop edge case
- performance-critical exceptional case

## 16.4. Ne zaman meşru değildir?

- “class yazmak zor geldi”
- “hızlıca bitsin”
- “tek yerde kullanıyorum”
- “tasarım sistemiyle uğraşmak istemedim”
- “bu component zaten özel”

## 16.5. Kural

Escape hatch kullanıldıysa:
- neden gerektiği yazılmalı
- neden canonical yolun yetmediği açıklanmalı
- scope dar tutulmalı
- future cleanup ihtiyacı görünür olmalı

---

# 17. StyleSheet Politikası (Mobile)

## 17.1. Kural

React Native StyleSheet canonical styling yöntemi değildir.

## 17.2. Ne anlama gelir?

- StyleSheet tümden yasak demek değildir
- ama default çözüm değildir
- NativeWind ile çözülebilen alanlar StyleSheet’e kaçırılmaz

## 17.3. StyleSheet meşru adayları

- very specific performance-sensitive case
- unsupported style interop
- complex animation/native measurement bridge
- unavoidable platform edge case

## 17.4. Zayıf davranışlar

- her component’te alışkanlıkla StyleSheet açmak
- token sistemini StyleSheet içine kopyalamak
- “sadece bunda kullandım” diyerek style sprawl üretmek

---

# 18. Inline Style Politikası

## 18.1. Kural

Inline style canonical değildir.

## 18.2. Neden?

Çünkü:
- token disiplini bozulur
- review zorlaşır
- design drift görünmez artar
- reuse azalır

## 18.3. Meşru istisnalar

- runtime-computed dimension
- temporary animated numeric bridge
- 3rd-party API constraint
- single-use calculated transform/positioning edge case

Ama bu istisnalar da sınırlı ve belgeli olmalıdır.

---

# 19. Component Variant Politikası

## 19.1. Kural

Component görünümü ad-hoc class string birikimiyle değil, explicit variant/state sistemiyle kurulmalıdır.

## 19.2. Varyant neyi kapsar?

- size
- emphasis / intent
- tone
- surface style
- interactive state
- destructive / success / warning semantic states
- density

## 19.3. Neden?

Çünkü aksi halde component API:
- `className` çöplüğü
- boolean prop patlaması
- görünmez stil branch’leri
üretir.

## 19.4. Kural

Component varyantları token ve semantic role üzerinden tasarlanmalıdır; palette ezberi üzerinden değil.

---

# 20. State Styling Politikası

## 20.1. Hangi state’ler düşünülmeli?

- default
- hover
- focus
- focus-visible
- pressed
- selected
- active
- disabled
- loading
- invalid
- success
- error
- expanded/collapsed

## 20.2. Kural

State styling component seviyesinde sistematik tanımlanmalı; screen içinde yeniden icat edilmemelidir.

## 20.3. Neden?

Bu boilerplate premium ve tutarlı interaction dili hedefliyor.  
State görünürlüğü rastgele olamaz.

---

# 21. Typography Consumption Politikası

## 21.1. Kural

Typography raw font-size / font-weight seçimleriyle değil, role-based semantic usage ile tüketilmelidir.

## 21.2. Örnek roller

- display
- heading
- title
- body
- body-secondary
- caption
- label
- overline
- helper
- error-text

## 21.3. Zayıf davranışlar

- component içinde 13, 14, 15, 17 gibi keyfi ara değerler üretmek
- typography hiyerarşisini ekran bazında yeniden tanımlamak
- weight ve line-height’i rastgele ayarlamak

---

# 22. Spacing Consumption Politikası

## 22.1. Kural

Spacing kararları rastgele numeric stil kararı olarak değil, scale-tied system kararı olarak alınmalıdır.

## 22.2. Ne anlama gelir?

- gap
- padding
- margin
- section spacing
- stack spacing
- container inset
- touch buffer
scale üzerinden gitmelidir.

## 22.3. Zayıf davranışlar

- 7, 13, 18, 22 gibi keyfi değerler
- bir ekranda başka, diğerinde başka spacing mantığı
- component içi spacing ile layout spacing’in birbirine karışması

---

# 23. Border / Radius / Surface Politikası

## 23.1. Kural

Surface dili merkezi olmalıdır.

## 23.2. Düşünülmesi gerekenler

- border visibility
- border weight
- radius system
- surface layering
- elevation/shadow mantığı
- interactive container tonları

## 23.3. Neden kritik?

Bu proje görsel dil konusunda keyfiliği reddediyor.  
Surface dili ürün karakterini taşıyan ana eksenlerden biridir.

## 23.4. Zayıf davranışlar

- component bazında rastgele radius
- kartların bazısında shadow, bazısında border, bazısında hiçbiri
- raw style ile surface karakterini bozmak

---

# 24. Dark Mode / Contrast Politikası

## 24.1. Kural

Dark mode yalnızca palette invert etmek değildir.  
Semantic roles yeniden düşünülmelidir.

## 24.2. Düşünülmesi gerekenler

- text contrast
- border visibility
- subtle surface ayrışması
- disabled state görünürlüğü
- feedback colors
- focus/active ring visibility
- overlay/backdrop davranışı

## 24.3. Zayıf davranışlar

- light theme token’larını koyulaştırıp geçmek
- border’ların karanlıkta kaybolması
- error/success renklerinin yalnızca hue ile ayrılması
- contrast’ı görsel zevk adına düşürmek

---

# 25. Accessibility ve Styling İlişkisi

## 25.1. Styling neden a11y konusudur?

Çünkü:
- contrast
- state visibility
- focus ring
- touch target perception
- disabled/invalid affordance
doğrudan styling ile ilişkilidir.

## 25.2. Kural

Styling kararı verilirken şu a11y alanları düşünülmelidir:
- focus visibility
- color-only meaning yasağı
- contrast
- error readability
- helper visibility
- hit area algısı
- reduced motion uyumu

---

# 26. HIG ve Styling İlişkisi

## 26.1. Kural

Mobile styling implementation, Apple HIG ile çelişen keyfi görsel davranışlar üretmemelidir.

## 26.2. Ne anlama gelir?

- touch targets göz ardı edilemez
- selected/focus/pressed feedback silik bırakılamaz
- safe area-aware surfaces styling’in parçasıdır
- form field visuals native ergonomiyi bozacak kadar keyfi olamaz

## 26.3. Sonuç

Styling runtime kararı, HIG enforcement stratejisinin teknik taşıyıcısıdır.

---

# 27. Reusable Components ve Styling İlişkisi

## 27.1. Kural

Reusable component API’leri style override çöplüğüne dönüşmemelidir.

## 27.2. Doğru model

Component:
- variant alır
- semantic intent alır
- controlled slots veya constrained customization alabilir
- ama herkese sınırsız raw class/style override vermez

## 27.3. Neden?

Çünkü sınırsız override:
- DS’yi delmek için resmi kanal olur
- görsel drift’i hızlandırır
- review ve testing’i zorlaştırır

---

# 28. Screen-Level Styling Politikası

## 28.1. Kural

Screen implementasyonu component ve pattern ağırlıklı olmalıdır.  
Screen’ler raw stil üretim yeri olmamalıdır.

## 28.2. Ne yapılabilir?

- layout composition
- semantic spacing composition
- screen-specific arrangement
- pattern assembly

## 28.3. Ne yapılmamalı?

- her screen’de aynı visual rules’ü yeniden yazmak
- screen bazında palette seçmek
- DS dışı yüzey stilleri icat etmek
- component içi kararları screen’de override etmek

---

# 29. Theming ve Persistence İlişkisi

## 29.1. Kural

Theme preference client-owned preference state olabilir.  
Ama theme implementation component-level local kararlarla değil, runtime semantic mapping ile çalışmalıdır.

## 29.2. Sonuç

- theme state store’da olabilir
- ama theme application styling system üzerinden olur
- “if dark then class string else başka string” kaosu kabul edilmez

---

# 30. Testing ve Audit Üzerindeki Etki

Bu ADR test ve audit açısından şu sonuçları doğurur:

1. Reusable component variant/state matrix test ve visual proof konusu olur
2. Dark/light semantic correctness audit konusu olur
3. Raw utility/raw style kaçakları lint/audit konusu olur
4. Focus/error/disabled/selected styling görünürlüğü test/audit konusu olur
5. Escape hatch kullanımı review ve audit konusu olur
6. Web/mobile styling parity implementation değil, design/behavior düzeyinde denetlenir

---

# 31. Repo Yapısı Üzerindeki Etki

Bu ADR şu topolojik sonuçları doğurur:

- shared tokens package zorunlu hale gelir
- semantic token mapping katmanı açık konumlanmalıdır
- reusable UI package styling runtime ile uyumlu tasarlanmalıdır
- web ve mobile app’ler kendi platform binding’lerini yaparken shared styling otoritesini bypass etmemelidir
- style helpers ve variant utilities kontrollü yerde yaşamalıdır

Bu nedenle `21-repo-structure-spec.md` ve `22-design-tokens-spec.md` bu ADR ile hizalanmalıdır.

---

# 32. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası contributor ve reviewer şu soruları sormalıdır:

1. Bu stil kararı hangi token veya semantic role’a dayanıyor?
2. Burada raw color/raw spacing/raw radius kaçışı var mı?
3. Bu component neden raw class/style override istiyor?
4. Escape hatch gerçekten gerekli mi?
5. Variant sistemi açık ve sistemik mi?
6. Dark mode ve contrast etkisi düşünüldü mü?
7. Focus/pressed/disabled/error state görünürlüğü yeterli mi?
8. Web ve mobile görsel dili bu kararla ayrışıyor mu?
9. Bu screen component assembly mi yapıyor, yoksa stil icat mı ediyor?
10. Bu değişiklik DS’yi güçlendiriyor mu, deliyor mu?

---

# 33. Neden styled-components / emotion Seçilmedi?

## 33.1. Kötü oldukları için değil

Bu araçlar belirli projelerde güçlü olabilir.  
Ama bu boilerplate için canonical seçim değildir.

## 33.2. Nedenleri

- token kaçaklarını daha görünmez hale getirebilirler
- raw style logic component içine daha kolay sızabilir
- web/mobile ortak consumption mental modelini zayıflatabilirler
- DS governance açısından daha serbest ve dolayısıyla daha riskli yüzey yaratabilirler
- utility + token discipline ile elde edilecek standardizasyona göre daha dağınık kullanım teşvik edebilirler

## 33.3. Sonuç

styled-components / emotion canonical baseline olarak reddedilmiştir.

---

# 34. Neden CSS Modules / Plain CSS + RN StyleSheet Seçilmedi?

## 34.1. Gerekçe

Bu kombinasyon teknik olarak mümkündür.  
Ama bu boilerplate’in hedefleri açısından şu sorunları üretir:

- web ve mobile styling mental modeli ayrışır
- token consumption discipline’i iki platformda farklı sistemlerle kurulmak zorunda kalır
- DS enforcement karmaşıklaşır
- reusable cross-platform UI family düşüncesi zayıflar
- mobile taraf tekrar StyleSheet-first kültüre kayar

## 34.2. Sonuç

Bu yaklaşım canonical olarak reddedilmiştir.

---

# 35. Neden MUI / Chakra / Ağır Component Framework Yönü Seçilmedi?

## 35.1. Gerekçe

Bu boilerplate kendi design system otoritesini kurmak istiyor.  
Ağır hazır component framework’ler:
- kendi visual language’ini getirir
- abstraction ve API yüzeyini dikte eder
- mobile parity açısından yanlış beklenti oluşturur
- premium hissiyatı mevcut framework karakterine bağlayabilir

## 35.2. Sonuç

Hazır component framework-first yaklaşım canonical değildir.

---

# 36. Riskler

Bu kararın da riskleri vardır.

## 36.1. Tailwind / NativeWind yanlış kullanılırsa utility çöpü oluşabilir
Bu ciddi risktir.

## 36.2. Semantic token disiplini iyi kurulmazsa raw utility kaçağı başlar
Tool tek başına çözmez.

## 36.3. NativeWind edge-case’lerde escape hatch ihtiyacı çıkabilir
Bu yüzden policy gerekir.

## 36.4. Web ve mobile arasında “aynı utility = aynı sonuç” yanılgısı oluşabilir
Bu da yanlış parity anlayışı üretir.

## 36.5. Theme mapping zayıf kurulursa dark mode yüzeyde kalır
Semantic layer olmadan kalite düşer.

---

# 37. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. Token ve semantic token spec’i netleştirilmeli
2. Raw utility ve arbitrary value politikası lint ile desteklenmeli
3. Style escape hatch annotation / waiver sistemi düşünülmeli
4. Reusable component variant contract’ları belgelenmeli
5. Dark/light visual audit checklist’i oluşturulmalı
6. Web/mobile token consumption examples hazırlanmalı
7. NativeWind / Tailwind kullanım sınırları contribution guide’a girmeli

---

# 38. Non-Goals

Bu ADR aşağıdakileri çözmez:

- every Tailwind config detail
- every NativeWind setup nuance
- exact folder names for styling utilities
- token naming convention’in tüm detayları
- Storybook theming implementation specifics
- animation library choice
- icon system exact implementation
- CSS reset / normalize detayları

Bu alanlar ilgili belge veya teknik setup aşamalarında kapanacaktır.

---

# 39. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. Web styling runtime canonical olarak Tailwind CSS olur
2. Mobile styling runtime canonical olarak NativeWind olur
3. Shared token source ve semantic token authority resmileşir
4. Component ve screen implementasyonunda raw style kararları sınırlandırılır
5. Theme runtime semantic mapping ile kurulur
6. Style escape hatch varsayılan değil, istisna olur
7. DS governance artık gerçek technical implementation layer ile bağlanmış olur

---

# 40. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- Tailwind / NativeWind kombinasyonu uzun vadeli bakımda sistematik sorun çıkarırsa
- design system enforcement bu modelle yeterince güçlü kurulamıyorsa
- platform parity yerine platform-specific styling sistemleri daha net avantaj sunarsa
- runtime theming ve token consumption bu modelle sürdürülemiyorsa

Bu seviyedeki değişiklik yeni ADR ve muhtemelen geniş component refactor’u gerektirir.

---

# 41. Kararın Kısa Hükmü

> Styling, tokens ve theming implementation için canonical karar: web’de Tailwind CSS, mobilde NativeWind kullanılacaktır; ancak bu araçlar utility özgürlüğü değil, shared token source ve semantic token disiplininin taşıyıcısı olarak çalışacaktır. Raw stil kararları, arbitrary values ve keyfi escape hatch kullanımı canonical değildir.

---

# 42. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Tailwind CSS ve NativeWind seçiminin kapsamı açıkça yazılmışsa
2. Token authority ve semantic token-first consumption net tanımlanmışsa
3. Web ve mobile theme runtime yaklaşımı görünür kılınmışsa
4. Raw utility/raw style/escape hatch politikaları açıklanmışsa
5. Component variant, state styling, a11y ve HIG ilişkisi kurulmuşsa
6. styled-components, CSS Modules + StyleSheet ve heavy component framework yönlerinin neden canonical seçilmediği açıklanmışsa
7. Riskler ve mitigations görünürse
8. Bu karar implementasyon öncesi kilitlenmiş styling baseline olarak kullanılabilecek netlikteyse

---

# 43. NativeWind 5.x Stable Readiness Kontrol Listesi

NativeWind 5.x şu anda candidate track statüsündedir (36-canonical-stack-decision.md). Periyodik olarak aşağıdaki kontrol listesi değerlendirilir:

## 43.1. Değerlendirme Kontrol Listesi

- [ ] **Stable release çıktı mı?** npm registry’de `nativewind@5.x.x` stable tag ile yayınlandı mı? (`next`, `beta`, `rc` tag’leri yeterli değildir)
- [ ] **Breaking change’ler mevcut token yapısını etkiliyor mu?** Mevcut `packages/design-tokens/` yapısı ve semantic token katmanı ile uyumlu mu? Token tüketim API’sında kırılma var mı?
- [ ] **Expo SDK 55 ile tam uyumluluk doğrulandı mı?** NativeWind 5.x + Expo SDK 55.x + React Native 0.83 kombinasyonu birlikte test edildi mi?
- [ ] **New Architecture (Fabric) uyumlu mu?** JSI tabanlı render pipeline ile sorunsuz çalışıyor mu? (ADR-018 referansı)
- [ ] **Tailwind CSS 4.x syntax ile %100 uyumlu mu?** Web’de Tailwind CSS 4.x ile kullanılan utility class’lar mobile’da aynı şekilde çalışıyor mu? Syntax farklılıkları var mı?
- [ ] **Migration guide mevcut mu?** NativeWind 4.x → 5.x geçişi için resmi migration guide yayınlandı mı? Breaking change listesi dokümante edildi mi?
- [ ] **Community adoption yeterli mi?** npm haftalık downloads trendi (en az 10K+), GitHub issues/PR aktivitesi, Discord/GitHub Discussions yanıt hızı makul mü?
- [ ] **Performans regresyonu yok mu?** NativeWind 5.x ile 4.x arasında render performansı karşılaştırması yapıldı mı?

## 43.2. Değerlendirme Periyodu

- **Rutin kontrol:** Her çeyrek (Ocak, Nisan, Temmuz, Ekim)
- **Tetiklenen kontrol:** Major NativeWind release veya RC yayınlandığında
- **Karar yetkisi:** Mobile lead veya architecture owner

## 43.3. Stable Geçiş Kararı

Kontrol listesinin tamamı ✅ olduğunda:
1. `38-version-compatibility-matrix.md` güncellenir
2. `37-dependency-policy.md`’de NativeWind versiyonu güncellenir
3. Migration planı oluşturulur ve zaman çizelgesi belirlenir
4. Pilot olarak 2-3 component NativeWind 5.x ile refactor edilir
5. Başarılıysa tam migration başlatılır

---

# 44. Design Token CI Validation Reçetesi

Token dosyalarının build aşamasında otomatik doğrulanması, design system tutarlılığının CI seviyesinde garanti altına alınmasını sağlar.

## 44.1. Naming Convention Kontrolü

Tüm token adları aşağıdaki kurallara uymalıdır:
- **Format:** kebab-case (ör. `color-primary`, `spacing-md`, `font-size-body`)
- **Semantic prefix zorunluluğu:** Her token ailesi kendi prefix’ini taşır:
  - Renkler: `color-*` (ör. `color-surface-primary`, `color-text-secondary`)
  - Spacing: `spacing-*` (ör. `spacing-xs`, `spacing-md`, `spacing-2xl`)
  - Tipografi: `font-*` (ör. `font-size-body`, `font-weight-bold`, `font-family-sans`)
  - Radius: `radius-*` (ör. `radius-sm`, `radius-full`)
  - Border: `border-*` (ör. `border-width-thin`, `border-color-subtle`)
- **Yasak pattern’ler:** Sayısal suffix olmadan (ör. `blue-500` gibi raw palette token’lar semantic katmanda kullanılmaz)

## 44.2. Kullanılmayan Token Tespiti

Kaynak kodda (`apps/`, `packages/ui/`) referansı olmayan token’lar tespit edilir ve uyarı üretilir. Bu kontrol:
- Token dosyalarındaki her token adını çıkarır
- Tüm kaynak dosyalarda (tsx, ts, css) bu token adını arar
- Referansı olmayan token’lar "potentially unused" olarak raporlanır
- **Aksiyon:** Uyarı seviyesindedir (error değil); gerçekten gereksiz olan token’lar temizlenir, henüz kullanılmamış ama planlanmış token’lar annotation ile işaretlenir

## 44.3. Eksik Token Kontrolü (Light/Dark Parity)

Light mode’da tanımlı olan her semantic token dark mode’da da tanımlı olmalıdır:
- Light token set ile dark token set karşılaştırılır
- Light’ta var ama dark’ta yok → **CI error** (dark mode’da undefined fallback riski)
- Dark’ta var ama light’ta yok → **CI warning** (temizlenmesi gereken orphan token)

## 44.4. Token Değer Aralığı Kontrolü

Token değerlerinin makul aralıklarda olup olmadığı kontrol edilir:
- Spacing: 0-128 (px veya rem karşılığı)
- Font-size: 10-64 (px veya rem karşılığı)
- Border-width: 0-8
- Radius: 0-9999 (full radius için büyük değer kabul edilir)
- Opacity: 0-1
- Z-index: 0-9999

Aralık dışı değerler **CI warning** üretir.

## 44.5. Cross-Reference Kontrolü

Bir token başka bir token’a referans veriyorsa (alias/reference token), hedef token’ın var olup olmadığı kontrol edilir. Kırık referans **CI error** üretir.

## 44.6. CI Entegrasyonu

```bash
pnpm lint:tokens
```

Bu komut yukarıdaki tüm kontrolleri çalıştırır ve PR’da rapor üretir. Error varsa PR merge edilemez; warning’ler review sırasında değerlendirilir.

---

# 45. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te styling, keyfi class veya style object üretimiyle kurulmayacaktır. Web tarafında Tailwind CSS, mobil tarafında NativeWind kullanılacak; ama asıl karar otoritesi shared token source ve semantic token sistemidir. Utility runtime yalnızca taşıyıcıdır; görsel ve theming disiplini ise token-first, semantic-role-based ve governance ile enforce edilen yapı üzerinden kurulacaktır.
