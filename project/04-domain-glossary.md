---
id: DOMAIN-GLOSSARY-001
title: Domain Glossary
doc_type: language_control
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROJECT-CHARTER-001
  - PRODUCT-VISION-THESIS-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
blocks:
  - PRODUCT-INFORMATION-ARCHITECTURE
  - PAGE-TYPES-PUBLICATION-MODEL
  - ROUTE-SLUG-URL-MODEL
  - DOMAIN-MODEL
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL
  - API-CONTRACTS
---

# Domain Glossary

## 1. Bu belge nedir?

Bu belge, `product-showcase` urunundeki temel domain terimlerini tek anlamli hale getiren, yasak ve tercih edilen kullanımları tanimlayan, UI dili ile teknik model arasindaki ayrimlari netlestiren ve tum belge seti icin zorunlu terminoloji kontrol katmani olarak isleyen resmi sozluktur.

Bu belge yalnizca kelime listesi degildir.  
Bu belge su sorulara cevap verir:

- Hangi kavram hangi anlamda kullanilir?
- Hangi kavramlar birbirine karistirilmamalidir?
- UI etiketi ile teknik model farkliyse bu nasil yazilir?
- Hangi es anlamlilar serbest, hangileri yasaktir?
- Destek, compliance ve operations metinleri de hangi terimleri kullanmak zorundadir?

Bu belge olmadan:

- ayni kavram farkli belgelerde farkli anlama gelir
- ekran isimleri ile veri modeli birbirini karsilamaz
- support issue tipleri karisir
- route, domain ve API tasariminda anlamsal kopukluk olusur

Bu nedenle bu belge dil duzeni degil, sistem duzenidir.

---

## 2. Bu belge neden kritiktir?

Bu urunde terminoloji sirf yazim duzeni icin onemli degildir.  
Terminoloji su alanlari dogrudan etkiler:

1. Domain model
2. Veritabani isimlendirmesi
3. UI ekran ve action naming
4. API contract'lari
5. Support issue taxonomy
6. Compliance ve disclosure dili

Ornek:

- `product` ile `placement` karisirsa reuse modeli bozulur
- `storefront` ile `profile` karisirsa IA ve public route bulaniklasir
- `merchant` ile `seller` karisirsa external source mantigi bozulur
- `unsupported` ile `blocked` karisirsa support yanlis aksiyon verir

Bu nedenle bu belge, proje boyunca ayni kavramin ayni anlamda kalmasini zorunlu kilar.

---

## 3. Terminoloji kullaniminin ana ilkeleri

Bu belge icin ana ilkeler sunlardir:

### 3.1. Tek kavram, tek ana anlam

Ayni kelime farkli belgelerde farkli seyler icin kullanilamaz.

### 3.2. UI etiketi farkli olabilir, teknik primitive farkli olabilir

Ama bu fark acik yazilmalidir.  
Ornek:

- UI'da `Collection` denebilir
- teknik primitive `Shelf` olabilir

Bu durumda ikisinin ayni varlik oldugu bu belgeye kaydedilmelidir.

### 3.3. Es anlamli kullanimlar kontrol altinda tutulur

Her es anlamli kelime serbest degildir.  
Bazilari bilincli olarak yasaklanir cunku urunu yanlis kategoriye iter.

### 3.4. Support ve compliance dili de ayni sozlugu kullanir

Sozluk yalniz product ve engineering icin degil; support ve compliance metinleri icin de baglayicidir.

---

## 4. Actor ve kimlik terimleri

### 4.1. Creator

Tanim:
Storefront'un ve recommendation evreninin sahibi olan urun rolu.

Kullanım:

- urun belgelerinde ana insan aktorunu tarif etmek icin kullanilir
- `user` yerine tercih edilir, cunku `user` teknik auth varligi olabilir

Yasak veya dikkatli kullanim:

- `influencer`: pazarlama tonu tasir, urun dilinde ana actor terimi olarak kullanilmaz
- `seller`: yanlistir; creator satici degildir

### 4.2. User

Tanim:
Teknik auth veya account varligini ifade eden genel terim.

Kullanim notu:

- auth, session, security ve DB belgelerinde anlamlidir
- urun actor'unu anlatirken `creator` veya `viewer` tercih edilir

### 4.3. Viewer

Tanim:
Public sayfalari tuketen, cogu zaman hesapsiz ziyaretci.

Kullanim notu:

- `customer` denmez; bu shopping product imasi tasir
- `user` denmesi actor ayrimini bozar

### 4.4. Owner

Tanim:
Storefront ve account'un asli kontrolune sahip creator rolu.

Kullanim notu:

- billing, ownership transfer, domain ayarlari ve account deletion owner'a aittir

### 4.5. Editor

Tanim:
Owner adina curation ve duzenleme yapabilen ama sahiplik ve kritik hesap alanlarini degistiremeyen role.

Kullanim notu:

- `admin` ile karistirilmaz
- `collaborator` ancak sonraki fazlarda daha genel role genislerse acilir

### 4.6. Admin / Ops

Tanim:
Ic operasyon tarafinda import, safety, broken link, merchant capability ve issue pattern'leriyle ilgilenen rol.

Kullanim notu:

- creator-side admin ile internal ops admin ayni sey degildir

### 4.7. Support

Tanim:
Issue intake, classification ve standard response akislarini yoneten operasyon rolu.

Kullanim notu:

- support, engineering'in es anlami degildir
- support issue tipi ayirir; root cause her zaman support tarafinda tamamen cozulemeyebilir

---

## 5. Public surface terimleri

### 5.1. Storefront

Tanim:
Creator'in public ana vitrini; tek-link ana giris yuzeyi.

Kullanım:

- creator'in public root page'i icin ana terimdir
- route ve IA belgelerinde birincil sayfa primitive'idir

Yasak veya dikkatli kullanim:

- `profile page`: yalnizca creator identity bolumunu tarif etmek icin kullanilabilir, page primitive'i gibi kullanilmaz
- `shop`: checkout imasi tasidigi icin ana terim olarak kullanilmaz

### 5.2. Profile

Tanim:
Creator'in kimlik, bio, avatar, handle ve positioning katmani.

Kullanim notu:

- `storefront`'un icindeki alt anlamsal bolgedir
- tek basina public root page primitive'i degildir

### 5.3. Public Page

Tanim:
Storefront, shelf page veya content page gibi viewer tarafinda acilan herhangi bir public route.

Kullanim notu:

- generic ust terim olarak kullanilabilir
- spesifik primitive yerine gecmez

### 5.4. Share Page

Tanim:
Dis platformlarda paylasilan public surface icin kullanilabilecek yardimci ifade.

Kullanim notu:

- teknik primitive degildir
- marketing veya UX copy icinde kullanilabilir

---

## 6. Context ve organization terimleri

### 6.1. Shelf

Tanim:
Baglama dayali ama nispeten kalici urun grubu.

Ornekler:

- daily stack
- gym bag
- shooting setup
- travel kit

Kullanim notu:

- teknik primitive olarak kullanilmasi onerilir
- `collection` ile es aile kavramdir ama tek database primitive secilmelidir

### 6.2. Collection

Tanim:
Shelf ile ayni ailede kullanilabilecek, creator-dostu UX etiketi.

Kullanim notu:

- teknik modelde ayri primitive yaratmak icin kullanilmaz
- UI metninde shelf yerine tercih edilebilir

Kural:

`Shelf` ve `Collection` ayni projede iki farkli ana entity gibi yazilamaz.

### 6.3. Content Page

Tanim:
Belirli bir video, post, story, newsletter, podcast veya icerik baglamina ait public sayfa.

Ornekler:

- used in this video
- products from this routine
- what I used in this shoot

Kullanim notu:

- urunun farklastirici primitive'idir
- "campaign page" veya "landing page" ile karistirilmaz

### 6.4. Context

Tanim:
Bir urunun neden, nerede veya hangi kullanim baglaminda onerildigini tanimlayan anlamsal cerceve.

Kullanim notu:

- category ile ayni sey degildir
- shelf ve content page bu context'in yapisal tasiyicilaridir

### 6.5. Category

Tanim:
Yardimci siniflandirma boyutu.

Kullanim notu:

- ana IA omurgasi degildir
- tag/filter/search yardimcisi olarak kullanilabilir

Kural:

`Category` hicbir belgede ana navigation primitive'i gibi kullanilamaz.

---

## 7. Product ve source terimleri

### 7.1. Product

Tanim:
Creator library icinde tekrar kullanilabilir urun varligi.

Kullanim notu:

- `link` ile ayni sey degildir
- merchant source kaydindan farklidir
- placement'in ust varligidir

### 7.2. Product Source

Tanim:
Belirli bir urunle iliskili external merchant veya kaynak kaydi.

Kullanim notu:

- canonical URL, extracted fields, refresh ve availability gibi alanlar burada yasar
- bir product birden fazla source'a sahip olabilir

### 7.3. Product Placement

Tanim:
Bir product'in belirli bir shelf veya content page icindeki context-bound gorunumu.

Kullanim notu:

- custom title
- custom note
- display order
- featured state

gibi context'e ozel alanlar placement seviyesinde yasar.

Kural:

`Product` ile `Product Placement` ayni sey degildir.  
Bir page icinde gorunen nesne cogu zaman placement'tir; product kaydinin kendisi degil.

### 7.4. Product Card

Tanim:
Viewer tarafinda product placement'in gorsel sunumu.

Kullanim notu:

- UI primitive'idir
- domain primitive'i degildir

### 7.5. Product Library

Tanim:
Creator tarafinda tum product kayitlarinin ve reuse operasyonunun merkezde toplandigi alan.

Kullanim notu:

- public catalog ile karistirilmaz
- creator-side management primitive'idir

---

## 8. Import ve extraction terimleri

### 8.1. Import

Tanim:
Creator tarafindan girilen bir URL veya referanstan product verisi elde etme surecinin tamami.

Kullanim notu:

- yalnizca scraping anlamina gelmez
- normalization, safety, extraction, dedupe, verification ve persistence zincirini kapsar

### 8.2. Import Job

Tanim:
Tek bir import denemesinin izlenebilir is kaydi.

Kullanim notu:

- status, failure reason, extractor path gibi alanlari tasir
- support ve ops icin kritik trace primitive'idir

### 8.3. Extraction

Tanim:
URL veya sayfa kaynagindan aday urun alanlarini cikarma adimi.

Kullanim notu:

- import'in bir alt asamasidir
- import'in tamami ile ayni sey degildir

### 8.4. Verification

Tanim:
Creator'in extraction sonucunu inceleyip dogruladigi veya duzelttigi asama.

Kullanim notu:

- "edit form" ile karistirilmaz
- aslen quality gate gorevi gorur

### 8.5. Manual Correction

Tanim:
Automated extraction'in eksik veya yanlis oldugu yerde creator'in alanlari duzelttigi akis.

Kullanim notu:

- fallback'tir
- varsayilan ana yol olmamalidir

### 8.6. Fallback

Tanim:
Bir onceki strateji basarisiz oldugunda veya yetersiz kaldiginda devreye giren sonraki yol.

Kullanim notu:

- retry, manual correction, unsupported merchant path veya kontrollu generic kurtarma davranislari fallback olabilir

### 8.7. Retry

Tanim:
Onceki import veya refresh denemesini ayni ya da ayarlanmis kosullarla yeniden baslatma davranisi.

Kullanim notu:

- fallback ile ayni sey degildir
- her fallback retry degildir

### 8.8. Refresh

Tanim:
Var olan product source bilgisini yeniden kontrol etme veya guncelleme davranisi.

Kullanim notu:

- ilk import'tan farklidir
- stale-data stratejisiyle baglantilidir

---

## 9. Merchant ve external source terimleri

### 9.1. Merchant

Tanim:
Dis e-commerce domain'i veya satici kaynak.

Kullanim notu:

- product'in satildigi veya kaynaklandigi external siteyi ifade eder
- `seller` ile karistirilmaz; seller marketplace icindeki alt satici da olabilir

### 9.2. Domain

Tanim:
Merchant'in veya herhangi bir URL kaynaginın host / domain seviyesi kimligi.

Kullanim notu:

- merchant ile iliskilidir ama bire bir ayni sey olmayabilir
- capability registry cogu zaman domain bazli isler

### 9.3. Support Tier

Tanim:
Belirli merchant/domain icin urunun ne seviyede import destegi verdigini ifade eden seviye.

Ornekler:

- full
- partial
- fallback-only
- blocked

Kullanim notu:

- teknik parsing kalitesi ve UX fallback davranisini etkiler

### 9.4. Unsupported Merchant

Tanim:
Import'in deterministic kalite vaadi veremeyecegi, bu nedenle fallback agirlikli ele alinacak merchant.

Kullanim notu:

- `blocked` ile ayni degildir
- unsupported demek her zaman yasakli demek degildir

### 9.5. Blocked Domain

Tanim:
Safety, compliance veya teknik nedenlerle import'a kapatilan domain.

Kullanim notu:

- creator fallback olarak manuel product bile acamiyor olabilir; bu karar policy'ye baglidir
- support tarafi `unsupported` ile karistirmamalidir

---

## 10. Trust ve compliance terimleri

### 10.1. Disclosure

Tanim:
Recommendation ile ilgili ticari veya etik baglam bilgisini ifade eden data primitive'i.

Ornekler:

- affiliate
- sponsored
- gifted
- brand_provided
- self_purchased
- unknown_relationship

Kullanim notu:

- sadece UI badge'i degildir
- veri katmaninda ayrica kayitli olmalidir

### 10.2. Trust Layer

Tanim:
Disclosure, source merchant, stale/missing price ve creator note gibi guven ureten elemanlarin birlikte olusturdugu katman.

Kullanim notu:

- tek alana indirgenmez
- hem UI hem veri hem policy katmanidir

### 10.3. Trust Badge

Tanim:
Disclosure veya benzeri trust bilgisinin UI'daki gorsel sunumu.

Kullanim notu:

- `disclosure` ile ayni kavram degildir
- disclosure data'dir, trust badge onun gorsel ifadesidir

### 10.4. Affiliate

Tanim:
Merchant cikisinda creator veya platformun ekonomik bag kurabilecegi iliski tipi.

Kullanim notu:

- sponsorlu ile ayni sey degildir
- gifted ile ayni sey degildir

### 10.5. Sponsored

Tanim:
Belirli urun veya icerik baglaminda sponsorluk iliskisi oldugunu ifade eden disclosure tipi.

### 10.6. Gifted

Tanim:
Urunun creator'a hediye edilmis oldugunu ifade eden disclosure tipi.

### 10.7. Brand Provided

Tanim:
Urunun creator'a marka veya temsilci tarafindan saglandigini ifade eden disclosure tipi.

Kullanim notu:

- `gifted` ile karisabilir; ama ayni primitive olarak ele alinmaz
- canonical data degeri `brand_provided` olarak yazilir

### 10.8. Self Purchased

Tanim:
Creator'in urunu kendi satin aldigini veya kendi kullanim deneyimine dayandigini belirten disclosure tipi.

Kullanim notu:

- her zaman kanitlanabilir finansal kayıt anlamina gelmez
- public copy `kendi satin aldim` veya benzeri sade dille sunulabilir; canonical data degeri `self_purchased` olarak yazilir

### 10.9. Unknown Relationship

Tanim:
Relationship bilgisinin henuz kesinlestirilmedigini veya creator tarafindan netlestirilmedigini ifade eden gecici disclosure tipi.

Kullanim notu:

- sessizce `self_purchased` veya `affiliate` varsayilmaz
- publish warning veya blocker davranisina yol acabilir

---

## 11. Status ve state terimleri

Bu bolumde state isimleri ve anlamsal farklari sabitlenir.

### 11.1. Draft

Tanim:
Creator tarafinda hazirlanan ama henuz publicte yayinlanmayan nesne durumu.

Kullanim notu:

- shelf, content page veya product placement duzeyinde kullanilabilir
- `saved` ile ayni sey degildir

### 11.2. Published

Tanim:
Public route veya public surface uzerinde gorunur hale gelmis durum.

### 11.3. Unpublished

Tanim:
Bir zamanlar yayinlanmis ama artik publicte gorunmeyen durum.

Kullanim notu:

- draft'tan farklidir; gecmis yayin izi olabilir

### 11.4. Archived

Tanim:
Aktif kullanimdan cikarilmis ama silinmemis nesne durumu.

Kullanim notu:

- product archive ile page archive farkli davranabilir

### 11.5. Deleted

Tanim:
Nesnenin sistemden silindigi veya geri donulemez silme surecine girdigi durum.

Kullanim notu:

- UI'da `remove` gorulebilir ama domain'de delete farkli davranis ifade eder

### 11.6. Remove

Tanim:
Bir placement veya iliskinin baglamdan cikarilmasi aksiyonu.

Kullanim notu:

- her remove, product delete demek degildir
- bu ayrim support ve creator UI'inda acik olmalidir

### 11.7. Verification States

Onerilen anlamlar:

- `pending`: creator veya sistem tarafi final dogrulama bekleniyor
- `verified`: kritik alanlar kabul edildi
- `needs_correction`: publish once creator duzeltmesi gerekiyor
- `rejected`: bu import sonucu kabul edilmedi

Kural:

`failed import` ile `needs_correction` ayni state degildir.

### 11.8. Stale

Tanim:
Guncelligi belirlenmis zaman eşiğini gecmis veri.

Kullanim notu:

- stale olmak yanlis olmakla ayni sey degildir
- stale price, stale availability ve stale metadata ayri davranabilir

---

## 12. URL ve routing terimleri

### 12.1. Canonical URL

Tanim:
Normalization ve dedupe icin baz alinan temiz ana URL.

Kullanim notu:

- tracking parametreleri ve gereksiz varyasyonlar ayiklanmis olur
- product source esleme ve refresh mantigi bunun uzerinden yurur

### 12.2. Public URL

Tanim:
Viewer'in gordugu urun, shelf veya content page route'u.

Kullanim notu:

- canonical source URL ile karistirilmaz

### 12.3. Slug

Tanim:
Public route icinde insan okunabilir kimlik parcasi.

Kullanim notu:

- handle, shelf slug veya content page slug olarak farkli seviyelerde olabilir

### 12.4. Deep Link

Tanim:
Belirli bir screen veya public route'a dogrudan goturen link.

Kullanim notu:

- mobile app entry ve public route gecislerinde kullanilabilir

---

## 13. Action ve event fiilleri

Bu bolum, dokumanlarda ayni eylem icin ayni fiillerin kullanilmasini zorunlu kilar.

### 13.1. Add

Anlam:
Yeni product, source veya placement yaratma ya da mevcut bir nesneyi baglama aksiyonu.

### 13.2. Import

Anlam:
External URL'den product bilgisi cikararak sisteme alma aksiyonu.

### 13.3. Verify

Anlam:
Extraction sonucunu creator tarafinda onaylama veya duzeltme aksiyonu.

### 13.4. Publish

Anlam:
Public gorunurluk kazandirma aksiyonu.

### 13.5. Unpublish

Anlam:
Public gorunurlugu geri alma aksiyonu.

### 13.6. Archive

Anlam:
Aktif kullanimdan cekme ama veriyi tamamen silmeme aksiyonu.

### 13.7. Remove

Anlam:
Bir placement'i context'ten cikarma aksiyonu.

### 13.8. Delete

Anlam:
Kalici silme veya daha sert veri yok etme aksiyonu.

Kural:

`remove` ve `delete` destek metinlerinde karistirilmamalidir.

---

## 14. Yasak veya dikkatli kullanilacak diller

### 14.1. `Shop`

Sorun:
Checkout / commerce beklentisi yaratir.

Kural:

- marketing copy'de kontrollu kullanilabilir
- teknik ve urun ana primitive'i olarak kullanilmaz

### 14.2. `Marketplace`

Sorun:
Global discovery feed ve ranking beklentisi yaratir.

Kural:

- ana urun taniminda kullanilmaz

### 14.3. `Bio Link Tool`

Sorun:
Urunu gereksiz sekilde basit ve zayif kategoriye indirger.

### 14.4. `AI Curator`

Sorun:
AI'nin rolunu abartir ve yanlis beklenti uretir.

### 14.5. `Store`

Sorun:
Checkout ve order beklentisi yaratabilir.

Kural:

- sadece kontrollu marketing dilinde dikkatli kullanilir
- system primitive'i olarak `storefront` tercih edilir

---

## 15. UI etiketi ile teknik primitive arasindaki ayrim

Bu urunde ayni kavramin UI ile domain arasinda farkli isimleri olabilir.  
Bu farklar gizli kalmamalidir.

| UI Etiketi | Teknik Primitive | Not |
| --- | --- | --- |
| Collection | Shelf | UI dostu alternatif olabilir |
| Profile | Storefront profile section | Ana page primitive'i degil |
| Card | Product Placement render | Product kaydinin kendisi degil |
| Trusted link | Outbound merchant link with trust layer | Marketing copy olabilir |
| Remove from page | Remove placement | Product delete anlamina gelmez |

Kural:

Her belge, teknik veya UI tarafini kastederken bunu acik yazmalidir.

---

## 16. Support ve operations terminoloji kurallari

Support ve operations belgeleri su ayrimlara sadik kalmak zorundadir:

1. `unsupported` ile `blocked` ayni issue tipi degildir
2. `wrong extraction` ile `needs correction` ayni sey degildir
3. `broken link` ile `stale price` ayni issue tipi degildir
4. `remove placement` ile `delete product` ayni aksiyon degildir
5. `merchant` ile `domain` bazen ayni issue baglaminda kullanilsa da analitik olarak ayri seviyeler olabilir

---

## 17. Compliance terminoloji kurallari

Compliance ve trust belgelerinde:

1. `disclosure` data primitive'i olarak kullanilir
2. `trust badge` UI sunumu olarak kullanilir
3. `affiliate`, `sponsored`, `gifted`, `brand_provided`, `self_purchased` ve `unknown_relationship` farkli state'lerdir
4. `safety block` ile `support limitation` ayni policy sonucu degildir

---

## 18. Yeni terim ekleme politikasi

Bu proje boyunca yeni bir terim eklenmesi gerekirse:

1. Once bu belgeye eklenir
2. Terimin tanimi yazilir
3. Hangi mevcut terimlerden farkli oldugu belirtilir
4. UI mi teknik primitive mi oldugu yazilir
5. Yasak / dikkatli kullanilacak es anlamlilar not edilir

Bu adim yapilmadan belge ailesine yeni ana terim sokulmamasi gerekir.

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `20-product-information-architecture.md` creator, storefront, shelf, content page ve placement ayrimini bu sozluge uygun kullanmalidir
2. `30-domain-model.md` product, source ve placement primitive'lerini burada tanimlandigi gibi ayirmalidir
3. `22-route-slug-and-url-model.md` canonical URL ile public URL farkini korumalidir
4. `34-roles-permissions-and-ownership-model.md` owner, editor, support ve ops terimlerini burada tanimlandigi gibi kullanmalidir
5. `103-support-playbooks.md` issue taxonomy kurallarini bu belgeyle uyumlu yazmalidir

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ayni kavram farkli belgelerde farkli anlama gelmiyorsa
- UI dili ile teknik model karistirilmiyorsa
- support, product ve engineering ayni issue tiplerine ayni isimle bakiyorsa
- product, source ve placement ayrimi hicbir yerde bulaniklasmiyorsa

Bu belge basarisiz sayilir, eger:

- `shelf`, `collection`, `category`, `page`, `product`, `card`, `link`, `source` gibi terimler rastgele kullanilmaya devam ederse
- public page primitive'leri ile UI kopyasi birbirine karisirsa
- support issue tipleri teknik primitive'lerle eslesmez hale gelirse

Bu nedenle bu belge, tum proje dokuman setinin ortak dil omurgasidir.
