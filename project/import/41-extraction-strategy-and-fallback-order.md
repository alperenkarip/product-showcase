---
id: EXTRACTION-STRATEGY-FALLBACK-ORDER-001
title: Extraction Strategy and Fallback Order
doc_type: import_policy
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - URL-IMPORT-PIPELINE-SPEC-001
  - PROJECT-ADR-003
  - RISK-REGISTER-001
blocks:
  - MERCHANT-CAPABILITY-REGISTRY
  - AI-ASSISTED-EXTRACTION-BOUNDARIES
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC
  - IMPORT-ACCURACY-TEST-MATRIX
---

# Extraction Strategy and Fallback Order

## 1. Bu belge nedir?

Bu belge, URL import pipeline'inda extraction katmanlarinin hangi sira ile calisacagini, hangi katmanin hangi alanlarda otorite sayilacagini, headless render'in ne zaman bir extraction asamasi degil sadece execution mode olarak devreye girecegini, katmanlar arasi conflict ve downgrade kurallarinin nasil isleyecegini tanimlayan resmi extraction policy belgesidir.

Bu belge su sorulara cevap verir:

- Neden merchant adapter, structured data ve heuristic parse ayni seviyede degildir?
- Fallback zinciri hangi sirayla calisir?
- Bir katman "yeterli" sonuc verdiginde alt katmanlar tamamen susar mi, yoksa validation icin yine de kullanilir mi?
- Fiyat, title, image ve merchant gibi alanlar icin en guclu kaynak hangisidir?
- AI burada kaynak motoru mu, normalization yardimcisi mi?
- Headless render neden baska bir katman degil de kontrollu fetch/execution bicimidir?

Bu belge, extraction ekibi icin algoritmik anayasa niteligindedir.

---

## 2. Bu belge neden kritiktir?

Import kalitesini bozan sey yalnizca extraction basarisizligi degildir.  
Daha tehlikeli olan, yanlis extraction katmaninin sessizce fazla otorite kazanmasidir.

Ornek:

- OG image'i urun gorseli sanmak
- title temizligini AI'ya birakip merchant bilgisini de AI ile "duzeltmek"
- structured data varken DOM heuristic sonucunu daha "guzel" diye ustune yazmak
- her domain'i headless render ile baslatip maliyeti patlatmak

Bu belge olmadan fallback sira mantigi ekip icinde dagilir, debug imkansizlasir ve support hangi katmanin bozuldugunu anlayamaz.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Extraction, daima en deterministik ve alana en yakin kaynaktan baslar; daha alt katmanlar ancak eksikligi tamamlamak, aday uretmek veya conflict tespit etmek icin devreye girer; hicbir daha zayif katman daha guclu bir kaniti sessizce override edemez.

Bu karar su sonuclari dogurur:

1. Merchant-specific adapter varsa ilk oncelik odur.
2. Structured data, generic katmanlar icinde en guclu kaynaktir.
3. OG ve sosyal metadata, title/image yardimcisidir; price veya merchant kaynagi olarak tek basina yeterli degildir.
4. HTML heuristic parse ancak ust katmanlar yetmediginde veya validation gerektiğinde agirlik kazanir.
5. AI, kaynak veri uretmez; normalization, ranking ve ambiguity isaretleme yardimcisidir.

---

## 4. On kosullar

Extraction sira karari su on kosullar tamamlanmadan calismaz:

1. URL normalization
2. safety preflight
3. merchant capability registry resolution

Bu uc adim tamamlanmadan "hangi fallback sirasini kullanalim?" sorusu sorulmaz.

---

## 5. Resmi fallback sira modeli

Baglayici sira asagidaki gibidir:

1. merchant-specific parser
2. structured data parse
3. Open Graph ve diger sosyal metadata
4. HTML heuristic parse
5. AI-assisted normalization ve ranking
6. human confirmation

Bu sira `PROJECT-ADR-003` ile baglayicidir.  
Belge degismeden sira tersine cevrilmez.

---

## 6. Katmanlarin rolu

## 6.1. Merchant-specific parser

En yuksek otoriteli katmandir.

Ne zaman kullanilir:

- registry tier `full`
- domain veya host-pattern icin resmi adapter vardir

Ne saglar:

- canonical product alanlari
- varyant farklarini daha dogru yorumlama
- image seciminde daha yuksek kalite
- merchant ve availability bilgisi icin daha yuksek guven

Kurallar:

1. Adapter sonucu, ayni alan icin daha zayif generic katmanla sessizce override edilmez.
2. Adapter sonucu ile diger katman catisiyorsa conflict log'u tutulur.
3. Adapter'in eksik biraktigi alanlar icin alt katmanlar yardimci olabilir.

## 6.2. Structured data parse

Generic extraction icinde en guvenilir katmandir.

Kaynaklar:

- JSON-LD
- Microdata
- RDFa

Kurallar:

1. `Product` veya benzeri structured schema varsa title, image, price, currency ve availability icin kuvvetli aday sayilir.
2. Structured data spam veya multiple conflicting product node iceriyorsa confidence duser.
3. Structured data, varsa OG ve yalniz DOM text'e gore daha ustundur.

## 6.3. Open Graph ve sosyal metadata

Bu katman, sosyal paylasim odakli metadata'dir.

Guclu oldugu alanlar:

- title yardimi
- hero/preview image adayi

Zayif oldugu alanlar:

- kesin merchant
- kesin product identity
- kesin price/availability

Kurallar:

1. OG image dogrudan primary product image secilmez; aday havuzuna girer.
2. OG title structured data ile ciddi catismada ise daha zayif kabul edilir.
3. Price icin OG veya meta description kullanmak yeterli kanit sayilmaz.

## 6.4. HTML heuristic parse

DOM secicileri, gorunen text pattern'leri ve bilinen layout ipuclari ile calisan generic katmandir.

Ne zaman agirlik kazanir:

- adapter yoksa
- structured data zayifsa
- OG yetersizse
- validation veya ambiguity aciklamasi gerekiyorsa

Kurallar:

1. Heuristic parse, brittle oldugu icin tek basina "net dogru" kabul edilmez.
2. Birden fazla benzer product card veya gallery varsa ambiguity yukseltilir.
3. Headless render gerekiyorsa bu katmanin calisma bicimi degisir; katmanin kendisi degismez.

## 6.5. AI-assisted normalization ve ranking

AI bu urunde extraction source degildir.

Rolleri:

- title cleanup
- image candidate ranking
- duplicate benzerligi yardimi
- tag normalization
- "review required" sinyali uretme

Sinirlari:

- price uydurmaz
- merchant icat etmez
- canonical URL belirlemez
- structured data veya adapter sonucunu gizlice degistirmez

## 6.6. Human confirmation

Final kalite kapisidir.

Ne zaman zorunludur:

- medium/low confidence varsa
- kritik alan conflict tasiyorsa
- duplicate/reuse karari net degilse
- unsupported veya `fallback-only` tier merchant ise

---

## 7. Headless render'in resmi yeri

Headless render bu sirada ayri bir semantic extraction katmani degildir.  
Bu, bazi katmanlarin veri alabilmesi icin kullanilan kontrollu execution mode'dur.

### 7.1. Ne zaman kullanilir?

- registry bu host icin gerekli diyorsa
- static fetch ile bos HTML donuyorsa
- JS ile yuklenen kritik product alanlari varsa

### 7.2. Ne zaman kullanilmaz?

- her domain icin varsayilan olarak
- maliyeti dusunmeden ilk adim olarak
- AI sonucu zayif diye "belki render yardim eder" mantigiyla rastgele

### 7.3. Neden ayri katman sayilmaz?

Cunku render, kanit turunu degistirmez; yalnizca structured data veya HTML heuristic'in daha zengin DOM gormesini saglar.

---

## 8. Alan bazli otorite matrisi

| Alan | Kabul edilen en guclu kaynak sira mantigi | Not |
| --- | --- | --- |
| Canonical URL | adapter > normalized final URL > canonical link tag | AI kaynak degildir |
| Merchant | adapter > resolved host/domain > structured metadata hint | AI ve OG merchant otoritesi degil |
| Title | adapter > structured data > OG/meta title > HTML heuristic > AI cleanup | AI sadece cleanup/ranking yapar |
| Image | adapter > structured data image > OG image > HTML gallery candidate > AI ranking | AI image icat etmez |
| Price | adapter > structured data > HTML heuristic | OG ve AI price kaynagi degildir |
| Currency | adapter > structured data > HTML heuristic | numeric deger tek basina yeterli degil |
| Availability | adapter > structured data > HTML heuristic | yoksa `unknown` |
| Tags / semantic hints | deterministic extraction > AI normalization > creator review | creator override finaldir |

Bu tablo ihlal edilirse extraction policy bozulmus sayilir.

---

## 9. Katmanlar arasi conflict kurallari

### 9.1. Kuvvetli ust katman ile zayif alt katman catismasi

Ornek:

- adapter `merchant=A`
- HTML heuristic `merchant=B`

Beklenen davranis:

- adapter kazanir
- conflict log'lanir
- gerekirse confidence dusurulur

### 9.2. Iki orta seviye katman catismasi

Ornek:

- structured data title ile OG title farkli

Beklenen davranis:

- structured data oncelik kazanir
- fark ciddi ise review warning'i yaratilir

### 9.3. Ust katman eksik, alt katman dolu

Ornek:

- structured data price yok
- HTML heuristic price benzeri deger yakaladi

Beklenen davranis:

- alt katman aday uretebilir
- confidence orta/low olarak isaretlenir
- verification UI bu belirsizligi gosterebilir

### 9.4. Katmanlar arasi "en guzel gorunen veri" secimi yasagi

Bir alt katman sonucu sadece daha estetik gorunuyor diye ustteki kanit ezilemez.

---

## 10. Stop ve continue kurallari

Fallback zinciri "her zaman tum katmanlari sonuna kadar calistir" mantigiyla islememelidir.

### 10.1. Erken yeterlilik

Su durumda alt katmanlar tamamen veya kismen atlanabilir:

- adapter kritik alanlari yuksek guvenle verdi
- registry bu merchant icin ek generic parse'in degeri dusuk

### 10.2. Validation icin devam

Su durumda daha alt katmanlar validation veya image zenginlestirme icin yine de kosabilir:

- image secimi icin ek aday lazim
- adapter sonucu ile source page metadata'si uyum kontrolu isteniyor

### 10.3. Maliyet kontrollu devam

Katmanlarin cagrilmasi:

- tier
- latency butcesi
- alan eksikligi
- bilinen domain davranisi

ile sinirlanir.

---

## 11. Field completion kurallari

Extraction, eksik alani doldurmak ile uydurma yapmak arasindaki farki korumak zorundadir.

### 11.1. Kabul edilen tamamlama

- title whitespace/brand noise temizligi
- image candidate ranking
- currency sembolunu structured context ile eslemek

### 11.2. Kabul edilmeyen tamamlama

- eksik fiyat icin tahmini deger yazmak
- merchant host ile marka adini esit sanmak
- availability yoksa "in stock" varsaymak

---

## 12. Senaryolar

## 12.1. Senaryo A: Full support merchant

Beklenen sira:

1. adapter
2. gerekirse structured data validation
3. image destek sinyali
4. verification payload

Beklenen davranis:

- AI yalnizca ranking/cleanup yardimcisi olur
- low-cost, high-confidence path korunur

## 12.2. Senaryo B: Partial support merchant

Beklenen sira:

1. structured data
2. OG
3. HTML heuristic
4. AI normalization
5. human review

Beklenen davranis:

- medium confidence dogal sayilir
- creator correction sik gorunur

## 12.3. Senaryo C: Fallback-only merchant

Beklenen sira:

1. normalize + safe fetch
2. structured/OG/HTML generic fallback
3. AI ranking gerekirse
4. manual correction agirlikli review

Beklenen davranis:

- auto-apply yolu acilmaz
- confidence yuksek gorunse bile review kapisi kalir

## 12.4. Senaryo D: Blocked merchant

Beklenen davranis:

- extraction zinciri hic baslamaz
- policy reason ile `blocked` sonucu doner

---

## 13. Failure ve edge-case senaryolari

### 13.1. Bir sayfada birden fazla product schema var

Beklenen davranis:

- tekini rastgele secme
- ambiguity isaretle
- verification review agirligini artir

### 13.2. OG image lifestyle banner, product image degil

Beklenen davranis:

- image candidate havuzuna girer ama otomatik primary secilmez
- gallery/structured data adaylariyla birlikte degerlendirilir

### 13.3. HTML'de eski fiyat var, structured data'da yeni fiyat var

Beklenen davranis:

- structured data once gelir
- eski fiyat "compare at" olduguna dair net kanit yoksa public primary fiyat yapilmaz

### 13.4. AI title cleanup markayi dusurdu

Beklenen davranis:

- AI cleanup destructive degisiklik yaptiysa original title korunur
- cleanup yalnizca onerilen form olur

### 13.5. Render gerekli ama registry bunu bilmiyor

Beklenen davranis:

- failure code ve telemetry olusur
- registry review backlog'una sinyal gider

---

## 14. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. AI'yi fallback sirasinda price/merchant kaynagi gibi kullanmak
2. OG image'i primary image diye sabitlemek
3. Headless render'i varsayilan maliyet modeli yapmak
4. Daha alt katmani "daha guzel sonuc verdi" diye ustteki kanitin ustune yazmak
5. Conflict bilgisini creator ve support'tan saklamak
6. Tum domain'lere ayni extraction davranisini uygulamak

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `42-merchant-capability-registry.md`, tier bazli adapter, headless ve confidence alanlarini bu sira mantigina gore tanimlamalidir.
2. `47-ai-assisted-extraction-boundaries.md`, AI'nin yalnizca normalization/ranking rolunde kalacagini bu belgeyle birebir uyumlu yazmalidir.
3. `44-product-verification-ui-and-manual-correction-spec.md`, conflict ve confidence state'lerini bu policy'ye gore yuzeye cikarmalidir.
4. `83-import-accuracy-test-matrix.md`, katman otoritesi ve conflict handling senaryolarini ayri test siniflari olarak ele almalidir.

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- extraction katmanlari tek tek isimlendirilebilir ve debug edilebilir ise
- her alan icin hangi kaynagin neden daha guclu oldugu net ise
- AI ve headless render dogru yerde, sinirli rolde kalabiliyorsa
- conflict durumlari sessiz overwrite yerine acik review ihtiyacina donusuyorsa

Bu belge basarisiz sayilir, eger:

- fallback sira maliyet veya sezgiye gore degisiyorsa
- zayif katmanlar guclu katmanlari sessizce eziyorsa
- support bir title/image/fiyat sonucunun hangi kaynaktan geldigini anlayamiyorsa
