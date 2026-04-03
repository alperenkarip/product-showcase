---
id: SUPPORT-PLAYBOOKS-001
title: Support Playbooks
doc_type: support_operations_spec
status: ratified
version: 2.0.0
owner: support-operations
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PERSONAS-JOBS-PRIMARY-USE-CASES-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
  - REPORTING-TAKEDOWN-ABUSE-POLICY-001
  - RUNBOOKS-001
blocks:
  - RELEASE-READINESS-CHECKLIST
---

# Support Playbooks

## 1. Bu belge nedir?

Bu belge, `product-showcase` icinde en sik creator ve viewer destek taleplerinin nasil siniflandirilacagini, support'un hangi bilgiye bakacagini, hangi aksiyonlari kendi basina yapabilecegini, hangi durumlarda ops/compliance/engineering'e escalation gerektigini ve kullaniciya nasil cevap verilmesi gerektigini tanimlayan resmi support operasyon belgesidir.

Bu belge su sorulara cevap verir:

- "Urun cekilemedi" ticket'i geldiginde support ilk hangi kayitlara bakar?
- Wrong image ile stale price sikayeti ayni issue family midir?
- Support neyi duzeltebilir, neyi sadece aciklayabilir?
- Unsafe link veya takedown benzeri raporlar nasil farkli ele alinir?
- Creator'a hangi dilde, hangi netlikte cevap verilir?

---

## 2. Bu belge neden kritiktir?

Bu urunde support yalnizca "ticket kapatan" fonksiyon degildir.  
Support, creator guveninin son hattidir.

Destek akisi zayif olursa:

1. teknik jargon creator'i yorar
2. ayni issue farkli support agent'lerinde farkli isimlendirilir
3. unsafe link gibi ciddi sorunlar siradan hata gibi ele alinir
4. support, ops yetkisine girmemesi gereken aksiyonlari denemeye baslar

Bu belge support'u bir call center script'i degil, urun-semantic playbook haline getirir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Support `product-showcase` icinde teknik kok nedeni tahmin ederek dogaçlama hareket etmez; issue'yu standart issue family'lerinden birine oturtur, gerekli kaniti toplar, creator'a "neden oldu / ne yapabilirsin / biz ne yapiyoruz" ayrimini net anlatir ve riskli teknik veya policy aksiyonlarini ops/compliance zincirine eskale eder.

Bu karar su sonuclari dogurur:

1. Support sessiz state mutation yapmaz.
2. Her sikayet issue family + severity + next action ile kayda girer.
3. Creator yanitlari tutarli ve jargon-siz olur.

---

## 4. Support actor modeli

Bu proje icin support iki ana kullanici grubu ile muhatap olur:

1. creator owner/editor
2. public viewer veya raporlayan kisi

### 4.1. Creator issue'lari

Genelde su ailelerden gelir:

- import sonucu
- wrong image / wrong merchant
- price/trust row
- broken link
- duplicate product
- page visibility
- billing/ownership

### 4.2. Viewer/third-party issue'lari

Genelde su ailelerden gelir:

- unsafe link
- yanlis urun / yaniltici page
- takedown / trademark
- kaldirilmis veya bozuk content

---

## 5. Support'un gorebilecegi veri ve sinirlar

Support asgari su okuma yetkilerine sahip olabilir:

1. import job summary
2. product/source trust state summary
3. page publication state
4. invite / membership high-level state
5. issue/audit gecmisi

Support'un gormemesi gerekenler:

1. raw secret'lar
2. break-glass credential'lar
3. masked olsa bile gereksiz payment detaylari
4. destructive ops controls

Kural:

Support, ihtiyaci oldugu kadar gorur; ops/admin break-glass araci gibi davranmaz.

---

## 6. Standart issue family'leri

Her talep asgari bir issue family ile etiketlenir:

1. `IMPORT_NOT_FETCHED`
2. `WRONG_IMAGE`
3. `PRICE_MISSING_OR_STALE`
4. `BROKEN_OR_BLOCKED_LINK`
5. `DUPLICATE_PRODUCT`
6. `PAGE_UNPUBLISHED_OR_REMOVED`
7. `OWNERSHIP_OR_BILLING`
8. `UNSAFE_OR_ABUSIVE_CONTENT`

Kural:

`other` kovasi varsayilan issue family olamaz.  
Yeni issue ailesi gerekiyorsa dokuman guncellenir.

---

## 7. Her issue icin toplanacak zorunlu alanlar

Support ticket veya report kaydinda asgari su alanlar bulunur:

1. issue family
2. etkilenen creator/workspace veya public URL
3. merchant host varsa
4. product/page reference varsa
5. ilk gorulen zaman
6. user-facing etki
7. tekrar ediyor mu bilgisi
8. support'un verdigi yanit ozeti

Opsiyonel ama yararli alanlar:

- import job id
- screenshot veya URL
- device/platform

---

## 8. Standart cevaplama ilkeleri

Support cevabinda su ayrim net olmalidir:

1. ne oldu
2. kullanici ne yapabilir
3. bizim tarafta ne yapilacak

### 8.1. Dil ilkeleri

1. teknik jargonla creator'i bogma
2. suclayici dil kullanma
3. belirsizlik varsa "incelemedeyiz" de, uydurma sebep yazma
4. policy bloklarinda beklenti yonetimini acik yap

### 8.2. Yasak kaliplar

1. "sizde sorun yoktur herhalde"
2. "biraz bekleyin belki duzelir"
3. "sistem bazen boyle yapabiliyor"

---

## 9. Triage akisi

Support triage su sirayla ilerler:

1. issue family belirle
2. user harm / unsafe risk var mi bak
3. ilgili import/page/source summary'yi bul
4. standart self-serve veya support-allowed aksiyon var mi kontrol et
5. escalation gerekiyor mu karar ver

Kural:

Unsafe veya compliance etkili ailelerde support tek basina closure vermez.

---

## 10. Playbook 1: `IMPORT_NOT_FETCHED`

### 10.1. Tipik semptom

- "urun cekilemedi"
- "linki yapistirdim ama ilerlemedi"
- "surekli isleniyor gibi gorunuyor"

### 10.2. Support kontrol listesi

1. import job id veya son import kaydini bul
2. status `blocked`, `failed`, `needs_review`, `expired` hangisi ayir
3. failure code var mi bak
4. merchant host ve target context'i kontrol et

### 10.3. Creator'a yanit cizgisi

- eger `blocked` ise neden tipi acikca anlat
- eger `needs_review` ise review/correction yolunu goster
- eger `failed` teknik ariza ise tekrar deneme veya bizim takip edecegimiz yol yaz

### 10.4. Support-allowed aksiyonlar

- review ekranina yonlendirme
- bilinen self-serve retry onerisi
- status aciklamasi

### 10.5. Escalation tetikleri

- ayni merchant'ta tekrar eden pattern
- `P0` queue/backlog supheleri
- wrong-product/wrong-image cluster'i

---

## 11. Playbook 2: `WRONG_IMAGE`

### 11.1. Tipik semptom

- "yanlis gorsel geldi"
- "urun yerine banner gorunuyor"
- "yanlis renk/varyant secilmis"

### 11.2. Support kontrol listesi

1. product ve selected image state'i bul
2. import review correction gechmisi var mi bak
3. merchant/source son refresh zamanini kontrol et

### 11.3. Creator'a yanit cizgisi

- gorselin neden otomatik sectigini tahmin etme
- duzeltme veya review akisi varsa ona yonlendir
- issue tekrarliyorsa inceleme acildigini soyle

### 11.4. Escalation tetikleri

- ayni merchant'ta birden cok wrong-image vakasi
- full-tier merchant'ta tekrar eden yanlis primary image

---

## 12. Playbook 3: `PRICE_MISSING_OR_STALE`

### 12.1. Tipik semptom

- "fiyat gorunmuyor"
- "fiyat eski gorunuyor"
- "stok bilgisi yanlis"

### 12.2. Support kontrol listesi

1. selected source state
2. freshness state
3. `price_display_state`
4. last checked timestamp

### 12.3. Creator'a yanit cizgisi

- current fiyat garantisi vermeyiz
- stale veya hidden-by-policy state'i net aciklariz
- manuel refresh veya bekleme penceresi varsa net soyleriz

### 12.4. Yasak ifade

- "sizin fiyat yanlis gorunuyor olabilir ama kullanicilar anlamaz"

### 12.5. Escalation tetikleri

- stale warning'ler kaybolduysa
- birden fazla public page ayni anda etkilendiyse

---

## 13. Playbook 4: `BROKEN_OR_BLOCKED_LINK`

### 13.1. Tipik semptom

- "link acilmiyor"
- "siteye gitmiyor"
- "link guvensiz gibi"

### 13.2. Support kontrol listesi

1. source state `blocked`, `broken`, `stale`, `active` hangisi
2. host ve redirect bilgisi
3. daha once issue var mi

### 13.3. Creator veya viewer'a yanit cizgisi

- blocked ise acikca policy/safety semantigi kullan
- broken ise teknik veya source-side bozulma oldugunu belirt
- alternatif safe action varsa yaz

### 13.4. Escalation tetikleri

- unsafe/phishing supheleri
- birden fazla ticket'ta ayni host geciyorsa

---

## 14. Playbook 5: `DUPLICATE_PRODUCT`

### 14.1. Tipik semptom

- "ayni urun iki kez olustu"
- "mevcut urune source eklemek yerine yeni kayit acildi"

### 14.2. Support kontrol listesi

1. normalized/canonical URL farki var mi
2. reuse candidate history var mi
3. variant ambiguity notu var mi

### 14.3. Support davranisi

- otomatik merge sozu verme
- reuse/merge incelemesini ops/product tarafina tasima
- creator'a mevcut gecici cozum yolunu anlatma

### 14.4. Escalation tetikleri

- full-tier merchant'ta tekrar eden duplicate
- ayni merchant'ta tracking URL pattern'i artisi

---

## 15. Playbook 6: `PAGE_UNPUBLISHED_OR_REMOVED`

### 15.1. Tipik semptom

- "sayfa acilmiyor"
- "content page kaldirildi"
- "storefront yok oldu"

### 15.2. Support kontrol listesi

1. publication state
2. archive/soft delete bilgisi
3. custom domain/canonical degisimi var mi

### 15.3. Support davranisi

- draft/unpublished/removed state'leri karistirma
- creator'a restore veya publish akisi varsa net anlat
- viewer'a uygun fallback mesajini kullan

### 15.4. Escalation tetikleri

- yayinli cok sayida sayfa aniden kaybolduysa
- custom domain genel issue varsa

---

## 16. Playbook 7: `OWNERSHIP_OR_BILLING`

### 16.1. Tipik semptom

- "editor olarak billing goremedim"
- "odeme yaptim ama ozellik acilmadi"
- "ownership transfer olduktan sonra erisim bozuldu"

### 16.2. Support kontrol listesi

1. role ve owner/editor status
2. billing state summary
3. checkout bridge pending mi
4. webhook veya entitlement issue sinyali var mi

### 16.3. Support davranisi

- owner-only alanlarda yetki cizgisini net anlat
- checkout basarisi = aninda access mantigini kurma
- entitlement veya ownership truth'u support ekranindan netlesenemiyorsa ops/billing escalation'ini hemen baslat

### 16.4. Escalation tetikleri

- entitlement drift
- role escalation supheleri
- ownership recovery talebi

---

## 17. Playbook 8: `UNSAFE_OR_ABUSIVE_CONTENT`

### 17.1. Tipik semptom

- unsafe link bildirimi
- trademark sikayeti
- abusive storefront report

### 17.2. Support davranisi

1. hizli issue siniflama
2. kanit alanlarini toplama
3. gecici kisit ihtiyacini ops/compliance zincirine aktarma
4. kullaniciya inceleme acildigini net söyleme

### 17.3. Yasak davranis

- support'un tek basina "uygunsuz degil" diye closure vermesi

---

## 18. Support'un yapamayacagi aksiyonlar

Support asla sunlari yapmaz:

1. policy block'u kaldirmak
2. creator adina import apply etmek
3. entitlement state'ini elle acmak
4. owner transferi tamamlamak
5. domain verify edilmeden aktif saymak

Bu aksiyonlar ops/compliance/engineering cizgisindedir.

---

## 19. Escalation matrisi

| Issue family | Birincil eskalasyon | Ikincil eskalasyon |
| --- | --- | --- |
| IMPORT_NOT_FETCHED | ops/import | engineering |
| WRONG_IMAGE | import/product | ops |
| PRICE_MISSING_OR_STALE | ops/trust | product |
| BROKEN_OR_BLOCKED_LINK | ops/safety | compliance |
| DUPLICATE_PRODUCT | product/import | engineering |
| PAGE_UNPUBLISHED_OR_REMOVED | web/product | ops |
| OWNERSHIP_OR_BILLING | billing/ops | security/compliance |
| UNSAFE_OR_ABUSIVE_CONTENT | compliance/ops | security |

---

## 20. Support macro yazim ilkeleri

1. Ne oldu, ne yapabilirsin, biz ne yapiyoruz ayrimi korunur.
2. Belirsiz teknik sebep kesinmis gibi sunulmaz.
3. Policy bloklarinda net ve sakin dil kullanilir.
4. Viewer ve creator dil tonu farkli olabilir; ama ikisi de jargon-sizdir.

---

## 21. Anti-pattern'ler

Bu belgede acikca yasaklanan yaklasimlar:

1. Support'un kok nedeni tahmin ederek yanlis bilgi vermesi
2. Ayni issue family icin agent bazli farkli dil kullanimi
3. Riskli operator aksiyonlarini support'un ustlenmesi
4. Unsafe link veya trademark raporunu normal bug gibi ele almak
5. Creator'a "tekrar deneyin" demekle yetinmek

---

## 22. Bu belge sonraki belgelere ne emreder?

### 22.1. Release readiness

- launch oncesi destek issue family'leri icin macro ve escalation hatlari hazir olacak

### 22.2. Runbooks

- teknik teshis runbook'lari support'un issue family cizgisiyle uyumlu olacak

### 22.3. Incident response

- support lead rolu ve creator-facing iletisim bu belgeye dayanacak

---

## 23. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin support agent'i bir talep geldiginde "bu issue hangi aileye girer, hangi kayda bakarim, neyi aciklarim, neyi asla yapmam ve ne zaman eskale ederim?" sorularini ek aciklama istemeden cevaplayabilmelidir; creator ayni issue icin tutarsiz veya yanıltici cevap almamalidir.
