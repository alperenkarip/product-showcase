---
id: DATA-LIFECYCLE-RETENTION-DELETION-RULES-001
title: Data Lifecycle, Retention and Deletion Rules
doc_type: governance_policy
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DOMAIN-MODEL-001
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
  - PRICE-AVAILABILITY-REFRESH-POLICY
blocks:
  - DATABASE-SCHEMA-SPEC
  - DATA-BACKUP-RETENTION-RESTORE
  - PRIVACY-DATA-MAP
  - BACKGROUND-JOBS-SCHEDULING-SPEC
---

# Data Lifecycle, Retention and Deletion Rules

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde hangi veri ailesinin hangi state'lerden gectigini, archive / unpublish / soft delete / hard purge kavramlarinin nasil ayrildigini, her veri sinifinin ne kadar sure tutulacagini, hangi aksiyonlarda restore imkani oldugunu, hangi durumlarda geri donus olmadigini ve backup katmani ile uygulama katmani arasindaki lifecycle farkini tanimlayan resmi retention ve deletion policy belgesidir.

Bu belge su sorulara cevap verir:

- Bir page veya product archived oldugunda tam olarak ne olur?
- Soft delete ile hard purge arasindaki fark nedir?
- Import log'lari ve source snapshot'lari ne kadar tutulur?
- Account deletion gerceklestiginde hangi veri hemen gider, hangisi retention sinifinda kalir?
- Restore ne zaman mumkundur, ne zaman yasal veya policy olarak kapatilir?

Bu belge, yalnizca "silme vardir" notu degildir.  
Bu belge, urunun veri omrunu ve operasyonel geri donus sinirlarini tanimlayan source of truth'tur.

---

## 2. Bu belge neden kritiktir?

Bu urunde lifecycle hatalari dogrudan guven problemi uretir.

Ornek:

- archived page'in publicte yasamaya devam etmesi
- silindi sanilan account verisinin editor listesinde gorunmesi
- stale source'un aktif product gibi davranmasi
- purge edilmesi gereken debug payload'larin aylarca kalmasi

Ayni zamanda ters yonlu hata da tehlikelidir:

- restore edilebilir draft'i geri donusuz silmek
- audit kaydini erkenden yok etmek
- billing veya guvenlik kaydini urun verisiyle ayni retention sinifina sokmak

Bu belge bu iki ucu da engeller:

1. gereksiz veri birikimi
2. hatali erken veri kaybi

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icinde veri yasam dongusu entity tipine gore farklilasir; publicten cekme, arsivleme, uygulama-seviyesi soft delete, policy-seviyesi purge ve backup-level retention birbirine karistirilmaz; restore imkani yalnizca acikca izin verilen siniflarda vardir.

Bu karar su sonuclari dogurur:

1. `unpublish`, `archive`, `soft_delete` ve `purge` ayrik operasyonlardir.
2. Her veri ailesi ayni sure tutulmaz.
3. Uygulama verisinden silinmis olmak, backup katmanindan aninda yok olmak anlamina gelmez.
4. Account deletion sonrasinda bazi kayitlar operational olarak artik restore edilemez, backup'ta gecici olarak kalabilir.
5. Audit ve billing kayitlari creator content'i ile ayni retention sinifina sokulmaz.

---

## 4. Temel kavramlar

### 4.1. Unpublish

Yalnizca public gorunurlugu kapatir.

Ozellikleri:

- veri kaydi durur
- restore benzeri islem gerektirmez
- SEO/share etkisi vardir

### 4.2. Archive

Kaydi aktif kullanim disina alir ama domain butunlugunu ve tarihceyi korur.

Ozellikleri:

- creator-side gorulebilir
- restore edilebilir
- publicte cogu durumda gosterilmez veya controlled state'e gecer

### 4.3. Soft delete

Kaydi uygulama ana akislarindan cikarir; tombstone veya deleted state ile geri donus penceresi tanir.

Ozellikleri:

- kullanici akislari disinda tutulur
- restore penceresi vardir
- purge adimi ayri isletilir

### 4.4. Hard purge

Uygulama ana veritabanindan geri donusuz silmedir.

Ozellikleri:

- sadece policy'nin izin verdigi durumda yapilir
- referential ve audit etkisi once kontrol edilir

### 4.5. Backup retention

Uygulama verisinden kalkmis bir kaydin yedek kopyasinin, disaster recovery amaciyla gecici sure daha tutulmasidir.

Kural:

Backup'ta bulunuyor olmak, urunsel restore hakki dogurmaz.

---

## 5. Veri aileleri ve retention siniflari

Bu urunde veri aileleri asagidaki retention siniflari ile yonetilir.

| Sinif | Tanim | Varsayilan sure |
| --- | --- | --- |
| `R0-ephemeral` | Gecici worker/runtime verisi | 24 saat - 7 gun |
| `R1-operational-short` | Hata ayiklama ve operasyonel loglar | 30 gun |
| `R2-operational-extended` | Import kalitesi ve trend takibi icin gerekli detaylar | 180 gun |
| `R3-product-recoverable` | Restore penceresi olan urun verisi | 30 gun restore penceresi + purge |
| `R4-audit-security` | Audit, support ve security olaylari | 730 gun |
| `R5-financial-legal` | Billing ve yasal/faturalama kayitlari | 3650 gun |

Bu siniflar default'tur.  
Belge revizyonu olmadan veri ailesi keyfi olarak baska sinifa tasinmaz.

---

## 6. Entity bazli lifecycle kurallari

## 6.1. Storefront

### State modeli

- `active`
- `suspended`
- `soft_deleted`
- `purged`

### Kurallar

1. Storefront silme istegi public root'u aninda kapatir.
2. Soft-deleted storefront 30 gun boyunca recovery penceresinde tutulur.
3. Recovery penceresi sonunda storefront kaydi purge edilir.
4. Handle, purge sonrasinda bile 90 gun quarantine'de kalir.

### Neden?

Storefront:

- public kimlik
- link dagitimi
- SEO ve share izi

tasidigi icin anlik tekrar kullanima acilmamalidir.

## 6.2. Shelf ve Content Page

### State modeli

- `draft`
- `published`
- `unpublished`
- `archived`
- `soft_deleted`
- `purged`

### Kurallar

1. `unpublish`, kaydi silmez; yalnizca publicten ceker.
2. `archived` kayit creator-side'ta korunur ve restore edilebilir.
3. `soft_deleted` page 30 gun boyunca restore edilebilir.
4. `published` veya `archived` olmus page'in purge oncesi relation impact kontrolu zorunludur.
5. Purge edilen page'in preview/share cache'i de temizlenir.

## 6.3. Product

### State modeli

- `active`
- `archived`
- `soft_deleted`
- `purged`

### Kurallar

1. Product aktif placement tasirken purge edilemez.
2. Product silme istegi once etki analizi sunar.
3. Product soft delete penceresi 30 gundur.
4. Product restore edildiginde historical tags, notes ve audit izi korunur.

### Not

Archived product, stale source ile ayni sey degildir.  
Biri creator karari, digeri source sagligi state'idir.

## 6.4. Product Source

### State modeli

- `active`
- `stale`
- `blocked`
- `archived`
- `purged`

### Kurallar

1. Source `stale` olabilir; bu silme sebebi degildir.
2. `blocked` source publicte cikis vermez ama historical referans korunabilir.
3. Source purge'i, product butunlugunu bozmuyorsa yapilir.
4. Source payload ve extraction artefact'lari source kaydiyla ayni sure tutulmaz; daha kisa tutulur.

## 6.5. Placement

Placement'lar page ve product arasinda baglayici oldugu icin purge'te baglamsal etkileri vardir.

Kurallar:

1. Page soft-delete oldugunda placement'lar bagli soft-delete davranisi alir.
2. Product purge olmadan once bagli placement kalmamalidir.
3. Placement historical analytics veya audit referansi gerekiyorsa tombstone summary tutulabilir.

## 6.6. Import Job

### State modeli

- `queued`
- `running`
- `succeeded`
- `failed`
- `expired`
- `purged`

### Retention

1. Job metadata ve sonuc ozeti `R2-operational-extended` sinifinda 180 gun tutulur.
2. Ham debug payload, HTML snapshot veya extractor artefact'lari `R1-operational-short` sinifinda 30 gun tutulur.
3. Gecici retry buffer ve worker temp verisi `R0-ephemeral` sinifindadir; en gec 7 gun icinde temizlenir.

## 6.7. Media ve image cache

Media icin tek tip retention uygulanmaz.

Kurallar:

1. Secilmemis import image candidate'lari 7 gun sonra purge edilir.
2. Secilmis ve aktif public yuzeyde kullanilan media, parent entity aktif oldugu surece tutulur.
3. Parent soft-delete oldugunda media da purge queue'ya girer; restore penceresi boyunca silinmez.
4. Derivative thumbnail/cache varyantlari ana asset'ten once purge edilebilir.

## 6.8. Audit ve support verisi

Audit trail:

- `R4-audit-security`
- minimum 730 gun

Support case ve reason-code loglari:

- minimum 730 gun

Gerekce:

- ownership
- abuse
- recovery
- silme/restore ihtilaflari

## 6.9. Billing ve subscription verisi

Billing olaylari, invoice referanslari ve entitlement history:

- `R5-financial-legal`
- minimum 3650 gun

Bu veriler creator content'i silinse bile hemen purge edilmez.

---

## 7. Retention takvimi

Asagidaki tablo launch icin uygulama seviyesindeki default retention takvimidir.

| Veri ailesi | Aktif durum | Restore penceresi | Purge hedefi |
| --- | --- | --- | --- |
| Storefront | aktif veya suspended | 30 gun | gun 31+ |
| Shelf / Content Page | draft/unpublished/archived | 30 gun | gun 31+ |
| Product | active/archived | 30 gun | gun 31+ ve dependency temizse |
| Product Source current state | product aktif oldugu surece | N/A | parent politikasina bagli |
| Price/availability snapshots | aktif source history | N/A | 90 gun ham, 365 gun ozet |
| Import job metadata | operational | N/A | 180 gun |
| Import raw payload | debugging | N/A | 30 gun |
| Temp worker files | ephemeral | N/A | 24 saat - 7 gun |
| Selected media | parent aktifligi boyunca | parent restore penceresi kadar | parent purge sonrasi |
| Audit/support logs | governance | restore kavrami yok | 730 gun |
| Billing records | legal/finance | restore kavrami yok | 3650 gun |

Buradaki "gun 31+" ifadesi, otomatik purge job'un ilk uygun calisma penceresini ifade eder.  
Anlik midnight hard delete zorunlu degildir; ama retention penceresi asilmamalidir.

---

## 8. Delete akislarinin resmi davranisi

## 8.1. Product delete

Normal akis:

1. Owner delete aksiyonunu baslatir.
2. Sistem bagli placement, source ve public etkiyi gosterir.
3. Aktif placement varsa once ayirma/arsivleme istenir.
4. Product `soft_deleted` olur.
5. 30 gun sonunda bagli engel yoksa purge edilir.

Beklenen sistem davranisi:

- "sildim ama page'de duruyor" durumu olmamali
- creator'e etki alani acik gosterilmeli

## 8.2. Page delete

Normal akis:

1. Owner page'i silmek ister.
2. Sistem page'in published/unpublished/archived durumunu ve etkisini gosterir.
3. Public route aninda kapatilir.
4. Page `soft_deleted` olur.
5. Preview, SEO ve share cache temizlenir.
6. 30 gun sonra purge edilir.

## 8.3. Storefront delete

Normal akis:

1. Account/storefront deletion talebi alinir.
2. Public storefront kapanir.
3. Baqli page'ler publicten cekilir.
4. Creator data `soft_deleted` penceresine girer.
5. Handle quarantine baslar.
6. 30 gun sonra urun verisi purge edilir; audit/billing retention sinifinda kalir.

## 8.4. Account deletion

Account deletion, storefront deletion'dan daha genistir.

Kurallar:

1. Yalnizca owner baslatabilir.
2. Re-auth gerekir.
3. Editor ve support tamamlayamaz.
4. Silme talebi alininca aktif session'lar sinirlandirilir.
5. Product/content verisi 30 gunluk grace penceresine girer.
6. Grace penceresi dolduktan sonra operational restore kapatilir.

### Kritik not

Backup'ta gecici sure duran veri, kullaniciya "undelete" ozelligi olarak sunulmaz.

---

## 9. Restore kurallari

Restore, her veri icin acik degildir.

### 9.1. Restore edilebilenler

- soft-deleted storefront
- soft-deleted shelf/content page
- soft-deleted product
- archived product/page

### 9.2. Restore edilemeyenler

- purge edilmis product/page/storefront
- expired temp worker artefact'lari
- retention penceresi dolmus raw import payload'lari
- user-initiated final account deletion sonrasi operational dataset

### 9.3. Restore sonrasi kurallar

1. Restore, eski stale fiyat bilgisini otomatik "guncel" yapmaz.
2. Restore, blocked source'u tekrar aktiflestirmez.
3. Restore, takedown altindaki content'i policy kontrolu olmadan yayinlamaz.

---

## 10. Source freshness ve lifecycle iliskisi

Source lifecycle, content lifecycle ile karistirilmamali.

### 10.1. `stale`

- retention problemi degildir
- freshness problemidir

### 10.2. `blocked`

- safety veya policy problemidir
- historical relation korunabilir

### 10.3. `archived`

- creator veya system karariyla operasyonel aktiflikten cikmistir

### 10.4. `purged`

- artik operasyonel kayit olarak tutulmaz

Bu ayrim, viewer trust davranisi icin zorunludur.

---

## 11. Backup ile uygulama deletion'i arasindaki fark

Backup stratejisi, product deletion davranisinin yerine gecmez.

Kurallar:

1. Uygulama seviyesinde `soft_deleted` olan veri hemen backup'tan cikmaz.
2. Backup'tan geri yukleme sadece disaster recovery veya kontrollu operasyon amaciyla dusunulur.
3. User-initiated final deletion sonrasi backup restore ile kullaniciya normal undelete hizmeti verilmez.
4. Backup retention, `104-data-backup-retention-and-restore.md` tarafinda bu belgeyi izleyerek operasyonel detaylandirilir.

---

## 12. Privacy, minimization ve log hijyeni

Retention politikasi yalnizca "ne kadar sakliyoruz?" sorusu degildir; "gereksiz neyi hic saklamiyoruz?" sorusunu da kapsar.

Kurallar:

1. Import raw payload'lari sonsuza kadar tutulmaz.
2. Temp HTML/image snapshot'lari kalite debug islevi bittiğinde purge edilir.
3. Log'larda gereksiz PII zenginlestirme yapilmaz.
4. Support notlari issue cozumuyle ilgisiz kisisel veri biriktirme alani olamaz.

---

## 13. Failure ve edge-case senaryolari

### 13.1. Product delete edildi ama aktif page referansi var

Beklenen davranis:

- delete akisi finalize olmaz
- once placement etkisi cozulur

### 13.2. Original content silindi ama content page degeri suruyor

Beklenen davranis:

- page otomatik hard delete olmaz
- controlled archived veya notice state'e gecirilebilir

### 13.3. Account deletion grace period'unda owner vazgecti

Beklenen davranis:

- operational restore mumkundur
- public root geri acilabilir
- audit trail korunur

### 13.4. Abuse takedown ve user deletion cakisti

Beklenen davranis:

- public erisim once policy geregi kapali kalir
- deletion takvimi audit/security retention'i silmez

### 13.5. Purge job basarisiz oldu

Beklenen davranis:

- kayit "sonsuz soft-delete" durumunda unutulmaz
- retry ve ops alert uretilir

### 13.6. Backup restore sonrasi eski fiyatlar geri geldi

Beklenen davranis:

- restored source current-state yerine freshness/policy katmani yeniden degerlendirilir
- outdated fiyat publice dogrudan acilmaz

---

## 14. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Unpublish, archive ve delete'i ayni sey saymak
2. Her veri ailesine tek retention suresi uygulamak
3. Import raw payload'larini sinirsiz saklamak
4. Product silinince bagli page/placement etkisini yok saymak
5. User-initiated final deletion sonrasi backup restore'u normal urun ozelligi gibi sunmak
6. Billing ve audit kayitlarini urun verisiyle ayni retention sinifina koymak
7. Restore sonrasi stale/blocked trust state'lerini sifirlamis gibi davranmak

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `71-database-schema-spec.md`, entity state ve tombstone alanlarini bu belgeyle uyumlu modellemelidir.
2. `72-background-jobs-and-scheduling-spec.md`, purge, cleanup ve retention enforcement job'larini bu takvime gore kurmalidir.
3. `104-data-backup-retention-and-restore.md`, backup restore semantigini uygulama-level restore ile karistirmayacak sekilde yeniden yazilmalidir.
4. `90-privacy-data-map.md`, veri ailelerini bu retention siniflariyla birebir eslemelidir.
5. `84-cross-platform-acceptance-checklist.md`, archive/delete/restore davranisini her yuzeyde test etmelidir.

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- entity bazli lifecycle durumu net sekilde ayrisiyorsa
- restore edilebilir veri ile geri donusuz purge edilen veri karismiyorsa
- retention sureleri operasyonel olarak uygulanabilir ve auditlenebilir ise
- backup ile urun-seviyesi restore beklentisi ayrik tutuluyorsa

Bu belge basarisiz sayilir, eger:

- creator veya support "hangi veri ne zaman gider?" sorusuna net cevap veremiyorsa
- silinmis oldugu sanilan veri publicte gorunmeye devam ediyorsa
- operational log ve debug payload retention'i kontrolsuz buyuyorsa

