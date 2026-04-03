# Product Showcase

`product-showcase`, creator'larin kullandigi veya onerdigi urunleri tek link altinda baglamli storefront'lar, shelf'ler ve content-linked page'ler uzerinden yayinlamasini hedefleyen urun icin proje-ozel dokumantasyon calisma alanidir.

Bu repo su anda kod degil, derived proje oncesi belge otoritesi icerir. Boilerplate otoritesi `../boilerplate` altindadir; bu dizin ise yalnizca proje-ozel karar katmanini tasir.

## Ne Var?

- root boundary ve repo ozeti
- `project/` altinda 100 proje-ozel dokuman
- arastirma notlari ve giris kaynaklari
- `.env.example` + environment matrix referansi

## Okuma Sirasi

Ilk giris icin onerilen sira:

1. [BOUNDARY.md](/Users/alperenkarip/Projects/product-showcase/BOUNDARY.md)
2. [project/00-project-charter.md](/Users/alperenkarip/Projects/product-showcase/project/00-project-charter.md)
3. [project/01-product-vision-and-thesis.md](/Users/alperenkarip/Projects/product-showcase/project/01-product-vision-and-thesis.md)
4. [project/02-product-scope-and-non-goals.md](/Users/alperenkarip/Projects/product-showcase/project/02-product-scope-and-non-goals.md)
5. [project/05-success-criteria-and-launch-gates.md](/Users/alperenkarip/Projects/product-showcase/project/05-success-criteria-and-launch-gates.md)
6. [project/product/20-product-information-architecture.md](/Users/alperenkarip/Projects/product-showcase/project/product/20-product-information-architecture.md)
7. [project/product/23-creator-workflows.md](/Users/alperenkarip/Projects/product-showcase/project/product/23-creator-workflows.md)
8. [project/import/40-url-import-pipeline-spec.md](/Users/alperenkarip/Projects/product-showcase/project/import/40-url-import-pipeline-spec.md)
9. [project/architecture/60-system-architecture.md](/Users/alperenkarip/Projects/product-showcase/project/architecture/60-system-architecture.md)
10. [project/operations/100-environment-and-secrets-matrix.md](/Users/alperenkarip/Projects/product-showcase/project/operations/100-environment-and-secrets-matrix.md)

## Dokuman Aileleri

Bu repo, boilerplate `docs/` alanini tekrar etmez. Onun yerine su proje-ozel aileleri doldurur:

- `project/00-05` -> foundation
- `project/research/10-13` -> arastirma ve risk
- `project/product/20-28` -> urun, IA ve workflow
- `project/domain/30-35` -> domain model ve ownership
- `project/import/40-48` -> URL import ve extraction
- `project/design/50-58` -> ekran ve UX spec
- `project/architecture/60-69` -> sistem ve runtime mimarisi
- `project/data/70-75` -> API, schema, jobs ve cache
- `project/quality/80-88` -> kalite ve acceptance
- `project/compliance/90-94` -> privacy, disclosure, abuse
- `project/operations/100-104` -> env, runbook, support
- `project/implementation/110-115` -> roadmap ve rollout
- `project/adr/PROJECT-ADR-001-011` -> proje karar kayitlari
- `project/ai-guardrails/GP-001-005` -> proje-ozel AI guardrail seti

## Kaynak Dosyalar

Bu belge seti su kaynaklar kullanilarak yazildi:

- [creator_product_vitrine_arastirma_raporu_2026.md](/Users/alperenkarip/Projects/product-showcase/creator_product_vitrine_arastirma_raporu_2026.md)
- [icerik-bazli-urun-vitrini.md](/Users/alperenkarip/Projects/product-showcase/icerik-bazli-urun-vitrini.md)
- [proje-dokuman-listesi.md](/Users/alperenkarip/Projects/product-showcase/proje-dokuman-listesi.md)
- [dokuman-olusturma-talimati.md](/Users/alperenkarip/Projects/product-showcase/dokuman-olusturma-talimati.md)

## Durum

Mevcut durum `documentation-first / pre-bootstrap` safhasidir. Proje belge omurgasi kurulmustur; fiziksel derived monorepo bootstrap'i, upstream sync yapisi ve kod tabani sonraki adımdır.
