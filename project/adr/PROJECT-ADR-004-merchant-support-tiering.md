---
id: PROJECT-ADR-004
title: Merchant Support Tiering
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-004 - Merchant Support Tiering

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-004
- **Baslik:** Merchant Support Tiering
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Import governance / operations
- **Karar alani:** Merchant bazli destek seviyelerinin canonical tier modelini sabitler.
- **Ilgili ust belgeler:**
  - `project/import/42-merchant-capability-registry.md`
  - `project/import/48-import-failure-modes-and-recovery-rules.md`
  - `project/research/12-risk-register.md`
- **Etkiledigi belgeler:**
  - `project/operations/101-runbooks.md`
  - `project/operations/103-support-playbooks.md`
  - `project/implementation/113-initial-seed-content-and-demo-data-plan.md`
  - `project/quality/83-import-accuracy-test-matrix.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; bu ADR import governance dilini standartlastirir.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Merchant destek seviyesi dort tier ile ifade edilir.
- Canonical tier adlari `full`, `partial`, `fallback-only` ve `blocked` olarak sabitlenir.
- Registry kaydi olmadan kalici support davranisi acilmaz.
- Tier, extraction, verification agirligi, refresh ve support copy'sini belirler.

Bu ADR'nin ana hukmu sudur:

> `full`, `partial`, `fallback-only` ve `blocked` tier modeli, hem runtime hem support hem ops icin tek dil olur; gayriresmi kisaltmalar veya takma tier isimleri canonical tier yerine gecmez.

---

# 2. Problem Tanimi

Domain destek seviyesi acik degilse:

1. creator beklentisi ile runtime davranisi ayrisir
2. support ayni merchant icin farkli cevap verir
3. refresh ve retry maliyeti kontrolden cikar
4. quality regression oldugunda kill switch karari gecikir

Import davranisinin merchant bazli farkli oldugu bir urunde tiersiz model operasyonel körlüktür.

---

# 3. Baglam

Bazi merchant'larda:

- adapter vardir
- price/title/image guveni yuksektir
- refresh guvenle calistirilir

Bazilarinda ise:

- generic parse agirliklidir
- manual review yuksektir
- refresh kisitli olmalidir

Bu fark, yalniz teknik not olarak degil; urun-operasyon dili olarak sabitlenmelidir.

---

# 4. Karar Kriterleri

1. Support ve ops icin ortak dil yaratmak
2. Import davranisini domain bazli kontrol etmek
3. Kill switch ve refresh politikasina temel saglamak
4. Quality promotion/demotion kararlarini kanitli hale getirmek
5. Creator-facing beklenti yonetimini tutarli kilmak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Tiersiz serbest domain destegi

Eksiler:

- runtime ve support copy'si dagilir
- promotion/demotion kanitsiz olur

## 5.2. Sadece ikili destek modeli

Eksiler:

- partial ve fallback-only gercegini tasiyamaz
- support ve creator beklentisini kaba sekilde ikiye boler

## 5.3. Dort seviyeli merchant tier modeli

Artisi:

- yeterince acik
- runtime ve ops icin uygulanabilir
- quality governance'a uygun

---

# 6. Secilen Karar

Secilen model:

1. `full`
2. `partial`
3. `fallback-only`
4. `blocked`

Baglayici kurallar:

- `full`: kanitli yuksek guven, duzenli refresh, dusuk review agirligi
- `partial`: alan bazli belirsizlik, kontrollu refresh, orta/yuksek review
- `fallback-only`: generic parse + creator correction agirlikli, agresif refresh yok
- `blocked`: policy veya safety nedeniyle import/public cikis yok

Ek kural:

- gayriresmi kisaltmalar yalnizca aciklayici not olabilir; canonical tier alaninda kullanilmaz, runtime ve docs dili `fallback-only` uzerinden gider.

---

# 7. Neden Bu Karar?

- Ikili model operasyonel gercegi tasimaz.
- Dort seviye, fazlalik yaratmadan yeterli ifade gucu saglar.
- Tier modeli refresh, retry, support ve copy davranisini ayni cizgiye toplar.
- Quality regression oldugunda demotion ve block kararlarini netlestirir.

---

# 8. Reddedilen Yonler

- "Herkesi supported sayalim, sadece confidence farkli olsun" yaklasimi reddedildi; cunku creator copy ve support dili belirsizlesir.
- "Sadece blocked/not blocked" modeli reddedildi; cunku operasyonel kalite basamaklari gorunmez olur.
- Ekip ici takma isimlerle tier kullanimi reddedildi; cunku terminoloji dagilmasi yaratir.

---

# 9. Riskler

1. Tier promotion icin siyasi baski olusabilir.
2. `partial` ile `fallback-only` pratikte karisabilir.
3. Registry guncellemesi gecikirse runtime eski varsayimla calisabilir.
4. Seed/test belgelerinde tier isimleri drift edebilir.

---

# 10. Risk Azaltma Onlemleri

- Tier promotion ve demotion import accuracy kanitlarina baglanacak.
- Support ve ops tooling tier summary'yi acikca gosterecek.
- Seed/demo ve internal test belgeleri canonical tier isimleriyle guncellenecek.
- Block ve demotion kararlarina audit izi zorunlu olacak.

---

# 11. Non-Goals

- merchant partnerlik programi tanimlamak
- revenue potansiyeline gore tier atamak
- creator'a gore ayni domain icin keyfi tier farki uretmek
- canonical tier disinda gizli runtime seviyeleri acmak

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Merchant registry canonical state haline gelir.
2. Failure mode ve support playbook belgeleri tier dilini kullanir.
3. Seed/demo data plan'i merchant karmasini tier bazli kurar.
4. Ops, quality regression gordugunde promotion/demotion dilini net kullanir.

Ihlal belirtileri:

- belgelerde gayrikanonik tier adlarinin belirmesi
- support'un ayni merchant icin farkli copy kullanmasi
- refresh davranisinin tier ile aciklanamamasi

---

# 13. Onay Kriterleri

- Merchant capability registry canonical tier adlarini kullanmalidir.
- Support ve ops belgeleri ayni tier dilini tekrar etmelidir.
- Import accuracy matrix tier promotion/demotion kanitini uretebilmelidir.
- Seed/demo ve internal test setleri her tier'i temsil etmelidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Registry, support copy ve seed/test belgelerinde naming uyumu gerektirir.
- **Tahmini Efor:** Dusuk/orta; terminology ve tooling summary guncellemesi.
- **Breaking Change:** Olası; gayriresmi tier adlarini kullanan tooling veya fixture'lar degisir.
- **Migration Adimlari:**
  - canonical olmayan tier ifadelerini tara
  - registry ve fixture veri setlerini `fallback-only` diline cek
  - support/ops ekran summary'lerinde ayni adlari kullan
- **Rollback Plani:** Tier modeli ancak yeni ADR ile supersede edilir; docs disi alias kullanimi rollback sayilmaz, ihlaldir.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - dort tier'in quality governance icin yetersiz kalmasi
  - tier promotion/demotion kararlarinda tekrarli belirsizlik olusmasi
  - yeni merchant segmentlerinin path veya region seviyesinde daha zengin model gerektirmesi
- **Degerlendirme Sorumlusu:** Ops owner + import architecture owner + product owner
- **Degerlendirme Kapsami:**
  - import accuracy matrix verisi
  - support issue family trendleri
  - registry degisiklik sikligi
  - tier isimlerinin ekip icinde tutarliligi
