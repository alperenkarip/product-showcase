---
id: DISCLOSURE-AFFILIATE-LABELING-POLICY-001
title: Disclosure and Affiliate Labeling Policy
doc_type: compliance_policy
status: ratified
version: 2.0.0
owner: product-compliance
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
  - CONTENT-COPY-GUIDELINES-001
  - API-CONTRACTS-001
blocks:
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - RELEASE-READINESS-CHECKLIST
---

# Disclosure and Affiliate Labeling Policy

## 1. Bu belge nedir?

Bu belge, `product-showcase` icinde affiliate, sponsorlu, gifted, brand-provided ve benzeri iliski tiplerinin hangi seviyede nasil etiketlenecegini, product-level ile page-level disclosure farkini, creator default ve override davranisini, zorunlu gorunurluk kurallarini ve audit/uygulama cizgisini tanimlayan resmi disclosure politikasidir.

## 2. Ana karar

> Bu urunde disclosure opsiyonel stil ogesi degil, trust primitive'idir; iliski varsa product-level disclosure zorunludur, page veya storefront geneli aciklama bunu ikame etmez, creator bu sinyali gizleyemez veya belirsizlestiremez.

## 3. Disclosure seviyeleri

Bu projede disclosure uc seviyede dusunulur:

1. product-level relationship disclosure
2. page-level context disclosure
3. storefront-level genel trust/disclosure notu

Kural:

Product-level relationship varsa asil truth odur.  
Page/storefront disclosure yalniz baglam ekler.

## 4. Asgari disclosure enum'lari

Product-level primary relationship alanlari:

- `affiliate`
- `sponsored`
- `gifted`
- `brand_provided`
- `self_purchased`
- `unknown_relationship`

Ek not:

Affiliate link davranisi product-level relationship'ten ayri teknik flag olarak izlenebilir; ama public copy tarafinda gizlenmez.

## 5. Gorunurluk kurallari

1. Kart seviyesinde kisa disclosure badge veya row gorunur.
2. Detail veya content context alaninda daha acik copy bulunabilir.
3. Page-level genel not, product-level disclosure eksigini kapatmaz.
4. Disclosure dark pattern ile gizlenmez, fold icine saklanmaz, sadece tooltip'e hapsedilmez.

## 6. Creator default ve override modeli

1. Creator varsayilan disclosure profili tanimlayabilir.
2. Product bazinda override yapabilir.
3. Override audit event uretir.
4. Required disclosure alanini bos birakmak publish blocker olabilir.

## 7. Copy kurallari

1. Disclosure acik ve duz yazilir.
2. Belirsiz ifadeler kullanilmaz.
3. Locale bazli wording merkezi copy kurallariyla gelir.
4. Disclosure copy ticari iddiaya donusturulmez.

## 8. Yasak davranislar

1. disclosure bilgisini gizlemek
2. "ortaklik olabilir" gibi muğlak ifadeler kullanmak
3. page-level disclosure ile product-level iliskiyi gizledigini varsaymak
4. affiliate link var ama badge yok durumu yaratmak

## 9. Audit ve support notlari

1. Disclosure degisikligi audit event uretir.
2. Support tarafinda tarihce okunabilir.
3. Compliance incelemesi gereken durumlarda owner aksiyonu ile bag kurulur.

## 10. Senaryo bazli notlar

### 10.1. Senaryo: Bir content page'de farkli iliski tipleri var

Beklenen:

- her product kendi disclosure'ini tasir
- page-level genel not varsa ek baglam olur ama product truth'u gizlemez

### 10.2. Senaryo: Creator varsayilanini `affiliate` secmis ama bir urun `self_purchased`

Beklenen:

- product-level override uygulanir
- publicte dogru badge gorunur

### 10.3. Senaryo: Relationship bilgisi bilinmiyor

Beklenen:

- sistem bunu sessizce `self_purchased` sanmaz
- publish guard veya creator warning devreye girebilir

## 11. Bu belgenin basari kriteri nedir?

Viewer her urunde ticari iliskiyi acikca gorebiliyor, creator bu sinyali kazara veya isteyerek gizleyemiyor ve support/compliance gecmise donuk ne zaman hangi disclosure degistigini okuyabiliyorsa belge amacina ulasmistir.
