---
id: ACCESSIBILITY-PROJECT-CHECKLIST-001
title: Accessibility Project Checklist
doc_type: accessibility_checklist
status: ratified
version: 2.0.0
owner: design-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PUBLIC-WEB-SCREEN-SPEC-001
  - CREATOR-MOBILE-SCREEN-SPEC-001
  - CREATOR-WEB-SCREEN-SPEC-001
  - EMPTY-LOADING-ERROR-STATE-SPEC-001
blocks:
  - RELEASE-READINESS-CHECKLIST
---

# Accessibility Project Checklist

## 1. Bu belge nedir?

Bu belge, `product-showcase` icin public ve creator yuzeylerinde yerine getirilmesi gereken proje-ozel erisilebilirlik maddelerini tanimlayan resmi checklist'tir.

## 2. Ana karar

> Bu projede erisilebilirlik yalniz form label'i degil; trust, disclosure, warning, stale state ve reorder gibi kritik urunsel anlamlarin her kullaniciya algilanabilir olmasi demektir.

## 3. Public surface checklist

1. Kart CTA'lari ve merchant cikis aksiyonlari acik label tasir.
2. Disclosure ve stale bilgi yalniz renk ile anlatilmaz.
3. Hidden-by-policy, unavailable ve stale notice metinsel olarak ayristirilir.
4. Image placeholder ve broken image durumlari ekran okuyucuya anlamsiz gorsel kalabaligi yaratmaz.

## 4. Creator surface checklist

1. Verification form alanlari acik etiketli ve grouped semantics tasir.
2. Duplicate/reuse warning'leri screen reader tarafindan fark edilir sekilde duyurulur.
3. Drag/drop veya reorder aksiyonlarinin keyboard/alternative yolu vardir.
4. Async state gecisleri `aria-live` veya platform-esdegeri ile hissedilir.

## 5. Focus ve keyboard checklist

1. Modal, drawer ve review paneli focus trap'i dogru calistirir.
2. Error durumunda odak nereye gittiği kontrolludur.
3. Keyboard-only kullanici import, verification ve publish akisini tamamlayabilir.

## 6. Motion ve feedback checklist

1. Reduced motion tercihleri oncelenir.
2. Success, warning ve error feedback yalniz animasyona baglanmaz.
3. Skeleton/loading state'leri ekrandaki anlami gizlemez.

## 7. Form ve validation checklist

1. Validation hatalari alan ve sayfa seviyesinde anlasilir sekilde duyurulur.
2. Required alanlar ve review-required warning'leri birbirine karismaz.
3. Duplicate/reuse karari secenekleri screen reader ile ayristirilabilir.

## 8. Mobil ozel maddeler

1. Touch target'lar rahat kullanilabilir boyuttadir.
2. Share-entry ve paste-entry akisi screen reader ile tamamlanabilir.
3. Native geri hareketi kritik verification state'ini sessiz kaybetmez.

## 9. Denetim senaryolari

Asgari manuel denetim senaryolari:

1. keyboard ile import -> verification -> publish
2. screen reader ile stale/disclosure row okuma
3. error state ve retry butonlarini odakla tamamlama
4. reorder alternatif akisini klavye ile kullanma

## 10. Release blocker maddeleri

1. Disclosure/trust bilgisinin yalniz renk ile verilmesi
2. Verification formunda label veya error semantics eksigi
3. Keyboard ile publish veya reorder alternatifsiz kalmasi
4. Screen reader kullanicisinin blocked/stale state'i anlayamamasi

## 11. Bu belgenin basari kriteri nedir?

Public ve creator yuzeylerinde urunsel olarak kritik anlamlarin sadece goren veya fare kullanan kisiye degil, tum kullanicilara acik olmasi ve release audit'lerinde bu maddelerin somut olarak kontrol edilebilmesidir.
