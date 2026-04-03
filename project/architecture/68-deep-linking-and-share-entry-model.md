---
id: DEEP-LINKING-SHARE-ENTRY-MODEL-001
title: Deep Linking and Share Entry Model
doc_type: linking_architecture
status: ratified
version: 2.1.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - ROUTE-SLUG-URL-MODEL-001
  - MOBILE-SURFACE-ARCHITECTURE-001
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE-001
blocks:
  - CROSS-PLATFORM-ACCEPTANCE-CHECKLIST
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-MOBILE-SCREEN-SPEC
---

# Deep Linking and Share Entry Model

## 1. Bu belge nedir?

Bu belge, canonical public link'lerin web ve mobile arasında nasıl davranacağını, creator-share/paste girişlerinin mobile import akışına nasıl bağlanacağını, short-link ve redirect modelini, preview/signed URL güvenlik sınırlarını ve handle/domain değişimi sonrası link sürekliliğinin nasıl korunacağını tanımlayan resmi linking architecture belgesidir.

Bu belge su sorulara cevap verir:

- Public canonical URL ile creator action deep link neden aynı davranışı taşımaz?
- App yüklüyse ve yüklü değilse deneyim nasıl ayrılır?
- Share intent neden generic dashboard'a değil quick import flow'una düşmelidir?
- Signed preview URL ile public share URL nasıl ayrıştırılır?
- Short-link analytics canonical davranışı nasıl bozmadan çalışır?

---

## 2. Bu belge neden kritiktir?

Link bu urunde sadece navigation aracı değildir.

Link:

- public recommendation consumption
- social sharing
- creator import girişi
- preview/review

rollerini taşır.

Bu roller karışırsa:

1. share intent yanlış ekrana düşer
2. preview link kamuya açık canonical gibi davranır
3. handle/domain değişiminde link sürekliliği bozulur
4. app-open deneyimi public canonical'ı kırar

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Canonical public URL her zaman web-first ve güvenilir paylaşım hedefidir; mobile app-open deneyimi bunun üstüne isteğe bağlı bir katmandır; creator-action girişleri ise ayrı intent ailesi olarak import-centric route'lara bağlanır; preview ve signed link'ler asla kalıcı public canonical link gibi davranmaz.

Bu karar su sonuclari dogurur:

1. Public canonical link bozulmaz.
2. Creator share entry doğrudan quick add/import akışına girer.
3. Preview/signed routes noindex ve limited-lifetime kalır.

---

## 4. Link aileleri

Sistemde dört ana link ailesi vardır:

1. canonical public links
2. creator-action deep links
3. short redirects
4. preview/signed links

### 4.1. Canonical public links

Storefront, shelf, content page ve varsa light detail sayfalarının kalıcı URL'leridir.

### 4.2. Creator-action deep links

Import, pending review veya creator task'lerini app içinde açan intent'lerdir.

### 4.3. Short redirects

Analytics veya kampanya paylaşımı için daha kısa entrypoint'tir.

### 4.4. Preview/signed links

Draft/preview veya sınırlı erişim akışları için zaman/policy kısıtlı linklerdir.

---

## 5. Canonical public link ilkeleri

### 5.1. Tek kaynak

Canonical public link:

- indexlenebilir yüzeydir
- share metadata'nın gerçek taşıyıcısıdır

### 5.2. App-open optionality

Mobil uygulama yüklüyse:

- relevant surface app'te açılabilir

Ama:

- web canonical fallback her zaman kalır

### 5.3. Kural

Public link app yüklü diye creator workspace'e yönlenmez.

---

## 6. Creator share entry modeli

### 6.1. Intent

Creator dışarıda gördüğü merchant/product linkini sisteme içeri almak ister.

### 6.2. Beklenen rota

Share/paste girişleri:

- quick add
- processing
- verification

zincirine bağlanır.

### 6.3. Neden dashboard değil?

Cunku intent "uygulamayı aç" değil, "bu linki içeri al"dır.

---

## 7. Auth ile deep-link ilişkisi

### 7.1. Creator-action link auth gerektiriyorsa

Beklenen davranis:

- auth akışı tamamlanır
- intent context korunur
- doğru flow'a geri dönülür

### 7.2. Public link auth gerektirmez

Public canonical link anonim tüketim için güvenilir kalır.

### 7.3. Kural

Auth gerektiren creator intent'ler login sonrası dashboard'a dump edilmez.

---

## 8. Short-link mimarisi

### 8.1. Amaç

- daha kısa paylaşım URL'si
- analytics ve campaign tracking

### 8.2. Davranış

Short link:

- canonical hedefe çözülür
- aynı içeriğe yönlenir
- canonical'ı bozmaz

### 8.3. Kural

Short link ayrı içerik yüzeyi değildir.  
Kısaltılmış yönlendirme girişidir.

---

## 9. Preview ve signed link modeli

### 9.1. Preview links

Draft veya unpublished content'i sınırlı paylaşmak için kullanılabilir.

### 9.2. Signed links

Zaman veya kimlik kısıtlı erişim için kullanılır.

### 9.3. Kural

Preview/signed link:

- noindex
- non-canonical
- expire olabilir

### 9.4. Expiry davranışı

Link süresi dolduğunda:

- generic 404 değil
- explicit expired preview state üretilir

---

## 10. Handle/domain değişimi ve continuity

### 10.1. Handle değişimi

Eski public URL:

- kontrollü redirect
- canonical update

alır.

### 10.2. Custom domain değişimi

Canonical host değişebilir.  
Redirect ve metadata zinciri birlikte güncellenir.

### 10.3. App link map güncellemesi

Deep-link resolver eski handle/domain eşlemelerini anlayacak kadar dayanıklı olmalıdır.

---

## 11. Cross-platform continuity

### 11.1. Web -> app

Public link app'te açılırsa:

- mümkünse aynı logical surface
- değilse güvenilir web fallback

### 11.2. App -> web

Creator app içinden publice bakmak istediğinde canonical web target kullanılabilir.

### 11.3. Share -> auth -> import flow

Bu zincirde intent kaybı kabul edilmez.

---

## 12. Edge-case senaryolari

### 12.1. App yüklü değil

Beklenen davranis:

- canonical web experience açılır

### 12.2. Share intent login istiyor

Beklenen davranis:

- auth sonrası quick import flow restore edilir

### 12.3. Expired preview link

Beklenen davranis:

- public canonical'a düşmez
- expired preview state gösterir

### 12.4. Handle değişti ama eski link cache'te

Beklenen davranis:

- redirect/canonical zinciri ile çözülür

---

## 13. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. share intent'i generic home/dashboard'a düşürmek
2. preview link'i public canonical share link gibi kullanmak
3. short redirect ile canonical'i farklı içeriklere götürmek
4. auth sonrası creator intent'i kaybetmek
5. app-open davranışıyla web canonical'ı kırmak

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `53-creator-mobile-screen-spec.md`, share/paste girişini bu intent modeline göre tasarlamalıdır.
2. `67-seo-og-and-share-preview-architecture.md`, canonical public links ile preview links ayrımını bu modelle uyumlu tutmalıdır.
3. `84-cross-platform-acceptance-checklist.md`, app-installed/app-not-installed ve auth-required share-entry senaryolarını bu belgeye göre test etmelidir.

---

## 15. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- public canonical links her durumda güvenilir kalıyorsa
- creator share girişleri doğru import akışına düşüyorsa
- preview/signed link'ler public share semantiğiyle karışmıyorsa
- handle/domain değişimi sonrası link sürekliliği kırılmıyorsa

Bu belge basarisiz sayilir, eger:

- share intent'ler yanlış yüzeylere düşüyorsa
- preview link'ler yanlışlıkla kamuya açık canonical gibi davranıyorsa
- app-open ve canonical mantığı birbirini bozuyorsa

