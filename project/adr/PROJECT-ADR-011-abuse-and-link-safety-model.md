---
id: PROJECT-ADR-011
title: Abuse and Link Safety Model
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-011 - Abuse and Link Safety Model

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-011
- **Baslik:** Abuse and Link Safety Model
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Security / abuse governance
- **Karar alani:** External link guvenligi, blocked domain davranisi ve abuse response zincirini tanimlar.
- **Ilgili ust belgeler:**
  - `project/import/48-import-failure-modes-and-recovery-rules.md`
  - `project/compliance/92-external-link-and-merchant-content-policy.md`
  - `project/compliance/93-reporting-takedown-and-abuse-policy.md`
  - `project/quality/87-security-and-abuse-checklist.md`
- **Etkiledigi belgeler:**
  - `project/operations/102-incident-response-project-layer.md`
  - `project/operations/103-support-playbooks.md`
  - `project/implementation/114-internal-test-plan.md`
  - `project/ai-guardrails/GP-005-link-safety-and-abuse.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; security baseline'i urun-semantic abuse modeliyle somutlar.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Link safety kontrolu import pipeline'in zorunlu katmanidir.
- Blocked domain ve unsafe redirect durumlari publice cikmaz.
- Abuse ve takedown olaylari support bug'i gibi degil, guven olaylari gibi ele alinir.
- Policy remove, import failure ve public render davranisi ayni canonical state zincirine baglanir.

Bu ADR'nin ana hukmu sudur:

> Creator-girisi olan dis link sistemi, guvenlik ve abuse filtresi olmadan yayin katmanina ulasamaz.

---

# 2. Problem Tanimi

External link sistemi:

- phishing
- redirect zinciri
- scam product
- zararli merchant

gibi riskleri tasir. Bu riskler kontrollu model olmadan:

1. viewer'i dogrudan zarara iter
2. urun itibarini bozar
3. compliance ve store-review riskini buyutur
4. support issue'larini teknik bug gibi gostermeye baslar

---

# 3. Baglam

Bu urun creator recommendation odaklidir ve dis merchant URL'leri tasir. Bu nedenle platform:

- link normalize eder
- safety check yapar
- blocked/policy state'lerini public render'a tasir
- report/takedown zinciri kurar

Kisacasi "creator ne girerse yayinla" mantigi bu urunde kabul edilemez.

---

# 4. Karar Kriterleri

1. Viewer guvenligini korumak
2. Ops ve support icin net triage modeli kurmak
3. Import akisini gereksiz false positive ile felc etmemek
4. Policy ve technical state'i ayri ama bagli tutmak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Creator ne girerse yayinla

Eksiler:

- viewer zarar riskini kabul edilemez bicimde artirir

## 5.2. Sadece manuel raporlama sonrasi aksiyon al

Eksiler:

- proaktif safety yoktur
- publice risk sizar

## 5.3. Pipeline safety check + ops review modeli

Artisi:

- automation ile erken koruma
- ops/compliance ile kontrollu istisna yonetimi

---

# 6. Secilen Karar

Secilen model:

- URL normalization sonrasi safety check
- blocked domain listesi ve rule seti
- redirect zinciri analizi
- report/takedown akisi
- ops/compliance review queue

Baglayici kurallar:

1. Blocked veya unsafe link publice cikmaz.
2. `blocked` state teknik failure ile karistirilmaz.
3. Abuse report, support ticket gibi degil policy triage kaydi gibi ele alinir.
4. Safety sonucu creator'a acik copy ile anlatilir; sessiz yok etme yapilmaz.

---

# 7. Neden Bu Karar?

- Viewer guvenligini urun seviyesinde korur.
- Support ve ops icin net issue family yaratir.
- Import kalite hattini guvenlikten ayirmadan yonetir.
- Policy remove ve blocked link davranisini ayni state diliyle baglar.

---

# 8. Reddedilen Yonler

- Yalniz manuel rapora dayanmak reddedildi; cunku zarar ancak rapor gelene kadar sizar.
- Teknik failure gibi davranmak reddedildi; cunku blocked state policy ve safety state'idir.
- Support ekibini tek basina nihai otorite yapmak reddedildi; cunku compliance ve security zinciri gerekir.

---

# 9. Riskler

1. False positive blocked kararlar creator frustrasyonu yaratabilir.
2. Rule seti eskirse yeni abuse pattern'leri kacar.
3. Redirect kontrolleri maliyet veya latency baskisi yaratabilir.

---

# 10. Risk Azaltma Onlemleri

- Block reason code ve support copy acik tutulur.
- Ops/compliance review queue false positive temizligi yapar.
- Internal test ve support dry run abuse issue ailelerini zorunlu kapsar.
- Rule seti ve blocked listesi auditli sekilde guncellenir.

---

# 11. Non-Goals

- web-wide content moderation platformu olmak
- creator girisini tamamen manuel review'a baglamak
- blocked state'i generic 500 hatasina indirmek
- support'tan policy gerekcesini gizlemek

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Import pipeline safety gate kazanir.
2. Support playbook'lari `BROKEN_OR_BLOCKED_LINK` ve `UNSAFE_OR_ABUSIVE_CONTENT` ayrimini net kullanir.
3. Incident response, trust ve safety olaylarini availability disi ama kritik kategoriye alir.
4. AI guardrail'leri link safety'yi opsiyonel degil zorunlu kabul eder.

Ihlal belirtileri:

- blocked domain'lerin teknik retry ile tekrar acilmaya calisilmasi
- unsafe link issue'larinin generic bug kuyruğuna dusmesi
- creator'a neden aciklamasi olmadan linkin kaybolmasi

---

# 13. Onay Kriterleri

- Safety check import pipeline'in zorunlu adimi olmalidir.
- Blocked state, support ve public copy'de teknik failure'dan ayri gorunmelidir.
- Report/takedown ve abuse review zinciri calisir olmalidir.
- Internal test senaryolari unsafe link ve blocked domain davranisini kapsamalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Import entry, public outbound link ve support/compliance tooling alanlarini etkiler.
- **Tahmini Efor:** Orta; safety gate, copy, ops queue ve triage uyumu gerektirir.
- **Breaking Change:** Olası; daha once acik kabul edilen bazi linkler artik block olabilir.
- **Migration Adimlari:**
  - normalization sonrasi safety gate'i canonical hale getir
  - blocked reason ve policy state copy'sini tum yuzeylerde hizala
  - support/compliance triage akisini issue family bazli kur
- **Rollback Plani:** Safety model ancak yeni ADR ile yumusatilir; gizli allowlist veya bypass rollback degil ihlaldir.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - false positive blocked oraninin kabul edilemez hale gelmesi
  - yeni abuse pattern'lerinin mevcut modelin disinda kalmasi
  - store-review veya compliance geri bildiriminin ek kontrol istemesi
- **Degerlendirme Sorumlusu:** Security/compliance owner + ops owner + product owner
- **Degerlendirme Kapsami:**
  - blocked/abuse issue trendleri
  - support escalation kalitesi
  - false positive/false negative dengesi
  - public guven sinyalleri
