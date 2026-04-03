---
id: PROJECT-ADR-001
title: Product Boundary and Core Surface
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-001 - Product Boundary and Core Surface

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-001
- **Baslik:** Product Boundary and Core Surface
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Product boundary / scope
- **Karar alani:** Urunun recommendation publishing, commerce ve marketplace ekseninde hangi sinirda durdugunu baglar.
- **Ilgili ust belgeler:**
  - `project/00-project-charter.md`
  - `project/01-product-vision-and-thesis.md`
  - `project/02-product-scope-and-non-goals.md`
  - `project/product/23-creator-workflows.md`
- **Etkiledigi belgeler:**
  - `project/product/20-product-information-architecture.md`
  - `project/product/21-page-types-and-publication-model.md`
  - `project/product/28-subscription-and-plan-model.md`
  - `project/implementation/110-project-roadmap.md`
  - `project/compliance/92-external-link-and-merchant-content-policy.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; bu ADR teknik stack degil, urun sinirini sabitler.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Urun, checkout yapmayan recommendation publishing sistemi olarak konumlanir.
- Core surface public web storefront + shelf/content page + creator import/publish akisidir.
- Merchant checkout, siparis takibi, iade, sepet ve marketplace operasyonu kapsam disidir.
- Monetization, GMV veya order capture uzerinden degil creator utility ve publishing capability'leri uzerinden kurulur.

Bu ADR'nin ana hukmu sudur:

> `product-showcase`, creator recommendation deneyimini paketleyen ve yayinlayan bir urundur; commerce operasyonunu sahiplenen bir platform degildir.

---

# 2. Problem Tanimi

Bu sinir yazili degilse urun su uc yone kayar:

1. link-in-bio parity baskisiyla generic vitrın aracina donusur
2. checkout ve order beklentisiyle teknik, hukuki ve support kapsamı gereksiz buyur
3. import/trust kalitesi yerine commerce checklist'i backlog'u yonetmeye baslar

Sonuc:

- ilk release uygulanabilirligini kaybeder
- viewer'a verilen soz belirsizlesir
- support ve compliance riskleri patlar

---

# 3. Baglam

Arastirma belgeleri, bu urunun farkinin "magaza sahibi olmak" degil; creator'in baglamli urun secimini hizli ve guvenilir bicimde yayinlayabilmesi oldugunu gosterir. Teknik tarafta da en yuksek risk URL import, extraction, verification ve trust katmanindadir. Bu nedenle urunun degeri:

1. product discovery kalitesinde
2. creator workflow hizinda
3. public guven sinyallerinde

toplanir.

Commerce ownership eklendiginde ise su alanlar acilir:

- cart state
- payment ve refund
- order lifecycle
- tax/legal kapsam
- buyer support

Bu alanlar urunun ana teziyle ayni yonde deger uretmez.

---

# 4. Karar Kriterleri

1. Ilk ciddi versiyonun teknik ve operasyonel olarak uygulanabilir kalmasi
2. Rakiplerden net ve savunulabilir urun farki uretmesi
3. Import, disclosure ve trust kalitesini merkeze almasi
4. Store-review ve compliance riskini gereksiz buyutmamasi
5. Monetization modelini utility etrafinda kurabilmesi

---

# 5. Degerlendirilen Alternatifler

## 5.1. Full creator storefront + checkout

Artisi:

- yuzeysel olarak daha buyuk ticari alan

Eksisi:

- order, payment, refund ve buyer support zinciri gerekir
- launch takvimini asiri buyutur
- app/store ve hukuki risk alanini genisletir

## 5.2. Generic link-in-bio/storefront araci

Artisi:

- pazar daha tanidik gorunur

Eksisi:

- farklastirici import/trust avantajini yok eder
- urunu kalabalik bir kategoriye iter

## 5.3. Recommendation publishing sistemi

Artisi:

- creator workflow ve trust uzerinden net fark yaratir
- import omurgasina yatirimi anlamli kilar
- public web experience'i netlestirir

Eksisi:

- "neden checkout yok?" sorusu anlatim gerektirir

---

# 6. Secilen Karar

Secilen yon, recommendation publishing sistemi modelidir.

Bu modelde:

1. creator urunu import eder
2. veriyi dogrular
3. shelf veya content page'e baglar
4. public web uzerinden viewer'a sunar
5. viewer dis merchant'a cikar

Baglayici kurallar:

- Uygulama icinde checkout, sepet, order tracking acilmaz.
- Viewer davranisi "go to merchant" mantigiyla biter.
- Billing, creator capability kilitleme/acma icindir; viewer commerce state'i icin degil.
- Product truth, marketplace katalogu degil creator-curated recommendation graph'idir.

---

# 7. Neden Bu Karar?

Bu karar secilmistir cunku:

1. import ve trust katmani, checkout eklenmeden de yuksek deger uretir
2. scope daraltildiginda farklastirici capability'lere yatirim yogunlastirilabilir
3. hukuki, store-review ve operasyonel karmasa ciddi bicimde azalir
4. creator utility odakli monetization daha saglam kurulabilir
5. public web narrative daha temiz hale gelir

---

# 8. Reddedilen Yonler

- Checkout odakli storefront reddedildi; cunku urunu recommendation publishing omurgasindan commerce omurgasina kaydirir.
- Generic link hub reddedildi; cunku arastirma tezindeki import + trust + baglamli vitrin farkini eritır.
- Affiliate network operorlugu reddedildi; cunku ilk fazda neutral ve guven odakli recommendation deneyimini bozar.

---

# 9. Riskler

1. Rakip parity baskisi scope genisletme talebi yaratabilir.
2. Bazi creator'lar checkout veya "tek yerde satin alma" beklentisi tasiyabilir.
3. Monetization dili zayif kurulursa utility algisi eksik kalabilir.
4. External link cikis modeli policy ve safety katmanini daha kritik hale getirir.

---

# 10. Risk Azaltma Onlemleri

- Scope ve non-goal belgeleri backlog filtrelemesinde zorunlu referans olacak.
- Public ve creator copy'si "discover -> verify -> go to merchant" zincirini net anlatacak.
- Subscription ve plan modeli commerce ownership degil creator utility ekseninde kurulacak.
- External link policy ve abuse modeli launch oncesi kapatilacak.

---

# 11. Non-Goals

- checkout
- sepet
- order/kargo/iade yonetimi
- marketplace seller modeli
- buyer account ve buyer support
- affiliate network operatorlugu

---

# 12. Sonuc ve Etkiler

Bu karar asagidaki belge ve backlog alanlarini baglar:

1. IA ve page modelinde catalog-commerce dili degil recommendation dili kullanilir.
2. Architecture belgelerinde merchant checkout external boundary olarak kalir.
3. Roadmap'te import, creator loop ve trust katmani checkout capability'lerinin onune konur.
4. Compliance tarafinda asil odak disclosure, link safety ve external content policy olur.
5. Billing tarafinda plan entitlement'i creator capability ile sinirli kalir.

Bu ADR ihlal edilirse tipik belirti:

- roadmap'e cart/order task'lari girmesi
- page spec'lerde "buy now" veya benzeri on-platform commerce beklentisi belirmesi
- support belgelerinde buyer lifecycle dili ortaya cikmasi

---

# 13. Onay Kriterleri

- Tum urun belgeleri recommendation publishing siniriyla tutarli olmali.
- Hicbir page spec checkout varsaymamalidir.
- Roadmap commerce capability'lerini cekirdege almamalidir.
- Subscription ve monetization anlatimi creator utility ekseninde kalmalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Yok; karar dokuman seti ve backlog filtreleme uzerinden etki eder.
- **Tahmini Efor:** Dokumantasyon, backlog ve naming discipline duzeyi.
- **Breaking Change:** Hayir.
- **Migration Adimlari:**
  - Mevcut backlog'taki commerce benzeri onerileri ADR'ye gore etiketle
  - Checkout cagrisimi yapan copy ve taslak ekranlari temizle
  - Roadmap ve implementation belgelerinde boundary notunu acik tut
- **Rollback Plani:** Bu karar geri alinacaksa yeni bir ADR ile commerce genislemesi resmilestirilir; mevcut ADR supersede edilir.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - creator talebinin tekrarli ve veriyle kanitlanmis bicimde on-platform commerce istemesi
  - monetization modelinin utility odakli yapida yetersiz kalmasi
  - dis merchant cikisinin trust veya donusum acisindan yapisal engel yaratmasi
- **Degerlendirme Sorumlusu:** Product owner + architecture owner + compliance owner
- **Degerlendirme Kapsami:**
  - scope drift sinyalleri
  - creator talep yogunlugu
  - support/compliance maliyeti
  - import ve trust odaginin korunup korunmadigi
