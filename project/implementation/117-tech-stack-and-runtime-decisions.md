---
id: TECH-STACK-RUNTIME-DECISIONS-001
title: Tech Stack and Runtime Decisions
doc_type: stack_decision_record
status: ratified
version: 1.0.0
owner: engineering
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - DERIVED-REPO-BOOTSTRAP-MONOREPO-SPEC-001
  - SYSTEM-ARCHITECTURE-001
  - WEB-SURFACE-ARCHITECTURE-001
  - MOBILE-SURFACE-ARCHITECTURE-001
  - AUTH-IDENTITY-SESSION-MODEL-001
  - THIRD-PARTY-SERVICES-REGISTER-001
blocks:
  - OPENAPI-CLIENT-GENERATION-SPEC-001
  - DATABASE-MIGRATION-SEED-BOOTSTRAP-PLAN-001
  - PRODUCT-ANALYTICS-EVENT-TAXONOMY-001
  - NOTIFICATION-AND-OPERATOR-MESSAGING-POLICY-001
  - MVP-EXECUTION-TICKET-PACK-001
---

# Tech Stack and Runtime Decisions

## 1. Bu belge nedir?

Bu belge, `product-showcase` implementasyonunun hangi runtime, framework, kutuphane ve altyapi secimleriyle kurulacagini; hangilerinin faz 1 baseline, hangilerinin conditional adoption, hangilerinin acikca ertelenmis oldugunu tanimlayan resmi stack karar belgesidir.

Bu belge su sorulari kapatir:

- web hangi runtime ile kurulacak?
- mobile navigation ve local storage omurgasi ne olacak?
- API/BFF hangi framework ile yazilacak?
- DB, ORM, auth ve job orchestration ne olacak?
- analytics, billing ve email vendor aileleri nasil secilecek?
- hangi kutuphaneler bootstrap'te zorunlu, hangileri ancak complexity threshold asilirsa acilacak?

Bu belge olmadan ekip su hatalara duser:

1. boilerplate canonical stack ile celisen secimler onerir
2. mobile navigation ve styling iki kez degisir
3. API iskeleti framework denemesine doner
4. fetch-first ile query-layer karisir
5. analytics ve billing vendor kararlari sprint ortasinda degisir

---

## 2. Bu belge neden kritiktir?

Bu urunde stack secimi dekoratif degildir. Dogrudan urun kalitesi ve delivery hizi uretir.

Ornek:

1. yanlis web runtime -> public SEO ile creator route guard karisir
2. yanlis mobile navigation -> deep link ve verification akisi dagilir
3. yanlis auth secimi -> web/mobile session truth'u ayrisir
4. yanlis ORM veya migration disiplini -> import ve publication state refactor maliyeti artar
5. fazla erken analytics ve flag vendor lock-in'i -> utility odagi bozulur

Bu nedenle burada "hangi kutuphane seviliyor?" degil, "hangi secim bu urunun karar setini tasir?" sorusu cevaplanir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase`, boilerplate'in canonical stack kararlarina sadik kalarak `Node 20.19.x + pnpm 10.x + Turbo 2.x + TypeScript 5.9.x` monoreposu olarak kurulacak; web runtime `React 19.2 + Vite 8 + React Router 7`, mobile runtime `Expo SDK 55 + React Native 0.83 + React Navigation 7`, API runtime `Hono + Zod + Better Auth + Drizzle + PostgreSQL`, jobs runtime `Inngest`, core observability `Sentry`, transactional email `Resend-class`, canonical subscription authority `RevenueCat-class`, web checkout surface `Stripe-class` ve analytics `vendor-agnostic abstraction` uzerinden yurutulecektir.

Bu karar su sonuclari dogurur:

1. Next.js, Expo Router ve tek-router soyutlamasi secilmez.
2. Query-layer bootstrap default'u degildir; complexity threshold ile acilir.
3. NativeWind 5 candidate track'i proje icin zorunlu baseline sayilmaz; bu repo v1 mobile styling fallback'ini aktive eder.
4. Mobile paid entry surface MVP kritik yoluna alinmayabilir; ancak canonical subscription authority `RevenueCat-class` entitlement katmani olarak korunur ve web checkout ayni entitlement sistemine baglanir.

---

## 4. Version track ve pin modeli

Bu proje exact patch pin'i package manifest ve lockfile'da tasir. Bu belge ise strategic version track'i sabitler.

Canonical track:

1. Node.js `20.19.x`
2. pnpm `10.x`
3. Turborepo `2.x`
4. TypeScript `5.9.x`
5. React `19.2.x`
6. Vite `8.x`
7. React Router `7.x`
8. Expo SDK `55.x`
9. React Native `0.83.x`
10. React Navigation `7.x`
11. Tailwind CSS `4.x`
12. Zustand `5.x`
13. TanStack Query `5.x` conditional track
14. React Hook Form `7.x`
15. Zod `4.x`
16. Sentry stable line

Kural:

- exact patch yukseltileri compatibility matrix ve CI ile kontrol edilir
- major track degisimi bu belge revizyonu olmadan yapilmaz

---

## 5. Root toolchain kararlari

## 5.1. Node.js

Canonical baseline `20.19.x` tir.

Neden:

1. boilerplate compatibility matrix ile uyumludur
2. Expo 55, Vite 8 ve modern toolchain hattini birlikte tasir
3. CI ve local parity icin daha guvenli merkez cizgidir

## 5.2. pnpm

Package manager `pnpm 10.x` olur.

Kural:

- workspace install guvenligi aktif olur
- root lockfile authority'si tekildir

## 5.3. Turborepo

Task orchestration `Turbo 2.x` uzerinden kurulur.

Kural:

- lint, test, typecheck, contracts generate ve seed gorevleri pipeline olarak tanimlanir

## 5.4. TypeScript

Kod tabaninin ana dili `TypeScript 5.9.x` olur.

Kural:

- JS fallback dosyalari canonical implementation yolu sayilmaz

---

## 6. Web runtime karari

Web runtime su secimlerle kurulacaktir:

1. React `19.2.x`
2. React DOM `19.2.x`
3. Vite `8.x`
4. React Router `7.x`
5. Tailwind CSS `4.x`

### 6.1. Neden bu secim?

1. public web + creator web + ops web tek app icinde mantiksal route ailelerine ayrilabilir
2. SPA-first shell kararina uyar
3. React Router data-router modeli public/creator/ops ayrimini tasir
4. Vite bootstrap hizi yuksek, shell kontrolu nettir

### 6.2. Web state ve data modeli

1. app-global client-owned state -> Zustand
2. form state -> React Hook Form + Zod
3. server state -> fetch-first default
4. query/cache complexity artisinda -> TanStack Query adoption

Kural:

- query sonucu Zustand'a kopyalanmaz
- route loader ile API client contract'i farkli truth uretmez

---

## 7. Mobile runtime karari

Mobile runtime su secimlerle kurulacaktir:

1. Expo SDK `55.x`
2. React Native `0.83.x`
3. React Navigation `7.x`
4. `react-native-screens`
5. `react-native-safe-area-context`
6. `react-native-gesture-handler`
7. `react-native-reanimated`
8. secure storage -> Expo SecureStore
9. local cache/draft -> MMKV class storage

### 7.1. Neden Expo + React Navigation?

1. creator utility runtime ihtiyacina hizli cevap verir
2. native-feeling verification ve quick-add akisini tasir
3. deep link ve auth restore senaryolari olgundur
4. boilerplate navigation baseline ile uyumludur

### 7.2. Mobile styling fallback karari

Boilerplate NativeWind 5'i candidate track olarak izler. Bu proje icin v1 karar su sekildedir:

1. mobile styling authority'si semantic token + `StyleSheet` tabanli component primitive'lerdir
2. NativeWind 5 yalniz release-status, Expo 55 uyumu ve token audit'i gecerse sonradan devreye alinabilir
3. MVP bootstrap'i NativeWind kararini beklemez

Bu karar su riski kapatir:

- styling candidate track yuzunden mobile bootstrap'in bloklanmasi

---

## 8. API ve server runtime karari

API/BFF runtime secimi:

1. Hono
2. Zod 4
3. Better Auth
4. Drizzle ORM
5. PostgreSQL

### 8.1. Hono neden secildi?

1. route family ayrimini temiz tasir
2. typed middleware ve handler yazimi hafiftir
3. public/creator/ops/webhook surface'leri icin uygun bir transport shell'dir

### 8.2. Better Auth neden secildi?

1. secure cookie + session summary modeline uyar
2. web ve mobile tarafinda ortak auth authority kurulabilir
3. owner/editor/support principal ayrimlarini auth'tan sonra application layer'a tasimak kolaydir

### 8.3. Drizzle + PostgreSQL neden secildi?

1. relation-heavy schema acik tanimlanir
2. migration ve seed pipeline'i fiziksel olarak kontrol edilebilir
3. billing, audit, import ve publication tablolarini tipli sekilde tasir

Kural:

- database authority tek Postgres primary uzerindedir
- local SQLite ile "gercek backend varmis gibi" ikili dogru kurulmaz

---

## 9. Jobs ve async orchestration karari

Background jobs ve workflow authority'si:

1. Inngest
2. app-level queue adapter'lari
3. Playwright class headless render/browse capability

### 9.1. Inngest neden secildi?

1. import pipeline'ini durable ve gozetilebilir hale getirir
2. billing reconcile ve retry mantigini ayrik handler zincirine donusturur
3. webhook follow-up ve scheduled refresh icin uygundur

### 9.2. Kural

- import, refresh, cleanup ve reconcile flow'lari request-response icinde tamamlanmis kabul edilmez

---

## 10. Storage ve media karari

1. primary DB -> managed PostgreSQL
2. object storage -> S3/R2 uyumlu object store
3. media transform authority -> jobs pipeline

Kural:

- creator upload ve imported media ayni access policy'ye sahip sayilmaz
- signed URL ve public asset ayrimi korunur

---

## 11. Observability ve analytics karari

## 11.1. Sentry zorunludur

Error tracking ve release health authority'si Sentry olur.

## 11.2. Analytics abstraction zorunludur

Product analytics dogrudan vendor SDK import eden screen kodu ile kurulmaz.

Karar:

1. `packages/analytics` event registry authority'si olur
2. vendor adapter abstraction'i korunur
3. bootstrap safhasinda analytics vendor lock-in'i zorunlu degildir

## 11.3. Product analytics vendor tercihi

Preferred family `PostHog-class` olarak kaydedilir; ancak vendor secimi taxonomy ve consent enforcement tamamlanmadan bootstrap blocker sayilmaz.

---

## 12. Billing, email ve domain/vendor kararlar

## 12.1. Canonical subscription authority

Boilerplate ADR-016 ile uyumlu olarak canonical subscription authority `RevenueCat-class` olur.

Neden:

1. cross-platform entitlement truth'unu tek yerde toplar
2. web Stripe ve mobile store billing olaylarini ayni subscription sistemi altinda birlestirir
3. receipt validation, renewal, grace ve cancellation lifecycle'ini canonical hatta tasir

## 12.2. Web checkout surface

Owner web checkout UX'u icin `Stripe-class` provider kullanilir; ancak bu provider subscription authority yerine gecmez.

Kurallar:

1. checkout success tek basina access acmaz
2. web checkout olayi `RevenueCat-class` entitlement zinciriyle normalize edilir
3. `Stripe-class` surface, canonical IAP yolunu devre disi birakan alternatif truth haline getirilemez

## 12.3. MVP sequencing

Bu proje icin v1 sequencing karari sudur:

1. owner-facing web checkout akisi once acilabilir
2. mobile paid entry UI MVP kritik yoluna alinmayabilir
3. bu sequencing, `RevenueCat-class` subscription authority'sini erteleyen veya mimariden silen bir karar degildir

## 12.4. Transactional email

Preferred family `Resend-class` olur.

Kullanim:

1. invite
2. billing notice
3. ownership transfer
4. export/deletion
5. security mail

---

## 13. Conditional adoption kararlari

Asagidaki teknolojiler conditional adoption sinifindadir:

1. TanStack Query
2. analytics vendor adapter'i
3. NativeWind 5
4. mobile push channel

### 13.1. TanStack Query ne zaman acilir?

Asagidaki complexity threshold'lardan ikisi gecilirse:

1. stale/revalidate graph'i buyurse
2. optimistic mutation ve invalidation cogu ekrani etkilerse
3. offline-aware retry/refresh mantigi artarsa

### 13.2. Mobile push ne zaman acilir?

MVP sonrasi, su kanitlar olmadan acilmaz:

1. in-app ve email notification yeterliligi olculdu
2. support escalation hacmi kaliciyla takip edildi
3. spam ve preference modeli netlesti

---

## 14. Yasak veya ertelenmis yollar

Bu belgeye gore su yollar secilmez:

1. Next.js / SSR-first web runtime
2. Expo Router canonical navigation
3. ikinci state library
4. mobile ve web icin ayrik schema authority
5. server state'i generic local store'a yazma
6. `Stripe-class` provider'i tek subscription truth'u haline getirme
7. boilerplate canonical IAP yolunu "native sonra bakariz" diyerek mimariden silme

---

## 15. Bootstrap icin zorunlu install seti

Ilk bootstrap'te asgari su dependency aileleri vardir:

1. React, Vite, React Router
2. Expo, React Native, React Navigation
3. Hono, Zod, Better Auth, Drizzle, Postgres driver
4. RHF, Zustand
5. Sentry
6. Playwright
7. testing, lint, tsconfig ve config paketleri

Not:

- `RevenueCat-class` subscription authority adapter'i ve `Stripe-class` web checkout bridge'i MVP delivery kapsamindadir; ilk bootstrap commit'inde full wiring zorunlu degildir ama package boundary ve integration yeri acik yazilir. `Stripe-only` shortcut kabul edilmez.

Ilk bootstrap'te zorunlu olmayanlar:

1. TanStack Query
2. analytics vendor SDK
3. push SDK setup
4. storybook benzeri component lab

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `76-openapi-and-client-generation-spec.md`, Hono + Zod reality'sine gore codegen zincirini sabitlemelidir.
2. `77-database-migration-and-seed-bootstrap-plan.md`, Drizzle + PostgreSQL migration gercegini fiziksel komutlara cevirmelidir.
3. `105-product-analytics-event-taxonomy.md`, vendor-agnostic analytics abstraction modelini korumalidir.
4. `106-notification-and-operator-messaging-policy.md`, v1'de push'i critical path'ten cikarmali, email + in-app authority'sini netlestirmelidir.
5. `118-mvp-execution-ticket-pack.md`, task acarken bu stack kararina aykiri is acmamalidir.

---

## 17. Basari kriteri

Bu belge basarili sayilir, eger:

1. ekip "hangi stack resmi?" sorusunu tekrar sormuyorsa
2. boilerplate ile celisen secimler delivery ortasinda geri donmuyorsa
3. bootstrap commit'i teknolojik spike degil, kararli omurga uretirse
4. conditional adoption alanlari gizli degil, yazili ve denetlenebilir kalirsa
