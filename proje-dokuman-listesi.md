Archive’i çıkardım ve denetledim.

Net sonuç:

* **Boilerplate `docs/` alanı** zaten otorite katmanı olarak tanımlanmış.
* **Türetilen projenin asıl belge seti `project/` altında yaşamalı.**
* Root’ta **`BOUNDARY.md` zorunlu**.
* `docs/adr/` boilerplate ADR’leri için **read-only referans alanı**.
* Proje kararları **`project/adr/PROJECT-ADR-XXX-*.md`** formatında yazılmalı.
* Bu proje için yeni belge seti, boilerplate’i tekrar kopyalamak değil; **ürün, domain, akış, operasyon ve proje-özel karar katmanını tanımlamak** zorunda.

Aşağıdaki liste, **bu ürün için gerçekten oluşturulması gereken proje-özel doküman setidir**.

---

# 0. Root seviyesinde zorunlu belgeler

## 1. `BOUNDARY.md`

Amaç:

* Bu türetilen projenin hangi boilerplate sürümünden çıktığını kayıt altına almak.
* Aktif override’ları, proje-özel eklemeleri ve son audit bilgisini tutmak.
* Boilerplate–project sınırını görünür ve denetlenebilir kılmak.

## 2. `README.md`

Amaç:

* Repo’nun dıştan okunabilir kısa özeti.
* Projenin ne olduğu, hangi yüzeylerden oluştuğu, nasıl ayağa kaldırıldığı ve ana belge haritasına nasıl gidileceği.

## 3. `.env.example` açıklama referansı ile birlikte ayrı bir md

Önerilen dosya: `project/operations/environment-and-secrets-matrix.md`
Amaç:

* Ortam değişkenlerini sadece isim olarak değil, anlamı, kaynak sistemi, zorunluluğu ve rotasyon kuralıyla tanımlamak.

---

# 1. Foundation / çekirdek yön belgeleri

## 4. `project/00-project-charter.md`

Amaç:

* Projenin resmi charter’ı.
* Problem tanımı, hedef, kapsam, kapsam dışı alanlar, ana başarı kriterleri.

## 5. `project/01-product-vision-and-thesis.md`

Amaç:

* Ürünün varlık nedeni.
* “Bu ürün tam olarak nedir, ne değildir?” sorusunu kapatmak.
* Link-in-bio klonu mu, storefront mu, recommendation surface mi tartışmasını bitirmek.

## 6. `project/02-product-scope-and-non-goals.md`

Amaç:

* Bilinçli olarak yapmayacağımız şeyleri bağlamak.
* Checkout, marketplace, heavy affiliate dashboard, geniş analytics suite gibi alanların neden dışarıda kaldığını netleştirmek.

## 7. `project/03-personas-jobs-and-primary-use-cases.md`

Amaç:

* Creator, viewer, ops/admin ve gerekirse support rollerini tanımlamak.
* Her rol için Jobs-to-be-Done ve ana kullanım senaryolarını yazmak.

## 8. `project/04-domain-glossary.md`

Amaç:

* Terminoloji kaosunu önlemek.
* “storefront”, “shelf”, “collection”, “content page”, “product card”, “link import”, “merchant source”, “verification state” gibi kavramları tek anlamlı hale getirmek.

## 9. `project/05-success-criteria-and-launch-gates.md`

Amaç:

* Dışarı açılmadan önce ürünün hangi kalite ve kapsam eşiğini geçmesi gerektiğini tanımlamak.
* Senin “yarım ürün çıkmama” yaklaşımını yazılı launch gate’e çevirmek.

---

# 2. Research / ürün keşif ve strateji belgeleri

## 10. `project/research/10-market-landscape-and-competitor-map.md`

Amaç:

* Rakip kümelerini sabitlemek.
* Linktree/Beacons/Stan/ShopMy/LTK/platform-native shopping gibi kümeleri ve bunlardan nasıl ayrışacağımızı belgelemek.

## 11. `project/research/11-problem-validation-and-user-friction-map.md`

Amaç:

* Creator ve izleyici tarafındaki gerçek sürtünme noktalarını belgelemek.
* “Ürün neden gereklidir?” sorusunu varsayım değil kanıt düzeyinde netleştirmek.

## 12. `project/research/12-risk-register.md`

Amaç:

* Teknik, hukuki, operasyonel, ürünsel ve büyüme risklerini listelemek.
* Özellikle scraping, yanlış veri çekimi, disclosure, abuse ve app-store risklerini izlemek.

## 13. `project/research/13-assumption-log.md`

Amaç:

* Şu an doğru kabul ettiğimiz ama henüz doğrulanmamış varsayımları kayıt altına almak.
* Sonradan sessizce unutulan kararları önlemek.

---

# 3. Ürün tanımı ve bilgi mimarisi belgeleri

## 14. `project/product/20-product-information-architecture.md`

Amaç:

* Ürünün top-level bilgi mimarisini tanımlamak.
* Omurganın kategori değil; creator, vitrin, collection/shelf, content-linked page ve product library olduğunu bağlamak.

## 15. `project/product/21-page-types-and-publication-model.md`

Amaç:

* Hangi sayfa tiplerinin var olduğunu netleştirmek.
* Profil vitrini, koleksiyon sayfası, içerik-bağlı sayfa, ürün kartı görünümü, hata/boş durum sayfaları gibi yüzeyleri tanımlamak.

## 16. `project/product/22-route-slug-and-url-model.md`

Amaç:

* Public route yapısını, slug kurallarını, canonical URL yapısını ve paylaşım mantığını sabitlemek.

## 17. `project/product/23-creator-workflows.md`

Amaç:

* Creator tarafındaki tüm ana akışları yazmak.
* İlk kurulum, vitrin oluşturma, link yapıştırma, doğrulama, koleksiyona ekleme, yayınlama, düzenleme, kaldırma.

## 18. `project/product/24-viewer-experience-spec.md`

Amaç:

* İzleyicinin public web deneyimini tanımlamak.
* Kart yapısı, güven sinyalleri, disclosure görünümü, dış linke çıkış, mobil performans beklentisi.

## 19. `project/product/25-search-filter-tagging-rules.md`

Amaç:

* Kategori ana omurga değilse; filtre, etiket, arama ve faceting nasıl çalışacak bunu tanımlamak.

## 20. `project/product/26-template-and-customization-rules.md`

Amaç:

* Creator’ın vitrini hangi sınırlar içinde özelleştirebileceğini yazmak.
* Template sistemi, tema varyasyonu, izin verilen serbestlik ve yasak alanlar.

## 21. `project/product/27-disclosure-trust-and-credibility-layer.md`

Amaç:

* Affiliate, sponsorlu, gifted, personally bought gibi işaretlerin ürün kartı ve sayfa düzeyinde nasıl görüneceğini tanımlamak.

## 22. `project/product/28-subscription-and-plan-model.md`

Amaç:

* Free/pro/plan sınırlarını sade biçimde bağlamak.
* Hangi plan hangi hakları açar, hangi limitler vardır.

---

# 4. Domain modeli ve veri belgeleri

## 23. `project/domain/30-domain-model.md`

Amaç:

* Ana varlıkları ve ilişkileri tanımlamak.
* User, creator profile, storefront, collection, content page, product, merchant source, import job, verification state, disclosure record, subscription record.

## 24. `project/domain/31-product-library-and-reuse-model.md`

Amaç:

* Aynı ürünün creator kütüphanesinde tekrar tekrar oluşturulmasını önleyecek modeli tanımlamak.

## 25. `project/domain/32-content-linked-shelf-model.md`

Amaç:

* “Bu videoda kullandıklarım” gibi içerik-bağlı vitrinlerin domain mantığını tanımlamak.

## 26. `project/domain/33-tag-taxonomy-and-classification-model.md`

Amaç:

* Kategori yerine kullanılan etiket, bağlam, kullanım tipi ve sınıflandırma mantığını yazmak.

## 27. `project/domain/34-roles-permissions-and-ownership-model.md`

Amaç:

* Owner, editor, support/admin gibi rollerin erişim sınırlarını belirlemek.

## 28. `project/domain/35-data-lifecycle-retention-and-deletion-rules.md`

Amaç:

* Ürün kaydı, fiyat snapshot’ı, import log’u, user media’sı ve audit kayıtlarının yaşam döngüsünü tanımlamak.

---

# 5. URL import / scraping / extraction belgeleri

Bu ürünün kaderi burada belirlenir. Bu alan ayrı belge ailesi olmak zorunda.

## 29. `project/import/40-url-import-pipeline-spec.md`

Amaç:

* Link yapıştırıldıktan sonra sistemin hangi adımlardan geçtiğini uçtan uca tanımlamak.

## 30. `project/import/41-extraction-strategy-and-fallback-order.md`

Amaç:

* Extraction sırasını bağlamak:

  1. merchant-specific parser
  2. structured data
  3. open graph
  4. HTML parse
  5. AI fallback
  6. human confirmation

## 31. `project/import/42-merchant-capability-registry.md`

Amaç:

* Hangi domain’lerde hangi seviyede destek verildiğini tanımlamak.
* Full support / partial support / best effort ayrımı.

## 32. `project/import/43-link-normalization-and-deduplication-rules.md`

Amaç:

* Aynı ürünün farklı URL’ler, tracking parametreleri veya varyant linkleriyle tekrar oluşmasını engellemek.

## 33. `project/import/44-product-verification-ui-and-manual-correction-spec.md`

Amaç:

* Otomatik çekilen ürün bilgilerinin creator’a nasıl doğrulatılacağını tanımlamak.

## 34. `project/import/45-price-availability-and-refresh-policy.md`

Amaç:

* Fiyatın ne zaman çekileceği, ne zaman stale sayılacağı, ne zaman saklanacağı veya gizleneceği.
* Public yüzeyde fiyat gösterimi konusunu bağlamak.

## 35. `project/import/46-media-selection-and-image-quality-rules.md`

Amaç:

* Hangi görselin ana ürün görseli sayılacağı, yanlış hero image riskinin nasıl yönetileceği.

## 36. `project/import/47-ai-assisted-extraction-boundaries.md`

Amaç:

* AI’nin nerede kullanılacağını ve nerede kullanılmayacağını bağlamak.
* AI’nin ürün/fiyat uydurmasının yasak olduğunu yazmak.

## 37. `project/import/48-import-failure-modes-and-recovery-rules.md`

Amaç:

* Başarısız import, eksik veri, timeout, bot koruması, yanlış görsel gibi durumlarda sistem davranışını tanımlamak.

---

# 6. Yüzey bazlı UX / ekran belgeleri

## 38. `project/design/50-design-direction-and-brand-translation.md`

Amaç:

* Projenin kendi görsel kimliğini, boilerplate tasarım standardına bağlayarak tanımlamak.

## 39. `project/design/51-screen-inventory.md`

Amaç:

* Tüm ekranların envanterini çıkarmak.
* Web public, creator web, creator mobile, admin/ops ekranlarını listelemek.

## 40. `project/design/52-public-web-screen-spec.md`

Amaç:

* Public vitrinin tüm sayfalarını ekran bazında tanımlamak.

## 41. `project/design/53-creator-mobile-screen-spec.md`

Amaç:

* Mobil creator yönetim ekranlarını ayrıntılandırmak.
* Hızlı ekleme, share extension sonrası düzenleme, collection picker, publish akışları.

## 42. `project/design/54-creator-web-screen-spec.md`

Amaç:

* Masaüstü creator panelini tanımlamak.
* Bulk edit, template ayarı, domain ayarı, içerik sayfası yönetimi.

## 43. `project/design/55-admin-ops-screen-spec.md`

Amaç:

* İç ekip için gerekli ops yüzeylerini tanımlamak.
* Import başarı oranı, failed jobs, abuse inceleme, domain support kayıtları.

## 44. `project/design/56-empty-loading-error-and-state-spec.md`

Amaç:

* Bu projeye özel boş/ara/hata durumlarını tanımlamak.

## 45. `project/design/57-motion-feedback-and-microinteraction-spec.md`

Amaç:

* Özellikle hızlı ekleme ve publish akışında geri bildirim davranışlarını bağlamak.

## 46. `project/design/58-content-copy-guidelines.md`

Amaç:

* Public ve creator yüzeyindeki mikro kopya mantığını sabitlemek.
* Teknik jargon, disclosure metni, hata mesajları, doğrulama dili.

---

# 7. Teknik mimari belgeler

## 47. `project/architecture/60-system-architecture.md`

Amaç:

* Tüm sistemi uçtan uca tanımlamak.
* Public web, creator app, creator web, backend services, queues, storage, third-party services.

## 48. `project/architecture/61-web-surface-architecture.md`

Amaç:

* Public web ve creator web katmanlarının runtime, rendering ve deployment yapısını tanımlamak.

## 49. `project/architecture/62-mobile-surface-architecture.md`

Amaç:

* Mobil uygulama tarafının rolünü netleştirmek.
* Creator-first kullanım, share extension etkisi, deep link ve auth geçişleri.

## 50. `project/architecture/63-auth-identity-and-session-model.md`

Amaç:

* Boilerplate auth baseline’ını bu projeye somutlamak.
* Creator identity, session flow, slug ownership, domain ownership.

## 51. `project/architecture/64-subscription-billing-integration-architecture.md`

Amaç:

* Subscription tarafının teknik entegrasyon modelini tanımlamak.

## 52. `project/architecture/65-job-queue-worker-and-refresh-architecture.md`

Amaç:

* Import, refresh, retry ve backoff süreçlerini tanımlamak.

## 53. `project/architecture/66-file-media-and-image-asset-architecture.md`

Amaç:

* Görsellerin nerede tutulduğu, nasıl işlendiği, cache ve dönüşüm stratejisi.

## 54. `project/architecture/67-seo-og-and-share-preview-architecture.md`

Amaç:

* Public sayfaların SEO, Open Graph, share preview ve metadata üretimini tanımlamak.

## 55. `project/architecture/68-deep-linking-and-share-entry-model.md`

Amaç:

* App link, universal link, magic link, share sheet dönüşlerini bağlamak.

## 56. `project/architecture/69-observability-and-internal-event-model.md`

Amaç:

* Public kullanıcıya analytics göstermeden içeride hangi operasyonel olayların izleneceğini tanımlamak.

---

# 8. Data / API / entegrasyon belgeleri

## 57. `project/data/70-api-contracts.md`

Amaç:

* Tüm ana endpoint veya server function sözleşmelerini tanımlamak.

## 58. `project/data/71-database-schema-spec.md`

Amaç:

* Domain modelinin fiziksel veri şemasına dönüşümünü yazmak.

## 59. `project/data/72-background-jobs-and-scheduling-spec.md`

Amaç:

* Cron, refresh, retry ve scheduled cleanup işlerini tanımlamak.

## 60. `project/data/73-cache-revalidation-and-staleness-rules.md`

Amaç:

* Fiyat, görsel ve storefront cache davranışlarını tanımlamak.

## 61. `project/data/74-third-party-services-register.md`

Amaç:

* Kullanılacak scraping servisleri, proxy servisleri, auth sağlayıcıları, payment provider, image pipeline, error tracking gibi tüm dış servisleri listelemek.

## 62. `project/data/75-webhook-and-event-consumer-spec.md`

Amaç:

* Subscription, auth, domain verification veya diğer dış sistemlerden gelecek event’leri tanımlamak.

---

# 9. Kalite, doğrulama ve acceptance belgeleri

## 63. `project/quality/80-project-definition-of-ready.md`

Amaç:

* Bir özelliğin implementasyona girmeden önce hangi belge ve kararları tamamlaması gerektiğini tanımlamak.

## 64. `project/quality/81-project-definition-of-done.md`

Amaç:

* Bu projeye özel DoD.
* Boilerplate DoD üzerine ürün-özel kabul kriterlerini eklemek.

## 65. `project/quality/82-test-strategy-project-layer.md`

Amaç:

* Boilerplate test standardını bu projeye uygulamak.
* Unit, integration, E2E, scraping/import testleri, visual diff, route smoke testleri.

## 66. `project/quality/83-import-accuracy-test-matrix.md`

Amaç:

* Farklı merchant tiplerinde hangi veri alanlarının doğruluk testine tabi olacağını yazmak.

## 67. `project/quality/84-cross-platform-acceptance-checklist.md`

Amaç:

* Web, iOS, Android, farklı ekran boyutları ve paylaşım yüzeyleri için kabul kriterleri.

## 68. `project/quality/85-performance-budgets.md`

Amaç:

* Public web performans sınırları, media budget, TTFB/LCP/CLS hedefleri.

## 69. `project/quality/86-accessibility-project-checklist.md`

Amaç:

* Boilerplate accessibility standardını bu ürünün ekranlarına uygulamak.

## 70. `project/quality/87-security-and-abuse-checklist.md`

Amaç:

* Link abuse, malicious URL, phishing, spam vitrini, sahte ürün, zararlı redirect gibi riskleri kontrol etmek.

## 71. `project/quality/88-release-readiness-checklist.md`

Amaç:

* İç testten dış yayına geçmeden önce son kontrol listesi.

---

# 10. Uyum, politika ve hukuki belgeler

## 72. `project/compliance/90-privacy-data-map.md`

Amaç:

* Hangi veriyi neden tuttuğumuzu ve nerede işlediğimizi belgelemek.

## 73. `project/compliance/91-disclosure-and-affiliate-labeling-policy.md`

Amaç:

* Affiliate/sponsor/gifted disclosure kurallarını ürün seviyesinde sabitlemek.

## 74. `project/compliance/92-external-link-and-merchant-content-policy.md`

Amaç:

* Harici ürün içeriklerini hangi çerçevede gösterdiğimizi tanımlamak.

## 75. `project/compliance/93-reporting-takedown-and-abuse-policy.md`

Amaç:

* Şikâyet, kaldırma, yanlış ürün bildirimi, zararlı link raporu süreçlerini tanımlamak.

## 76. `project/compliance/94-platform-and-store-review-risk-notes.md`

Amaç:

* Özellikle mobil uygulama dağıtımı varsa app store review tarafında dış link, subscription, account deletion gibi konuları önceden bağlamak.

---

# 11. Operasyon ve support belgeleri

## 77. `project/operations/100-environment-and-secrets-matrix.md`

Amaç:

* Dev, preview, staging, production ortamlarının farklarını ve secret yönetimini yazmak.

## 78. `project/operations/101-runbooks.md`

Amaç:

* Import sistemi bozulursa, queue birikirse, fiyat refresh çökerse, domain verify olmazsa ne yapılacağını tanımlamak.

## 79. `project/operations/102-incident-response-project-layer.md`

Amaç:

* Boilerplate incident yaklaşımını bu projenin failure mode’larına indirmek.

## 80. `project/operations/103-support-playbooks.md`

Amaç:

* “ürün çekilemedi”, “yanlış görsel geldi”, “fiyat yanlış”, “link bozuk” gibi kullanıcı sorunlarına standardize cevap ve çözüm akışı sağlamak.

## 81. `project/operations/104-data-backup-retention-and-restore.md`

Amaç:

* Özellikle storefront ve import verisi için geri yükleme ve retention kuralı tanımlamak.

---

# 12. Uygulama planı ve teslimat belgeleri

## 82. `project/implementation/110-project-roadmap.md`

Amaç:

* Geliştirme sırasını ve bağımlılıkları mantıklı biçimde bağlamak.
* “MVP” dili kullanmadan, yine de uygulama fazlarını netleştirmek.

## 83. `project/implementation/111-work-breakdown-structure.md`

Amaç:

* Epic → capability → task kırılımı üretmek.

## 84. `project/implementation/112-feature-sequencing-and-dependency-order.md`

Amaç:

* Hangi özelliğin hangisinden sonra gelebileceğini teknik olarak sabitlemek.

## 85. `project/implementation/113-initial-seed-content-and-demo-data-plan.md`

Amaç:

* İç test için örnek creator, vitrin, collection ve merchant link veri seti oluşturmak.

## 86. `project/implementation/114-internal-test-plan.md`

Amaç:

* Senin “önce içeride yeterince test et” modelini sistematik hale getirmek.

## 87. `project/implementation/115-launch-transition-plan.md`

Amaç:

* İç testten kapalı yayına, oradan genel yayına geçişin koşullarını tanımlamak.

---

# 13. Proje-özel ADR seti

Boilerplate’in teknik ADR’leri var. Ama bu ürünün kendine özel kararları da ayrı ADR olarak yazılmalı.

## 88. `project/adr/PROJECT-ADR-001-product-boundary-and-core-surface.md`

Amaç:

* Ürünün checkout olmayan recommendation/storefront sınırını kapatmak.

## 89. `project/adr/PROJECT-ADR-002-public-web-vs-creator-app-surface-split.md`

Amaç:

* Public consumption web-first, creator workflow mobile-friendly kararını resmileştirmek.

## 90. `project/adr/PROJECT-ADR-003-url-import-and-extraction-order.md`

Amaç:

* Extraction sırasını ve fallback mantığını teknik karar olarak kilitlemek.

## 91. `project/adr/PROJECT-ADR-004-merchant-support-tiering.md`

Amaç:

* Full support / partial support / best effort ayrımını bağlamak.

## 92. `project/adr/PROJECT-ADR-005-product-reuse-and-dedup-model.md`

Amaç:

* Aynı ürünün tekrar oluşmasını önleyecek temel yaklaşımı bağlamak.

## 93. `project/adr/PROJECT-ADR-006-template-customization-boundaries.md`

Amaç:

* Creator özelleştirme serbestliğinin sınırlarını teknik/ürün kararı olarak tanımlamak.

## 94. `project/adr/PROJECT-ADR-007-price-display-and-refresh-policy.md`

Amaç:

* Fiyat gösterimi, snapshot ve yenileme konusunu bağlamak.

## 95. `project/adr/PROJECT-ADR-008-disclosure-model.md`

Amaç:

* Affiliate/sponsor/gifted/owned işaretlerinin veri ve UI modelini karar altına almak.

## 96. `project/adr/PROJECT-ADR-009-share-extension-adoption-decision.md`

Amaç:

* Share extension ilk sürümde olacak mı, ne zaman olacak, hangi platformlarda olacak sorusunu kapatmak.

## 97. `project/adr/PROJECT-ADR-010-internal-observability-minimum.md`

Amaç:

* Kullanıcıya analytics suite açmadan içeride hangi minimum ölçümün zorunlu olduğunu tanımlamak.

## 98. `project/adr/PROJECT-ADR-011-abuse-and-link-safety-model.md`

Amaç:

* Zararlı link, redirect, scam product ve abuse yönetimi kararını sabitlemek.

---

# 14. AI guardrail ve proje-özel kural belgeleri

Boilerplate’te AI guardrail sistemi var. Bu projeye özel ek guardrail’ler de gerekli.

## 99. `project/ai-guardrails/GP-001-url-import-and-extraction.md`

Amaç:

* AI’nin import alanında hangi kurallara uyması gerektiğini tanımlamak.

## 100. `project/ai-guardrails/GP-002-public-web-seo-and-share-pages.md`

Amaç:

* Public sayfa üretiminde SEO/metadata/hız kurallarını sabitlemek.

## 101. `project/ai-guardrails/GP-003-creator-workflow-simplicity.md`

Amaç:

* Creator UX’in gereksiz alan, form ve sürtünmeyle bozulmasını engellemek.

## 102. `project/ai-guardrails/GP-004-disclosure-and-trust-ui.md`

Amaç:

* Disclosure alanlarının yok sayılmamasını sağlamak.

## 103. `project/ai-guardrails/GP-005-link-safety-and-abuse.md`

Amaç:

* Dış link ve merchant içeriklerinde güvenlik kontrollerini zorunlu hale getirmek.

---

# Bu listede özellikle tekrar oluşturulmaması gerekenler

Aşağıdakiler proje-özel belge olarak sıfırdan yazılmamalı; boilerplate’ten miras alınmalı:

* çalışma prensipleri
* UI/UX kalite standardı
* design system architecture
* theming and visual language
* accessibility baseline
* performance standard
* testing baseline
* security baseline
* release/versioning rules
* quality gates/CI rules
* dependency policy
* version compatibility matrix
* AI workflow and tooling
* AI instruction standards
* branching and merge strategy
* exception policy
* upstream sync strategy
* Expo SDK upgrade strategy
* HIG enforcement strategy

Yani:
**aynı standardı tekrar yazmak yerine, proje belgesinde o standardın bu ürüne nasıl uygulandığı yazılmalı.**

---

# Net sonuç

Bu proje için minimum ciddi belge seti şudur:

* **root zorunlu belgeler**
* **foundation**
* **research**
* **product / IA**
* **domain**
* **import/extraction**
* **design/screen spec**
* **architecture**
* **data/api**
* **quality**
* **compliance**
* **operations**
* **implementation**
* **project ADR**
* **project AI guardrails**

Toplamda bu, gevşek değil **tam kapsamlı proje dokümantasyon iskeleti** verir.

Sonraki adım doğru sıra ile şu olur: önce bu listeyi **nihai dosya ağacına** çevirip, ardından **hangi belge hangi sırayla yazılacak** planını çıkarmak.
