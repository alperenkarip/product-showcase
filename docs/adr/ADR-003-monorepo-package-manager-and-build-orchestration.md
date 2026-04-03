# ADR-003 — Monorepo, Package Manager and Build Orchestration

## Doküman Kimliği

- **ADR ID:** ADR-003
- **Başlık:** Monorepo, Package Manager and Build Orchestration
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational repository topology and workflow decision
- **Karar alanı:** Repo topolojisi, monorepo seçimi, package manager seçimi, task orchestration, shared package sınırları, docs/tooling/scripts/config ayrımı, workspace yönetimi
- **İlgili üst belgeler:**
  - `00-project-charter.md`
  - `01-working-principles.md`
  - `02-product-platform-philosophy.md`
  - `06-application-architecture.md`
  - `07-module-boundaries-and-code-organization.md`
  - `17-technology-decision-framework.md`
  - `19-roadmap-to-implementation.md`
  - `21-repo-structure-spec.md`
  - `37-dependency-policy.md`
  - `38-version-compatibility-matrix.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `29-release-and-versioning-rules.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `35-document-map.md`
  - `36-canonical-stack-decision.md`

---

# 1. Karar Özeti

Bu boilerplate için repository ve build-workflow omurgası aşağıdaki gibi kabul edilmiştir:

- **Repo modeli:** Monorepo
- **Package manager:** pnpm 10.x
- **Task/build orchestration:** Turborepo 2.x
- **Ana çalışma yüzeyleri:** `apps/`, `packages/`, `docs/`, `tooling/`, `scripts/`
- **Başlangıç app seti:** `apps/web`, `apps/mobile`
- **Başlangıç package seti:** `packages/core`, `packages/design-tokens`, `packages/ui`, `packages/config-typescript`, `packages/config-eslint`, `packages/testing`
- **Docs yaklaşımı:** repo içi birincil otorite
- **Tooling yaklaşımı:** custom governance ve quality tooling repo citizen
- **Kural:** shared-by-proof, not shared-by-ambition

Bu ADR’nin ana hükmü şudur:

> Bu boilerplate tek repo içinde yaşayacaktır. Web ve mobile uygulamaları, shared foundation package’leri, docs, tooling ve scripts tek monorepo altında yönetilecektir. Package manager olarak pnpm, task orchestration için Turborepo kullanılacaktır. Repo topolojisi klasör estetiği değil, mimari sınırların fiziksel karşılığı olarak ele alınacaktır.

---

# 2. Problem Tanımı

Cross-platform boilerplate kurarken ilk büyük karar alanlarından biri repo modelidir.  
Bu alan belirsiz bırakılırsa şu sorunlar ortaya çıkar:

- web ve mobile ayrı repo’lara kayar
- shared domain ve shared UI kuralları kâğıtta kalır
- docs ve ADR’ler runtime kodundan kopar
- config tekrarları büyür
- dependency sürümleri drift yaşar
- CI ve local task orchestration dağınıklaşır
- shared-by-proof yerine copy-paste kültürü gelişir
- boundary enforcement zayıflar
- “ortak ama aslında farklı” kod yapıları çoğalır

Bu yüzden repo modeli sıradan klasör kararı değildir.  
Asıl soru şudur:

> Web, mobile, shared foundations, docs ve tooling aynı sistem olarak mı yönetilecek, yoksa gevşek bağlı ayrı parçalar gibi mi yaşatılacak?

Bu ADR tam olarak bunu kapatır.

---

# 3. Bağlam

Bu boilerplate aşağıdaki özellikleri aynı anda taşımak istiyor:

1. Web ve mobile birlikte düşünülen ürün omurgası
2. Shared domain logic
3. Shared design tokens
4. Shared UI primitives/components
5. Tek kalite sistemi
6. Tek docs-first karar sistemi
7. CI ve local workflow’un koordineli olması
8. Dependency ve version governance’in merkezi işletilmesi
9. Tooling ve HIG enforcement’in repo vatandaşı olması
10. İlk gün küçük, zamanla büyüyebilen repo yapısı

Bu bağlamda repo kararı iki uçtan da kaçınmalıdır:

- tek düz repo içinde her şeyi app içine yığmak
- gereksiz micro-package yağışı ile monorepo’yu teorik şıklık alanına çevirmek

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. Cross-platform uygunluğu
2. Shared foundation yönetimi
3. Docs-first çalışma modeli
4. Dependency sürüm disiplini
5. CI/local task yönetimi
6. Config tekrarını azaltma
7. Mimari sınırları görünür kılma
8. Öğrenme/bakım maliyeti
9. Tooling ve governance’i repo içinde tutabilme
10. Uzun vadeli genişletilebilirlik

---

# 5. Seçilen Karar

## 5.1. Repo modeli
- **Monorepo**

## 5.2. Package manager
- **pnpm 10.x**

## 5.3. Task/build orchestration
- **Turborepo 2.x**

## 5.4. Root topoloji
- `apps/`
- `packages/`
- `docs/`
- `tooling/`
- `scripts/`
- root config files

## 5.5. Başlangıç app’leri
- `apps/web`
- `apps/mobile`

## 5.6. Başlangıç foundation package’leri
- `packages/core`
- `packages/design-tokens`
- `packages/ui`
- `packages/config-typescript`
- `packages/config-eslint`
- `packages/testing`

---

# 6. Neden Monorepo?

## 6.1. Çünkü bu proje iki ayrı ürün değil, tek ürün sistemidir

Web ve mobile burada rastgele iki ayrı istemci değildir.  
Ortaklaştıkları şeyler vardır:

- domain mantığı
- quality gates
- docs ve ADR sistemi
- design token authority
- bazı UI foundations
- testing support
- tooling/governance

Bunları iki ayrı repo’da yaşatmak:
- tekrar üretir,
- drift üretir,
- otoriteyi dağıtır.

## 6.2. Çünkü docs-first model repo vatandaşı olmalıdır

Bu projede docs:
- repo dışı wiki,
- açıklama klasörü,
- sonradan yazılan not
değildir.

Docs:
- karar verir,
- build/review/checklist süreçlerini etkiler,
- repo topolojisini yönlendirir.

Bu model monorepo’da daha doğal yaşar.

## 6.3. Çünkü dependency ve version governance merkezi olmalıdır

Bu boilerplate için dependency policy ve compatibility matrix merkezi düşünülmüştür.  
Ayrı repo modeli şunları zorlaştırır:

- sürüm zinciri senkronizasyonu
- root policy enforcement
- shared config packages
- parallel upgrade yönetimi

## 6.4. Çünkü tooling ve governance ayrı repo değil, sistemin parçasıdır

Custom lint, HIG enforcement, codemod veya verification scripts gibi tooling bileşenleri bu projede ikinci sınıf vatandaş değildir.  
Monorepo bunların uygulama ve docs ile birlikte evrilmesine imkân verir.

---

# 7. Neden Polyrepo Değil?

Polyrepo yaklaşımı şu açılardan zayıf değerlendirilmiştir:

## 7.1. Drift riski
Web, mobile ve shared foundations farklı hızlarda bozulur.

## 7.2. Shared package yönetim yükü
Küçük shared package’ler için bile publish/version/bump senaryoları büyür.

## 7.3. Docs ve karar dağılması
ADR ve docs seti merkezi kalmak yerine kopyalara veya dış sisteme kayar.

## 7.4. CI karmaşıklığı
Aslında sade görünür ama değişiklik etkisi görünmezleşir.

## 7.5. Boilerplate bağlamında aşırı operasyon maliyeti
Bu repo’nun hedefi çok ekipli kurumsal servis federasyonu değildir.  
Bu yüzden polyrepo burada fazla pahalıdır.

---

# 8. Neden pnpm?

## 8.1. Seçim
Package manager olarak:
- **pnpm 10.x**

## 8.2. Neden pnpm?

### A. Workspace gücü
Monorepo için doğal ve güçlü workspace modeli sunar.

### B. Dependency disiplinine uygunluk
Daha kontrollü ve daha görünür dependency davranışı üretir.

### C. Disk ve install verimliliği
pnpm’nin içerik-adreslenmiş store ve verimli install modeli monorepo için güçlü avantajdır.

### D. 10.x hattı güncel ve aktif
pnpm 10 hattı güncel, aktif bakım alan ve güvenlik/disiplin yönü güçlenen bir hattır.

## 8.3. Neden npm değil?

- workspace desteği artık var olsa da monorepo ergonomisi ve governance için pnpm kadar güçlü fit sunmaz
- disk ve dependency topology disiplini açısından zayıf kalır

## 8.4. Neden Yarn değil?

Yarn güçlü olabilir.  
Ama bu boilerplate bağlamında:
- pnpm workspace doğal fit’i,
- dependency kontrol modeli,
- daha sade monorepo hikâyesi
nedeniyle tercih edilmemiştir.

## 8.5. Neden Bun değil?

Bun hızlı olabilir.  
Ama bu proje için öncelik yalnızca hız değil:
- ekosistem uyumu,
- monorepo maturity,
- risk azaltma,
- long-term boring reliability’dir.

Bun bu bağlamda baseline olarak seçilmemiştir.

---

# 9. Neden Turborepo?

## 9.1. Seçim
Task/build orchestration için:
- **Turborepo 2.x**

## 9.2. Neden?

### A. Task graph ve caching
Monorepo içindeki build/test/lint/typecheck görevleri için açık ve güçlü task graph sağlar.

### B. Local + CI workflow uyumu
Aynı görev mantığı local ve CI’da anlamlı şekilde taşınabilir.

### C. Incremental build ve cache davranışı
Content-aware caching ve selective task execution monorepo için büyük avantajdır. Turborepo bu alanın ana değer önerisidir.

### D. Bu proje için doğru sadelik seviyesi
Nx gibi daha ağır kurumsal workflow katmanlarına kıyasla daha yalın ama güçlü bir model sunar.

## 9.3. Neden Nx değil?

Nx güçlü olabilir.  
Ama bu boilerplate bağlamında:
- erken aşamada fazla frameworkleşme riski
- generator/workspace opinionation maliyeti
- gereksiz kurumsal ağırlık
oluşturabilir.

Bu proje için başlangıçta doğru denge Turborepo ile daha iyi kurulmaktadır.

## 9.4. Neden task orchestration hiç olmasın?
Çünkü monorepo’da şu sorunlar büyür:
- hangi package etkileniyor
- ne rebuild/test edilmeli
- CI’da ne koşmalı
- local verify nasıl hızlı kalmalı

Orchestration olmadan bu işler manuel kaosa döner.

---

# 10. Root Topoloji Kararı

## 10.1. Canonical root alanları

```text
/
├─ apps/
├─ packages/
├─ docs/
├─ tooling/
├─ scripts/
├─ .github/
└─ root config files
```

## 10.2. Bu alanların rolleri

### `apps/`
Çalıştırılabilir uygulama kabukları

### `packages/`
Gerçek shared foundations

### `docs/`
Yaşayan karar ve standart sistemi

### `tooling/`
Custom lint, HIG enforcement, codemod, repo validators

### `scripts/`
Operational commands

### `.github/`
Workflow, PR template ve repo automation yüzeyi

### Root config
Workspace/orchestration/lint/TS/ignore/env template

## 10.3. Kural
Root, çöplük değil;  
repo seviyesinde otorite yüzeyidir.

---

# 11. Exact Başlangıç App Kararı

## 11.1. Başlangıç app seti
- `apps/web`
- `apps/mobile`

## 11.2. Neden yalnızca iki app?
Bu aşamada amaç:
- temel ürün kabuklarını kurmak
- gereksiz yardımcı app çoğaltmamak

Storybook, playground veya docs app gibi ek yüzeyler:
- sonradan açık gerekçeyle eklenebilir
- baseline’ın parçası olmak zorunda değildir

---

# 12. Exact Başlangıç Package Kararı

## 12.1. Package seti
- `packages/core`
- `packages/design-tokens`
- `packages/ui`
- `packages/config-typescript`
- `packages/config-eslint`
- `packages/testing`

## 12.2. Neden bu kadar?
Çünkü amaç:
- gerçek shared foundations’ı görünür yapmak
- ama “her şeyi package’a bölme” hastalığına düşmemektir

## 12.3. Neden feature package’leri yok?
Feature code varsayılan olarak app içinde kalır.

Bu çok kritik kuraldır.

---

# 13. Shared-by-Proof İlkesi

Bu ADR’nin merkezindeki fiziksel ilke şudur:

> **Shared-by-proof, not shared-by-ambition**

## 13.1. Ne demek?
Bir şey:
- teorik olarak tekrar kullanılabilir diye package olmaz
- iki dosyada benzer göründü diye shared yapılmaz
- “ileride belki lazım olur” diye yukarı taşınmaz

## 13.2. Ne zaman shared yapılır?
Ancak şu durumda:
- gerçekten birden fazla consumer vardır
- shared yapılınca boundary netleşir
- bakım maliyeti düşer
- ownership daha temiz hale gelir

## 13.3. Sonuç
Monorepo, herkesi package yapma izni vermez.  
Tersine, kontrollü paylaşım rejimi getirir.

---

# 14. Feature Code Neden App İçinde Kalıyor?

## 14.1. Çünkü feature çoğu zaman app composition’a bağlıdır
Feature şu şeylere sık bağlıdır:
- route/screen composition
- local orchestration
- query hooks
- form wiring
- auth/session gates
- platform adaptation

Bunları erkenden shared package yapmak çoğu zaman sahte soyutlama üretir.

## 14.2. Ne zaman feature package olabilir?
Sadece:
- iki app gerçekten aynı feature modülünü anlamlı kullanıyorsa
- public surface netse
- taşımanın faydası kanıtlıysa

Aksi halde app içinde kalmalıdır.

---

# 15. Docs Neden Repo İçinde?

## 15.1. Çünkü docs bu projede ikincil değil
Bu projede docs:
- karar hafızası
- quality standard
- implementation guide
- audit ve DoD referansı
rolünü taşır.

## 15.2. Sonuç
`docs/` alanı repo citizen’dir.  
Repo dışı wiki mantığı canonical değildir.

---

# 16. Tooling Neden Ayrı Alan?

## 16.1. Çünkü tooling app runtime kodu değildir
Custom lint plugin, HIG runtime checker veya codemod script’i:
- ürün özelliği değildir
- ama kalite omurgasının parçasıdır

## 16.2. Sonuç
Bunlar:
- app içine gömülmez
- random script klasörüne atılmaz
- `tooling/` altında yaşar

---

# 17. Config Package Kararı

## 17.1. Neden `packages/config-typescript` ve `packages/config-eslint` var?
Çünkü:
- config tekrarı azaltılmalı
- apps ve packages ortak standardı tüketmeli
- root’a kopya config saçılmamalı

## 17.2. Kural
Config otoritesi de reusable foundation’dır.  
Bu yüzden package olarak yaşaması meşrudur.

---

# 18. Testing Package Kararı

## 18.1. Neden `packages/testing` var?
Çünkü:
- shared test helpers
- custom render utilities
- ortak fixture builders
- deterministic test setup yardımcıları
tekrar üretilebilir.

## 18.2. Ama dikkat
Feature-private mocks bu pakete taşınmaz.

Bu ayrım çok önemlidir.

---

# 19. Build / Task Orchestration Modeli

## 19.1. Kural
Turborepo görevleri repo’nun ana kalite yüzeylerini modellemelidir.

Beklenen ana task aileleri:
- `build`
- `typecheck`
- `lint`
- `test`
- `test:e2e`
- `verify`
- `docs:check` veya eşdeğer
- gerektiğinde `storybook` / `dev` / `clean`

## 19.2. Neden?
Çünkü repo’nun neyi “iş” saydığı görünür olmalıdır.

## 19.3. Kural
Task naming ve scope mantığı contributor için tahmin edilebilir olmalıdır.

---

# 20. CI ile İlişkisi

## 20.1. Monorepo kararı CI’ı etkiler
CI şu avantajları alır:
- changed packages/apps odaklı çalışma
- merkezi task graph
- caching
- root governance

## 20.2. Ama dikkat
Monorepo tek başına hız demek değildir.
Yanlış task graph kurulursa tersi de olabilir.

Bu yüzden Turborepo seçimi yanında task discipline de gereklidir.

---

# 21. Dependency Governance ile İlişkisi

Bu ADR doğrudan `37-dependency-policy.md` ile bağlıdır.

## 21.1. Neden?
Çünkü monorepo kararı şunu zorunlu kılar:
- dependency sınıfları görünür olacak
- root vs package dependency disiplini olacak
- duplicate dependency ve version drift yönetilecek
- “bir package kendi kafasına göre ikinci tool kurdu” davranışı görünür olacak

---

# 22. Compatibility Matrix ile İlişkisi

Bu ADR doğrudan `38-version-compatibility-matrix.md` ile bağlıdır.

## 22.1. Neden?
Çünkü:
- Node baseline
- pnpm line
- Turbo line
- Expo / React / RN chain
- Vite / React chain
aynı anda yönetilmelidir.

Monorepo kararı compatibility matrix olmadan eksik kalır.

---

# 23. Reddedilen Alternatifler

## 23.1. Polyrepo
Reddedildi.
Neden:
- drift
- docs dağılması
- shared foundations için publish/version yükü
- governance kaybı

## 23.2. npm workspace
Reddedildi.
Neden:
- pnpm kadar güçlü fit üretmiyor

## 23.3. Yarn-first
Reddedildi.
Neden:
- bu repo için gerekli fayda üstün gelmedi

## 23.4. Bun-first
Reddedildi.
Neden:
- baseline olarak daha fazla risk ve ekosistem sürtünmesi

## 23.5. Nx-first orchestration
Reddedildi.
Neden:
- bu boilerplate için erken aşamada fazla ağır ve opinionated

## 23.6. No orchestrator
Reddedildi.
Neden:
- monorepo task yönetimi görünmez kaosa döner

---

# 24. Riskler

Bu kararın da riskleri vardır.

## 24.1. Monorepo yanlış kullanılırsa package çorbası olabilir
Gerçek risk.

## 24.2. Shared-by-proof ilkesi unutulursa gereksiz abstraction patlar
Bu en yaygın bozulma biçimidir.

## 24.3. Turborepo task graph yanlış kurulursa CI beklenen kazancı üretmez
Bu da gerçek risktir.

## 24.4. pnpm peer ve workspace kuralları disiplin istemez sanılırsa sürtünme yaşanır
Monorepo kolay ama kuralsız değildir.

## 24.5. Docs alanı repo içinde olsa bile güncellenmezse sembolik kalır
Bu süreç riski vardır.

---

# 25. Risk Azaltma Önlemleri

1. `21-repo-structure-spec.md` exact başlangıç topolojisi vermeli
2. `20-initial-implementation-checklist.md` package açma sırasını disipline etmeli
3. `37-dependency-policy.md` duplicate tool riskini kontrol etmeli
4. `31-audit-checklist.md` package drift ve placement ihlallerini denetlemeli
5. `35-document-map.md` docs ve ADR zincirini görünür tutmalı
6. `30-contribution-guide.md` yeni package / yeni dependency kararını kurala bağlamalı

---

# 26. Non-Goals

Bu ADR aşağıdakileri çözmez:

- exact package.json contents
- exact turbo task definitions
- exact CI YAML details
- publish/public package strategy
- every subfolder naming detail
- storybook/playground ek app kararı
- remote cache provider seçimi

Bunlar ilgili operational belgelerde kapanacaktır.

---

# 27. Kararın Kısa Hükmü

> Bu boilerplate tek monorepo içinde kurulacaktır. Package manager olarak pnpm 10.x, task/build orchestration için Turborepo 2.x kullanılacaktır. Repo topolojisi `apps/`, `packages/`, `docs/`, `tooling/`, `scripts/` aileleri etrafında şekillenecek; feature code varsayılan olarak app içinde kalacak, shared foundations ise kanıtlı ihtiyaçla package haline getirilecektir.

---

# 28. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. Monorepo kararının neden verildiği açıkça yazılmışsa
2. pnpm ve Turborepo seçiminin gerekçesi görünürse
3. Polyrepo / npm / yarn / bun / Nx alternatiflerinin neden baseline olmadığı açıklanmışsa
4. Exact başlangıç root topoloji aileleri ve başlangıç package seti netleştirilmişse
5. Shared-by-proof ilkesi fiziksel repo düzeyinde tanımlanmışsa
6. 21/20/37/38 ile ilişkisi açık kurulmuşsa
7. Repo bootstrap için gerçek yön verici netlikteyse

---

# 29. pnpm Catalogs ile Tek Versiyon Yönetimi

pnpm 10.x’in catalog özelliği, monorepo genelinde dependency versiyonlarını tek bir noktadan yönetmeyi sağlar. Bu özellik version drift riskini ortadan kaldırır ve upgrade sürecini dramatik biçimde basitleştirir.

## 29.1. Catalog Tanımı

`pnpm-workspace.yaml` dosyasında catalog bloğu tanımlanır. Bu blok monorepo genelinde kullanılacak dependency versiyonlarının tek kaynağıdır:

```yaml
packages:
  - ‘apps/*’
  - ‘packages/*’

catalog:
  react: ^19.1.0
  react-dom: ^19.1.0
  react-native: ~0.83.0
  typescript: ^5.8.0
  zod: ^4.0.0
  zustand: ^5.0.0
  ‘@tanstack/react-query’: ^5.0.0
  i18next: ^26.0.0
  react-hook-form: ^7.0.0
  expo: ~55.0.0
```

## 29.2. Package’larda Kullanımı

Her workspace package’ında `package.json`’da doğrudan versiyon yazmak yerine `catalog:` prefix’i kullanılır:

```json
{
  “dependencies”: {
    “react”: “catalog:”,
    “zustand”: “catalog:”,
    “zod”: “catalog:”
  }
}
```

Bu sayede versiyon bilgisi tek bir yerde yaşar; package’lar yalnızca “catalog’daki versiyonu kullan” der.

## 29.3. Avantajlar

- **Versiyon tutarsızlığı riski sıfırlanır:** Aynı dependency’nin farklı workspace’lerde farklı versiyonlarla kullanılması imkansız hale gelir
- **Upgrade tek noktadan yapılır:** `pnpm-workspace.yaml`’daki catalog güncellenince tüm workspace’ler yeni versiyonu alır
- **Review kolaylığı:** Versiyon değişikliği tek dosyada görünür; PR review’da tüm etki anında anlaşılır
- **Compatibility matrix (38) ile doğal uyum:** Catalog tanımı ile compatibility matrix aynı versiyonları referans alır

## 29.4. Migration Stratejisi

Mevcut direkt versiyonlar catalog referansına dönüştürülür:

1. `pnpm-workspace.yaml`’a canonical dependency’lerin versiyonları catalog bloğuna yazılır
2. Her `package.json`’daki direkt versiyon `catalog:` ile değiştirilir
3. `pnpm install` çalıştırılarak lockfile güncellenir
4. CI’da catalog sync kontrolü eklenir: Direkt versiyon kullanan paket varsa uyarı üretilir

## 29.5. CI Kontrolü

CI pipeline’ına catalog uyum kontrolü eklenir. Bu kontrol:
- `package.json` dosyalarında catalog’da tanımlı bir dependency’nin direkt versiyon ile kullanılıp kullanılmadığını kontrol eder
- Catalog’da olmayan yeni dependency eklendiğinde uyarı üretir (catalog’a eklenmeli mi sorusu sorulur)
- `pnpm install --frozen-lockfile` ile lockfile tutarlılığı doğrulanır

---

# 30. Turborepo Remote Cache Stratejisi

CI build sürelerini optimize eden remote cache, monorepo’nun ölçeklenebilirliği için kritik bir bileşendir.

## 30.1. Remote Cache Nedir?

Turborepo’nun local cache’i varsayılan olarak `.turbo/` dizininde yaşar. Remote cache, bu cache artifact’lerini merkezi bir storage’a taşıyarak farklı CI runner’lar ve geliştiriciler arasında paylaşıma açar. Bir geliştirici veya CI runner daha önce aynı input hash’i ile çalıştırılmış bir task’ı tekrar çalıştırmak istediğinde, remote cache’den sonucu alır ve task’ı atlar.

## 30.2. Seçenekler

### Vercel Remote Cache (Hosted)

- Turborepo’nun birinci sınıf remote cache entegrasyonu
- Sıfır konfigürasyon: `npx turbo login` ve `npx turbo link` ile aktifleşir
- Vercel free tier: Hobi projeler için yeterli (aylık 500 saatlik cache hit)
- Avantaj: Bakım gerektirmez, Vercel CDN üzerinden düşük latency

### Self-Hosted Remote Cache

- `turborepo-remote-cache` veya `turbo-remote-cache-rs` gibi açık kaynak çözümler
- S3, GCS, Azure Blob veya MinIO üzerinde çalışır
- Avantaj: Tam kontrol, maliyet optimizasyonu, veri lokasyonu kontrolü
- Dezavantaj: Altyapı bakım yükü

## 30.3. Beklenen Kazanım

Remote cache ile CI build sürelerinde **%40-60 iyileşme** beklenir. Bu iyileşme şu senaryolarda ortaya çıkar:

- PR’da yalnızca `apps/web` değiştiğinde `packages/*` testleri cache’den gelir
- Ardışık CI run’larda değişmeyen paketlerin build/test/lint’i atlanır
- Geliştiricinin local’inde başka bir geliştiricinin zaten çalıştırdığı task’lar cache’den çözülür

## 30.4. Güvenlik

- **Cache artifact imzalama:** `TURBO_REMOTE_CACHE_SIGNATURE_KEY` environment variable’ı ile artifact’ler imzalanır. Bu, cache poisoning saldırılarını önler.
- **Erişim kontrolü:** Remote cache token’ı CI secret olarak saklanır, repo’ya yazılmaz
- **Cache isolation:** Farklı branch’lerin cache’leri izole tutulabilir (isteğe bağlı)

## 30.5. Invalidation ve Temizlik

- `turbo prune` ile gereksiz cache artifact’leri temizlenir
- Periyodik cache cleanup (ör. 30 günden eski artifact’ler) CI cron job ile yapılır
- Major dependency upgrade sonrası cache invalidation yapılır (hash değişeceği için otomatik olur)

## 30.6. Maliyet Değerlendirmesi

| Seçenek | Maliyet | Bakım Yükü | Uygunluk |
|---------|---------|------------|----------|
| Vercel Free | $0 (500 saat/ay) | Sıfır | Küçük-orta projeler |
| Vercel Pro | $20/ay/kullanıcı | Düşük | Orta-büyük projeler |
| Self-hosted (S3) | ~$5-20/ay (storage) | Orta | Büyük projeler, veri kontrolü gerekli |
| Self-hosted (MinIO) | Sunucu maliyeti | Yüksek | Enterprise, air-gapped ortamlar |

Bu boilerplate için başlangıçta **Vercel Remote Cache free tier** değerlendirilir; ölçek büyüdükçe self-hosted’a geçiş planlanabilir.

---

# 31. Kısa Sonuç

Bu boilerplate için repo ve build workflow omurgası artık açıktır:

- Tek repo
- pnpm workspace
- Turborepo task graph
- `apps/web` + `apps/mobile`
- kontrollü shared foundations
- repo içinde yaşayan docs ve tooling

Bu karar artık “opsiyonlardan biri” değil,  
repo bootstrap’ın resmi başlangıç zeminidir.
