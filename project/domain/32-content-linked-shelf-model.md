---
id: CONTENT-LINKED-SHELF-MODEL-001
title: Content-Linked Shelf Model
doc_type: domain_specialization
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - DOMAIN-MODEL-001
  - PAGE-TYPES-PUBLICATION-MODEL-001
blocks:
  - PUBLIC-WEB-SCREEN-SPEC
  - PROJECT-ADR-002
---

# Content-Linked Shelf Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urunundeki content-linked page primitive'inin domain davranışını, klasik shelf ile ortak ve farklı yönlerini, hangi metadata'nın zorunlu olduğunu, neden bu sayfa tipinin urunun farklastirici yüzeyi olduğunu ve içerik referansı kaybolduğunda bile nasıl davranması gerektiğini tanımlayan resmi domain specialization belgesidir.

## 2. Ana karar

> Content-linked page, shelf'in basit alt varyantı gibi hafife alınamaz; domain düzeyinde ayrı davranış kurallarına sahip, içerik referansı zorunlu bir context primitive'idir.

## 3. Content-linked page neden ayrıdır?

Çünkü bu surface:

- belirli bir içerik bağlamını taşır
- viewer'e "bu içerikte ne kullanıldı?" sorusunun cevabını verir
- urunun differentiator gücünü görünür kılar

## 4. Zorunlu alanlar

Asgari olarak:

1. title
2. slug
3. owner storefront ilişkisi
4. content context descriptor
5. en az bir placement

Opsiyonel ama güçlü alanlar:

- thumbnail / cover
- platform type
- original content URL
- publish timestamp
- creator intro note

## 5. Shelf ile ortak yönler

- ikisi de context taşır
- ikisi de placement listesi taşır
- ikisi de page publication state taşır

## 6. Shelf ile ayrışan yönler

Content-linked page:

- belirli içerik referansı taşır
- zamanla archive edilme ihtimali daha yüksektir
- OG ve share değeri daha güçlü olabilir

## 7. Domain kuralları

1. Content-linked page ürünsüz publish edilemez
2. İçerik referansı semantik minimum taşımadan publish edilemez
3. Aynı product hem shelf hem content page içinde bulunabilir
4. Original content silinse bile page otomatik hard-delete olmaz

## 8. Lifecycle farkı

Evergreen shelf'ler uzun ömürlü olabilir.  
Content-linked page'ler daha event-driven yaşar.

Bu nedenle:

- archive politikası daha aktif olabilir
- restore davranışı da ayrı değerlendirilir

## 9. Edge case'ler

### 9.1. Story / temporary content

İçeriğin kendisi uçucu olabilir; page tamamen silinmek zorunda değildir.

### 9.2. Original content removed

Page:

- controlled archived/notice state'e geçebilir
- ama creator kararına kadar tamamen yok edilmez

## 10. Bu belge sonraki belgelere ne emreder?

1. `21-page-types-and-publication-model.md` content page'i first-class state taşıyan page type olarak korumalıdır
2. `52-public-web-screen-spec.md` content context'i üst bölgede görünür tasarlamalıdır

## 11. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- content-linked page shelf'ten anlamsal olarak net ayrışıyorsa
- içerik referansı kaybolduğunda bile kontrollü davranış tanımlıysa
- product-showcase'in ana farkı olan "used in this content" modeli teknik primitive haline geliyorsa
