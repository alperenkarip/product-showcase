---
id: ROUTE-SLUG-URL-MODEL-001
title: Route, Slug and URL Model
doc_type: routing_policy
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PRODUCT-INFORMATION-ARCHITECTURE-001
  - PAGE-TYPES-PUBLICATION-MODEL-001
  - DOMAIN-GLOSSARY-001
blocks:
  - WEB-SURFACE-ARCHITECTURE
  - SEO-OG-SHARE-PREVIEW-ARCHITECTURE
  - EXTERNAL-LINK-MERCHANT-CONTENT-POLICY
---

# Route, Slug and URL Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun public URL yapisini, handle modelini, slug kurallarini, canonical davranisini, redirect rejimini, preview URL kurallarini, query parameter politikasini ve custom domain geldiğinde dahi korunacak route semantiğini tanimlayan resmi routing policy belgesidir.

Bu belge su sorulara cevap verir:

- Creator identity URL'de nasil tasinacak?
- Storefront, shelf, content page ve product detail route'lari nasil ayrisacak?
- Slug collision nasıl çözülecek?
- Handle rename veya transfer durumunda ne olacak?
- Preview, short link ve canonical iliskisi nasil kurulacak?

Bu belge olmadan route modeli rastgeleleşir ve şu problemler doğar:

- canonical bozulur
- support URL'den hangi sayfaya bakildigini anlayamaz
- share preview tutarsizlasir
- analytics attribution karmasiklasir

---

## 2. Bu belge neden kritiktir?

Bu urunde URL yalnız adres degildir.  
URL ayni zamanda:

- creator identity taşıyıcısı
- page type sinyalleyicisi
- share primitive
- SEO primitive
- support/debug referansı

olduğu için stratejik role sahiptir.

Ozellikle bu urunde:

- content page'ler önemli farklastirici yüzeydir
- creator kimligi birinci sinif primitive'tir
- public web primary consumption surface'tir

Bu nedenle route modeli tasarimsal degil, urunsel karardir.

---

## 3. Route modelinin ana karari

Bu belge için ana karar sudur:

> Creator kimligi URL'de birinci sinif olarak tasinacak; storefront, shelf ve content page route'lari page type bazli ayrisacak; short/share URL'ler asla canonical URL'nin yerine gecmeyecek.

Bu karar su sonuclari doğurur:

1. Creator handle route'un ana köküdür
2. Page type'lar farkli namespace'te yaşar
3. Preview route'lar public canonical ile karismaz
4. Query parametreleri canonical'i degistirmez

---

## 4. Public route primitive'leri

Bu belgeye gore varsayilan public route ailesi sunlardir:

### 4.1. Storefront root

Onerilen model:

- `/{handle}`

Gorevi:

- creator storefront root surface'i tasimak

Not:

- `@handle` görsel dilde kullanılabilir
- ancak teknik route primitive'i gerekli platform kisitlarina göre `/{handle}` veya `/{creator-handle}` seklinde uygulanabilir

Kural:

- hangi form secilirse secilsin creator identity URL'nin birinci sinif parcası kalır

### 4.2. Shelf route

Onerilen model:

- `/{handle}/s/{shelf-slug}`

Gorevi:

- shelf primitive'ini storefront ve content page'den ayırmak

### 4.3. Content page route

Onerilen model:

- `/{handle}/c/{content-slug}`

Gorevi:

- content-linked page'i birinci sinif route primitive'i yapmak

### 4.4. Product light detail route

Varsa onerilen model:

- `/{handle}/p/{product-slug}`

Kural:

- product detail, creator context'inden kopuk root-level product catalog route'una donusmez

### 4.5. Short/share redirect route

Onerilen model:

- `/r/{short-code}`

Gorevi:

- kısa paylaşım
- attribution destekli redirect

Kural:

- canonical URL değildir
- 301/302 policy'si kullanım amacına göre belirlenir

---

## 5. Handle modeli

### 5.1. Handle nedir?

Handle:

- creator'in public URL kimligidir
- route yapisinin root primitive'idir

### 5.2. Handle kurallari

Handle için bağlayıcı kurallar:

1. global olarak benzersizdir
2. insan okunabilir olmalıdır
3. rezerv kelimelerle cakisamaz
4. owner account'a baglidir
5. transfer veya degisim audit izli olmalidir

### 5.3. Reserved words politikasi

Asagidaki gibi route namespace'leri handle olarak kullanilamaz:

- `s`
- `c`
- `p`
- `r`
- `api`
- `admin`
- `login`
- `settings`

Liste uygulama detayında genişleyebilir; ama reserve mantigi zorunludur.

### 5.4. Handle degisimi

Handle degisimi:

- mumkündür ama hafife alinamaz
- child route'larin hepsini etkiler

Zorunlu sonuclar:

1. eski route'lar redirect verir
2. redirect zinciri birikmez
3. share preview invalidation tetiklenir
4. analytics ve support mapping'i korunur

### 5.5. Handle transferi

Owner transfer veya hesap el degistirme durumunda:

- support / ops kontrollu prosedur gerekir
- handle anlik olarak baska kisiye serbest birakilmaz

---

## 6. Slug kurallari

### 6.1. Genel slug ilkeleri

Tum slug'lar için:

1. küçük harf
2. ASCII normalize form
3. kelimeler arasi `-`
4. anlamsiz kisa hash benzeri defaultlar tercih edilmez
5. emoji ve gereksiz noktalama kullanılmaz

### 6.2. Auto-slug generation

Sistem:

- title'dan slug turetebilir
- creator sonradan override edebilir

Kural:

- auto-generated slug anlamsal olmali
- sessizce anlamsiz suffix yığını üretmemelidir

### 6.3. Namespace bazli benzersizlik

Storefront root disinda:

- shelf slug'lari handle icinde shelf namespace'inde benzersiz olmalı
- content slug'lari handle icinde content namespace'inde benzersiz olmalı
- product slug'lari varsa kendi namespace'inde benzersiz olmalı

Bu model su avantaji verir:

- aynı creator icinde `gym-bag` hem shelf hem content olarak kural olarak mümkün olabilir
- ama UX tarafinda kafa karistirici ise yine de uyarı verilebilir

### 6.4. Slug override kurali

Creator slug'i degistirebilir; ama:

- published route'larda redirect politikasi devreye girmeli
- preview ve draft route'lar canonical sayilmamali

---

## 7. Canonical URL modeli

### 7.1. Tek canonical hedef kuralı

Her public published page'in tek canonical hedefi vardir.

Canonical olamayan varyasyonlar:

- query parametreli URL'ler
- preview URL'ler
- short redirect URL'ler
- signed access URL'ler
- share tracker variant'lari

### 7.2. Canonical ile public erişilebilir varyasyon farki

Bir URL erişilebilir olabilir ama canonical olmayabilir.

Ornek:

- unlisted page route'u erişilebilir olabilir
- ama indexlenebilir canonical gibi davranmaz

### 7.3. Canonical inheritance kuralı

Canonical route:

- page type'a,
- handle'a,
- current slug'a

baglidir.

Template degisimi canonical'i degistirmez.  
Page meaning degismedigi surece visual varyasyon canonical degisikligi sayılmaz.

---

## 8. Query parameter politikasi

### 8.1. Izin verilen parametre aileleri

Asagidaki parametre tipleri kabul edilebilir:

1. analytics attribution (`utm_*` vb.)
2. lightweight UI state
3. preview access tokens
4. signed review access data

### 8.2. Query parametreleri ne yapamaz?

- canonical'i degistiremez
- page type'i degistiremez
- trust/disclosure state'ini degistiremez
- farklı content göstermeye neden olamaz

### 8.3. UI state parametreleri

UI state parametreleri:

- sıralama tercihi
- filtre seçimi
- tab state

gibi anlamlara sahip olabilir.  
Ama bu state route'un anlamsal kimligini degistirmez.

---

## 9. Preview URL modeli

### 9.1. Preview URL'nin amacı

Preview URL:

- creator / editor review
- owner approval
- pre-publish quality control

icin vardir.

### 9.2. Preview URL'nin kurallari

1. canonical değildir
2. noindex olmalıdır
3. signed veya time-boxed olabilir
4. analytics'te public traffic ile karismamasi gerekir

### 9.3. Preview URL ne değildir?

- kalici share link
- launch-ready public route
- redirect source of truth

---

## 10. Unlisted URL modeli

### 10.1. Unlisted ne demektir?

Unlisted:

- link bilenin gorebildigi
- ama indexlenmemesi gereken page durumudur

### 10.2. Unlisted route canonical olur mu?

Kural:

- unlisted page canonical SEO surface gibi davranmaz
- page erişilebilir olabilir ama index intent tasimaz

### 10.3. Unlisted neden gerekir?

- creator review ile public publish arasi ara durum
- sınırlı paylaşım
- pilot kullanicilarla test

---

## 11. Redirect modeli

### 11.1. Handle change redirects

Handle degisirse:

- eski storefront route'u yenisine gider
- eski shelf/content/product route'lari yeni handle ile yeni path'e gider

### 11.2. Slug change redirects

Published page slug degisirse:

- eski URL yeni canonical'e redirect verir

### 11.3. Redirect chain policy

Kural:

- redirect zinciri katman katman birikmemeli
- mümkün oldugunca son canonical target'a direct resolve edilmelidir

### 11.4. Archive redirects

Archived page için varsayilan davranis:

- her zaman root'a atmak zorunlu değildir
- controlled archived state page de mümkün olabilir

Bu karar SEO ve UX birlikte düşünülmelidir.

---

## 12. Custom domain ile ilişki

### 12.1. Custom domain neyi degistirir?

Custom domain:

- host'u degistirir
- route semantiğini degistirmez

### 12.2. Custom domain varken handle kaybolur mu?

Hayır.  
Handle urun kimliginin semantic primitive'i olarak kalir; ama root domain deneyiminde path'te görünmeyebilir.

Bu durumda sistem icinde:

- handle hâlâ primary identity primitive'i olur
- custom domain presentation layer gibi davranır

### 12.3. Custom domain + root collision

Custom domain tek creator'a bağlıysa:

- root `/` storefront olabilir

Ama child page namespaces:

- `/s/...`
- `/c/...`
- `/p/...`

mantigini korur.

---

## 13. Deep link ve app entry iliskisi

Bu urun web-first public experience taşısa da:

- mobile app
- share extension
- internal review tools

ile ilişkili deep link akislari olabilir.

Kural:

- public canonical URL her zaman web route'dur
- app deep link bunun ustune ek entry behavior'dur
- app route canonical'in yerine gecmez

---

## 14. Edge-case kurallari

### 14.1. Empty storefront route

Storefront route var ama aktif content yoksa:

- 404 verilmez
- controlled empty storefront experience gösterilir veya publish engellenir

### 14.2. Archived content page route

Archived route:

- soft landing / archived notice verebilir
- ya da uygun policy ile 404/410 davranisina dönebilir

Ama bu davranis belgeyle belirlenmeli, rastgele olmamalidir.

### 14.3. Conflicting slug

Yeni slug conflict olursa:

- creator'a acik uyarı gösterilir
- sessizce anlamsiz collision çözümü yapılmaz

### 14.4. Deleted creator account

Creator account silinirse:

- handle'in hemen tekrar serbest birakilmasi risklidir
- koruma ve quarantine suresi gerekir

---

## 15. Anti-pattern listesi

Bu belgeye göre su yaklasimlar yanlistir:

1. Preview URL'yi kalici public route gibi kullanmak
2. Short link'i canonical olarak yorumlamak
3. Query parametreyle farkli page primitive'leri üretmek
4. Handle'i route'un yardimci parcasina indirmek
5. Custom domain geldi diye route semantiğini bozmak

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `61-web-surface-architecture.md` route resolution ve redirect mantigini bu modele gore kurmalıdır
2. `67-seo-og-and-share-preview-architecture.md` canonical/noindex davranisini bu belgeye bağlamalidir
3. `92-external-link-and-merchant-content-policy.md` outbound redirect ve blocked-link davranisini route modelinden ayirmamalidir
4. `21-page-types-and-publication-model.md` state ve route iliskisini tutarli yorumlamalidir

---

## 17. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- route'lar creator kimligi ve page type semantiğini tek anlamli tasiyorsa
- preview, unlisted, canonical ve short link kavramlari karismiyorsa
- handle ve slug degisiklikleri SEO/support krizine donusmeden yönetilebiliyorsa
- custom domain gelse bile route mantigi bozulmuyorsa

Bu belge basarisiz sayilir, eger:

- URL'lerden hangi page primitive'ine bakildigi anlasilmiyorsa
- canonical davranis query veya short link yüzünden bulaniklasiyorsa
- handle degisiklikleri redirect karmasasina donusuyorsa

Bu nedenle bu belge, public web'in kalici adres semantiğini ve kimlik yapısını tanımlar.
