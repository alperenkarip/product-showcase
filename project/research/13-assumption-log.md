---
id: ASSUMPTION-LOG-001
title: Assumption Log
doc_type: research_governance
status: ratified
version: 2.0.0
owner: product
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PROBLEM-VALIDATION-FRICTION-MAP-001
  - RISK-REGISTER-001
blocks:
  - INTERNAL-TEST-PLAN
  - SUBSCRIPTION-PLAN-MODEL
  - CREATOR-MOBILE-SCREEN-SPEC
  - LAUNCH-TRANSITION-PLAN
---

# Assumption Log

## 1. Bu belge nedir?

Bu belge, `product-showcase` projesinde bugün dogru kabul edilerek uzerine belge veya roadmap insa edilen; ancak henuz yeterli veriyle kesinlesmemis varsayimlari resmi olarak kayda alan, test planina baglayan ve yanlışlanma durumunda hangi belgelerin revize edilmesi gerekecegini tanimlayan resmi varsayim yonetim belgesidir.

Bu belge su sorulara cevap verir:

- Hangi kararlar veri degil varsayim uzerine kurulu?
- Bu varsayimlar neden simdilik kabul ediliyor?
- Nasil test edilecekler?
- Ne olursa yanlışlanmiş sayilacaklar?
- Yanlışlandiklarinda hangi belge veya roadmap maddeleri etkilenir?

Bu belge olmadan varsayimlar sessizce "gercek" gibi davranmaya baslar.  
Ve ekip, belge setini aslinda test edilmemis önkabuller üzerine kurar.

---

## 2. Bu belge neden kritiktir?

Belge seti derinlesirken her cümle ayni guven seviyesinde değildir.

Bazi kararlar:

- stratejik olarak guclu,
- ama henuz kanitsiz olabilir.

Ornek:

- fitness wedge en iyi segment midir?
- mobile-first creator velocity gerçekten baskin mi?
- content-linked page storefront ana sayfadan daha fazla deger mi uretir?

Eger bu varsayimlar kayda alinmazsa:

- roadmap bunlari kesin bilgi gibi uygular
- sonra gelen veriler belge setiyle celisir
- ekip "bunu zaten karara baglamistik" diyerek yanlis varsayimi korur

Bu belge, kararla varsayim arasindaki farki acik tutar.

---

## 3. Varsayim yonetiminin ana ilkeleri

### 3.1. Her varsayim bir belgeye bağlı olmalıdır

Varsayim boslukta duramaz.  
Hangi belgeyi etkiledigi yazılmalıdır.

### 3.2. Her varsayim bir test yoluna sahip olmalıdır

"Bakacagiz" yeterli degildir.  
Gorusme, usage data, QA, pilot metric veya A/B benzeri test yolu belirtilmelidir.

### 3.3. Her varsayimin bir invalidation trigger'i olmalıdır

Yanlislandigi nasıl anlaşılacak yazılmalıdır.

### 3.4. Varsayimlar sessizce kapanmis sayilmaz

Durumlar sunlardir:

- `open`
- `testing`
- `validated`
- `invalidated`
- `partially-validated`

---

## 4. Assumption log'un ana karari

Bu belge için en önemli karar sudur:

> Bu projedeki bazi stratejik kararlar doğru gorunse de, bunlarin hepsi ayni derecede kanitli degildir; bu nedenle belge seti kendi varsayimlarini acikca kaydetmek zorundadir.

Bu karar önemli cünkü:

- varsayimlari saklamak hiza degil korluga yol acar
- dogrulanmamis tezler launch once risk üretir

---

## 5. Varsayim kayit tablosu

| ID | Varsayim | Simdilik neden kabul ediliyor? | Dogrulama yontemi | Invalidation trigger | Etkiledigi belgeler | Durum |
| --- | --- | --- | --- | --- | --- | --- |
| A-01 | Fitness creator ilk wedge icin en uygun segmenttir | Context ve repeatable product pattern'i kuvvetli | Pilot creator gorusmeleri + private usage davranisi | Beauty/tech retention veya publish frequency belirgin daha iyi cikarsa | 01, 10, 11, 110, 113 | Open |
| A-02 | Creator price alanini zorunlu degil opsiyonel görmek ister | Stale price korkusu yüksek | Creator interviews + setting usage logs | Creator'lar price gizlemeyi nadiren kullanirsa veya price beklentisi cok yuksek cikarsa | 11, 27, 45, 52 | Open |
| A-03 | Mobile hizli ekleme davranisi web'den daha kritik olacaktır | Share/paste davranisi mobil agirlikli varsayiliyor | Private usage logs + onboarding diary | Creator'lar agirlikli olarak desktop'ta urun ekliyorsa | 03, 23, 53, 54 | Open |
| A-04 | 3-5 guclu preset ilk faz icin yeterlidir | Tema yerine import ve context daha kritik görünüyor | Creator feedback + support request trendi | Creator'lar ilk haftalarda theme/customisation eksigini ana problem diye raporlarsa | 02, 26, 50, 52, 54 | Open |
| A-05 | Sade plan modeli ilk fazda yeterlidir | Product value complexity'den once utility gelmeli | Conversion / churn + sales feedback | Kullanici acquisition, conversion veya retention icin ek plan farklari zorunlu hale gelirse | 02, 28, 40 | Open |
| A-06 | Content-linked page, storefront ana sayfadan daha yüksek deger uretecektir | Differentiation burada görülüyor | Traffic split + CTR + repeated use | Storefront ana sayfa anlamli sekilde baskin ve content pages düşük kullanımda kalırsa | 01, 20, 21, 24, 52 | Open |
| A-07 | AI yalnizca fallback/normalization rolunde kalmalidir | Uydurma veri riski yüksek | Import quality audit + correction rate | Deterministik katman sürekli yetersiz kalir ve AI güvenilir şekilde ana role çıkarsa | 02, 40, 41, 47, 60 | Open |
| A-08 | Reuse library retention'in ana surucusudur | Tekrarsiz veri girisi ana friction olarak görünüyor | Repeat publishing behavior + duplicate avoidance data | Creator'lar library reuse kullanmadan da yüksek retention gösterirse | 00, 11, 23, 31 | Open |
| A-09 | Editor role'u launch once sinirli ama gerçek bir ihtiyaçtır | Gercek creator operasyonlarında yardimci rol olasi | Pilot team interviews + role request frequency | Coklu editor talebi neredeyse hic gelmezse | 03, 34, 54, 103 | Open |
| A-10 | Public web consumption web-first optimize edilmelidir | Sosyal trafik dis linklerle web'e geliyor varsayimi güçlü | Referral analytics + session data | App-open veya platform-native deep-link tüketimi beklenmedik şekilde baskin cikarsa | 00, 01, 24, 52, 61, 67 | Open |

---

## 6. En yuksek etkili varsayimlar

Bu bolumde urun yönünü en fazla etkileyen varsayimlar ayri ele alinir.

### 6.1. A-01 Fitness wedge varsayimi

Neden kritik:

- seed content planini belirler
- ilk messaging'i belirler
- onboarding orneklerini etkiler
- demo verisini belirler

Yanlışlanirsa ne olur:

- landing ve sample showcase seti degisir
- roadmap'te dikey ornekleri revize etmek gerekir

### 6.2. A-03 Mobile velocity varsayimi

Neden kritik:

- creator mobile app önceliğini etkiler
- share extension tartismasini etkiler
- mobile vs web backlog onceliklerini etkiler

Yanlışlanirsa ne olur:

- mobile yuzey scope'u yeniden kalibre edilir
- web curation tarafi daha once gelir

### 6.3. A-06 Content-linked page value varsayimi

Neden kritik:

- urunun differentiator'u burada kurulu
- IA, screen map ve route model bu varsayima dayanir

Yanlışlanirsa ne olur:

- urunun farklastirma anlatisi yeniden kurulmak zorunda kalir

### 6.4. A-08 Reuse library retention varsayimi

Neden kritik:

- domain model ve creator workflow bunun etrafinda kuruluyor

Yanlışlanirsa ne olur:

- library merkezli modelin agirligi yeniden değerlendirilir

---

## 7. Varsayim tipleri

Bu projedeki varsayimlar dort tipe ayrilir:

### 7.1. Wedge varsayimlari

Hangi creator grubu ile girilecegi ve neden o grubun uygun oldugu.

### 7.2. Behavior varsayimlari

Creator'in hangi yuzeyi hangi siklikta kullanacagi gibi davranişsal varsayimlar.

### 7.3. Value varsayimlari

Hangi feature'in gercek deger üretecegi ile ilgili varsayimlar.

### 7.4. Boundary varsayimlari

AI'nin rolu, plan modelinin sadeligi veya theme derinligi gibi scope sınırı ile ilgili varsayimlar.

Bu ayrim, varsayimlari rastgele liste olmaktan çıkarır.

---

## 8. Varsayimlar nasil test edilir?

Varsayim test yöntemleri en az su ailelerden biriyle yazilmalidir:

1. Creator interview
2. Private usage analytics
3. Support issue trend review
4. Feature usage frequency
5. Comparative flow completion data

Her varsayim icin "hangi veri geldiginde dogrulandi sayacagiz?" sorusu cevaplanmali.

---

## 9. Varsayimlarin yanlışlanma rejimi

Bir varsayim invalidated oldugunda:

1. varsayim logunda durum guncellenir
2. etkiledigi belgeler listelenir
3. belge revizyonu acilir
4. gerekiyorsa roadmap sirasi degisir
5. gerekiyorsa yeni ADR acilir

Varsayimlar sessizce silinmez.  
Yanlislanmis varsayimlar proje hafizasinda kalir.

---

## 10. Varsayim bazli test önceliği

Bu belgeye gore ilk test edilmesi gereken varsayimlar sunlardir:

### 10.1. A-01 Fitness wedge

Neden once:

- giris mesajini etkiler
- demo ve sample datayi etkiler

### 10.2. A-03 Mobile velocity

Neden once:

- mobile / web scope dengesini etkiler

### 10.3. A-06 Content-linked page value

Neden once:

- urunun farklastirma eksenini etkiler

### 10.4. A-08 Reuse retention

Neden once:

- library merkezli domain kararini etkiler

---

## 11. Varsayimlarin owner yapisi

Her varsayimin bir owner'i olmalidir.

Onerilen owner modeli:

- wedge ve positioning varsayimlari -> Product
- import/AI rolü varsayimlari -> Product + Engineering
- mobile behavior varsayimlari -> Product + Mobile
- plan ve conversion varsayimlari -> Product + Growth

Owner belirtilmeyen varsayimlar genellikle test edilmeden unutulur.

---

## 12. Varsayimlar launch gate'leri nasil etkiler?

Tum varsayimlar ayni launch seviyesinde kritik degildir.

### 12.1. Gate B etkileyen varsayimlar

- A-07 AI rolü
- A-02 price visibility davranisi

### 12.2. Gate C etkileyen varsayimlar

- A-03 mobile velocity
- A-08 reuse retention
- A-09 editor role ihtiyaci

### 12.3. Gate D ve büyüme etkileyen varsayimlar

- A-01 wedge
- A-05 plan sadeligi
- A-06 content page value
- A-10 web-first consumption

---

## 13. Varsayim ile karar arasindaki fark

Bu belge şu ayrımı zorunlu kilar:

- **Karar**: bugun uygulanacak yön seçimi
- **Varsayim**: bu yönün neden doğru olacagina dair test edilmesi gereken tez

Ornek:

- Karar: fitness ile basliyoruz
- Varsayim: fitness retention ve tekrar kullanim icin en dogru ilk wedge'dir

Bu ayrim korunmazsa ekip, geçici kararları "dogrulanmis gercek" gibi yorumlar.

---

## 14. Bu belge sonraki belgelere ne emreder?

1. `114-internal-test-plan.md` en yuksek etkili varsayimlar icin test oturumlari tanimlamalidir
2. `28-subscription-and-plan-model.md` plan sadeligi varsayimini olcum planina baglamalidir
3. `53-creator-mobile-screen-spec.md` mobile velocity varsayimini destekleyecek akislari öne almalidir
4. `115-launch-transition-plan.md` launch sonrasi ilk 30 gunde hangi varsayimlarin yeniden olculecegini yazmalidir

---

## 15. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- ekip hangi cümlelerin veri, hangilerinin varsayim oldugunu acikca ayirabiliyorsa
- varsayimlarin test yolu ve invalidation trigger'i netse
- yanlislanan varsayimlar belge setine geri baglanabiliyorsa
- roadmap, test edilmemis varsayimlari "kesin gercek" gibi taşımıyorsa

Bu belge basarisiz sayilir, eger:

- varsayimlar gizli kalirsa
- test planina baglanmadan kararlar kesinlesirse
- yanlislanan varsayimlar belge revizyonu tetiklemezse

Bu nedenle bu belge, projenin hangi kararlarinin veriyle, hangilerinin simdilik mantikli ama test edilmesi gereken tezlerle ayakta durdugunu görünür hale getirir.
