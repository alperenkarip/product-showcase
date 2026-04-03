---
id: TAG-TAXONOMY-CLASSIFICATION-MODEL-001
title: Tag Taxonomy and Classification Model
doc_type: domain_taxonomy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - SEARCH-FILTER-TAGGING-RULES-001
  - DOMAIN-MODEL-001
  - DOMAIN-GLOSSARY-001
blocks:
  - DATABASE-SCHEMA-SPEC
  - AI-ASSISTED-EXTRACTION-BOUNDARIES
  - CREATOR-WEB-SCREEN-SPEC
  - PUBLIC-WEB-SCREEN-SPEC
---

# Tag Taxonomy and Classification Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde tag sisteminin hangi semantic amaca hizmet ettigini, hangi tag ailelerinin resmi olarak var oldugunu, bu tag'lerin hangi entity seviyesinde atanabilecegini, tag kaynagi ve otorite sirasinin ne oldugunu, tag lifecycle'inin nasil yonetilecegini ve classification davranisinin ne zaman deterministic ne zaman AI-assisted ne zaman creator-controlled kalacagini tanimlayan resmi taxonomy belgesidir.

Bu belge su sorulara cevap verir:

- Tag tam olarak hangi probleme cozum uretir?
- Hangi tag aileleri vardir ve bunlar birbirinden nasil ayrilir?
- Product, placement ve page seviyesi tag'ler nasil farklilasir?
- Creator manuel duzeltmesi ile extraction / AI sonucu catistiginda kimin sozu gecer?
- Hangi tag publicte gorunebilir, hangisi yalnizca internal metadata olarak kalir?
- Taxonomy kaosu yaratmadan esneklik nasil saglanir?

Bu belge, sadece "ornek tag listesi" degildir.  
Bu belge, urunun semantic duzenini ve discoverability kalitesini koruyan domain policy'dir.

---

## 2. Bu belge neden kritiktir?

`product-showcase` category-tree tabanli bir marketplace degildir.  
Bu nedenle tag sistemi, urunun discoverability katmaninda gercekten onemli bir role sahiptir.

Ama tehlike de tam burada baslar:

> Tag sistemi, cok kolay bicimde urunun bilgi mimarisinin yerine gecmeye calisabilir.

Bu hata yapildiginda:

- creator-context-first IA bozulur
- public root generic browse deneyimine kayar
- her import sonucu kontrolsuz kelime coplugune donusur
- ayni urun farkli kelimelerle daginik hale gelir
- support ve analytics ayni kavrami farkli adlarla gormeye baslar

Bu nedenle tag modeli serbest metin rahatligi degil, kontrollu semantic altyapi olarak ele alinmalidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Tag'ler, `product-showcase` urununde bilgi mimarisinin omurgasi degil; kontrollu ailelere ayrilmis, otorite sirasi net, product ve context seviyesinde ayri davranan yardimci semantic metadata katmanidir.

Bu karar su sonuclari dogurur:

1. Tag sistemi, page type veya shelf bilgisinin yerine gecemez.
2. Her tag ayni seviyede degildir; aile, scope ve kaynak bilgisi zorunludur.
3. Creator manuel siniflandirmasi her zaman extraction ve AI sonucunun ustundedir.
4. Trust ve disclosure state'i "normal tag" gibi serbestce olusturulmaz; gerekiyorsa derived signal olarak expose edilir.
5. Public gorunen tag seti ile internal classification seti ayni olmak zorunda degildir.

---

## 4. Taxonomy tasarim ilkeleri

### 4.1. IA once gelir, tag sonra gelir

Entry point sirasiyla:

1. creator
2. storefront
3. shelf veya content page
4. product placement
5. gerekiyorsa search / filter / tag layer

Tag'ler bu akisi destekler.  
Bu akisin yerine gecemez.

### 4.2. Tag ailesi bilinmeden tag anlami kurulmaz

`travel` etiketi ile `tripod` etiketi ayni tur veri degildir.

- `tripod` bir `product_type`
- `travel` bir `use_case`

Bu ayrim veri modelinde zorunludur.  
Tek bir serbest `tags[]` dizisi yeterli kabul edilmez.

### 4.3. Scope bilinmeden tag davranisi kurulmaz

Ayni kelime farkli scope'larda farkli davranabilir.

Ornek:

- `gym-routine` bir content-context tag olabilir
- `beginner` product-level attribute olarak da kullanilabilir

Bu nedenle atamanin hangi entity'de yapildigi zorunlu metadata'dir.

### 4.4. Otorite ve kaynak kaydi tutulur

Her tag assignment icin asgari olarak su bilgiler saklanir:

- canonical tag id veya slug
- family
- assignment scope
- assignment source
- confidence
- visibility
- actor ve timestamp

Kaynagi bilinmeyen tag, desteklenmis tag sayilmaz.

### 4.5. Taxonomy kontrollu buyur

Launch fazinda "herkes istedigi etiketi yazsin" yaklasimi kabul edilmez.

Esneklik gerekir.  
Ama esneklik kontrolsuz vocabulary patlamasina donusmemelidir.

---

## 5. Temel kavramlar

### 5.1. Tag definition

Canonical vocabulary icindeki resmi tag kaydidir.

Asgari alanlar:

- `slug`
- `display_label`
- `family`
- `status`
- `public_visibility`
- `aliases`
- `deprecated_replacement`

### 5.2. Tag assignment

Belirli bir entity'ye atanmis somut tag kaydidir.

Asgari alanlar:

- `target_type`
- `target_id`
- `tag_slug`
- `assignment_source`
- `confidence`
- `state`

### 5.3. Tag alias

Ayni anlami ifade eden ama canonical olmayan alternatif kelimedir.

Ornek:

- `protein-powder` -> canonical
- `whey-protein` -> alias olabilir, ama baglama gore ayri canonical term de olabilir

Alias karari gelisiguzel verilmez.  
Yanlis alias, iki farkli urunu ayni kavram altinda toplar.

### 5.4. Derived signal

Esas kaynagi baska bir domain state olan ve filter/tag-benzeri gorunen sinyaldir.

Ornek:

- `affiliate`
- `gifted`
- `price-hidden`
- `stale-source`

Bunlar public filter davranisina katilabilir.  
Ama normal creator-authored serbest tag gibi modellenmez.

### 5.5. Visibility

Tag assignment'in hangi yuzeyde kullanilabilecegini belirtir:

- `public`
- `creator_only`
- `internal_only`

---

## 6. Resmi tag aileleri

Launch kapsami icinde resmi olarak desteklenen aileler asagidadir.

| Family | Amac | Tipik scope | Publicte gorunurluk | Coklu atama |
| --- | --- | --- | --- | --- |
| `product_type` | Urunun ne oldugunu anlatir | Product | Evet | Sinirli coklu |
| `use_case` | Hangi durumda kullanildigini anlatir | Product ve Placement | Evet | Evet |
| `content_context` | Urunun hangi icerik baglaminda gorundugunu anlatir | Content Page ve Placement | Evet | Evet |
| `attribute` | Urunun veya onerinin niteligini anlatir | Product | Evet, secili | Evet |
| `merchant_context` | Merchant veya procurement baglamini anlatir | Product Source ve Product-derived | Creator/internal agirlikli | Sinirli |
| `trust_signal` | Trust/disclosure state'ini derived sekilde ifade eder | Derived | Evet, derived | Sistem kontrollu |

### 6.1. `product_type`

Bu aile, urunun fiziksel veya islevsel tipini anlatir.

Ornekler:

- `tripod`
- `serum`
- `running-shoe`
- `protein-powder`
- `desk-lamp`

Kurallar:

1. Her product icin en az bir `product_type` tag'i hedeflenir.
2. Bir product birden fazla `product_type` tasiyabilir; ancak bu durum gercek semantic gerekce gerektirir.
3. `product_type`, use-case veya attribute terimleriyle karistirilmaz.

Kabul edilebilir coklu ornek:

- `microphone` + `audio-interface-bundle` ayni product icin uygun olmayabilir
- `protein-powder` + `supplement` birlikte olabilir, ama biri ust family biri alt family ise gorelendiği net olmalidir

### 6.2. `use_case`

Bu aile, urunun hangi ihtiyac veya kullanim baglaminda onerildigini anlatir.

Ornekler:

- `travel`
- `recovery`
- `daily-routine`
- `workout`
- `desk-setup`

Kurallar:

1. `use_case`, urunun ne oldugu degil, ne icin onerildigi bilgisidir.
2. `use_case` hem product seviyesinde genel baglam, hem de placement seviyesinde page-bagli baglam tasiyabilir.
3. Use-case multiplicity kabul edilir; ama ilk 3-5 anlamli tag disinda publicte yuzey kirletilmez.

### 6.3. `content_context`

Bu aile, urunun belirli bir icerik veya yayin baglamindaki rolunu anlatir.

Ornekler:

- `video-used`
- `morning-routine`
- `whats-in-my-bag`
- `before-after`
- `studio-tour`

Kurallar:

1. `content_context`, ozellikle `Content Page` primitive'i ile baglantilidir.
2. Bu aile product'in kalici identity'si gibi davranmamalidir.
3. Ayni product farkli content page'lerde farkli `content_context` tasiyabilir.

### 6.4. `attribute`

Bu aile, product veya recommendation'in niteliksel ozelligini anlatir.

Ornekler:

- `budget`
- `premium`
- `beginner-friendly`
- `lightweight`
- `sensitive-skin`

Kurallar:

1. Attribute tag'leri iddia niteliginde olabilir; bu nedenle ozellikle creator veya deterministic kaynaga dayanmalidir.
2. Hassas, iddiali veya regule terimler kontrolsuz eklenemez.
3. `best`, `number-one`, `guaranteed`, `medical-grade` gibi marketing/claim agirligi yuksek terimler launch taxonomy'sine alinmaz.

### 6.5. `merchant_context`

Bu aile, procurement veya merchant tipi baglamini anlatir.

Ornekler:

- `official-store`
- `marketplace-listing`
- `regional-merchant`
- `brand-direct`

Kurallar:

1. Bu aile publicte her zaman chip olarak gorunmek zorunda degildir.
2. Cogu durumda creator-side filter ve internal quality icin daha degerlidir.
3. Merchant capability ve support tier ile karistirilmaz.

### 6.6. `trust_signal`

Bu aile serbest authored family degildir.  
Esas kaynagi baska bir domain durumudur.

Ornekler:

- `affiliate`
- `gifted`
- `price-hidden`
- `stale-source`
- `verified-by-creator`

Kurallar:

1. `trust_signal` assignment'lari sistem veya policy tarafindan uretilir.
2. Creator bu sinyalleri serbest metinle olusturamaz.
3. Asil source of truth disclosure, verification veya freshness state'idir; tag sadece UI/facet yansimasidir.

---

## 7. Scope modeli

Tag davranisinin dogru calismasi icin hangi entity seviyesinde yasadigi net olmak zorundadir.

### 7.1. Product-level tags

Asagidaki aileler varsayilan olarak product-level'dir:

- `product_type`
- `attribute`
- kalici `use_case`

Bu tag'ler, product library reuse davranisinda anlamlidir.

### 7.2. Placement-level tags

Placement-level tagging yalnizca baglama ozel semantic fark varsa kullanilir.

Ornek:

- ayni su matarasi `travel` shelf'inde `lightweight`
- ama `gym-recovery` content page'inde `recovery`

Kural:

Placement-level tag, product-level tag'i sessizce override etmez.  
Baglama ek semantic katman ekler.

### 7.3. Content Page-level tags

`content_context` aileli tag'ler agirlikla page seviyesinde veya page-derived placement seviyesinde tasinir.

Ornek:

- `night-routine`
- `packing-video`
- `camera-bag-breakdown`

Bu tag'ler, publicte "bu icerikte ne kullanildi" baglamini kuvvetlendirir.

### 7.4. Source-level tags

`merchant_context` ve bazi derived trust sinyalleri source seviyesinde olusabilir.

Ama publicte cogu zaman product aggregate veya selected source uzerinden gosterilir.  
Tum source tag'lerini oldugu gibi publice yaymak zorunlu degildir.

---

## 8. Otorite sirasi ve assignment source modeli

Tag assignment otoritesi asagidaki sira ile yorumlanir:

1. creator manual assignment
2. deterministic extraction / normalization
3. AI-assisted suggestion
4. system-derived signals

Bu siralama her ailede ayni anlama gelmez.  
Ozellikle `trust_signal` icin system-derived state yuksek otoritedir; cunku asil kaynak disclosure veya freshness modelidir.

### 8.1. `creator_manual`

Creator'in bizzat sectigi, ekledigi, kaldirdigi veya dogruladigi assignment.

Kurallar:

1. Creator manuel override, ayni family/scope icin extraction sonucunu ezer.
2. Creator'in kaldirdigi tag, re-import sonrasi otomatik geri gelmez; ancak suggestion olarak tekrar sunulabilir.
3. Creator manual action auditlenir.

### 8.2. `deterministic_extraction`

Merchant title, structured metadata, known dictionaries veya normalization kurallariyla cikarilan tag'lerdir.

Kurallar:

1. Yuksek guvenli ama yine de duzeltilebilir kabul edilir.
2. Deterministic sistem, unsupported terimi canonical family'ye zorla sokmaz.
3. Structured metadata varsa oncelik oradadir; rastgele title keyword eslesmesi tek basina yeterli degildir.

### 8.3. `ai_suggestion`

Model yardimli semantic tamamlama ve synonym eslestirmesidir.

Kurallar:

1. AI sonucu asla tek basina yuksek riskli claim veya trust state yaratmaz.
2. AI assignment'i otomatik publice cikacaksa yuksek confidence ve aile uygunlugu gerekir.
3. AI `creator_manual` kaydini overwrite edemez.

### 8.4. `system_derived`

Disclosure, verification, staleness, archive gibi baska state'lerden uretilen tag-benzeri sinyallerdir.

Kurallar:

1. Bunlar canonical taxonomy ile ayni serbest vocabulary havuzunda yasamaz.
2. Derived signal'larin expiration ve guncellenme kurali asil state tarafindan yonetilir.

---

## 9. Confidence ve assignment state modeli

Her assignment yalnizca "var/yok" biciminde tutulmaz.  
Asgari state semantigi gerekir.

### 9.1. Onerilen assignment state'leri

- `suggested`
- `confirmed`
- `suppressed`
- `deprecated`

### 9.2. Beklenen davranis

- `suggested`: creator review bekliyor olabilir
- `confirmed`: creator veya policy tarafindan kabul edilmistir
- `suppressed`: bilincli olarak bastirilmis ve tekrar sessizce publice gelmemelidir
- `deprecated`: vocabulary tarafinda eskiyen ama historical referans icin tutulan assignment

### 9.3. Confidence seviyesi

Asgari confidence siniflari:

- `high`
- `medium`
- `low`

Kurallar:

1. `low` confidence AI sonucu creator-side suggestion olarak kalir.
2. `medium` confidence deterministic veya AI sonucu publicte default facet olamaz; review veya corroboration gerekir.
3. `high` confidence deterministic sonuc yine de creator override'ina tabidir.

---

## 10. Controlled vocabulary ve governance modeli

### 10.1. Canonical slug zorunlulugu

Her resmi tag canonical slug ile tanimlanir.

Neden:

- URL-safe referans
- translation bagimsizligi
- duplicate terim engelleme

### 10.2. Display label locale'den ayridir

Canonical slug:

- `beginner-friendly`

Display label:

- `Beginner friendly`
- locale bazli ceviri ile gorunebilir

Slug locale ile degismez.

### 10.3. Alias kullanimi

Alias'lar yalnizca su isler icin vardir:

- import normalization
- search synonym match
- creator arama kolayligi

Alias, canonical taxonomy'yi bypass eden ikinci vocabulary sistemi haline gelmemelidir.

### 10.4. Deprecated tag politikasi

Bir tag gereksiz, hatali veya fazla spesifik oldugunda:

1. `deprecated` olarak isaretlenir
2. gerekiyorsa replacement canonical slug tanimlanir
3. yeni assignment engellenir
4. eski assignment'lar migration veya read-time mapping ile yonetilir

### 10.5. Creator-scoped custom term politikasi

Launch'ta tam serbest global custom tag acilmaz.  
Ama esneklik ihtiyaci nedeniyle sinirli custom term davranisi gerekir.

Kurallar:

1. Creator, `use_case` ve `attribute` ailelerinde custom term onerisi girebilir.
2. Bu terim ilk asamada `creator_only` ve `pending_normalization` olarak tutulur.
3. `product_type` ailesinde serbest custom term default olarak kapali olur.
4. `trust_signal` ailesinde custom term tamamen yasaktir.
5. Publice acilacak custom term once normalization veya explicit approval akisindan gecmelidir.

Bu karar taxonomy coplugunu engellerken creator ihtiyacini tamamen reddetmez.

---

## 11. Search, filter ve ranking ile iliski

### 11.1. Search index davranisi

Tag'ler search index'ine yardimci sinyal olarak girebilir.

Ama kurallar:

1. Search ranking yalnizca tag overlap ile calismaz.
2. Page context, title, creator note ve structured product fields daha yuksek oncelik tasir.
3. Deprecated tag'ler aktif ranking sinyali uretmez.

### 11.2. Public filter davranisi

Public filter'da sadece yuksek sinyal, dusuk karmasa uretecek aileler cikabilir:

- `product_type`
- `use_case`
- secili `attribute`
- derived `trust_signal`

`merchant_context` publicte default facet olmak zorunda degildir.

### 11.3. Creator-side filter davranisi

Creator tarafinda daha derin filter kabul edilir:

- merchant-related context
- hidden/suppressed tags
- suggested classification review
- deprecated term impact

### 11.4. Facet patlamasi yasagi

Tek bir listede onlarca facet, urunun basit curation akisini bozuyorsa:

- facetler gruplanir
- dusuk frekansli facetler gizlenir
- derived veya internal-only tag'ler publicten cekilir

---

## 12. Akislar

## 12.1. Akis A: Import sirasinda classification

Normal akis:

1. URL import edilir.
2. Deterministic extraction yapilir.
3. Structured metadata ve merchant dictionary sinyalleri okunur.
4. Canonical taxonomy adaylari uretilir.
5. Gerekiyorsa AI-assisted normalization ikinci katman olarak devreye girer.
6. Yuksek guvenli tag'ler `suggested` veya politika uygunsa `confirmed` olur.
7. Creator verification ekraninda tag'leri gorur ve duzeltir.

Beklenen sistem davranisi:

- source'u belirsiz terimleri zorla canonical aileye map etmemek
- confidence dusukse bunu creator'dan saklamamak
- unsupported domain icin classification uydurmamak

### 12.2. Akis B: Creator manuel duzeltme

Normal akis:

1. Creator tag listesine girer.
2. Hangi tag'in sistem onerdigi, hangisinin manuel oldugu gorulur.
3. Creator ekleme, silme veya family duzeltmesi yapar.
4. Sistem override kaydini olusturur.
5. Sonraki refresh veya re-import ayni family icin bu override'i korur.

Beklenen sistem davranisi:

- manuelliği gizlememek
- kaldirilan tag'i re-import ile sessizce geri getirmemek
- family degisikligini gecersiz form olarak bloklamak

### 12.3. Akis C: Public filter kullanimi

Normal akis:

1. Viewer content page veya shelf acilir.
2. Uygun facet'ler gosterilir.
3. Viewer `tripod` veya `travel` gibi facet secer.
4. Liste bu semantic sinyale gore daralir.

Beklenen sistem davranisi:

- publicte creator-only veya internal-only tag gostermemek
- derived trust signal'i normal tag gibi yaniltici sunmamak
- bos sonuc veriyorsa temiz cikis yolu sunmak

### 12.4. Akis D: Taxonomy bakimi ve deprecation

Normal akis:

1. Product veya ops ekip bir termi fazla gürultulu bulur.
2. Canonical replacement belirlenir.
3. Term `deprecated` olur.
4. Yeni assignment engellenir.
5. Eski assignment'lar migration planina gore tasinir veya read-time map edilir.

Beklenen sistem davranisi:

- public deneyimde ani semantic kirilma yaratmamak
- creator'in daha once kullandigi terimi aciklamasiz yok etmemek

---

## 13. Edge-case ve failure senaryolari

### 13.1. Ayni kelime farkli ailelere girebiliyor

Ornek:

- `travel` hem general use-case, hem belirli bir content series etiketi gibi davranabilir

Beklenen davranis:

- tek `travel` string'ini bağlamsiz kullanmak yerine family ve scope ile ayirmak

### 13.2. Merchant title spam dolu

Ornek:

- `BEST AMAZING PRO TRIPOD 2026 OFFICIAL SALE`

Beklenen davranis:

- title keyword'lerinden kontrolsuz attribute cikarmamak
- `best`, `official sale`, `amazing` gibi marketing kelimelerini ignore etmek

### 13.3. AI cok fazla tag oneriyor

Beklenen davranis:

- aile basina ust sinir uygulamak
- dusuk confidence tag'leri hidden suggestion olarak tutmak
- publice otomatik facet olarak cikarmamak

### 13.4. Creator ile sistem assignment'i catismali

Beklenen davranis:

- creator override kazanir
- ama audit ve explainability korunur
- gerekirse system suggestion "dismissed" olarak kaydedilir

### 13.5. Source degisince classification kayiyor

Product baska merchant source'a baglandiginda:

- source-level merchant_context degisebilir
- ama product-level manual classification sifirlanmaz

### 13.6. Archived product

Product archived oldugunda:

- tag assignment'lari historical olarak korunur
- public facet'te aktif listeleme sinyali uretmesi durdurulabilir
- creator-side recovery ve analytics icin metadata kaybolmaz

### 13.7. Hassas claim terimleri

`anti-acne`, `medical`, `fat-burning`, `doctor-approved` gibi iddia agirligi yuksek tag'ler launch taxonomy'sine default olarak alinmaz.

Beklenen davranis:

- bu terimler attribute veya marketing copy gibi serbest kullanilmaz
- gerekiyorsa compliance review gerektirir

---

## 14. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Her seyi tek `tags[]` alanina koymak
2. Category tree'yi gizlice tag sistemiyle geri getirmek
3. Creator override'ini extraction veya AI ile sessizce ezmek
4. Disclosure ve trust state'ini serbest custom tag gibi modellemek
5. Publicte internal-only classification'i gostermek
6. Deprecated term'leri yillarca sessizce aktif kullanmak
7. Placement baglamini product identity'si gibi kalicilastirmak
8. Tag sayisini kalite yerine bollukla olcmek

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `47-ai-assisted-extraction-boundaries.md`, tag uretimini bu aile ve otorite modeline gore sinirlamalidir.
2. `71-database-schema-spec.md`, canonical tag definition ile assignment kaydini ayri modellemelidir.
3. `52-public-web-screen-spec.md`, publicte yalnizca uygun visibility ve ailelere ait facet'leri gostermelidir.
4. `53-creator-web-screen-spec.md`, creator'e suggestion, confirmed ve suppressed ayrimini gosterebilmelidir.
5. `83-import-accuracy-test-matrix.md`, family dogrulugu, override korunumu ve deprecation migration testlerini icermelidir.

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- tag sistemi IA'yi yutmadan discoverability'i guclendiriyorsa
- aile, scope ve kaynak bilgisi olmadan hicbir assignment "tam" sayilmiyorsa
- creator manuel override'i kalici ve auditli sekilde korunuyorsa
- publicte gosterilen semantic katman ile internal classification katmani net ayrisiyorsa
- taxonomy, her import dalgasinda coplugune donusmeden buyuyebiliyorsa

Bu belge basarisiz sayilir, eger:

- urun kategori-first browse'a kayarsa
- ayni kavram farkli ailelerde rastgele dolasiyorsa
- creator kaldirdigi tag'leri tekrar tekrar geri goruyorsa
- AI/public classification sistemi gereksiz guven iddialari uretirse

