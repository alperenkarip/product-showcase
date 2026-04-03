---
id: GP-003
type: project
name: Creator Workflow Simplicity
kaynak-dokumanlar: 23, 44, 53, 54, 110, 112, 114
miras-tipi: zorunlu
son-guncelleme: 2026-04-02
---

# GP-003: Creator Workflow Simplicity Guardrail

## Bu Guardrail Ne Zaman Aktif?

- creator mobile/web akislari, verification, onboarding, library, bulk edit ve publish islerinde
- quick add veya page composition akisi degisiyorsa
- yeni alan, modal, adim veya karar noktasi ekleniyorsa

## Bu Guardrail Neyi Korur?

Bu guardrail su gercegi korur:

- creator'in ana vaadi hizli ve dusuk surtunmeli urun ekleme/yayinlamadir
- mobile ve web ayni workflow'un iki ayagidir
- complexity eklemek, capability eklemekle ayni sey degildir

## Zorunlu Kurallar

1. Quick add akisi gereksiz adim, uzun form veya ayar yigini ile agirlastirilmaz.
2. Reuse yerine duplicate yaratmaya tesvik eden UI eklenmez.
3. Unsupported merchant akisi fallback'siz birakilmaz.
4. Mobil yuzey utility-first kalir; derin ayarlar web'e tasinir.
5. Verification state'i creator'u cikissiz belirsizlige itmez.
6. Publish sonucu, stale/disclosure/public yansima etkisini creator'a acik anlatir.

## Uygulama Emirleri

1. Yeni alan ekleniyorsa "bu karar hangi mevcut karari acikca sadeleştiriyor?" sorusu cevaplanir.
2. Her kritik adim icin save/resume veya acik next step mantigi vardir.
3. Quick add, review, page secimi ve publish arasina gereksiz konfigürasyon adimi sokulmaz.
4. Mobile ve web terminology'si ayni kalir; ayni capability farkli isimlerle anlatilmaz.

## Anti-pattern'ler

1. her import sonrasi kapsamli ayar modal'i acmak
2. duplicate onerisini gizlemek
3. unsupported merchant'ta kullaniciyi bos hata ekraniyla birakmak
4. mobilde template/domain gibi derin ayarlari varsayilan akisa yigmaya baslamak
5. creator note, disclosure veya trust state'ini tek girdi alanina eritmek

## Kontrol Listesi

- [ ] Bu degisiklik quick add akisini uzatiyor mu?
- [ ] Duplicate/reuse karari hala gorunur mu?
- [ ] Fallback ve recovery yolu var mi?
- [ ] Mobile/web workflow dili tutarli mi?
- [ ] Yeni alan gercekten zorunlu mu?
- [ ] Creator bir sonraki adimi net anlayabiliyor mu?

## Merge Engelleri

Asagidaki durumlardan biri varsa degisiklik merge edilmez:

1. creator ana loop'una cikissiz adim ekleniyorsa
2. duplicate/reuse mantigi gizleniyorsa
3. unsupported veya failed import icin recovery yolu kayboluyorsa
4. mobile utility-first ilke bozuluyorsa

