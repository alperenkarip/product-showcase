---
id: PROJECT-ADR-002
title: Public Web vs Creator App Surface Split
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-002 - Public Web vs Creator App Surface Split

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-002
- **Baslik:** Public Web vs Creator App Surface Split
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Surface architecture
- **Karar alani:** Viewer tuketimi ile creator operasyonunun hangi yuzeylere dagilacagini tanimlar.
- **Ilgili ust belgeler:**
  - `project/product/23-creator-workflows.md`
  - `project/product/24-viewer-experience-spec.md`
  - `project/architecture/60-system-architecture.md`
- **Etkiledigi belgeler:**
  - `project/architecture/61-web-surface-architecture.md`
  - `project/architecture/62-mobile-surface-architecture.md`
  - `project/design/52-public-web-screen-spec.md`
  - `project/design/53-creator-mobile-screen-spec.md`
  - `project/design/54-creator-web-screen-spec.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; ADR public web, creator web ve mobile rollerini netlestirir.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Public consumption yuzeyi web-first olacaktir.
- Creator hizli operasyon akislari mobile-friendly tasarlanacaktir.
- Bulk edit, library organizasyonu, template ve ayar derinligi creator web yuzeyinde cozulur.
- Admin/ops yuzeyi web tarafinda kalir.

Bu ADR'nin ana hukmu sudur:

> Viewer icin ana giris public web, creator icin ana hiz katmani mobile-friendly workflow, derin yonetim ise creator web'dir.

---

# 2. Problem Tanimi

Tum rolleri tek yuzeye sikistirmak iki farkli bozulma yaratir:

1. Public web SEO, share preview ve hiz hedeflerini kaybeder.
2. Creator hizli ekleme davranisi gereksiz ekran ve ayar agirligi kazanir.

Ters tarafta her seyi mobile'a itmek de:

- bulk edit
- domain ayari
- organizasyon derinligi

gibi isleri kullanilamaz hale getirir.

---

# 3. Baglam

Bu urunde trafik dis sosyal platformlardan ve mesajlasma linklerinden gelecektir. Bu, public tarafin dogal olarak web-first olmasi anlamina gelir. Buna karsilik creator davranisi:

- hareket halinde urun ekleme
- hizli duzeltme
- paylasim akisi icinden donus

etrafinda sekillenir; bu da mobile-friendly akis gerektirir.  
Ancak template, bulk edit, domain ve detayli organizasyon yine masaustu/web yuzeyinde daha anlamlidir.

---

# 4. Karar Kriterleri

1. Public web performansi ve SEO ihtiyacini bozmamak
2. Creator'in gunluk tekrarli kullanim hizini korumak
3. Deep management islerini uygun yuzeye tasimak
4. Surface ayrimini ekip ve teknik mimari icin anlasilir kilmak
5. App store ve native riskleri kritik public deneyimin onune gecirmemek

---

# 5. Degerlendirilen Alternatifler

## 5.1. Tum ana yuzeyleri mobile-first kurmak

Eksiler:

- public discovery ve SEO zayiflar
- viewer icin app bagimliligi dogar
- web share girisi anlamsizlasir

## 5.2. Tum creator ve viewer akislari web-first kurmak

Eksiler:

- creator hizli ekleme deneyimi yavaslar
- mobilde tekrarli kullanim surtunmesi artar

## 5.3. Public web + creator mobile-friendly split modeli

Artisi:

- viewer ve creator ihtiyaclari ayri ama tutarli ele alinir
- public ve creator kalite hedefleri birbirini sabote etmez

---

# 6. Secilen Karar

Secilen model:

- viewer -> public web storefront/shelf/content page
- creator quick add/verify/publish -> mobile-friendly surface
- creator bulk edit/settings/library/template/domain -> creator web
- admin/ops -> web

Baglayici kurallar:

1. Public page'ler auth duvarli app shell gibi tasarlanmaz.
2. Mobile creator yuzeyi utility-first kalir; derin ayarlar oraya yigılmaz.
3. Creator web, mobildeki hizli loop'un yerine degil tamamlayicisi olarak kurulur.
4. Public viewer deneyimi native app indirisi gerektirmeden tamamlanir.

---

# 7. Neden Bu Karar?

- Social/share trafiği web'e iner; public girisin burada olmasi zorunludur.
- Creator'in hizli ekleme davranisi mobile-friendly akislarda daha gercekcidir.
- Web creator paneli, bulk ve organizasyon islerini daha dusuk surtunmeyle tasir.
- Surface split, public performans hedefleri ile creator productivity hedeflerini ayri optimize etmeyi saglar.

---

# 8. Reddedilen Yonler

- Viewer'i ana olarak native app'e tasimak reddedildi; cunku public discovery ve share akisini bozar.
- Creator'i yalniz web'e hapsetmek reddedildi; cunku hizli ekleme ve hareket halindeki kullanim beklentisini karsilamaz.
- Tumuyle tek shell icinde "hepsini birden" cozmeye calismak reddedildi; cunku bilgi mimarisi sisirir.

---

# 9. Riskler

1. Surface split, ekipte ownership karmaşasi yaratabilir.
2. Mobile ve web arasinda terminology drift olusabilir.
3. Bazi creator'lar derin ayarlari mobilde de bekleyebilir.
4. Public ile creator route ve auth davranislari karisabilir.

---

# 10. Risk Azaltma Onlemleri

- Screen inventory ve surface architecture belgeleri canonical referans olarak kullanilacak.
- Mobile ve web, ayni creator workflow terminology'sini tasiyacak.
- Deep link ve resume modeli early-phase'de netlestirilecek.
- Creator web ve mobile capability'leri ayni epic altinda izlenecek.

---

# 11. Non-Goals

- public viewer icin native app zorunlulugu
- creator mobile icinde tam web panel parity'si
- public ve creator icin tek bilgi mimarisi
- ops/admin capability'lerini mobile'a tasimak

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Public web dokumanlari SEO, OG ve hiz uzerinde daha sert kurallar tasir.
2. Creator mobile quick add ve verify akislarini one alir.
3. Creator web bulk edit, page composition ve settings derinligini tasir.
4. Architecture belgeleri auth, routing ve deployment'i surface bazli ayirir.
5. Implementation roadmap mobile ile web capability'lerini ayni creator loop altinda planlar.

Ihlal belirtileri:

- public page tasarimlarinda auth-oncelikli panel dili belirmesi
- mobile'da derin template/domain ayarlari birikmesi
- web creator panelinin quick add yerine agir ana giris haline gelmesi

---

# 13. Onay Kriterleri

- Public ekranlar viewer icin friction-light ve no-auth girisli olmali.
- Creator mobile quick add, verify ve hafif publish akisini kapsamalidir.
- Creator web bulk/library/settings alanlarini tasimalidir.
- Mobile ve web creator terminology'si tutarli olmalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Yok; ama future surface task'larinin ownerligi ve backlog yeri degisir.
- **Tahmini Efor:** Dokumantasyon ve implementation planlama duzeyi.
- **Breaking Change:** Hayir.
- **Migration Adimlari:**
  - Surface backlog'larini public/creator web/mobile olarak yeniden etiketle
  - Shared route ve auth davranislarini bu ADR ile hizala
  - Mobile'a yanlisla yigilan deep-management islerini creator web'e tası
- **Rollback Plani:** Bu karar ancak yeni ADR ile degistirilir; public veya creator ana surface'i tek yuzeye geri toplamak icin superseding karar gerekir.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - creator kullanim verisinin mobil varsayimi ciddi bicimde reddetmesi
  - public viewer davranisinin app-centric hale gelmesi
  - surface split'in operasyon maliyetini asiri artirmasi
- **Degerlendirme Sorumlusu:** Product owner + mobile lead + web architecture owner
- **Degerlendirme Kapsami:**
  - creator task completion verisi
  - public traffic ve route davranisi
  - mobile/web parity sorunlari
  - support feedback temalari
