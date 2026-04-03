---
id: PLATFORM-STORE-REVIEW-RISK-NOTES-001
title: Platform and Store Review Risk Notes
doc_type: distribution_risk_note
status: ratified
version: 2.0.0
owner: product-mobile-compliance
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - CREATOR-MOBILE-SCREEN-SPEC-001
  - SUBSCRIPTION-PLAN-MODEL-001
  - EXTERNAL-LINK-MERCHANT-CONTENT-POLICY-001
blocks:
  - RELEASE-READINESS-CHECKLIST
  - RISK-REGISTER
---

# Platform and Store Review Risk Notes

## 1. Bu belge nedir?

Bu belge, `product-showcase` mobil dagitim ve store review sureclerinde riskli gorulebilecek urunsel alanlari, bunlarin neden risk tasidigini ve launch cizgisinde hangi pozisyonun korunacagini tanimlayan resmi dagitim risk notudur.

## 2. Ana karar

> Mobil uygulama creator utility urunu olarak konumlanir; app ici consumer marketplace, agresif dis satin alma dili veya kontrolsuz merchant navigation urunun ana kimligi haline getirilmez. Store policy ile catisa bilecek billing ve external-link davranislari dikkatle sinirlanir.

## 3. Ana risk alanlari

1. external purchase / billing yonlendirmesi
2. app icinde viewer-first shopping hissi
3. share extension veya incoming share davranisi
4. user-generated merchant links
5. account deletion ve recovery gorunurlugu

## 4. Koruyucu ilkeler

1. Mobile app public storefront yerine creator workflow diliyle konumlanir.
2. Store policy ile catisabilecek billing akislari app core navigation'ina tasinmaz.
3. Account silme veya recovery yolu acik yazilir.
4. Merchant linkler creator utility baglaminda kalir; shopping directory hissi yaratmaz.

## 5. Billing ve dis satin alma notlari

1. App icinde web checkout'u agresif kopya ile itmek risklidir.
2. Upgrade/billing yonlendirmeleri owner utility baglaminda, kontrollu copy ile ele alinmalidir.
3. Yeni mobile billing capability eklenecekse bu belge tekrar gozden gecirilir.

## 6. External link riskleri

1. Merchant link agirligi app'i consumer commerce shell gibi gosterebilir.
2. Linklerin creator recommendation baglamindan kopmamasina dikkat edilir.
3. Unsafe veya blocked link'ler app review riski de yaratir; policy'den gecmeyen URL asla yuzeye cikmaz.

## 7. Share capability riskleri

1. Share extension / incoming share capability'si utility akisi olarak savunulabilir olmalidir.
2. Arka planda gizli scraping veya belirsiz data toplama hissi yaratilmamalidir.
3. Kullaniciya neyin import edildigi acik gosterilmelidir.

## 8. Trigger eden degisiklikler

Asagidaki degisikliklerden biri olursa store review riski yeniden incelenir:

1. mobile billing akisi eklenmesi
2. app icinde viewer/public consumption yuzeyinin buyumesi
3. yeni platform capability'si (extension, background task, intent) eklenmesi
4. merchant link davranisinin daha agresif hale gelmesi

## 9. Bu belgenin basari kriteri nedir?

Mobil urun kimligi creator utility cizgisinde kalıyor, store policy ile catismaya aday alanlar release oncesi yeniden degerlendiriliyor ve ekip "hangi degisiklik store review riskini buyutur?" sorusunu bu belge uzerinden cevaplayabiliyorsa belge amacina ulasmistir.
