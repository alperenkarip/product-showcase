---
id: EMPTY-LOADING-ERROR-STATE-SPEC-001
title: Empty, Loading, Error and State Spec
doc_type: state_design_spec
status: ratified
version: 2.0.0
owner: design
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - CREATOR-WORKFLOWS-001
  - VIEWER-EXPERIENCE-SPEC-001
  - IMPORT-FAILURE-MODES-RECOVERY-RULES-001
blocks:
  - PUBLIC-WEB-SCREEN-SPEC
  - CREATOR-MOBILE-SCREEN-SPEC
  - CREATOR-WEB-SCREEN-SPEC
  - ADMIN-OPS-SCREEN-SPEC
---

# Empty, Loading, Error and State Spec

## 1. Bu belge nedir?

Bu belge, public, creator ve internal yuzeylerde gorulen empty, loading, processing, degraded, blocked, failed ve recovery state'lerinin dilini, gorsel agirligini, hangi durumda tam ekran state hangi durumda inline state kullanilacagini ve her state'in bir sonraki aksiyonu nasil gostermesi gerektigini tanimlayan resmi state design belgesidir.

Bu belge su sorulara cevap verir:

- Empty state ile error state neden ayni tasarlanamaz?
- Processing ve waiting durumlari ne zaman skeleton, ne zaman status paneli ister?
- `blocked`, `failed`, `needs_review`, `expired` gibi import outcome'lari UI'da nasil ayrisir?
- Public stale price warning ile creator-side stale source alert ayni dilde mi konusmali?
- Hangi state full-screen, hangisi inline row, hangisi banner olmali?

Bu belge, state'leri ekrandan sonra dusunulen "son rötuş" olmaktan cikarir.

---

## 2. Bu belge neden kritiktir?

Bir urun yalniz happy path ile kullanilmaz.  
Ozellikle bu urunde:

- import bekler
- verification ister
- duplicate bulur
- stale source uyarir
- blocked domain'e carpar
- archived page ile karsilasir

State tasarimi zayif olursa:

- kullanici ne oldugunu anlamaz
- retry ile review'u karistirir
- empty state'i failure sanir
- trust warning'i gormez

Bu nedenle state spec, ana ekran spec'leri kadar kritik sayilir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> Her state, "sadece bir mesaj" degil; kullanicinin bulunduğu durumu, bunun nedenini ve bir sonraki anlamli aksiyonu gosteren tam bir UI davranisidir; empty, loading, waiting, blocked, failed ve degraded durumlar birbirinden hem copy hem gorsel agirlik olarak net sekilde ayrilir.

Bu karar su sonuclari dogurur:

1. Empty state'ler utandirici veya cezalandirici olmaz.
2. Loading state'ler indefinite spinner'a indirgenmez.
3. Import blocked ile import failed ayni kırmızı generic alert degildir.
4. Public stale price uyarisi panic error gibi davranmaz.

---

## 4. State aileleri

Bu urunde state'ler yedi ana aileye ayrilir:

1. empty
2. initial loading
3. background processing
4. review required
5. degraded but usable
6. blocked or forbidden
7. terminal failure

### 4.1. Empty

Veri yok ama sistem dogru calisiyor.

### 4.2. Initial loading

Sayfa veya ekran ilk veri yuklemesini yapiyor.

### 4.3. Background processing

Islem devam ediyor, kullanici bekliyor veya arka planda sonuc bekliyor.

### 4.4. Review required

Sistem bitirmedi; insan karari gerekiyor.

### 4.5. Degraded but usable

Bazi veri stale veya eksik, ama experience devam edebilir.

### 4.6. Blocked or forbidden

Policy, permission veya safety nedeniyle yol kapali.

### 4.7. Terminal failure

Akis bu durumda kendiliginden ilerleyemiyor; kullanici baska aksiyon almali.

---

## 5. Full-screen vs inline vs banner karar kurali

### 5.1. Full-screen state kullan

Eger:

- ekranin ana amaci tamamen yok olduysa
- kullanici baska hicbir anlamli icerik goremiyorsa

Ornek:

- empty storefront
- archived page
- invalid route

### 5.2. Inline state kullan

Eger:

- ana ekran hala anlamliysa
- sorun belli bir field veya row seviyesindeyse

Ornek:

- stale price row
- broken merchant CTA
- duplicate note

### 5.3. Banner/state strip kullan

Eger:

- ekranin tamami bozuk degil ama kritik baglamsal bilgi verilmesi gerekiyorsa

Ornek:

- review required
- editor cannot publish
- manual fallback available

---

## 6. Public state ailesi

## 6.1. Empty storefront

Tanim:

- creator'in henuz public recommendation'i yok

Davranis:

- saygili bos durum
- creator baglamini koruyan copy
- 404 veya hata dili kullanilmaz

## 6.2. Archived / removed page

Tanim:

- sayfa artik aktif public yuzey degil

Davranis:

- controlled archived state
- alternatif rota
- panic red error dili yok

## 6.3. Stale price

Tanim:

- fiyat mevcut ama freshness warning'i gerekli

Davranis:

- inline trust row warning
- page-level error panel kullanilmaz

## 6.4. Hidden price

Tanim:

- creator veya policy fiyatı gostermiyor

Davranis:

- bos alan olmaz
- sade bilgi satiri olur

## 6.5. Broken merchant link

Tanim:

- product recommendation var ama merchant cikisi geçici kullanilamaz

Davranis:

- CTA disabled veya alternatif copy
- urun tamamen yok edilmez

---

## 7. Creator mobile state ailesi

## 7.1. Import processing

Davranis:

- tam-screen progress veya dedicated status screen
- URL summary
- retry expectation

## 7.2. Low-confidence review required

Davranis:

- review strip veya warning block
- hangi alanlarin sorunlu oldugu net

## 7.3. Duplicate detected

Davranis:

- error gibi degil, decision state gibi sunulur
- mevcut product net gosterilir

## 7.4. Unsupported merchant

Davranis:

- blocked ile timeout karismaz
- manual fallback yolu acikca görünür

## 7.5. Offline pending

Davranis:

- local draft koruma bilgisi
- yeniden dene veya sonra devam et

---

## 8. Creator web state ailesi

## 8.1. Empty library

Davranis:

- bosluk duygusu degil, ilk import CTA'si

## 8.2. No pending review

Davranis:

- "her sey sakin" hissi
- sonraki yararli aksiyon gosterimi

## 8.3. Permission-gated action

Ornek:

- editor publish butonu

Davranis:

- gizlenebilir veya disabled explanatory state ile sunulabilir
- sessiz no-op yasak

## 8.4. Import failure list item

Davranis:

- failure code ve next action görünür
- technical dump yok

---

## 9. Ops state ailesi

## 9.1. Empty failed queue

Davranis:

- "hic veri yok" değil, "saglikli durum" hissi

## 9.2. Repeated failure spike

Davranis:

- dashboard-level anomaly state
- urgency vurgusu

## 9.3. Blocked domain detail

Davranis:

- neden
- scope of impact
- reason code

tek bakista okunur

---

## 10. Loading ve skeleton ilkeleri

### 10.1. Skeleton ne zaman?

Public content listesi ve creator listeleri icin uygundur.

### 10.2. Spinner ne zaman?

Tek adimli kisa islem veya button-level aksiyon icin.

### 10.3. Skeleton kurali

Kurallar:

1. Final layout'a sadik olmalidir.
2. Gercek hiyerarsi ile baglantisiz gri kutu yiginina donusmez.
3. Trust row, title ve CTA yerleri sezilebilir olmalidir.

---

## 11. Copy ilkeleri

### 11.1. Empty state copy

- utanclandirmaz
- "yanlış yaptın" demez
- sonraki ilk adımı verir

### 11.2. Error state copy

- ne oldu?
- simdi ne yapabilirsin?

sorularina cevap verir.

### 11.3. Blocked state copy

- policy/safety nedenini olabildigince aciklar
- anlamsiz retry umudu vermez

### 11.4. Degraded state copy

- experience devam eder
- ama belirsizlik saklanmaz

---

## 12. Import outcome -> UI state esleme tablosu

| Outcome / failure | UI state ailesi | Yuzey tipi |
| --- | --- | --- |
| `REVIEW_REQUIRED` | review required | creator mobile/web |
| `INPUT_INVALID_URL` | terminal failure | creator mobile/web |
| `CAPABILITY_UNSUPPORTED_MERCHANT` | blocked but recoverable | creator mobile/web |
| `FETCH_TIMEOUT` | background processing sonra terminal failure | creator mobile/web |
| `EXTRACTION_AMBIGUOUS_RESULT` | review required | creator mobile/web |
| `DEDUPE_POTENTIAL_REUSE` | decision state | creator mobile/web |
| `REVIEW_PAYLOAD_EXPIRED` | terminal failure + restart path | creator mobile/web |
| `REFRESH_STALE_THRESHOLD_REACHED` | degraded but usable | public + creator web |
| `POLICY_BLOCKED_DOMAIN` | blocked | creator + ops |

---

## 13. Senaryolar

## 13.1. Senaryo A: Viewer archived content page'e geldi

Beklenen state:

- full-screen archived page
- alternatif rota
- creator baglami korunsun

## 13.2. Senaryo B: Creator mobile import bekliyor

Beklenen state:

- spinner degil, progress/status screen
- arka planda devam bilgisi

## 13.3. Senaryo C: Creator web'de duplicate bulundu

Beklenen state:

- error degil, compare/decision state

## 13.4. Senaryo D: Ops dashboard'da failure spike

Beklenen state:

- anomaly banner/kart
- urgency ve drill-down aksiyonu

---

## 14. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. Empty state ile error state'i ayni copy ve ayni ikonla gostermek
2. Uzun sureli processing icin sadece spinner kullanmak
3. Duplicate ve review-required durumlarini failure gibi sunmak
4. Public stale warning'i tam ekran error paneline cevirmek
5. Permission block'u sessizce no-op yapmak

---

## 15. Bu belge sonraki belgelere ne emreder?

1. `52-public-web-screen-spec.md`, public degraded ve archived state'lere layout icinde yer ayirmalidir.
2. `53-creator-mobile-screen-spec.md`, processing, unsupported, duplicate ve offline state'lerini bu belgeye gore tasarlamalidir.
3. `54-creator-web-screen-spec.md`, empty library, permission gate ve import failure list state'lerini bu belgeyle uyumlu kurmalidir.
4. `55-admin-ops-screen-spec.md`, anomaly ve blocked detail state'lerini bu belgeye gore modellemelidir.

---

## 16. Bu belgenin basari kriteri nedir?

Bu belge basarili kabul edilir, eger:

- kullanici her state'te ne oldugunu ve sonraki adimi anlayabiliyorsa
- empty, loading, blocked, failed ve degraded durumlar gorsel ve tonal olarak karismiyorsa
- import outcome taxonomy UI state'lerine temiz sekilde yansiyorsa

Bu belge basarisiz sayilir, eger:

- spinner, generic alert ve toast ile tum state'leri gecistiriyorsak
- public ve creator tarafinda blocked/review/stale sinyalleri birbirine karisiyorsa
- state'ler sonraki aksiyonu gostermiyorsa

