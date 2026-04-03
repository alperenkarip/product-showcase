---
id: PERFORMANCE-BUDGETS-001
title: Performance Budgets
doc_type: quality_budget
status: ratified
version: 2.0.0
owner: engineering
last_updated: 2026-04-02
language: tr
source_of_truth: true
depends_on:
  - PUBLIC-WEB-SCREEN-SPEC-001
  - CREATOR-WEB-SCREEN-SPEC-001
  - CREATOR-MOBILE-SCREEN-SPEC-001
  - CACHE-REVALIDATION-STALENESS-RULES-001
  - BACKGROUND-JOBS-SCHEDULING-SPEC-001
blocks:
  - RELEASE-READINESS-CHECKLIST
  - RUNBOOKS
---

# Performance Budgets

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun public web, creator web, creator mobile ve asenkron operasyon katmanlari icin performans hedeflerini ve sert kabul esiklerini tanimlayan resmi performans butcesi belgesidir.

## 2. Ana karar

> Bu projede performans butcesi yalniz Lighthouse skoru degil; public decision-speed, creator responsiveness ve async workflow bekleme suresi uzerinden degerlendirilecektir.

## 3. Public web butceleri

### 3.1. Core Web Vitals hedefleri

- mobil `LCP`: p75 `<= 2.5s`
- mobil `INP`: p75 `<= 200ms`
- mobil `CLS`: p75 `<= 0.10`
- desktop `LCP`: p75 `<= 2.0s`

### 3.2. HTML ve veri

- public route server response / first byte hedefi: p95 `<= 800ms`
- public loader/read model hedefi: p95 `<= 300ms`

### 3.3. Gorsel hedefleri

- first viewport hero/cover tek asset hedefi: mobilde `<= 200KB`
- liste/kart gorsel hedefi: `<= 120KB`

## 4. Creator web butceleri

- dashboard ilk kullanilabilir gorunum: p75 `<= 2.0s`
- route/screen transition: `<= 500ms`
- import create acknowledge: p95 `<= 1.0s`
- buyuk listelerde scroll takilma yaratacak reflow kabul edilmez

## 5. Creator mobile butceleri

- cold start to usable shell: p75 `<= 3.0s`
- warm start: p75 `<= 1.5s`
- paste/share import entry ekran acilisi: `<= 1.0s`
- verification step gecisleri: `<= 300ms`

## 6. Async ve operasyonel butceler

- import `accepted -> needs_review/ready`: full-tier median `<= 45s`, p95 `<= 120s`
- partial/fallback import median `<= 75s`, p95 `<= 180s`
- manual refresh median `<= 60s`
- publish -> public cache invalidation gorunurlugu: p95 `<= 60s`
- publish -> OG/share preview asset hazirligi: p95 `<= 30s`

## 7. Olcum kaynaklari

Bu butceler tek bir arac uzerinden degil, katman bazli olculur:

1. public web RUM veya lab raporlari
2. server timing ve route telemetry
3. queue/job duration metric'leri
4. mobile runtime performance trace'leri

Kural:

Sadece lokal dev makinasi veya tek cihaz hissi performans karari icin yeterli sayilmaz.

## 8. Yuzey bazli ozel notlar

### 8.1. Public web

Trust/disclosure row'u performans bahanesiyle gec yuklenip layout kaymasi yaratmamalidir.

### 8.2. Creator web

Import create ack hizli olmali; ama "accepted" ile "tamamlandi" karistirilmamalidir.

### 8.3. Creator mobile

Paste/share girisi acildiginda kullanici bos beyaz ekran veya belirsiz spinner gormemelidir.

## 9. Queue ve resiliency esikleri

- `P0` backlog `> 5 dk` warning
- `P0` backlog `> 15 dk` blocker
- dead-letter artis trendi release blocker olabilir

## 10. Degrade kabul kurallari

1. Public route gecici stale cache ile acilabilir; ama yanlis current trust state gosteremez.
2. Async workflow yavasladiginda UI zaman durumunu acikca iletmelidir.
3. Performance sorunu trust veya correctness'i gizleyen bir degrade yoluna donusemez.

## 11. Release blocker maddeleri

1. Public mobil `LCP` butcesi sistematik asiliyorsa
2. Import median suresi kabul edilemez sekilde yuksekse
3. Publish sonrasi invalidation penceresi guveni bozacak kadar gecse
4. Mobile import girisi hissedilir sekilde yavas kalirsa

## 12. Anti-pattern'ler

1. Spinner gosterip gercek yavasligi gizlemek
2. Publicte agir hotlink veya optimize edilmemis gorsel kullanmak
3. Async yavasligi "arkada calisiyor" diyerek normalize etmek

## 13. Bu belgenin basari kriteri nedir?

Ekip her kritik yuzey icin sayisal hedef biliyor, bu hedefler release candidate uzerinde olculuyor ve budget asimi "ileride optimize ederiz" diye normalize edilmiyorsa bu belge amacina ulasmistir.
