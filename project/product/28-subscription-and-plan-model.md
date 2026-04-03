---
id: SUBSCRIPTION-PLAN-MODEL-001
title: Subscription and Plan Model
doc_type: monetization_boundary
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-SCOPE-NON-GOALS-001
  - SUCCESS-CRITERIA-LAUNCH-GATES-001
  - ASSUMPTION-LOG-001
blocks:
  - SUBSCRIPTION-BILLING-INTEGRATION-ARCHITECTURE
  - WEBHOOK-EVENT-CONSUMER-SPEC
  - PLATFORM-STORE-REVIEW-RISK-NOTES
---

# Subscription and Plan Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde monetization ve entitlement katmaninin hangi ilkelerle kurulacağını, plan farklarının nerede başlayıp nerede duracağını, trial davranışını, downgrade ve billing failure senaryolarını ve bilinçli olarak DIŞARIDA bırakılan monetization alanlarını tanımlayan resmi plan modeli belgesidir.

Bu belge su sorulara cevap verir:

- Plan modeli neden var?
- Hangi capability'ler plan farkıyla ayrışabilir?
- Hangi capability'ler asla kalite düşürme amacıyla kısılamaz?
- Trial nasıl davranır?
- Plan downgrade olursa public yüzey ne yapar?
- Billing failure durumunda ne olur?

---

## 2. Bu belge neden kritiktir?

Bu urunde monetization yanlış kurulduğunda iki uç risk vardır:

1. Çok gevşek model:

- import ve hosting maliyeti kontrolsüz büyür

2. Çok agresif model:

- temel ürün değeri kırpılır
- creator ürünün güven ve kalite hissini kaybeder

Bu belge bu iki uç arasında şu çizgiyi çizer:

> Plan modeli, urunun ekonomik sınırlarını korumalı; ama temel recommendation publishing kalitesini plan farkı bahanesiyle bozup creator'i düşük planlarda "kırık ürün"e mahkûm etmemelidir.

---

## 3. Ana karar

Bu belge için ana karar sudur:

> Subscription, urunun kendisi değil; urunun etrafındaki erişim ve kapasite katmanıdır. Plan farkları creator utility'yi açabilir veya genişletebilir; ama trust, import doğruluğu ve temel public kalite plan farkı bahanesiyle düşürülemez.

Bu karar su sonuclari doğurur:

1. Plan değeri utility üzerinden anlatılır
2. Kalitesiz storefront düşük planın kaderi olamaz
3. Trial ürünün gerçek değerini gösterecek kadar güçlü olmalıdır
4. Billing failure veya downgrade veri kaybı terörü yaratmamalıdır

---

## 4. Monetization felsefesi

### 4.1. Utility-first monetization

Creator planı şu değer etrafinda anlatılır:

- daha fazla publish kapasitesi
- daha fazla context page / shelf
- daha fazla branding kontrolü
- custom domain

Anlatılmaması gereken ana eksen:

- "daha çok gelir paneli"
- "daha çok satış zekası"

### 4.2. Quality floor ilkesi

Her creator en azından:

- güven veren public yüzey
- temel trust/disclosure görünürlüğü
- çalışır import deneyimi

almalıdır.

### 4.3. Cost-awareness ilkesi

Urun:

- scraping
- image processing
- hosting
- background refresh

maliyetleri taşıdığı için tamamen sınırsız ücretsiz varsayım üzerine kurulmaz.

---

## 5. İlk plan seti

### 5.1. Trial

Trial'in amacı:

- creator'in urunun gerçek değerini yaşayabilmesi
- ama maliyetin sınırsız açılmaması

Trial'da olması gerekenler:

- bir owner account
- belirli sayıda aktif shelf/content page
- import ve verification deneyimini gerçek hissettirecek entitlement
- public share edilebilir en az bir anlamlı surface

Trial'da olmaması gerekenler:

- ürünün kırpılmış, değerini göstermeyen demo hali

### 5.2. Creator Plan

Asıl ücretli ana plan.

Asgari olarak taşıyabilecek alanlar:

- daha yüksek page/shelf limitleri
- daha yüksek import hacmi
- custom domain
- daha fazla preset / customization alanı
- daha yüksek editor seat hakkı (ilerleyen aşamalarda)

### 5.3. Future expansion area

Sonraki fazlara bırakılan plan aileleri:

- team seats expansion
- agency / brand packages
- advanced reporting add-ons

Bu alanlar not edilir; ama launch çekirdeği sayılmaz.

---

## 6. Entitlement aileleri

Planlar şu capability aileleri üzerinden ayrışabilir:

### 6.1. Capacity entitlements

- aktif shelf sayısı
- aktif content page sayısı
- import hacmi
- library büyüklüğü

### 6.2. Branding / customization entitlements

- custom domain
- daha fazla template family
- daha fazla appearance flexibility

### 6.3. Team entitlements

- editor seat sayısı
- role sınırları

### 6.4. Future value entitlements

- export
- advanced analytics
- deeper reporting

Kural:

- trust, disclosure, temel public kalite ve import doğruluk guardrail'i entitlement ile kırpılmaz

---

## 7. Nelerin plan farkı OLMAMASI gerekir?

Bu belgeye göre şu alanlar planla "kırık ürün" seviyesine düşürülemez:

1. disclosure görünürlüğü
2. stale / missing price şeffaflığı
3. temel public kalite
4. import'in güvenli fallback mantığı
5. güvenlik / blocked-link davranışları

Bu alanları ücretli plan lehine kısmak kısa vadede gelir umudu yaratır; ama uzun vadede ürün güvenini bozar.

---

## 8. Trial davranışı

### 8.1. Trial neden gereklidir?

Bu ürünün değeri ekranla değil, davranışla anlaşılır:

- import
- verify
- reuse
- publish

Bu yüzden trial creator'e gerçek bir çalışma anı yaşatmak zorundadır.

### 8.2. Trial süresi

Bu belge tam sayı belirlemez; ama şu ilkeyi koyar:

- trial çok kısa olup creator'in ikinci publish anını görmeden bitmemelidir

### 8.3. Trial bitince ne olur?

Kural:

- aniden veri silinmez
- public surface bir grace policy ile yönetilir
- yeni import veya yeni publish kapasitesi sınırlanabilir

### 8.4. Trial'dan ücretliye geçiş copy'si

Anlatı:

- daha çok page
- daha fazla kapasite
- daha fazla kontrol

olmalıdır.

Anlatı olmaması gereken:

- "güvenli import için öde"
- "doğru disclosure için öde"

---

## 9. Downgrade davranışı

### 9.1. Downgrade neden hassastır?

Creator'in public sayfaları varsa ve downgrade ile limit asımı oluşursa:

- ürün bir anda kirık davranabilir
- public güven kaybı oluşabilir

### 9.2. Downgrade öncesi zorunlu görünürlük

Creator downgrade öncesi şunları görmelidir:

1. hangi entitlement'leri kaybedeceği
2. hangi page veya özelliklerin etkileneceği
3. ne kadar grace süresi olduğu

### 9.3. Limit aşımı durumunda davranış

Olası stratejiler:

- yeni içerik oluşturmayı durdurmak
- mevcut public içerikleri grace period boyunca korumak
- creator'e düzeltme / küçültme için zaman vermek

Kural:

- public linkleri aniden kırmak kabul edilmez

---

## 10. Billing failure davranışı

### 10.1. Billing failure neye dönüşmemelidir?

- anlık public takedown
- sessiz veri kaybı
- creator'i habersiz bırakan kısıtlama

### 10.2. Billing failure kademeleri

Asgari düşünülmesi gereken akış:

1. warning
2. grace period
3. capability freeze
4. sonrasında controlled downgrade behavior

### 10.3. Creator iletişimi

Creator:

- ne olduğunu
- ne zaman etkileneceğini
- neyi kaybedeceğini

açık biçimde bilmelidir.

---

## 11. Owner ve editor etkisi

### 11.1. Plan sahibi kimdir?

Plan sahibi owner'dır.

### 11.2. Editor ne yapamaz?

Editor:

- billing değişikliği
- plan değişikliği
- ödeme yöntemi yönetimi

yapamaz.

### 11.3. Editor ne görebilir?

Role modeline göre:

- plan state özeti
- bazı kullanım limitleri

görülebilir; ama kritik finansal kontrol owner'a aittir.

---

## 12. Plan modeli ile ürün kimliği arasındaki sınır

Plan modeli su alanlara kayamaz:

1. affiliate payout dashboard
2. commission settlement
3. B2B campaign billing
4. marketplace transaction fee engine

Bu alanlar ürünün recommendation publishing kimliğini bozar.

---

## 13. Non-goal monetization alanları

Bu belgeye göre plan modelinin parçası olmayan alanlar:

- affiliate revenue share dağıtımı
- merchant komisyon mutabakatı
- creator payout accounting
- retailer payout engine
- campaign ops billing

Bu alanlar bilinçli olarak kapsam dışıdır.

---

## 14. Plan modeliyle ilgili varsayımlar

Bu belge şu varsayımlara bağlıdır:

1. sade plan modeli ilk fazda yeterlidir
2. creator utility conversion için monetization jargonundan daha önemlidir
3. trust ve kaliteyi ücretli duvara koymadan da plan farkı yaratılabilir

Bu varsayımlar `Assumption Log` içinde izlenmelidir.

---

## 15. Başarı ölçütleri

Plan modeli başarılı sayılır, eğer:

1. creator utility ile plan değeri arasında net bağ kuruluyorsa
2. trial creator'e gerçek değer anı yaşatıyorsa
3. downgrade veri kaybı veya public güven krizi yaratmıyorsa
4. maliyet kontrolü yapılırken ürün kimliği bozulmuyorsa

---

## 16. Anti-pattern listesi

Bu belgeye göre su yaklasimlar yanlıştır:

1. trust/disclosure görünürlüğünü premium özelliğe çevirmek
2. trial'ı ürünün değerini göstermeyecek kadar zayıf kılmak
3. downgrade'de public linkleri aniden kırmak
4. plan anlatısını revenue dashboard üzerinden kurmak
5. import güvenliğini plan farkı bahanesiyle bozmak

---

## 17. Bu belge sonraki belgelere ne emreder?

1. `64-subscription-billing-integration-architecture.md` grace period, downgrade ve owner/editor ayrımını bu belgeyle hizalı kurmalıdır
2. `75-webhook-and-event-consumer-spec.md` billing event'lerini creator-facing state değişimlerine güvenli şekilde bağlamalıdır
3. `94-platform-and-store-review-risk-notes.md` trial/downgrade davranışlarının platform policy risklerini değerlendirmelidir

---

## 18. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- subscription ürünün merkezi olmadan ekonomik sınırları koruyorsa
- creator utility plan farklarının temel anlatısı oluyorsa
- düşük plan creator'i kalitesiz ya da güvenilmez yüzeylere mahkûm etmiyorsa
- trial ve downgrade davranışları kontrollü ve anlaşılır ise

Bu belge basarisiz sayilir, eger:

- monetization ürün kimliğinin önüne geçerse
- plan farkları trust ve kalite temellerini kırparsa
- downgrade ve billing failure kaotik public sonuçlar doğurursa

Bu nedenle bu belge, fiyatlandırma notu değil; monetization ile ürün kimliği arasındaki sınır sözleşmesidir.
