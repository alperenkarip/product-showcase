---
id: PRODUCT-ANALYTICS-EVENT-TAXONOMY-001
title: Product Analytics Event Taxonomy
doc_type: analytics_spec
status: ratified
version: 1.0.0
owner: product-analytics
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - OBSERVABILITY-INTERNAL-EVENT-MODEL-001
  - PRIVACY-DATA-MAP-001
  - VIEWER-EXPERIENCE-SPEC-001
  - CREATOR-WORKFLOWS-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
blocks:
  - MVP-EXECUTION-TICKET-PACK-001
---

# Product Analytics Event Taxonomy

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde hangi davranis sinyallerinin product analytics olarak toplanacagini, event isimlerinin nasil standardize edilecegini, hangi property'lerin zorunlu oldugunu ve hangi hassas verilerin analitige asla gitmeyecegini tanimlayan resmi analytics taxonomy belgesidir.

Bu belge su sorulari kapatir:

- hangi event urun utility'sini olcer?
- analytics ile audit/observability farki nedir?
- public viewer, creator ve ops yuzeyleri icin hangi event aileleri vardir?
- ham creator note, imported HTML veya merchant URL'i analitige gider mi?

---

## 2. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` yalniz urun utility, import quality ve creator operating loop'unu anlamaya yarayan minimum product analytics event'lerini toplayacak; heavy audience analytics, davranissal izleme veya ham creator icerigi toplamayacak; analytics dispatch her zaman consent ve privacy guard ile calisacak; audit ve observability event'leri bu taxonomy yerine gecmeyecektir.

Bu karar su sonuclari dogurur:

1. raw text note ve imported artefact payload analitige gitmez
2. `screen_view` coplugu yerine capability-merkezli event ailesi kullanilir
3. internal health metric'ler Sentry/log/event pipeline'da kalir, product analytics ile karismaz

---

## 3. Event tasarim ilkeleri

1. event ismi dot notation kullanir
2. fiil ve sonuc acik olur
3. ayni davranis web ve mobile'da ayni isimle anilir
4. payload key'leri camelCase olur
5. ham hassas veri event payload'ina konmaz

Ornek iyi isimler:

1. `public.storefront.viewed`
2. `creator.import.started`
3. `creator.import.review_submitted`
4. `creator.page.publish_completed`

Kotu isimler:

1. `screen_open`
2. `misc_event`
3. `button_click`

---

## 4. Ortak event alanlari

Her analytics event'inde asgari su alanlar bulunur:

1. `eventVersion`
2. `timestamp`
3. `appSurface`
4. `platform`
5. `appVersion`
6. `buildChannel`
7. `workspaceId` veya `null`
8. `userId` veya `anonymousId`

Durumsal ortak alanlar:

1. `storefrontId`
2. `pageId`
3. `shelfId`
4. `productId`
5. `placementId`
6. `importJobId`
7. `merchantKey`
8. `routeFamily`
9. `resultStatus`

---

## 5. Asla toplanmayacak alanlar

Asagidaki veri siniflari product analytics'e gitmez:

1. creator note ham metni
2. imported page HTML'i
3. full outbound URL
4. email, phone, postal address
5. raw payment artefact'i
6. operator note metni
7. support ticket serbest yazi alani

Kural:

- gerekiyorsa code, bucket veya boolean ozet kullanilir

---

## 6. Consent ve dispatch modeli

## 6.1. Product analytics consent'e baglidir

`analytics_opt_in = true` olmadan product analytics event'i cikmaz.

## 6.2. Essential telemetry ayri siniftir

Crash, security, billing drift veya abuse signal'lari product analytics degildir; consent kapali olsa da kendi policy'leriyle tasinabilir.

## 6.3. Buffered replay yasagi

Consent kapaliyken toplanmamis event sonradan replay edilmez.

---

## 7. Public event ailesi

Public tarafin amaci vanity trafik degil, utility sinyalidir.

### 7.1. Core event'ler

1. `public.storefront.viewed`
2. `public.page.viewed`
3. `public.product_card.expanded`
4. `public.outbound_link.clicked`
5. `public.disclosure_help.opened`
6. `public.price_state.viewed`

### 7.2. Zorunlu alanlar

1. `storefrontId` veya `pageId`
2. `routeFamily`
3. `productId` varsa
4. `merchantKey` varsa
5. `disclosureState` varsa

### 7.3. Bilincli olarak toplanmayanlar

1. heatmap benzeri agresif scroll tracking
2. mouse movement kaydi
3. viewer profile enrichment

---

## 8. Creator import event ailesi

Bu urunun kalbi burada atar.

### 8.1. Event'ler

1. `creator.import.started`
2. `creator.import.fetch_completed`
3. `creator.import.review_opened`
4. `creator.import.review_submitted`
5. `creator.import.correction_applied`
6. `creator.import.failed`

### 8.2. Zorunlu alanlar

1. `importJobId`
2. `merchantKey`
3. `tier`
4. `resultStatus`
5. `triggerSource`

### 8.3. Toplanmayacaklar

1. imported HTML body
2. full image candidate listesi
3. raw parser stack trace

---

## 9. Creator library, page ve publish event ailesi

### 9.1. Event'ler

1. `creator.product.selected_source_changed`
2. `creator.page.created`
3. `creator.page.publish_started`
4. `creator.page.publish_completed`
5. `creator.page.publish_blocked`
6. `creator.placement.removed`

### 9.2. Zorunlu alanlar

1. `pageId`
2. `routeFamily`
3. `placementCount` gerekiyorsa
4. `blockingReasonCode` varsa

Kural:

- publish blocked event'i error degil, urunsel friction sinyali olarak kaydolur

---

## 10. Billing ve account utility event ailesi

Bu ailede ama heavy monetization analytics'e kayilmaz.

### 10.1. Event'ler

1. `creator.billing.checkout_started`
2. `creator.billing.checkout_returned`
3. `creator.billing.portal_opened`
4. `creator.billing.entitlement_screen_viewed`
5. `creator.account.membership_invite_sent`

### 10.2. Toplanmayacaklar

1. tam fiyat/kart artefact'i
2. provider raw payload'i
3. personally identifiable billing detail

---

## 11. Supportability odakli product event'ler

Product analytics ile internal observability karismadan su urunsel sinyaller toplanabilir:

1. `creator.import.help_opened`
2. `creator.publish.issue_help_opened`
3. `creator.account.security_notice_viewed`

Kural:

- support panel action'lari product analytics degil, audit veya ops event olabilir

---

## 12. Vendor adapter modeli

Analytics event dispatch zinciri:

1. screen/component -> event builder
2. event builder -> registry validation
3. consent gate
4. adapter dispatch

Kural:

- screen dosyasi vendor SDK import etmez
- adapter degisse event ismi ve payload authority'si degismez

---

## 13. Dashboard ve KPI cizgisi

Bu taxonomy'nin odaklandigi minimum KPI aileleri:

1. import start -> review submit donusum orani
2. correction-required job oranlari
3. page publish completion orani
4. public outbound click utility'si
5. billing checkout start -> entitlement ready oranlari

Yasak KPI dili:

1. shadow viewer profiling
2. creator revenue surveillance
3. manipulative retention segmentleri

---

## 14. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. raw text'i analytics payload'ina yazmak
2. audit event'i product analytics gibi saymak
3. her buton tiklamasini event yapmak
4. consent yokken event biriktirmek
5. screen kodunda dogrudan vendor SDK kullanmak

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `118-mvp-execution-ticket-pack.md`, `packages/analytics` bootstrap task'larini bu event ailelerine gore acmalidir.
2. `69-observability-and-internal-event-model.md`, internal telemetry ile product analytics ayrimini korumalidir.
3. `90-privacy-data-map.md`, analytics payload siniflarini bu belge ile uyumlu denetlemelidir.

---

## 16. Basari kriteri

Bu belge basarili sayilir, eger:

1. urun utility'sini anlamak icin yeterli sinyal toplanirken gizlilik ihlali olmuyorsa
2. web ve mobile ayni event dilini kullaniyorsa
3. vendor degisse bile event semantigi korunuyorsa
4. ekip analytics ile audit/observability farkini karistirmiyorsa

