---
id: AI-ASSISTED-EXTRACTION-BOUNDARIES-001
title: AI-Assisted Extraction Boundaries
doc_type: ai_governance
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - EXTRACTION-STRATEGY-FALLBACK-ORDER-001
  - TAG-TAXONOMY-CLASSIFICATION-MODEL-001
  - RISK-REGISTER-001
blocks:
  - GP-001
  - IMPORT-ACCURACY-TEST-MATRIX
  - RUNBOOKS
  - PROJECT-ADR-003
---

# AI-Assisted Extraction Boundaries

## 1. Bu belge nedir?

Bu belge, import pipeline'inda AI'nin hangi noktalarda devreye girebilecegini, hangi isleri yapmasina acikca izin verildigini, hangi alanlarda kesinlikle kaynak veya otorite olamayacagini, AI cagrilarinin hangi girdilerle sinirlanacagini, output formatinin nasil olacagini ve AI yardiminin creator review ile deterministic extraction katmanlarinin yerine gecmesini nasil engelleyecegimizi tanimlayan resmi AI boundary belgesidir.

Bu belge su sorulara cevap verir:

- AI burada ana extraction motoru mudur, yardimci normalization katmani midir?
- Hangi durumlarda AI cagrisi yapmak anlamlidir, hangi durumlarda gereksiz veya risklidir?
- AI hangi alanlarda asla karar veremez?
- Prompt'a hangi veri gidebilir, hangisi gitmemelidir?
- AI output'u serbest metin mi, yapisal veri mi olmalidir?
- AI failure oldugunda import neden fail olmak zorunda degildir?

Bu belge, AI kullanimini "gerekirse bakariz" seviyesinden cikarir.

---

## 2. Bu belge neden kritiktir?

Import alaninda AI'nin en tehlikeli hatasi tamamen yanlis olmak degildir.  
Daha tehlikeli olan, ikna edici ama temelsiz veri uretmesidir.

Ornek:

- merchant'i hosttan yanlis tahmin etmek
- eksik fiyat icin tahmini deger yazmak
- product olmayan sayfayi "buyuk ihtimalle product" diye etiketlemek
- creator override'ini sessizce baskilamak

Bu urun icin AI, guveni artiran yardimci olabilir.  
Ama kaynak otoritesi gibi kullanilirsa import hattini kirar.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> AI, `product-showcase` import hattinda kaynak veri ureten bir parser degil; deterministic extraction sonucunu temizleyen, adaylari siralayan, semantic normalization yapan ve ambiguity'yi isaretleyen yardimci katmandir; merchant, canonical URL, price, currency, availability ve disclosure gibi kritik alanlarda asla tek basina source of truth olamaz.

Bu karar su sonuclari dogurur:

1. AI invocation deterministic katmanlardan sonra gelir.
2. AI output'u her zaman reviewable ve explainable olmak zorundadir.
3. AI failure, import failure ile ayni sey degildir.
4. AI suggestion creator manual kararini override edemez.

---

## 4. AI'nin resmi rolu

AI su dort rol icin kullanilabilir:

1. normalization
2. ranking
3. ambiguity labeling
4. semantic hint generation

AI su roller icin kullanilmaz:

1. ground-truth extraction
2. policy bypass
3. merchant support tier tahmini
4. trust/disclosure karari

---

## 5. AI invocation on kosullari

AI cagrisi ancak su kosullar saglandiginda dusunulur:

1. URL normalization tamamlanmis olmali
2. safety preflight tamamlanmis olmali
3. merchant registry resolve edilmeli
4. deterministic katmanlar bir ilk candidate set uretmis olmali

### 5.1. AI cagrisi yapılmayacak durumlar

Asagidaki durumlarda AI invocation varsayilan olarak yasaktir:

- malformed URL
- `blocked` tier merchant
- unsupported protocol
- hicbir fetch/extraction artefact'i yoksa
- adapter zaten yuksek confidence ve dusuk ambiguity sonuc vermisse

### 5.2. AI cagrisi anlamli olan durumlar

- title candidate'lari gürultuluysa
- image candidate sayisi fazla ve ambiguity varsa
- duplicate benzerligi sinirdaysa
- tag normalization gerekiyorsa
- product-detail vs listing-page ayrimi belirsizse

---

## 6. Izin verilen AI gorevleri

### 6.1. Title normalization

Izin verilen:

- marketing gürultusunu temizleme
- gereksiz tekrar ve casing duzeltme
- urun adini daha okunur hale getirme

Izin verilmeyen:

- olmayan marka/model ekleme
- boyut, varyant veya teknik ozellik uydurma

### 6.2. Image candidate ranking

Izin verilen:

- mevcut adaylar arasinda daha olasi primary image'i siralama
- banner/promo/lifestyle riskini isaretleme

Izin verilmeyen:

- yeni image URL icat etme
- aday olmayan gorseli secmis gibi donme

### 6.3. Duplicate similarity assistance

Izin verilen:

- mevcut product adaylari ile yeni candidate arasinda semantic benzerlik puani onermek
- "review gerekir" sinyali vermek

Izin verilmeyen:

- merge kararini tek basina finalize etmek

### 6.4. Tag normalization

Izin verilen:

- canonical taxonomy icine synonym map yardimi
- use-case veya attribute hint'i uretme

Izin verilmeyen:

- taxonomy disi serbest public tag dayatmak
- trust/disclosure alanini authored tag gibi uretmek

### 6.5. Ambiguity labeling

Izin verilen:

- "bu sayfa product detail olmayabilir"
- "bu image'ler arasinda net bir primary secim yok"
- "structured ve HTML title catismasi var"

Izin verilmeyen:

- ambiguity varken bunu certainty ile kapatmak

---

## 7. Yasakli AI alanlari

AI asagidaki alanlarda asla source of truth olamaz:

1. merchant identity
2. canonical URL
3. price amount
4. currency
5. availability
6. disclosure tipi
7. creator'in urunu sahsen kullanip kullanmadigi
8. merchant support tier
9. blocked / safe domain policy karari

Bu alanlarda AI yalnizca "review gerekir" sinyali uretebilir; final degeri veremez.

---

## 8. Output kontrati

AI output'u serbest prose olarak degil, yapisal kontrat olarak donmelidir.

Asgari output alanlari:

- `task_type`
- `confidence`
- `must_review`
- `result`
- `evidence_refs`
- `warnings`

### 8.1. `result` ornekleri

- `normalized_title`
- `ranked_candidate_ids`
- `duplicate_similarity_reason`
- `tag_suggestions`

### 8.2. `evidence_refs`

AI'nin sonucunu hangi input adaylari veya snippet'lere dayadigini gosteren referanslardir.

Kural:

- "cunku model boyle dedi" kabul edilmez

---

## 9. Confidence ve review kurallari

### 9.1. Confidence seviyeleri

AI output'u asgari olarak:

- `high`
- `medium`
- `low`

seklinde etiketlenir.

### 9.2. High confidence ne anlama gelmez?

`high` confidence:

- AI'nin kaynak otoritesi oldugu anlamina gelmez
- creator review'unu otomatik ortadan kaldirmaz

### 9.3. Must-review kosullari

Asagidaki durumda `must_review=true` zorunludur:

- conflicting title candidate'lari varsa
- ranked image adaylari birbirine yakin ise
- duplicate karari kesin degilse
- taxonomy suggestion low/medium confidence ise

---

## 10. Prompt ve veri minimizasyonu

AI'ya yalniz gerekli veri gider.

### 10.1. Gonderebileceklerimiz

- sanitize edilmis title adaylari
- candidate image metadata'si
- structured field ozetleri
- kısa text snippet'leri
- candidate product summary'leri

### 10.2. Gonderemeyeceklerimiz

- auth cookie
- session token
- secret
- gereksiz full page dump
- kullaniciya ait ilgisiz PII

### 10.3. Data minimization ilkesi

Her task icin minimum bilgi kullanilir.

Ornek:

- title cleanup icin full HTML gondermek gerekmez
- image ranking icin billing verisi gonderilmez

---

## 11. Model secim ve maliyet kurali

AI invocation maliyeti kontrollu olmali; "AI cagir, belki yardim eder" davranisi kabul edilmez.

### 11.1. Düşük maliyetli task'lar

- title cleanup
- tag normalization

### 11.2. Daha dikkatli task'lar

- image ranking
- duplicate similarity yorumlama

### 11.3. Cagrinin atlanacagi durumlar

Eger deterministic sonuclar yeterince iyiyse:

- AI invocation atlanir
- maliyet ve latency korunur

---

## 12. Creator override ve AI iliskisi

Creator manual karar zincirde en usttedir.

Kurallar:

1. Creator title duzelttiyse AI bunu sonraki refresh'te sessizce geri cevirmez.
2. Creator image secimi yaptiysa AI ranking'i historical suggestion olarak kalir.
3. Creator tag suppress ettiyse AI ayni tag'i kesin dogru gibi geri basmaz.

---

## 13. AI failure davranisi

AI su sebeplerle sonuc veremeyebilir:

- timeout
- schema parse failure
- low-quality input
- provider error

Beklenen davranis:

1. import hattı deterministic/manual review ile devam eder
2. AI failure ayrik failure code olarak loglanir
3. creator akisi bloklanmaz

Kural:

AI yoksa import olamaz modeli launch icin yasaktir.

---

## 14. Senaryolar

## 14.1. Senaryo A: Gürultulu title cleanup

Deterministic title:

- fazla promo kelime ve tekrar iceriyor

Beklenen davranis:

- AI okunur normalized title onerir
- original title kaybolmaz
- creator review edebilir

## 14.2. Senaryo B: Image ambiguity

Birden fazla candidate yuksek kalite.

Beklenen davranis:

- AI ranking yardim eder
- creator final secimi yapar

## 14.3. Senaryo C: Duplicate similarity siniri

Canonical URL ayni degil ama title/image benzer.

Beklenen davranis:

- AI benzerlik reason'i verebilir
- merge veya reuse karari creator/sistem kuralina kalir

## 14.4. Senaryo D: Price eksik

Beklenen davranis:

- AI price tahmini yapmaz
- field bos veya unavailable kalir

---

## 15. Failure ve edge-case senaryolari

### 15.1. AI structured data ile catisti

Beklenen davranis:

- structured data daha ustundur
- AI sonucu review note olarak kalir

### 15.2. AI unsupported page'i product gibi yorumladi

Beklenen davranis:

- deterministic page classifier ve verification bunu durdurur
- AI tek basina apply nedeni olamaz

### 15.3. AI tag onerileri cop oldu

Beklenen davranis:

- family limitleri uygulanir
- publice otomatik cikmaz
- creator review gerektirir

### 15.4. AI timeout

Beklenen davranis:

- import fail sayilmaz
- fallback path calisir

---

## 16. Observability ve audit beklentileri

Her AI invocation icin asgari olarak:

- task type
- model family
- invocation nedeni
- sanitized input sinifi
- latency
- token/maliyet sinifi
- output confidence
- must_review sonucu
- final human override olup olmadigi

tutulmalidir.

Bu alanlar olmadan AI yardiminin degerini veya riskini olcemeyiz.

---

## 17. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. AI ile merchant, price veya availability uydurmak
2. Deterministic parser yerine AI-first import yapmak
3. AI output'unu serbest prose olarak alip direkt uygulamak
4. Creator override'ini AI ile sessizce geri almak
5. AI failure'i import failure ile ayni saymak
6. Prompt'a gereksiz raw page dump veya secret gondermek

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `GP-001-url-import-and-extraction.md`, AI'nin yasakli alanlarini ve invocation kontrol listesini bu belgeyle birebir uyumlu hale getirmelidir.
2. `83-import-accuracy-test-matrix.md`, AI-assisted title cleanup, image ranking, duplicate assist ve failure fallback vakalarini ayri test etmeliidir.
3. `101-runbooks.md`, AI timeout, output degradation ve high hallucination-suspicion vakalari icin ayri operasyonel yol tanimlamalidir.
4. `44-product-verification-ui-and-manual-correction-spec.md`, AI kaynakli `must_review` alanlarini UI'da gorunur kilmalidir.

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- AI import kalitesini artirirken ground-truth parser rolune cikmiyorsa
- kritik alanlarda hallucination veya silent override riski sistematik olarak bastiriliyorsa
- AI failure durumunda creator akisi devam edebiliyorsa
- creator manual karar zincirin en ustunde kalmaya devam ediyorsa

Bu belge basarisiz sayilir, eger:

- AI fiyat, merchant veya disclosure alanlarinda fiili otoriteye donusuyorsa
- deterministic kalite sorunu yerine AI ile "sihirli" kapatma aliskanligi olusuyorsa
- AI invocation nedeni, girdisi ve etkisi gozlenemiyorsa
