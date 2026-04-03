---
id: SECURITY-AND-ABUSE-CHECKLIST-001
title: Security and Abuse Checklist
doc_type: security_checklist
status: ratified
version: 2.0.0
owner: security-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - AUTH-IDENTITY-SESSION-MODEL-001
  - WEBHOOK-EVENT-CONSUMER-SPEC-001
  - THIRD-PARTY-SERVICES-REGISTER-001
  - URL-IMPORT-PIPELINE-SPEC-001
blocks:
  - RELEASE-READINESS-CHECKLIST
  - INCIDENT-RESPONSE-PROJECT-LAYER
---

# Security and Abuse Checklist

## 1. Bu belge nedir?

Bu belge, `product-showcase` icin external link, import, actor authorization, webhook, billing ve support suistimali alanlarinda uygulanmasi gereken proje-ozel guvenlik ve abuse onleme checklist'ini tanimlar.

## 2. Ana karar

> Bu projede guvenlik yalniz auth degil; link safety, owner/editor yetki cizgisi, webhook authenticity, rate limiting ve support/ops action audit'i birlikte korunmadikca urun guvenli sayilmaz.

## 3. Auth ve authorization checklist

1. Owner-only aksiyonlar editor'a acilmaz.
2. Session token veya secret client bundle'a sizmaz.
3. Sensitive aksiyonlar gerektiğinde re-auth ister.
4. Scope resolution olmadan workspace mutation yapilmaz.

## 4. External link ve import checklist

1. URL safety check aktif.
2. Blocked domain listesi uygulanir.
3. Redirect zinciri kontrol edilir.
4. Unsafe scheme/protocol reject edilir.
5. Import rate limit ve abuse guard vardir.

## 5. Webhook ve provider checklist

1. Signature verification zorunlu.
2. Duplicate/replay korumasi vardir.
3. Checkout success access unlock sayilmaz.
4. Secret rotasyonu desteklenir.

## 6. Support ve ops checklist

1. Support action'lari auditli.
2. Silent state mutation yok.
3. Manual retry veya unblock reason code ile yapilir.
4. Owner recovery veya domain aksiyonlari scoped tutulur.

## 7. Billing ve economic abuse checklist

1. Checkout success access unlock sayilmaz.
2. Duplicate webhook event'leri ikinci kez entitlement acmaz.
3. Trial veya grace abuse paterni telemetry ile izlenir.

## 8. Kirmizi bayraklar

1. Ayni merchant'ta phishing benzeri pattern artisi
2. Wrong redirect veya unsafe link support sikayeti
3. Duplicate veya stale source manipülasyonu
4. Webhook reject veya replay spike
5. Invite abuse veya brute-force benzeri hareket

## 9. Incident tetikleyebilecek durumlar

1. Permission escalation supheleri
2. Unsafe link veya domain block bypass
3. Secret leak veya webhook verification bozulmasi
4. Repeated abuse pattern ile import altyapisinin zorlanmasi

## 10. Release blocker maddeleri

1. Permission escalation riski
2. Webhook authenticity acigi
3. Blocked domain policy'sinin uygulanmamasi
4. Secret sizintisi veya client exposure
5. Audit izsiz support/ops mutasyonu

## 11. Bu belgenin basari kriteri nedir?

Ekip, "bu urunde kotu niyetli actor en kolay nereden zarar verir?" sorusunu bu checklist ile sistematik tarayabiliyor ve release adaylari bu maddelerden gecmeden canliya cikmiyorsa belge amacina ulasmistir.
