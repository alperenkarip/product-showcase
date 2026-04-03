---
id: CREATOR-WEB-SCREEN-SPEC-001
title: Creator Web Screen Spec
doc_type: creator_web_design
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - CREATOR-WORKFLOWS-001
  - TEMPLATE-CUSTOMIZATION-RULES-001
  - DESIGN-DIRECTION-BRAND-TRANSLATION-001
blocks:
  - WEB-SURFACE-ARCHITECTURE
  - EMPTY-LOADING-ERROR-STATE-SPEC
  - MOTION-FEEDBACK-MICROINTERACTION-SPEC
---

# Creator Web Screen Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` creator web uygulamasindaki dashboard, library, shelf editor, content page builder, import history, settings ve billing gibi ekran ailelerinin bilgi yogunlugunu, layout modelini, yan panel / table / bulk edit davranisini ve owner/editor rollerinin bu yuzeylerde nasil ayrisacagini tanimlayan resmi desktop creator design spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Web creator yuzeyi neden mobilin buyumus kopyasi olmamalidir?
- Hangi ekranlarda tablo yogunlugu kabul edilir, hangilerinde builder daha uygun olur?
- Dashboard'ta ne gorunmeli, ne gorunmemeli?
- Library ve import history neden ayri ama bagli yuzeylerdir?
- Shelf editor ve content page builder arasindaki fark masaustunde nasil belirginlesir?

Bu belge, creator web'i generic admin panel olmaktan cikarir.

---

## 2. Bu belge neden kritiktir?

Creator retention icin mobil hiz kadar web derinligi de onemlidir.

Yanlis web tasarimi su sorunlari uretir:

- library reuse zorlasir
- duplicate confusion artar
- import failures tani koyulmadan kalir
- page editing gereksiz builder karmasasina doner
- dashboard vanity analytics coplugune bogulur

Creator web'in gorevi, "her sey burada olsun" degil; yogun creator operasyonlarini daha net ve guvenli hale getirmektir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Creator web, yogun bilgi ve toplu operasyon kapasitesini creator-uygun sadelikle birlestiren utility-first bir desktop surface'tir; table, side panel, split view ve bulk actions kullanilabilir, ancak yuzey asla internal ops console veya generic enterprise CMS hissine kaymaz.

Bu karar su sonuclari dogurur:

1. Dashboard is sinyali merkezli olur, vanity analytics merkezli olmaz.
2. Library ve import history ayri ekran aileleri olarak korunur.
3. Page builder'lar "pixel-perfect site builder" degil, context-first curation araci gibi davranir.

---

## 4. Creator web ilkeleri

### 4.1. Dense but readable

Masaustu avantaji bilgi yogunlugudur.  
Ama yogunluk, debug panel kalabaligina donusmemelidir.

### 4.2. Search and compare first

Library ve import ekranlarinda:

- arama
- filtre
- duplicate clarity
- compare edilebilir satirlar

oncelikli olmalidir.

### 4.3. Split responsibilities

Dashboard, library, editor ve settings ayni "mega screen" icine yigilmamalidir.

### 4.4. Safe bulk action

Archive, remove, re-order ve benzeri toplu islerde etki alani gorunur olmalidir.

---

## 5. Layout ailesi

Creator web icin uc ana layout tipi vardir:

1. overview dashboard
2. list/table + side panel
3. builder/editor canvas + side controls

### 5.1. Overview dashboard

Kisa sağlık sinyali ve next-action alanidir.

### 5.2. List/table + side panel

Library, import history ve supportable review icin uygundur.

### 5.3. Builder/editor canvas

Shelf ve content page duzenleme icin uygundur.

---

## 6. Screen family 1: Dashboard

## 6.1. Amac

Creator'i sisteme girince neyin aksiyon bekledigine yonlendirmek.

## 6.2. Asgari bolumler

1. pending review imports
2. recent publish health
3. stale/broken source dikkat kartlari
4. hizli continue aksiyonlari

## 6.3. Bilincli olarak ikinci planda kalanlar

- vanity charts
- follower-like metrics
- gereksiz lifetime counters

## 6.4. Primary soru

Dashboard şu soruya cevap vermelidir:

"Simdi ne yapmaliyim?"

---

## 7. Screen family 2: Product library index

## 7.1. Amac

Reuse, duplicate clarity ve product maintenance'in ana yuzeyidir.

## 7.2. Layout

Onerilen model:

- ustte search + filter bar
- ortada table veya dense grid
- sagda side panel/detail drawer opsiyonel

## 7.3. Asgari sutunlar veya kart alanlari

- primary image
- title
- merchant/source summary
- trust state
- archive state
- placement count

## 7.4. Zorunlu ozellikler

1. hizli arama
2. duplicate/reuse clarity
3. archive state ayrimi
4. source sagligi gorunurlugu

---

## 8. Screen family 3: Product detail / side panel

## 8.1. Amac

Library listesinden ayrilmadan detay gormek.

## 8.2. Asgari icerik

1. selected image
2. title ve tags
3. source listesi
4. trust/disclosure state
5. placement kullanim alani
6. last refresh / stale bilgisi

## 8.3. Kural

Bu panel ops log duvarina donmez.  
Creator'in karar vermesi icin gerekli ozeti verir.

---

## 9. Screen family 4: Shelf editor

## 9.1. Amac

Evergreen veya recurring recommendation cluster'ini olusturmak ve duzenlemek.

## 9.2. Layout

Onerilen model:

- ustte page header + publication state
- ortada placement listesi / grid preview
- yanda properties ve ordering controls

## 9.3. Kritik davranislar

1. drag/reorder
2. placement note duzenleme
3. featured toggle
4. draft / publish / archive

## 9.4. Kural

Boş shelf publish edilmez ve editor owner degilse publish aksiyonu kilitli veya aciklamali olur.

---

## 10. Screen family 5: Content page builder

## 10.1. Amac

Content-linked recommendation page'i kurmak.

## 10.2. Layout

Onerilen model:

- content reference block
- intro/context fields
- linked products listesi
- publication rail

## 10.3. Shelf'ten farki

Content page builder:

- content reference alanini birinci sinif blok olarak tasir
- "bu icerikte gecenler" semantiğini açık eder

## 10.4. Yapilmamasi gerekenler

- bunu generic landing page builder gibi tasarlamak
- page-level context'i meta panel'e gömmek

---

## 11. Screen family 6: Import history and failures

## 11.1. Amac

Creator'in son importlarini, pending review'lari ve basarisiz veya blocked durumlari anlamasi.

## 11.2. Asgari sutunlar

- submitted URL summary
- merchant/tier
- status
- failure or review reason
- created / updated time
- next action

## 11.3. Kural

Bu ekran ops dashboard'un kucuk kopyasi degildir.  
Creator'in "neden olmadi, simdi ne yapayim?" sorusuna cevap verir.

---

## 12. Screen family 7: Template and appearance settings

## 12.1. Amac

Sinirli ama degerli template secimi ve görsel varyasyon.

## 12.2. Asgari icerik

1. template family secimi
2. preview
3. accent/spacing yogunlugu gibi kontrollu ayarlar

## 12.3. Kural

Trust/disclosure gorunurlugu bu ekranda kapatilamaz.

---

## 13. Screen family 8: Storefront settings

## 13.1. Amac

Account-level olmayan ama storefront-level kararlar:

- basic profile
- domain baglama
- general trust defaults
- share/SEO baglantilari

## 13.2. Role farki

Owner:

- domain/trust defaults gibi alanlara erisir

Editor:

- bu ekranin kritik bolumlerine erisemez veya read-only gorur

---

## 14. Screen family 9: Billing and entitlements

## 14.1. Amac

Plan ve entitlements'i account seviyesinde gormek.

## 14.2. Kural

Bu ekran owner'a aittir.  
Editor icin görünmez veya net read-only bilgilendirme ile kilitli olmalıdır.

---

## 15. Bulk action ve safety ilkeleri

### 15.1. Archive / delete / remove farki

Bu uc aksiyon ayri gosterilir.  
Tek generic "delete" dropdown'una sıkıştırılmaz.

### 15.2. Etki alani preview

Bulk action oncesi creator'e su gosterilir:

- kac urun etkilenecek
- hangi page'ler etkilenecek
- geri donus imkani var mi

### 15.3. Undo beklentisi

Undo varsa acik olur.  
Yoksa restore path veya kalicilik net anlatilir.

---

## 16. Empty, degraded ve permission state'leri

Creator web asagidaki state'leri first-class ele alir:

- empty library
- no pending reviews
- duplicate conflict
- stale source warning
- blocked source
- editor cannot publish
- no target selected

Bu state'ler yalniz toast ile gecistirilmez.

---

## 17. Senaryolar

## 17.1. Senaryo A: Creator duplicate problemi cozuyor

Beklenen deneyim:

- library'de benzer product'lar kolay karsilastirilir
- reuse/merge baglami net gorunur

## 17.2. Senaryo B: Content page builder

Beklenen deneyim:

- content reference block page'in ust mantigini tasir
- product listesi builder'in ana icerigidir

## 17.3. Senaryo C: Import failure listesi

Beklenen deneyim:

- creator teknik log degil, aksiyon odakli next step gorur

## 17.4. Senaryo D: Editor publish etmeye calisiyor

Beklenen deneyim:

- permission state acik ve saygili
- gizli başarısızlık yok

---

## 18. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Creator web'i generic admin panel gibi tasarlamak
2. Dashboard'u vanity metrics ile doldurmak
3. Library ve import history'yi tek listeye yigmaya calismak
4. Shelf editor ile content page builder'i ayni ekran varyanti yapmak
5. Bulk actions'i etki alanı gostermeden calistirmak

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `61-web-surface-architecture.md`, creator route ailelerini dashboard, library, editor ve settings olarak ayirmalidir.
2. `56-empty-loading-error-and-state-spec.md`, creator web'in duplicate, stale, blocked ve permission state'lerini bu ekranlara gore detaylandirmalidir.
3. `57-motion-feedback-and-microinteraction-spec.md`, drag/reorder, side panel ve publish feedback'lerini bu davranislarla uyumlu tanimlamalidir.

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator web yogun ama okunur kalabiliyorsa
- reuse, duplicate clarity ve import follow-up web'de guclu sekilde cozuluyorsa
- shelf ve content builder farki ekran davranisinda netlesiyorsa
- owner/editor farki UI'da açıkca hissediliyorsa

Bu belge basarisiz sayilir, eger:

- creator web generic CMS/ops paneli gibi hissediyorsa
- dashboard vanity analytics'e kayiyorsa
- builder ve library yuzeyleri birbirine karisiyorsa

