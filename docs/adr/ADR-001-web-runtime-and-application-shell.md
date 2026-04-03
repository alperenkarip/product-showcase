# ADR-001 — Web Runtime and Application Shell

## Doküman Kimliği

- **ADR ID:** ADR-001
- **Başlık:** Web Runtime and Application Shell
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational architecture and tooling decision
- **Karar alanı:** Web runtime, application shell, routing baseline, web bootstrap direction
- **İlgili üst belgeler:**
  - `17-technology-decision-framework.md`
  - `36-canonical-stack-decision.md`
  - `06-application-architecture.md`
  - `08-navigation-and-flow-rules.md`
  - `21-repo-structure-spec.md`
- **Etkilediği belgeler:**
  - `19-roadmap-to-implementation.md`
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `29-release-and-versioning-rules.md`
  - `35-document-map.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında web runtime ve application shell için aşağıdaki karar kabul edilmiştir:

- **Web UI runtime:** React
- **Web development/build runtime:** Vite
- **Web routing solution:** React Router 7 data-router / `RouterProvider`-first
- **Rendering yaklaşımı:** Canonical baseline olarak **SPA-first client-rendered application shell**
- **SSR / RSC / App Router style framework yaklaşımı:** v1 canonical stack içinde **bilinçli olarak seçilmemiştir**
- **Application shell yaklaşımı:** route-aware, provider-composed, design-system-first, documentation-first bir React app shell

Bu karar, web tarafını mobile ile davranışsal ve mimari uyumlu tutmak; ama web’i gereksiz framework yüküyle ağırlaştırmamak için verilmiştir.

---

# 2. Problem Tanımı

Boilerplate için web tarafında en kritik erken kararlardan biri şudur:

> Web uygulaması hangi runtime ve hangi application shell modeli üzerinde kurulacak?

Bu karar erken verilmezse şu sorunlar çıkar:

- repo yapısı erken yanlış kurulur,
- routing modeli geç değişirse büyük refactor gerekir,
- app shell ile feature assembly karışır,
- web tarafı mobile’dan zihinsel olarak kopar,
- SSR/RSC gibi ek kararlar gereksiz erken gündeme girer,
- testing, build, CI ve shared package topolojisi bulanık kalır,
- application shell içinde neyin global, neyin feature-level olduğu belirsizleşir.

Bu yüzden web runtime kararı boilerplate seviyesinde “sonra bakarız” denecek bir karar değildir.

---

# 3. Bağlam

Bu boilerplate’in mevcut üst hedefleri şunlardır:

1. Cross-platform ürün geliştirme
2. Web ve mobil arasında yüksek davranışsal ve tasarımsal uyum
3. Design system-first yaklaşım
4. Documentation-first / specification-first geliştirme
5. Apple HIG duyarlılığını mobile tarafta güçlü biçimde korurken web’de de premium UX standardı sürdürme
6. Type-safe, test edilebilir, uzun ömürlü mimari
7. Governance, audit ve quality gate ile desteklenen sürdürülebilir sistem

Bu bağlamda web runtime kararı şu baskılar altında verilmelidir:

- mobile tarafla zihinsel model uyumu korunmalı
- web’i ayrı ağır platform evrenine sürüklememeli
- hızlı ama hacky olmayan bootstrap mümkün olmalı
- design system, routing, state, testing ve monorepo topolojisi ile doğal uyum kurmalı
- gereksiz framework lock-in azaltılmalı
- modern ama hype-temelli olmayan seçim yapılmalı

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Cross-platform zihinsel model uyumu**
2. **Component-driven architecture uyumu**
3. **Design system-first yaklaşımı desteklemesi**
4. **Tooling olgunluğu**
5. **TypeScript uyumu**
6. **Routing modelinin açıklığı**
7. **Mimari sadelik**
8. **Gereksiz framework lock-in riski**
9. **Testing stack ile uyum**
10. **Monorepo ve package yapısı ile uyum**
11. **Uzun vadeli bakım kolaylığı**
12. **Documentation-first karar modeli ile uyum**

---

# 5. Değerlendirilen Alternatifler

Bu karar verilmeden önce aşağıdaki ana alternatifler düşünülmüştür:

1. React + Vite + React Router
2. Next.js
3. Remix / benzeri router-first framework
4. Başka SPA-oriented React wrapper çözümleri
5. Tam custom minimal React setup

Aşağıda neden seçilmedikleri veya seçildikleri açıklanmıştır.

---

# 6. Seçilen Karar: React + Vite + React Router

## 6.1. Neden React?

React seçiminin ana nedenleri şunlardır:

### 6.1.1. Mobile ile zihinsel model uyumu
Mobile tarafta React Native kullanılacağı için, web’de de React kullanmak:
- component düşünce biçimini ortaklaştırır,
- hooks/state/orchestration modelini hizalar,
- feature assembly mantığını benzer tutar,
- shared domain ve selected shared UI contracts için güçlü ortak zemin sağlar.

### 6.1.2. Design system-first yapı ile yüksek uyum
Bu boilerplate’te reusable UI, DS governance, token-first tasarım, semantic styling ve visual contract çok merkezi.  
React, component-driven model sayesinde bu disiplini doğal taşır.

### 6.1.3. Ekosistem olgunluğu
React:
- çok geniş ekosistem,
- çok güçlü tooling,
- yüksek topluluk desteği,
- uzun vadeli sürdürülebilirlik
sunmaktadır.

### 6.1.4. Testing ile doğal uyum
Testing Library, Vitest, Playwright ve farklı quality tooling’lerle doğal çalışır.

### 6.1.5. Boilerplate hedefleriyle uyum
Bu proje “web sitesi” değil, cross-platform ürün ailesi için application shell kuruyor.  
React bu hedefe uygun şekilde application-first düşünceyi taşır.

---

## 6.2. Neden Vite?

Vite seçiminin ana nedenleri şunlardır:

### 6.2.1. Gereksiz framework ağırlığı olmadan modern web shell kurma
Vite, React app shell’i kurmak için yeterince güçlü ama gereksiz opinionated framework yükü taşımaz.

### 6.2.2. Hızlı local geliştirme döngüsü
Documentation-first sonrası implementasyona geçerken hızlı feedback kritiktir.  
Vite bu konuda güçlü bir temel sunar.

### 6.2.3. Modern React + TypeScript + Tailwind ekosistemiyle güçlü uyum
Bu boilerplate’in styling, testing ve monorepo bileşenleriyle doğal şekilde çalışır.

### 6.2.4. Framework lock-in azaltma
Vite, uygulama shell’ini React tabanında kurup routing, DS, state ve infra kararlarını bizim belirlememize izin verir.  
Bu, boilerplate seviyesinde önemli avantajdır.

### 6.2.5. SPA-first baseline ile iyi eşleşme
Bu boilerplate’in v1 canonical yönü SSR-first değil, controlled app shell’tir.  
Vite bu modele uygundur.

---

## 6.3. Neden React Router?

### 6.3.1. Routing modelinin açıklığı
React Router:
- nested routes,
- route-level composition,
- navigation state,
- path-based product organization
için olgun zemin sunar.
- data-router ve route-aware error/data boundary modeli ile daha kurallı shell kurulmasına izin verir.
- `RouterProvider` tabanlı giriş modeli, gelecekte framework/data mode genişlemesi gerektiğinde daha temiz yükseltme yolu bırakır.

### 6.3.2. React shell ile uyum
App shell → route groups → feature screens zincirini doğal kurmaya izin verir.

### 6.3.3. Web’i mobile ile zihinsel olarak çok uzaklaştırmama
React Navigation ile birebir aynı değildir, olmak zorunda da değildir.  
Ama ikisi de controlled navigation modeline izin verir.  
Bu da behavior parity kurarken önemlidir.

### 6.3.4. Boilerplate için yeterli esneklik
Bu proje çok ağır server-driven router paradigmasına ihtiyaç duymadan güçlü ürün akışları kurmak istiyor.  
React Router bu iş için yeterlidir.

### 6.3.5. Resmi Vite entegrasyon yolu ile hizalanma
Bootstrap sırasında React Router'ın resmi **Vite plugin / route-module-capable** entegrasyon yolu varsayılan değerlendirme çizgisidir ve adopt/omit kararı yazılı kayda geçirilmelidir. Bu, SSR veya RSC’ye geçmek zorunda olduğumuz anlamına gelmez; `ssr: false` SPA shell korunabilir. Ama ad-hoc `BrowserRouter` wiring yerine resmi route module, loader/clientLoader ve route-level ErrorBoundary kabiliyetleriyle hizalı başlangıç çizgisi daha güçlüdür.


---

# 7. Rendering Yaklaşımı Kararı: SPA-First

## 7.1. Karar

Canonical v1 web yönü:
- **SPA-first**
- **client-rendered application shell**
- route-aware composition
- shared domain and DS-centric architecture

## 7.2. Neden?

Bu karar şu nedenlerle verilmiştir:

### 7.2.1. Mobile ile ürün mantığı hizalaması
Mobile taraf doğası gereği app-shell odaklıdır.  
Web tarafı da aynı ürün ailesinin parçası olarak benzer ürün mantığı taşımalıdır.

### 7.2.2. Boilerplate’in odak noktası SSR değil
Bu boilerplate’in ana iddiası:
- premium cross-platform ürün foundation’ı
- governance + design system + architecture kalitesi
- app-like product shell
olduğu için SSR-first kurgu ilk öncelik değildir.

### 7.2.3. Karar yüzeyini gereksiz büyütmeme
SSR/RSC/App Router gibi alanlar şunları erken zorlar:
- data loading topology
- cache ownership
- server-client boundary decisions
- rendering phase complexity
- web’i mobile’dan daha ayrı bir mimari evrene taşıma

Bu boilerplate için bu aşamada bu karmaşıklık yanlış önceliktir.

---

# 8. Neden Next.js Seçilmedi?

Bu soru özellikle açık cevaplanmalıdır. Çünkü “neden Next değil?” en doğal itirazlardan biridir.

## 8.1. Next.js kötü olduğu için değil

Karar “Next.js kötüdür” değildir.  
Karar şudur:

> Bu boilerplate’in v1 canonical hedefleri için Next.js gereksiz ağırlık ve yanlış öncelik üretiyor.

## 8.2. Nedenleri

### 8.2.1. SSR / RSC / App Router karar yüzeyi fazla büyük
Bu boilerplate’in şu an çözmesi gereken problem:
- doğru ürün foundation’ı,
- doğru shared architecture,
- doğru design system,
- doğru mobile-web parity,
- doğru quality gates.

Next.js ise erken aşamada şu tartışmaları zorlar:
- SSR mı CSR mı
- RSC sınırları
- server actions
- route data ownership
- deployment/runtime specifics

Bu alanlar şu an gereksiz geniş karar yüzeyi oluşturur.

### 8.2.2. Mobile ile zihinsel model uzaklaşır
Web tarafı fazla framework-heavy hale geldiğinde, mobile ile ortak ürün mantığı yerine web’e özel bir dünya oluşur.  
Bu, current boilerplate hedefiyle çelişir.

### 8.2.3. Lock-in riski
Canonical boilerplate seviyesinde gereksiz framework opinion’ları, sonraki feature ve package kararlarını etkileyebilir.

### 8.2.4. Fazla güçlü web-first bias
Next.js seçimi çoğu ekipte şu psikolojiyi üretir:
- web ana ürün,
- mobile ise uyarlama katmanı

Bu proje tam olarak bunu istemiyor.

## 8.3. Sonuç
Next.js reddedildi çünkü yanlış öncelik üretiyor; yetersiz olduğu için değil.

---

# 9. Neden Remix veya Benzeri Alternatifler Seçilmedi?

## 9.1. Gerekçe

Remix/router-first full-stack yaklaşımlar bazı bağlamlarda güçlü olabilir.  
Ancak bu boilerplate’in temel hedefleri için:

- app-shell architecture,
- mobile-web ortak mental model,
- design system governance,
- shared product logic

daha kritik.

Router-first full-stack modeller erken aşamada web data flow paradigmasını fazla merkezileştirebilir.

## 9.2. Sonuç

Bu aşamada daha sade ve daha kontrollü kombinasyon olan React + Vite + React Router tercih edilmiştir.

---

# 10. Neden Tamamen Custom Minimal Setup Değil?

## 10.1. Gerekçe

Tamamen sıfırdan minimal setup kulağa esnek gelebilir.  
Ama pratikte şu sorunları çıkarır:

- gereksiz bakım yükü
- karar tekrarları
- tooling uyumsuzluğu
- test/build/dev ergonomisinin daha fazla elle kurulması
- boilerplate’in amacı olan “standardized high-quality start” hedefine zarar

## 10.2. Sonuç

Boş esneklik yerine olgun ama gereksiz ağır olmayan stack seçilmiştir.

---

# 11. Web Application Shell Kararı

## 11.1. Karar

Web tarafında application shell şu ilkelere göre kurulacaktır:

1. **Route-aware shell**
2. **Provider-composed root**
3. **Feature assembly app shell’den ayrılmış**
4. **Design-system-first presentation infrastructure**
5. **App-level concerns centrally wired**
6. **Feature logic shell’e sızmayacak**

## 11.2. Application shell neyi kapsar?

Web shell aşağıdaki alanları kapsar:

- root app entry
- root providers
- theme bootstrapping
- router setup
- app-level error boundary
- route group composition
- app-wide layout chrome registration
- app-level analytics/error tracking bootstrap
- auth/session shell gates
- build metadata exposure surface

## 11.3. Application shell neyi kapsamaz?

Aşağıdakiler app shell konusu değildir:

- feature-specific business logic
- screen-specific orchestration
- domain rules
- ad-hoc fetching logic
- component-level visual decisions
- feature-local transient state

---

# 12. Route Modeli Kararı

## 12.1. Karar

Route modeli:
- feature-aware,
- nested structure destekli,
- app-shell controlled,
- typed navigation hedefli
kurulacaktır.

## 12.2. Kural

Route’lar rastgele sayfa dosyaları yığını gibi ele alınmayacaktır.  
Route yapısı ürün akışını yansıtmalı; klasör yapısı kadar domain ve feature mantığıyla da uyumlu olmalıdır.

## 12.3. Sonuç

Web routing:
- “sayfa listesi” değil,
- ürün shell’inin resmi parçası
olarak düşünülür.

---

# 13. Web’de Data Loading Yaklaşımı Bu Karardan Nasıl Etkilenir?

## 13.1. Önemli not

Bu ADR data fetching stack kararını tam kapatmaz; onu ADR-005 yapacaktır.  
Ama web runtime kararı şu sonucu doğurur:

- server-rendered data loading temel varsayım olmayacak,
- client-driven query/cache modeli canonical kabul edilecek,
- data ownership React app shell + query layer içinde çözülecek.

## 13.2. Sonuç

Bu web kararı, TanStack Query merkezli client-driven application modelini destekler.

---

# 14. Web Shell ve Design System İlişkisi

## 14.1. Kural

Web shell:
- DS’yi tüketen üst runtime yüzeyidir,
- DS’den bağımsız paralel stil sistemi kurmaz,
- global layout chrome ve route surfaces’leri DS-first mantıkla kurar.

## 14.2. Ne anlama gelir?

- raw page-level styling kaosu olmayacak
- app shell ile route surfaces design token mantığını bozmayacak
- web shell, visual language açısından mobilin kuzeni değil, aynı ailenin parçası olacak

---

# 15. Web Shell ve Cross-Platform İlişkisi

## 15.1. Kural

Web shell, mobile shell ile birebir aynı olmaz.  
Ama aynı ürün mantığını taşımalıdır.

## 15.2. Sonuçlar

- route groups ve screen flows, mobile’daki navigation intent ile hizalı düşünülür
- web’e özel güçlü layout olanakları kullanılır
- ama behavior parity bozulmaz
- web, “daha farklı ürün” haline gelmez

---

# 16. Testing Üzerindeki Etkiler

Bu karar şu test sonuçlarını doğurur:

1. Web-side unit/integration için modern hızlı runner mantığı desteklenir
2. React Router ve route-aware shell integration test konusu olur
3. Playwright ile web user journey doğrulaması doğal hale gelir
4. App shell wiring ve route transitions integration/E2E katmanında anlam kazanır

---

# 17. Repo Yapısı Üzerindeki Etkiler

Bu karar doğrudan şu repo alanlarını etkiler:

- `apps/web`
- web-specific route shell structure
- web app bootstrap entry
- web layout/chrome assembly
- web-specific adapters
- shared packages’in web tarafından tüketim modeli

Bu nedenle `21-repo-structure-spec.md` bu kararla güncellenmelidir.

---

# 18. CI / Build Üzerindeki Etkiler

Bu karar aşağıdaki CI/build sonuçlarını doğurur:

- web build sanity resmi gate olacaktır
- route/app shell integrity dolaylı build/test konusu olacaktır
- Vite-based web build pipeline temel alınacaktır
- Playwright ve web integration coverage planları bu stack üzerinden tasarlanacaktır

---

# 19. Güçlü Yanlar

Bu kararın ana avantajları:

1. Web tarafı gereksiz ağırlaşmaz
2. Mobile ile zihinsel ve mimari uyum korunur
3. Design system-first yaklaşım doğal taşınır
4. Documentation-first implementasyon için sade ve güçlü zemin sunar
5. Framework lock-in gereksiz büyümez
6. Monorepo yapısı ile iyi uyum sağlar
7. Testing ve tooling ekosistemi güçlüdür

---

# 20. Riskler

Dürüst olmak gerekir. Bu karar risksiz değildir.

## 20.1. SSR olmayışı bazı web use-case’lerde sınır yaratabilir
Bu boilerplate’in v1 hedefi için kabul edilmiştir.  
SEO-heavy public marketing site use-case’i bu boilerplate’in primary hedefi değildir.

## 20.2. Web tarafında bazı framework conveniences alınmamış olur
Bu bilinçli tercihtir.  
Amaç rahatlık değil, doğru temel kurmaktır.

## 20.3. App shell tasarımı iyi yapılmazsa SPA kaosu oluşabilir
Bu nedenle shell ve routing disiplinine ayrıca belge ve audit bağlanmalıdır.

---

# 21. Mitigations

Bu kararın risklerini azaltmak için aşağıdaki önlemler zorunludur:

1. `08-navigation-and-flow-rules.md` ile route/flow standardını sıkı kurmak
2. `21-repo-structure-spec.md` ile apps/web shell topolojisini netleştirmek
3. `ADR-005` ile data/query yaklaşımını kapatmak
4. `33-visual-implementation-contract.md` ile web shell visual quality’yi denetlemek
5. `14-testing-strategy.md` ile web route/application shell integration testlerini tanımlamak

---

# 22. Bu Kararın Non-Goals Alanları

Bu ADR aşağıdakileri çözmez:

- SEO-first marketing site mimarisi
- SSR/RSC adoption planı
- hybrid rendering strategy
- backend rendering contracts
- microfrontend yaklaşımı
- CMS-driven public site architecture

Bu alanlar bu boilerplate’in current canonical kapsamı dışındadır.

---

# 23. Bu Kararın Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar resmen doğar:

1. Web app `apps/web` odaklı React application shell olarak kurulur
2. Vite baseline kabul edilir
3. React Router routing baseline kabul edilir
4. Web tarafı Next.js/SSR-first çizgiye göre şekillendirilmez
5. Shared package yapısı web shell tarafından tüketilecek şekilde tasarlanır
6. Web-mobil parity davranışsal seviyede korunur; teknik birebirlik zorunlu sayılmaz

---

# 24. Reddedilen Alternatiflerin Kısa Özeti

## 24.1. Next.js
Reddedildi çünkü:
- aşırı erken karar yüzeyi açıyor
- web-first bias üretiyor
- canonical cross-platform foundation için gereksiz framework ağırlığı getiriyor

## 24.2. Remix
Reddedildi çünkü:
- router/full-stack yaklaşımı bu aşamada gereksiz geniş karar alanı oluşturuyor

## 24.3. Bare minimal custom stack
Reddedildi çünkü:
- standardizasyon gücünü azaltıyor
- bakım yükünü artırıyor

---

# 25. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki tür durumlarda bu ADR yeniden değerlendirilebilir:

- boilerplate’in ana hedefi SEO-first public web product’a kayarsa
- server-driven rendering primary requirement olursa
- mobile ile parity hedefi yerine web-first multi-surface strategy kabul edilirse
- React + Vite + React Router kombinasyonu uzun vadede teknik olarak yetersiz hale gelirse

Bu tür bir değişiklik yeni ADR ve muhtemelen major versioning etkisi gerektirir.

---

# 26. Kararın Kısa Hükmü

> Web runtime ve application shell için canonical karar: React + Vite + React Router tabanlı, SPA-first, route-aware, provider-composed, design-system-first application shell modelidir. Root router girişi canonical olarak `createBrowserRouter` + `RouterProvider` hattında kurulur; `BrowserRouter` ancak geçişsel veya bilinçli istisna durumlarında kabul edilebilir. Next.js/SSR-first veya benzeri daha ağır web-first çerçeveler v1 canonical boilerplate kapsamında seçilmemiştir.

---

# 27. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Web runtime seçimi açıkça yazılmışsa
2. Application shell yaklaşımı tanımlanmışsa
3. Neden React + Vite + React Router seçildiği gerekçelendirilmişse
4. Neden Next.js ve benzeri alternatiflerin seçilmediği net yazılmışsa
5. Cross-platform bağlamı ve shell etkisi görünür kılınmışsa
6. Repo, testing ve CI etkileri işaretlenmişse
7. Bu karar artık implementasyon öncesi kilitlenmiş baseline olarak kullanılabilecek netlikteyse

---

# 28. SSR/SSG Gelecek Değerlendirmesi

SPA-first kararının bilinçli sınırları ve gelecek değerlendirme çerçevesi:

## 28.1. Şu Anki Pozisyon

Bu boilerplate SPA-first yaklaşımı canonical baseline olarak kabul etmiştir. Server-side rendering (SSR) veya static site generation (SSG) v1 canonical kapsamda yoktur. Bu bilinçli bir tercihtir ve aşağıdaki ürün profillerine uygundur:

- Dashboard ve admin panel uygulamaları
- Internal tool ve SaaS ürünleri
- Auth-gated tüm uygulama yüzeyleri
- SEO gereksinimi düşük veya sıfır olan ürünler

## 28.2. SEO Gereksinimleri Doğarsa

Derived project’te public-facing landing page veya content-heavy site ihtiyacı çıkarsa aşağıdaki değerlendirme sırası uygulanır:

1. **React Router 7.x SSR modu:** Mevcut stack ile en uyumlu seçenek. `ssr: true` ile mevcut route yapısı korunarak server rendering eklenebilir. `clientLoader` / `loader` ayrımı ile hangi route’ların SSR alacağı kontrol edilir.
2. **Vite SSR plugin ekosistemi:** vite-plugin-ssr veya benzeri plugin ile daha granüler SSR/SSG kontrolü. Mevcut Vite build pipeline korunur.
3. **Hybrid yaklaşım:** SPA-first korunur, yalnızca SEO gerektiren route’lar (ör. `/blog`, `/pricing`, `/features`) SSR veya prerender alır. Uygulama shell’i SPA olarak kalır.
4. **Full SSR framework (Next.js, Remix):** Tüm web uygulamasının framework’e taşınması. Bu seçenek major migration gerektirir ve yeni ADR ile kapatılmalıdır. Boilerplate kapsamı dışında, derived project kararıdır.

## 28.3. Karar Tetikleyicisi

Bu değerlendirme şu koşullardan biri doğduğunda aktif hale gelir:
- Derived project’te public-facing, indexlenmesi gereken sayfa ihtiyacı kesinleştiğinde
- Core Web Vitals (LCP, FID, CLS) SPA mimarisinde kabul edilemez seviyeye ulaştığında
- Content marketing veya SEO-driven growth stratejisi benimsendiğinde

---

# 29. React 19 Concurrent Features Entegrasyonu

React 19’un SPA mimarisine etkisi ve canonical kullanım rehberi:

## 29.1. useTransition

Ağır state güncellemelerinde UI responsiveness’ı korumak için kullanılır. Özellikle büyük liste filtreleme, tab geçişi veya kompleks form state değişikliklerinde ana thread’in bloklanmasını önler.

- **Canonical kullanım alanı:** Route geçişlerinde loading indicator gösterme, büyük veri setlerinde filtreleme sırasında UI’ın donmamasını sağlama
- **Kural:** Her state güncellemesi transition’a sarılmaz; yalnızca kullanıcının fark edeceği gecikme üreten güncellemeler için kullanılır

## 29.2. useDeferredValue

Sık güncellenen UI’larda (arama kutusu, gerçek zamanlı filtreleme) render önceliğini düşürmek için kullanılır. Input’un kendisi anında güncellenir, sonuç listesi ertelenir.

- **Canonical kullanım alanı:** Search-as-you-type pattern’lerinde arama sonuçları, büyük listelerde canlı filtreleme
- **Kural:** useDeferredValue ve debounce birlikte değil, durum bazında tercih edilir. Network isteği gerektiren aramalarda debounce, yalnızca client-side filtreleme yapılan yerlerde useDeferredValue tercih edilir.

## 29.3. useOptimistic

Form submit sırasında optimistic UI göstermek için canonical pattern. Kullanıcı submit’e bastığında UI anında güncellenir, mutation başarısız olursa rollback yapılır.

- **Canonical kullanım alanı:** Like/unlike toggle, yorum ekleme, liste öğesi silme gibi hızlı geri bildirim gerektiren aksiyonlar
- **Kural:** Optimistic update’ler ADR-005’teki mutation lifecycle ile uyumlu kurulmalıdır. Rollback senaryosu her zaman düşünülmelidir.

## 29.4. Suspense Boundaries

Route-level ve component-level lazy loading stratejisi:

- **Route-level Suspense:** Her route modülü `React.lazy` ile yüklenir, route geçişinde skeleton/loading gösterilir
- **Component-level Suspense:** Ağır component’ler (grafik, harita, editör) lazy load edilir
- **Nested Suspense:** Sayfa skeleton’u üst boundary’de, bağımsız veri blokları iç boundary’lerde yönetilir
- **Fallback standardı:** Suspense fallback’leri design system’deki loading state standardına (25-error-empty-loading-states.md) uymalıdır

## 29.5. use() Hook

Promise ve context okuma için yeni API. Data fetching pattern’lerine etkisi:

- **Potansiyel kullanım:** Route loader’dan dönen promise’lerin component içinde okunması
- **Dikkat:** use() hook’u TanStack Query’nin yerini almaz; query cache lifecycle, invalidation ve retry TanStack Query ile yönetilmeye devam eder (ADR-005)
- **Karar:** use() hook’unun TanStack Query ile birlikte kullanım pattern’leri bootstrap aşamasında belirlenecektir

## 29.6. React Compiler (Watchlist)

React Compiler şu anda controlled opt-in ile watchlist’tedir (36-canonical-stack-decision.md):

- **Potansiyel:** useMemo, useCallback, React.memo gibi manuel memo pattern’lerinin otomatik hale gelmesi
- **Risk:** Zustand selector optimizasyonları ve third-party hook’larla potansiyel çakışma
- **Strateji:** Compiler stable olunca sınırlı scope’ta (ör. tek bir shared component) pilot deneme yapılır. Performans benchmark’ı sonrası genişletme kararı verilir. Manuel memo kaldırma ancak Compiler’ın kararlı çalıştığı doğrulandıktan sonra yapılır.

---

# 30. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Web tarafı, mobile ile zihinsel ve mimari uyumu koruyan ama web’i gereksiz ağır framework kararlarına kilitlemeyen bir foundation üzerinde kurulacaktır. Bu foundation, React + Vite + React Router tabanlı, SPA-first, design-system-first ve route-aware application shell modelidir.
