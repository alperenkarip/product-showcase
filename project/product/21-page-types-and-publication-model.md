---
id: PAGE-TYPES-PUBLICATION-MODEL-001
title: Page Types and Publication Model
doc_type: product_surface
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - SUCCESS-CRITERIA-LAUNCH-GATES-001
blocks:
  - ROUTE-SLUG-URL-MODEL
  - PUBLIC-WEB-SCREEN-SPEC
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE
  - CREATOR-WORKFLOWS
---

# Page Types and Publication Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urunundeki public ve creator-side page type primitive'lerini, bu page type'larin hangi state'lerde yasadigini, publish / unpublish / unlisted / archive / preview davranislarini ve sayfa seviyesindeki olgunluk kurallarini tanimlayan resmi surface ve publication model belgesidir.

Bu belge su sorulara cevap verir:

- Hangi sayfa tipleri first-class citizen'dir?
- Hangi sayfa tipleri public, hangileri internal'dir?
- Bir page ne zaman publish edilebilir?
- Preview ve unlisted davranislari nasil ayrisir?
- Archive ve remove ayni sey midir?
- Route, SEO ve template sistemi bu page type kararlarindan nasil etkilenir?

Bu belge olmadan:

- route modeli muallak kalir
- canonical davranis bozulur
- publish ve draft state'leri sayfadan sayfaya farkli yorumlanir
- support ve creator tarafinda "neden bu sayfa yayinda/yayinda degil" sorusu karisir

---

## 2. Bu belge neden kritiktir?

Bu urun icin "page" yalniz bir ekran degildir.  
Page type karari su alanlari belirler:

1. public URL türlerini
2. SEO ve OG stratejisini
3. trust/disclosure gorunurlugunu
4. publish state machine'ini
5. permission ve editor davranisini

Ozellikle bu urunde kritik olan sey, content-linked page'in ikincil degil birincil page type olarak kabul edilmesidir.

Bu belge bunun teknik ve urunsel karsiligini baglar.

---

## 3. Page modelinin ana karari

Bu belge icin ana karar sudur:

> Storefront, Shelf ve Content Page bu urunun publicte birinci sinif page type'laridir. Product detail varsa ikincil destekleyici yuzeydir; product catalog primitive'i degildir.

Bu karar su sonuclari doğurur:

1. Storefront root page tek public primitive degildir
2. Shelf page generic "category page" yerine context page gibi davranir
3. Content Page urunun farklastirici page type'idir
4. Product detail sayfasi varsa creator-context'ten kopuk davranamaz

---

## 4. Public page type seti

### 4.1. Storefront Root

Tanım:
Creator'in public ana vitrini.

Ana amaci:

- creator kimligini tanitmak
- featured shelf ve content page'lere gecis vermek
- recommendation universe'un giris kapisi olmak

Storefront'ta bulunabilecek ana bloklar:

- creator identity
- featured shelves
- featured content pages
- gerekiyorsa featured placements
- trust / disclosure summary

Storefront'ta bulunmamasi gereken baskin davranislar:

- long-form profile microsite
- category browse home
- full shopping catalog

### 4.2. Shelf Page

Tanım:
Nispeten kalici context etrafinda organize edilen urun grubu sayfasi.

Ana amaci:

- tekrar ziyaret edilen context'leri tasimak
- product set'ini grup halinde sunmak

Ana bloklari:

- shelf title
- context description
- placements list
- related contexts

Shelf page ne degildir:

- category landing page
- temporary post detail page

### 4.3. Content Page

Tanım:
Belirli video, reel, post, story, newsletter veya benzeri bir icerige bagli public page.

Ana amaci:

- "bu icerikte ne kullanildi?" sorusuna doğrudan cevap vermek
- urunun asil differentiator surface'ini olusturmak

Ana bloklari:

- content reference
- content title / visual
- product placements
- creator note
- related contexts

### 4.4. Product Light Detail

Tanım:
Product veya placement icin daha fazla karar bilgisi veren, ama generic shopping detail page'e donusmeyen ikincil public surface.

Ne zaman anlamlidir:

- placement karti uzerindeki bilgi yetersiz kalirsa
- creator note daha uzun gosterilecekse
- bir urunun birden fazla context ile iliskisi anlatilacaksa

Ne degildir:

- catalog PDP
- merchant product page replacement

### 4.5. System Pages

Bu urun icin system pages public modelin parcasidir.

Asgari system pages:

- 404 / not found
- archived page notice
- removed content notice
- empty storefront
- blocked / unsafe outbound notice

Bu system pages "edge case" degil, publication modelinin resmi parcasidir.

---

## 5. Creator-side page type seti

Bu yüzeyler public page type'larla karistirilmamalidir.

### 5.1. Onboarding / Setup

Amaç:

- account ve storefront temel kurulumunu yapmak

### 5.2. Dashboard

Amaç:

- recent activity
- pending issues
- hızlı entry points

### 5.3. Product Library

Amaç:

- product yönetimi
- reuse
- source inspection

### 5.4. Verification Surface

Amaç:

- import sonucu review / correction

### 5.5. Shelf Editor

Amaç:

- shelf oluşturma ve düzenleme

### 5.6. Content Page Editor

Amaç:

- content page oluşturma ve düzenleme

### 5.7. Storefront Settings

Amaç:

- public root yapılandırması
- featured selection

### 5.8. Template / Appearance

Amaç:

- kontrollu customization

### 5.9. Import History

Amaç:

- import trail ve issue review

### 5.10. Billing / Plan / Domain

Amaç:

- owner-level administrative controls

Bu page type'lar public indexleme ve canonical modeline dahil değildir.

---

## 6. Publication state modeli

Bu belge icin state modeli page düzeyinde tutarli olmak zorundadir.

### 6.1. Zorunlu ana state'ler

Asgari page state seti:

- `draft`
- `published`
- `unlisted`
- `archived`

Gerekiyorsa teknik alt state'ler olabilir; ama urun dili bu dort state etrafinda sabitlenir.

### 6.2. Draft

Anlamı:

- creator veya editor tarafinda hazırlanan ama publicte görünmeyen sayfa

Kurallar:

- indexlenmez
- canonical olmaz
- signed preview ile görüntülenebilir

### 6.3. Published

Anlamı:

- public route uzerinden görünür
- canonical ve indexlenebilir

Kurallar:

- trust ve disclosure katmanı tamamlanmış olmalı
- route final sayilır

### 6.4. Unlisted

Anlamı:

- public route erişilebilir olabilir
- ama arama/indexleme disidir

Kullanım nedenleri:

- sınırlı paylaşım
- test / review
- sadece link bilen giriş

Kural:

- unlisted page published ile karistirilmaz
- analytics ve support tarafinda state ayrı görünmelidir

### 6.5. Archived

Anlamı:

- aktif public circulation dışına alınmış ama geçmiş kaydı korunmuş sayfa

Kurallar:

- canonical'i aktif kalmaz
- related pages üzerinden kontrollü not gösterilebilir
- restore edilebilir

---

## 7. Page type bazli publication kurallari

### 7.1. Storefront publish kuralı

Storefront'un publish olabilmesi icin asgari su kosullar gerekir:

1. valid handle/slug
2. temel creator identity alanlari
3. en az bir public surface entry point'i

Bu entry point su olabilir:

- bir shelf
- bir content page
- kontrollu featured placement seti

Bos storefront publish edilebilir mi?

Varsayilan karar:

- hayir, full empty storefront publish varsayilan yol olmamalidir

Istisna:

- trial veya soft-setup sırasında limited visible coming-soon benzeri controlled state istenirse ayri policy gerekir

### 7.2. Shelf publish kuralı

Shelf'in publish olabilmesi icin:

1. baslik
2. en az bir aktif placement
3. creator kimligi ile bag

Opsiyonel ama guclu alanlar:

- short description
- hero / cover

### 7.3. Content Page publish kuralı

Content page'in publish olabilmesi icin:

1. title
2. content reference veya context descriptor
3. en az bir aktif placement

Neden bu daha siki?

Cunku content page'in "hangi icerik?" sorusuna cevap verememesi urunun farklastirici vaadini bozar.

### 7.4. Product light detail publish kuralı

Varsa:

- bir creator context'ine bagli olmali
- orphan PDP gibi yaşamamalidir

---

## 8. Product publication ile page publication farki

Bu urunde product library kaydi ile page publication ayni sey degildir.

### 8.1. Product kaydi

Olabilir:

- library'de mevcut
- verified veya correction needed
- ama publicte hic görünmüyor olabilir

### 8.2. Public görünürlük

Asıl public görünürlük placement ve page state üzerinden belirlenir.

Kural:

- "product var" demek "product publicte var" demek değildir
- bu fark UI, support ve analytics tarafinda korunmalidir

---

## 9. Preview modeli

### 9.1. Preview ne icindir?

Preview:

- creator veya editor review
- owner final kontrol
- template degisikligi kontrolu

icin vardir.

### 9.2. Preview ne degildir?

- canonical URL degildir
- public share URL degildir
- kalici route degildir

### 9.3. Preview davranis kurallari

1. signed veya time-boxed olabilir
2. noindex olur
3. cache ve metadata davranisi public canonical ile ayni sayilmaz

---

## 10. Revision ve live update modeli

Published page duzenlendiginde varsayilan davranis belirlenmelidir.

### 10.1. Minor edits

Ornek:

- typo fix
- note update
- small order change

Varsayilan:

- live update olabilir

### 10.2. Major edits

Ornek:

- slug degisimi
- template family degisimi
- featured structure degisimi
- content reference degisimi

Varsayilan:

- preview-before-publish akisi onerilir

### 10.3. Neden bu ayrim gerekir?

Cunku her degisiklik icin agir preview süreci creator hizini bozar.  
Ama her şeyi de anlik yayina vermek public kalite riskidir.

---

## 11. Unpublish, archive ve remove farklari

### 11.1. Unpublish

Anlamı:

- page public circulation'dan cekilir
- ama page aktif bir çalışma nesnesi olarak kalabilir

### 11.2. Archive

Anlamı:

- page operasyonel olarak kapatilir
- ama gecmis izi korunur

### 11.3. Remove

Anlamı:

- page değil, placement ilişkisi context'ten çıkarılır

Kural:

- creator UI'inda bu fark net gosterilmelidir
- support playbook'lari bu kavramlari karistirmamalidir

---

## 12. Edge case publication kurallari

### 12.1. Empty storefront

Storefront'ta hic aktif shelf/content page yoksa:

- publish bloke edilir veya
- controlled empty state ile özel policy gerekir

Varsayilan:

- empty storefront aktif launch path'i değildir

### 12.2. Archived product source inside published page

Bir source stale veya archived oldugunda:

- placement otomatik silinmez
- creator'a correction / remove önerilir

### 12.3. Removed original content

Ornek:

- video silindi ama content page kaydi var

Davranis:

- content page otomatik 404 olmak zorunda degildir
- "orijinal içerik artık mevcut değil" gibi controlled state sunulabilir

### 12.4. All placements unavailable

Bir page içindeki tum placements archive/invalid hale geldiyse:

- page state review gerektirir
- publicte kirik deneyim uretilmemelidir

---

## 13. SEO ve share etkileri

Page type karari şu teknik sonuçlari zorunlu kilar:

1. her published page kendi canonical ve metadata setine sahiptir
2. unlisted pages noindex olur
3. preview pages canonical üretemez
4. content pages OG/share tarafinda oncelikli yuzeydir
5. archived page'ler aktif SEO yüzeyi gibi davranmaz

---

## 14. Permission ve actor etkileri

### 14.1. Owner

Tum page type'larda final publish/unpublish/archive kararini verebilir.

### 14.2. Editor

Page taslaklarini hazirlayabilir, düzenleyebilir, belki publish tetikleyebilir; ama kritik ownership/billing/domaine dokunamaz.

Bu detay `roles-permissions` belgesinde netlesir; ama page modeli actor farki tasir.

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Content Page'i optional side surface gibi ele almak
2. Empty storefront'u normal launch state'i gibi kabul etmek
3. Product library varligini public page gibi yorumlamak
4. Preview URL'yi public share URL gibi kullanmak
5. Archive ile remove davranisini karistirmak

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `22-route-slug-and-url-model.md` page type bazli route farklarini net tanimlamalidir
2. `23-creator-workflows.md` draft/publish/archive kararlarini sayfa bazli akislara cevirmelidir
3. `52-public-web-screen-spec.md` storefront, shelf ve content page'i ayri screen family olarak tasarlamalidir
4. `67-seo-og-and-share-preview-architecture.md` canonical/noindex kararlarini bu modele gore kurmalidir

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- hangi page type'in ne için var oldugu tek anlamli hale geliyorsa
- publication state'leri sayfalar arasi tutarlı ise
- content page urunun first-class surface'i olarak korunuyorsa
- preview, unlisted, archive ve remove kavramlari karismiyorsa

Bu belge basarisiz sayilir, eger:

- storefront disindaki page type'lar ikincil görünürse
- page publication ile product publication karisirse
- route, SEO ve editor davranislari state modelini tutarlı tasıyamazsa

Bu nedenle bu belge, sayfa listesinden fazlasidir; urunun publicte nasıl yaşadığını tanımlayan stateful surface modelidir.
