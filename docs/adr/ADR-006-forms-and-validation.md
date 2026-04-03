# ADR-006 — Forms and Validation

## Doküman Kimliği

- **ADR ID:** ADR-006
- **Başlık:** Forms and Validation
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational form architecture, validation and schema strategy decision
- **Karar alanı:** Form engine seçimi, validation/schema yaklaşımı, field lifecycle, submit behavior, async validation, error surface, draft/state sınırları
- **İlgili üst belgeler:**
  - `11-forms-inputs-and-validation.md`
  - `09-state-management-strategy.md`
  - `06-application-architecture.md`
  - `12-accessibility-standard.md`
  - `25-error-empty-loading-states.md`
  - `32-definition-of-done.md`
  - `36-canonical-stack-decision.md`
  - `ADR-004-state-management.md`
  - `ADR-005-data-fetching-cache-and-mutation-model.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `23-component-governance-rules.md`
  - `24-motion-and-interaction-standard.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `ADR-007-styling-tokens-and-theming-implementation.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında forms ve validation için aşağıdaki karar kabul edilmiştir:

- **Form engine:** React Hook Form
- **Validation / schema aracı:** Zod 4 (form + transport + domain sözleşmeleri için schema authority)
- **Canonical yaklaşım:** Form state, generic app-global store konusu değildir; dedicated form lifecycle ile yönetilir
- **Schema yaklaşımı:** Validation kuralları mümkün olduğunca schema-first ve type-safe tanımlanır
- **Submit yaklaşımı:** Form submit behavior, form engine ile mutation/query lifecycle arasında açık orchestration ile kurulur
- **Field yaklaşımı:** Reusable field shell + semantics-first + error/helper relation zorunlu
- **Async validation yaklaşımı:** İhtiyaç varsa controlled, debounced, user-friendly ve network-aware biçimde; ham, sürekli ve gürültülü değil
- **Draft / persistence yaklaşımı:** Form values varsayılan olarak kalıcı tutulmaz; yalnızca gerekçeli ve güvenli bağlamlarda controlled draft strategy kullanılır
- **Canonical ilke:** Form state ile app-global state, form validation ile backend error, field-level error ile form-level failure ve submit pending ile general loading birbirine karıştırılmaz

Bu ADR’nin ana hükmü şudur:

> Bu boilerplate’te formlar, local input yığınları veya generic global store mantığıyla değil; React Hook Form + Zod tabanlı, schema-aware, type-safe, accessibility-first ve explicit submit lifecycle modeliyle kurulacaktır. Form state form engine içinde, submit ve server interaction ise feature orchestration ile birlikte yönetilecektir.

---

# 2. Problem Tanımı

Formlar ürünlerde en sık dağınıklaştırılan alanlardan biridir.  
Bozulma genelde şu şekillerde olur:

- her input kendi local state’ini taşır
- validation kuralları JSX içine dağılır
- helper/error ilişkisi tutarsız olur
- submit pending ile page loading karışır
- form-level error ile field-level error karışır
- backend validation response rastgele UI’ya akıtılır
- aynı form logic’i farklı ekranlarda farklı davranır
- dirty/touched/reset mantığı unutulur
- “taslak” ihtiyacı olunca bütün form global store’a taşınır
- async validation kullanıcıyı boğan gürültüye dönüşür

Bu yüzden forms kararı yalnızca “hangi form library?” kararı değildir.  
Asıl karar şudur:

> Form state, field lifecycle, validation contract, error taxonomy, submit orchestration ve accessibility semantiği nasıl birlikte çalışacak?

Bu ADR tam olarak bunu kapatır.

---

# 3. Bağlam

Bu boilerplate’in forms ve validation açısından taşıdığı zorunluluklar şunlardır:

1. Web ve mobile arasında behavior parity
2. Accessibility-first form experience
3. Type-safe contract üretimi
4. Validation kurallarının dağılmaması
5. Form state’in generic store’lara dağılmaması
6. Submit lifecycle’ın mutation modeline doğru bağlanması
7. Error, helper, hint ve success surfaces’in net ayrılması
8. Reusable field components ve form patterns ile uyum
9. Draft/persistence kararlarının güvenli ve açık olması
10. Testing ve audit için form behavior’ın açık hale gelmesi

Bu bağlamda seçilecek çözüm şu iki uçtan da kaçınmalıdır:

- her field için local `useState` ve rastgele validation
- her şeyi store’a veya aşırı soyut “form service” yapısına taşıma

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Form lifecycle desteği**
2. **TypeScript ile güçlü uyum**
3. **Schema-driven validation desteği**
4. **Web ve mobile ile uyum**
5. **Performance**
6. **Reusable field patterns ile uyum**
7. **A11y semantics kurma kolaylığı**
8. **Submit orchestration’a uygunluk**
9. **Testing ergonomisi**
10. **Low ceremony**
11. **Ekosistem olgunluğu**
12. **Design-system-first yaklaşım ile uyum**

---

# 5. Değerlendirilen Alternatifler

Bu karar öncesi ana alternatifler şunlardır:

1. React Hook Form + Zod
2. Formik + Yup
3. React local state + custom validation
4. Zustand/Redux tabanlı form state
5. Headless custom form engine
6. TanStack Form gibi alternatif form yaklaşımları

Bu alternatiflerin neden seçilmediği veya seçildiği aşağıda açıklanmıştır.

---

# 6. Seçilen Karar: React Hook Form + Zod

## 6.1. Neden React Hook Form?

React Hook Form bu boilerplate için şu nedenlerle canonical seçim olarak kabul edilmiştir:

### 6.1.1. Form lifecycle için doğal yapı sunması
RHF şu alanları sistematik biçimde taşır:
- values
- touched
- dirty
- submit handling
- reset
- validation integration
- field registration
- controlled/uncontrolled denge

Bu, form behavior’ı random component logic olmaktan çıkarır.

### 6.1.2. Performance profili güçlüdür
Özellikle çok alanlı formlarda gereksiz rerender baskısını daha iyi yönetebilir.

### 6.1.3. React ve React Native ile doğal uyum
Hem web hem mobile tarafında güçlü pratik karşılığı vardır.

### 6.1.4. Reusable field abstraction’larıyla iyi çalışır
Bu boilerplate reusable field shell ve controlled form patterns kurmak istiyor.  
RHF bu zemine uygundur.

### 6.1.5. Low ceremony
Yeterince güçlüdür ama aşırı framework hissi vermez.  
Boilerplate için bu denge önemlidir.

---

## 6.2. Neden Zod?

Zod 4 şu nedenlerle seçilmiştir:

### 6.2.1. Validation + type safety birlikteliği
Bu proje validation’ı yalnızca “hata göster” alanı olarak değil, contract ve schema alanı olarak görüyor.  
Zod bu köprüyü güçlü kurar.

### 6.2.2. Runtime schema gücü
Sadece tip üretmek değil, gelen/giden veri ve form state kurallarını runtime’da doğrulamak için güçlüdür.

### 6.2.3. Modern TypeScript ekosistemi ile uyum
Inference ve schema ergonomisi güçlüdür.

### 6.2.4. Shared contract potansiyeli
Bazı validation kuralları yalnızca form UI meselesi değildir; domain-safe contract ile de ilişkilidir.  
Zod bu alanlarda anlamlı ortak zemin sunabilir.

---

## 6.3. Neden RHF + Zod kombinasyonu?

Bu kombinasyon şu nedenle canonical kabul edilmiştir:

> Form lifecycle ve validation contract iki ayrı ama uyumlu katman olmalıdır.

- RHF → form state, registration, submit lifecycle
- Zod → schema, parsing, validation contract

Bu ayrım temizdir.

---

# 7. Bu Karar Ne Anlama Gelmez?

Bu ADR çok kolay yanlış yorumlanabilir.  
Bu yüzden sınırlar açık yazılmalıdır.

## 7.1. “Zod yalnızca form field error üretmek için vardır” demek değildir
Her şey aynı katmanda çözülmez.  
Bazı kurallar domain katmanında, bazıları backend’te, bazıları UI semantics’te yaşar.

## 7.2. “Her form reusable schema paylaşmalı” demek değildir
Yapay ortaklaştırma kabul edilmez.

## 7.3. “RHF varsa field UX otomatik doğru olur” demek değildir
Field shell, helper, error, a11y, keyboard, touch ergonomisi yine tasarlanmalıdır.

## 7.4. “Form state store’a hiç temas etmeyecek” demek değildir
Doğrudan generic app store’a gömülmeyecek demektir.  
Ama feature orchestration veya justified draft state ile kontrollü ilişki olabilir.

## 7.5. “Backend validation artık önemsiz” demek değildir
Yanlış.  
Frontend validation kullanıcı deneyimi için vardır; backend validation veri bütünlüğü için yine zorunludur.

---

# 8. En Kritik İlke: Form State’in Resmi Evi

Bu ADR’nin kalbi şu cümledir:

> **Form state’in resmi evi form engine’dir. Generic app-global store değildir.**

Bu cümle pratikte şunu ifade eder:

- field values RHF içinde yaşar
- touched/dirty RHF içinde yaşar
- submit lifecycle RHF ve orchestration arasında yürür
- generic Zustand store form engine’in yerini almaz
- “taslak lazım olabilir” bahanesiyle tüm form state store’a taşınmaz

Bu ilke bozulursa form mimarisi dağılır.

---

# 9. Form State Türleri

Form state tek parça değildir. Bu ayrım net olmalıdır.

## 9.1. Field value state
Her alanın mevcut değeri.

## 9.2. Interaction state
- touched
- dirty
- visited benzeri sinyaller

## 9.3. Validation state
- field errors
- form-level validation issues
- parsing failures

## 9.4. Submit lifecycle state
- submitting
- submit succeeded
- submit failed
- retry possible

## 9.5. UI support state
- password visible toggle
- picker open/close
- local helper expansion
- inline preview state

Bu state aileleri aynı şey değildir ve tek booleans setine indirgenmemelidir.

---

# 10. Form Engine ve UI Arasındaki Sınır

## 10.1. Kural

Form engine:
- values,
- validation integration,
- submit plumbing,
- state lifecycle
konusudur.

UI ise:
- field shell,
- labels,
- helper/error rendering,
- spacing/hierarchy,
- accessibility semantics,
- touch/keyboard ergonomisi
konusudur.

## 10.2. Neden önemli?

RHF seçmek UI form kalitesini otomatik çözmez.  
Field components ve screen composition hâlâ tasarım sistemi ve a11y standardına göre kurulmalıdır.

---

# 11. Validation Katmanları

Validation tek katmanlı düşünülmemelidir. Bu ayrım çok kritiktir.

## 11.1. UI-level validation
Kullanıcı deneyimini yöneten erken sinyaller:
- required
- basic format
- length
- obvious invalid states

## 11.2. Schema-level validation
Form contract’ının type-safe ve runtime doğrulaması:
- field shape
- object structure
- transformation/parsing
- cross-field conditions (uygunsa)

## 11.3. Domain-level validation
Saf iş kuralı niteliği taşıyan kurallar:
- allowed combinations
- business constraints
- domain invariants

## 11.4. Backend validation
Sunucu tarafında zorunlu olan final güvenlik ve bütünlük katmanı.

## 11.5. Kural

Frontend form validation, backend doğrulamanın yerine geçmez.  
Ama kullanıcı deneyimini ciddi biçimde iyileştirmek için gereklidir.

---

# 12. Zod Şema Politikası

## 12.1. Kural

Form validation mümkün olduğunca schema-first tanımlanmalıdır.

## 12.2. Neden?

Çünkü:
- kurallar dağılmaz
- type inference güçlenir
- parsing ve validation birlikte düşünülür
- testing daha sistematik hale gelir
- field contract ve submit payload ilişkisi netleşir

## 12.3. Şema her şeyi içerir mi?

Hayır.  
Şemayı gereksiz evrensel kutsal nesne haline getirmek de yanlıştır.

Şema:
- açıklanabilir
- ilgili form alanıyla uyumlu
- bakım maliyeti makul
olmalıdır.

## 12.4. Zayıf davranışlar

- validation kurallarını JSX içine dağıtmak
- aynı kuralı üç farklı katmanda farklı yazmak
- form şemasını feature-dışı anlamsız shared nesneye dönüştürmek
- schema’ya presentation concern gömmek

---

# 13. Field-Level vs Form-Level Validation

## 13.1. Field-level validation
Tek alan üzerinden anlamlı olan kurallardır.

Örnek:
- e-posta formatı
- minimum uzunluk
- required
- sayı aralığı

## 13.2. Form-level validation
Alanlar arası ilişki veya bütün form bağlamı gerektiren kurallardır.

Örnek:
- şifre ve şifre tekrar eşleşmesi
- tarih aralığı mantığı
- en az bir seçim zorunluluğu
- iki alanın birlikte yasak kombinasyonu

## 13.3. Kural

Field error ile form-level error birbirine karıştırılmamalıdır.  
Kullanıcıya doğru yüzeyde gösterilmelidir.

---

# 14. Parse vs Validate Ayrımı

## 14.1. Neden kritik?

Birçok veri “yanlış” değil, önce parse edilmesi gereken ham input olabilir.

Örnek:
- text input’tan sayı
- boş string → undefined/null dönüşümü
- trimmed value
- normalized casing
- phone/date formatting

## 14.2. Kural

Parse / normalize / validate adımları rastgele screen handler’larda dağılmamalıdır.

## 14.3. Zod burada ne sağlar?

Schema ve transform mantığı uygun yerde kullanılabilir.  
Ama dönüşümler açıklanabilir ve sürprizsiz olmalıdır.

---

# 15. Submit Lifecycle Politikası

## 15.1. Submit tek action değildir

Submit şu aşamaları içerir:
- pre-submit validation
- submit attempt
- pending state
- backend response
- success/failure classification
- field errors dönüşü
- form-level error dönüşü
- post-submit reset/preserve behavior

## 15.2. Kural

Bu lifecycle açık düşünülmelidir.  
“onSubmit içinde API çağırdık bitti” yaklaşımı kabul edilmez.

## 15.3. Submit owner kimdir?

- RHF: form mechanics
- feature orchestration: server interaction + UX decisions
- query/mutation layer: async behavior
- presentation: visible user feedback

Bu ownership zinciri korunmalıdır.

---

# 16. Submit Pending State Politikası

## 16.1. Kural

Submit pending, page-level loading ile aynı şey değildir.

## 16.2. Neden?

Bir form submit olurken:
- tüm ekran kilitlenmek zorunda olmayabilir
- sadece ilgili aksiyon ve belirli alanlar etkilenebilir
- kullanıcı context kaybetmemelidir

## 16.3. Zayıf davranışlar

- küçük form submit’i için tüm ekran spinner’a dönüştürmek
- pending state’i hiç göstermemek
- kullanıcıya ikinci kez submit imkanı verip duplicate request üretmek
- pending state yüzünden helper/error visibility’i bozmak

---

# 17. Success Politikası

## 17.1. Kural

Success tek tip değildir.

Örnekler:
- inline success
- route transition sonrası success
- toast / banner support
- optimistic success
- silent success with updated state

## 17.2. Kural

Success feedback, görevin büyüklüğüne ve kullanıcı beklentisine göre verilmelidir.

## 17.3. Zayıf davranışlar

- kritik save sonrası sessiz kalmak
- trivial save sonrası aşırı gösterişli success
- success ile reset davranışını karıştırmak
- submit oldu mu olmadı mı kullanıcıyı belirsiz bırakmak

---

# 18. Error Politikası

## 18.1. Form error tek şey değildir

Aşağıdaki aileler ayrılmalıdır:

1. field-level validation error
2. form-level validation error
3. backend business validation error
4. auth/session error
5. permission error
6. network/transport failure
7. unknown technical failure

## 18.2. Kural

Bu error ailelerinin tamamı aynı kırmızı metin alanına dökülmez.

## 18.3. Neden?

Çünkü:
- bazıları alan düzeyinde çözülür
- bazıları form üstünde açıklanır
- bazıları kullanıcıyı yeniden kimlik doğrulamaya yönlendirir
- bazıları retry ister
- bazıları teknik destek/unknown issue karakteri taşır

## 18.4. Zayıf davranışlar

- ham backend mesajını alana yazmak
- form-level error’ı field altına koymak
- network failure ile validation failure’ı aynı muameleye tabi tutmak
- auth error’da kullanıcıyı form içinde sıkıştırmak

---

# 19. Backend Validation Error Mapping

## 19.1. Neden ayrı bölüm?

Çünkü en çok kaos burada çıkar.

## 19.2. Kural

Backend’ten gelen validation veya business rule error’ları controlled mapping ile UI’ya taşınmalıdır.

## 19.3. Olası hedef yüzeyler

- specific field errors
- form-level error block
- global auth/session handling
- inline non-field warning
- retry guidance

## 19.4. Zayıf davranışlar

- response error payload’ını olduğu gibi kullanıcıya göstermek
- field mapping yapmadan generic hata vermek
- non-field business error’ı yanlışlıkla bir alana bağlamak
- aynı backend hata kodunu farklı ekranlarda farklı yorumlamak

---

# 20. Reset Politikası

## 20.1. Form reset ne zaman düşünülmeli?

- submit success sonrası
- cancel sonrası
- modal close sonrası
- screen leave sonrası
- user switch/logout sonrası
- server-fetched default values değişince

## 20.2. Kural

Her form için şu açık olmalıdır:
- ne zaman reset olur?
- ne zaman values korunur?
- ne zaman dirty state temizlenir?
- ne zaman draft restore çalışır?

## 20.3. Zayıf davranışlar

- submit sonrası yanlışlıkla tüm input’u silmek
- başarısız submit sonrası formu gereksiz resetlemek
- modal kapanıp açılınca stale eski data bırakmak
- user switch sonrası önceki kullanıcının draft’ını göstermek

---

# 21. Draft ve Persistence Politikası

## 21.1. Kural

Form draft persistence varsayılan değildir.  
Yalnızca açık ürün değeri ve güvenli lifecycle varsa uygulanır.

## 21.2. Ne zaman meşru olabilir?

- uzun formlar
- kesinti riski yüksek multi-step süreçler
- kayıp maliyeti büyük kullanıcı girdileri
- offline/unstable connectivity senaryoları
- kullanıcıdan açıkça beklenen draft davranışı

## 21.3. Ne zaman zayıftır?

- kısa basit formlar
- güvenlik riski taşıyan alanlar
- user-bound data’nın yanlış kullanıcıya sızma riski
- reset/draft ownership’i belirsiz formlar

## 21.4. Kural

Draft, “her ihtimale karşı kaydedelim” mantığıyla açılmaz.

---

# 22. Async Validation Politikası

## 22.1. Neden dikkatli ele alınmalı?

Async validation yanlış uygulanırsa:
- sürekli ağ isteği yağmuru
- focus kaybı
- flicker
- kullanıcı baskısı
- false negative/positive hissi
üretir.

## 22.2. Meşru örnekler

- benzersiz kullanıcı adı kontrolü
- mevcut sistemde alınmış e-posta kontrolü
- server-backed invitation code validation
- domain rule’ın yalnızca backend’te bilinen kısmı

## 22.3. Kural

Async validation:
- debounced olmalı
- açık loading semantics taşımalı
- blocking ve non-blocking etkisi net olmalı
- offline/network failure ile validation failure karıştırılmamalı
- her tuş basışında agresif tetiklenmemelidir

## 22.4. Zayıf davranışlar

- kullanıcı yazarken her harfte request atmak
- network error’u “geçersiz değer” diye göstermek
- async validation yüzünden formu kullanılamaz hale getirmek
- server response gecikmesini kullanıcıya belirsiz bırakmak

---

# 23. Default Values Politikası

## 23.1. Kural

Default values açık ownership ile düşünülmelidir.

## 23.2. Olası kaynaklar

- static defaults
- server-fetched defaults
- draft restore values
- navigation context values
- shell/user/workspace context values

## 23.3. Sorulması gerekenler

- default value ne zaman yüklenir?
- query sonucu geç geldiğinde form nasıl davranır?
- kullanıcı düzenleme yaptıysa geç gelen veri override edecek mi?
- reset default’a mı, son draft’a mı döner?

## 23.4. Zayıf davranışlar

- async defaults gelince kullanıcı girdisini ezmek
- default ownership’i belirsiz bırakmak
- edit form ile create form davranışını aynı sanmak

---

# 24. Edit Forms vs Create Forms

## 24.1. Neden ayrı düşünülmeli?

Create ve edit aynı field’ları taşısa bile aynı lifecycle’ı taşımaz.

## 24.2. Edit form ek riskler

- fetched initial values
- partial mutation
- stale data
- optimistic patch ihtimali
- conflict resolution
- unsaved changes warning
- reset semantics

## 24.3. Kural

Edit form, create form’un küçük varyasyonu gibi ele alınmamalıdır.

---

# 25. Reusable Field Component Politikası

## 25.1. Kural

Form engine ile field component aynı şey değildir.

## 25.2. Reusable field shell ne taşımalıdır?

- label
- helper
- error
- required/optional semantics
- state visibility
- touch target
- spacing consistency
- assistive relationships
- invalid / disabled / focused surfaces

## 25.3. RHF integration ne yapar?

- value binding
- change handling
- validation lifecycle hookup

## 25.4. Zayıf davranışlar

- her form ekranında field shell’i yeniden yazmak
- helper/error ilişkisini field component dışında rastgele çözmek
- RHF bağlama kodu ile visual field contract’ı karıştırmak

---

# 26. Accessibility Politikası

## 26.1. Kural

Formlar a11y açısından birinci sınıf vatandaştır.  
Aşağıdaki alanlar düşünülmeden form done değildir:

- label / accessible name
- required state
- invalid state semantics
- helper / error relation
- focus order
- keyboard ergonomisi (web)
- touch ergonomisi (mobile)
- submit ve error feedback görünürlüğü
- color-only meaning’den kaçınma

## 26.2. Neden kritik?

Form bug’ı yalnızca UX sorunu değil; erişim engeli de olabilir.

---

# 27. Motion ve Interaction Politikası

## 27.1. Kural

Formlar da motion/interaction standardına uymalıdır.

## 27.2. Düşünülmesi gerekenler

- focus transitions
- error appearance
- helper expansion
- success confirmation
- keyboard/sheet transitions
- reduced motion uyumu

## 27.3. Zayıf davranışlar

- invalid state’i ani ve agresif görsel şokla vermek
- helper/error geçişlerinde layout kaosu üretmek
- reduced motion tercihine rağmen decorative animation kullanmak

---

# 28. Cross-Platform Etkisi

## 28.1. Kural

Form behavior parity korunmalıdır.  
Ama presentation ve ergonomi platforma göre uyarlanabilir.

## 28.2. Ortak kalması gerekenler

- validation mantığı
- submit semantiği
- error taxonomy
- success/retry mantığı
- required/optional kuralları
- field meaning
- data contract

## 28.3. Platforma göre farklılaşabilecekler

- keyboard flow
- picker surface
- modal/sheet usage
- dense data form layout
- inline vs full-screen edit ergonomisi

## 28.4. Keyboard Handling Stratejisi

Keyboard yönetimi, form ekranlarında kullanıcı deneyiminin temel parçasıdır. Yanlış yönetildiğinde aktif input keyboard arkasında kalır, kullanıcı submit butonuna erişemez veya form alanları arasında geçiş yapamaz. Bu bölüm, platform bazında keyboard handling kurallarını tanımlar.

### 28.4.1. Keyboard Avoidance

**Mobile (React Native):**
- Basit formlar (3-5 alan): `KeyboardAvoidingView` kullanılmalı — iOS’ta `behavior="padding"`, Android’de `behavior="height"`
- Uzun / scroll gerektiren formlar: `KeyboardAwareScrollView` (react-native-keyboard-aware-scroll-view) tercih edilmeli — aktif input’u otomatik olarak görünür alana kaydırır
- Bottom sheet içindeki formlar: Sheet kütüphanesinin built-in keyboard avoidance desteği kullanılmalı (ör. @gorhom/bottom-sheet)

**Web:** Tarayıcılar keyboard avoidance’ı otomatik yönetir. Ek React bileşeni gerekmez.

### 28.4.2. Focus Akışı ve Alan Geçişleri

Kullanıcı keyboard’daki "Next" tuşuyla bir sonraki alana geçebilmelidir. Bu akış programatik olarak kurulmalıdır:

1. Her alana `returnKeyType` tanımlanmalı: ara alanlar `"next"`, son alan `"done"` veya `"send"`
2. `onSubmitEditing` ile bir sonraki alana `ref.current?.focus()` yapılmalı
3. Son alandan "done" tuşu ile form submit tetiklenmeli
4. Formun birincil amacı veri girişiyse ilk alana `autoFocus` verilebilir

### 28.4.3. Keyboard Dismiss Kuralları

- Form dışına dokunma → keyboard kapanmalı (`keyboardDismissMode="on-drag"` veya `Keyboard.dismiss()`)
- Submit sonrası → keyboard kapanmalı (`Keyboard.dismiss()` submit handler içinde)
- Navigation (geri gitme) → keyboard kapanmalı
- Hata gösterimi → keyboard açık kalmalı (kullanıcı düzeltmeye devam edebilmeli)

Detaylı platform farkları tablosu ve kontrol listesi `D-FRM-forms-validation.md` guardrail dokümanındadır.

## 28.5. Zayıf davranışlar

- web’de güçlü validation varken mobile’da gevşek bırakmak
- mobile’da helper/error görünürlüğünü azaltmak
- aynı formu iki platformda farklı domain mantığıyla çalıştırmak
- keyboard açıldığında aktif input’un görünmez kalması
- form alanları arasında "Next" ile geçiş yapılamaması
- submit sonrası keyboard’un açık kalması

---

# 29. Testing Üzerindeki Etki

Bu karar test stratejisinde şu sonuçları doğurur:

1. Pure validation rules testlenebilir olmalıdır
2. Field component contract’ları component test konusu olur
3. Form submit lifecycle integration test konusu olur
4. Backend validation mapping testlenebilir olmalıdır
5. Draft/reset/preserve behavior riskliyse test veya audit konusu olmalıdır
6. A11y semantics form alanlarında doğrulanmalıdır

---

# 30. Repo Yapısı Üzerindeki Etki

Bu ADR şu topolojik sonuçları doğurur:

- reusable field components DS/package katmanında yaşayabilir
- form schemas feature veya domain bağlamına göre doğru yerde yaşamalıdır
- form engine glue code feature/screen orchestration ile ilişkili kalmalıdır
- backend error mapping screen içine dağılmaz
- draft helpers generic store package’ine rastgele gömülmez

Bu nedenle `21-repo-structure-spec.md` ve `23-component-governance-rules.md` bu ADR ile hizalanmalıdır.

---

# 31. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası contributor ve reviewer şu soruları sormalıdır:

1. Bu form neden RHF dışında çözüldü?
2. Validation kuralı nerede yaşıyor?
3. Field error ile form error ayrımı doğru mu?
4. Submit pending ve general loading karışmış mı?
5. Backend error mapping kontrollü mü?
6. Draft/persist gerçekten gerekli mi?
7. Reset/preserve davranışı açık mı?
8. A11y semantics eksiksiz mi?
9. Async validation kullanıcıyı boğuyor mu?
10. Web ve mobile behavior parity korunuyor mu?

---

# 32. Neden Formik + Yup Seçilmedi?

## 32.1. Formik kötü olduğu için değil

Formik tarihsel olarak yaygın ve birçok projede işe yarayabilir.  
Ama bu boilerplate için canonical seçim değildir.

## 32.2. Nedenleri

- modern React performans ve ergonomi beklentileri açısından RHF daha güçlü durur
- schema + type inference çizgisinde Zod daha uygun seçenektir
- RHF + Zod kombinasyonu daha modern, daha type-safe ve daha düşük ceremony ile ilerler

## 32.3. Sonuç

Formik + Yup reddedilmiştir çünkü kötü değil; canonical hedef için daha zayıf uyum sunmaktadır.

---

# 33. Neden Local State + Custom Validation Seçilmedi?

Bu yaklaşım canonical olarak reddedilmiştir çünkü:

- kurallar dağılır
- tekrar artar
- dirty/touched/reset mantığı tutarsızlaşır
- test ve review maliyeti artar
- büyük formlarda kaos üretir
- a11y ve helper/error ilişkisi standardize edilmez

Bu yaklaşım küçük prototiplerde tolere edilebilir olabilir; boilerplate foundation için değildir.

---

# 34. Neden Generic Store-Driven Forms Seçilmedi?

Bu da özellikle açık yazılmalıdır.

## 34.1. Neden reddedildi?

Çünkü generic store-driven forms:
- form engine davranışını yeniden icat etmeye iter
- field lifecycle’ı store action’larına boğar
- submit/validation ergonomisini bozar
- local form concern’lerini app-global concern haline getirir
- persistence ve cleanup riskini artırır

## 34.2. Sonuç

Store-based generic form modeli canonical olarak reddedilmiştir.

---

# 35. Riskler

Bu kararın da riskleri vardır.

## 35.1. RHF yanlış bağlanırsa field wrappers karmaşıklaşabilir
Özellikle kötü abstraction yapılırsa.

## 35.2. Zod aşırı kullanılırsa schema’lar gereksiz ağırlaşabilir
Her şeyi tek dev schema’ya dökmek yanlıştır.

## 35.3. Backend error mapping iyi tasarlanmazsa kullanıcı deneyimi yine bozulur
Tool bunu otomatik çözmez.

## 35.4. Draft persistence yanlış açılırsa güvenlik/stale risk çıkar
Özellikle edit ve session-bound formlarda.

## 35.5. Async validation yanlış yapılırsa UX kötüleşir
Bu ciddi risktir.

---

# 36. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. Reusable field shell contract’ları net yazılmalı
2. Form schema placement policy contribution guide’a girmeli
3. Backend error mapping standardı oluşturulmalı
4. Async validation guidelines yazılmalı
5. Draft/persist kararları DoD ve audit’e bağlanmalı
6. Form submit lifecycle integration testleri kritik alanlarda zorunlu olmalı
7. A11y form checklist’i audit içinde görünür olmalı

---

# 37. Non-Goals

Bu ADR aşağıdakileri çözmez:

- every field component API detail
- every schema naming convention
- exact form folder structure
- i18n copy policy for every validation message
- masked input strategy detail
- server code generation / schema sharing automation
- offline-first draft engine detayları

Bu alanlar sonraki belge ve policy’lerde kapanacaktır.

---

# 38. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. Forms canonical olarak React Hook Form ile kurulacaktır
2. Validation ve schema yaklaşımı canonical olarak Zod 4 ile kurulacaktır; Zod yalnızca form error değil, input/output/domain sözleşmeleri için schema authority olarak ele alınacaktır
3. Form state generic app store’a taşınmayacaktır
4. Field-level ve form-level error ayrımı korunacaktır
5. Submit lifecycle explicit tasarlanacaktır
6. Async validation yalnızca gerekçeli ve controlled biçimde kullanılacaktır
7. Draft/persistence varsayılan değil, istisna olacaktır
8. Reusable field shells design system ve a11y standardıyla hizalı kurulacaktır

---

# 39. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- RHF ve Zod kombinasyonu çok büyük form mimarilerinde sistematik darboğaz üretirse
- ecosystem ve maintenance dengesi ciddi bozulursa
- cross-platform form ergonomisi için daha güçlü ve olgun alternatif ortaya çıkarsa
- schema-validation modelinin proje ihtiyaçlarıyla belirgin biçimde çatıştığı görülürse

Bu seviyedeki değişiklik yeni ADR ve muhtemelen geniş form refactor’u gerektirir.

---

# 40. Kararın Kısa Hükmü

> Forms ve validation için canonical karar: form lifecycle React Hook Form ile, validation/schema contract’ı Zod ile kurulacaktır. Form state generic app-global store konusu değildir. Submit, validation, backend error mapping, draft/persist, a11y ve field shell behavior’ı explicit ownership ile tasarlanacaktır.

---

# 41. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. React Hook Form ve Zod seçiminin kapsamı açıkça yazılmışsa
2. Form state’in resmi evi net tanımlanmışsa
3. Validation katmanları ve error taxonomy görünür kılınmışsa
4. Submit, reset, draft, async validation ve a11y politikaları açıklanmışsa
5. Formik/Yup, local-state-only ve store-driven forms yaklaşımının neden canonical seçilmediği açıklanmışsa
6. Riskler ve mitigations görünürse
7. Bu karar implementasyon öncesi kilitlenmiş forms baseline olarak kullanılabilecek netlikteyse

---

# 42. Zod Schema Paylaşım Stratejisi

Monorepo’da frontend-backend arası schema paylaşımı ve tek kaynak ilkesi:

## 42.1. Paylaşımlı Schema Paketi

`packages/schemas/` altında tüm Zod schema’ları tanımlanır. Bu paket monorepo genelinde tek schema otoritesidir:

- **Frontend kullanımı:** Schema’dan form validasyonu + TypeScript tipi türetilir (`z.infer<typeof UserSchema>`)
- **Backend kullanımı (derived project):** Aynı schema’dan API request/response validasyonu yapılır
- **Avantaj:** Frontend ve backend arasında validation tutarsızlığı sıfırlanır. "Frontend kabul etti ama backend reddetti" veya tersi durumlar ortadan kalkar.

## 42.2. Schema Versiyonlama

- Schema paketi semantic versioning kullanır
- Breaking change’de (alan kaldırma, tip değişikliği) major versiyon artırılır
- Non-breaking change’de (yeni opsiyonel alan, validation kuralı yumuşatma) minor versiyon artırılır
- Tüm consumer’lar aynı schema versiyonunu kullanır (pnpm catalog ile garanti edilir)

## 42.3. Partial Schema Pattern’leri

Aynı entity için farklı form/API varyantları `z.pick()`, `z.omit()` ve `z.partial()` ile türetilir:

- **Create formu:** `UserSchema.omit({ id: true, createdAt: true })` — id ve timestamp server tarafında üretilir
- **Update formu:** `UserSchema.partial().required({ id: true })` — yalnızca değişen alanlar gönderilir, id zorunlu
- **List response:** `z.array(UserSchema.pick({ id: true, name: true, email: true }))` — yalnızca liste için gereken alanlar
- **Detail response:** `UserSchema` — tüm alanlar döner

Bu pattern code duplication’ı ortadan kaldırır ve entity değişikliğinde tüm varyantlar otomatik güncellenir.

## 42.4. Schema Organizasyonu

```
packages/schemas/
├── src/
│   ├── user.ts           # UserSchema + varyantları
│   ├── auth.ts           # LoginSchema, RegisterSchema
│   ├── product.ts        # ProductSchema + varyantları
│   ├── common.ts         # Paylaşılan alt schema’lar (AddressSchema, PhoneSchema)
│   └── index.ts          # Public API
├── package.json
└── tsconfig.json
```

---

# 43. Conditional Validation Pattern Kataloğu

Sık karşılaşılan koşullu validasyon reçeteleri ve Zod implementasyonları:

## 43.1. Tip Bazlı Zorunluluk (Discriminated Union)

**Senaryo:** "Şirket faturası seçiliyse vergi no zorunlu, bireysel fatura seçiliyse gereksiz"

```typescript
const InvoiceSchema = z.discriminatedUnion(‘invoiceType’, [
  z.object({
    invoiceType: z.literal(‘individual’),
    fullName: z.string().min(2),
  }),
  z.object({
    invoiceType: z.literal(‘corporate’),
    companyName: z.string().min(2),
    taxNumber: z.string().length(10),
    taxOffice: z.string().min(2),
  }),
]);
```

`discriminatedUnion` TypeScript tip narrowing’i otomatik sağlar; form UI’da tip seçimine göre alanlar dinamik gösterilir.

## 43.2. Değer Bazlı Validasyon (Refine)

**Senaryo:** "Ülke TR ise TC kimlik no formatı kontrol et"

```typescript
const ProfileSchema = z.object({
  country: z.string(),
  nationalId: z.string().optional(),
}).refine(
  (data) => data.country !== ‘TR’ || (data.nationalId && /^\d{11}$/.test(data.nationalId)),
  { message: ‘TC Kimlik No 11 haneli olmalıdır’, path: [‘nationalId’] }
);
```

`refine` ile cross-field validasyon yapılır; `path` ile hatanın hangi alana ait olduğu belirtilir.

## 43.3. Cross-Field Validasyon (SuperRefine)

**Senaryo:** "Şifre ve şifre tekrar eşleşmeli"

```typescript
const PasswordSchema = z.object({
  password: z.string().min(8),
  confirmPassword: z.string(),
}).superRefine((data, ctx) => {
  if (data.password !== data.confirmPassword) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: ‘Şifreler eşleşmiyor’,
      path: [‘confirmPassword’],
    });
  }
});
```

`superRefine` birden fazla hata üretebilir ve her hatayı farklı alanlara bağlayabilir.

## 43.4. Dinamik Alan Validasyonu (Array)

**Senaryo:** "Adres sayısı 1-5 arası olabilir, her adres complete olmalı"

```typescript
const AddressListSchema = z.object({
  addresses: z.array(
    z.object({
      street: z.string().min(5),
      city: z.string().min(2),
      zipCode: z.string().regex(/^\d{5}$/),
    })
  ).min(1, ‘En az bir adres girilmelidir’).max(5, ‘En fazla 5 adres eklenebilir’),
});
```

React Hook Form’un `useFieldArray` hook’u ile dinamik alan ekleme/çıkarma işlemi yapılır.

## 43.5. Conditional Required (Union + Refine)

**Senaryo:** "İletişim tercihi email ise email zorunlu, telefon ise telefon zorunlu"

```typescript
const ContactSchema = z.object({
  contactPreference: z.enum([‘email’, ‘phone’, ‘both’]),
  email: z.string().email().optional(),
  phone: z.string().optional(),
}).refine(
  (data) => {
    if (data.contactPreference === ‘email’ || data.contactPreference === ‘both’) {
      return !!data.email;
    }
    return true;
  },
  { message: ‘Email adresi zorunludur’, path: [‘email’] }
).refine(
  (data) => {
    if (data.contactPreference === ‘phone’ || data.contactPreference === ‘both’) {
      return !!data.phone;
    }
    return true;
  },
  { message: ‘Telefon numarası zorunludur’, path: [‘phone’] }
);
```

Her conditional pattern için form UI’da ilgili alanların visibility ve required durumu schema ile senkron yönetilir.

---

# 44. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te formlar random local state, generic store veya dağınık validation ile kurulmayacaktır. React Hook Form + Zod kombinasyonu, type-safe, a11y-first, schema-aware ve explicit submit lifecycle taşıyan canonical forms foundation olarak kabul edilmiştir. Form state form engine’de kalır; orchestration, mutation ve feedback onun etrafında kurulur.

---

# 45. React 19 Form API’leri ile İlişki

Bu bölüm, React 19.2 ile gelen form-related API’lerin bu boilerplate’teki konumunu açıkça kaydeder.

## 45.1. useFormStatus

React 19 `useFormStatus` hook’u, `<form>` elementinin submit durumunu (pending, data, method, action) child component’lere context üzerinden iletir. Bu hook React’in native `<form action={...}>` pattern’i ile çalışacak şekilde tasarlanmıştır.

**Bu boilerplate’teki pozisyonu:** Kullanılmaz.

Neden: React Hook Form 7.x (ADR-006 canonical) kendi `formState.isSubmitting` mekanizmasına sahiptir ve form submit lifecycle’ını tamamen yönetir. `useFormStatus` React’in `<form action>` pattern’i ile çalışır; RHF ise `handleSubmit` ile kendi submit pipeline’ını kontrol eder. İki sistem birlikte kullanıldığında submit state ownership çakışması oluşur.

## 45.2. useActionState

React 19 `useActionState` hook’u (önceki adıyla `useFormState`), Server Actions ile entegre bir form state yönetimi sunar. Server-side form processing ve progressive enhancement senaryoları için tasarlanmıştır.

**Bu boilerplate’teki pozisyonu:** Non-goal.

Neden: Bu boilerplate SPA-first mimaridedir (ADR-001). Server Actions ve Server Components bu mimarinin kapsamı dışındadır. Form submit işlemleri client-side RHF `handleSubmit` → TanStack Query mutation (ADR-005) → REST/GraphQL API zinciri üzerinden gerçekleşir. `useActionState`’in sunduğu server-side form processing bu zincirle uyumsuz ve gereksizdir.

## 45.3. React 19 `<form action={fn}>` Pattern’i

React 19, `<form>` elementine doğrudan `action` prop’u olarak bir fonksiyon geçirilmesini destekler. Bu pattern, form submit’i React’in transition mekanizması ile entegre eder.

**Bu boilerplate’teki pozisyonu:** Kullanılmaz.

Neden: RHF kendi `<form onSubmit={handleSubmit(onSubmit)}>` pattern’ini kullanır. React’in `<form action>` pattern’i ile RHF’in submit interception’ı aynı anda çalıştırılamaz. RHF canonical form engine olduğu sürece, React 19’un native form submission pattern’i bu boilerplate’te aktif değildir.

## 45.4. Bilinçli Karar Kaydı

Bu bölüm, React 19 form API’lerinin bilinçli olarak değerlendirildiğini ve reddedildiğini kaydeder:

> React Hook Form 7.x bu boilerplate’in canonical form engine’idir. React 19’un `useFormStatus`, `useActionState` ve `<form action>` pattern’leri SPA-first, client-side form mimarisi ile yapısal olarak uyumsuz oldukları için kullanılmaz. Bu karar, React 19 form API’lerinin kalitesiz olduğu anlamına gelmez; yalnızca bu projenin mimari tercihiyle hizalı olmadığı anlamına gelir.

## 45.5. Yeniden Değerlendirme Koşulu

Bu pozisyon aşağıdaki koşullardan biri gerçekleşirse yeniden değerlendirilir:

1. RHF’in React 19 form API’leri ile resmi entegrasyon katmanı yayımlaması
2. SPA-first mimariden SSR/RSC mimariye geçiş kararı alınması (yeni ADR gerektirir)
3. React 20+ ile form API’lerinin evrilmesi ve RHF’in bu evrimi benimsemesi
