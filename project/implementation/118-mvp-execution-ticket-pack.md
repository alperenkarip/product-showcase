---
id: MVP-EXECUTION-TICKET-PACK-001
title: MVP Execution Ticket Pack
doc_type: delivery_execution_pack
status: ratified
version: 1.0.0
owner: product-engineering
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - PROJECT-ROADMAP-001
  - WORK-BREAKDOWN-STRUCTURE-001
  - FEATURE-SEQUENCING-DEPENDENCY-ORDER-001
  - DERIVED-REPO-BOOTSTRAP-MONOREPO-SPEC-001
  - TECH-STACK-RUNTIME-DECISIONS-001
  - OPENAPI-CLIENT-GENERATION-SPEC-001
  - DATABASE-MIGRATION-SEED-BOOTSTRAP-PLAN-001
  - PRODUCT-ANALYTICS-EVENT-TAXONOMY-001
  - NOTIFICATION-AND-OPERATOR-MESSAGING-POLICY-001
blocks:
  - INTERNAL-TEST-PLAN-001
  - LAUNCH-TRANSITION-PLAN-001
---

# MVP Execution Ticket Pack

## 1. Bu belge nedir?

Bu belge, mevcut roadmap, WBS ve sequencing belgelerini gercek implementasyon baslangicinda acilabilir ticket paketlerine indiren resmi delivery pack'tir. Soyut capability yerine, hangi sprintte hangi ticket'in acilacagini, her ticket'in hangi dosya alanini etkileyecegini ve kabul kanitini netlestirir.

Bu belge backlog dump'i degildir. Sadece launch-kritik MVP hattina ait ticket authority'sidir.

---

## 2. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` implementasyonu alti dalgali MVP ticket paketiyle acilacaktir; her ticket bir veya daha fazla source-of-truth belgeye baglanacak, yazma alani acik yazilacak, generated artefact ve migration task'lari uygulama ticket'larindan once acilacak ve documentation-first authority'si olmayan hicbir spike canonical ticket sayilmayacaktir.

---

## 3. Ticket acma standardi

Her ticket asgari su alanlari tasir:

1. ticket id
2. capability
3. owner
4. write scope
5. referans belge
6. acceptance kaniti
7. dependency

Yasak ticket dili:

1. "editor iyilestir"
2. "import duzelt"
3. "ui polish"

---

## 4. Dalga ozeti

Bu belge alti delivery dalgasi tanimlar:

1. D0 bootstrap ve contracts
2. D1 identity, workspace ve publication core
3. D2 import, verification ve source truth
4. D3 creator web/mobile operating loop
5. D4 public trust, billing ve notification minimumu
6. D5 seed, test, ops ve launch evidence

Kural:

- bir dalganin "kritik" ticket'lari kapanmadan sonraki dalganin kritik ticket'lari accepted sayilmaz

---

## 5. D0 - Bootstrap ve contracts

### 5.1. D0 amaci

Monorepo, stack, schema authority ve generated artefact zincirini kurmak.

### 5.2. Ticket'ler

#### TKT-001 - Root workspace bootstrap

- Capability: `CAP-01-01`
- Owner: platform engineering
- Write scope: root manifest'ler, `apps/*`, `packages/*`
- Referans: `116`, `117`
- Acceptance:
  1. root `pnpm install` calisir
  2. `pnpm lint`, `pnpm typecheck`, `pnpm test` placeholder degil gercek pipeline olarak vardir

#### TKT-002 - Shared config package'leri

- Capability: `CAP-01-01`
- Owner: platform engineering
- Write scope: `packages/config-*`, `tsconfig.base.json`
- Referans: `116`, `117`
- Acceptance:
  1. web, mobile, api, jobs ayni TS/lint authority'sini tuketir

#### TKT-003 - Contracts package skeleton

- Capability: `CAP-01-05`
- Owner: backend/platform
- Write scope: `packages/contracts`
- Referans: `70`, `76`
- Acceptance:
  1. route family dizinleri vardir
  2. common response envelope schema'si vardir

#### TKT-004 - OpenAPI generate chain

- Capability: `CAP-01-05`
- Owner: backend/platform
- Write scope: `packages/contracts/openapi`, `generated-client`
- Referans: `76`
- Acceptance:
  1. `pnpm contracts:generate` calisir
  2. generated artefact CI'da kontrol edilir

#### TKT-005 - DB package and migration skeleton

- Capability: `CAP-01-01`
- Owner: backend/data
- Write scope: `packages/db`
- Referans: `71`, `77`
- Acceptance:
  1. migration klasoru ve seed siniflari vardir
  2. `pnpm db:migrate` ve `pnpm db:seed:base` komutlari tanimlidir

#### TKT-006 - Observability baseline wiring

- Capability: `CAP-01-04`
- Owner: platform
- Write scope: `apps/web`, `apps/api`, `apps/jobs`, `packages/shared-utils`
- Referans: `69`, `117`
- Acceptance:
  1. request/job correlation id uretimi vardir
  2. Sentry baseline'in yeri bellidir

---

## 6. D1 - Identity, workspace ve publication core

### 6.1. Ticket'ler

#### TKT-010 - Auth shell ve principal summary

- Capability: `CAP-02-01`
- Owner: backend/auth
- Write scope: `apps/api`, `packages/auth-shared`
- Referans: `63`, `117`
- Acceptance:
  1. web cookie tabanli auth calisir
  2. mobile secure summary restore modeli vardir

#### TKT-011 - Core identity migrations

- Capability: `CAP-02-01`
- Owner: backend/data
- Write scope: `packages/db/schema`, `migrations`
- Referans: `71`, `77`
- Acceptance:
  1. users/workspaces/memberships/storefront identities tabloları olusur

#### TKT-012 - Workspace and role guard

- Capability: `CAP-02-02`
- Owner: backend
- Write scope: `apps/api`, `packages/domain`
- Referans: `34`, `70`
- Acceptance:
  1. owner/editor yetki farki route seviyesinde enforce edilir

#### TKT-013 - Storefront and handle lifecycle

- Capability: `CAP-02-03`
- Owner: backend/web
- Write scope: `apps/api`, `apps/web`, `packages/db`
- Referans: `21`, `22`, `71`
- Acceptance:
  1. handle uniqueness
  2. public route resolution

#### TKT-014 - Publication state machine

- Capability: `CAP-02-04`
- Owner: backend/domain
- Write scope: `packages/domain`, `packages/contracts`, `apps/api`
- Referans: `21`, `30`, `70`
- Acceptance:
  1. draft/published/unpublished/archived state'leri calisir

#### TKT-015 - Minimal public render shell

- Capability: `CAP-02-05`
- Owner: web
- Write scope: `apps/web`
- Referans: `24`, `52`, `61`
- Acceptance:
  1. handle -> storefront route cikar
  2. 404 / unpublished / removed davranisi ayri ayridir

---

## 7. D2 - Import, verification ve source truth

### 7.1. Ticket'ler

#### TKT-020 - Product/source/placement core tables

- Capability: `CAP-03-01`, `CAP-03-02`
- Owner: backend/data
- Write scope: `packages/db`
- Referans: `30`, `31`, `71`, `77`
- Acceptance:
  1. product canonical record
  2. source record
  3. selected source state

#### TKT-021 - URL normalization and dedupe engine

- Capability: `CAP-04-01`
- Owner: import/backend
- Write scope: `packages/import-engine`
- Referans: `40`, `43`
- Acceptance:
  1. canonical URL uretimi
  2. duplicate key cikarimi

#### TKT-022 - Merchant capability registry runtime

- Capability: `CAP-04-02`
- Owner: import/ops
- Write scope: `packages/import-engine`, `packages/db`
- Referans: `42`
- Acceptance:
  1. `full/partial/fallback-only/blocked` tier authority'si calisir

#### TKT-023 - Extraction fallback pipeline

- Capability: `CAP-04-03`
- Owner: import
- Write scope: `apps/jobs`, `packages/import-engine`
- Referans: `40`, `41`, `47`
- Acceptance:
  1. normalization -> fetch -> parse -> fallback sirasi korunur

#### TKT-024 - Verification apply workflow

- Capability: `CAP-04-04`
- Owner: backend/web/mobile
- Write scope: `apps/api`, `apps/web`, `apps/mobile`, `packages/contracts`
- Referans: `44`, `70`, `76`
- Acceptance:
  1. correction payload kalici olur
  2. selected source truth update edilir

#### TKT-025 - Failure taxonomy and retry

- Capability: `CAP-04-06`
- Owner: import/jobs
- Write scope: `apps/jobs`, `packages/import-engine`, `packages/db`
- Referans: `48`, `72`
- Acceptance:
  1. retryable vs blocked failure ayrimi vardir
  2. parked backlog mantigi yazilidir

---

## 8. D3 - Creator operating loop

### 8.1. Ticket'ler

#### TKT-030 - Mobile quick add shell

- Capability: `CAP-05-01`
- Owner: mobile
- Write scope: `apps/mobile`
- Referans: `23`, `53`, `62`
- Acceptance:
  1. URL paste -> import start
  2. verification entry

#### TKT-031 - Web library management

- Capability: `CAP-06-01`
- Owner: web
- Write scope: `apps/web`
- Referans: `23`, `54`
- Acceptance:
  1. product library goruntulenir
  2. source secimi degistirilebilir

#### TKT-032 - Page and shelf composition

- Capability: `CAP-06-03`
- Owner: web/backend
- Write scope: `apps/web`, `apps/api`
- Referans: `20`, `21`, `23`
- Acceptance:
  1. page create/edit
  2. shelf placement add/remove

#### TKT-033 - Save, publish and invalidate flow

- Capability: `CAP-06-04`
- Owner: web/backend
- Write scope: `apps/api`, `apps/web`, `apps/jobs`
- Referans: `21`, `73`
- Acceptance:
  1. publish action public surface'i gunceller
  2. stale cache invalidate olur

#### TKT-034 - Creator auth guard parity

- Capability: `CAP-05-01`, `CAP-06-01`
- Owner: auth/web/mobile
- Write scope: `apps/web`, `apps/mobile`, `packages/auth-shared`
- Referans: `63`, `23`
- Acceptance:
  1. owner/editor surface farki web ve mobile'da aynidir

---

## 9. D4 - Public trust, billing ve notifications

### 9.1. Ticket'ler

#### TKT-040 - Trust row and disclosure render

- Capability: `CAP-07-02`
- Owner: web
- Write scope: `apps/web`, `packages/ui-web`
- Referans: `27`, `52`, `58`, `91`
- Acceptance:
  1. product-level disclosure gorunur
  2. page-level copy product truth'u ikame etmez

#### TKT-041 - Price freshness and state render

- Capability: `CAP-07-03`
- Owner: web/backend
- Write scope: `apps/web`, `apps/api`
- Referans: `45`, `56`
- Acceptance:
  1. stale / hidden / unavailable ayrimi dogru gorunur

#### TKT-042 - Stripe checkout and entitlement bridge

- Capability: `CAP-08-01`
- Owner: backend/billing
- Write scope: `apps/api`, `apps/jobs`, `packages/db`
- Referans: `28`, `64`, `75`, `117`
- Acceptance:
  1. checkout success tek basina access acmaz
  2. entitlement bridge pending state gorunur

#### TKT-043 - Notification center and transactional email

- Capability: `CAP-08-02`, `CAP-09-02`
- Owner: backend/web/mobile
- Write scope: `apps/api`, `apps/web`, `apps/mobile`, `packages/db`
- Referans: `106`, `100`, `74`
- Acceptance:
  1. in-app notice center vardir
  2. billing/invite/security mail'i cikar

#### TKT-044 - Analytics registry and first event family

- Capability: `CAP-01-04`, `CAP-10-04`
- Owner: product engineering
- Write scope: `packages/analytics`, `apps/web`, `apps/mobile`
- Referans: `105`
- Acceptance:
  1. public.view ve creator.import event'leri registry uzerinden cikar
  2. consent gate calisir

---

## 10. D5 - Seed, test, ops ve launch evidence

### 10.1. Ticket'ler

#### TKT-050 - Demo seed package

- Capability: `CAP-10-01`
- Owner: backend/data
- Write scope: `packages/db/src/seed/demo`
- Referans: `77`, `113`
- Acceptance:
  1. internal test icin gerekli creator/merchant/import dataset yuklenir

#### TKT-051 - Support and ops console minimum

- Capability: `CAP-09-01`, `CAP-09-02`
- Owner: web/ops
- Write scope: `apps/web`, `apps/api`
- Referans: `55`, `101`, `103`
- Acceptance:
  1. import failure ve billing drift gorunur
  2. support issue family okunur

#### TKT-052 - Contract and migration CI gates

- Capability: `CAP-10-04`
- Owner: platform
- Write scope: `.github`, root tasks
- Referans: `76`, `77`, `88`
- Acceptance:
  1. generated artefact drift yakalanir
  2. migration/seed guard calisir

#### TKT-053 - Internal test cohort run

- Capability: `CAP-10-02`
- Owner: product/qa
- Write scope: test plans, fixtures, dashboards
- Referans: `114`, `82`, `83`
- Acceptance:
  1. cohort bazli test sonucu kayda girer

#### TKT-054 - Release evidence package

- Capability: `CAP-10-04`
- Owner: product-engineering
- Write scope: release docs, dashboards, checklists
- Referans: `88`, `115`
- Acceptance:
  1. launch gate evidence paketi tamamlanir

---

## 11. Paralel calisma sinirlari

Parallel-safe alanlar:

1. TKT-001 ile TKT-002
2. TKT-030 ile TKT-031
3. TKT-040 ile TKT-044

Paralel acilmamasi gerekenler:

1. TKT-024, TKT-023 oncesi
2. TKT-042, TKT-010 ve TKT-011 oncesi
3. TKT-053, TKT-050 oncesi

---

## 12. Sprint onerisi

Onerilen sprint kirilimi:

1. Sprint 0 -> D0
2. Sprint 1 -> D1
3. Sprint 2 -> D2
4. Sprint 3 -> D3
5. Sprint 4 -> D4
6. Sprint 5 -> D5

Kural:

- sprint kapanisi task tamamlama sayisiyla degil acceptance kanitiyle olculur

---

## 13. Anti-pattern listesi

Bu belgeye gore su yollar yanlistir:

1. D0 kapanmadan UI sprint'i acmak
2. generated contracts olmadan client yazmak
3. demo seed olmadan internal test planlamak
4. notification policy yokken push veya email vendor eklemek
5. trust row olmadan public polish sprint'i yapmak

---

## 14. Basari kriteri

Bu belge basarili sayilir, eger:

1. ekip ilk gunden itibaren acilabilir ticket listesine sahipse
2. hangi ticket'in hangi dosya alanina dokunacagi netse
3. dependency zinciri nedeniyle sprint ortasi kaos cikmiyorsa
4. MVP implementasyonu belge yorumu yerine acik delivery contract'i ile ilerliyorsa

