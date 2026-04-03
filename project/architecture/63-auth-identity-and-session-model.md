---
id: AUTH-IDENTITY-SESSION-MODEL-001
title: Auth, Identity and Session Model
doc_type: security_auth_spec
status: ratified
version: 2.0.0
owner: security-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
  - ROUTE-SLUG-URL-MODEL-001
  - SYSTEM-ARCHITECTURE-001
blocks:
  - API-CONTRACTS
  - WEBHOOK-EVENT-CONSUMER-SPEC
  - PRIVACY-DATA-MAP
  - SUBSCRIPTION-BILLING-INTEGRATION-ARCHITECTURE
---

# Auth, Identity and Session Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde teknik auth kimligi, urunsel creator kimligi, public handle/storefront kimligi, web ve mobile session taşıma mekanizmaları, owner/editor yetki çözümü, session invalidation, re-auth ve account recovery gibi alanlari tanimlayan resmi auth ve session architecture belgesidir.

Bu belge su sorulara cevap verir:

- `User`, `Creator Profile`, `Storefront` ve `Handle` neden ayni kavram degildir?
- Web ve mobile neden ayni auth omurgasini ama ayni session taşıma mekanizmasını kullanmaz?
- Owner/editor role çözümü ne zaman devreye girer?
- Session expiry, revoke, logout ve recovery nasil çalışır?
- Custom domain ve authenticated route'lar cookie davranisi acisindan nasil ayrilir?

Bu belge, auth'i yalnız login ekranı karari olmaktan cikarir.

---

## 2. Bu belge neden kritiktir?

Bu urunde auth zayıf olursa sadece account güvenliği değil, su alanlar da bozulur:

- ownership
- publish yetkisi
- billing hakları
- account deletion
- support recovery
- editor access revocation

Ustelik urun hem web hem mobile taşıdığı icin canonical identity ile transport mekanizmasi ayrimini net kurmak zorunludur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Web ve mobile ayni canonical auth/identity omurgasini kullanir; ama web, HttpOnly secure cookie tabanli server-managed session ile; mobile ise secure local storage ile restore edilen app session modeliyle çalışır; authorization karari her zaman authentication + principal resolution + ownership/resource scope + action sensitivity zinciri uzerinden verilir.

Bu karar su sonuclari dogurur:

1. Web'de localStorage token auth modeli yoktur.
2. Mobile secure storage kullanir; AsyncStorage benzeri açık storage auth source olmaz.
3. UI gizleme, permission karari yerine geçmez.
4. Owner/editor farki session katmaninda degil, principal resolution ve authorization katmaninda çözümlenir.

---

## 4. Identity katmanlari

### 4.1. Technical auth identity: `User`

Teknik kimlik ve canonical account id.

Gorevi:

- authentication
- session ilişkilendirme
- provider bağlama

### 4.2. Product identity: `Creator Profile`

Urunsel kimlik katmani.

Gorevi:

- display name
- avatar
- bio / positioning

### 4.3. Public identity: `Handle + Storefront`

Viewer'in gördüğü public kimlik katmani.

Gorevi:

- route identity
- public brand/address

### 4.4. Ownership identity

Belirli storefront/account primitive'i uzerinde nihai yetkiyi tasiyan katmandir.

Kural:

- auth kimligi ile ownership ayni sey sayilmaz

---

## 5. Principal çözümleme modeli

Authentication "kim?" sorusuna cevap verir.  
Authorization icin ayrıca "hangi baglamda?" sorusu gerekir.

### 5.1. Principal turleri

- anonymous viewer
- signed-in owner
- signed-in editor
- support
- ops/admin
- system worker

### 5.2. Workspace/storefront scope

Signed-in user birden fazla bağlama sahip olabilir.  
Bu nedenle route veya mutation aninda aktif scope çözülür.

### 5.3. Kural

Session var diye otomatik owner sayilmaz.  
Role ve resource scope ayrıca çözülür.

---

## 6. Web session modeli

### 6.1. Taşıma mekanizması

Web session:

- server-managed
- HttpOnly
- Secure cookie

ile taşınır.

### 6.2. Neden?

1. XSS riskini azaltmak
2. browser'ın doğal auth modeline uymak
3. creator ve ops route'larinda güvenli gate sağlamak

### 6.3. Cookie ilkeleri

Kurallar:

1. `HttpOnly`
2. `Secure`
3. uygun `SameSite`
4. auth host ve custom public domain karışmayacak

### 6.4. Yasak

- access token'ı `localStorage` / `sessionStorage` içine koymak

---

## 7. Mobile session modeli

### 7.1. Taşıma mekanizması

Mobile session:

- secure local persistence
- restore on launch
- server revalidation

üzerinden çalışır.

### 7.2. Neden?

Mobile tarayıcı cookie modelinin kopyası degildir.  
Native runtime için secure local store gerekir.

### 7.3. Kurallar

1. Session secret secure storage'da tutulur.
2. App açılışında restore yapılır.
3. Expired/revoked session durumunda temiz logout gerekir.

---

## 8. Login stratejisi

Bu belge exact provider listesi belirlemek zorunda degildir.  
Ama auth stratejisi için şu ilkeyi koyar:

- düşük sürtünmeli sign-in
- web + mobile uyumu
- session ve recovery açısından yönetilebilir provider seti

### 8.1. Kural

Provider sayısı auth complexity'si ugruna kontrolsüz açılmaz.

### 8.2. Account linking

Birden fazla provider tek canonical `User` altında birleşebilir.  
Ama merge/recovery kuralları açıkça kontrol edilmeden sessiz birleştirme yapılmaz.

---

## 9. Session yaşam döngüsü

Session lifecycle asgari şu adımları içerir:

1. sign-in
2. session create
3. client persistence
4. active use
5. refresh/revalidate
6. revoke / sign-out / expiry
7. local cleanup

### 9.1. Kural

Client logout, server invalidate olmadan tam logout sayılmaz.

### 9.2. Session restore

Web:

- cookie varlığı ile

Mobile:

- secure store restore + server revalidation ile

çalışır.

---

## 10. Authorization karar zinciri

Auth katmani authorization ile birlikte düşünülmelidir.

Karar zinciri:

1. authentication
2. principal resolution
3. role membership
4. resource ownership
5. action sensitivity
6. state constraint

### 10.1. Ornek

User signed-in olabilir.  
Ama:

- ilgili storefront owner değilse billing'e giremez
- editor ise publish yapamaz
- support ise normal creator mutation yapamaz

---

## 11. Re-auth ve high-sensitivity işlemler

Asagidaki işlemler mevcut session'a ek güven istemelidir:

- ownership transfer
- account deletion
- billing-critical değişiklikler
- custom domain unlink gibi yüksek etkili alanlar

### 11.1. Neden?

Bu işlemler session hijack veya stale device riskinde daha yikicidir.

---

## 12. Session invalidation kurallari

### 12.1. Editor access revoke

Editor erişimi kaldırıldığında:

- yeni write'lar aninda reddedilir
- aktif session'lar makul sürede invalid edilir

### 12.2. Passwordless/provider unlink benzeri kritik auth değişikliği

Kritik account security değişimlerinde mevcut oturumlar yeniden doğrulanabilir.

### 12.3. Account suspension

Suspended account:

- creator mutations yapamaz
- public route davranışı policy'ye göre ayrıca ele alınır

---

## 13. Account recovery

### 13.1. Normal recovery

- provider veya e-posta akışıyla controlled recovery

### 13.2. Ownership-sensitive recovery

Owner access kaybında:

- support tek başına ownership transfer yapamaz
- kimlik doğrulama ve auditli prosedur gerekir

### 13.3. Kural

Recovery, gizli "support owner oldu" mekanizmasına dönüşmez.

---

## 14. Custom domain ve auth host ayrimi

Public custom domain ile authenticated creator routes karistirilmamalidir.

### 14.1. Public custom domain

- storefront ve public page surfaces

### 14.2. Authenticated host

- creator workspace
- ops/admin routes

### 14.3. Neden?

Cookie scope, CSRF ve canonical davranisi korumak icin.

---

## 15. Webhook ve external event ilişkisi

Auth-related dış olaylar:

- provider unlink
- account email verification
- session revoke

gibi alanlarda webhook/event consumer ile senkronize olabilir.

### Kural

External auth event'leri idempotent ve auditli işlenir.

---

## 16. Privacy ve minimization notlari

Auth sistemi:

- gereksiz profile çoğaltması yapmaz
- session metadata'sını support için yeterli ama aşırı olmayacak düzeyde tutar
- device/session listesinde gereksiz PII zenginleştirme yapmaz

---

## 17. Edge-case senaryolari

### 17.1. Signed-in creator public route'ta

Beklenen davranis:

- public experience auth workspace'e donmez

### 17.2. Mobile restore oldu ama role değişmiş

Beklenen davranis:

- next API call'da current role/scope okunur
- stale local assumption yetki vermez

### 17.3. Editor publish etmeye çalışıyor

Beklenen davranis:

- auth başarılı olabilir
- authorization reddi ayrı ve net olur

### 17.4. Owner recovery sürecinde eski session'lar açık

Beklenen davranis:

- gerektiğinde revoke-all-sessions uygulanır

---

## 18. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Web'de token'ı client storage'a koymak
2. Session var diye role/ownership kontrolünü atlamak
3. Custom public domain altında creator auth workspace taşımak
4. Support recovery akışını gizli ownership transfer aracına dönüştürmek
5. Mobile local state'i yetki source-of-truth saymak

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `70-api-contracts.md`, her write endpoint'te authentication + scope + ownership + action sensitivity kontrolünü taşımak zorundadır.
2. `75-webhook-and-event-consumer-spec.md`, auth/billing/domain event'lerini bu session ve audit modeliyle uyumlu işlemelidir.
3. `90-privacy-data-map.md`, session ve auth metadata retention'ını bu belgeyle uyumlu haritalamalıdır.
4. `64-subscription-billing-integration-architecture.md`, owner-only billing erişimini bu role modeline göre kurmalıdır.

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- web ve mobile ortak identity ama farklı session taşıma modeliyle güvenli çalışıyorsa
- owner/editor farkı teknik olarak enforce ediliyorsa
- custom domain ve authenticated host davranışı karışmıyorsa
- recovery ve revoke akışları auditli ve kontrollu kalıyorsa

Bu belge basarisiz sayilir, eger:

- session modeli platform farkını gizleyip kırık güvenlik üretirse
- auth ile ownership/authorization kararı birbirine karışırsa
- support veya stale local state fiilen owner gibi davranabiliyorsa

