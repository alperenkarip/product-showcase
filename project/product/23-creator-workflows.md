---
id: CREATOR-WORKFLOWS-001
title: Creator Workflows
doc_type: workflow_spec
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - PAGE-TYPES-PUBLICATION-MODEL-001
  - DOMAIN-GLOSSARY-001
blocks:
  - CREATOR-MOBILE-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - PRODUCT-VERIFICATION-UI-MANUAL-CORRECTION-SPEC
  - PRODUCT-LIBRARY-REUSE-MODEL
---

# Creator Workflows

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde creator owner ve editor actor'lerinin temel is akislarini, bu akislardaki state geçişlerini, alternatif yolları, bozulma durumlarını, yetki farklarını, mobil ve web ayrımını ve urunun creator tarafında retention ureten davranışı nasil koruyacagini tanimlayan resmi workflow spesifikasyonudur.

Bu belge su sorulara cevap verir:

- Creator urune nasil girer?
- Ilk publish akisi nasil olmalidir?
- URL-first import akisi creator icin tam olarak nasil görünür?
- Reuse davranisi nerede devreye girer?
- Content page ve shelf akislari birbirinden nasil ayrilir?
- Remove, archive, delete ve unpublish creator tarafinda nasil davranir?
- Editor ile owner arasindaki fark workflow'a nasil yansır?

Bu belge olmadan creator experience ekran bazli ve kopuk kalir.  
Asil retention driver'i olan tekrarli publish hizi tanimsiz kalir.

---

## 2. Bu belge neden kritiktir?

Bu urunde creator retention'in ana belirleyicisi onboarding degil, tekrarli urun ekleme ve yayinlama maliyetidir.

Eger creator workflow'lari:

- uzun forma dayanirsa
- verification karisik olursa
- reuse yerine duplicate üretirse
- unsupported merchant'ta cikissiz kalırsa
- remove/archive etkisini belirsiz birakırsa

creator urunu bir kez kurar ama düzenli kullanmaz.

Bu nedenle creator workflow belgesi, UX ozeti degil; urunun davranissal cekirdeğidir.

---

## 3. Workflow tasariminin ana kararlari

Bu belge için ana kararlar sunlardir:

1. Paste/share URL birincil giris yoludur
2. Long-form manual entry fallback'tir
3. Verification quality gate'tir, dekoratif ara ekran degildir
4. Reuse varsayilan davranistir
5. Mobil ve web farkli güç noktalarına sahiptir
6. Remove / archive / delete davranislari creator'e etki alaniyla birlikte gösterilmelidir

---

## 4. Workflow ilke seti

### 4.1. Hız ilkesi

Tek bir urun ekleme akisi:

- mümkün olan en az zihinsel yükle
- mümkün olan en az ekran geçisiyle
- mümkün olan en az tekrarli veri girişiyle

ilerlemelidir.

### 4.2. Correction over reinvention ilkesi

Import sonucunda problem varsa creator'e "bastan olustur" yerine:

- verify et
- duzelt
- fallback sec

yollari verilmelidir.

### 4.3. Reuse over duplication ilkesi

Sistem ayni product'i yeniden olusturmaya değil, mevcut product'i yeniden kullanmaya yönlendirmelidir.

### 4.4. Safe publishing ilkesi

Creator "publish ettim ama ne oldu?" sorusunu sormamalidir.

### 4.5. Progressive depth ilkesi

Mobil hizli akisi tasir.  
Web daha derin edit ve curation tasir.  
Ikisi ayni ekranları kopyalamak zorunda degildir.

---

## 5. Actor farklari

### 5.1. Owner

Owner şu aksiyonlari yapabilir:

- tüm import ve verification akislari
- page publish / unpublish
- template secimi
- domain / billing / ownership
- archive / restore / delete kararları

### 5.2. Editor

Editor şu aksiyonlari yapabilir:

- product ekleme
- verification'a yardim
- shelf / content page hazırlama
- placement düzenleme
- draft oluşturma

Editor şu aksiyonlari yapamaz:

- billing değişikliği
- ownership transfer
- domain baglama
- account delete

Workflow'lar bu role farkini UI seviyesinde tasimak zorundadir.

---

## 6. Ana workflow ailesi

Bu belgede creator workflow'lari sekiz ana aileye ayrilir:

1. İlk kurulum
2. Hızlı urun ekleme
3. Verification ve correction
4. Library reuse
5. Shelf yönetimi
6. Content page yönetimi
7. Publish / unpublish / archive
8. Maintenance ve recovery

---

## 7. Workflow 1: İlk kurulum

### 7.1. Amaç

Creator'in urunu "kurmus olmak icin" degil, ilk publish'e ulasmak icin setup yapmasi.

### 7.2. Normal akis

1. Sign up / sign in
2. Handle secimi
3. Temel creator identity alanlari
4. Ilk storefront preset / başlangıç görünümü
5. Ilk shelf veya content page açma
6. Ilk URL import
7. Ilk publish veya draft

### 7.3. Neden bu sıra?

Çünkü creator'in urunle ilk deger anı:

- "tema seçtim"

değil,

- "ilk urunümü yayina aldım"

anidir.

### 7.4. Alternatif akislar

- creator ilk shelf yerine ilk content page acmak ister
- creator import sonrasi draft'ta kalmak ister
- creator ilk urunu sonra eklemek ister ama storefront setup'i tamamlamak ister

### 7.5. Bozulma durumlari

- handle çakışması
- auth callback failure
- onboarding yarida birakma
- ilk import unsupported merchant

### 7.6. Beklenen sistem davranisi

1. handle çatışmasında alternatif önerilir
2. auth başarısızlığında ilerleme kaybı minimuma iner
3. creator setup'i bitirmeden ayrılsa bile geri döndüğünde kaldığı yerden devam eder
4. ilk import bozulsa bile ürün "dead end" üretmez

### 7.7. Bu akista kabul edilemez şeyler

- 10+ alanlı onboarding formu
- ilk urun ekleme yolunun belirsiz kalması
- content page'in setup'ta görünmez olması

---

## 8. Workflow 2: Hızlı urun ekleme

### 8.1. Amaç

Creator'in tek bir URL ile mümkün olan en kısa sürede product + placement sonucuna ulaşması.

### 8.2. Ana akis

1. Creator URL yapıştırır veya share sheet'ten gelir
2. Sistem URL normalization ve safety kontrolü yapar
3. Import job oluşturulur
4. Aday alanlar üretilir
5. Creator verification ekranını görür
6. Hedef shelf / content page seçer
7. Publish veya draft sonucu alır

### 8.3. Akisin minimum zorunlu verileri

- URL
- hedef context (hemen veya sonra seçilebilir)
- trust/disclosure input'u

### 8.4. Akisin alternatif yolları

#### Alternatif yol A: Duplicate bulundu

Sistem:

- mevcut product'i önerir
- reuse-first davranir

Creator:

- mevcut product'i seçip yeni placement oluşturur

#### Alternatif yol B: Image ambiguous

Sistem:

- çoklu image candidate sunar
- creator seçim yapar

#### Alternatif yol C: Price yok ama title/image yeterli

Sistem:

- import'i tamamen bloklamaz
- price state'i "hidden / unavailable" olarak ilerler

#### Alternatif yol D: Hedef context sonra belirlenecek

Sistem:

- product'i library'ye kaydeder
- placement seçimini sonraya bırakır

### 8.5. Bozulma durumlari

- timeout
- low-confidence extraction
- blocked domain
- unsupported merchant
- redirect chain risk

### 8.6. Beklenen sistem davranisi

1. timeout'ta retry veya background completion açıklanır
2. low-confidence durumda verification sıkılaşır
3. blocked domain açık neden ile durdurulur
4. unsupported merchant'ta manual fallback gösterilir

### 8.7. Bu akista kabul edilemez şeyler

- generic "bir şeyler ters gitti"
- creator'i tekrar tekrar aynı URL'yi denemeye itmek
- duplicate olduğu halde yeni product açmayı default yapmak

---

## 9. Workflow 3: Verification ve correction

### 9.1. Verification neden ayri bir workflow'dur?

Cunku verification yalnizca ara ekran degildir.  
Urun dogrulugu ve trust kalitesi burada korunur.

### 9.2. Creator'in verify ettigi alanlar

Asgari kritik alanlar:

- title
- primary image
- merchant
- varsa price durumu
- disclosure

### 9.3. Correction yolları

1. alan duzeltme
2. image seçimi
3. merchant source değişikliği veya reddi
4. manual note ekleme
5. fallback manual card

### 9.4. Verification state kararları

Muhtemel sonuçlar:

- verified
- needs correction
- save as draft
- reject import result

### 9.5. Hata durumlari

- creator alanları eksik bıraktı
- disclosure seçmedi
- image yok
- source çok belirsiz

### 9.6. Beklenen davranis

- creator'e kritik eksik alanlar net söylenir
- correction, form duvarına dönüşmez
- save-as-draft yolu varsa açık kalır

---

## 10. Workflow 4: Library reuse

### 10.1. Amaç

Creator'in ayni urunu tekrar tekrar oluşturmamasını sağlamak.

### 10.2. Normal akis

1. creator library'de arama yapar
2. product'i seçer
3. yeni shelf veya content page'e placement ekler
4. gerekiyorsa page-specific note yazar

### 10.3. Reuse sinyalleri

Sistem şu anlarda reuse önermelidir:

- aynı canonical URL
- çok benzer title + merchant
- mevcut source eşleşmesi

### 10.4. Alternatif akis

- creator bilerek ayrı product açmak ister

Bu durumda:

- neden gerekli olduğuna dair hafif guardrail düşünülür
- varsayilan aksiyon yine reuse olur

### 10.5. Bozulma durumlari

- çok benzer ama farklı product'lar
- archived product reuse isteği
- editor yanlış product seçiyor

### 10.6. Beklenen davranis

- ayırt edici metadata gösterilir
- archived product ile active product net ayrılır

---

## 11. Workflow 5: Shelf yönetimi

### 11.1. Shelf oluşturma

Normal akis:

1. yeni shelf oluştur
2. title ve kısa context yaz
3. placements ekle
4. sırala
5. preview / publish

### 11.2. Shelf düzenleme

Desteklenmesi gereken aksiyonlar:

- re-order
- placement note update
- featured toggle
- archive / unpublish

### 11.3. Hata ve edge-case durumlari

- shelf title yok
- shelf boş
- shelf içindeki product archived oldu
- editor publish yetkisine sahip değil

### 11.4. Beklenen davranis

- boş shelf publish edilmez
- archived product'lar creator'e açık uyarı verir

---

## 12. Workflow 6: Content page yönetimi

### 12.1. Bu workflow neden ayrı?

Content page bu urunun differentiator surface'i oldugu icin shelf ile aynı düzeyde ama farklı mantik taşır.

### 12.2. Normal akis

1. yeni content page oluştur
2. content context gir
3. kapak / referans medya ekle
4. products seç
5. page-level intro / note yaz
6. preview / publish

### 12.3. Alternatif akislar

- mevcut page'e yeni product ekleme
- video henüz canlı değil, ama page draft hazırlanıyor
- URL import akışı doğrudan yeni content page'e bağlanıyor

### 12.4. Bozulma durumlari

- page title var ama product yok
- content reference eksik
- imported product verification bekliyor
- original content sonra silindi

### 12.5. Beklenen davranis

- ürünsüz content page publish edilmez
- content reference zorunlu minimum semantic context taşır
- verification bekleyen product durumunda publish guardrail devreye girer

---

## 13. Workflow 7: Publish / unpublish / archive

### 13.1. Publish

Creator publish aninda şunları net görmelidir:

- ne yayınlanıyor
- hangi route'ta görünecek
- trust/disclosure durumu ne

### 13.2. Unpublish

Anlamı:

- page publicten çekilir
- veri kaydı korunur

### 13.3. Archive

Anlamı:

- page veya product aktif kullanım dışına alınır
- ama geri getirilebilir geçmiş izi korunur

### 13.4. Delete

Anlamı:

- daha kalıcı ve dikkatli veri kaldırma işlemi

### 13.5. Etki alanı gösterimi

Kural:

- remove / archive / delete öncesi creator etkilenen page/placement setini görebilmelidir

### 13.6. Kabul edilemez davranis

- "sildim sandım ama her yerden gitti"
- "archive ettim ama neden publicte görünüyor anlamadım"

---

## 14. Workflow 8: Maintenance ve recovery

Creator launch sonrasında sadece yeni product eklemez; mevcut içerikleri de korur.

### 14.1. Maintenance senaryolari

- stale price uyarısı almak
- broken link uyarısı almak
- archived source için correction yapmak
- outdated product note guncellemek

### 14.2. Recovery davranisları

Sistem creator'e şunları açık sunmalıdır:

- hangi sorun var
- ne kadar kritik
- önerilen aksiyon ne

### 14.3. Bozulma durumlari

- aynı anda çok sayıda stale warning
- source erişilemiyor
- merchant policy değişmiş

---

## 15. Mobil ve web ayrımı

### 15.1. Mobilde birincil akışlar

- hızlı import
- hızlı verify
- son kullanılan context'e ekleme
- mini publish

### 15.2. Web'de birincil akışlar

- deep library curation
- bulk ordering
- template ve storefront düzeni
- import geçmişi ve detaylı correction

### 15.3. Yanlış yaklaşım nedir?

- mobilde tüm desktop gücünü kopyalamaya çalışmak
- web'i yalnız settings alanı gibi bırakmak

---

## 16. Offline ve kesinti davranışı

### 16.1. Offline import

Tam import offline tamamlanamaz.  
Ama creator'in intent'i kaybedilmemelidir.

### 16.2. Kaydedilebilecek state

- yazılmış notes
- draft page değişiklikleri
- son seçilmiş context

### 16.3. Publish sırasında kopma

Kural:

- creator'e sahte "yayınlandı" mesajı verilmez
- state net açıklanır

---

## 17. Workflow anti-pattern listesi

Bu belgeye göre su yaklasimlar yanlistir:

1. her import sonrası tam ekran uzun form
2. duplicate bulunduğu halde yeni product oluşturmayı teşvik etmek
3. unsupported merchant'ta dead end üretmek
4. remove/delete/archive ayrımını gizlemek
5. content page oluşturmayı shelf'ten daha zor hale getirmek

---

## 18. Bu belge sonraki belgelere ne emreder?

1. `53-creator-mobile-screen-spec.md` mobilde quick capture ve verify akışını birincil kılmalıdır
2. `54-creator-web-screen-spec.md` library, ordering ve deep edit akışlarını merkeze almalıdır
3. `44-product-verification-ui-and-manual-correction-spec.md` verification state ve correction yollarını bu belgeyle tutarlı kurmalıdır
4. `31-product-library-and-reuse-model.md` reuse davranışını domain seviyesinde bu workflow'u destekleyecek şekilde yazmalıdır

---

## 19. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- creator'in ilk publish ve tekrarli publish akislari net ve uygulanabilir görünüyorsa
- unsupported merchant, duplicate ve correction durumlari dead end üretmiyorsa
- owner ve editor farki workflow seviyesinde açık ise
- mobil ve webin farklı görevleri tasarım ve ürün belgelerine net taşınabiliyorsa

Bu belge basarisiz sayilir, eger:

- creator hâlâ uzun form merkezli bir editore mahkûm görünüyorsa
- reuse davranışı zayıf veya belirsizse
- publish / archive / delete etkileri karışıyorsa

Bu nedenle bu belge, creator tarafındaki ekranların listesi değil; urunun tekrarli kullanim ve retention mantığını belirleyen davranis motorudur.
