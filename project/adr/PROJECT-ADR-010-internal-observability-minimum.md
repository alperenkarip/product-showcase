---
id: PROJECT-ADR-010
title: Internal Observability Minimum
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-010 - Internal Observability Minimum

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-010
- **Baslik:** Internal Observability Minimum
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Observability baseline
- **Karar alani:** Launch oncesi hangi minimum internal telemetry ve operational visibility'nin zorunlu oldugunu tanimlar.
- **Ilgili ust belgeler:**
  - `project/architecture/69-observability-and-internal-event-model.md`
  - `project/05-success-criteria-and-launch-gates.md`
  - `project/operations/101-runbooks.md`
- **Etkiledigi belgeler:**
  - `project/operations/102-incident-response-project-layer.md`
  - `project/quality/88-release-readiness-checklist.md`
  - `project/implementation/114-internal-test-plan.md`
  - `project/implementation/115-launch-transition-plan.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; event modeli ve ops readiness ile uyumludur.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Import ve publish sagligini olcen minimum event seti zorunludur.
- Failure reason, request/job correlation ve actor baglami kaydedilir.
- Ops ve support, generic log'lara degil urun-semantic event setine bakar.
- Vanity analytics, minimum observability yerine gecmez.

Bu ADR'nin ana hukmu sudur:

> Kullaniciya agir analytics gostermesek bile, urun ekibi import, trust, publish ve safety sagligini kanitsiz yonetemez; launch oncesi minimum internal observability zorunludur.

---

# 2. Problem Tanimi

Telemetry olmadan:

1. import basari orani bilinmez
2. support ve ops kok nedeni bulamaz
3. release gate kanit uretmez
4. incident sinifi availability ile sinirli sanilir
5. trust veya disclosure bozulmalari sayisal izlenemez

Bu urunde ic gozlem luks degil, operasyonel zorunluluktur.

---

# 3. Baglam

Bu urun:

- import motoru
- external link safety
- stale/refresh davranisi
- support issue family'leri

gibi operasyonel olarak hassas alanlar tasir. Publice creator-facing analytics suite acmamak, ekip icinde de veri olmayacagi anlamina gelmez. Aksi halde runbook ve incident belgeleri uygulamada karsilik bulmaz.

---

# 4. Karar Kriterleri

1. Kok neden analizine yetmek
2. Fazla veri veya privacy yuku yaratmamak
3. Ops ve support ekiplerine ortak sinyal saglamak
4. Launch ve rollout gating'e kanit saglamak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Yalnizca error log'lari

Eksiler:

- urun-semantic saglik hakkinda yeterli sinyal vermez

## 5.2. Full creator-facing analytics once

Eksiler:

- product scope ve privacy yukunu gereksiz buyutur

## 5.3. Minimum internal event modeli

Artisi:

- ihtiyac olan operasyonel sinyali saglar
- creator utility ve privacy sinirina saygilidir

---

# 6. Secilen Karar

Asgari event ve telemetry omurgasi:

- `import_submitted`
- `import_completed`
- `import_failed`
- `verification_saved`
- `publication_changed`
- `publish_completed`
- `source_broken`
- `stale_state_entered`
- `unsafe_link_blocked`
- `webhook_received`
- `webhook_parked`
- `entitlement_changed`

Her olay asgari su baglami tasir:

- request id
- job/workflow id, varsa
- actor/workspace baglami
- merchant veya route baglami
- reason code

---

# 7. Neden Bu Karar?

- Runbook ve support playbook'larina veri saglar.
- Launch transition'da pacing kararlarini kanitlar.
- Import ve trust bozulmalarini availability disinda da gozlenebilir kilar.
- Privacy'yi zorlamadan gerekli minimumu saglar.

---

# 8. Reddedilen Yonler

- Sadece infra log'lariyla yetinmek reddedildi; cunku urun davranisi okunamaz.
- Creator-facing analytics'i minimum observability yerine koymak reddedildi; cunku amac operator gorusu, vanity insight degildir.
- "Hata cikarsa bakariz" anlayisi reddedildi; cunku launch-kritik urun import odaklidir.

---

# 9. Riskler

1. Asgari event seti eksik tasarlanirsa runbook'lar kör kalabilir.
2. Event seti fazla buyurse privacy ve noise maliyeti artar.
3. Correlation id disiplini gevserse supportability duser.

---

# 10. Risk Azaltma Onlemleri

- Event adlari merkezi sozlukten cikar.
- Event'ler source-of-truth dokumanlarla hizalanir.
- Privacy data map ile uyumsuz ham payload loglama yasaklanir.
- Release readiness'te observability kaniti zorunlu tutulur.

---

# 11. Non-Goals

- viewer'a analytics paneli acmak
- gereksiz behavioural profiling
- full raw merchant payload arsivi tutmak
- yalniz vanity chart uretmek

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Ops dashboard'lari urun-semantic veri okur.
2. Internal test ve rollout planlari sayisal sinyal uretir.
3. Incident response availability disi trust olaylarini da metric ile gorur.
4. Support issue family'leri log arastirmasi degil canonical summary ile beslenir.

Ihlal belirtileri:

- support'un olaylarda request/job izini gorememesi
- import kalite sorunlarinin sadece manuel gözlemle fark edilmesi
- release gate toplantilarinda metric yerine sezgi kullanilmasi

---

# 13. Onay Kriterleri

- Minimum event seti canli ortamda gercekten uretiliyor olmalidir.
- Correlation id zinciri request -> job -> issue -> runbook akisini desteklemelidir.
- Privacy ve retention belgeleriyle uyumlu veri tutulmalidir.
- Release readiness kanit paketi observability sinyali icermelidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** API, jobs, ops tooling ve release evidence akisini etkiler.
- **Tahmini Efor:** Orta; event emission, naming ve dashboard wiring gerektirir.
- **Breaking Change:** Olası; dağinik log veya event adlari standardize olur.
- **Migration Adimlari:**
  - canonical event sozlugunu kodla hizala
  - correlation id ve reason code zincirini zorunlu kil
  - ops summary ve dashboard'lari bu event'lere bagla
- **Rollback Plani:** Event seti daraltilabilir veya genisletilebilir; ama minimum observability felsefesi yeni ADR olmadan kaldirilamaz.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - support ve ops'in tekrarli bicimde veri eksikligi yasamasi
  - privacy veya cost etkisinin beklenenden yuksek cikmasi
  - rollout ve incident kararlarinin mevcut event setiyle yeterince kanitlanamamasi
- **Degerlendirme Sorumlusu:** Ops owner + platform owner + product owner
- **Degerlendirme Kapsami:**
  - dashboard kapsami
  - supportability geri bildirimi
  - privacy ve retention uyumu
  - release gate kanit ihtiyaci
