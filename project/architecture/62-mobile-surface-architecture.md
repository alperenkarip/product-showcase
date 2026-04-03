---
id: MOBILE-SURFACE-ARCHITECTURE-001
title: Mobile Surface Architecture
doc_type: runtime_surface_architecture
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - SYSTEM-ARCHITECTURE-001
  - CREATOR-MOBILE-SCREEN-SPEC-001
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
blocks:
  - DEEP-LINKING-SHARE-ENTRY-MODEL
  - CACHE-REVALIDATION-STALENESS-RULES
  - AUTH-IDENTITY-SESSION-MODEL
---

# Mobile Surface Architecture

## 1. Bu belge nedir?

Bu belge, `apps/mobile` runtime'inin bu urunde hangi görevi üstlendiğini, hangi actor'lere hizmet verdiğini, navigation topolojisini, share intake ve deep link girişlerini, local draft persistence sınırlarını, offline davranışını ve neden mobile'ın public storefront container'i değil creator operasyon aracı olarak konumlandığını tanımlayan resmi mobile architecture belgesidir.

Bu belge su sorulara cevap verir:

- Mobile app neden viewer consumption değil creator utility surface'idir?
- Navigation aileleri nelerdir?
- Share/paste/deep-link girisleri hangi route'lara düşmelidir?
- Offline'da ne korunur, ne korunmaz?
- Mobile neden web'deki bulk edit ve yogun dashboard davranislarini taşımaz?

Bu belge, mobile surface'i "webin küçük hali" olmaktan çıkarır.

---

## 2. Bu belge neden kritiktir?

Creator tekrarli kullanim davranisinin buyuk kismi mobilde olur.  
Ama mobile'a fazla sorumluluk yüklemek de urunu bozar.

Yanlış mobil mimari su problemlere yol acar:

1. public consumption ve creator operation ayni app shell'de karisir
2. import akisi native/share girislerinde dağilir
3. offline draft ile gerçek import sonucu birbirine karisir
4. deep link'ler dashboard'a düşer, iş odagi kaybolur

Bu nedenle mobile surface'in rolü teknik seviyede netleştirilmelidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Mobile uygulama, `product-showcase` urununde creator owner/editor actor'lerinin hizli import, verification, target secimi ve hafif publishing ihtiyacini tasiyan bir creator utility runtime'idir; viewer-facing public storefront experience canonical olarak mobile web/public web'de kalir; mobile app public site kapsayicisi gibi davranmaz.

Bu karar su sonuclari dogurur:

1. App install zorunlu public consumption stratejisi olmayacak.
2. Navigation, import-first mental model etrafinda kurulacak.
3. Share intake first-class entrypoint sayılacak.
4. Offline state local draft ile sinirli kalacak; source truth worker/API tarafinda oluşacak.

---

## 4. Mobile runtime'in amaci

Mobile runtime su sorunlari cozer:

1. creator bir link gordugu anda hızlı import başlatabilir
2. verification'ı cepte tamamlayabilir
3. ürünü hızlıca library veya hedef context'e baglayabilir
4. hafif publish/success continuation alabilir

Mobile runtime'in cozmeye calismadigi alanlar:

1. public storefront consumption
2. yoğun bulk edit
3. derin ops/support paneli
4. kompleks settings/billing akışlarının tam kontrolü

---

## 5. Navigation topolojisi

Mobile navigation, actor'in en sık yaptığı işe göre tasarlanır.

### 5.1. Root aileler

Launch icin mantıksal root aileler:

- auth
- quick add / import
- library lightweight access
- pages lightweight access
- settings

### 5.2. Task flows

Task flow olarak tam-screen aileler:

- import processing
- verification
- target picker
- quick page create
- publish confirmation

### 5.3. Neden bu ayrım?

Import ve verification gibi akışlar tab içi mini modal gibi çözülürse state sahipliği bozulur.

---

## 6. Share intake mimarisi

### 6.1. Paste first

Uygulama acildiginda hızlı URL girisi ana yol olarak vardir.

### 6.2. Native share entry

Mobile OS share action ile gelen link:

- dashboard'a değil
- doğrudan quick import entry veya processing flow'una

düşmelidir.

### 6.3. Future extension compatibility

Native share extension sonraki karar olabilir.  
Ama extension yoksa clipboard/paste fallback zorunludur.

---

## 7. Deep link modeli

Mobile iki tur link alir:

### 7.1. Creator-action deep link

Ornek:

- import callback
- quick add intent
- push notification ile ilgili pending review

### 7.2. Public consumption deep link

Public URL uygulamaya açılabilir.  
Ama canonical experience web/public web olarak kalir.

Kural:

- public URL mobile app'e açıldığında bile creator utility shell'i ile karıştırılmaz

---

## 8. Local persistence sinirlari

Mobile'da local persistence vardir; ama sınırsız değildir.

### 8.1. Tutulabilecekler

- auth session restore bilgisi
- quick add draft
- verification sırasında creator'in geçici field düzeltmeleri
- recent target history

### 8.2. Tutulamayacaklar

- worker sonucunu taklit eden sahte import sonucu
- canonical source truth
- stale/fresh price kararı
- permission kararının offline üretimi

### 8.3. Kural

Offline state, API/worker source of truth'unu simüle etmez.

---

## 9. Offline ve reconnect davranisi

### 9.1. Offline before submit

Creator URL girebilir, draft oluşabilir.

### 9.2. Offline after submit

Job kabul edilip edilmediği server truth ile okunur.  
Belirsiz durumda "yeniden dene" veya "status kontrol et" sunulur; sessiz duplicate submit yapılmaz.

### 9.3. Offline during verification

Local field corrections korunabilir.  
Ama final apply server side permission ve persistence olmadan tamamlanmaz.

---

## 10. Session ve security yerleşimi

### 10.1. Session taşıma

Mobilde secure local storage tabanlı session restore kullanılır.

### 10.2. Owner-sensitive actions

Asagidaki aksiyonlarda ek re-auth veya biometric gate gerekebilir:

- publish final action
- account-sensitive settings
- deletion / ownership benzeri kritik alanlar

### 10.3. Secret sınırı

Import secret, provider secret veya worker-only credentials mobile'a inmez.

---

## 11. Data sync modeli

Mobile veri erişimi şu ilkeye göre kurulur:

1. hızlı optimistic UI mümkündür
2. source of truth API response'tur
3. import / refresh / permissions worker ve server tarafında finalize olur

### 11.1. Sync gereken aileler

- library listeleri
- recent imports
- page lightweight summaries
- settings summary

### 11.2. Sync gerekmeyen / ertelenebilenler

- yoğun analytics
- büyük historical diagnostics
- ops telemetry

---

## 12. Screen family -> runtime karşılıkları

### 12.1. Quick add

Hızlı network başlangıcı + minimal local validation

### 12.2. Processing

Job state polling / refresh mekanizması

### 12.3. Verification

Server-generated payload + local correction state

### 12.4. Target picker

Recent targets cache + server validated target list

### 12.5. Publish confirmation

Mutation result summary + next action suggestions

---

## 13. Mobile ve web sorumluluk ayrimi

### 13.1. Mobile'da kalacaklar

- quick import
- verification
- quick target attach
- lightweight page continuation

### 13.2. Web'e birakilacaklar

- bulk reorder
- table-dense library compare
- import diagnostics detail
- broad settings and billing management

### 13.3. Neden?

Bu ayrim UX tercihi degil; route, state ve information density uyumu icin teknik karardir.

---

## 14. Failure konsantrasyon alanlari

Mobile tarafinda en kritik riskler:

1. duplicate submit
2. stale local draft
3. ambiguous import sonucu
4. share entry'nin yanlış ekrana dusmesi
5. auth expiry sırasında belirsiz davranis

Bu alanlar mimari ve state tasarimi birlikte gerektirir.

---

## 15. Edge-case senaryolari

### 15.1. App share intent ile açıldı ama kullanıcı login değil

Beklenen davranis:

- auth akisi sonrası import flow context'i korunur
- dashboard'a düşürülmez

### 15.2. Verification sırasında app kapandı

Beklenen davranis:

- local correction taslağı geri yüklenebilir
- ama server payload expired ise yeniden review gerekir

### 15.3. Unsupported merchant mobile share'den geldi

Beklenen davranis:

- quick add akisi manual fallback veya net unsupported state'e gider
- generic failure ekranı çıkmaz

---

## 16. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Mobile app'i public storefront container'ı gibi tasarlamak
2. Dashboard'u varsayilan import entrypoint'i yapmak
3. Offline state'e source truth rolü vermek
4. Share intent'i genel home ekranına düşürmek
5. Web'e ait yoğun bilgi yüzeylerini mobile'a zorlamak

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `68-deep-linking-and-share-entry-model.md`, share ve deep-link routing'ini bu creator-only mobile kararina gore detaylandirmalidir.
2. `63-auth-identity-and-session-model.md`, mobile session restore ve re-auth mantigini bu runtime sinirlariyla uyumlu yazmalidir.
3. `53-creator-mobile-screen-spec.md`, screen family'lerini bu navigation ve local persistence modeline göre tasarlamalidir.

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- mobile creator utility surface'i olarak net konumlanıyorsa
- quick import ve verification akisi deep link/share ile tutarlı çalışıyorsa
- offline ve local state source truth'u taklit etmiyorsa
- mobile ve web surface ayrimi teknik olarak net kalıyorsa

Bu belge basarisiz sayilir, eger:

- mobile bir anda public storefront app'ine kayarsa
- share entry flow'u generic dashboard'a düşürülüyorsa
- local draft ile gerçek job state karışıyorsa
