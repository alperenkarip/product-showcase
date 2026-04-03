---
id: SCREEN-INVENTORY-001
title: Screen Inventory
doc_type: design_map
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PAGE-TYPES-PUBLICATION-MODEL-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
  - DESIGN-DIRECTION-BRAND-TRANSLATION-001
blocks:
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-MOBILE-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - ADMIN-OPS-SCREEN-SPEC
  - EMPTY-LOADING-ERROR-STATE-SPEC
---

# Screen Inventory

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde launch ve erken sonraki faz icin gerekli tum ekran ailelerini, bunlarin hangi actor veya yuzey icin var oldugunu, hangi akisin parcasi oldugunu, kritik mi destekleyici mi oldugunu ve hangi ekranin baska bir ekranin hafif varyanti degil de ayri bir screen family sayilmasi gerektigini tanimlayan resmi screen map belgesidir.

Bu belge su sorulara cevap verir:

- Hangi yuzeylerde hangi ekranlar var?
- Hangi ekranlar launch-kritik?
- Hangi ekranlar ayni bilgi mimarisinin farkli yuzleri, hangileri gercekten ayrik primitive'ler?
- Public, creator mobile, creator web ve ops ekranlari nasil gruplaniyor?
- Empty/loading/error state'ler hangi ekran ailelerine bagli?

Bu belge, sadece ekran isim listesi degildir.  
Bu belge tasarim ve implementasyon kapsam haritasidir.

---

## 2. Bu belge neden kritiktir?

Screen inventory net olmazsa su sorunlar ortaya cikar:

- bazi ekranlar gereksiz varyant olarak cogalir
- bazi ekranlar "zaten su ekranin icine sikistiririz" diye kaybolur
- launch kapsami ile sonraki faz ekranlari karisir
- creator mobile ve web rolleri bulanir

Bu urunde ekran ailesi ile domain primitive arasinda guclu bir bag vardir.  
Ozellikle:

- storefront
- shelf
- content page
- verification
- import history
- failed import detail

gibi yuzeyler birbirinin modali degildir; gercek ekran aileleridir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` ekran yapisi dort ana yuzeye ayrilir: public web, creator mobile, creator web ve admin/ops; her yuzey kendi actor ihtiyacina gore ayri screen family'ler tasir ve launch kapsami, "her yerde her sey" yerine actor-uygun ekran dagilimi ile korunur.

Bu karar su sonuclari dogurur:

1. Mobile ve web creator ekranlari birebir ayni bilgi yogunluguna sahip olmayacak.
2. Public screen family'leri creator tool ekranlarina karismayacak.
3. Ops ekranlari creator template diliyle tasarlanmayacak.

---

## 4. Screen inventory siniflari

Her ekran asagidaki niteliklerle siniflanir:

- `surface`
- `actor`
- `purpose`
- `criticality`
- `launch_scope`
- `downstream_owner`

### 4.1. `criticality`

- `P0`: launch olmadan urunun cekirdek vaadi tasinmaz
- `P1`: launch'i destekler ama gecikmeli cikabilir
- `P2`: sonraki faz veya polish sinifi

### 4.2. `launch_scope`

- `launch-core`
- `launch-supporting`
- `post-launch`

---

## 5. Public web screen family'leri

Public web, viewer ve paylasilan link ziyaretcisi icin recommendation consumption surface'idir.

### 5.1. Public 01: Storefront home

- surface: public web
- actor: viewer
- purpose: creator root ve featured recommendation girisi
- criticality: `P0`
- launch_scope: `launch-core`

### 5.2. Public 02: Shelf page

- surface: public web
- actor: viewer
- purpose: recurring context altinda product cluster gosterimi
- criticality: `P0`
- launch_scope: `launch-core`

### 5.3. Public 03: Content page

- surface: public web
- actor: viewer
- purpose: "bu icerikte kullanilanlar" deneyimi
- criticality: `P0`
- launch_scope: `launch-core`

### 5.4. Public 04: Product light detail

- surface: public web
- actor: viewer
- purpose: karttan daha cok baglam, PDP'den daha hafif karar sayfasi
- criticality: `P1`
- launch_scope: `launch-supporting`

### 5.5. Public 05: Archived / removed page

- surface: public web
- actor: viewer
- purpose: kaldirilmis veya arsivlenmis public route'lari kontrollu sonuclandirma
- criticality: `P0`
- launch_scope: `launch-core`

### 5.6. Public 06: Not found / invalid route

- surface: public web
- actor: viewer
- purpose: handle veya slug bulunamadiginda creator baglamini kaybetmeden cikis verme
- criticality: `P1`
- launch_scope: `launch-supporting`

---

## 6. Creator mobile screen family'leri

Creator mobile, owner/editor'in gunluk hiz aksiyonlari icindir.

### 6.1. Mobile 01: Auth / session entry

- purpose: giris, session devam ettirme
- criticality: `P1`
- launch_scope: `launch-supporting`

### 6.2. Mobile 02: Quick import entry

- purpose: URL girme / share intake karsilama
- criticality: `P0`
- launch_scope: `launch-core`

### 6.3. Mobile 03: Import processing / waiting

- purpose: async job bekleme ve status takibi
- criticality: `P0`
- launch_scope: `launch-core`

### 6.4. Mobile 04: Verification and correction

- purpose: title/image/merchant/reuse review
- criticality: `P0`
- launch_scope: `launch-core`

### 6.5. Mobile 05: Target picker

- purpose: shelf/content page secimi veya library-only kaydetme
- criticality: `P0`
- launch_scope: `launch-core`

### 6.6. Mobile 06: Quick page create

- purpose: yeni shelf veya content page icin hafif olusturma akisi
- criticality: `P1`
- launch_scope: `launch-supporting`

### 6.7. Mobile 07: Publish confirmation

- purpose: sonuc, next-step ve sharing feedback
- criticality: `P1`
- launch_scope: `launch-supporting`

### 6.8. Mobile 08: Offline / retry draft state

- purpose: baglanti kaybinda local ilerleme ve kurtarma
- criticality: `P1`
- launch_scope: `launch-supporting`

---

## 7. Creator web screen family'leri

Creator web, derin duzenleme, organizasyon ve review icindir.

### 7.1. Web 01: Creator dashboard

- purpose: recent imports, publish health, pending review sinyalleri
- criticality: `P1`
- launch_scope: `launch-supporting`

### 7.2. Web 02: Product library index

- purpose: search, reuse, duplicate clarity
- criticality: `P0`
- launch_scope: `launch-core`

### 7.3. Web 03: Product review / side panel

- purpose: library icinden detay, source ve trust inceleme
- criticality: `P1`
- launch_scope: `launch-supporting`

### 7.4. Web 04: Shelf editor

- purpose: shelf yaratma, re-order, note ve publication
- criticality: `P0`
- launch_scope: `launch-core`

### 7.5. Web 05: Content page builder

- purpose: content-linked page kurma ve duzenleme
- criticality: `P0`
- launch_scope: `launch-core`

### 7.6. Web 06: Bulk edit / bulk reorder

- purpose: yogun creator operasyonlari
- criticality: `P1`
- launch_scope: `launch-supporting`

### 7.7. Web 07: Template and appearance settings

- purpose: template secimi ve sinirli customizasyon
- criticality: `P1`
- launch_scope: `launch-supporting`

### 7.8. Web 08: Storefront settings

- purpose: profile, domain, trust defaults, publishing settings
- criticality: `P1`
- launch_scope: `launch-supporting`

### 7.9. Web 09: Import history and failure list

- purpose: son importlar, pending review, failed imports
- criticality: `P0`
- launch_scope: `launch-core`

### 7.10. Web 10: Billing and entitlements

- purpose: plan / subscription / seats benzeri account-level kararlar
- criticality: `P1`
- launch_scope: `launch-supporting`

---

## 8. Admin / ops screen family'leri

Internal yuzeyler creator deneyiminin operasyonel arka planini yonetir.

### 8.1. Ops 01: Import jobs dashboard

- purpose: queue health ve failure pattern gorme
- criticality: `P0`
- launch_scope: `launch-core`

### 8.2. Ops 02: Import job detail

- purpose: tekil vakanin stage, failure code, payload ve recovery durumunu inceleme
- criticality: `P0`
- launch_scope: `launch-core`

### 8.3. Ops 03: Merchant registry console

- purpose: tier, kill switch, notes ve review tarihi yonetimi
- criticality: `P0`
- launch_scope: `launch-core`

### 8.4. Ops 04: Broken link / stale source queue

- purpose: refresh degradation ve trust riski takibi
- criticality: `P1`
- launch_scope: `launch-supporting`

### 8.5. Ops 05: Unsafe link / abuse review

- purpose: blocked domain, unsafe redirect ve policy review
- criticality: `P0`
- launch_scope: `launch-core`

### 8.6. Ops 06: Support lookup console

- purpose: creator vakasi baglaminda destekli goruntuleme
- criticality: `P1`
- launch_scope: `launch-supporting`

---

## 9. State-only screen family'leri

Bazi yuzeyler tam yeni screen degil ama first-class state tasir.  
Bunlar screen inventory icinde ayrica izlenir.

### 9.1. Empty state family

- empty storefront
- empty shelf
- empty library
- empty failed queue

### 9.2. Loading / processing family

- import processing
- queue waiting
- public skeleton loading

### 9.3. Error / degraded family

- blocked import
- failed import
- stale price warning
- archived public page
- broken merchant link

Bu aileler `56-empty-loading-error-and-state-spec.md` icinde derinleşir.

---

## 10. Cross-surface handoff noktalarI

Bu urunde bazi akislar bir yuzeyde baslayip digerinde devam edebilir.

### 10.1. Mobile -> web handoff

Ornekler:

- mobilde import edip webde bulk duzenleme
- mobilde draft olusturup webde template secme

### 10.2. Web -> public handoff

Ornekler:

- preview to public publish
- content page builder -> public route

### 10.3. Ops -> support handoff

Ornekler:

- failed import job detail -> creator-facing destek cevabi

Inventory bu handoff'lari gizlememelidir.

---

## 11. Launch oncesi zorunlu ekranlar

Launch gate icin asgari zorunlu ekran seti:

1. public storefront home
2. public shelf page
3. public content page
4. mobile quick import entry
5. mobile verification
6. mobile target picker
7. web product library index
8. web shelf editor
9. web content page builder
10. web import history
11. ops import jobs dashboard
12. ops import job detail

Bu set olmadan urunun cekirdek vaadi eksik kalir.

---

## 12. Bilincli olarak launch disinda birakilabilen ekranlar

Asagidaki alanlar sonraki faza kalabilir:

- gelismis analytics dashboard
- zengin public product detail varyasyonlari
- coklu internal moderation panelleri
- development-only diagnostics screens

Bu belge launch disini "yok" degil, "simdilik kapsam disi" olarak isaretler.

---

## 13. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Mobile ve web creator ekranlarini ayni yogunlukta ele almak
2. Verification'i ayri screen family saymamak
3. Content page'i shelf varyanti gibi gormek
4. Ops job detail'i liste icinde gizli drawer'a indirgeyip ayri ekran ihtiyacini reddetmek
5. Empty/error state'leri tasarim inventory'si disinda dusunmek

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `52-public-web-screen-spec.md`, public family'leri bu inventory ile birebir uyumlu tasarlamalidir.
2. `53-creator-mobile-screen-spec.md`, mobile import ve verification akisini ayrik screen family'ler olarak ele almalidir.
3. `54-creator-web-screen-spec.md`, library, editor ve import history ekranlarini bu ayrimla modellemelidir.
4. `55-admin-ops-screen-spec.md`, jobs dashboard ve job detail ayrimini korumalidir.
5. `56-empty-loading-error-and-state-spec.md`, state-family ekranlarini bu envantere gore tasarlamalidir.

---

## 15. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ekip hangi screen family'nin neden var oldugunu tek bakista anlayabiliyorsa
- launch kapsamindaki cekirdek ekranlar net ayristirilmissa
- actor ve surface farklari ekran seviyesinde de korunuyorsa

Bu belge basarisiz sayilir, eger:

- farkli yuzeylerin rolleri birbirine karisiyorsa
- verification, content page veya ops detail gibi kritik family'ler "sonra bakariz" seklinde belirsiz kaliyorsa

