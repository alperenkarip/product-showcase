---
id: PROJECT-ADR-003
title: URL Import and Extraction Order
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-003 - URL Import and Extraction Order

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-003
- **Baslik:** URL Import and Extraction Order
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Import architecture
- **Karar alani:** URL import hattinda extraction katmanlarinin hangi sirayla ve hangi sinirlarla calisacagini tanimlar.
- **Ilgili ust belgeler:**
  - `project/import/40-url-import-pipeline-spec.md`
  - `project/import/41-extraction-strategy-and-fallback-order.md`
  - `project/import/47-ai-assisted-extraction-boundaries.md`
  - `project/research/12-risk-register.md`
- **Etkiledigi belgeler:**
  - `project/import/42-merchant-capability-registry.md`
  - `project/import/44-product-verification-ui-and-manual-correction-spec.md`
  - `project/import/48-import-failure-modes-and-recovery-rules.md`
  - `project/architecture/65-job-queue-worker-and-refresh-architecture.md`
  - `project/quality/83-import-accuracy-test-matrix.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; bu ADR proje-ozel import mantigini sabitler.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Extraction sirasi deterministik kaynaktan daha pahali ve belirsiz katmanlara dogru ilerler.
- AI kaynak veri ureten katman degil, normalize eden ve belirsizlik sinifi cikaran yardimci katmandir.
- Human confirmation import'in final quality kapisidir.
- URL normalization ve safety check, extraction sirasinin on kosuludur.

Bu ADR'nin ana hukmu sudur:

> URL normalization ve safety check sonrasinda `merchant parser -> structured data -> OG/social metadata -> HTML heuristic -> AI-assisted normalization -> human confirmation` zinciri bozulmadan uygulanir.

---

# 2. Problem Tanimi

Extraction sirasi belirsiz olursa:

1. maliyet kontrolsuz artar
2. hata kaynaklari okunamaz hale gelir
3. AI yanlis yerde otorite kazanir
4. support ve ops hangi katmanin bozuldugunu anlayamaz
5. creator review'u yalnizca makyaj katmanina donusur

Bu urunde import kalitesi cekirdek farklastiricidir; siralama keyfi olamaz.

---

# 3. Baglam

Structured data ve merchant parser gibi deterministik katmanlar varken her seyi render veya AI ile cozmeye calismak:

- gereksiz pahali
- daha yavas
- daha az denetlenebilir

bir yaklasimdir.

Public trust katmani da:

- yanlis gorsel
- uydurma merchant
- stale veya yanlis fiyat

risklerini tolere etmez. Bu nedenle import hattinda "en zeki gorunen" yol degil, "en denetlenebilir ve guvenli" yol once gelir.

---

# 4. Karar Kriterleri

1. Deterministik dogrulugu en yuksek kaynagi once kullanmak
2. Worker maliyetini ve latency'yi kontrol etmek
3. Debug, support ve ops kabiliyetini korumak
4. AI'nin karar otoritesini sinirlamak
5. Creator review'unu son kalite kapisi olarak korumak

---

# 5. Degerlendirilen Alternatifler

## 5.1. AI-first extraction

Eksiler:

- fiyat ve merchant uydurma riski artar
- supportability ve explainability zayiflar

## 5.2. Render-first extraction

Eksiler:

- maliyet ve latency yukseltir
- her domain icin gereksiz agirlik yaratir

## 5.3. Deterministik-first fallback zinciri

Artisi:

- acik hata siniflari uretir
- hangi katmanin ise yaradigi gozlenebilir
- registry tier'leriyle kolay entegre olur

---

# 6. Secilen Karar

Secilen strateji:

1. URL normalization
2. safety and policy check
3. merchant-specific parser
4. structured data
5. OG/social metadata
6. HTML heuristic parse
7. AI-assisted normalization
8. human confirmation

Baglayici kurallar:

- Safety check gecmeyen URL extraction'a girmez.
- Merchant parser varsa once o denenir.
- AI, kaynagi olmayan fiyat veya merchant uretmez.
- Human confirmation gerektiren kritik alanlar sessizce apply edilmez.
- Katman atlama ancak registry veya policy karariyla olur; gizli shortcut olmaz.

---

# 7. Neden Bu Karar?

- En ucuz ve en guvenilir veri once gelir.
- Render ve AI yalnizca gerekli oldugunda devreye girer.
- Human review yerini kaybetmez.
- Failure taxonomy ve supportability dogal sekilde katmanlara ayrilir.
- Registry tier sistemiyle uyumlu calisir.

---

# 8. Reddedilen Yonler

- AI-first yaklasim reddedildi; cunku cost ve trust riskini ayni anda buyutur.
- Her domain icin render-first yol reddedildi; cunku supported merchant'larda gereksiz yuk yaratir.
- Human confirmation'siz "tam otomatik" final apply reddedildi; cunku wrong image/wrong merchant riskini artiştirir.

---

# 9. Riskler

1. Structured data yanlis veya eksik olabilir.
2. OG image urun gorseli yerine banner secilebilir.
3. HTML heuristic parse yanlis varyanta yonelebilir.
4. AI-assisted normalization fazla guven hissi yaratabilir.
5. Katman sayisi latency yonetimini zorlayabilir.

---

# 10. Risk Azaltma Onlemleri

- Registry tier ile hangi merchant'ta hangi katmanin ne kadar guvenilir oldugu yazilir.
- Verification UI kritik alanlarda creator review zorunlu kilinir.
- Wrong image ve ambiguity durumlari failure family olarak izlenir.
- AI output yalnizca kaynakli alanlarda normalize edilir; authority olmaz.
- Queue/worker tarafinda katman bazli telemetry tutulur.

---

# 11. Non-Goals

- her domain icin creator review'suz tam otomasyon
- AI ile eksik fiyat veya merchant uydurmak
- render'i varsayilan standart haline getirmek
- support'tan gizli "special parser path" acmak

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri dogurur:

1. Merchant capability registry tier mantigi daha anlamli hale gelir.
2. Verification UI, hangi alanin hangi kaynaktan geldigi bilgisini tasiyabilir.
3. Failure modes dokumani teknik arizayi ambiguity ve policy state'inden ayirir.
4. AI guardrail'leri net sinir kazanir.
5. Import accuracy matrix'i katman bazli kaliteyi olcebilir.

Ihlal belirtileri:

- AI'nin fiyat veya merchant alanini tek kaynak gibi doldurmasi
- render'in her import'ta varsayilan olarak calismasi
- support'un "hangi katman bozuldu?" sorusuna cevap verememesi

---

# 13. Onay Kriterleri

- Extraction order dokuman ve runtime davranisi ayni sira ile calismalidir.
- Safety check extraction'tan once uygulanmalidir.
- Verification UI, kritik alanlarda human confirmation kapisini korumalidir.
- AI assisted adim authority degil helper davranisi gostermelidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Import pipeline, worker ve verification alanlarinda sequencing dogrulugu gerektirir.
- **Tahmini Efor:** Orta; extraction katmanlari ve telemetry'nin hizalanmasi gerekir.
- **Breaking Change:** Olası; farkli sira varsayan eski import code-path'leri kapanabilir.
- **Migration Adimlari:**
  - mevcut extractor path'lerini canonical siraya gore haritala
  - AI adiminin authority rolunu temizle
  - katman bazli failure kodlarini standardize et
  - verification ve support copy'sini yeni sira ile uyumlu hale getir
- **Rollback Plani:** Siralama degisecekse yeni ADR ile supersede edilir; gizli runtime override kabul edilmez.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - katman bazli accuracy verisinin baska siranin acik ustunluk sagladigini kanitlamasi
  - registry tier yapisinin sirayi merchant bazli ciddi farkli kurgulamayi gerektirmesi
  - latency veya maliyetin kabul edilemez hale gelmesi
- **Degerlendirme Sorumlusu:** Import architecture owner + ops owner + product owner
- **Degerlendirme Kapsami:**
  - import accuracy matrix trendleri
  - queue maliyeti ve latency
  - support issue dagilimi
  - AI misuse veya hallucination sinyalleri
