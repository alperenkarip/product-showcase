---
id: ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
title: Roles, Permissions and Ownership Model
doc_type: domain_security
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - DOMAIN-MODEL-001
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
  - CREATOR-WORKFLOWS-001
blocks:
  - AUTH-IDENTITY-SESSION-MODEL
  - API-CONTRACTS
  - SUPPORT-PLAYBOOKS
  - PRIVACY-DATA-MAP
---

# Roles, Permissions and Ownership Model

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde kimlerin hangi kaynaklar uzerinde hangi aksiyonlari yapabilecegini, owner kavraminin neden teknik account'tan ayri dusunulmesi gerektigini, editor rolu ve ic rollerin hangi sinirlarda tutulacagini, ownership transfer ve recovery gibi hassas durumlarin nasil yonetilecegini ve permission kararinin hangi katmanlarda verilecegini tanimlayan resmi authorization ve ownership belgesidir.

Bu belge su sorulara cevap verir:

- Owner tam olarak nedir, user hesabindan farki nedir?
- Editor neyi yapabilir, neyi yapamaz?
- Support ve ops/admin neden "arka kapi owner" olamaz?
- Permission karari hangi sirayla verilir?
- Publish, delete, ownership transfer ve account deletion neden ayni agirlikta degildir?
- Auditlenmeyen yardim veya gizli impersonation neden kabul edilemez?

Bu belge, yalnizca rol listesi degildir.  
Bu belge, urunun guven, destek, isletim ve veri sahipligi duzenini tasiyan ana policy'dir.

---

## 2. Bu belge neden kritiktir?

Bu urunde hata yapmaya en acik alanlardan biri authorization katmanidir.

Yanlis permission modeli su sorunlari dogurur:

- editor, owner gibi davranmaya baslar
- support gizli admin gibi icerik degistirir
- ownership recovery kaosa doner
- delete, publish ve domain degisikligi ayni agirlikta ele alinir
- audit izi olmayan operasyonlar guven problemi yaratir

Ozellikle bu urun creator-first oldugu icin, "hesap kimin?" ve "kim kimin adina ne yapabilir?" sorusu sadece security konusu degil, ayni zamanda trust ve support maliyeti konusudur.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` owner-first, resource-scoped ve audit-zorunlu bir permission modeli kullanir; editor yalnizca curation ve operasyonel hazirlik alaninda yetkilidir, support ve ops/admin ise owner'in yerine gecen gizli roller degil, sinirli ve kayitli break-glass actor'leridir.

Bu karar su sonuclari dogurur:

1. Tek bir storefront veya account icin tek owner source of truth'u vardir.
2. Editor launch fazinda publish, billing, handle/domain, ownership transfer ve account deletion yapamaz.
3. Support'in "yardim etmek icin" sessizce icerik yayina almasi kabul edilmez.
4. Ops/admin abuse veya guvenlik gerekcesiyle erisim kesebilir; ama keyfi olarak creator content'ini yeniden yazamaz.
5. Permission karari yalnizca role bakilarak verilmez; resource ownership ve action sensitivity birlikte degerlendirilir.

---

## 4. Tasarim ilkeleri

### 4.1. User ile owner ayni kavram degildir

`User`, teknik auth hesabidir.  
`Owner`, belirli storefront/account primitive'inin nihai yetki sahibidir.

Bir user:

- bir storefront'un owner'i olabilir
- baska bir storefront'ta editor olabilir
- hicbir storefront'ta yetkili olmayabilir

### 4.2. Tek owner ilkesi

Launch kapsami icinde her account / storefront icin tam olarak bir owner vardir.

Bu ilke sunlari engeller:

- iki owner'in sessizce catismasi
- domain ve billing gibi kritik alanlarda belirsizlik
- support'un "hangisine inanalim?" sorunu

### 4.3. Least privilege zorunludur

Bir rol, yalnizca isini yapmak icin gerekli minimum yetkiye sahip olur.

Ornek:

- editor urun ekleyebilir
- ama billing degistiremez
- support account'a bakabilir
- ama content publish edemez

### 4.4. Action sensitivity rolden bagimsizdir

Ayni actor farkli aksiyonlarda farkli hassasiyet seviyeleri ile karsilasir.

Ornek:

- product title duzeltmek ile
- handle degistirmek
- ownership transfer yapmak

ayni agirlikta degildir.

### 4.5. Audit izi olmayan yardim yoktur

Internal roller:

- neye bakti
- neyi degistirdi
- neden degistirdi

sorularinin cevabini birakmak zorundadir.

### 4.6. Gizli impersonation yasaktir

Support veya ops tarafinda "owner gibi sisteme girip bir seyleri duzelttik" yaklasimi launch modelinde kabul edilmez.

Gerekirse:

- scoped support action
- explicit reason code
- audit event
- owner notification

zorunludur.

---

## 5. Principal modelleri

Bu urunde permission kararina giren principal aileleri asagidadir.

### 5.1. Owner

Owner, belirli bir creator account / storefront primitive'inin nihai otoritesidir.

Owner'in sorumluluklari:

- public yayin kararlari
- domain ve handle sahipligi
- billing ve plan kararlari
- collaborator davetleri ve iptalleri
- account deletion veya ownership transfer gibi geri donusu agir aksiyonlar

### 5.2. Editor

Editor, owner adina curation ve operasyonel hazirlik yapabilen sinirli collaborator roldur.

Editor'in tipik gorevleri:

- product import
- verification/correction yardimi
- shelf ve content page hazirlama
- placement duzenleme
- draft uretme

Editor'in yapamayacaklari:

- publish/unpublish
- account deletion
- billing degisikligi
- domain veya handle degisikligi
- collaborator yonetimi
- ownership transfer

### 5.3. Support

Support actor'u, kullanici sorunlarini anlamak ve standart cozum akislarini yurutecek sinirli internal roldur.

Support'in gorevleri:

- issue triage
- goruntuleme ve tanilama
- belirli safe operasyonlar
- recovery flow baslatma veya owner'a rehberlik etme

Support'in yapamayacaklari:

- creator adina icerik publish etmek
- gizli edit yapmak
- owner karari gerektiren alanlarda tek tarafli aksiyon almak

### 5.4. Ops / Admin

Ops/Admin rolu, sistem sagligi, guvenlik, abuse ve operasyonel denge icin vardir.

Yetkileri:

- abuse block
- merchant/domain safety enforcement
- incident response
- queue veya job-level operasyonlar
- policy kaynakli gecici erisim kisitlari

Sinirlari:

- keyfi public content duzenleme yok
- owner yerine editorial karar verme yok
- billing veya ownership karari adina tek tarafli hareket yok

### 5.5. System Worker

Background job, webhook consumer veya scheduled refresh gibi sistem aktorleri de principal olarak ele alinmalidir.

Kurallar:

1. System worker yalnizca servis-kapsamli yetki ile calisir.
2. User-facing permission'larin yerine gecmez.
3. Yaptigi kritik mutasyonlar auditlenir.

---

## 6. Resource hiyerarsisi

Permission karari, resource tipine gore verilir.  
Her sey tek "project" kaynagi gibi ele alinmaz.

### 6.1. Account-level kaynaklar

- user account
- user settings
- subscription/plan
- billing profile

### 6.2. Creator presence kaynaklari

- creator profile
- storefront
- appearance/template binding
- custom domain
- handle

### 6.3. Publication kaynaklari

- shelf
- content page
- draft/preview state
- placements

### 6.4. Library kaynaklari

- product
- product source
- verification state
- import correction state

### 6.5. Collaboration kaynaklari

- invite
- editor membership
- transfer request

### 6.6. Governance kaynaklari

- audit log
- support case
- abuse case
- takedown state

---

## 7. Permission karar zinciri

Her write veya hassas read aksiyonu asagidaki sira ile degerlendirilir:

1. authentication
2. principal resolution
3. role membership
4. resource ownership or membership check
5. action sensitivity check
6. state constraint check
7. audit requirement check
8. execution

Bu zincirde bir katman basarisizsa aksiyon tamamlanmaz.

### 7.1. Authentication

Request'i yapan actor kim?

- owner/editor session'i mi?
- support veya ops console session'i mi?
- system worker mi?

### 7.2. Principal resolution

User hangi storefront/account baglaminda hareket ediyor?

Ozellikle multi-workspace gelecegi icin bu adim rolden ayridir.

### 7.3. Membership / ownership

Actor:

- owner mi?
- editor mu?
- internal support mu?

Ve bu actor ilgili kaynaga bagli mi?

### 7.4. Action sensitivity

Aksiyonun agirligi nedir?

- `read_product` ile `transfer_ownership` ayni degildir
- `edit_draft_page` ile `delete_account` ayni degildir

### 7.5. State constraint

Kaynak durumu aksiyona izin veriyor mu?

Ornek:

- suspended account publish edemez
- archived product yeni placement'e eklenemez, once restore gerekebilir
- pending transfer varken ikinci transfer baslatilamaz

### 7.6. Audit requirement

Bu aksiyon icin:

- reason code
- actor id
- before/after snapshot
- notification

gerekiyor mu?

Kritik aksiyonlarda evet.

---

## 8. Hassasiyet seviyeleri

Permission modeli, aksiyonlari hassasiyet gruplarina ayirir.

### 8.1. S0 - dusuk riskli operasyonlar

Ornek:

- draft title guncelleme
- placement sirasi degistirme
- library search

### 8.2. S1 - urunsel etkisi yuksek ama geri donulebilir operasyonlar

Ornek:

- product verification
- page draft duzenleme
- product archive
- page unpublish

### 8.3. S2 - public etki veya guven etkisi yuksek operasyonlar

Ornek:

- publish
- restore
- takedown release
- disclosure veya visible trust state degisikligi

### 8.4. S3 - ownership ve hesap etkisi yuksek operasyonlar

Ornek:

- billing degisikligi
- domain baglama/cozme
- collaborator davet/iptal
- ownership transfer
- account deletion

Kural:

Launch'ta S2 ve S3 aksiyonlari owner disinda baska bir external role'a verilmez.

---

## 9. Yetki matrisi

Asagidaki tablo launch davranisinin resmi kaydidir.

| Aksiyon | Owner | Editor | Support | Ops/Admin | System Worker |
| --- | --- | --- | --- | --- | --- |
| Library ve page verisini goruntuleme | Evet | Evet | Scopeli | Scopeli | Gerekli ise |
| Product import baslatma | Evet | Evet | Hayir | Hayir | Job execute eder |
| Product verification / correction | Evet | Evet | Hayir | Hayir | Hayir |
| Draft shelf/content page olusturma | Evet | Evet | Hayir | Hayir | Hayir |
| Draft duzenleme | Evet | Evet | Hayir | Hayir | Hayir |
| Publish / unpublish | Evet | Hayir | Hayir | Hayir | Hayir |
| Page archive / restore | Evet | Hayir | Hayir | Abuse lock disinda Hayir | Hayir |
| Product archive / restore | Evet | Evet, archive sinirli | Hayir | Hayir | Hayir |
| Hard delete product/page | Evet, guardli | Hayir | Hayir | Hayir | Purge job uygular |
| Handle degistirme | Evet | Hayir | Hayir | Auditli yardim | Hayir |
| Custom domain baglama/cozme | Evet | Hayir | Hayir | Auditli yardim | Hayir |
| Billing/plan degistirme | Evet | Hayir | Hayir | Hayir | Webhook uygular |
| Editor davet etme / cikarma | Evet | Hayir | Hayir | Hayir | Hayir |
| Ownership transfer baslatma | Evet | Hayir | Hayir | Recovery proseduru ile yardimci | Hayir |
| Account deletion isteme | Evet | Hayir | Hayir | Hayir | Deletion workflow uygular |
| Support case notu ekleme | Hayir | Hayir | Evet | Evet | Hayir |
| Abuse block / takedown | Hayir | Hayir | Hayir | Evet | Policy job uygular |
| Raw audit log export | Owner scope disi Hayir | Hayir | Sinirli | Evet | Hayir |

Tablodaki "scopeli" ifadesi sunu ifade eder:

- support veya ops tum sistemi rastgele gezmez
- vaka, owner veya incident baglami gerekir

---

## 10. Owner davranis kurallari

### 10.1. Nihai public karar sahibi

Owner:

- neyin yayinlanacagina
- hangi route ile yayinlanacagina
- hangi editor'lerin erisecegine
- domain ve handle tercihlerine

nihai olarak karar verir.

### 10.2. Re-auth gerektiren owner aksiyonlari

Asagidaki aksiyonlarda mevcut session yeterli sayilmaz; ek kimlik teyidi gerekir:

- account deletion onayi
- ownership transfer
- billing profile kritik degisiklikleri
- custom domain unlink gibi etkisi buyuk operasyonlar

### 10.3. Owner notification zorunlulugu

Asagidaki olaylar owner'a bildirimsiz gecemez:

- editor daveti kabul edildi
- editor erisimi kaldirildi
- domain degisikligi oldu
- support recovery flow baslatti
- ops/admin tarafindan abuse veya safety blok uygulandi

---

## 11. Editor davranis kurallari

### 11.1. Editor rolu neden vardir?

Bu urunde editor, owner'in yerine gecmek icin degil, tekrarli curation maliyetini azaltmak icin vardir.

### 11.2. Editor'un izinli alanlari

Editor:

- yeni urun ekleyebilir
- mevcut urunleri duzenleyebilir
- verification surecine yardim edebilir
- shelf ve content page draft'lari hazirlayabilir
- placement'lari organize edebilir

### 11.3. Editor'un yasak alanlari

Editor:

- publish edemez
- unpublish edemez
- owner profile ayarlarini degistiremez
- domain / billing / handle alanina giremez
- ownership transfer baslatamaz
- account deletion isteyemez

### 11.4. Neden publish editor'e verilmez?

Launch fazinda publish karari:

- public trust
- disclosure gorunurlugu
- route / SEO etkisi
- markasal sahiplik

tasidigi icin owner'da tutulur.

Granular collaboration gelecekte acilabilir.  
Ama bu belge degismeden sessizce acilmaz.

---

## 12. Support ve ops sinirlari

### 12.1. Support ne yapabilir?

Support:

- issue'yu goruntuler
- import/job durumunu inceler
- standard recovery akisini baslatir
- editor invite'i tekrar gonderme gibi guvenli yardimlar yapabilir

### 12.2. Support ne yapamaz?

Support:

- public content'i creator adina degistiremez
- publish edemez
- delete edemez
- owner onayi olmadan account recovery'yi tamamlayamaz

### 12.3. Ops/Admin ne yapabilir?

Ops/Admin:

- abuse veya fraud durumunda public erisimi dondurabilir
- riskli domain veya merchant path'lerini bloklayabilir
- queue, worker, import ve system sagligini yonetebilir

### 12.4. Ops/Admin ne yapamaz?

Ops/Admin:

- creator style veya curation tercihini keyfi degistiremez
- content'i owner yerine rewrite edemez
- ownership'i sessizce devredemez

### 12.5. Break-glass kuralı

Internal actor'lerin normal permission sinirlarini gecen her aksiyon:

- reason code
- actor id
- vaka / incident referansi
- owner notification

ile birlikte kaydedilir.

---

## 13. Collaboration, invite ve membership lifecycle'i

### 13.1. Invite olusturma

Yalnizca owner editor daveti olusturabilir.

Asgari bilgiler:

- invite edilen e-posta
- hedef storefront/account
- rol
- expiration

### 13.2. Invite kabul

Invite kabul edildiginde:

- membership kaydi olusur
- owner'a bildirim gider
- editor session'i ilgili workspace baglami ile acilir

### 13.3. Invite expiry

Suresi dolan invite:

- tekrar kullanilamaz
- sessizce aktif editor'e donusmez
- gerekiyorsa owner tarafindan yeniden uretilir

### 13.4. Membership iptali

Owner editor erisimini kaldirdiginda:

- yeni mutasyon aninda engellenir
- aktif session'lar makul sure icinde invalidate edilir
- audit kaydi yazilir

---

## 14. Ownership transfer ve recovery

### 14.1. Normal ownership transfer

Normal akis:

1. Mevcut owner transfer baslatir.
2. Hedef kullanici belirlenir.
3. Kritik etkiler acikca gosterilir.
4. Re-auth yapilir.
5. Hedef taraf kabul eder.
6. Transfer tamamlanir ve auditlenir.

Transferin etkiledigi alanlar:

- storefront owner pointer
- billing sorumlulugu
- collaborator yonetimi
- handle/domain yetkisi

### 14.2. Recovery kaynakli transfer

Owner hesabina erisim kaybedildiginde:

- support tek basina transfer tamamlayamaz
- identity proof ve standard recovery proseduru gerekir
- ops/admin yardimi auditli olur

### 14.3. Orphaned storefront yasagi

Hicbir anda owner'siz aktif storefront kalamaz.

Transfer:

- atomik tamamlanir
- ya eski owner kalir
- ya yeni owner aktiflesir

Ara durumda belirsizlik olmaz.

---

## 15. Delete, archive ve permission iliskisi

Authorization modeli, lifecycle kavramlarini net ayirmak zorundadir.

### 15.1. Archive

- daha dusuk riskli
- cogu durumda owner
- product seviyesinde editor'e kisitli alan acilabilir

### 15.2. Unpublish

- public etkisi oldugu icin owner aksiyonudur

### 15.3. Delete

- geri donusu agir veya sinirli oldugu icin owner + guardrail aksiyonudur

### 15.4. Account deletion

- en yuksek hassasiyet seviyesidir
- yalnizca owner baslatir
- editor ve support baslatamaz

---

## 16. Audit ve gozlenebilirlik kurallari

Asagidaki olaylar audit event uretmek zorundadir:

- login ve principal resolution
- role grant / revoke
- invite create / accept / expire
- publish / unpublish
- delete / restore / archive
- handle/domain degisiklikleri
- ownership transfer
- internal support/ops mutation'lari

Kritik event'lerde asgari alanlar:

- actor type
- actor id
- target type
- target id
- action
- before state summary
- after state summary
- reason code
- timestamp

---

## 17. Failure ve edge-case senaryolari

### 17.1. Editor erisimi iptal edildi ama oturum acik

Beklenen davranis:

- yeni write aksiyonlari aninda reddedilir
- mevcut ekran stale permission uyarisi verir
- session kisa sure icinde invalidate edilir

### 17.2. Owner ve editor ayni draft'i duzenliyor

Beklenen davranis:

- optimistic concurrency veya revision guard devreye girer
- editor owner'in kritik publish kararini override edemez

### 17.3. Support bir seyi duzeltmek istiyor

Beklenen davranis:

- support ya safe built-in action kullanir
- ya owner'a yonlendirme yapar
- "arka planda duzeltiverdik" davranisi yasaktir

### 17.4. Abuse nedeniyle storefront kapatildi

Beklenen davranis:

- ops/admin public erisimi dondurur
- owner'a neden bildirilir
- editorial veri sessizce silinmez

### 17.5. Pending ownership transfer varken account deletion istendi

Beklenen davranis:

- iki kritik akisin ayni anda tamamlanmasina izin verilmez
- biri iptal edilmeden digeri finalize olmaz

---

## 18. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Editor'u owner'in hafif versiyonu gibi ele almak
2. Support'e "gerekirse her seyi yapar" yetkisi vermek
3. Publish ve delete gibi aksiyonlari draft edit ile ayni agirlikta gormek
4. Ownership recovery'yi sadece support ticket cevabina indirgemek
5. Audit izi olmadan internal mutasyon yapmak
6. Resource ownership bakmadan yalnizca role gore izin vermek
7. Orphaned storefront olusmasina izin vermek

---

## 19. Bu belge sonraki belgelere ne emreder?

1. `63-auth-identity-and-session-model.md`, principal resolution, re-auth ve session invalidation davranisini bu role modeline gore derinlestirmelidir.
2. `70-api-contracts.md`, her write endpoint icin role + ownership + state check beklentisini tasimalidir.
3. `103-support-playbooks.md`, support'in ne yapip ne yapamayacagini bu belgeyle birebir uyumlu yazmalidir.
4. `90-privacy-data-map.md`, internal actor access ve audit event retention siniflarini bu permission modeline gore aciklamalidir.
5. `87-security-and-abuse-checklist.md`, privilege escalation, impersonation ve orphaned ownership testlerini icermelidir.

---

## 20. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- owner, editor, support ve ops rollerinin sinirlari birbiriyle karismiyorsa
- publish, billing, ownership transfer ve account deletion gibi aksiyonlar launch'ta yalnizca owner'da toplanmis ise
- internal actor'lerin gizli owner gibi davranmasi teknik olarak da operasyonel olarak da engelleniyorsa
- permission karari role, ownership, state ve audit gereksinimini birlikte degerlendiriyorsa

Bu belge basarisiz sayilir, eger:

- editor sessizce public degisiklik yapabiliyorsa
- support veya ops keyfi icerik mutasyonu yapabiliyorsa
- ownership recovery ve transfer akislari belirsiz kaliyor ya da support ticket yorumuna birakiliyorsa

