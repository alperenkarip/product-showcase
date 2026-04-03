---
id: EXTERNAL-LINK-MERCHANT-CONTENT-POLICY-001
title: External Link and Merchant Content Policy
doc_type: safety_compliance_policy
status: ratified
version: 2.0.0
owner: product-compliance
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - LINK-NORMALIZATION-DEDUP-RULES-001
  - URL-IMPORT-PIPELINE-SPEC-001
  - DISCLOSURE-TRUST-CREDIBILITY-LAYER-001
blocks:
  - SECURITY-AND-ABUSE-CHECKLIST
  - REPORTING-TAKEDOWN-ABUSE-POLICY
---

# External Link and Merchant Content Policy

## 1. Bu belge nedir?

Bu belge, `product-showcase` icindeki merchant URL'lerinin, harici merchant iceriklerinden tureyen metin ve gorsellerin ve public merchant cikisinin hangi kurallarla gosterilecegini tanimlayan resmi external link ve merchant content politikasidir.

## 2. Ana karar

> `product-showcase` harici merchant icerigini sahiplenmez; creator recommendation baglaminda yonlendirir. Unsafe, blocked, asiri belirsiz veya non-product karakterli linkler public cikisa donusturulmez; stale veya eksik merchant verisi current offer gibi sunulmaz.

## 3. Izinli link siniflari

1. supported merchant product page
2. fallback-only ama policy'den gecen product page
3. creator tarafindan manuel girilmis ama safety kontrollerini gecen merchant linki

## 4. Reddedilen link siniflari

1. phishing/malware supheli yonlendirmeler
2. policy ile bloke edilmis domainler
3. asiri redirect zinciri
4. bariz non-product page veya katalog/listing sayfasi
5. canonical olarak cozumlenemeyen ve review'a bile guvenli giremeyen linkler

## 5. Merchant content kullanimi

1. Imported title/image/price yardimci veri sayilir.
2. Bu veri current offer veya merchant garantisi gibi sahiplenilmez.
3. Publicte gosterilen merchant bilgisi selected source ve trust state ile birlikte sunulur.

## 6. Public cikis kurallari

1. Merchant adi ve dis link davranisi acik gosterilir.
2. Blocked/unsafe link publicte aktif CTA uretemez.
3. Stale fiyat merchant gercegi gibi sunulmaz.
4. Broken veya kaldirilmis source'ta CTA gizlenebilir veya disabled state'e cekilebilir.

## 7. Creator-facing kurallar

1. Link reddedildiginde creator'a net neden gosterilir.
2. Support/ops sinyali olusur.
3. Review-required durumda creator cikissiz kalmaz.
4. Manual URL girisi policy bypass sayilmaz.

## 8. Brand ve merchant isim kullanimi

1. Merchant brand'i product source baglami kadar kullanilir.
2. "resmi satici", "en iyi fiyat" gibi desteklenmeyen iddialar copy'ye girmez.
3. Merchant logolari veya gorselleri markasal sahiplenme hissi yaratacak sekilde kullanilmaz.

## 9. Senaryo bazli notlar

### 9.1. Senaryo: Link later becomes broken

Beklenen:

- refresh veya report ile source state guncellenir
- public cikis guvenli degrade olur

### 9.2. Senaryo: Creator manually enters suspicious merchant URL

Beklenen:

- policy block
- net aciklama
- audit ve abuse sinyali

## 10. Bu belgenin basari kriteri nedir?

Publicte yalniz policy'den gecmis, trust semantigi dogru ve viewer'i yaniltmayan merchant cikislari kalıyor; creator policy block aldiginda nedenini anliyor ve support bu karar zincirini audit ile izleyebiliyorsa belge amacina ulasmistir.
