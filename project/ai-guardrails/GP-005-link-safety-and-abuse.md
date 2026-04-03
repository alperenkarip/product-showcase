---
id: GP-005
type: project
name: Link Safety and Abuse
kaynak-dokumanlar: 42, 48, 87, 92, 93, 102, 103
miras-tipi: zorunlu
son-guncelleme: 2026-04-02
---

# GP-005: Link Safety and Abuse Guardrail

## Bu Guardrail Ne Zaman Aktif?

- URL import, external link, report/takedown, ops console ve public outbound link islerinde
- merchant allow/block davranisi degisiyorsa
- abuse raporlama veya support escalation akisi guncelleniyorsa

## Bu Guardrail Neyi Korur?

Bu guardrail su gercegi korur:

- creator-girisi olan dis link sistemi safety gate olmadan yayinlanamaz
- blocked ve abuse state'leri teknik bug degil, policy ve guven state'idir

## Zorunlu Kurallar

1. Blocked veya unsafe domain public'e cikmaz.
2. Redirect zinciri ve policy check importten once calisir.
3. Abuse report akisi support/ops baglantisi olmadan birakilmaz.
4. Link safety ihlali siradan UI bug'i gibi ele alinmaz.
5. Blocked state teknik retry ile sessizce asilmaya calisilmaz.
6. Creator'a policy nedeni acik copy ile anlatilir.

## Uygulama Emirleri

1. Safety gate sonucu canonical reason code ile kaydedilir.
2. `blocked`, `failed`, `needs_review` ve `removed_by_policy` ayni kovaya yigılmaz.
3. Ops review queue ve support escalation zinciri canli olmak zorundadir.
4. Allowlist veya blocklist degisikligi audit izi olmadan uygulanmaz.

## Anti-pattern'ler

1. blocked domain'i generic import failure gibi gostermek
2. redirect zincirini ignore ederek final URL'ye bakmamak
3. creator'a neden belirtmeden linki sessizce kaldirmak
4. abuse raporunu support notu seviyesine indirgemek

## Kontrol Listesi

- [ ] Safety check katmani var mi?
- [ ] Blocked reason creator ve support icin okunur mu?
- [ ] Ops escalation yolu tanimli mi?
- [ ] Kullaniciya guvenli hata copy'si sunuluyor mu?
- [ ] `blocked` state teknik failure ile karismiyor mu?
- [ ] Allow/block degisikligi auditli mi?

## Merge Engelleri

Asagidaki durumlardan biri varsa degisiklik merge edilmez:

1. public cikis safety gate disina aliniyorsa
2. abuse/takedown zinciri owner'siz birakiliyorsa
3. blocked state generic hata gibi gosteriliyorsa
4. allowlist mantigi registry/policy disinda gizli kural olarak ekleniyorsa

