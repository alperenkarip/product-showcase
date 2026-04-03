---
id: PROJECT-ADR-009
title: Share Extension Adoption Decision
doc_type: project_adr
status: accepted
last_updated: 2026-04-02
source_of_truth: true
---

# PROJECT-ADR-009 - Share Extension Adoption Decision

## Dokuman Kimligi

- **ADR ID:** PROJECT-ADR-009
- **Baslik:** Share Extension Adoption Decision
- **Durum:** Accepted
- **Tarih:** 2026-04-02
- **Karar turu:** Mobile capability sequencing
- **Karar alani:** Share extension'in launch cekirdegi icinde olup olmayacagini ve ne kosulla sonraki faza tasinacagini tanimlar.
- **Ilgili ust belgeler:**
  - `project/design/53-creator-mobile-screen-spec.md`
  - `project/implementation/110-project-roadmap.md`
  - `project/implementation/112-feature-sequencing-and-dependency-order.md`
- **Etkiledigi belgeler:**
  - `project/architecture/62-mobile-surface-architecture.md`
  - `project/architecture/68-deep-linking-and-share-entry-model.md`
  - `project/implementation/115-launch-transition-plan.md`
- **Boilerplate ADR catisma kontrolu:** Catisma yok; mobile runtime ve deep-linking kararlarini fazlar.

---

# 1. Karar Ozeti

Bu ADR ile asagidaki karar kabul edilmistir:

- Launch cekirdegi paste-first quick add akisidir.
- Native-grade share extension ilk genel erisim icin zorunlu capability degildir.
- Clipboard/paste ve kontrollu deep-link girisi zorunlu fallback olarak bulunur.
- Share extension ancak creator core loop ve import kalitesi kanitlandiktan sonra genisleme capability'si olarak ele alinir.

Bu ADR'nin ana hukmu sudur:

> Share extension degerli bir hiz artisi saglar; ama ilk kullanilabilir urun kalitesi onun uzerine bagimli kilinmaz.

---

# 2. Problem Tanimi

Share extension'i launch blocker yapmak:

1. mobil takvimi native/platform riskine baglar
2. urun cekirdegi olan import kalitesinden odağı uzaklastirir
3. iOS/Android parity ve review risklerini gereksizce kritik yola sokar
4. extension kirildiginda hiz hikayesini tamamen cokertebilir

Ters tarafta extension'i sonsuza kadar reddetmek de creator hiz vaadini gereksiz kisar.

---

# 3. Baglam

Creator quick add kritik capability'dir; ama bunu basarmanin tek yolu native extension degildir. Paste, clipboard ve deep-link girisi ile:

- link alma
- verification'a gecis
- page/shelf secimi

cozulabilir. Native extension ise daha sonra:

- platform izinleri
- lifecycle karmaşıkligi
- share payload edge-case'leri

dogru cozuldugunde ek deger uretir.

---

# 4. Karar Kriterleri

1. Launch takvimini gereksiz native risklere kilitlememek
2. Creator hiz vaadini minimum uygulanabilir seviyede korumak
3. Mobile roadmap'i kontrollu fazlamak
4. Fallback'siz bir hiz iddiasi kurmamak

---

# 5. Degerlendirilen Alternatifler

## 5.1. Share extension'i zorunlu launch capability'si yapmak

Eksiler:

- launch riskini asiri arttirir
- quick add degerini platform spesifik kilitlere baglar

## 5.2. Share extension'i tamamen reddetmek

Eksiler:

- creator hiz hikayesini gereksiz sinirlar
- sonraki fazlarda degerli olabilecek bir capability'yi erken gomer

## 5.3. Paste-first launch + extension sonraki capability

Artisi:

- core utility bugun saglanir
- native hiz artisi ayri delivery fazinda guvenli sekilde eklenir

---

# 6. Secilen Karar

Secilen model:

- quick add icin paste/clipboard girisi launch'ta zorunlu
- deep-link veya incoming share entry kontrollu desteklenebilir
- native extension sonraki faz capability'si

Baglayici kurallar:

1. Launch UX copy'si hiz vaadini extension'a bagli anlatmaz.
2. Share extension yokken creator loop eksik sayilmaz; paste-first akisin kaliteli olmasi zorunludur.
3. Extension eklenirse de fallback akisi yasamaya devam eder.
4. Extension support edilirse app review, permission ve edge-case testleri ayri gate alir.

---

# 7. Neden Bu Karar?

- Core utility import ve verify'dir; extension sadece girisi hizlandirir.
- Native capability'yi kritik yoldan almak launch riskini dusurur.
- Clipboard/deep-link fallback'i platform kirilmasina karsi emniyet supabidir.
- Sequencing discipline korunur.

---

# 8. Reddedilen Yonler

- Extension'i launch zorunlulugu yapmak reddedildi; cunku quality odagini dagitir.
- "Nasilsa sonra bakariz" diyerek fallback'siz tasarlamak reddedildi; cunku creator hareket halinde giris ihtiyacini bozar.
- Extension'i tamamen kapatmak reddedildi; cunku orta vadede degerli hiz artisi saglayabilir.

---

# 9. Riskler

1. Bazi creator'lar native share beklentisi tasiyabilir.
2. Paste-first UX kotu olursa extension yoklugu abartili hissedilir.
3. Sonraki fazda extension eklendiginde terminology drift olabilir.

---

# 10. Risk Azaltma Onlemleri

- Paste-first akisi launch'ta premium kalitede kurulur.
- Mobile copy, hizli eklemeyi extension terimiyle degil sonuc odakli anlatir.
- Deep-linking ve resume modeli erkenden canonical hale getirilir.
- Extension sonrasi capability, yeni ADR gerektirmeden bu ADR'nin kosullariyla izlenir ama ayri delivery gate alir.

---

# 11. Non-Goals

- extension'siz hizli eklemenin imkansiz oldugunu varsaymak
- launch'ta native parity zorlugu yaratmak
- creator web veya mobile quick add'i extension'a gore tasarlamak
- extension yokken kullaniciyi cikissiz birakmak

---

# 12. Sonuc ve Etkiler

Bu karar su etkileri yaratir:

1. Roadmap'te share extension kritik yol disina alinir.
2. Creator mobile spec paste-first loop'u derinlestirir.
3. Deep-linking modeli extension'siz de tamamli davranmak zorunda kalir.
4. Launch transition plan'i extension'i gate disi capability olarak izler.

Ihlal belirtileri:

- launch checklist'inde extension olmadan cikamayiz varsayimi
- paste-first akisin ikinci sinif deneyim olarak birakilmasi
- quick add copy'sinin extension mevcudiyetine baglanmasi

---

# 13. Onay Kriterleri

- Launch'ta paste-first quick add tam calisiyor olmalidir.
- Deep-link veya clipboard resume akisi creator'i kaybettirmemelidir.
- Share extension eksikligi release blocker sayilmamalidir.
- Extension gelecekte eklenirse fallback akisi bozulmamalidir.

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** Mobile backlog ve launch gate siralamasini etkiler.
- **Tahmini Efor:** Dusuk/orta; capability sequencing ve UX copy hizasi gerekir.
- **Breaking Change:** Hayir; daha cok backlog ve launch scope etkisi vardir.
- **Migration Adimlari:**
  - share extension task'larini critical path disina tasi
  - paste-first akisin eksik kisimlarini launch zorunlulugu olarak etiketle
  - launch copy'sini extension-free utility diline cek
- **Rollback Plani:** Extension'i kritik yola geri almak ancak yeni ADR veya superseding karar ile mumkundur.

---

# 15. Yeniden Degerlendirme

- **Revalidation Tarihi:** Kosullu
- **Tetikleyici Kosul:**
  - creator cohort verisinin extension'siz quick add'in belirgin adoption duvarı oldugunu gostermesi
  - platform risklerinin kabul edilebilir seviyeye inmesi
  - paste-first akisin yetersiz kalmasi
- **Degerlendirme Sorumlusu:** Mobile owner + product owner + launch owner
- **Degerlendirme Kapsami:**
  - quick add completion rate
  - creator feedback temalari
  - platform review ve maintenance riski
  - deep-link/fallback basari oranlari
