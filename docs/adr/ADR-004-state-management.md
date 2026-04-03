# ADR-004 — State Management

## Doküman Kimliği

- **ADR ID:** ADR-004
- **Başlık:** State Management
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational application state and ownership decision
- **Karar alanı:** App-global state, feature orchestration state, store policy, server-state ayrımı, persistence sınırları
- **İlgili üst belgeler:**
  - `09-state-management-strategy.md`
  - `06-application-architecture.md`
  - `07-module-boundaries-and-code-organization.md`
  - `10-data-fetching-cache-sync.md`
  - `11-forms-inputs-and-validation.md`
  - `15-quality-gates-and-ci-rules.md`
  - `36-canonical-stack-decision.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `ADR-005-data-fetching-cache-and-mutation-model.md`
  - `ADR-006-forms-and-validation.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında state management için aşağıdaki karar kabul edilmiştir:

- **App-global client state aracı:** Zustand
- **Varsayılan yaklaşım:** Local-first, feature-appropriate, global-only-when-necessary
- **Server state yaklaşımı:** Zustand ile değil; ayrı query/cache katmanıyla yönetilir
- **Form state yaklaşımı:** Generic app store ile değil; ayrı form katmanında yönetilir
- **Derived state yaklaşımı:** Mümkün olduğunca hesaplanır, ayrıca mutable source olarak saklanmaz
- **Persistence yaklaşımı:** Convenience-first değil, ownership/security/staleness-first
- **Store açma politikası:** Store açmak varsayılan değil; gerekçeli istisnadır
- **Canonical ilke:** Zustand, tüm state’in evi değildir; yalnızca gerçekten app-global veya kontrollü feature-level paylaşım gerektiren client-owned state için kullanılır

Bu ADR’nin ana hükmü şudur:

> State yönetimi bu boilerplate’te “tek store’a her şeyi atalım” yaklaşımıyla kurulmayacaktır. Zustand, hafif ve kontrollü app-global client state aracı olarak kabul edilir; server state, form state ve local transient UI state ise kendi doğru katmanlarında çözülecektir.

---

# 2. Problem Tanımı

Boilerplate için state management kararı verilmezse veya yarım verilirse şu bozulmalar hızla ortaya çıkar:

- local UI state global store’a taşınır
- query/cache verisi duplicated client store’a dökülür
- form state generic store ile yönetilmeye çalışılır
- screen-local orchestration ile app-global state birbirine karışır
- persistence kontrolsüz büyür
- logout/user switch sonrası stale bilgi kalır
- aynı bilgi birden fazla yerde yaşamaya başlar
- feature sınırları bozulur
- test maliyeti artar
- source of truth belirsizleşir

Bu yüzden state kararı yalnızca “hangi kütüphane?” kararı değildir.  
Asıl karar şudur:

> Ne store’a girecek, ne store’a girmeyecek ve neden?

Bu ADR tam olarak bunu kilitler.

---

# 3. Bağlam

Bu boilerplate’in state açısından taşıdığı zorunluluklar şunlardır:

1. Web ve mobile arasında davranışsal uyum
2. Documentation-first state ownership
3. Server state ile client state’in net ayrılması
4. Form state’in generic state yığınına karıştırılmaması
5. Design system ve feature orchestration ile uyumlu davranış
6. Test edilebilirlik
7. Security ve persistence hijyeni
8. Uzun vadede store sprawl üretmeyen yapı
9. Boundary ve modül disiplini ile uyum
10. Gereksiz ceremony yaratmadan yüksek kontrol

Bu bağlamda seçilecek state yaklaşımı şu iki uçtan da kaçınmalıdır:

- Redux-benzeri ağır, her şeyi merkeze çeken yapı
- tamamen dağınık local state kültürü

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Ownership modeline uygunluk**
2. **Local / feature / global ayrımını bozmama**
3. **Server state’i yanlışlıkla store’a çekmeme**
4. **TypeScript ile güçlü çalışma**
5. **Low ceremony**
6. **Feature-level controlled adoption**
7. **Monorepo/package yapısı ile uyum**
8. **Testing ve refactor ergonomisi**
9. **Persistence ve reset kurallarını uygulayabilme**
10. **Cross-platform React zihinsel modeli ile uyum**
11. **Maintenance cost**
12. **Tooling ve ecosystem olgunluğu**

---

# 5. Değerlendirilen Alternatifler

Bu karar öncesi ana alternatifler şunlardır:

1. Zustand
2. Redux Toolkit
3. Jotai
4. Recoil
5. Context + custom hooks only
6. MobX
7. “No store, everything local” yaklaşımı

Bu alternatiflerin neden seçilmediği veya seçildiği aşağıda açıklanmıştır.

---

# 6. Seçilen Karar: Zustand

## 6.1. Neden Zustand?

Zustand bu boilerplate için şu nedenlerle canonical seçim olarak kabul edilmiştir:

### 6.1.1. Düşük ceremony
Bu proje yüksek kalite istiyor; ama gereksiz ceremony istemiyor.  
Zustand:
- store yönetimi için yeterince net
- ama Redux düzeyinde ceremony üretmeyen
bir araçtır.

### 6.1.2. Ownership modelini gizlememesi
Bazı araçlar state’i kolay merkezileştirdiği için yanlış kullanımı teşvik eder.  
Zustand ise doğru policy ile kullanıldığında “neyi store’a koyuyoruz?” sorusunu açık tutar.

### 6.1.3. App-global state için güçlü uyum
Theme, locale, shell summary, workspace context gibi state’ler için uygun hafiflikte ve açıklıktadır.

### 6.1.4. Feature-level controlled usage imkanı
Bazı özel feature orchestration alanlarında store gerekli olabilir.  
Zustand bunu fazla mimari ağırlık olmadan destekler.

### 6.1.5. TypeScript ile güçlü uyum
Store contracts ve selectors açısından TypeScript ile tatmin edici bir çalışma modeli sunar.

### 6.1.6. React ekosistemiyle doğal çalışma
React ve React Native ile doğal uyum gösterir; web-mobile zihinsel modeli bozulmaz.

---

# 7. Bu Karar Ne Anlama Gelmez?

Bu karar çok yanlış yorumlanmaya açıktır.  
O yüzden açık yazılmalıdır.

## 7.1. “Artık her state Zustand’a girecek” demek değildir
Bu yanlış olur.

## 7.2. “Zustand varsa TanStack Query’ye gerek yok” demek değildir
Bu daha da yanlış olur.

## 7.3. “Form state’i store’da çözeriz” demek değildir
Yanlıştır.

## 7.4. “Component local state gereksiz” demek değildir
Yanlıştır.

## 7.5. “Global state açmak kolay, o zaman kullanalım” demek değildir
Bu da yanlış ve tehlikelidir.

Doğru yorum şudur:

> Zustand, yalnızca gerçekten app-global veya kontrollü şekilde feature-scope store gerektiren client-owned state için kullanılacaktır.

---

# 8. Store Policy — En Kritik Bölüm

Bu ADR’nin kalbi burasıdır.

## 8.1. Varsayılan yaklaşım: Local-first

Yeni bir state ihtiyacı doğduğunda varsayılan soru şu olmalıdır:

> Bu state gerçekten store gerektiriyor mu?

Varsayılan cevap:
- hayır, önce local / feature-local düşün

## 8.2. Store açmak için güçlü gerekçeler gerekir

Bir state store’a ancak şu tür gerekçelerle çıkar:

1. Birden fazla feature veya app shell alanı aynı state’e ihtiyaç duyuyorsa
2. Route/screen lifetime’ını aşan anlamlı client-owned context varsa
3. Prop drilling değil, gerçek ownership değişimi varsa
4. Persistence ve reset modeli merkezi düşünülmek zorundaysa
5. Feature-level orchestration local state ile sürdürülemez karmaşıklığa ulaştıysa

## 8.3. Store açmak için zayıf gerekçeler

Aşağıdakiler store açmak için yeterli değildir:

- “prop drilling olmasın”
- “kolay geldi”
- “globalde tutarsak daha rahat”
- “ileride lazım olabilir”
- “tek yerden yönetmek istedim”
- “component çok büyüdü”

Bunlar çoğu zaman yanlış state placement göstergesidir.

---

# 9. Zustand Neye Uygundur?

Aşağıdaki state aileleri için Zustand güçlü adaydır:

## 9.1. App-global preferences
- theme mode
- locale
- density preference
- harmless display preferences

## 9.2. Shell-level session-adjacent client context
- current workspace selection
- app-shell capability summary
- top-level user context fragments
- cross-feature UI chrome state

## 9.3. App-wide non-server client state
- dismissed banners
- app-level UI layout toggles
- global navigation support state (gerektiğinde)
- safe persisted non-sensitive preferences

## 9.4. Carefully scoped feature stores
Yalnızca gerektiğinde:
- complex multi-step flow state
- advanced local draft orchestration
- multi-panel selection coordination

Burada bile “store açalım” varsayılan değil, istisnadır.

---

# 10. Zustand Neye Uygun Değildir?

Bu bölüm net olmalıdır. Çünkü bozulma burada başlar.

## 10.1. Server state
Aşağıdakiler Zustand’ın işi değildir:
- query data
- API result cache
- stale/refetch lifecycle
- mutation result ownership
- invalidation graph

## 10.2. Form engine state
Aşağıdakiler generic Zustand store konusu değildir:
- field values
- touched
- dirty
- submit lifecycle
- validation error tree

## 10.3. Kısa ömürlü component UI state
Örnek:
- accordion open
- local tab selection
- dropdown visibility
- inline action pending
- row expanded

## 10.4. Salt derived state
Örnek:
- `isReady`
- `hasData`
- `visibleItems`
- `isSubmitEnabled`
- `sortedAndFilteredList`

Bunlar mümkün olduğunca hesaplanmalıdır.

## 10.5. Platform binding details
Örnek:
- keyboard offset workaround state
- sheet instance micro state
- per-screen gesture toggles
- ephemeral native integration flags

Bunlar yanlışlıkla globalleştirilmemelidir.

---

# 11. Neden Redux Toolkit Seçilmedi?

Bu karar bilinçli şekilde açıklanmalıdır.

## 11.1. Redux Toolkit kötü olduğu için değil

RTK güçlü araçtır.  
Ama bu boilerplate’in hedefleri için canonical default değildir.

## 11.2. Nedenleri

### 11.2.1. Gereksiz ceremony riski
Boilerplate’in amacı sağlam temel kurmak; ritual üretmek değil.  
RTK çoğu zaman şu riski taşır:
- slice çoğalması
- her state’in store’a gitmesi
- ekstra soyutlama

### 11.2.2. Yanlış merkezileştirme teşviki
RTK’nın en büyük pratik riski şudur:
“Nasıl olsa store var, bunu da oraya atalım.”

Bu proje tam tersini istiyor.

### 11.2.3. Bu boilerplate’in state profili
Bu boilerplate server-state ağırlıklı modern app modeline daha yakın.  
Bu nedenle app-global client state aracı daha hafif ve kontrollü olmalıdır.

## 11.3. Sonuç

Redux Toolkit reddedilmiştir çünkü yetersiz değil; canonical hedef için gereğinden ağır ve yanlış kullanım teşvikine daha açık görülmüştür.

---

# 12. Neden Jotai / Recoil Seçilmedi?

## 12.1. Kısmi güçlü yönleri
Bu araçlar atom tabanlı yaklaşım sunabilir ve bazı bağlamlarda güçlü olabilir.

## 12.2. Neden canonical seçim olmadılar?
Bu boilerplate için:
- atom-level mental model gereksiz parçalanma riski taşıyabilir
- ownership yerine atom sprawl oluşabilir
- app-global state policy’yi daha dağınık hale getirebilir
- contributor’ların yanlış granularity kararları vermesini kolaylaştırabilir

## 12.3. Sonuç
Bu araçlar reddedildi çünkü bu boilerplate’in hedeflediği store policy için daha net ve sade yön Zustand ile elde ediliyor.

---

# 13. Neden “Context + custom hooks only” Seçilmedi?

## 13.1. Sorun

Bu yaklaşım küçük projelerde bazen yeterli olabilir.  
Ama boilerplate düzeyinde:
- app-global state büyüdüğünde dağınıklık üretir
- provider ormanına dönüşebilir
- reset/persist kuralları görünmezleşebilir
- testing ve ownership daha bulanık olabilir

## 13.2. Sonuç

Context elbette tamamen yasak değildir.  
Ama canonical app-global state çözümü olarak seçilmemiştir.

---

# 14. Store Türleri İçin Canonical Model

Bu ADR exact code API vermez; ama store ailelerini tanımlar.

## 14.1. App-global stores
Tekrarlı app-wide client state için.

Örnek:
- theme store
- locale store
- workspace shell store
- app UI chrome store

## 14.2. Feature-scoped stores
Sadece güçlü gerekçeyle.

Örnek:
- advanced wizard coordination
- complex local draft orchestration
- multi-panel selection coordination

## 14.3. Yasaklanan yanlış model
“Tek büyük global mega store”

Bu proje bunu canonical model olarak reddeder.

---

# 15. Mega Store Neden Yasaklanır?

Tek büyük store ilk başta kolay görünür.  
Ama zamanla şu olur:

- ownership kaybolur
- unrelated rerender riski artar
- action ve state isimleri çamurlaşır
- logout/reset kuralları zorlaşır
- feature boundary bozulur
- test izolasyonu düşer
- aynı store her feature’ın çöplüğüne dönüşür

Bu yüzden canonical model:
- küçük, amaca odaklı,
- ownership’i net,
- gerekçeli store’lar
üzerinden kurulmalıdır.

---

# 16. Server State ile İlişkisi

## 16.1. En kritik kural

Server state store’a kopyalanmayacaktır.

Bu cümle çok önemlidir.

## 16.2. Ne anlama gelir?

Aşağıdakiler yapılmayacaktır:
- query result’u alıp Zustand’a yazmak
- mutation sonrası aynı kaynağın hem query cache hem Zustand hem local state kopyasını taşımak
- stale/refetch mantığını store ile çözmek

## 16.3. Neden?

Çünkü bu:
- source of truth çoğaltır
- stale bug’larını artırır
- invalidation karmaşası üretir
- state ownership’i bozar

## 16.4. Sonuç

Zustand kararı doğrudan ADR-005 ile uyumludur:
- server state → query/cache layer
- client-owned app state → Zustand

---

# 17. Form State ile İlişkisi

## 17.1. Kural

Form state generic Zustand store ile çözümlenmeyecektir.

## 17.2. Neleri kapsar?

- values
- touched
- dirty
- submit state
- validation lifecycle
- field errors

Bunlar dedicated form katmanının konusudur.

## 17.3. İstisna benzeri alanlar
Formla ilişkili ama gerçekten global olan şeyler olabilir:
- multi-step flow shell context
- draft restore preference
- top-level form session summary

Ama bunlar form engine state’i değildir.

---

# 18. Persistence Politikası

## 18.1. Kural

Persist varsayılan değildir.  
Persist kararı gerekçeli olmalıdır.

## 18.2. Zustand store’larında neler persist edilebilir?

- theme preference
- locale
- harmless UI preferences
- safe workspace preference
- selected shell-level non-sensitive context

## 18.3. Neler kolayca persist edilmemelidir?

- auth tokens
- sensitive user data
- query result cache duplications
- ephemeral action state
- stale riski yüksek server-derived fragments
- user-bound context without cleanup

## 18.4. En kritik sorular

Bir Zustand alanını persist etmeden önce şu sorular sorulmalıdır:
1. Bu veri yanlış kullanıcıya taşınırsa ne olur?
2. Logout sonrası temizlenecek mi?
3. App restart sonrası bunun kalması gerçekten değerli mi?
4. Security riski var mı?
5. Stale kalırsa kullanıcıyı yanıltır mı?

---

# 19. Reset ve Cleanup Politikası

## 19.1. Kural

Her store için reset politikası açık olmalıdır.

## 19.2. Açık cevap verilmesi gereken anlar

- app cold start
- route leave
- feature exit
- modal close
- submit success
- logout
- user switch
- workspace switch

## 19.3. Neden?

Bu cevaplar yazılmazsa store uzun ömürlü çöp üretir.

## 19.4. Zayıf davranış

“Store’da kalsın, sonra bakarız.”  
Bu kabul edilmez.

---

# 20. Selector Politikası

## 20.1. Kural

Store içindeki veriler kör biçimde her yerde tüketilmemelidir.  
Selective consumption tercih edilmelidir.

## 20.2. Neden?

- rerender kontrolü
- coupling azaltma
- contract clarity
- test ergonomisi

## 20.3. Uyarı

Selector kullanımı store sprawl sorununu çözmez.  
Sadece tüketimi kontrollü hale getirir.  
Asıl mesele ownership’tir.

---

# 21. Feature Store Ne Zaman Meşru?

Feature store ancak şu koşullarda meşru adaydır:

1. Aynı feature içinde birden fazla screen/section/store consumer var
2. Local state ile yönetmek aşırı zorlaşıyor
3. State gerçekten feature lifetime taşıyor
4. Query cache veya form engine ile çözülmüyor
5. App-global yapmak yanlış olur
6. Store açınca ownership netleşiyor

Bu koşullar yoksa feature store açmak erken ve zayıftır.

---

# 22. App-Global Store Ne Zaman Meşru?

App-global store aşağıdaki tür durumlarda meşru adaydır:

- theme
- locale
- app-wide preferences
- shell-visible workspace context
- cross-feature app chrome state
- session-adjacent safe client state

Ama şu alanlarda app-global store zayıftır:

- screen filters
- query results
- local forms
- per-screen sheet state
- one-off flow progress
- temporary action result state

---

# 23. Derived State Politikası

## 23.1. Kural

Derived information mümkün olduğunca saklanmaz; hesaplanır.

## 23.2. Örnekler

- `isReady`
- `hasBlockingError`
- `visibleActions`
- `filteredItems`
- `canSubmit`

## 23.3. Neden?

Derived state’i store’a yazmak:
- sync problemleri
- duplicate truth
- harder debugging
üretir.

## 23.4. İstisna

Expensive derived computations optimize edilecekse memoization veya controlled derivation düşünülür.  
Ama bu, derived state’i otomatik mutable source yapmaz.

---

# 24. Cross-Platform Etkisi

## 24.1. Kural

Zustand kararı web ve mobile arasında behavior parity’ye hizmet etmek için verilmiştir; implementation parity’yi zorlamak için değil.

## 24.2. Sonuç

- shared client-owned contracts ortak olabilir
- ama platform-specific ephemeral UI state ortaklaştırılmak zorunda değildir
- storage/persistence behavior platforma göre dikkatle uyarlanmalıdır
- user-facing behavior aynı kalırken teknik binding farklı olabilir

---

# 25. Testing Üzerindeki Etki

Bu karar test stratejisinde şu sonuçları doğurur:

1. Store logic ve selectors izole testlenebilir olmalıdır
2. App-global store davranışı integration düzeyinde doğrulanmalıdır
3. Feature store varsa lifecycle ve reset kuralları test konusu olmalıdır
4. Persistence side-effects kontrolsüz bırakılmamalıdır
5. Server-state duplication test smell olarak ele alınmalıdır

---

# 26. Repo Yapısı Üzerindeki Etki

Bu karar şu fiziksel/topolojik sonuçları doğurur:

- app-global store alanları app shell veya shared application contracts düzeyinde net konumlanmalıdır
- feature stores feature module içinde kalmalıdır
- query cache store ile karıştırılmamalıdır
- form engine state aynı store package’ine gömülmemelidir
- persistence helpers güvenlik ve session kurallarıyla hizalanmalıdır

Bu yüzden `21-repo-structure-spec.md` bu ADR ile güncellenmelidir.

---

# 27. Quality Gates Üzerindeki Etki

Bu karar şu gate adaylarını meşrulaştırır:

- server state’i store’a kopyalayan pattern’lerin engellenmesi
- forbidden store misuse rules
- boundary rules for app-global store access
- persisted sensitive state checks
- logout reset discipline reviews
- store naming and placement rules

Bu kuralların hepsi ilk gün blocker olmak zorunda değildir.  
Ama canonical policy artık nettir.

---

# 28. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası reviewer ve contributor şu soruları sormalıdır:

1. Bu state neden store’a girdi?
2. Local veya feature-local çözüm neden yetmedi?
3. Bu server state mi?
4. Bu form state mi?
5. Bu derived state mi?
6. Persist gerekçesi nedir?
7. Reset/lifetime açık mı?
8. Wrong-user leak riski var mı?

Bu sorular cevapsızsa store kararı zayıftır.

---

# 29. Reddedilen Alternatiflerin Kısa Özeti

## 29.1. Redux Toolkit
Reddedildi çünkü:
- canonical ihtiyaç için gereksiz ceremony ve merkezileştirme riski taşır

## 29.2. Jotai / Recoil
Reddedildi çünkü:
- atom-level granularity yanlış state parçalanmasını teşvik edebilir
- canonical ownership modelini daha dağınık hale getirebilir

## 29.3. Context-only
Reddedildi çünkü:
- app-global state için yeterli clarity ve ergonomi sunmayabilir
- provider sprawl riski taşır

## 29.4. “No store ever”
Reddedildi çünkü:
- app-global client-owned state’in gerçek ihtiyaçlarını inkâr eder
- shell-level state için gereksiz zorlamalar üretir

---

# 30. Riskler

Bu kararın da riskleri vardır.

## 30.1. Zustand yanlış kullanılırsa mini-mega-store’lara dönüşebilir
Bu ciddi risktir.

## 30.2. “Hafif araç” rahatlığı store proliferation üretebilir
Yani kolay diye fazla store açılabilir.

## 30.3. Server-state duplication hala insan hatasıyla olabilir
Tool seçimi tek başına bunu engellemez.

## 30.4. Persistence yanlış kullanılırsa security/staleness problemi çıkar
Özellikle workspace/user-scoped state’lerde.

---

# 31. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. ADR-005 ile server-state policy kesin kapatılmalı
2. ADR-006 ile form-state policy ayrılmalı
3. Store opening checklist contribution guide’a eklenmeli
4. Boundary ve lint rules selected misuse’ları yakalamalı
5. Audit checklist store sprawl ve duplication’ı denetlemeli
6. DoD reset/persist kanıtı isteyebilmeli

---

# 32. Non-Goals

Bu ADR aşağıdaki alanları **çözmez**. Her biri kendi ilgili ADR veya policy belgesinde kapatılmıştır:

### 32.1. Server state yönetimi
API query data, cache lifecycle, stale/refetch mantığı, mutation result ownership ve invalidation graph bu ADR'nin kapsamı dışındadır. Server state yönetimi **ADR-005 — Data Fetching, Cache and Mutation Model** tarafından çözülür. Zustand'a server state kopyalanması bu ADR tarafından açıkça yasaklanmıştır (Bölüm 16).

### 32.2. Form state yönetimi
Field values, touched/dirty state, validation lifecycle, submit state ve field error tree bu ADR'nin kapsamı dışındadır. Form state yönetimi **ADR-006 — Forms and Validation** tarafından çözülür. Generic Zustand store ile form state çözümlenmesi bu ADR tarafından açıkça yasaklanmıştır (Bölüm 17).

### 32.3. Auth ve session state
Auth token transport protocol, session restore/expire lifecycle, biometric authentication state ve secure credential storage bu ADR'nin kapsamı dışındadır. Auth ve session state yönetimi **ADR-010 — Auth, Session and Secure Storage Baseline** tarafından çözülür.

### 32.4. Offline persistence stratejisi
Offline-first data sync, local-first storage engine seçimi, conflict resolution ve offline queue yönetimi bu ADR'nin kapsamı dışındadır. Offline persistence stratejisi **ADR-019 — Local Storage and Offline-First Strategy** tarafından çözülür. Bu ADR yalnızca Zustand store'larının sınırlı persistence kurallarını tanımlar (Bölüm 18); genel offline mimari kararı vermez.

### 32.5. Global CSS/styling state
Theme token'ları, design system renk/spacing değerleri ve platform-specific styling konfigürasyonu bu ADR'nin kapsamı dışındadır. Zustand yalnızca kullanıcı theme preference'ını (dark/light mode seçimi gibi) tutabilir; styling engine state'i ve token yönetimi **ADR-007 — Styling, Tokens and Theming Implementation** kapsamındadır.

### 32.6. Diğer kapsam dışı alanlar
- Persistence library exact selection (MMKV vs SecureStore detayları → ADR-019)
- Every selector pattern detail (implementasyon seviyesi kararı, bu ADR policy seviyesindedir)
- Mobile secure storage implementation specifics (→ ADR-010, ADR-019)

---

# 33. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. App-global client-owned state için Zustand resmi baseline kabul edilir
2. Server state store’a taşınmaz; query/cache katmanında kalır
3. Form state generic app store ile çözülmez
4. Derived state mümkün oldukça hesaplanır
5. Store açma kararı gerekçeli olmalıdır
6. Persistence, security ve reset kuralları store design’ın parçası olur

---

# 34. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- Zustand app-global state ihtiyaçları için sistematik olarak yetersiz kalırsa
- store policy aşırı friction üretirse
- ecosystem/tooling uyumu ciddi bozulursa
- cross-platform behavior parity için başka yaklaşım belirgin avantaj sunarsa

Bu seviyedeki değişiklik yeni ADR ve muhtemelen structural migration gerektirir.

---

# 35. Kararın Kısa Hükmü

> State management için canonical karar: app-global ve selected client-owned shared state Zustand ile yönetilir; server state, form state ve local transient UI state kendi doğru katmanlarında kalır. Store açmak varsayılan değildir; gerekçeli istisnadır. Mega store ve server-state duplication bu boilerplate’te kabul edilmez.

---

# 36. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Zustand seçiminin kapsamı açıkça yazılmışsa
2. Nelerin store’a gireceği ve girmeyeceği net ayrılmışsa
3. Server state ve form state ile sınırlar görünür kılınmışsa
4. Store policy, persistence ve reset mantığı açıklanmışsa
5. Alternatiflerin neden seçilmediği netse
6. Riskler ve mitigations görünürse
7. Bu karar implementasyon öncesi kilitlenmiş state baseline olarak kullanılabilecek netlikteyse

---

# 37. Zustand DevTools Entegrasyon Standardı

Zustand store’larının development ortamında görünür, debug edilebilir ve izlenebilir olması için DevTools entegrasyonu standardize edilmelidir.

## 37.1. Development Ortamı

- `zustand/devtools` middleware aktif olmalıdır
- Redux DevTools Extension ile bağlantı kurulur (Chrome/Firefox extension)
- Her store DevTools’ta ayrı instance olarak görünür
- Time-travel debugging desteği sayesinde state değişiklikleri geriye sarılabilir

## 37.2. Production Ortamı

- DevTools middleware **tamamen devre dışı** bırakılır
- Bundle’dan çıkarılır (tree-shaking ile veya conditional import ile)
- Konfigürasyon: `import.meta.env.DEV` koşullu middleware ekleme pattern’i kullanılır

## 37.3. Store Naming Convention

DevTools’ta görünen store adları **PascalCase** ve açıklayıcı olmalıdır:

- ✅ `AuthStore`, `ThemeStore`, `CartStore`, `WorkspaceStore`
- ❌ `store1`, `myStore`, `data`, `state`

Bu isimlendirme DevTools’ta store’ları hızlı tanımlamayı ve debug etmeyi kolaylaştırır.

## 37.4. Koşullu Middleware Örneği

```typescript
import { devtools } from ‘zustand/middleware’;

// DevTools sadece development’ta aktif
const withDevtools = import.meta.env.DEV
  ? (fn, name) => devtools(fn, { name })
  : (fn) => fn;
```

Bu pattern ile production bundle’da DevTools kodu yer almaz; development’ta ise tüm store değişiklikleri izlenebilir.

## 37.5. Time-Travel Debugging

DevTools entegrasyonu ile şu debug kabiliyetleri elde edilir:

- Her state değişikliğinin action adı ile loglanması
- State’in belirli bir ana geri sarılması (time-travel)
- State diff görünümü (hangi alan değişti)
- Action dispatch history

---

# 38. React Compiler ile Zustand Uyumu Analizi

React Compiler şu anda controlled opt-in ile watchlist’tedir (36-canonical-stack-decision.md). Etkinleştirildiğinde Zustand ile etkileşimi dikkatle değerlendirilmelidir.

## 38.1. Potansiyel Çakışma Alanları

Zustand’ın temel performans optimizasyonu **selector bazlı re-render kontrolü**ne dayanır. Kullanıcı `useStore(state => state.count)` şeklinde selector yazarak yalnızca `count` değiştiğinde re-render tetikler. React Compiler ise component seviyesinde otomatik memoization yapar.

Bu iki mekanizma birlikte çalıştığında:

- **useShallow hook’u gereksiz hale gelebilir:** Compiler’ın otomatik memo’laması shallow comparison’ı zaten yapıyor olabilir
- **Selector optimizasyonları çifte çalışabilir:** Hem selector hem Compiler aynı re-render’ı engellemeye çalışabilir; bu tehlikeli değildir ama gereksiz karmaşıklık üretebilir
- **Manuel React.memo ve useMemo kullanımları kaldırılabilir:** Compiler bunları otomatik yapacağı için store subscriber component’lerdeki manuel optimizasyonlar gereksizleşebilir

## 38.2. Test Stratejisi

Compiler opt-in yapıldığında aşağıdaki doğrulama adımları uygulanır:

1. Tüm store subscriber component’lerin **re-render sayısı benchmark’lanır** (before/after karşılaştırma)
2. `useShallow` kullanan component’lerin Compiler altında davranışı doğrulanır
3. Selector bazlı optimizasyonların Compiler ile çakışıp çakışmadığı tespit edilir
4. Production bundle size etkisi ölçülür

## 38.3. Geçiş Planı

1. **Şu an:** Manuel selector optimizasyonu devam eder, Compiler deneysel kalır
2. **Compiler stable olunca:** Sınırlı scope’ta (1-2 store subscriber component) pilot deneme yapılır
3. **Pilot başarılıysa:** Zustand selector pattern’leri gözden geçirilir; useShallow gereksizse kaldırılır
4. **Genişletme:** Tüm store subscriber component’ler Compiler altında test edilir ve geçiş tamamlanır

## 38.4. Mevcut Eylem

Şu anda herhangi bir aksiyon gerekmez. Manuel selector optimizasyonu canonical yaklaşım olmaya devam eder. Compiler stable release’i ve Zustand ekibinin resmi Compiler uyumluluk rehberi yayınlaması beklenir.

---

# 39. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te state management, merkezi store fetişi ile kurulmayacaktır. Zustand yalnızca gerçekten app-global veya kontrollü feature-scope client-owned state için kullanılacaktır. Server state query/cache katmanında, form state form engine içinde, local ephemeral state ise mümkün olduğunca component veya feature yakınında kalacaktır.

---

# 40. React 19 State Primitives ile İlişki

Bu bölüm, React 19.2 ile gelen state-related değişikliklerin Zustand-merkezli state mimarisi üzerindeki etkisini kaydeder.

## 40.1. use(Context) Kısa Yazımı

React 19, `useContext(MyContext)` yerine `use(MyContext)` yazılmasını destekler. Bu tamamen bir convenience syntax’tır; davranışsal fark yoktur.

**Bu boilerplate’teki pozisyonu:** Kabul edilir.

Zustand store’larına erişim zaten `useStore(selector)` pattern’i ile yapılır ve Context’e bağımlı değildir. Ancak React Context kullanan (ör: ThemeProvider, i18n) senaryolarda `use(Context)` kısa yazımı kullanılabilir. Bu bir mimari karar değil, syntax tercihidir.

## 40.2. useOptimistic

React 19 `useOptimistic` hook’u, asenkron operasyon tamamlanmadan önce UI state’ini geçici olarak güncellemek için tasarlanmıştır.

**Bu boilerplate’teki pozisyonu:** UI-local scope’ta kabul edilir; store’a yazılmaz.

`useOptimistic` ile üretilen geçici state, Zustand store’a yazılmamalıdır. Zustand store’lar "truth of record" niteliğindedir; optimistic state ise geçici ve spekülatif niteliktedir. Bu iki kavram aynı katmanda yaşamamalıdır.

**Kabul edilebilir kullanım:**
- Bir butonun tıklanmasıyla anlık UI geri bildirimi (like/unlike toggle)
- Form submit sonrası geçici başarı gösterimi
- Liste öğesi ekleme/çıkarma animasyonu için anlık UI güncellemesi

**Yasak kullanım:**
- `useOptimistic` çıktısını Zustand store’a yazmak
- Server state’i `useOptimistic` ile yönetmek (TanStack Query optimistic update kullanılmalı — ADR-005 §22)
- Global app state’i `useOptimistic` ile değiştirmek

## 40.3. useTransition ve useDeferredValue

Bu hook’lar React 18’de tanıtılmış, React 19’da olgunlaşmıştır. Concurrent rendering ile ağır hesaplamaları veya state güncellemelerini düşük öncelikli olarak işaretlerler.

**Bu boilerplate’teki pozisyonu:** Kabul edilir.

- `useTransition`: Ağır state güncellemelerini (ör: filtreleme, arama) non-blocking yapmak için kullanılabilir. Zustand store güncellemesini `startTransition` içinde çağırmak teknik olarak mümkündür ancak Zustand’ın senkron yapısı nedeniyle fayda sınırlıdır. Daha çok React state (`useState`) ile kullanıldığında etkilidir.
- `useDeferredValue`: Expensive render’ları geciktirmek için. Liste filtreleme, arama sonuçları gibi senaryolarda kullanılabilir.

## 40.4. Bilinçli Karar Kaydı

> Zustand 5.x bu boilerplate’in canonical client-side state management aracıdır. React 19 state primitives (use, useOptimistic, useTransition, useDeferredValue) Zustand’ı değiştirmez; UI-local optimizasyon ve convenience senaryolarında tamamlayıcı olarak kullanılabilir. Store ownership, persistence ve cross-component state paylaşımı Zustand’ın sorumluluğundadır.
