---
id: PROJECT-ADR-006
title: Template Customization Boundaries
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-006 - Template Customization Boundaries

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-006
- **Baslik:** Template Customization Boundaries
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** UX system / customization
- **Karar alani:** Creator template ozellestirmesinin urun, trust ve performans sinirlari icinde nasil yapilacagini tanimlar.
- **Ilgili ust belgeler:**
  - `project/product/26-template-and-customization-rules.md`
  - `project/design/50-design-direction-and-brand-translation.md`
  - `project/product/27-disclosure-trust-and-credibility-layer.md`
- **Etkiledigi belgeler:**
  - `project/design/52-public-web-screen-spec.md`
  - `project/design/54-creator-web-screen-spec.md`
  - `project/quality/85-performance-budgets.md`
  - `project/quality/86-accessibility-project-checklist.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; controlled template modeli design system ile uyumludur.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Customization controlled preset modeliyle sinirlanir.
- Zorunlu bilgi hiyerarsisi creator tarafindan kaldirilamaz.
- Serbest HTML/CSS, custom code veya tam page builder acilmaz.
- Trust, disclosure ve external link bilgisi template tercihiyle gizlenemez.

Bu ADR'nin ana hukmu sudur:

> Creator ifade alani kazanir; ama urunun trust, performans, erisilebilirlik ve bilgi mimarisi omurgasi bozulamaz.

---

# 2. Problem Tanimi

Sinirsiz ozellestirme:

1. public kaliteyi dagitir
2. disclosure ve trust alanlarini gizleme riski yaratir
3. performans ve erişilebilirlik kontrolunu zayiflatir
4. support ve QA maliyetini patlatir

Ters tarafta hic customization vermemek de creator'in sahiplenme ve marka hissini zayiflatir.

---

# 3. Baglam

Bu urunun farki sonsuz ozel tasarlanabilir storefront olmak degil; hizli import ve kaliteli public sunumdur. Creator:

- renk
- tipografi tonu
- density
- section vurgu

gibi kontrollu alanlarda fark yaratabilmelidir.  
Ama template sistemi generic no-code builder'a donusurse:

- trust row saklanir
- page performansi sapar
- her storefront baska urun gibi davranir

---

# 4. Karar Kriterleri

1. Varsayilan kaliteyi korumak
2. Creator'a yeterli ama kontrollu ifade alani vermek
3. Trust/disclosure ve performance alanlarini garanti altinda tutmak
4. Support, QA ve accessibility maliyetini yonetilebilir tutmak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Serbest page builder mantigi

Eksiler:

- kalite ve support maliyeti asiri artar
- trust alanlari gizlenebilir

## 5.2. Tek zorunlu sabit template

Eksiler:

- creator sahiplenmesini ve ifade farkini kisar

## 5.3. Controlled preset + token varyasyon modeli

Artisi:

- kalite zemini korunur
- creator'a anlamli ama sinirli ozel alan verir

---

# 6. Secilen Karar

Secilen model:

- 3-5 template ailesi
- token-bazli renk ve tipografi varyasyonlari
- density ve vurgu secenekleri
- section-level ac/kapa ama sinirli duzen

Baglayici kurallar:

1. Product card, trust row, disclosure ve merchant cikisi kaldirilamaz.
2. Custom code veya HTML embed acilmaz.
3. Layout grid ve content hierarchy tamamen serbest birakirlamaz.
4. Accessibility ve performance budget'ini asan template varyasyonu kabul edilmez.

---

# 7. Neden Bu Karar?

- Creator'a ifade alani verirken trust omurgasini korur.
- Tasarim sistemi ve public kalite zemini dagilmaz.
- QA ve support yuku patlamaz.
- Performance ve a11y kontrol altinda kalir.

---

# 8. Reddedilen Yonler

- Serbest HTML/CSS reddedildi; cunku urunu baska bir kategoriye iter.
- Herkese ayni sabit storefront reddedildi; cunku creator sahiplenmesini zayiflatir.
- Trust/disclosure alanlarini template optional yapmak reddedildi; cunku public guveni bozar.

---

# 9. Riskler

1. Bazi creator'lar ozellestirme alanini yetersiz bulabilir.
2. Token seti kotu tasarlanirsa her storefront benzer hissedebilir.
3. Template varyasyonlari arttikca test matrisi sisebilir.

---

# 10. Risk Azaltma Onlemleri

- Az sayida ama farkli template ailesi secilir.
- Density, type scale ve accent gibi fark yaratan ama guvenli varyasyonlar acilir.
- Template capability'leri roadmap'te core loop sonrasina konur.
- Public kalite audit'i template bazli tekrar edilir.

---

# 11. Non-Goals

- custom code
- serbest layout builder
- disclosure/trust alanini kapatmak
- page bazli class/HTML editor

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Creator web settings controlled tokens etrafinda kurulur.
2. Public screen spec zorunlu bilgi hiyerarsisini korur.
3. Design system component'leri degistirilebilir degil, konfigure edilebilir olur.
4. Performance ve accessibility checklist'leri template capability'sine baglanir.

Ihlal belirtileri:

- template secimiyle trust row'un kaybolmasi
- creator'in layout'u serbestce bozabilmesi
- template degisince CLS/performance budget'lerinin bozulmasi

---

# 13. Onay Kriterleri

- Template varyasyonlari design token ve preset mantigiyla ifade edilmelidir.
- Trust/disclosure ve core product card bilgisi template fark etmeksizin gorunur kalmalidir.
- Performance ve accessibility budget'leri template bazinda korunmalidir.
- Creator settings UI, builder degil controlled customization dili kullanmalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Public render ve creator settings capability'lerini etkiler.
- **Tahmini Efor:** Orta; token, preset ve settings UI sinirlarini netlestirmeyi gerektirir.
- **Breaking Change:** Olası; serbest customization bekleyen taslaklar varsa.
- **Migration Adimlari:**
  - template ayarlarini controlled token modeline indir
  - kaldirilamaz zorunlu alanlari component seviyesinde kilitle
  - custom-code veya freeform layout fikirlerini backlog disina cikar
- **Rollback Plani:** Genisleme ancak yeni ADR ile ve quality/trust etkisi yeniden hesaplanarak yapilir.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - creator retention veya conversion verisinin mevcut customization seviyesinin yetmedigini gostermesi
  - controlled preset modelinin her storefront'u asiri benzetmesi
  - template test maliyetinin kabul edilemez seviyeye cikmasi
- **Degerlendirme Sorumlusu:** Design owner + product owner + frontend architecture owner
- **Degerlendirme Kapsami:**
  - creator feedback'i
  - template adoption dagilimi
  - trust/performance regressions
  - support talepleri
