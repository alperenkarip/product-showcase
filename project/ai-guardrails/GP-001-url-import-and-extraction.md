---
id: GP-001
type: project
name: URL Import and Extraction
kaynak-dokumanlar: 40, 41, 42, 43, 44, 45, 46, 47, 48, 88
miras-tipi: zorunlu
son-guncelleme: 2026-04-02
---

# GP-001: URL Import and Extraction Guardrail

## Bu Guardrail Ne Zaman Aktif?

- import pipeline, worker, parser, registry, normalization, verification ekrani ve retry/failure handling calisilirken
- import ile ilgili AI veya otomasyon desteği kullanilirken
- merchant destek seviyesi veya extraction order degisiyorsa

## Bu Guardrail Neyi Korur?

Bu guardrail su urun gercegini korur:

- import bu urunun cekirdek utility'sidir
- AI yardimci olabilir ama authority olamaz
- extraction sirasi cost, trust ve supportability dengesini korur

## Zorunlu Kurallar

1. AI fiyat, merchant, availability veya urun modeli uyduramaz.
2. Extraction order canonical siradan cikamaz: normalization + safety -> parser -> structured data -> OG -> HTML heuristic -> AI-assisted normalization -> human confirmation.
3. Merchant tier registry disinda gizli destek mantigi eklenmez.
4. Duplicate/reuse kontrolu import flow'dan atlanmaz.
5. Unsupported veya `blocked` tier merchant'ta cikissiz hata yerine acik state ve uygun fallback bulunur.
6. Verification kapisi kritik alanlarda sessizce bypass edilmez.
7. Import final apply client tarafinda tamamlanmis kabul edilmez; durable server truth zorunludur.

## Uygulama Emirleri

1. Katman ekleniyorsa hangi mevcut katmanin onune veya arkasina girdigi acik yazilir.
2. Yeni merchant support'u registry kaydi, quality kaniti ve support copy'si olmadan acilmaz.
3. Failure reason kodlari generic `failed` kovasina yigilmadan siniflandirilir.
4. Wrong image, stale price ve blocked domain issue'lari ayri semantics tasir.

## Anti-pattern'ler

1. OG image'i sorgusuz ana gorsel kabul etmek
2. AI'dan eksik fiyat veya merchant markasi doldurmasini istemek
3. Import'i istemci tarafinda bitirmeye calismak
4. Registry disinda "gecici gizli allowlist" acmak
5. Verification gerektiren state'i sessizce auto-apply etmek

## Kontrol Listesi

- [ ] Extraction order belgeye ve runtime'a uyuyor mu?
- [ ] Safety check extraction'tan once mi?
- [ ] Verification zorunlu alanlari korunuyor mu?
- [ ] Failure mode ve retry davranisi tanimli mi?
- [ ] Yeni degisiklik duplicate/reuse mantigini bozuyor mu?
- [ ] AI adimi authority kazanmis mi?

## Merge Engelleri

Asagidaki durumlardan biri varsa degisiklik merge edilmez:

1. import sonucu kaynaksiz veri uretiyorsa
2. registry disi merchant support davranisi ekleniyorsa
3. support'un issue family okuyamayacagi generic state'ler olusuyorsa
4. blocked/unsafe URL davranisi teknik failure gibi ele aliniyorsa
