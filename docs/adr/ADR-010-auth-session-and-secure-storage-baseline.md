# ADR-010 — Auth, Session and Secure Storage Baseline

## Doküman Kimliği

- **ADR ID:** ADR-010
- **Başlık:** Auth, Session and Secure Storage Baseline
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational security, auth boundary, session ownership and secure persistence decision
- **Karar alanı:** Authentication boundary, session modeli, token/session ownership, secure storage yaklaşımı, logout/reset disiplini, web ve mobile auth persistence farkları
- **İlgili üst belgeler:**
  - `27-security-and-secrets-baseline.md`
  - `09-state-management-strategy.md`
  - `06-application-architecture.md`
  - `10-data-fetching-cache-sync.md`
  - `28-observability-and-debugging.md`
  - `29-release-and-versioning-rules.md`
  - `36-canonical-stack-decision.md`
  - `ADR-002-mobile-runtime-and-native-strategy.md`
  - `ADR-004-state-management.md`
  - `ADR-005-data-fetching-cache-and-mutation-model.md`
  - `ADR-009-observability-stack.md`
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

Bu boilerplate kapsamında auth, session ve secure storage için aşağıdaki karar kabul edilmiştir:

- **Canonical auth yaklaşımı:** Backend-agnostic ama contract-first auth boundary
- **Auth/session ownership ilkesi:** Auth artefact’ları generic app-global UI state değildir
- **Web oturum yaklaşımı:** Mümkün olan yerde backend-managed, `HttpOnly` + `Secure` + uygun `SameSite` cookie tabanlı session tercih edilir
- **Web fallback yaklaşımı:** Backend zorunlu kılıyorsa constrained client-managed token modeli, ama canonical ilk tercih değildir
- **Mobile session persistence yaklaşımı:** Secure storage adapter; Expo-first baseline içinde canonical secure persistence aracı olarak `Expo SecureStore` sınıfı çözüm
- **Token görünürlük ilkesi:** Access/refresh token benzeri auth artefact’ları analytics, logs, generic stores ve debug yüzeylerine sızmaz
- **Session state yaklaşımı:** UI shell yalnızca session summary / auth status / capability summary gibi sanitized client-facing state tüketir
- **Logout ve user switch ilkesi:** Deterministic cleanup zorunludur; wrong-user leak kabul edilmez
- **Canonical ilke:** Auth sistemi UI kolaylığı için değil, security-first ownership ve lifecycle mantığıyla kurulacaktır

Bu ADR’nin ana hükmü şudur:

> Auth ve session bu boilerplate’te sıradan preference state, generic Zustand store verisi veya rastgele local storage konusu değildir. Web’de mümkün olan en güçlü varsayılan backend-managed secure cookie modelidir; mobile’da secure storage adapter kullanılır. UI yalnızca sanitize edilmiş auth/session summary tüketir; gerçek auth artefact’ları kontrollü boundary içinde kalır.

---

# 2. Problem Tanımı

Auth ve session alanı projelerde en hızlı yanlış çözülen alanlardan biridir.  
Tipik bozulmalar şunlardır:

- token generic global store’a yazılır
- localStorage’a her şey atılır
- logout sadece bir flag temizler
- user switch sonrası önceki kullanıcının cache/draft/context verisi kalır
- refresh token ve access token aynı şekilde ele alınır
- auth error ile permission error karıştırılır
- secure storage yerine convenience storage kullanılır
- debug/log/analytics içine hassas auth verisi düşer
- UI auth summary ile gerçek session artefact’ı aynı state’e karışır
- web ve mobile farkları düşünülmeden tek kaba çözüm dayatılır

Bu yüzden auth/session kararı yalnızca “hangi kütüphane?” veya “token nereye koyulacak?” sorusu değildir.  
Asıl soru şudur:

> Kimlik doğrulama ve oturum bilgisi hangi boundary içinde yaşayacak, hangi artefact nerede tutulacak, UI’ya hangi özet bilgi çıkacak, logout ve user switch nasıl temizlenecek ve web/mobile güvenlik farkları nasıl yönetilecek?

Bu ADR tam olarak bunu kapatır.

---

# 3. Bağlam

Bu boilerplate’in auth/session açısından taşıdığı zorunluluklar şunlardır:

1. Cross-platform ürün yapısı
2. Web ve mobile için farklı güvenlik gerçeklikleri
3. Security-first state ownership
4. Wrong-user leak riskini minimuma indirme
5. Query/cache/store/forms ile net sınırlar
6. Logout ve session expiry davranışlarının deterministik olması
7. Secure storage ve non-secure storage ayrımının net yapılması
8. Observability tarafında hassas veri sızmaması
9. Documentation-first lifecycle ve cleanup modeli
10. Backend sağlayıcısından bağımsız, ama gevşek olmayan auth boundary

Bu bağlamda auth yaklaşımı şu iki uçtan da kaçınmalıdır:

- her şeyi frontend convenience’ına göre storage’a dökmek
- aşırı soyut “auth service” tanımı yapıp somut lifecycle kararlarını belirsiz bırakmak

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Security ve threat-surface uygunluğu**
2. **Web ve mobile farklarını doğru ele alma**
3. **State ownership açıklığı**
4. **Logout/user switch cleanup güvenliği**
5. **Observability ve privacy uyumu**
6. **Session expiry ve re-auth yönetimi**
7. **Tooling/runtime uyumu**
8. **Backend-agnostic ama contract-driven olma**
9. **Maintenance ve audit kolaylığı**
10. **DX ama güvenliği delmeyen pragmatizm**
11. **Cross-platform parity of auth behavior**
12. **Long-term extensibility**

---

# 5. Seçilen Karar

Bu boilerplate için canonical auth/session baseline şu şekilde kabul edilmiştir:

## 5.1. Auth boundary
- explicit auth adapter / auth boundary
- provider veya SDK directly UI’ya saçılmaz
- UI, auth implementation detayını değil auth contract’ı tüketir

## 5.2. Web session preference
- mümkün olan yerde backend-managed secure cookie session
- `HttpOnly` + `Secure` + uygun `SameSite`
- frontend token okuyabilen ana model canonical değildir

## 5.3. Mobile session persistence
- secure storage adapter
- Expo-first baseline için canonical secure persistence: `Expo SecureStore` sınıfı çözüm

## 5.4. UI-facing auth state
- sanitized auth summary
- authenticated / unauthenticated / refreshing / expired benzeri status
- selected capability/session summary
- no raw secret exposure

## 5.5. Cleanup policy
- logout
- user switch
- workspace switch
- session expiry
durumlarında deterministic cleanup zorunlu

---

# 6. En Kritik İlke: Auth Artefact ile UI Session Summary Aynı Şey Değildir

Bu ADR’nin kalbi şu ayrımdır:

1. **Auth artefact’ları**
2. **UI-facing auth/session summary**

Bu iki şey kesinlikle karıştırılmamalıdır.

## 6.1. Auth artefact örnekleri

- access token
- refresh token
- session cookie
- provider session handle
- device credential pointer
- PKCE/state/nonce benzeri auth protocol transient değerleri

## 6.2. UI-facing summary örnekleri

- isAuthenticated
- current user summary
- auth status
- session expired classification
- workspace availability
- capability summary
- re-auth needed state

## 6.3. Kural

UI, mümkün olduğunca yalnızca ikinci grubu görmelidir.  
Birinci grup boundary içinde kalmalıdır.

---

# 7. Auth Boundary Kararı

## 7.1. Kural

Auth implementation detayları uygulama geneline dağılmaz.  
Canonical model explicit auth boundary / adapter katmanıdır.

## 7.2. Boundary ne yapar?

- login / logout / refresh / restore session semantics
- auth provider communication
- session restore attempt
- sanitized auth state üretimi
- token/session handling
- auth error classification
- session expiry handling
- user switch cleanup orchestration

## 7.3. Boundary ne yapmaz?

- screen-specific navigation kararlarının tamamını üstlenmez
- raw UI feedback render etmez
- feature business logic taşımaz
- analytics payload’larına auth artefact saçmaz

### 7.3.1. Auth Ekran Spec Referansı

Auth akışının somut ekran spec’leri `39-default-screens-and-components-spec.md` Bölüm 7’de tanımlanmıştır: Login (S08), Register (S09), Forgot Password (S10), Reset Password (S11), OTP Verification (S12), Biometric Prompt (S13). Her ekranın platform davranışı, kullanılan kütüphaneler ve Apple HIG uyum notları bu belgede detaylıdır.

## 7.4. Neden bu kadar önemli?

Çünkü auth çözümü provider’a, backend topology’ye veya SDK’ya sıkı bağlı olabilir.  
Bu karmaşıklık doğrudan screen/component seviyesine yayılmamalıdır.

---

# 8. Web Auth Session Kararı

## 8.1. Canonical tercih

Web tarafında mümkün olan yerde tercih edilen model:

> **Backend-managed secure session via `HttpOnly` cookies**

## 8.2. Neden bu tercih?

### 8.2.1. Token exposure surface azaltır
`HttpOnly` cookie modeli, JavaScript erişimini sınırlandırdığı için token theft yüzeyini azaltır.

### 8.2.2. Generic frontend state’e token saçma riskini düşürür
Frontend tarafında “token’ı store’a koy, header’a bas” kültürü zayıflar.

### 8.2.3. Security baseline daha güçlüdür
Özellikle XSS tehdidi perspektifinde daha kontrollü model sunabilir.

## 8.3. Bu karar ne anlama gelmez?

- CSRF yok sayılır demek değildir
- backend’in her durumda aynen bunu desteklediği varsayımı değildir
- frontend hiçbir auth logic taşımayacak demek değildir

## 8.4. Kural

Cookie session tercih ediliyorsa CSRF, session expiry, backend invalidation ve re-auth flow’ları ayrıca düşünülmelidir.

---

# 9. Web Fallback Kararı

## 9.1. Neden fallback gerekli?

Her backend veya auth provider cookie-session modeliyle gelmeyebilir.  
Bazı entegrasyonlarda client-managed access token kaçınılmaz olabilir.

## 9.2. Kural

Bu fallback model:
- canonical ilk tercih değildir
- gereksiz yere kolay yol diye seçilmez
- strict threat model ile ele alınır
- auth adapter arkasında tutulur

## 9.3. Ne anlama gelir?

Eğer web’de token client tarafında tutulmak zorundaysa:
- token lifecycle açık olacak
- memory vs storage kararı bilinçli olacak
- refresh flow güvenli tasarlanacak
- token generic store’a yayılmayacak
- logs/analytics/debug yüzeylerine sızmayacak

---

# 10. Mobile Secure Storage Kararı

## 10.1. Canonical tercih

Expo-first baseline içinde mobile secure persistence için canonical karar:

> **Secure storage adapter backed by Expo-compatible secure storage class solution**

Pratikte bu, v1 baseline için `Expo SecureStore` sınıfı çözümdür.

## 10.2. Neden?

### 10.2.1. Mobile secure persistence gerçek ihtiyaçtır
Mobile uygulama soğuk açılışlar, session restore ve re-auth senaryoları taşır.  
Convenience storage güvenli değildir.

### 10.2.2. Expo-first runtime ile doğal uyum
Bu karar, ADR-002 ile hizalıdır.

### 10.2.3. Sensitive artefact’ları generic storage’tan ayırır
Theme, locale, dismissed banner ile token aynı storage sınıfında düşünülmez.

## 10.3. Kural

Mobile session persistence için non-secure local storage canonical değildir.

---

# 11. Access Token, Refresh Token ve Session Handle Ayrımı

## 11.1. Neden kritik?

Birçok proje bu üç şeyi aynı şey gibi ele alır. Bu yanlıştır.

## 11.2. Access token
- kısa ömürlü olabilir
- request authorization için kullanılabilir
- exposure riskine çok duyarlıdır

## 11.3. Refresh token
- daha yüksek hassasiyet taşır
- lifecycle ve storage kararı daha sıkıdır
- generic UI state’e yaklaşmamalıdır

## 11.4. Session handle / cookie / backend session reference
- provider ve backend modeline göre farklılaşabilir
- frontend’in raw anlamda “okuması” gerekmeyebilir

## 11.5. Kural

Bu artefact’lar aynı storage ve aynı visibility policy ile ele alınmaz.

---

# 12. Token’lar Store’a Girebilir mi?

## 12.1. Canonical cevap

**Generic app-global state store’a hayır.**

## 12.2. Neden?

Çünkü bu:
- accidental exposure riskini artırır
- debug yüzeylerine sızmayı kolaylaştırır
- persistence yanlış kararlarını tetikler
- wrong-user leak ve cleanup riskini artırır
- auth artefact ile UI summary’yi karıştırır

## 12.3. UI ne görebilir?

- isAuthenticated
- current user summary
- session status
- refresh in progress
- re-auth required
- selected capability summary

## 12.4. İstisna benzeri alanlar?

Controlled in-memory access within auth adapter olabilir.  
Ama bu generic store ownership’i demek değildir.

---

# 13. LocalStorage / AsyncStorage / Generic Persistence Politikası

## 13.1. Kural

Auth artefact’ları için generic convenience storage canonical değildir.

## 13.2. Ne yasaklı sayılmalıdır?

Bağlama göre:
- raw token’ı localStorage’a koymak
- raw token’ı generic AsyncStorage benzeri non-secure katmana koymak
- auth session bilgisini dismissed UI preference ile aynı persistence katmanına gömmek

## 13.3. Neden?

Çünkü convenience storage:
- security riskini büyütür
- cleanup’i zorlaştırır
- yanlış kullanıcıya sızma ihtimalini artırır
- developer ergonomisi bahanesiyle sınırları bozar

---

# 14. Auth State Machine Düşüncesi

## 14.1. Kural

Auth yalnızca boolean `isLoggedIn` değildir.

## 14.2. Olası auth durumları

- unknown / bootstrapping
- unauthenticated
- authenticated
- refreshing
- session-expired
- reauth-required
- auth-error
- signing-out

## 14.3. Neden?

Bu ayrım yapılmazsa:
- splash ve boot davranışı karışır
- expired session ile logged-out aynı ele alınır
- refresh race condition’ları büyür
- UI yanlış yüzey gösterir

## 14.4. Kural

UI ve navigation gate’leri auth state machine semantiğini tüketmelidir; ham token var/yok mantığını değil.

---

# 15. Session Restore Politikası

## 15.1. Kural

App/web başlarken session restore deterministic tasarlanmalıdır.

## 15.2. Düşünülmesi gerekenler

- restore denemesi ne zaman yapılır?
- unknown → authenticated/unauthenticated geçişi nasıl olur?
- loading surface nasıl görünür?
- refresh başarısızsa ne olur?
- stale cache / previous user data ne zaman temizlenir?

## 15.3. Zayıf davranışlar

- önce eski kullanıcı verisini göstermek
- restore başarısız olsa da shell’i yanlış açmak
- restore sırasında belirsiz spinner kaosu
- session restore failure’ı sessizce swallow etmek

---

# 16. Logout Politikası

## 16.1. En kritik ilke

> Logout yalnızca bir boolean temizliği değildir.

## 16.2. Logout sırasında temizlenmesi gerekebilecek alanlar

- secure auth artefact’ları
- in-memory auth context
- query cache
- user-scoped client state
- drafts (policy’ye göre)
- workspace context
- feature-local persisted remnants
- analytics user binding
- diagnostics user context

## 16.3. Kural

Logout deterministic cleanup contract taşımalıdır.

## 16.4. Zayıf davranışlar

- token’ı silip query cache’i bırakmak
- önceki kullanıcının profile bilgisi görünmeye devam etmek
- analytics binding’i resetlememek
- debug/session summary yüzeylerinde önceki kullanıcı izlerini bırakmak

---

# 17. User Switch Politikası

## 17.1. Neden ayrı düşünülmeli?

User switch, logout + login’in birebir aynı UX karşılığı değildir.  
Ama security ve wrong-user leak açısından aynı ciddiyeti taşır.

## 17.2. Kural

User switch olduğunda:
- önceki user-scoped state temizlenmeli
- query cache scope resetlenmeli veya yeniden ayrıştırılmalı
- drafts ve persisted session-adjacent state yeniden değerlendirilmelidir
- analytics/observability user binding güncellenmelidir

## 17.3. Zayıf davranışlar

- yeni kullanıcı giriş yaptığında eski kullanıcının liste verisini kısa süre göstermek
- shared workspace context’i resetlememek
- storage namespace’i user-agnostic bırakmak

---

# 18. Workspace / Tenant Switch Politikası

## 18.1. Neden önemli?

B2B veya multi-workspace ürünlerde workspace switch, user switch kadar kritik olabilir.

## 18.2. Kural

Workspace-bound state:
- query key scope
- persisted context
- current selection
- capability summary
açısından ayrıştırılmalıdır.

## 18.3. Zayıf davranışlar

- workspace değişince önceki workspace’in data cache’ini UI’da tutmak
- current workspace scope’u query key’e yansıtmamak
- secure session ile workspace state’i birbirine karıştırmak

---

# 19. Session Expiry Politikası

## 19.1. Kural

Session expiry logged-out ile aynı UX’e kör indirilmez.

## 19.2. Neden?

Çünkü kullanıcı deneyimi açısından fark vardır:
- session expired
- network error
- revoked session
- manual logout
aynı şey değildir.

## 19.3. Doğru yaklaşım

- uygun classification
- gerekiyorsa re-auth flow
- pending work kaybı riski varsa kontrollü iletişim
- cache ve sensitive state cleanup

## 19.4. Zayıf davranışlar

- expiry durumunda sessiz sonsuz retry
- kullanıcıyı neden çıktığını anlamadan ana ekrana atmak
- expired session’da stale data göstermeye devam etmek

---

# 20. Auth Error Taxonomy

## 20.1. Neden kritik?

Auth error tek şey değildir.

## 20.2. Olası error aileleri

- invalid credentials
- session expired
- token refresh failed
- permission denied
- provider unavailable
- multi-factor required
- user disabled
- account locked
- network failure during auth
- unknown auth failure

## 20.3. Kural

Bu error aileleri aynı generic hata metnine indirgenmemelidir.

## 20.4. Neden?

Çünkü remediation farklıdır:
- tekrar giriş
- bekleme
- destek
- permission açıklaması
- retry
- MFA flow
- no-op with guidance

---

# 21. Auth ve Query Cache İlişkisi

## 21.1. Kural

Auth/session değişimi query cache davranışını etkiler.

## 21.2. Ne anlama gelir?

- user-scoped queries auth context ile bağlanmalıdır
- logout/user switch sonrası user-bound cache temizlenmelidir
- session expired durumunda stale protected data görünmeye devam etmemelidir

## 21.3. Zayıf davranışlar

- auth state değişti ama protected query data ekranda kaldı
- refresh başarısız olunca query error classification belirsiz kaldı
- user-scope query key disiplini yok

---

# 22. Auth ve Generic App State İlişkisi

## 22.1. Kural

Generic app state store auth implementation artefact’ı taşımaz.  
Yalnızca sanitized shell summary taşıyabilir.

## 22.2. Neler taşınabilir?

- auth status
- current user summary
- current workspace summary
- capability flags (sanitize edilmiş)
- session-expired surface state

## 22.3. Neler taşınmaz?

- raw tokens
- refresh tokens
- provider internals
- sensitive session payload’ları

---

# 23. Auth ve Forms İlişkisi

## 23.1. Kural

Login, signup, password reset, MFA gibi auth formları da generic forms standardına uymalıdır.

## 23.2. Düşünülmesi gerekenler

- credentials form values generic store’a gitmez
- validation ve error taxonomy kontrollü olur
- auth backend error’ları ham halde gösterilmez
- sensitive field değerleri logs/analytics’e sızmaz

## 23.3. Zayıf davranışlar

- auth form payload’ını analytics event’e koymak
- login failed error detaylarını raw backend string olarak göstermek
- remember me benzeri alanları yanlış storage ile karıştırmak

---

# 24. Observability ve Privacy İlişkisi

## 24.1. Kural

Auth/session observability privacy-first olmalıdır.

## 24.2. Görünür olabilir

- auth success/failure classification
- session restore success/failure
- session expired event
- re-auth required state
- permission denied classification

## 24.3. Görünür olmamalı

- raw token
- credentials
- secret claims
- full session payload
- raw auth response body

## 24.4. Zayıf davranışlar

- Sentry’ye token sızdırmak
- analytics payload’ına email/password basmak
- logs içinde credential data bırakmak

---

# 25. Secure Storage Adapter Politikası

## 25.1. Kural

Secure storage doğrudan app’in her yerinden çağrılan serbest API olmamalıdır.  
Auth boundary veya controlled secure persistence adapter ile çalışmalıdır.

## 25.2. Neden?

Çünkü:
- usage surface küçülür
- audit kolaylaşır
- secrets’in nerede tutulduğu görünür olur
- test/mocking daha temiz olur

## 25.3. Zayıf davranışlar

- her feature dosyasından secure storage erişimi
- random utility’lerin token okuması
- storage key’lerinin dağınık tanımlanması

---

# 26. Storage Namespace ve Scope Politikası

## 26.1. Kural

Persisted auth-adjacent ve user-bound state için namespace/scope düşünülmelidir.

## 26.2. Neden?

Çünkü:
- wrong-user leak
- workspace confusion
- stale drafts
- cleanup zorluğu
oluşabilir.

## 26.3. Düşünülmesi gerekenler

- device-scoped mi?
- user-scoped mi?
- workspace-scoped mi?
- session-scoped mi?

Bu sorular net değilse persistence risklidir.

---

# 27. Re-auth ve Session Refresh Politikası

## 27.1. Kural

Refresh / re-auth davranışı sessiz sihir gibi düşünülmemelidir.

## 27.2. Sorulması gerekenler

- refresh ne zaman tetiklenir?
- başarısız olursa classification ne olur?
- kullanıcıya ne gösterilir?
- pending mutation/query’lere ne olur?
- same request kaç kez tekrar denenir?

## 27.3. Zayıf davranışlar

- sonsuz refresh loop
- expired session’da görünmez retry storm
- auth failure’ı generic network failure gibi ele almak
- kullanıcıyı sessizce belirsiz durumda bırakmak

---

# 28. Web vs Mobile Farkları

## 28.1. Ortak kalması gerekenler

- auth boundary mantığı
- sanitized UI state
- logout/user switch cleanup disiplini
- observability privacy ilkesi
- auth error taxonomy
- session lifecycle classification

## 28.2. Farklılaşabilecekler

- persistence mekanizması
- browser cookie/session gerçekliği
- mobile secure store gerçekliği
- boot/restore UX detayları
- system auth / biometrics / deep link callback integration detayları

## 28.3. Sonuç

Behavior parity korunur; storage mechanism parity zorunlu değildir.

---

# 29. Biometric / Device Auth İlişkisi

## 29.1. Kural

Biometric veya device-level unlock mekanizmaları, auth/session modelinin yerine geçmez; yalnızca kontrollü ek katman olabilir.

## 29.2. Neden?

Çünkü:
- local device unlock, backend session validity ile aynı şey değildir
- false equivalence kullanıcı ve ekip için risklidir

## 29.3. Sonuç

Biometric support eklenirse ayrıca policy ister; base auth modelini değiştirmez.

---

# 30. Testing Üzerindeki Etki

Bu ADR test stratejisinde şu sonuçları doğurur:

1. Auth boundary behavior testlenebilir olmalıdır
2. Logout cleanup riskli alanlarda integration test konusu olur
3. Session restore davranışı test veya audit konusu olur
4. Wrong-user leak senaryoları özellikle doğrulanmalıdır
5. Auth error classification testlenebilir olmalıdır
6. Secure storage adapter usage kontrollü mock/test yüzeyi taşımalıdır

---

# 31. Repo Yapısı Üzerindeki Etki

Bu ADR şu topolojik sonuçları doğurur:

- auth boundary / adapter controlled katmanda yaşamalıdır
- secure storage helpers random utility klasörlerine dağılmaz
- session summary UI store’dan ayrı conceptual boundary’de tutulur
- auth provider specifics app-shell ve adapter seviyesinde kalır
- logout cleanup orchestration merkezi ve açıklanabilir olmalıdır
- biometric authentication modülü auth boundary içinde yaşamalıdır

Bu nedenle `21-repo-structure-spec.md` bu ADR ile hizalanmalıdır.

---

# 32. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası contributor ve reviewer şu soruları sormalıdır:

1. Burada auth artefact generic state’e sızıyor mu?
2. Bu veri secure storage gerektiriyor mu?
3. Logout/user switch cleanup gerçekten tamam mı?
4. Wrong-user leak riski var mı?
5. Session restore UX ve lifecycle açık mı?
6. Auth error classification doğru mu?
7. Logs/analytics/debug surfaces sensitive veri taşıyor mu?
8. Cookie/session vs token fallback kararı gerçekten gerekçeli mi?
9. Query cache auth değişimiyle uyumlu mu?
10. Bu auth implementation provider detayını UI’ya sızdırıyor mu?

---

# 33. Neden Web’de LocalStorage-First Token Modeli Seçilmedi?

## 33.1. Gerekçe

Web’de raw token’ı localStorage’a koyup tüm auth’ı bunun etrafında kurmak:
- exposure surface’i artırır
- XSS etkisini büyütür
- accidental log/debug sızıntısını kolaylaştırır
- cleanup ve wrong-user riskini artırır

## 33.2. Sonuç

Bu model canonical ilk tercih değildir.

---

# 34. Neden Auth’u Generic Zustand Store ile Çözmüyoruz?

## 34.1. Gerekçe

Çünkü Zustand UI-facing summary için uygundur; auth artefact ownership için değil.

## 34.2. Riskler

- persistence kolayca yanlış açılır
- token visibility artar
- auth vs shell summary karışır
- security review zorlaşır

## 34.3. Sonuç

Generic store-driven auth model canonical olarak reddedilmiştir.

---

# 35. Neden Mobile’da Generic AsyncStorage-First Model Seçilmedi?

## 35.1. Gerekçe

Mobile secure persistence ihtiyacı convenience storage ile aynı seviyede değildir.

## 35.2. Sonuç

Auth/session persistence için non-secure generic storage canonical baseline değildir.

---

# 36. Riskler

Bu kararın da riskleri vardır.

## 36.1. Backend-agnostic auth boundary kötü tasarlanırsa fazla soyut olabilir
Bu gerçek risktir.

## 36.2. Cookie-preferred model tüm backend’lere uymaz
Bu nedenle fallback policy gereklidir.

## 36.3. Secure storage yanlış scope ile kullanılırsa stale/wrong-user leak yine oluşabilir
Tool tek başına çözmez.

## 36.4. Cleanup orchestration eksik tasarlanırsa logout güvenli görünür ama eksik kalır
Bu ciddi risktir.

## 36.5. Session restore UX kötü tasarlanırsa güvenlik doğru olsa bile ürün deneyimi bozulur
Bu da kritik risktir.

---

# 37. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. Auth adapter contract dokümante edilmeli
2. Logout/user switch cleanup checklist hazırlanmalı
3. Sensitive payload denylist observability tarafına bağlanmalı
4. Secure storage access tek boundary’ye indirgenmeli
5. Query cache cleanup policy auth lifecycle ile bağlanmalı
6. Session restore ve expiry behavior audit edilmeli
7. Web fallback token modeli seçilirse ayrı security review yapılmalı

---

# 38. Non-Goals

Bu ADR aşağıdakileri çözmez:

- exact auth provider/vendor seçimi
- OAuth/OIDC/SAML detay protokolleri
- MFA implementation details
- biometrics full policy
- passwordless specifics
- backend session rotation specifics
- cookie attribute exact final values in every deployment environment
- web fallback token transport exact wiring

Bu alanlar ürün ve backend bağlamına göre ayrıca kapanacaktır.

---

# 39. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. Auth/session ownership generic app state’ten ayrılır
2. Web tarafında secure cookie session modeli mümkünse canonical tercih olur
3. Mobile tarafında secure storage adapter canonical hale gelir
4. UI yalnızca sanitized auth/session summary tüketir
5. Logout, session expiry ve user switch deterministic cleanup gerektirir
6. Observability ve analytics yüzeyleri auth sensitive data’yı taşımaz
7. Wrong-user leak, resmi audit ve DoD konusu olur

---

# 40. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- backend topology cookie-preferred modeli sistematik olarak imkânsız kılıyorsa
- Expo secure storage baseline uzun vadede yetersiz kalırsa
- auth provider gereksinimleri boundary modelini ciddi biçimde değiştirirse
- privacy/regulation veya enterprise security gereksinimleri farklı session modeli zorunlu kılarsa

Bu seviyedeki değişiklik yeni ADR ve muhtemelen geniş auth migration gerektirir.

---

# 41. Kararın Kısa Hükmü

> Auth, session ve secure storage için canonical karar: auth artefact’ları generic app state değildir; UI yalnızca sanitized session summary tüketir. Web’de mümkün olan yerde backend-managed secure cookie session tercih edilir; mobile’da secure storage adapter kullanılır. Logout, expiry ve user switch deterministic cleanup gerektirir; sensitive auth data observability, logs ve analytics yüzeylerine sızmaz.

---

# 42. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Auth artefact ile UI-facing session summary ayrımı açıkça yazılmışsa
2. Web cookie-preferred yaklaşımı ve mobile secure storage baseline net tanımlanmışsa
3. Generic store ve generic convenience storage sınırları görünür kılınmışsa
4. Logout, user switch, expiry ve restore politikaları açıklanmışsa
5. Privacy/observability sınırları netse
6. Neden localStorage-first, generic store-driven auth ve generic AsyncStorage-first modelin canonical seçilmediği açıklanmışsa
7. Riskler ve mitigations görünürse
8. Bu karar implementasyon öncesi kilitlenmiş auth/session baseline olarak kullanılabilecek netlikteyse

---

# 43. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te auth ve session, convenience-first frontend state problemi olarak ele alınmayacaktır. Auth artefact’ları kontrollü boundary içinde kalacak; UI yalnızca sanitize edilmiş auth/session summary tüketecektir. Web tarafında mümkün olan yerde secure cookie session tercih edilecek, mobile tarafında ise secure storage adapter kullanılacaktır. Logout, restore, expiry ve user switch davranışları deterministik ve security-first tasarlanacaktır.

---

# 44. Biometric Authentication Genisletmesi (2026-04-01 Eki)

Bu bolum ADR-010’un mevcut kararlarini degistirmez; biometric authentication katmanini tamamlayici olarak tanimlar. Mevcut auth boundary, secure storage ve session lifecycle kararlari aynen gecerlidir.

## 44.1. Canonical SDK

`expo-local-authentication` bu boilerplate’in biometric authentication SDK’sidir. Expo SDK 55.x managed workflow ile dogal uyum saglar ve ADR-002 Expo-first ilkesiyle hizalidir.

## 44.2. Desteklenen Biometric Yontemler

### 44.2.1. iOS

- **Face ID:** TrueDepth kamera tabanli yuz tanima
- **Touch ID:** Parmak izi tanima (eski cihazlar)
- **Optic ID:** Vision Pro cihazlarda iris tanima
- `NSFaceIDUsageDescription` plist key’i zorunludur; kullaniciya neden Face ID istendigini aciklar

### 44.2.2. Android

- **Fingerprint:** Parmak izi tanima
- **Face Unlock:** Yuz tanima (cihaz destegine bagli)
- **Iris:** Iris tanima (cihaz destegine bagli)
- BiometricPrompt API kullanilir; cihaz seviyesinde dogrulama yapilir

## 44.3. Security Level Ayrimi

### 44.3.1. biometricStrong (Class 3)

- Donanim tabanli biometric dogrulama
- Face ID, Touch ID ve Android BiometricPrompt BIOMETRIC_STRONG
- Guvenlik acisidan tercih edilen seviye
- Auth token unlock ve hassas islemler icin bu seviye zorunludur

### 44.3.2. biometricWeak (Class 2)

- Yazilim tabanli veya dusuk guvenlikli biometric dogrulama
- Bazi Android cihazlardaki yuz tanima
- Hassas islemler icin tek basina yeterli degildir
- Convenience unlock icin kabul edilebilir ama guvenlik-kritik islemlerde biometricStrong ile desteklenmelidir

### 44.3.3. Kural

Uygulama hangi security level’in mevcut oldugunu kontrol eder ve buna gore davranis belirler. biometricStrong yoksa hassas islemler icin PIN/sifre fallback zorunludur.

## 44.4. Fallback Mekanizmasi Zorunlulugu

- **Biometric her zaman opsiyoneldir; zorunlu degildir.** Kullanici biometric kullanmayi reddedebilir veya cihaz desteklemeyebilir.
- **Fallback yontemleri:** PIN, sifre veya pattern unlock her zaman alternatif olarak sunulur
- **Biometric basarisiz oldugunda** (taninmayan yuz/parmak, sensor hatasi) fallback otomatik sunulur
- **Accessibility:** Biometric kullanamayan kullanicilar (fiziksel engel, cihaz desteksizligi) icin alternatif yol her zaman mevcuttur. Biometric olmadan uygulamanin tum ozellikleri erisilebilir olmalidir.
- **Kilit sonrasi:** Birden fazla basarisiz biometric deneme sonrasi cihaz guvenlik kilidi devreye girer; uygulama bunu yonetmez, platform mekanizmasina birakir.

## 44.5. Biometric Veri Guvenligi

### 44.5.1. Veri cihazda kalir

- Biometric veri (parmak izi, yuz haritasi) cihazin Secure Enclave (iOS) veya TEE/StrongBox (Android) alaninda saklanir
- Bu veri uygulama tarafindan okunamaz, kopyalanamaz veya backend’e gonderilemez
- Uygulama yalnizca dogrulama sonucunu (basarili/basarisiz) alir

### 44.5.2. Backend’e gonderilmez

- Biometric veri, hash’i, template’i veya herhangi bir turetilmis verisi backend’e gonderilmez
- Backend biometric dogrulama sonucunu dogrudan guvenilir kaynak olarak kabul etmez; biometric yalnizca yerel cihaz unlock mekanizmasidir

### 44.5.3. Observability ve privacy

- Biometric event’leri (basari/basarisizlik) analytics’e yalnizca anonimlestirilmis ve aggreate olarak raporlanir
- Biometric hata detaylari (hangi parmak, hangi yuz acisi) loglanmaz
- Sentry veya diger crash reporting araclarinda biometric context bulunmaz

## 44.6. Biometric + Secure Storage Birlestirmesi (Token Unlock)

### 44.6.1. Senaryo

Kullanici uygulamayi actigi zaman biometric dogrulama ile secure storage’daki auth token’ina erisim saglanir. Bu, session restore isleminin kullanici dostu versiyonudur.

### 44.6.2. Akis

1. Uygulama aciliginda biometric enrollment durumu kontrol edilir
2. Biometric aktifse ve kullanici onayliysa biometric prompt gosterilir
3. Biometric dogrulama basariliysa secure storage’dan token okunur
4. Token gecerliligi kontrol edilir (expired ise refresh veya re-auth)
5. Basarisizsa veya kullanici iptal ederse PIN/sifre fallback sunulur

### 44.6.3. Kural

Biometric dogrulama basarisi otomatik olarak backend session gecerliligi anlamina gelmez. Biometric yalnizca yerel secure storage erisim kapisi olarak kullanilir; backend session validity ayrica dogrulanir.

## 44.7. Biometric Enrollment Durumu Kontrolu

- Uygulama baslarken `expo-local-authentication` ile cihazin biometric destegi kontrol edilir
- Kontrol edilen durumlar:
  - **Donanim destegi var mi?** (hasHardwareAsync)
  - **Biometric kayitli mi?** (isEnrolledAsync)
  - **Hangi biometric turleri mevcut?** (supportedAuthenticationTypesAsync)
  - **Security level nedir?** (biometricStrong vs biometricWeak)
- Biometric donanim yoksa veya kayit yapilmamissa biometric secenegi gosterilmez; fallback dogrudan sunulur
- Kullanici cihaz ayarlarindan biometric ekler/kaldirir; uygulama bir sonraki acilista durumu yeniden kontrol eder

---

# 45. Passkeys (FIDO2/WebAuthn) Watchlist

Passwordless authentication degerlendirmesi ve gelecek pozisyonu.

## 45.1. Durum

Passkeys su anda **Watchlist** statusundedir. Canonical stack'e alinmasi icin olgunluk ve ihtiyac kosullarinin karsilanmasi gerekir.

## 45.2. Teknoloji

FIDO2/WebAuthn standardi uzerine insa edilmis platform authenticator tabanlı kimlik dogrulama:

- **Nasil calisir:** Kullanici cihazin biyometrik dogrulamasi (Face ID, Touch ID, Windows Hello) ile public key cryptography tabanli kimlik dogrulama yapar. Sifre yerine cihazda saklanan private key kullanilir.
- **Platform destegi:** iOS 16+, Android 9+, macOS 13+, Windows 10+, modern web browsers (Chrome 108+, Safari 16+, Firefox 119+)
- **Sync destegi:** iCloud Keychain (Apple) ve Google Password Manager ile passkey'ler cihazlar arasi senkronize edilir

## 45.3. Avantajlar

- **Phishing-resistant:** Domain binding sayesinde phishing sitelerde passkey kullanilamaz
- **Kullanici deneyimi iyilesmesi:** Sifre hatirlamak ve girmek gerekmez; biyometrik ile tek dokunusla giris
- **Sifre yonetimi gereksiz:** Sifre sifirla, guclu sifre olustur, sifre manager gibi akislar ortadan kalkar
- **Guclu guvenlik:** Public key cryptography tabanli; sunucu tarafinda sifre saklanmaz

## 45.4. Boilerplate Etkisi

Passkeys eklendiginde auth flow'a asagidaki degisiklikler gelir:

1. **Registration:** Kullanici kayit sirasinda passkey olusturabilir (WebAuthn `navigator.credentials.create()`)
2. **Authentication:** Giris sirasinda passkey ile dogrulama yapabilir (WebAuthn `navigator.credentials.get()`)
3. **Fallback:** Passkey desteklemeyen cihazlar/browserlar icin geleneksel sifre giris yolu korunur
4. **Account recovery:** Passkey kaybedildiginde (cihaz degisikligi, factory reset) recovery mekanizmasi zorunludur

## 45.5. Degerlendirme Kosulu

Asagidaki kosullardan biri veya birkaci dogdugunda passkeys degerlendirmesi aktif hale gelir:

- Derived project'te passwordless authentication ihtiyaci kesinlestiginde
- Backend auth provider (ör. Firebase Auth, Auth0, Supabase) passkey destegi stable olarak sundugunda
- Hedef kullanici kitlesinin platform dagilimi passkey destegini yeterli kildiginda (iOS 16+, Android 9+ penetrasyon orani)

## 45.6. Library Adaylari

- **Web:** `@simplewebauthn/browser` (client) + `@simplewebauthn/server` (backend)
- **Mobile:** `react-native-passkey` veya Expo tarafindan saglanan future passkey modulu
- **Cross-platform:** Credential manager API'leri ile platform-native entegrasyon

## 45.7. Risk

- **Platform fragmentation:** Eski cihaz ve browser'larda passkey destegi yoktur; her zaman fallback gerekir
- **Recovery karmasikligi:** Passkey kaybedildiginde account recovery sureci karmasik olabilir
- **Backend bagimliligi:** WebAuthn server-side implementation gerektirir; backend-agnostic boilerplate icin ek zorluk

---

# 46. Token Refresh Race Condition Cozumu

Birden fazla eszamanli API cagrisi sirasinda token yenileme sorununu cozen queue-based pattern.

## 46.1. Problem

Tipik senaryo:
1. Kullanicinin access token'i expire olur
2. Ayni anda 3 API cagrisi 401 (Unauthorized) yaniti alir
3. Her biri bagimsiz olarak refresh token istegi gonderir
4. Ilk refresh basarili olur ve yeni access/refresh token pair uretilir
5. Diger 2 istek **eski** refresh token ile refresh dener → basarisiz olur (refresh token rotate edildiyse)
6. Kullanici beklenmedik sekilde logout edilir

Bu sorun ozellikle ekran acilisinda birden fazla query'nin paralel calismasi durumunda sik yasanir.

## 46.2. Cozum: Queue-Based Refresh Token Pattern

### Temel Mekanizma

1. Ilk 401 yaniti alindiginda **refresh lock** alinir (singleton promise olusturulur)
2. Diger 401 yaniti alan istekler **kuyruktaki promise'i bekler** (yeni refresh istegi gondermez)
3. Refresh basarili olunca yeni token ile **tum kuyruk replay edilir** (bekleyen istekler yeni token ile yeniden gonderilir)
4. Refresh basarisiz olunca **tum kuyruk reject edilir** ve kullanici logout edilir

### Implementation: Fetch/Axios Interceptor

```typescript
let refreshPromise: Promise<string> | null = null;

async function handleUnauthorized(failedRequest: Request): Promise<Response> {
  if (!refreshPromise) {
    // Ilk 401 — refresh baslatilir
    refreshPromise = refreshAccessToken()
      .finally(() => { refreshPromise = null; });
  }

  // Tum 401'ler ayni promise'i bekler
  const newToken = await refreshPromise;
  // Basarili — istegi yeni token ile tekrar gonder
  return fetch(failedRequest, { headers: { Authorization: `Bearer ${newToken}` } });
}
```

Bu pattern ile kac tane 401 gelirse gelsin yalnizca **tek bir refresh istegi** gonderilir.

## 46.3. Edge Case'ler

- **Refresh sirasinda uygulama kapatilirsa:** Yeniden acilista secure storage'daki refresh token ile yeni refresh denenir. Basarili olursa session devam eder, basarisiz olursa re-auth istenir.
- **Timeout:** Refresh istegi **10 saniye** icinde cevap gelmezse fail kabul edilir ve kullanici logout edilir. Network hatasi durumunda retry yapilmaz (refresh token'in zaten kullanilmis olma riski).
- **Concurrent tab (web):** BroadcastChannel veya localStorage event listener ile tab'lar arasi token senkronizasyonu saglanir. Bir tab refresh yaparsa diger tab'lar yeni token'i alir.
- **Refresh token rotation:** Her refresh sonrasi yeni refresh token uretiliyorsa (rotation), eski refresh token gecersiz hale gelir. Bu nedenle tek istek pattern'i kritiktir.

## 46.4. Sentry Entegrasyonu

- Token refresh failure event'i Sentry'ye raporlanir (hassas token bilgisi olmadan)
- Refresh timeout ve network error sayilari izlenir
- Anormal refresh pattern (ör. 1 dakikada 50+ refresh) alert uretir

## 44.8. Platform-Specific Davranis Farklari

### 44.8.1. iOS

- Face ID ilk kullanildiginda sistem izin dialog’u gosterir; kullanici reddederse ayarlardan acmasi gerekir
- Touch ID icin ayrica izin gerekmez; enrollment yeterlıdir
- Keychain entegrasyonu ile biometric-protected item’lar tanimlanabilir
- `LAPolicy.deviceOwnerAuthenticationWithBiometrics` vs `LAPolicy.deviceOwnerAuthentication` ayrimi yapilir

### 44.8.2. Android

- BiometricPrompt sistem dialog’u gosterir; custom UI yasaktir (platform kuralı)
- `setNegativeButtonText` ile iptal butonu yonetilir
- `setAllowedAuthenticators` ile BIOMETRIC_STRONG, BIOMETRIC_WEAK ve DEVICE_CREDENTIAL kombinasyonlari belirlenir
- Android 10+ cihazlarda biometric API tutarlıdır; eski cihazlarda FingerprintManager fallback expo-local-authentication tarafindan yonetilir

### 44.8.3. Ortak davranis

- Biometric prompt UI platform-native olur; custom biometric UI olusturulmaz
- Dogrulama sonucu (basari/basarisizlik/iptal) her iki platformda ayni sekilde ele alinir
- Biometric tercih durumu kullanici bazinda secure storage’da tutulur

## 44.9. Passkey Destegi Hazirligi (WebAuthn / FIDO2)

### 44.9.1. Gelecek yonelim

Passkey (WebAuthn / FIDO2) password-less authentication standardidir. Apple, Google ve Microsoft tarafindan desteklenmektedir.

### 44.9.2. Hazirlik ilkeleri

- Auth boundary mimarisi passkey entegrasyonuna izin verecek sekilde tasarlanir
- Auth adapter contract’i passkey credential turunu destekleyecek genislikte tutulur
- Passkey implementation detaylari bu ADR kapsaminda degildir; ayri ADR gerektirir
- Mevcut biometric authentication passkey’in yerini almaz; passkey hazir olana kadar biometric + token modeli gecerlidir

### 44.9.3. Kural

Passkey destegi eklendiginde mevcut biometric flow graceful degradation ile korunur. Passkey desteklemeyen cihazlarda biometric + fallback modeli devam eder.

## 44.10. Biometric Authentication Non-Goals

Bu genisletme asagidakileri cozmez:

- Passkey / WebAuthn / FIDO2 tam implementation
- Multi-factor authentication (MFA) tam stratejisi
- Biometric-only auth (biometric tek basina backend session olusturmaz)
- Continuous authentication (surekli biometric dogrulama)
- Biometric veri yedekleme ve cihazlar arasi transfer
- Kurumsal (enterprise) biometric policy yonetimi

## 44.11. Biometric Onay Kriterleri

Bu genisletme yeterli kabul edilir eger:

1. Canonical SDK secimi (`expo-local-authentication`) ve gerekcesi acikca yazilmissa
2. Fallback mekanizmasi zorunlulugu net tanimlanmissa
3. Biometric veri guvenlik ilkeleri (cihazda kalir, backend’e gonderilmez) belirtilmisse
4. Security level ayrimi (biometricStrong/biometricWeak) aciklanmissa
5. Biometric + secure storage birlestirmesi (token unlock) tanımlanmissa
6. Enrollment durumu kontrolu detaylandirilmissa
7. Platform-specific davranis farklari (iOS/Android) gorunur kilinmissa
8. Passkey hazirligi ilkeleri yazilmissa
9. Accessibility gereksinimi (biometric kullanamayan kullanicilar icin alternatif) acikca belirtilmisse
10. Mevcut ADR-010 kararlariyla celismedigi dogrulanmissa

---

# 45. Passkeys (FIDO2/WebAuthn) — Watchlist Stratejisi (2026-04 Güncellemesi)

## 45.1. Passkeys Nedir?

Passkeys, FIDO Alliance ve W3C tarafından standartlaştırılan, şifresiz (passwordless) kimlik doğrulama teknolojisidir. Geleneksel şifre + SMS OTP yerine cihazda saklanan kriptografik anahtar çifti (public key + private key) kullanır.

Teknik olarak passkeys şu bileşenlerden oluşur:

- **WebAuthn (Web Authentication API):** Tarayıcı ve uygulama tarafında kullanılan JavaScript API'si. Kullanıcı kimliğini doğrulamak için cihaz authenticator'ı ile iletişim kurar.
- **FIDO2 protokolü:** Sunucu ile istemci arasındaki kimlik doğrulama protokolü. Challenge-response modeline dayalıdır.
- **Platform authenticator:** Cihazın kendisi (Face ID, Touch ID, parmak izi, Windows Hello). Harici donanım token'ı gerektirmez.
- **Discoverable credentials:** Kullanıcı adı girmeye bile gerek kalmadan, cihaz hangi credential'ın bu site/uygulama için geçerli olduğunu otomatik tespit eder.

### Kullanıcı deneyimi şu şekilde çalışır:

1. Kayıt (registration): Kullanıcı hesap oluştururken veya passkey eklerken, cihaz bir anahtar çifti üretir. Public key sunucuya gönderilir, private key cihazda (Secure Enclave / TEE / Keystore) kalır.
2. Giriş (authentication): Sunucu bir challenge gönderir. Cihaz, private key ile challenge'ı imzalar ve sunucu public key ile doğrular. Şifre hiçbir zaman ağ üzerinden geçmez.
3. Cross-device: iCloud Keychain (Apple), Google Password Manager veya Windows Hello üzerinden passkey'ler cihazlar arası senkronize olur.

## 45.2. Platform Desteği (2026 Durumu)

- **iOS 16+:** Tam destek. Safari ve native uygulamalar. iCloud Keychain ile senkronizasyon.
- **Android 9+:** Tam destek. Chrome ve native uygulamalar. Google Password Manager ile senkronizasyon.
- **Web (modern tarayıcılar):** Chrome, Safari, Firefox, Edge — WebAuthn API tam destekli.
- **React Native:** expo-passkeys (community) veya react-native-passkeys kütüphaneleri ile entegrasyon mümkün.

## 45.3. Neden Watchlist?

Bu ADR passkeys'i canonical baseline'a almak yerine watchlist'e koymaktadır çünkü:

1. **Backend bağımlılığı:** Passkeys, sunucu tarafında WebAuthn relying party desteği gerektirir. Bu boilerplate backend-agnostic olduğu için sunucu tarafı kararı projeden projeye değişecektir.
2. **React Native ekosistem olgunluğu:** expo-passkeys henüz erken aşamadadır. API yüzeyi değişebilir.
3. **Fallback zorunluluğu:** Tüm kullanıcılar passkey destekli cihaz kullanmaz. Şifre tabanlı fallback her durumda gerekli kalır.
4. **UX karmaşıklığı:** Passkey kayıt/giriş akışı, kullanıcılara açıkça anlatılması gereken yeni bir kavramdır.

## 45.4. Ne Zaman Canonical Baseline'a Alınabilir?

1. expo-passkeys veya eşdeğeri stable release'e ulaşmış olmalı
2. Backend entegrasyon rehberi yazılmış olmalı (en az bir referans backend — Firebase Auth, Clerk veya custom)
3. Cross-platform (web + iOS + Android) passkey akışı end-to-end test edilmiş olmalı
4. Fallback auth akışı (şifre tabanlı) ile birlikte çalıştığı doğrulanmış olmalı
5. Bu ADR revize edilmeli ve passkeys bölümü "watchlist" yerine "conditional track" veya "canonical" statüsüne alınmalı

## 45.5. Mevcut ADR-010 ile İlişki

Bu ek, ADR-010'un mevcut kararlarını değiştirmez. Mevcut auth baseline şu şekilde kalır:
- Web: Backend-managed HttpOnly cookies (tercih edilen)
- Mobile: Expo SecureStore (secure storage adapter)
- Biometric: expo-local-authentication (device-level biometric)

Passkeys bu yapının üzerine opsiyonel bir ek katman olarak eklenebilir; mevcut auth boundary ve cleanup policy'yi bozmaz. Passkey credential'ları da auth artefact'ı olarak kabul edilir ve UI-facing auth summary'den ayrı tutulur.

## 45.6. Geçici Kullanım Kuralı

Passkeys, canonical baseline olmadan şu koşullarda denenebilir:
- spike veya POC çalışmalarında
- backend sağlayıcısı (Clerk, Firebase Auth v2 vb.) native passkey desteği sunuyorsa
- kullanım documented ve scoped olmalı
- production feature'da kullanım ADR uzantısı veya exception kaydı gerektirir

---

# 46. Social Login / Third-party Auth Providers (2026-04 Eki)

Bu bölüm, social login (Apple Sign In, Google Sign In vb.) ve üçüncü taraf kimlik doğrulama sağlayıcılarının boilerplate içindeki konumunu, entegrasyon stratejisini ve mevcut ADR-010 kararlarıyla uyumunu tanımlar.

## 46.1. Boilerplate Pozisyonu

- Social login boilerplate tarafından "watchlist + ready-to-adopt" konumdadır
- Boilerplate, social login altyapısını hazırlar; hangi provider'ların aktif edileceği derived project kararıdır
- Apple Sign In: iOS uygulamasında üçüncü taraf login sunuluyorsa Apple Sign In sunulması **ZORUNLUDUR** (App Store Review Guidelines 4.8)
- Google Sign In: Opsiyonel, yaygın kullanım nedeniyle tercih edilir

## 46.2. Apple Sign In

- **Zorunluluk:** iOS'ta herhangi bir social/third-party login (Google, Facebook vb.) sunuluyorsa Apple Sign In da sunulmalıdır
- **Kütüphane:** `expo-apple-authentication` (Expo managed workflow uyumlu)
- **Flow:** `ASAuthorizationController` → identity token + authorization code → backend doğrulama
- **UI:** "Sign in with Apple" butonu Apple Human Interface Guidelines'a uymalıdır (siyah/beyaz tema, minimum boyut, Apple logosu)
- **Özel durum:** Kullanıcı "Hide My Email" seçebilir → relay email adresi döner
- **Privacy:** Apple Sign In kullanıcının gerçek email'ini paylaşmak zorunda bırakmaz

## 46.3. Google Sign In

- **Durum:** Opsiyonel (derived project kararı)
- **Kütüphane seçenekleri:**
  - `@react-native-google-signin/google-signin`: Native Google Sign In SDK
  - `expo-auth-session`: Generic OAuth flow (daha az native ama daha basit)
- **Flow:** Google OAuth → ID token → backend doğrulama
- **Web:** Google Identity Services (One Tap Sign In) veya OAuth popup
- **Scope:** Minimum gerekli scope (`profile`, `email`) — aşırı permission isteme

## 46.4. OAuth Flow ve Token Mapping

- Social provider'dan alınan token (identity token / ID token) doğrudan kullanılmaz
- Token backend'e gönderilir → backend kendi session token'ını döner
- Backend session token'ı mevcut ADR-010 auth boundary içinde yönetilir:
  - **Web:** HttpOnly cookie
  - **Mobile:** Expo SecureStore
- Social provider token'ı client'ta **SAKLANMAZ** — backend doğrulaması yeterlidir
- **Logout:** Social provider session'ı ayrıca kapatılmalıdır (revoke token)

## 46.5. Expo AuthSession Kullanımı

- `expo-auth-session`: Generic OAuth 2.0 / OpenID Connect flow
- **Redirect URI:** Expo Auth Proxy veya custom scheme
- **Platform farkları:**
  - iOS: `ASWebAuthenticationSession` (secure browser)
  - Android: Custom Chrome Tab
  - Web: Popup veya redirect
- **Avantaj:** Herhangi bir OAuth provider (GitHub, Microsoft, Twitter vb.) ile çalışır
- **Dezavantaj:** Native SDK kadar smooth UX sağlamayabilir

## 46.6. Derived Project Kararı

Boilerplate auth altyapısını hazırlar (token mapping, session yönetimi, logout flow). Provider seçimi derived project'e bırakılır:

- **E-commerce:** Apple + Google genellikle yeterli
- **Enterprise:** Microsoft/Azure AD eklenebilir
- **Sosyal platform:** Facebook, Twitter eklenebilir

Her yeni provider eklenmesinde: abstraction layer (`authService.loginWith(provider)`) üzerinden, doğrudan SDK çağrısı component'te yapılmaz.

## 46.7. Mevcut ADR-010 ile Uyum

- Social login token'ları da "auth artefakt" kategorisindedir (bölüm 6)
- Aynı cleanup/logout policy geçerlidir
- UI-facing auth summary'de provider bilgisi tutulabilir: `{ provider: "apple", displayName: "..." }`
- Biometric login social login ile birlikte çalışabilir (SecureStore'daki session token biometric ile korunur)

## 46.8. Anti-pattern'ler

- Social provider token'ını `localStorage`/`AsyncStorage`'a yazmak (güvenlik riski)
- Apple Sign In sunmadan diğer social login'leri sunmak (iOS red riski)
- Social login callback'inde error handling atlamak (silent failure)
- Her social login butonunda farklı auth flow implementasyonu (abstraction layer kullan)
- Kullanıcıya gereksiz permission scope istemek (veri minimizasyonu ihlali)

---

# 47. Passkeys (FIDO2/WebAuthn) Yol Haritası

Bu bölüm, passwordless authentication için passkeys teknolojisinin bu boilerplate'teki konumunu ve geçiş stratejisini tanımlar.

## 47.1. Mevcut Pozisyon: Watchlist → Pilot Candidate

Passkeys (FIDO2/WebAuthn) 2026 itibarıyla iOS 16+ ve Android 9+ cihazların büyük çoğunluğunda desteklenmektedir. Bu boilerplate passkeys'i **pilot candidate** olarak değerlendirir; henüz canonical auth yöntemi olarak kabul etmez.

## 47.2. Passkeys'in Avantajları

- **Phishing-resistant:** Domain'e bağlı credential, sahte siteye gönderilemez
- **Passwordless:** Kullanıcı şifre hatırlamak zorunda değil
- **Cross-device:** iCloud Keychain (Apple) ve Google Password Manager ile cihazlar arası senkronize
- **Biometric-backed:** Face ID, Touch ID, parmak izi ile doğrulama

## 47.3. Implementasyon Yolu

### Web

- WebAuthn API (navigator.credentials) ile browser-native passkey desteği
- Backend'de FIDO2 server library gereklidir (ör: SimpleWebAuthn)

### Mobile (React Native)

- `expo-passkeys` veya `react-native-passkeys` ile native passkey API'lerine erişim
- iOS: ASAuthorization framework, Android: Credential Manager API
- Expo managed workflow uyumluluğu doğrulanmalıdır

## 47.4. Geçiş Stratejisi

Passkeys implementasyonu aşağıdaki kademeli yaklaşımla yapılır:

1. **Phase 1 — Hybrid:** Mevcut password + biometric auth korunur; passkey opsiyonel olarak sunulur
2. **Phase 2 — Promoted:** Passkey tercih edilen yöntem olarak öne çıkarılır; password fallback korunur
3. **Phase 3 — Primary:** Passkey varsayılan auth yöntemi; password yalnızca recovery için

**Kural:** Phase 3'e geçiş ancak hedef kullanıcı tabanının %90+'ı passkey destekli cihaz kullandığında değerlendirilir.

## 47.5. Canonical Stack'e Dahil Edilme Koşulları

Passkeys'in canonical auth yöntemi olarak ADR-010'u güncellemesi için:

1. `expo-passkeys` veya eşdeğeri stable release olmalı
2. Backend FIDO2 server implementasyonu tamamlanmış olmalı
3. Cross-platform (iOS + Android + Web) passkey flow'u end-to-end test edilmiş olmalı
4. Migration stratejisi (mevcut password kullanıcıları) belgelenmiş olmalı
5. Recovery flow (kayıp cihaz, passkey senkronizasyon sorunu) tasarlanmış olmalı

Bu koşullar sağlandığında yeni bir ADR veya ADR-010 addendum'u açılır.
