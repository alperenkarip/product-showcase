# 18-adr-template.md

## Doküman Kimliği

- **Doküman adı:** ADR Template
- **Dosya adı:** `18-adr-template.md`
- **Doküman türü:** Template / decision-writing standard / ADR authoring guide
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Kapsam:** Bu belge, boilerplate kapsamında yeni bir Architecture Decision Record yazılması gerektiğinde kullanılacak standart şablonu, yazım kurallarını, zorunlu başlıkları, karar seviyesi eşiklerini ve kabul kriterlerini tanımlar. Bu belge ADR içeriği üretmez; ADR yazımını standartlaştırır.
- **İlgili belgeler:**
  - `17-technology-decision-framework.md`
  - `35-document-map.md`
  - `36-canonical-stack-decision.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`
  - mevcut ADR seti (`ADR-001` → `ADR-019`)

---

# 1. Amaç

Bu şablonun amacı, yeni bir kararın:
- neden açıldığını,
- hangi problemi çözdüğünü,
- hangi alternatifleri değerlendirdiğini,
- neyi seçtiğini,
- neyi reddettiğini,
- hangi riskleri getirdiğini,
- hangi diğer belgeleri etkilediğini
net ve denetlenebilir biçimde kayda geçirmektir.

ADR, "not" değildir.
ADR, "toplantı özeti" değildir.
ADR, "teknoloji tanıtımı" değildir.

ADR şudur:
> **Projede kalıcı etkisi olan bir teknik veya yapısal kararın resmi kaydı.**

---

# 2. Ne Zaman ADR Gerekir?

Aşağıdaki durumlardan biri varsa ADR güçlü adaydır:

1. canonical stack yönünü etkileyen karar
2. runtime veya build zincirini değiştiren karar
3. ikinci bir tool family açan karar
4. auth/security/storage etkisi olan karar
5. styling/theming/token authority’yi etkileyen karar
6. testing/CI topolojisini etkileyen karar
7. monorepo/package boundary etkisi olan karar
8. migration ve exit cost’u yüksek karar
9. vendor lock-in riski yüksek karar
10. birden fazla belgeyi aynı anda etkileyen karar

Aşağıdaki tip kararlar çoğu zaman ADR gerektirmez:
- küçük utility helper eklemek
- isim düzeltmek
- saf refactor
- docs typo düzeltmek
- runtime davranışı değiştirmeyen küçük script eklemek

---

# 3. ADR Yazım Kuralları

## 3.1. Temel kurallar
- muğlak yazma
- alternatifleri saklama
- kararın maliyetini gizleme
- riskleri küçültme
- vendor veya araç lehine pazarlama dili kullanma
- karar alanını olduğundan küçük gösterme

## 3.2. Zorunlu ayrımlar
Her ADR mümkün olduğunca şu ayrımı korumalıdır:
- **Problem**
- **Bağlam**
- **Değerlendirilen alternatifler**
- **Seçilen karar**
- **Neden bu karar**
- **Reddedilen yönler**
- **Riskler**
- **Risk azaltma önlemleri**
- **Non-goals**
- **Etkilediği belgeler ve sonuçlar**

## 3.3. Yazım tarzı
- karar net olmalı
- “şimdilik böyle” dili kullanılmamalı
- “ileride bakarız” ile karar alanı kapatılıyormuş gibi yapılmamalı
- ürün kapsamı ile boilerplate kapsamı karıştırılmamalı
- implementation detayı ile karar seviyesi birbirine karıştırılmamalı

---

# 4. Önerilen ADR Dosya Adı Formatı

Canonical format:

`ADR-XXX-<kebab-case-karar-adi>.md`

Buradaki `XXX` ve `<kebab-case-karar-adi>` gerçek dosya adı değildir; şablon placeholderıdır. Yeni ADR yazılırken bu iki alan gerçek sıra numarası ve gerçek karar adı ile değiştirilir.

Örnekler (bunlar gerçek dosya adı örnekleridir, placeholder değildir):
- `ADR-001-web-runtime-and-application-shell.md`
- `ADR-003-monorepo-package-manager-and-build-orchestration.md`
- `ADR-007-styling-tokens-and-theming-implementation.md`

Kurallar:
- `ADR-XXX` kısmı sıralı olmalı
- açıklama kısa ama yeterince anlamlı olmalı
- dosya adı ile belge başlığı birebir yakın olmalı
- “final”, “new”, “latest”, “last” gibi geçici kelimeler kullanılmamalı

---

# 5. Önerilen ADR Şablonu

Aşağıdaki şablon yeni ADR yazarken kullanılmalıdır:

```md
# ADR-XXX — <Karar Başlığı>

## Doküman Kimliği

- **ADR ID:** ADR-XXX
- **Başlık:** <Karar Başlığı>
- **Durum:** Proposed / Accepted / Superseded / Deprecated
- **Tarih:** YYYY-MM-DD
- **Karar türü:** <Foundational / Runtime / Governance / Tooling / Security / UX-system / etc.>
- **Karar alanı:** <Bu ADR tam olarak hangi alanı kapatıyor?>
- **İlgili üst belgeler:**
  - `<ilgili ana standartlar>`
- **Etkilediği belgeler:**
  - `<revize edilmesi gereken belgeler>`

---

# 1. Karar Özeti

Bu ADR ile aşağıdaki karar kabul edilmiştir:

- <karar 1>
- <karar 2>
- <karar 3>

Bu ADR’nin ana hükmü şudur:

> <kararın tek paragrafta sert ve net özeti>

---

# 2. Problem Tanımı

<karar verilmezse hangi operasyonel veya mimari sorun çıkıyor?>

---

# 3. Bağlam

<ürün, platform, kalite, mimari ve operasyon bağlamı>

---

# 4. Karar Kriterleri

1. <kriter>
2. <kriter>
3. <kriter>

---

# 5. Değerlendirilen Alternatifler

1. <alternatif 1>
2. <alternatif 2>
3. <alternatif 3>

---

# 6. Seçilen Karar

<seçilen yönün ayrıntılı açıklaması>

---

# 7. Neden Bu Karar?

<neden seçildiğinin net gerekçeleri>

---

# 8. Reddedilen Yönler

<neden reddedildi?>

---

# 9. Riskler

<teknik ve operasyonel riskler>

---

# 10. Risk Azaltma Önlemleri

<mitigation listesi>

---

# 11. Non-Goals

<bu ADR’nin bilinçli olarak çözmediği alanlar>

---

# 12. Sonuç ve Etkiler

<repo, docs, contribution, audit, CI, implementation etkileri>

---

# 13. Onay Kriterleri

<bu ADR hangi koşullarda yeterli kabul edilir?>

---

# 14. Migration Impact

- **Mevcut Kod Etkisi:** [Yok / Düşük / Orta / Yüksek]
- **Tahmini Efor:** [Saat / Gün / Hafta bazlı]
- **Breaking Change:** [Evet / Hayır]
- **Migration Adımları:** (varsa)
  1. Etkilenen dosya ve modüllerin tespiti
  2. Mevcut implementasyonun yeni karara göre refactor edilmesi
  3. Test suite'in güncellenmesi ve geçirilmesi
  4. CI pipeline'ın yeni karara uyumlu hale getirilmesi
  5. Doküman referanslarının güncellenmesi
- **Rollback Planı:** (karar geri alınırsa ne yapılır)
  - Hangi dosyalar revert edilir?
  - Dependency değişiklikleri nasıl geri alınır?
  - Geçiş sırasında üretilen veri/artifact nasıl temizlenir?
  - Superseded ADR ile geçiş nasıl belgelenir?

Bu bölüm her ADR'de zorunludur. Migration impact değerlendirmesi yapılmadan ADR kabul edilemez.

---

# 15. Yeniden Değerlendirme (Revalidation)

- **Revalidation Tarihi:** [YYYY-MM-DD veya "Koşullu"]
- **Tetikleyici Koşul:** [ör. "NativeWind 5.x stable olunca", "SDK 56 release olunca", "Major dependency upgrade yapıldığında"]
- **Değerlendirme Sorumlusu:** [Rol veya kişi — ör. "Mobile Lead", "Architecture Owner"]
- **Değerlendirme Kapsamı:**
  - Seçilen aracın ekosistem sağlığı (npm downloads trendi, GitHub activity, security advisories)
  - Alternatiflerin güncel durumu (reddedilen seçeneklerde kayda değer gelişme var mı?)
  - Kararın ürettiği teknik borç veya friction seviyesi
  - Compatibility matrix (38) ile uyum durumu
- **Sonuç Seçenekleri:**
  - ✅ Karar geçerli, değişiklik gereksiz
  - ⚠️ Karar geçerli ama addendum gerekiyor
  - 🔄 Karar yeniden değerlendirilmeli, yeni ADR açılmalı
  - ❌ Karar superseded, yeni ADR ile değiştirilmeli

Bu bölüm her ADR'de zorunludur. Revalidation tanımlanmadan ADR "süresiz geçerli" sayılmaz; periyodik veya koşullu gözden geçirme planı olmalıdır.
```

---

# 6. Durum Alanı Nasıl Kullanılır?

## 6.1. `Proposed`
Karar hazırlanıyor ama kabul edilmedi.

## 6.2. `Accepted`
Karar resmi baseline haline geldi.

## 6.3. `Superseded`
Yerine başka ADR geçti.

## 6.4. `Deprecated`
Karar tarihsel olarak kayıtlı ama artık aktif referans değil.

Kural:
- aynı alan için iki çelişkili `Accepted` ADR bırakılmaz
- supersede durumunda document map ve ilgili operasyonel belgeler güncellenir

---

# 7. ADR Yazarken Sorulacak Zorunlu Sorular

1. Bu karar gerçekten ADR seviyesinde mi?
2. Problem net mi?
3. Mevcut canonical stack ile ilişkisi açık mı?
4. Alternatifler dürüstçe yazıldı mı?
5. Riskler saklandı mı?
6. Etkilenen belgeler listelendi mi?
7. Dependency policy etkisi var mı?
8. Compatibility matrix etkisi var mı?
9. Repo/bootstrap/test/audit etkisi açık mı?
10. Bu ADR implementation ekibine karar aldıracak netlikte mi?

---

# 8. Çok Sık Yapılan Hatalar

1. ADR’yi teknoloji tanıtımına çevirmek
2. Kararı tek cümle yazıp gerisini boş bırakmak
3. Alternatifleri göstermemek
4. Riskleri küçültmek
5. Etkilediği belgeleri yazmamak
6. “Belki sonra değişir” diye kararı muğlak bırakmak
7. exact implementation detaylarını kararın yerine geçirmek
8. eski ADR’yi supersede etmeden yeni Accepted ADR yazmak

---

# 9. Bu Şablonun İlişkili Olduğu Gerçek Örnekler

Bu repo içinde şu belgeler referans örnek olarak okunabilir:

- `ADR-001-web-runtime-and-application-shell.md`
- `ADR-002-mobile-runtime-and-native-strategy.md`
- `ADR-003-monorepo-package-manager-and-build-orchestration.md`
- `ADR-004-state-management.md`
- `ADR-005-data-fetching-cache-and-mutation-model.md`
- `ADR-006-forms-and-validation.md`
- `ADR-007-styling-tokens-and-theming-implementation.md`
- `ADR-008-testing-stack.md`
- `ADR-009-observability-stack.md`
- `ADR-010-auth-session-and-secure-storage-baseline.md`
- `ADR-011-internationalization-baseline.md`
- `ADR-012-navigation-baseline.md`

---

# 10. Kısa Sonuç

Bu şablonun amacı, ADR yazımını keyfi ve yüzeysel olmaktan çıkarıp; kararın problemi, bağlamı, alternatifleri, riskleri ve repo üzerindeki etkisini görünür hale getiren standart bir yazım rejimi oluşturmaktır. Yeni bir karar, bu şablonun ruhuna uymuyorsa çoğu zaman ya ADR seviyesi değildir ya da yeterince olgunlaşmamıştır.
