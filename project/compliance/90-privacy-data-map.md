---
id: PRIVACY-DATA-MAP-001
title: Privacy Data Map
doc_type: privacy_inventory
status: ratified
version: 2.0.0
owner: compliance-engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DATABASE-SCHEMA-SPEC-001
  - DATA-LIFECYCLE-RETENTION-DELETION-RULES-001
  - THIRD-PARTY-SERVICES-REGISTER-001
blocks:
  - ENVIRONMENT-AND-SECRETS-MATRIX
  - REPORTING-TAKEDOWN-ABUSE-POLICY
---

# Privacy Data Map

## 1. Bu belge nedir?

Bu belge, `product-showcase` icinde hangi veri siniflarinin hangi amacla toplandigini, hangi sistemlerde islendiginı, hangi actor'lerin erisebildigini, hangi retention siniflarina baglandigini ve hangi veri toplama davranislarinin bilincli olarak disarida birakildigini tanimlayan resmi privacy veri envanteridir.

## 2. Ana karar

> Bu proje creator utility ve public recommendation publishing urunudur; veri toplama da bu utility ile sinirli kalir. Gereksiz davranissal profil cikarimi, merchant linklerden kisi profili zenginlestirme veya support kolayligi bahanesiyle asiri ham veri saklama kabul edilmez.

## 3. Veri siniflari

Asgari veri aileleri:

1. auth ve account verisi
2. creator public profile ve content verisi
3. product/source/import operasyon verisi
4. billing ve entitlement verisi
5. audit, support ve abuse olay verisi
6. minimum analytics/telemetry verisi

## 4. Isleme amaclari

Bu proje veriyi su amaclarla isler:

1. account ve session yonetimi
2. creator publishing ve public rendering
3. import dogrulugu ve supportability
4. guvenlik, abuse ve takedown yonetimi
5. billing ve yasal kayit

Bunlar disindaki amaclar icin veri biriktirmek bu belgenin disindadir.

## 5. Veri haritasi

| Veri ailesi | Neden tutulur | Nerede islenir | Kim erisir | Retention sinifi |
| --- | --- | --- | --- | --- |
| Auth kimligi | owner/editor erisimi | auth + API | user, auth system, sinirli support | account lifecycle |
| Creator profile | public storefront ve handle | app + public web | creator, viewer, support read-only | owner lifecycle / publication lifecycle |
| Product/source/import | import kalite ve public trust | API + worker + ops | creator, support, ops | R1-R3 operasyonel retention |
| Disclosure kayitlari | trust ve uyum | app + public render | creator, viewer, support | yayin suresi + audit |
| Billing olaylari | plan entitlements ve yasal kayit | billing + webhook consumer | owner, billing ops, support kisitli | finansal/yasal retention |
| Audit/support actions | guvenlik ve inceleme | ops/support tools | support, ops, compliance | uzatilmis audit retention |

## 6. Ozellikle toplanmayan veriler

Bu proje bilincli olarak su davranislari benimsemez:

1. merchant ziyaretlerinden bireysel alisveris profili cikarma
2. gereksiz cihaz fingerprint toplama
3. creator veya viewer icin gizli behavioural score tutma
4. full ham merchant page arsivi biriktirme
5. support kolayligi icin maskesiz hassas payload loglama

## 7. Actor bazli erisim ilkeleri

1. Viewer yalniz public data'yi gorur.
2. Creator yalniz kendi workspace verisine erisir.
3. Support scoped, gerekceli ve auditli erisim alir.
4. Ops yalniz operasyonel gereklilik kadar erisir.
5. Billing ve audit gibi hassas aileler owner/support/compliance sinirinda kalir.

## 8. Veri akislari

### 8.1. Creator input -> import pipeline

URL ve ilgili context verisi worker tarafinda islenir; ama gereksiz ham artefact kalici tutulmaz.

### 8.2. Creator publish -> public render

Publicte yalniz yayina alinmis ve privacy-safe alanlar gorunur.

### 8.3. Billing / webhook -> entitlement

Finansal olaylar internal entitlement truth'una yansitilir; gereksiz provider payload'i yuzeylere tasinmaz.

## 9. Retention notlari

Retention detaylarinin source of truth'u `[35-data-lifecycle-retention-and-deletion-rules.md](/Users/alperenkarip/Projects/product-showcase/project/domain/35-data-lifecycle-retention-and-deletion-rules.md)` belgesidir. Bu envanter yalniz hangi veri ailesinin hangi retention cizgisine baglandigini gosterir.

## 10. Kritik notlar

1. Merchant URL ve import log'lari kullanici faydasi icin tutulur; gereksiz PII ile zenginlestirilmez.
2. User-facing analytics minimum urun utility sinirinda tutulur.
3. Export/deletion talebi geldiginde hangi ailelerin nasil ele alinacagi retention ve governance belgeleriyle hizali olmak zorundadir.

## 11. Anti-pattern'ler

1. Support kolayligi icin full raw payload veya full HTML arsivi toplamak
2. Analytics eventi ile audit olayini ayni havuzda tutmak
3. Public veriyi gerekce olmadan actor-scoped veriyle birlestirmek
4. "Belki ileride lazim olur" diye veri toplamak

## 12. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin ekip "hangi veri neden tutuluyor, kim erisiyor ve neden tutmuyoruz?" sorularina bu harita uzerinden net cevap verebilmeli; yeni entegrasyon veya feature bu cizgiye uymadan devreye girememelidir.
