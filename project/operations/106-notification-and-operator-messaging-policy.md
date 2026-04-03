---
id: NOTIFICATION-AND-OPERATOR-MESSAGING-POLICY-001
title: Notification and Operator Messaging Policy
doc_type: engagement_policy
status: ratified
version: 1.0.0
owner: product-operations
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - CREATOR-WORKFLOWS-001
  - SUBSCRIPTION-PLAN-MODEL-001
  - SUPPORT-PLAYBOOKS-001
  - PRIVACY-DATA-MAP-001
  - MOBILE-SURFACE-ARCHITECTURE-001
blocks:
  - MVP-EXECUTION-TICKET-PACK-001
---

# Notification and Operator Messaging Policy

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununde kime, hangi durumda, hangi kanal uzerinden, hangi tonla mesaj gidecegini; hangi bildirimlerin bilerek gonderilmeyecegini ve operator alert'leri ile kullanici bildirimlerinin nasil ayrilacagini tanimlayan resmi notification politikasidir.

Bu belge su sorulari kapatir:

- v1'de push var mi?
- viewer'a growth notification gonderilecek mi?
- creator import, billing, security ve ownership durumlari nasil haber verilecek?
- operator alert ile user-facing notice ayni sey midir?

---

## 2. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` v1'de bildirim sistemini growth veya manipulative retention araci olarak kullanmayacak; viewer-facing push veya marketing reminder acmayacak; creator-facing user notification authority'si `in-app notification center + transactional email` olacak; mobile push v1 critical path disinda kalacak; operator alert'leri user notification sistemiyle karistirilmayacaktir.

Bu karar su sonuclari dogurur:

1. v1'de push dependency'si implementasyon blocker degildir
2. reminder spam veya "geri gel" growth kurgusu yoktur
3. kritik account/billing/security mesajlari email ile garanti altina alinir
4. app icinde okunabilir notification inbox gerekir

---

## 3. Notification siniflari

Bu urunde bildirimler dort ana sinifa ayrilir:

1. creator-facing operational notifications
2. creator-facing attention-required notices
3. account, billing, security and ownership notifications
4. operator-only alerts

Bilerek disarida birakilanlar:

1. viewer promo push
2. streak/gamification reminder
3. generic daily reminder
4. abandoned cart benzeri ticari nudge

---

## 4. Kanal stratejisi

## 4.1. In-app notification center

V1'de zorunludur.

Kullanimi:

1. import sonucu dikkat gerektiriyor
2. page publish blocker olustu
3. ownership invite bekliyor
4. security review gerekli

## 4.2. Transactional email

V1'de zorunludur.

Kullanimi:

1. invite
2. ownership transfer
3. billing issue
4. export/deletion
5. security notice

## 4.3. Mobile push

V1 canonical yol degildir.

Kural:

1. push provider kurulumu MVP blocker sayilmaz
2. push acilacaksa ayrik rollout ve spam guard notu gerekir

## 4.4. Operator alert kanali

User-facing kanal degildir.

Ornek:

1. Sentry alert
2. ops email
3. queue backlog incident alert'i

---

## 5. Creator-facing event aileleri

## 5.1. Import dikkat gerektiriyor

Tetik:

1. import review bekliyor
2. correction gerekli
3. merchant blocked veya high-risk failure olustu

Kanal:

1. in-app notice
2. email yalniz uzun sure bekleyen veya blocked state icin

## 5.2. Publication blocker

Tetik:

1. disclosure eksik
2. link blocked
3. ownership yetkisi yetersiz

Kanal:

1. anlik in-app notice
2. email yok, ancak blocker kullanici ayrildiktan sonra da acik kaldiysa ozet email olabilir

## 5.3. Billing ve entitlement notice

Tetik:

1. checkout donusu pending
2. payment failed
3. grace period basladi
4. entitlement degisti

Kanal:

1. in-app notice
2. transactional email

## 5.4. Account ve ownership notice

Tetik:

1. workspace invite
2. ownership transfer pending
3. security-critical session change

Kanal:

1. email zorunlu
2. in-app tamamlayici

---

## 6. Viewer notification policy

Viewer'a v1'de su bildirimler gonderilmez:

1. price drop
2. back in stock
3. wishlist reminder
4. recommendation reminder

Neden:

1. viewer account modeli kritik yolda degildir
2. urun utility'si creator publishing problemidir
3. spam ve privacy riski gereksiz erken artar

---

## 7. In-app notification center kurallari

Notification center su alanlari tasir:

1. `kind`
2. `severity`
3. `createdAt`
4. `readAt`
5. `ctaTarget`
6. `workspaceId`
7. `actorScope`

Kural:

- read state user bazlidir
- duplicate event tek notification'a coker
- stale olmuş notice otomatik temizlenir veya archive edilir

---

## 8. Email copy ve ton kurallari

Email tonu:

1. net
2. sakin
3. operasyonel
4. utandirmayan

Yasak ton:

1. "geri don"
2. "seni ozledik"
3. agresif urgency
4. belirsiz marketing sloganlari

---

## 9. Deep link ve hedef davranisi

Email veya in-app CTA'leri su hedeflere gider:

1. import review screen
2. billing/entitlements screen
3. workspace invite accept flow
4. security/session review screen

Kural:

- public URL ile creator utility route'u karistirilmaz
- auth gerekiyorsa deferred redirect modeli uygulanir

---

## 10. Dedupe ve anti-spam kurallari

1. ayni root cause ayni gunde tekrar tekrar email'e donmez
2. in-app notice read edilmis ama root cause cozulmemisse severity downgrade ile kalabilir
3. billing ve security disindaki notice'lar sessizce spamlasmaz

Cooldown ornekleri:

1. import correction notice -> ayni job icin yeniden en erken state degisince
2. billing failed email -> provider state degismedikce gunluk tekrar yok

---

## 11. Delivery ve failure handling

## 11.1. Email basarisizsa

1. retry queue
2. operator-only log
3. in-app notice korunur

## 11.2. In-app notice create basarisizsa

1. action kendisi fail olmaz
2. audit event ve operator signal uretilir

## 11.3. Kanal fallback kurali

Kritik mesajlar:

1. ownership transfer
2. security
3. billing grace/failure

icin email authority'dir; in-app notice onun yerine gecmez.

---

## 12. Preferences ve consent

V1 preference modeli sade tutulur:

1. operational email -> kritik alanlarda kapatilamaz veya sinirli kapatilir
2. in-app notice -> urun davranisinin parcasi, kapatilamaz
3. future push -> ayri opt-in gerektirir

Kural:

- marketing preference ile operational notice ayni ayar altina konmaz

---

## 13. Operator-only alert ayrimi

Operator alert'leri su ailelerden gelir:

1. import failure spike
2. queue backlog
3. billing drift
4. abuse/takedown escalation

Bunlar:

1. support/ops ekraninda gorunur
2. Sentry/ops kanalina gider
3. user-facing notification sayilmaz

---

## 14. Mobile push karari ve v2 kapisi

Push'un v2'de acilmasi ancak su kosullarda kabul edilir:

1. in-app notice + email modeli yetersizlik kaniti verdi
2. push preference ve deep link altyapisi test edildi
3. support spam ve duplicate riskini kabul etti
4. operator runbook guncellendi

Bu kosullar olmadan `expo-notifications` hattina gecilmez.

---

## 15. Anti-pattern listesi

Bu belgeye gore su yaklasimlar yanlistir:

1. viewer growth push acmak
2. billing issue'yu sadece in-app notice ile gecistirmek
3. operator alert'i user notice gibi gostermek
4. push acmadan once notification center kurmamak
5. email'i marketing aracina cevirmek

---

## 16. Bu belge sonraki belgelere ne emreder?

1. `62-mobile-surface-architecture.md`, push dependency'sini v1 kritik yolundan cikaracaktir.
2. `103-support-playbooks.md`, notice root cause'larini support issue family ile esleyecektir.
3. `118-mvp-execution-ticket-pack.md`, notification center ve transactional email task'larini ayri capability olarak acacaktir.

---

## 17. Basari kriteri

Bu belge basarili sayilir, eger:

1. creator kritik account/import/billing durumlarini kacirmiyorsa
2. urun spam hissi vermiyorsa
3. operator alert ile user notice karismiyorsa
4. v1 push'siz de operasyonel olarak yeterli bildirim sistemi kuruluyorsa

