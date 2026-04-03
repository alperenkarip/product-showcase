---
id: PROJECT-ADR-005
title: Product Reuse and Dedup Model
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-005 - Product Reuse and Dedup Model

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-005
- **Baslik:** Product Reuse and Dedup Model
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Domain model
- **Karar alani:** Product, source ve placement arasindaki canonical ayrimi ve dedupe davranisini tanimlar.
- **Ilgili ust belgeler:**
  - `project/domain/30-domain-model.md`
  - `project/domain/31-product-library-and-reuse-model.md`
  - `project/import/43-link-normalization-and-deduplication-rules.md`
- **Etkiledigi belgeler:**
  - `project/product/23-creator-workflows.md`
  - `project/data/71-database-schema-spec.md`
  - `project/implementation/111-work-breakdown-structure.md`
  - `project/quality/83-import-accuracy-test-matrix.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; domain model ve DB schema kararlarini hizalar.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Product reusable library entity'sidir.
- Product source, import ve refresh truth'unu tasiyan ayrik entity'dir.
- Placement, product'in sayfa veya shelf baglamindaki sunum katmanidir.
- Dedupe canonical URL, merchant sinyali, similarity ve creator review ile calisir.

Bu ADR'nin ana hukmu sudur:

> Ayni creator/workspace icin ayni urun mumkun oldugunca tek `product` kaydinda tutulur; farkli sunum ve yerlesimler `placement` ile cozulur, farkli kaynak gercekleri ise `product_source` katmaninda yasatilir.

---

# 2. Problem Tanimi

Her shelf veya page icin yeni urun kaydi yaratilirsa:

1. duplicate veri patlar
2. stale source bakimi dagilir
3. creator ayni urunu tekrar tekrar duzeltir
4. support hangi kaydin kanonik oldugunu anlayamaz
5. selected source mantigi karisir

Ters tarafta tek product icine tum baglami gommeye calismak da:

- sayfa bazli notlar
- ozel basliklar
- sira ve vurgu farklari

gibi creator ihtiyaclarini bozar.

---

# 3. Baglam

Bu urunun ana vaadi hizli tekrarli kullanimdir. Bu ancak product library reusable oldugunda anlamlidir. Ayni anda creator'in farkli baglamlarda farkli:

- note
- placement title
- shelf sira
- page aciklamasi

ihtiyaclari vardir. Bu nedenle canonical urun truth'u ile baglamsal sunum ayni entity'ye yigilmamalidir.

---

# 4. Karar Kriterleri

1. Creator tekrarli veri girisini azaltmak
2. Source refresh ve stale bakimini merkezilestirmek
3. Baglama ozel sunumu korumak
4. Dedupe kararlarini supportable ve auditlenebilir yapmak
5. Public trust state'ini canonical source katmanina baglamak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Her sayfada bagimsiz urun karti

Eksiler:

- duplicate enflasyonu yaratir
- refresh ve stale state dagilir

## 5.2. Tek product, tek sunum modeli

Eksiler:

- baglamsal note/title ihtiyacini karsilamaz
- creator expressivity'sini kisar

## 5.3. Product + product_source + placement ayrik modeli

Artisi:

- canonical truth ile baglamsal sunumu ayrisir
- import ve public render daha net hale gelir

---

# 6. Secilen Karar

Secilen model:

- `product` -> canonical library kaydi
- `product_source` -> merchant/source truth'u, selected source state'i ve refresh durumu
- `placement` -> page veya shelf icindeki baglamsal sunum

Baglayici kurallar:

1. Public trust row canonical source state'ine dayanir; placement note'una degil.
2. Ayni product birden fazla placement'ta kullanilabilir.
3. Duplicate merge karari creator review veya kanitli normalization sinyaliyle verilir.
4. Placement silinmesi product silinmesi anlamina gelmez.
5. Product soft delete, aktif placement varken dogrudan purge'e gidemez.

---

# 7. Neden Bu Karar?

- Reuse hizini arttirir.
- Source bakimini tek yere toplar.
- Publicte gosterilen trust state'ini tek truth'a baglar.
- Creator'a farkli page baglamlarinda ifade alani birakir.
- Support ve ops icin duplicate ve stale kaynagini okunur hale getirir.

---

# 8. Reddedilen Yonler

- Sayfa bazli izole urun karti modeli reddedildi; cunku library reuse degerini yok eder.
- Tek product icine note/order/custom title gommek reddedildi; cunku baglam ve truth birbirine karisir.
- Tam otomatik merge modeli reddedildi; cunku yanlis birlestirme creator guvenini bozar.

---

# 9. Riskler

1. Dedupe fazla agresif olursa farkli varyantlar tek product sanilabilir.
2. Dedupe fazla gevsek olursa library duplicate dolar.
3. Placement ve product ayrimi UI'da creator'a karisik gelebilir.
4. Selected source ile placement custom note'u karisabilir.

---

# 10. Risk Azaltma Onlemleri

- Canonical URL ve varyant farklari icin net normalization kurallari uygulanir.
- Dedupe adaylari reviewable surface ile gosterilir.
- UI dili product truth ve placement customization ayrimini acik yazar.
- Wrong merge veya stale source issue'lari support taxonomy'de ayri gorunur.

---

# 11. Non-Goals

- global cross-creator product catalog
- tamamen otomatik merge
- placement notlarini product truth'una yazmak
- page silindiginde product'i de otomatik yok etmek

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. DB schema product/source/placement ayrimini zorunlu kilar.
2. Creator workflows, "reuse vs yeni record" kararini acik yuzeyde sunar.
3. Import flow canonical candidate uretir.
4. Public render, trust state'i source katmanindan okur.
5. Seed veri ve internal test duplicate/varyant senaryolari tasir.

Ihlal belirtileri:

- ayni workspace'te ayni urun icin cok sayida izole kayit birikmesi
- page custom title'larin canonical product title'i gibi davranmasi
- stale state'in placement bazli okunmasi

---

# 13. Onay Kriterleri

- Product, product_source ve placement ayrimi hem domain hem schema hem UI'da ayni anlamla kullanilmalidir.
- Dedupe kurallari normalization ve review akislarina baglanmalidir.
- Creator bir product'i farkli page ve shelf'lerde reuse edebilmelidir.
- Public trust state canonical source'tan okunmalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Data model, import ve creator workflow alanlarinda etkilidir.
- **Tahmini Efor:** Orta/yuksek; schema ve UI dilini birlikte hizalamayi gerektirir.
- **Breaking Change:** Evet, sayfa-bazli urun modeli varsayimi varsa.
- **Migration Adimlari:**
  - product/source/placement entity'lerini ayri modelle
  - mevcut duplicate kayitlari canonical adaylara esle
  - creator workflow'ta reuse secimini gorunur yap
- **Rollback Plani:** Ayrimdan geri donus ancak yeni ADR ile yapilir; aksi halde truth ve placement karisimi yeniden dogar.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - dedupe false-positive veya false-negative trendinin kabul edilemez hale gelmesi
  - creator'larin placement ve product ayrimini tekrarli bicimde anlayamaması
  - cross-creator catalog gerektiren yeni urun yonunun olusmasi
- **Degerlendirme Sorumlusu:** Domain owner + product owner + data owner
- **Degerlendirme Kapsami:**
  - duplicate issue trendleri
  - library reuse davranisi
  - selected source ve stale issue'lari
  - creator support talepleri
