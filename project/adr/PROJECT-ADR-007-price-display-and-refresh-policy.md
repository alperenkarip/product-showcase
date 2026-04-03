---
id: PROJECT-ADR-007
title: Price Display and Refresh Policy
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-007 - Price Display and Refresh Policy

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-007
- **Baslik:** Price Display and Refresh Policy
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Trust / data freshness
- **Karar alani:** Fiyatin hangi kosullarda gosterilecegini, stale davranisini ve refresh mantigini tanimlar.
- **Ilgili ust belgeler:**
  - `project/import/45-price-availability-and-refresh-policy.md`
  - `project/product/27-disclosure-trust-and-credibility-layer.md`
  - `project/data/73-cache-revalidation-and-staleness-rules.md`
- **Etkiledigi belgeler:**
  - `project/design/52-public-web-screen-spec.md`
  - `project/quality/83-import-accuracy-test-matrix.md`
  - `project/operations/101-runbooks.md`
  - `project/operations/103-support-playbooks.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; trust ve freshness kararlarini runtime davranisa baglar.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Fiyat yardimci bilgi olarak ele alinir; ana urun vaadi degildir.
- Stale veya dusuk guvenli fiyat kesinmis gibi gosterilmez.
- Creator fiyat gizleme secenegine sahiptir; ancak gizleme trust row mantigini bozmaz.
- Refresh davranisi merchant tier ve public exposure'a gore belirlenir.

Bu ADR'nin ana hukmu sudur:

> `product-showcase` fiyat gosterebilir; ama gunceklik ve kaynak guveni belirsizliginde trust'i fiyata feda etmez.

---

# 2. Problem Tanimi

Price alani yanlis veya stale oldugunda:

1. viewer guveni bozulur
2. creator yaniltici gorunur
3. support yukü artar
4. public storefront, recommendation urunu degil hatali fiyat vitrini gibi algilanir

Fiyati tamamen gizlemek de degerli yardimci sinyali yok eder.  
Bu nedenle kosullu gosterim gerekir.

---

# 3. Baglam

Bu urun fiyat karsilastirma, stok takip veya checkout urunu degildir. Fiyat:

- karar destekleyici
- ikincil
- freshness baglamina muhtac

bir bilgidir. Bu nedenle fiyat gosterimi:

- merchant tier
- source freshness
- selected source guveni
- creator hide tercihi

ile birlikte degerlendirilir.

---

# 4. Karar Kriterleri

1. Trust'i fiyat bilgisinden oncelemek
2. Refresh maliyetini tier bazli kontrol etmek
3. Creator'a esnek ama guvenli tercih sunmak
4. Support ve public copy'de durumu acik anlatmak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Her zaman fiyat gosterme

Eksiler:

- stale ve yanlis fiyat riski tasir
- trust bozar

## 5.2. Fiyat alanini tamamen kaldirma

Eksiler:

- viewer icin yardimci karar sinyalini yok eder

## 5.3. Conditional display + stale context modeli

Artisi:

- price bilgisini tamamen kaybetmez
- trust'i korur

---

# 6. Secilen Karar

Secilen model:

- fiyat yalnizca guvenli kaynak ve uygun tazelikte gosterilir
- `last_checked` veya esdeger freshness baglami tutulur
- stale esigi asilinca warning veya hide davranisi devreye girer
- creator `hide_price` karari verebilir

Baglayici kurallar:

1. Stale price, current price gibi render edilmez.
2. Fiyat source guveni dusukse publicte gosterim kapatilabilir.
3. Hidden price state'i "fiyat yok" degil, "gosterilmiyor" semantics'i tasir.
4. Selected source degismeden price truth placement bazinda uydurulmaz.

---

# 7. Neden Bu Karar?

- Price sinyalini korurken trust'i zedelemez.
- Refresh maliyetini tier bazli optimize eder.
- Creator'a fiyat gosterme uzerinde kontrollu esneklik verir.
- Support ve public copy'de acik durum yonetimi saglar.

---

# 8. Reddedilen Yonler

- "Her kosulda fiyat goster" modeli reddedildi; cunku urunun trust teziyle catisir.
- "Asla fiyat gosterme" modeli reddedildi; cunku viewer icin yardimci sinyali gereksiz yok eder.
- Price'i placement note veya creator metni icine itmek reddedildi; cunku denetlenebilirlik kaybolur.

---

# 9. Riskler

1. Hidden/stale davranisi creator tarafinda "fiyat neden kayboldu?" sorusu yaratabilir.
2. Refresh gecikmeleri beklenenden sik warning uretebilir.
3. Bazi merchant'larda fiyat alanı yapisal olarak zayif olabilir.

---

# 10. Risk Azaltma Onlemleri

- Creator UI'da stale ve hidden reason acikca gosterilir.
- Support playbook price issue family icin net copy saglar.
- Merchant tier ve refresh politikalari quality verisine gore ayarlanir.
- Public copy fiyatin kesin vaad olmadigini acikca anlatir.

---

# 11. Non-Goals

- fiyat karsilastirma motoru olmak
- real-time stock/fiyat garanti etmek
- stale price'i creator notu icine gizlemek
- merchant olmayan kaynaklardan fiyat uydurmak

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Price freshness state'i trust row ile bagli render edilir.
2. Refresh scheduler selected source ve merchant tier'e gore calisir.
3. Support ve runbook belgeleri stale vs missing ayrimini net kullanir.
4. Import accuracy matrix price alanini kosullu kabul mantigiyla olcer.

Ihlal belirtileri:

- stale price'in warning'siz gosterilmesi
- creator hide kararinin support tarafinda anlasilmamasi
- publicte "fiyat var ama ne kadar guncel bilmiyoruz" dilinin kaybolmasi

---

# 13. Onay Kriterleri

- Fiyat gosterimi freshness ve confidence baglamiyla birlikte calismalidir.
- Stale veya hidden state'ler UI ve copy'de ayri semantics tasimalidir.
- Refresh politikasi merchant tier ile tutarli olmalidir.
- Support ve public trust belgeleri ayni price dilini kullanmalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Public render, import trust state ve refresh scheduler'i etkiler.
- **Tahmini Efor:** Orta; public UI, cache ve support copy hizasi gerektirir.
- **Breaking Change:** Olası; fiyat alanini her zaman gosteren eski varsayim varsa.
- **Migration Adimlari:**
  - price state enum ve copy'sini canonical hale getir
  - stale/hide davranisini public ve creator surface'lere uygula
  - refresh scheduler ve cache invalidation politikasini hizala
- **Rollback Plani:** Bu karar ancak yeni ADR ile yumusatilir; gizli "her yerde goster" override'i kabul edilmez.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - creator davranis verisinin price visibility uzerinde farkli bir model istemesi
  - stale warning oranlarinin kalici bicimde yuksek kalmasi
  - merchant ekosisteminde price guvenilirliginin dramatik sekilde artmasi veya dusmesi
- **Degerlendirme Sorumlusu:** Product owner + import owner + trust/compliance owner
- **Degerlendirme Kapsami:**
  - stale/hidden issue trendleri
  - support ticket dagilimi
  - refresh maliyeti
  - public trust geri bildirimi
