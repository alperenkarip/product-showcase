---
id: PROJECT-ADR-008
title: Disclosure Model
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-008 - Disclosure Model

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-008
- **Baslik:** Disclosure Model
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Trust / compliance
- **Karar alani:** Disclosure bilgisinin veri modeli, UI gorunurlugu ve actor davranisini sabitler.
- **Ilgili ust belgeler:**
  - `project/product/27-disclosure-trust-and-credibility-layer.md`
  - `project/compliance/91-disclosure-and-affiliate-labeling-policy.md`
  - `project/design/58-content-copy-guidelines.md`
- **Etkiledigi belgeler:**
  - `project/design/52-public-web-screen-spec.md`
  - `project/quality/86-accessibility-project-checklist.md`
  - `project/operations/103-support-playbooks.md`
  - `project/implementation/114-internal-test-plan.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; trust ve compliance katmanlarini tek modele toplar.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Disclosure product-level veri alanidir.
- Page-level genel not, product-level disclosure'un yerine gecmez.
- Disclosure publicte gorunur ve action-adjacent kalir.
- Creator profil veya workspace seviyesinde varsayilan disclosure olabilir; product bazinda override edilebilir.

Bu ADR'nin ana hukmu sudur:

> Creator ile urun arasindaki ticari veya sponsorluk iliskisi, her urun icin gorunur ve acik sekilde ifade edilir; disclosure ayar veya dipnot katmanina gizlenmez.

---

# 2. Problem Tanimi

Disclosure:

- settings sayfasina saklanirsa
- sadece footer notu olursa
- creator note ile karistirilirsa

viewer recommendation iliskisini anlayamaz, trust kaybolur ve compliance riski dogar.

---

# 3. Baglam

Bu urun recommendation publishing sistemidir. Viewer'in gordugu sey yalnizca urun karti degil; creator'in o urunle iliskisinin niteligidir. Disclosure bu nedenle:

- hukuki dipnot
- dipnota itilmis etiket

degil; product truth'unun bir parcasidir.

---

# 4. Karar Kriterleri

1. Viewer'in iliski tipini hizla anlamasi
2. Creator icin net ama dusuk surtunmeli veri girisi
3. Compliance ve support icin auditlenebilir model
4. Disclosure'un gizlenmesini teknik olarak zorlastirmak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Sadece page-level genel disclosure

Eksiler:

- urun bazli iliskiyi belirsiz birakir

## 5.2. Gizli settings + optional creator note

Eksiler:

- trust signal'i gormezden gelinir
- supportability zayiflar

## 5.3. Product-level disclosure + page-level genel baglam

Artisi:

- urun bazli netlik saglar
- creator'a tekrarli veri girisini azaltan varsayilan mantik verir

---

# 6. Secilen Karar

Secilen model:

- product-level disclosure record
- kart veya detail seviyesinde gorunur row/badge
- creator/workspace seviyesinde varsayilan disclosure tercihi
- product bazinda override

Baglayici kurallar:

1. Product-level disclosure, page-level genel metinle ikame edilmez.
2. Creator note disclosure yerine kullanilmaz.
3. Disclosure sadece renk ile anlatilmaz; text semantics zorunludur.
4. Publicte disclosure, link action'ina anlamsal olarak yakin kalir.

---

# 7. Neden Bu Karar?

- Viewer trust'unu urun noktasinda saglar.
- Creator'a varsayilan + override dengesi verir.
- Compliance ve support icin audit izi birakir.
- Disclosure UI'nin template veya copy tarafinda kaybolmasini engeller.

---

# 8. Reddedilen Yonler

- Sadece genel sayfa notu reddedildi; cunku hangi urunun ne iliski tasidigi belirsiz kalir.
- Optional ve gizli disclosure modeli reddedildi; cunku compliance riskini urune dagitir.
- Creator note'a guvenmek reddedildi; cunku semantics ve denetlenebilirlik kaybolur.

---

# 9. Riskler

1. Creator disclosure girmeyi ek surtunme olarak gorebilir.
2. Varsayilan disclosure yanlis uygulanirsa fazla veya eksik etiket cikabilir.
3. Badge dili kotu secilirse viewer tarafinda kafa karistirabilir.

---

# 10. Risk Azaltma Onlemleri

- Varsayilan disclosure modeli creator tekrarli girisini azaltir.
- Product override akisi verification ve edit yuzeylerinde gorunur olur.
- Copy guidelines disclosure terimlerini sade ve standart tutar.
- Support playbook disclosure issue'larini ayri sinifta okur.

---

# 11. Non-Goals

- disclosure'u sadece legal footer'a itmek
- creator note ile disclosure'u birlestirmek
- disclosure bilgisini publicte gizlemek
- disclosure'u tasarim tercihi gibi optional yapmak

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Product schema disclosure alanlarini canonical hale getirir.
2. Public product card ve detail surface'leri badge/row davranisini kilitler.
3. Accessibility checklist disclosure bilgisinin sadece renkle anlatilmasini engeller.
4. Internal test ve support dry run disclosure edge-case'lerini kapsar.

Ihlal belirtileri:

- ayni page icinde bazi urunlerin disclosure'u kaybolmasi
- creator note'larin disclosure yerine kullanilmasi
- page genel notu varken product badge'lerinin gozden kaybolmasi

---

# 13. Onay Kriterleri

- Disclosure data modeli product seviyesinde bulunmalidir.
- Public UI disclosure bilgisini action-adjacent ve gorunur sunmalidir.
- Varsayilan ve override mantigi creator yuzeylerinde acik olmalidir.
- Support/compliance belgeleri ayni disclosure sozlugunu kullanmalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Product schema, verification UI, public card/detail copy alanlarini etkiler.
- **Tahmini Efor:** Orta; data model, UI ve copy koordinasyonu gerekir.
- **Breaking Change:** Olası; page-level disclosure varsayimi olan taslaklar icin.
- **Migration Adimlari:**
  - product-level disclosure alanlarini canonical hale getir
  - page-level genel notlari product-level semantics ile ayir
  - public ve creator surface'leri ayni disclosure sozlugune cek
- **Rollback Plani:** Disclosure modeli ancak yeni ADR ile degisir; UI'da gizleme veya dipnotlastirma rollback degil ihlaldir.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - creator tarafinda disclosure friction'inin kabul edilemez seviyeye cikmasi
  - viewer tarafinda disclosure anlasilabilirliginin dusuk kalmasi
  - compliance gereksinimlerinin product-level modele ek alanlar istemesi
- **Degerlendirme Sorumlusu:** Product owner + compliance owner + design owner
- **Degerlendirme Kapsami:**
  - disclosure tamamlama oranlari
  - support/compliance issue trendleri
  - public trust geribildirimi
  - accessibility audit bulgulari
