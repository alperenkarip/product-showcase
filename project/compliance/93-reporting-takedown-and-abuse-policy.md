---
id: REPORTING-TAKEDOWN-ABUSE-POLICY-001
title: Reporting, Takedown and Abuse Policy
doc_type: enforcement_policy
status: ratified
version: 2.0.0
owner: support-compliance-ops
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - EXTERNAL-LINK-MERCHANT-CONTENT-POLICY-001
  - SECURITY-AND-ABUSE-CHECKLIST-001
  - PRIVACY-DATA-MAP-001
blocks:
  - INCIDENT-RESPONSE-PROJECT-LAYER
  - RUNBOOKS
---

# Reporting, Takedown and Abuse Policy

## 1. Bu belge nedir?

Bu belge, `product-showcase` icinde yanlis urun, zararli link, sahte veya suistimale acik icerik, trademark/brand sikayeti ve kaldirma taleplerinin nasil alinacagini, hangi SLA ve triage siniflariyla ele alinacagini, gecici ve kalici aksiyonlarin nasil uygulanacagini tanimlayan resmi reporting ve takedown politikasidir.

## 2. Ana karar

> Safety ve uyum riski tasiyan raporlarda once gecici koruma uygulanir, sonra dogrulama yapilir; audit izi korunur, owner bilgilendirilir ve support/ops/compliance ayni olay siniflarini kullanir.

## 3. Rapor kategorileri

1. wrong product / wrong merchant
2. unsafe link
3. trademark / brand complaint
4. takedown request
5. abusive storefront veya spam pattern

## 4. Triage state'leri

- `received`
- `under_review`
- `temporary_restriction_applied`
- `resolved`
- `rejected`

## 5. Gecici aksiyonlar

1. public link cikisini durdurmak
2. ilgili surface'i unpublish etmek veya gizlemek
3. creator'a duzeltme warning'i gostermek
4. ops/support escalasyonu

Kural:

Gecici aksiyon audit izsiz uygulanmaz.

## 6. Kalici aksiyonlar

1. source veya page kaldirma
2. domain block
3. storefront kisitlamasi
4. raporun reddi ve closure notu

## 7. SLA oncelikleri

1. unsafe link / zararlı icerik: en yuksek oncelik
2. trademark/takedown: compliance owner review ile hizli inceleme
3. wrong product / stale veri: support + product triage

## 8. Owner iletisim ilkeleri

1. Gecici kisit uygulandiysa owner bilgilendirilir.
2. Kalici karar veya ek belge talebi varsa owner'a acik neden sunulur.
3. Support diyaloğu audit notuyla bagli kalir.

## 9. Kanit koruma ilkesi

1. Rapor alininca ilgili audit ve operational kanit korunur.
2. Hassas veya unsafe ham veri gereksiz yere kopyalanmaz.
3. Support kolayligi bahanesiyle privacy cizgisi asılmaz.

## 10. Senaryo bazli notlar

### 10.1. Senaryo: Unsafe merchant link raporu

Beklenen:

- hizli gecici blok
- owner bilgilendirmesi
- support/ops triage

### 10.2. Senaryo: Wrong product report

Beklenen:

- source/import kalite incelemesi
- gerekiyorsa page veya placement duzeltmesi

### 10.3. Senaryo: Trademark complaint

Beklenen:

- compliance owner review
- risk sinifi bunu gerektiriyorsa gecici kisit hizla uygulanir

## 11. Bu belgenin basari kriteri nedir?

Raporlar gelince ekip neyi ne kadar hizla kisitlayacagini, ne zaman owner bilgilendirecegini ve hangi kalici kararlari hangi audit iziyle alacagini tartismasiz biliyorsa belge amacina ulasmistir.
