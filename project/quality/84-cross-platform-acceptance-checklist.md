---
id: CROSS-PLATFORM-ACCEPTANCE-CHECKLIST-001
title: Cross-Platform Acceptance Checklist
doc_type: acceptance_checklist
status: ratified
version: 2.0.0
owner: product-design-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - CREATOR-MOBILE-SCREEN-SPEC-001
  - CREATOR-WEB-SCREEN-SPEC-001
  - PUBLIC-WEB-SCREEN-SPEC-001
  - TEST-STRATEGY-PROJECT-LAYER-001
blocks:
  - RELEASE-READINESS-CHECKLIST
  - ACCESSIBILITY-PROJECT-CHECKLIST
---

# Cross-Platform Acceptance Checklist

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun public web, creator web ve creator mobile yuzeylerinde semantic parity ve kabul kriterlerini tanimlayan resmi cross-platform acceptance checklist belgesidir.

Bu belge su sorulara cevap verir:

- Web ve mobile ayni urun truth'unu tutarli gosteriyor mu?
- Public mobile web ile desktop web ayni trust semantigini koruyor mu?
- iOS ve Android creator uygulamalarinda import ve verification akisi ayni urunsel sonucu veriyor mu?
- Platform farkliligi nerede kabul edilir, nerede edilmez?

---

## 2. Ana karar

> Bu projede parity pixel-perfect aynilik degil, semantic consistency demektir; platform ergonomisi farkli olabilir ama actor capability, state semantigi, trust/disclosure davranisi ve public truth platformlar arasinda celismemelidir.

---

## 3. Genel parity kurallari

1. Ayni product'in selected source ve trust state'i tum yuzeylerde ayni anlamda gorunur.
2. Archived, unpublished, blocked veya expired state'ler bir platformda gizlenip digerinde farkli isimle sunulmaz.
3. Owner-only capability'ler hicbir platformda editor'a acilmaz.
4. Public route ve canonical truth mobil web ile desktop web'de ayni kalir.

---

## 4. Public web acceptance

### 4.1. Mobil web

- storefront, shelf ve content page ilk viewport'ta anlamli hiyerarsiyle okunur
- stale/disclosure row yatay kaymadan gorunur
- CTA metni kesilmez veya trust bilgisini ezecek sekilde sikismaz

### 4.2. Desktop web

- ayri kolon/genislik kullanilsa bile same disclosure ve trust semantigi korunur
- hero / context / placement sira mantigi bozulmaz

### 4.3. Ortak public maddeler

- canonical ve metadata dogru
- share preview dogru yuzeye gider
- hidden-by-policy ve unavailable ayrimi tutarlidir

---

## 5. Creator mobile acceptance

### 5.1. Entry points

- paste entry calisir
- OS share sheet entry dogru hedefe iner
- derin linkten gelen context kaybolmaz

### 5.2. Verification akisi

- review-required state net gorunur
- manual correction alanlari kullanilabilir
- apply sonucu ve sonraki hedef secimi belirsiz kalmaz

### 5.3. Offline / interruption

- gecici kopusta kullanici cikissiz kalmaz
- local taslak authoritative truth gibi davranmaz

---

## 6. Creator web acceptance

### 6.1. Library ve page building

- bulk listeler okunur
- reorder tutarli calisir
- selected source degisikligi hemen dogru state'e yansir

### 6.2. Import history

- mobile ile ayni job state isimleri gorulur
- retry/cancel eligibility tutarlidir

### 6.3. Settings ve billing

- owner/editor ayrimi acik
- web checkout veya billing portal owner-only kalir

---

## 7. iOS ve Android parity

1. Share-entry davranisi iki platformda da ayni import intent mantigini korur.
2. Session restore ve sign-out semantigi tutarlidir.
3. Verification ekraninda ayni warning/review copy'si ve state ayrimi bulunur.
4. Platform-native farklar semantic truth'u bozmaz.

---

## 8. Deep link ve routing acceptance

1. Public link her cihazda dogru public surface'e gider.
2. Creator-deep-link auth gerektiriyorsa login sonrasi dogru hedefe duser.
3. Archived veya removed page her yuzeyde ayni semantik fallback'i verir.

---

## 9. Media ve trust acceptance

1. Primary image platforma gore farkli secilmez.
2. Stale price warning mobilde gizlenip desktop'ta gorunur hale gelmez.
3. Disclosure copy truncation nedeniyle anlam kaybetmez.

---

## 10. Release blocker maddeleri

Asagidaki bulgular cross-platform blocker sayilir:

1. Web ve mobile selected source farkli gosteriyor
2. Owner-only aksiyon mobile veya web'de editor'a aciliyor
3. Public mobile stale/disclosure row'u gizliyor
4. Deep link yanlis hedefe dusuyor
5. Archived/unpublished semantigi platformlar arasinda celisiyor

---

## 11. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip, "platformlar farkli ama urun semantigi ayni mi?" sorusunu bu checklist ile cevaplaya biliyor olmali ve release adaylari bu maddeler uzerinden denetlenebilmelidir.
