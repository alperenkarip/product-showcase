# ADR-008 — Testing Stack

## Doküman Kimliği

- **ADR ID:** ADR-008
- **Başlık:** Testing Stack
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational verification, tooling and quality enforcement decision
- **Karar alanı:** Unit/component/integration/E2E test araçları, test runner ayrımı, visual verification yaklaşımı, manual audit ile otomasyonun sınırı, cross-platform test stack topolojisi
- **İlgili üst belgeler:**
  - `14-testing-strategy.md`
  - `15-quality-gates-and-ci-rules.md`
  - `12-accessibility-standard.md`
  - `13-performance-standard.md`
  - `24-motion-and-interaction-standard.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `33-visual-implementation-contract.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `29-release-and-versioning-rules.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `34-hig-enforcement-strategy.md`
  - `38-version-compatibility-matrix.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında testing stack için aşağıdaki karar kabul edilmiştir:

- **Web-side unit / selected integration runner:** Vitest
- **React Native / mobile-side component and integration runner:** Jest
- **Behavior-oriented UI testing yaklaşımı:** Testing Library ailesi
- **Web E2E aracı:** Playwright
- **Mobile E2E yaklaşımı:** v1 canonical baseline içinde karar alanı açık bırakılır; zorunlu ve nihai mobile E2E aracı bu ADR ile kilitlenmez
- **Visual verification yaklaşımı:** Manual audit + targeted visual proof; gerektiğinde selected visual regression
- **Accessibility verification yaklaşımı:** Static checks + component/integration checks + manual audit kombinasyonu
- **Canonical ilke:** Tek araçla her test katmanını çözmeye çalışmak yerine, risk ve runtime gerçeğine uygun araç seçimi yapılır
- **En kritik tamamlayıcı ilke:** Otomatik testler, manual audit’in yerini almaz; ama onsuz kalite standardı eksik kalır

Bu ADR’nin ana hükmü şudur:

> Bu boilerplate’te test stack, “tek test runner ve tek yaklaşım her şeyi çözer” mantığıyla kurulmayacaktır. Web ve mobile runtime gerçekliği, UI contract testleri, feature orchestration testleri, E2E kritik akışları ve screenshot-faithful kalite ihtiyacı ayrı doğrulama katmanları gerektirir. Bu nedenle testing stack çok katmanlı ve amaç odaklı olacaktır.

---

# 2. Problem Tanımı

Test stratejisi dokümanda yazılı olsa bile test stack yanlış seçilirse veya eksik kilitlenirse şu sorunlar oluşur:

- ekip her alan için farklı test aracı seçmeye başlar
- unit, component, integration ve E2E ayrımı pratikte bulanıklaşır
- web ve mobile testleri farklı kalite seviyelerinde ilerler
- visual kalite “bir ara bakarız” seviyesine düşer
- component testleri snapshot çöplüğüne döner
- mobile taraf testten kaçar, web taraf ise aşırı testlenir
- CI ya çok yavaşlar ya da anlamsız boşalır
- manual audit gereken alanlar yanlışlıkla tamamen otomatik teste havale edilir
- flaky test kültürü oluşur
- test coverage var ama güven yok durumu ortaya çıkar

Bu yüzden testing stack kararı yalnızca “hangi test framework?” sorusu değildir.  
Asıl karar şudur:

> Hangi kalite riski, hangi test katmanı ve hangi araç ile doğrulanacak; hangi alanlar otomasyonla, hangi alanlar kontrollü manual audit ile kapanacak?

Bu ADR tam olarak bunu kilitler.

---

# 3. Bağlam

Bu boilerplate’in testing tarafında taşıdığı zorunluluklar şunlardır:

1. Risk-temelli doğrulama
2. Web ve mobile için uygun ama dağılmayan test stack
3. Reusable component contract’larının güvence altına alınması
4. Domain logic ile UI/feature orchestration testlerinin ayrılması
5. Accessibility ve visual quality’nin test stratejisinden dışlanmaması
6. CI performansını tamamen öldürmeyen ama kaliteyi koruyan seçimler
7. Manual audit ile otomasyonun rol ayrımının net olması
8. Cross-platform parity riskinin görünür doğrulanması
9. Monorepo ve package yapısına uyum
10. Documentation-first ve DoD ile bağlı gerçek bir doğrulama omurgası

Bu bağlamda testing stack şu iki uçtan da kaçınmalıdır:

- tek araçla her şeyi çözmeye çalışmak
- her ekip/alan kendi test aracını seçsin kaosu

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Web runtime ile uyum**
2. **Mobile runtime ile uyum**
3. **Behavior-oriented testing desteği**
4. **TypeScript ve modern tooling uyumu**
5. **Component ve feature integration test uygunluğu**
6. **E2E stabilitesi**
7. **CI performansı ve bakım maliyeti**
8. **Developer ergonomisi**
9. **Flaky riskini yönetebilme**
10. **Visual / a11y verification ile birlikte çalışabilme**
11. **Monorepo / workspace uyumu**
12. **Ekosistem olgunluğu**

---

# 5. Seçilen Karar

Bu boilerplate için canonical testing stack şu şekilde kabul edilmiştir:

## 5.1. Web-side unit ve selected integration
- **Vitest**

## 5.2. Mobile-side component ve selected integration
- **Jest**

## 5.3. UI interaction / behavior testing
- **Testing Library family**

## 5.4. Web E2E
- **Playwright**

## 5.5. Mobile E2E
- **Bu ADR ile nihai araç kilitlenmez**
- mobile E2E, mobile runtime/CI gerçekliği ayrıca doğrulandıktan sonra ayrı teknik kararla netleştirilir

## 5.6. Visual verification
- **Manual audit zorunlu**
- **Targeted screenshot / state proof zorunlu bağlamsal kanıt**
- **Selected visual regression opsiyonel ama güçlü aday**

---

# 6. Neden Tek Araçla Gitmiyoruz?

Bu ADR’nin en kritik cevaplarından biri budur.

## 6.1. Çünkü test katmanları aynı problem değildir

Aşağıdakiler aynı şey değildir:

- saf domain calculation
- reusable button contract
- complex form submit orchestration
- auth redirect flow
- screenshot-faithful spacing doğruluğu
- screen reader deneyimi
- mobile gesture hissi

Bunları tek araçla “bir şekilde” test etmeye çalışmak sahte güven üretir.

## 6.2. Çünkü web ve mobile runtime gerçeği farklıdır

- web DOM ve browser automation realitesi vardır
- mobile React Native render ve native runtime farkı vardır
- E2E stabilitesi ve bakım maliyeti iki platformda aynı değildir

## 6.3. Çünkü otomasyon her kalite alanını kapsamaz

Bu proje yalnızca functional correctness değil:
- premium UX
- visual fidelity
- HIG tonu
- state visibility
- motion hissi
de hedefliyor.

Bunların bir kısmı manual audit ister.

---

# 7. Web-side Unit / Selected Integration Kararı: Vitest

## 7.1. Karar
Web tarafında unit ve uygun selected integration senaryoları için canonical runner:
- **Vitest**

## 7.2. Neden Vitest?

### 7.2.1. Modern Vite ekosistemi ile doğal uyum
Web runtime zaten React + Vite olduğundan Vitest çok doğal seçimdir.

### 7.2.2. Hızlı local feedback
Boilerplate’in documentation-first sonrası implementasyon döngüsünde hızlı geri bildirim kritiktir.

### 7.2.3. TypeScript dostu yapı
Modern TS projeleri için güçlü ergonomi sağlar.

### 7.2.4. Component ve utility katmanları için güçlü pratiklik
Domain helpers, selectors, mappers ve selected web-side component/integration testleri için iyi temeldir.

### 7.2.5. Browser Mode ve görsel yardımcı yüzeyler
Vitest 4 hattındaki Browser Mode / component-browser test kabiliyeti, tam E2E'ye çıkmadan belirli browser-behavior doğrulamaları için güçlü adaydır. Ancak bu boilerplate'te varsayılan olarak her web testi browser-mode'a taşınmaz; yalnızca DOM/runtime farkı önemli ise kontrollü biçimde kullanılır.

## 7.3. Bu karar neyi kapsamaz?

- Mobile-side React Native testlerini
- Full browser E2E’yi
- Visual fidelity audit’ini
- HIG benzeri UX niteliğini

---

# 8. Mobile-side Component / Selected Integration Kararı: Jest

## 8.1. Karar
React Native tarafında canonical test runner:
- **Jest**

## 8.2. Neden Jest?

### 8.2.1. React Native ekosistem gerçekliği
React Native test pratiğinde Jest hâlâ çok güçlü ve doğal ekosistem karşılığına sahiptir.

### 8.2.2. Mobile-side tooling uyumu
Component ve selected integration testlerinde yaygın ve pratik bir temel sunar.

### 8.2.3. Ecosystem maturity
Mocking, test environment, component harness ve RN community knowledge açısından güçlüdür.

## 8.3. Neden web ve mobile için tek runner seçilmiyor?

Çünkü web runtime ve RN runtime aynı test topolojisini paylaşmak zorunda değildir.  
Aşırı birleştirme bazen sadelik değil, yanlış soyutlama üretir.

## 8.4. Kural

Tek runner kutsallığı bu boilerplate’te amaç değildir.  
Doğru katman için doğru tool seçimi amaçtır.

---

# 9. UI Interaction Testing Kararı: Testing Library

## 9.1. Karar
Reusable UI ve ekran davranışlarını kullanıcıya yakın şekilde doğrulamak için:
- **Testing Library ailesi**
canonical kabul edilir.

## 9.2. Neden?

Çünkü Testing Library:
- implementation detail yerine behavior’a odaklanır
- DOM/node yapısına değil kullanıcıya yakın etkileşime yaklaşır
- field, button, selection, error/helper, disabled/loading gibi durumların doğrulanmasında güçlüdür

## 9.3. Bu karar neden çok kritik?

Bu boilerplate reusable component ve UI contract kalitesini çok ciddiye alıyor.  
Testing Library bu alan için doğru zihinsel modeli teşvik eder.

## 9.4. Ne yapılmamalı?

- gereksiz internal markup odaklı testler
- CSS class detaylarını davranış testi sanmak
- raw snapshot’ı behavior testi yerine koymak

---

# 10. Web E2E Kararı: Playwright

## 10.1. Karar
Web E2E için canonical araç:
- **Playwright**

## 10.2. Neden Playwright?

### 10.2.1. Modern browser automation gücü
Gerçek kullanıcı yolculukları için güçlü ve olgun çözümdür.

### 10.2.2. Reliability
Modern web otomasyonunda güçlü bir standarttır.

### 10.2.3. Routing, auth, form, navigation, multi-step flow gibi kritik web akışlarında güçlüdür
Boilerplate’in en çok ihtiyaç duyduğu alanlarla doğal örtüşür.

### 10.2.4. Visual and interaction proof ile uyum
Screenshot, trace ve test debug deneyimi açısından da güçlüdür.

## 10.3. Kural

Playwright her ekranı test etmek için değil, yüksek değerli kritik journeys için kullanılacaktır.

---

# 11. Mobile E2E Kararı Neden Bu ADR’de Tam Kilitlenmiyor?

Bu nokta özellikle açıklanmalıdır.

## 11.1. Neden açık bırakılıyor?

Mobile E2E aracı seçimi yalnızca test tercihi değildir.  
Aşağıdaki alanlarla doğrudan bağlıdır:

- Expo workflow gerçekliği
- iOS/Android CI stabilitesi
- build matrix maliyeti
- device/emulator orchestration
- bakım yükü
- flaky risk seviyesi

Bu yüzden acele bir canonical kilit yanlış olabilir.

## 11.2. Bu boşluk ne anlama gelmez?

- mobile E2E gereksizdir
- mobile doğrulama yalnızca manual yapılır
- mobile kalite ikinci plandadır

Bunların hiçbiri doğru değildir.

## 11.3. Doğru yorum

Mobile E2E kararı önemlidir ama tool lock, runtime ve CI gerçekliği ile birlikte daha teknik doğrulanmalıdır.

## 11.4. Şu anki canonical durum

- mobile component/integration testing var
- manual audit var
- parity verification var
- selected critical flows için gelecekte dedicated mobile E2E kararı açılacaktır

## 11.5. Constrained Open Seçim Alanı

Mobile E2E tool seçimi bu ADR'de tam kilitlenmemekle birlikte, aday değerlendirmesi şu şekilde daraltılmıştır:

### Aday 1: Maestro (Shopify)
- Expo workflow ile uyumlu
- YAML tabanlı test tanımı
- CI entegrasyonu görece basit
- Dezavantaj: topluluk küçük, breaking change riski

### Aday 2: Detox (Wix)
- React Native ekosisteminde olgun
- CI entegrasyonu iyi
- Dezavantaj: Expo managed workflow desteği sınırlı, native build gerektirir

### Aday 3: Playwright Mobile (Microsoft)
- Web E2E ile aynı API
- Cross-platform tutarlılık
- Dezavantaj: React Native mobile native testing desteği henüz deneysel

### Seçim zamanlaması
Bu karar vertical slice fazında (20-initial-implementation-checklist.md Faz Q) kapatılmalıdır. O noktada:
- Expo SDK 55.x ile her adayın uyumu doğrulanmış olacaktır
- CI pipeline kurulu olacaktır
- İlk gerçek user flow implementasyonu test senaryosu sağlayacaktır

Bu alan constrained open'dır; yukarıdaki üç aday dışında yeni araç değerlendirilmez.

---

# 12. Visual Verification Kararı

## 12.1. En kritik ilke

> Visual quality otomatik test var diye kapanmış sayılmaz.

## 12.2. Canonical yaklaşım

- manual audit zorunlu
- screenshot / before-after proof zorunlu bağlamsal kanıt olabilir
- selected visual regression kontrollü biçimde eklenebilir

## 12.3. Neden?

Bu proje:
- spacing doğruluğu
- hierarchy
- component state görünürlüğü
- premium hissiyat
- screenshot-faithful implementation
hedefliyor.

Bu alanların tamamını snapshot veya DOM assertions ile çözmek imkânsızdır.

## 12.4. Kural

Visual verification test stratejisinin dışı değil; tamamlayıcı zorunlu parçasıdır.

---

# 13. Accessibility Verification Kararı

## 13.1. Canonical yaklaşım

Accessibility için tek katmanlı çözüm kabul edilmez.  
Üçlü yaklaşım gerekir:

1. static checks
2. component / integration checks
3. manual audit

## 13.2. Neden?

Çünkü:
- bazı semantics otomatik doğrulanabilir
- bazı focus ve flow davranışları gerçek deneyim ister
- screen reader ve dynamic type gibi alanlar yalnızca lint ile kapanmaz

## 13.3. Sonuç

A11y test stack’in dışında değil; onun gömülü parçasıdır.

---

# 14. Test Katmanı → Araç Eşleşmesi

Bu ADR’nin pratikte kullanılabilir olması için şu eşleşme nettir:

## 14.1. Pure logic / domain / selectors / mappers
- Vitest veya Jest bağlama göre
- asıl ilke: hızlı, deterministic, isolated

## 14.2. Reusable web components
- Vitest + Testing Library

## 14.3. Reusable mobile components
- Jest + Testing Library

## 14.4. Feature orchestration (web)
- Vitest + Testing Library, gerektiğinde integration düzeyi

## 14.5. Feature orchestration (mobile)
- Jest + Testing Library, selected integration düzeyi

## 14.6. Critical web user journeys
- Playwright

## 14.7. Critical mobile user journeys
- geçici olarak manual audit + selected integration; future dedicated mobile E2E decision

## 14.8. Visual fidelity
- manual audit + targeted visual proof
- selected visual regression where justified

## 14.9. A11y semantics
- static + component/integration + manual audit

---

# 15. Snapshot Politikası

## 15.1. Kural

Snapshot test canonical ana strateji değildir.

## 15.2. Neden?

Çünkü snapshot çoğu zaman:
- büyük diff gürültüsü üretir
- reviewer’ın gerçekten ne değiştiğini anlamasını zorlaştırır
- behavior yerine markup kopyası saklar
- coverage’i şişirir ama güven vermez

## 15.3. Snapshot ne zaman meşru olabilir?

- çok kontrollü küçük output contracts
- stable output olan belirli helper/formatter benzeri alanlar
- bilinçli ve sınırlı kullanım

## 15.4. Snapshot ne zaman zayıftır?

- her component için dev snapshot
- state matrix’i snapshot ile kapatmak
- behavior testi yerine snapshot koymak

---

# 16. Mocking Politikası

## 16.1. Kural

Mocking gereklidir ama sınırsız değildir.

## 16.2. Neden?

Çünkü testlerin:
- izole
- deterministik
- odaklı
olması gerekir.

## 16.3. Ama risk nedir?

Aşırı mock:
- gerçek behavior’ı gizler
- integration sorunlarını saklar
- implementation detail’e bağımlı test üretir
- sahte güven verir

## 16.4. Canonical yaklaşım

- unit düzeyinde gerektiği kadar mock
- integration düzeyinde gerçek davranışa daha yakın test
- E2E’de gerçek kullanıcı yolculuğu odaklı yaklaşım

---

# 17. Flaky Test Politikası

## 17.1. En kritik ilke

> Flaky test kalite aracı değil, kalite erozyonudur.

## 17.2. Kural

Flaky test:
- normal kabul edilmez
- “arada oluyor” diye yaşatılmaz
- rerun kültürüyle meşrulaştırılmaz
- gerekirse karantinaya alınır ama görünür takip açılır

## 17.3. Neden?

Çünkü flaky test:
- CI güvenini düşürür
- gerçek failure’ın önemini azaltır
- ekibi test sinyaline karşı duyarsızlaştırır

---

# 18. Coverage Politikası

## 18.1. Kural

Coverage yardımcı metriktir; amaç değildir.

## 18.2. Neden?

Çünkü yüksek coverage şu durumlarda anlamsız olabilir:
- yanlış şeyler testlenmişse
- kritik flows boş bırakılmışsa
- snapshot veya trivial render testleri şişmişse

## 18.3. Doğru soru

“Coverage kaç?” değil,  
“Yüksek riskli davranışlar gerçekten korunuyor mu?” sorusu esas alınır.

---

# 19. Web ve Mobile Arasında Test Parity Politikası

## 19.1. Kural

Aynı dosya ve aynı runner zorunlu değildir.  
Ama riskli davranışlar iki platformda da doğrulanmalıdır.

## 19.2. Ne ortak olabilir?

- shared domain tests
- validation schema tests
- some cross-platform logic tests
- parity-oriented behavior checklists

## 19.3. Ne ayrı olabilir?

- web browser flows
- mobile navigation ergonomisi
- keyboard vs touch dynamics
- layout density specific assertions

## 19.4. Sonuç

Implementation parity değil, quality parity hedeflenir.

---

# 20. Manual Audit’in Resmi Statüsü

## 20.1. Kural

Manual audit bu boilerplate’te “ekstra güzellik” değil, resmi kalite katmanıdır.

## 20.2. Hangi alanlarda özellikle zorunlu?

- screenshot-faithful UI
- motion quality
- premium feel
- parity değerlendirmesi
- dense data surfaces
- HIG tone
- mobile ergonomi
- screen reader / focus experience
- some dark mode / contrast surfaces

## 20.3. Neden?

Çünkü bunların çoğu otomasyonla tam kapanmaz.

---

# 21. Storybook / Component Lab ile İlişkisi

## 21.1. Kural

Testing stack component lab’dan bağımsız düşünülmez.

## 21.2. Ne anlama gelir?

Reusable component’ler için:
- isolated inspection
- state matrix gözlemi
- visual drift fark etme
- contract anlatımı
önemlidir.

## 21.3. Sonuç

Storybook bu boilerplate'te gevşek bir fikir değil, **Storybook 10.x + Storybook Test (Vitest addon)** hattı ile önerilen web component lab yüzeyidir. Storybook tek başına test runner değildir; ama story'leri browser-mode testlerine, interaction senaryolarına ve coverage görünürlüğüne bağlayabildiği için test ve audit ekosisteminin güçlü tamamlayıcısıdır.

---

# 22. CI Üzerindeki Etki

Bu karar şu CI sonuçlarını doğurur:

1. Web-side fast tests ayrı işletilebilir
2. Mobile-side RN tests ayrı işletilebilir
3. Web E2E ayrı stage’de koşabilir
4. Manual audit gereken işler CI ile tam kapanmış sayılmaz
5. Flaky ve slow suites görünür şekilde yönetilmelidir
6. Relevant test selection mantığı contribution ve gate belgeleriyle bağlanmalıdır

---

# 23. Repo Yapısı Üzerindeki Etki

Bu ADR şu topolojik sonuçları doğurur:

- web test utilities ile mobile test utilities aynı yere kör yığılmaz
- shared pure test helpers ayrı yaşam alanı bulabilir
- component tests ve feature tests fiziksel olarak anlamlı ayrılabilir
- E2E suite’leri app-level ownership ile kurgulanmalıdır
- audit/visual proof kanıt üretimi repo içinde düzenli yer bulmalıdır

Bu nedenle `21-repo-structure-spec.md` ve `29-release-and-versioning-rules.md` bu ADR ile hizalanmalıdır.

---

# 24. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası contributor ve reviewer şu soruları sormalıdır:

1. Bu değişikliğin risk seviyesi ne?
2. Bu risk için doğru test katmanı seçildi mi?
3. Snapshot ile geçiştirilmiş bir alan var mı?
4. Manual audit gerekip atlanan alan var mı?
5. Web ve mobile kalite dengesi bozulmuş mu?
6. Bu test gerçekten behavior mı doğruluyor, yoksa implementation detail mi?
7. Flaky potansiyel var mı?
8. A11y ve visual quality için yeterli kanıt var mı?
9. E2E gerçekten gerekli miydi, yoksa integration yeterli miydi?
10. Test stack kararı ihlal edilmiş mi?

---

# 25. Neden Tek Başına Jest Seçilmedi?

## 25.1. Gerekçe

Jest uzun süredir yaygın bir seçimdir.  
Ama bu boilerplate’in canonical yapısında web runtime Vite tabanlıdır.  
Bu nedenle web-side hızlı test ergonomisi için Vitest daha doğal seçimdir.

## 25.2. Sonuç

Jest tamamen reddedilmemiştir.  
Mobile-side RN gerçekliği için canonical yerini korur.  
Ama tüm stack için tek araç olarak seçilmez.

---

# 26. Neden Tek Başına Vitest Seçilmedi?

## 26.1. Gerekçe

Vitest web tarafında güçlüdür.  
Ama React Native ekosisteminin test gerçekliği ve alışılmış destek yüzeyi açısından Jest daha güvenilir canonical tercihtir.

## 26.2. Sonuç

Vitest tüm test dünyasının tek sahibi yapılmamıştır.

---

# 27. Neden Cypress Seçilmedi?

## 27.1. Gerekçe

Cypress güçlü olabilir.  
Ama canonical web E2E baseline için Playwright şu alanlarda daha güçlü değerlendirilmiştir:

- modern browser automation esnekliği
- trace/debug gücü
- multi-browser yeteneği
- daha uygun canonical fit

## 27.2. Sonuç

Cypress canonical seçilmemiştir.

---

# 28. Neden Mobile E2E Aracı Şimdilik Kilitlenmedi?

Bu konu tekrar açık ve net yazılmalıdır.

## 28.1. Çünkü yanlış erken kilit pahalı olur
Tool seçimi yalnızca feature değil; CI ve runtime stratejisi kararıdır.

## 28.2. Çünkü Expo gerçekliği dikkate alınmalıdır
Expo-first yaklaşım ile mobile E2E tool kararı birlikte değerlendirilmelidir.

## 28.3. Çünkü test stack’in geri kalanını kilitlemek daha önceliklidir
Mobile E2E önemlidir ama sırf liste tam görünsün diye acele kilitlenmez.

---

# 29. Riskler

Bu kararın da riskleri vardır.

## 29.1. Çift runner yapısı öğrenme maliyeti yaratabilir
Bu gerçek bir risktir.

## 29.2. Web ve mobile test kültürü ayrışabilir
Doğru governance olmazsa kalite seviyesi iki platformda farklılaşabilir.

## 29.3. Manual audit yanlış yorumlanırsa ekip test yazmaktan kaçabilir
Bu yüzden “audit = test yerine geçer” algısı engellenmelidir.

## 29.4. Visual verification yeterince sistemik kurulmazsa tekrar göz kararı kültürüne düşülebilir
Bu da risktir.

## 29.5. Mobile E2E kararı açık kaldığı için bazı ekipler bunu sürekli erteleyebilir
Bu da dikkat edilmesi gereken gerçek risktir.

---

# 30. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. Test katmanı → araç matrisi contribution guide’a yazılmalı
2. Relevant test selection policy açık olmalı
3. Snapshot ve mocking misuse kuralları görünür olmalı
4. Manual audit zorunlu alanları DoD’ye bağlanmalı
5. Web ve mobile parity audit checklist’e eklenmeli
6. Mobile E2E için ayrı teknik karar backlog’da açık görünmeli
7. Flaky test yönetim policy’si resmi hale getirilmeli

---

# 31. Non-Goals

Bu ADR aşağıdakileri çözmez:

- exact directory names for every test file
- exact coverage thresholds
- every mock utility implementation
- mobile E2E exact tool lock
- visual regression tool exact choice
- CI YAML configuration details

Bu alanlar ilgili setup ve policy belgelerinde kapanacaktır.

---

# 32. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. Web-side unit/selected integration için Vitest canonical olur
2. Mobile-side component/selected integration için Jest canonical olur
3. UI behavior tests Testing Library zihinsel modeliyle yazılır
4. Web E2E için Playwright canonical olur
5. Manual audit resmi kalite katmanı olarak kabul edilir
6. Snapshot-first veya one-runner-fits-all yaklaşımı canonical olarak reddedilir
7. Visual fidelity ve a11y artık testing stack tartışmasının resmi parçası olur

---

# 33. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- Vite/web testing ekosisteminde köklü değişim olursa
- RN tarafında Jest canonical tercihini zayıflatan ciddi teknik değişim yaşanırsa
- web E2E tarafında Playwright yerine belirgin daha güçlü stratejik aday oluşursa
- mobile E2E kararı için runtime ve CI gerçekliği yeni zorunluluk doğurursa
- testing stack bakım maliyeti faydayı aşarsa

Bu seviyedeki değişiklik yeni ADR ve muhtemelen CI/refactor etkisi gerektirir.

---

# 34. Kararın Kısa Hükmü

> Testing stack için canonical karar: web-side hızlı doğrulama Vitest ile, React Native tarafı Jest ile, UI behavior doğrulaması Testing Library ile, kritik web journeys Playwright ile ve görsel/HIG/a11y niteliği manual audit + targeted visual proof ile yönetilecektir. Tek araçla her şeyi çözme yaklaşımı canonical değildir.

---

# 35. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Web, mobile, UI interaction ve E2E için araç seçimi açıkça yazılmışsa
2. Neden tek araç yaklaşımının seçilmediği açıklanmışsa
3. Manual audit ve visual verification’ın resmi rolü net tanımlanmışsa
4. Snapshot, mocking, flaky test ve coverage yaklaşımı görünür kılınmışsa
5. Mobile E2E alanının neden bilinçli açık bırakıldığı net işaretlenmişse
6. Riskler ve mitigations görünürse
7. Bu karar implementasyon öncesi kilitlenmiş testing baseline olarak kullanılabilecek netlikteyse

---

# 36. Visual Regression Test Stratejisi

Component’lerin piksel düzeyinde görsel regresyon testi, design system tutarlılığının otomatik olarak korunmasını sağlar.

## 36.1. Araç Seçimi

### Canonical Tercih: Storybook + Chromatic

Storybook zaten canonical component lab olarak seçilmiştir (Bölüm 21). Chromatic, Storybook ile doğal entegrasyon sunarak visual regression test’i en düşük friction ile ekler:

- Her story otomatik olarak screenshot alınır
- PR’da değişen component’lerin visual diff’i görsel olarak raporlanır
- Onay gerektiren değişiklikler review ekibine sunulur
- Baseline yönetimi otomatiktir

### Alternatifler

- **Percy (BrowserStack):** Storybook entegrasyonu var, daha geniş browser matrix
- **Playwright screenshot comparison:** Mevcut E2E stack ile entegre, ek tool gerektirmez ama story-level granularity zor

## 36.2. Kapsam

- **Shared UI component’ler:** `packages/ui/` altındaki tüm component’lerin her varyantı (size, state, theme)
- **Varyant matrisi:** Primary/Secondary/Destructive intent × Small/Medium/Large size × Light/Dark theme × Default/Hover/Focus/Disabled state
- **Critical screens:** Onboarding, login, ana dashboard gibi yüksek etkili ekranlar (selective)

## 36.3. Tolerans Eşiği

- **%0.1 piksel farkı** kabul edilir (anti-aliasing, sub-pixel rendering toleransı)
- Bu eşik üzerindeki farklar "değişiklik" olarak işaretlenir ve onay gerektirir
- Font rendering farkları (OS/browser kaynaklı) baseline güncelleme ile çözülür

## 36.4. CI Entegrasyonu

- Her PR’da değişen component’lerin visual diff raporu üretilir
- Onay gerektiren visual değişiklikler PR’da açıkça görünür
- Onaylanmadan merge yapılamaz (blocking check)
- Yalnızca değişen story’ler test edilir (incremental)

## 36.5. Mobile Visual Test

- Expo + Storybook React Native ile component snapshot’ları alınır
- Web parity kontrolü: Aynı component’in web ve mobile render’ı karşılaştırılır (behavior parity, piksel birebirlik beklenmez)
- Platform-specific visual farklar (safe area, native control render) tolere edilir

---

# 37. Test Isolation ve Paralellik Stratejisi

Test suite’lerinin hızlı, güvenilir ve birbirinden izole çalışması için strateji:

## 37.1. Vitest (Web)

- `--pool=threads` ile her test dosyası ayrı thread’de paralel çalışır
- Her test dosyası kendi izole ortamında çalışır; global state paylaşımı yoktur
- `beforeEach` / `afterEach` ile test-level cleanup zorunludur
- `vi.resetAllMocks()` her test sonrası otomatik çağrılır

## 37.2. Jest (Mobile)

- `--maxWorkers=50%` ile CPU kullanımı optimize edilir (CI’da tüm core’ları kullanmak diğer CI job’larını yavaşlatır)
- Her test dosyası ayrı worker process’te çalışır
- `jest.clearAllMocks()` her test sonrası otomatik çağrılır (`clearMocks: true` config)

## 37.3. Shared State Yasağı

- **Test dosyaları arası global state paylaşımı kesinlikle yasaktır**
- Shared variable, singleton mock veya global side-effect üzerinden test arası veri geçirme forbidden
- Her test kendi setup’ını ve teardown’ını yapar
- Database/API mock: Her test kendi mock instance’ını oluşturur (msw handler, mock function)

## 37.4. CI Konfigürasyonu

Test suite’leri CI’da şu sıra ve paralellik ile çalışır:

1. **Paralel:** Vitest (web unit/integration) + Jest (mobile unit/integration) → aynı anda başlar
2. **Sıralı sonrası:** Playwright E2E → unit/integration testleri geçtikten sonra başlar (E2E daha yavaş ve daha kırılgan; önceki katman temiz geçmeli)
3. **Opsiyonel paralel:** Visual regression → unit testleri ile paralel çalışabilir

## 37.5. Flaky Test Politikası

- **Tespit:** Aynı kod değişikliği olmadan 3 ardışık CI run’da farklı sonuç veren test "flaky" kabul edilir
- **Quarantine:** Flaky test suite’den çıkarılır ve `__quarantine__/` dizinine taşınır; CI’da koşmaz ama görünür kalır
- **Süre limiti:** 1 hafta içinde düzeltilmezse test **silinir** ve ilgili davranış için yeni test yazılır
- **Root cause:** Her flaky test için root cause analizi yapılır (timing issue, shared state, network dependency, race condition)
- **Metrik:** Flaky test oranı CI dashboard’da izlenir; %2’yi aşarsa test stratejisi gözden geçirilir

---

# 38. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te testing stack, tek framework ve tek doğrulama biçimine indirgenmeyecektir. Web ve mobile runtime gerçekliği, reusable UI contract ihtiyacı, kritik user journey’ler ve visual/HIG kalite gereksinimleri çok katmanlı doğrulama zorunlu kılar. Bu nedenle canonical testing stack, Vitest + Jest + Testing Library + Playwright ve resmi manual audit katmanının birlikte çalıştığı modeldir.
