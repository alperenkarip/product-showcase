---
id: GP-004
type: project
name: Disclosure and Trust UI
kaynak-dokumanlar: 27, 45, 52, 58, 91, 94
miras-tipi: zorunlu
son-guncelleme: 2026-04-02
---

# GP-004: Disclosure and Trust UI Guardrail

## Bu Guardrail Ne Zaman Aktif?

- product card, public detail, verification, copy, stale price veya pricing UI calismalarinda
- template veya public layout degisiyorsa
- trust/disclosure copy'si guncelleniyorsa

## Bu Guardrail Neyi Korur?

Bu guardrail su gercegi korur:

- trust sinyalleri bu urunde accessory degil core semantics'tir
- disclosure ve freshness bilgisi, creator veya tasarim tercihiyle görünmez hale gelemez

## Zorunlu Kurallar

1. Disclosure urun seviyesinde gorunur kalir.
2. Stale fiyat warning'i gizlenmez veya euphemism ile yumusatilmaz.
3. Creator note, disclosure yerine kullanilmaz.
4. Trust bilgisi yalnizca renk ile anlatilmaz; text semantics zorunludur.
5. Hidden price, stale price ve unavailable link state'leri ayni seymis gibi sunulmaz.
6. Template secimi disclosure/trust row'u kaldiramaz.

## Uygulama Emirleri

1. Badge/row alanlari action-adjacent ve gorulebilir yerde kalir.
2. `last_checked` veya esdeger freshness baglami, fiyat varsa kontekst olarak sunulur.
3. Verification ve edit yuzeyleri creator'a disclosure sonucunu net gosterir.
4. Public copy trust state'ini guzel gostermek icin anlami bulandirmaz.

## Anti-pattern'ler

1. disclosure'u sadece footer veya modal icine saklamak
2. stale price'i current price gibi gostermek
3. trust state'ini ikon veya renkle aciklamasiz birakmak
4. creator note'u disclosure substitute'u gibi kullanmak

## Kontrol Listesi

- [ ] Badge veya row gorunur mu?
- [ ] Fiyat varsa freshness baglami var mi?
- [ ] Disclosure product seviyesinde mi?
- [ ] Template veya layout degisikligi trust alanini zayiflatti mi?
- [ ] State farklari dilde ve semantik olarak ayri mi?

## Merge Engelleri

Asagidaki durumlardan biri varsa degisiklik merge edilmez:

1. disclosure/trust alanlari optional gorsel detay gibi ele aliniyorsa
2. stale veya hidden state'ler current state gibi gorunuyorsa
3. public trust semantics'i sadece renge veya ikona indirgeniyorsa
4. template degisikligi disclosure gorunurlugunu bozuyorsa

