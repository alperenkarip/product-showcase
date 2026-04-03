---
id: GP-002
type: project
name: Public Web SEO and Share Pages
kaynak-dokumanlar: 21, 22, 24, 52, 61, 67, 85, 88
miras-tipi: yapisal
son-guncelleme: 2026-04-02
---

# GP-002: Public Web SEO and Share Pages Guardrail

## Bu Guardrail Ne Zaman Aktif?

- public route, metadata, canonical URL, OG, share preview, storefront/content page calismalarinda
- page type veya route davranisi degisiyorsa
- noindex, removed, archived veya unpublished state ele aliniyorsa

## Bu Guardrail Neyi Korur?

Bu guardrail su gercegi korur:

- public web bu urunun ana viewer yuzeyidir
- share ve SEO, route semantics'inin uzantisidir
- metadata ve performance, ikinci plana itilmis detay degil, surface'in bir parcasi olarak ele alinmalidir

## Zorunlu Kurallar

1. Public page canonical URL'si tek olmalidir.
2. Draft, unpublished, removed ve policy-hidden sayfalar indexlenmez.
3. Content page OG/metadata, generic storefront copy'siyle doldurulmaz.
4. Metadata page type ile uyumlu olmalidir: storefront, shelf ve content page ayni sablonu kopyalamaz.
5. Share preview bozuldugunda kontrollu fallback ve regenerate yolu vardir.
6. Public page hizini bozan image/asset yuklemesi kabul edilmez.

## Uygulama Emirleri

1. Her yeni public route canonical path ve state matrisiyle birlikte gelir.
2. OG image veya metadata, stale/removed state'i saklayacak bicimde tatliya baglanmaz.
3. Archived page davranisi public ve crawler acisindan net yazilir.
4. Noindex karari redirect veya 404 davranisindan ayri ama bagli ele alinir.

## Anti-pattern'ler

1. Tüm public page'leri ayni title/description sablonuna baglamak
2. Archived veya removed page'i sanki aktifmis gibi metadata ile sunmak
3. Performance budget'i share preview gorseli bahanesiyle asmak
4. Canonical ve visible path'in farkli olmasini aciklamadan birakmak

## Kontrol Listesi

- [ ] Metadata page type ile uyumlu mu?
- [ ] Canonical URL tek ve net mi?
- [ ] Archived/unpublished/removed state ele alindi mi?
- [ ] Share preview bozuldugunda recovery yolu var mi?
- [ ] Performance budget korunuyor mu?
- [ ] Noindex ve crawler davranisi net mi?

## Merge Engelleri

Asagidaki durumlardan biri varsa degisiklik merge edilmez:

1. page type'e ozel metadata mantigi yoksa
2. canonical/noindex davranisi belirsizse
3. share preview veya OG uretimi public trust state'ini gizliyorsa
4. performance budget'leri kasitli olarak ihlal ediliyorsa
