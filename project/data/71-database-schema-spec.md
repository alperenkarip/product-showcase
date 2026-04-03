---
id: DATABASE-SCHEMA-SPEC-001
title: Database Schema Spec
doc_type: data_architecture
status: ratified
version: 2.1.0
owner: engineering
last_updated: 2026-04-03
language: tr
source_of_truth: true
depends_on:
  - DOMAIN-MODEL-001
  - PRODUCT-LIBRARY-REUSE-MODEL-001
  - ROLES-PERMISSIONS-OWNERSHIP-MODEL-001
  - DATA-LIFECYCLE-RETENTION-DELETION-RULES-001
  - API-CONTRACTS-001
blocks:
  - BACKGROUND-JOBS-SCHEDULING-SPEC
  - DATA-BACKUP-RETENTION-RESTORE
  - PRIVACY-DATA-MAP
  - DATABASE-MIGRATION-SEED-BOOTSTRAP-PLAN-001
  - FEATURE-SEQUENCING-DEPENDENCY-ORDER
---

# Database Schema Spec

## 1. Bu belge nedir?

Bu belge, `product-showcase` urununun kalici veri omurgasini, ana tablo ailelerini, iliski modelini, hangi alanlarin source of truth oldugunu, nerede relational modelin zorunlu oldugunu, nerede controlled JSONB esnekligi kullanilabilecegini ve retention / audit / idempotency gereksinimlerinin fiziksel schema'ya nasil yansiyacagini tanimlayan resmi database schema belgesidir.

Bu belge yalnizca tablo listesi degildir. Fiziksel migration dalgalari, seed siniflari ve bootstrap komut authority'si `[77-database-migration-and-seed-bootstrap-plan.md](/Users/alperenkarip/Projects/product-showcase/project/data/77-database-migration-and-seed-bootstrap-plan.md)` belgesinde tanimlanir.  
Su sorulari cevaplar:

- Bu urunun ana verisi hangi depoda tutulur?
- Hangi entity'ler ayri tablolarda yasamak zorundadir?
- Product, source, placement, import ve publication zinciri fiziksel olarak nasil modellenir?
- Audit, webhook, idempotency ve workflow dedupe hangi tablolara iner?
- Retention siniflari schema seviyesinde nasil desteklenir?

---

## 2. Bu belge neden kritiktir?

Bu urunde veri modeli yuzeysel kurulursa sorun yalniz sorgu performansi olmaz.

Asil bozulmalar sunlardir:

1. Product ile source ayni tabloya yigilir ve duplicate confusion artar.
2. Placement notlari product truth'u gibi davranmaya baslar.
3. Import job kaydi ephemeral kalir, support ne oldugunu okuyamaz.
4. Publication state ile draft state birbirini ezer.
5. Idempotency ve webhook dedupe process memory seviyesinde kalir.
6. Retention / restore / audit geriye donuk uygulanamaz hale gelir.

Bu nedenle database schema, "ileride ORM ile hallederiz" seviyesi bir not degil; sistemin kalici davranis haritasidir.

---

## 3. Ana karar

Bu belge icin ana karar sudur:

> `product-showcase` icin ana kalici veri kaynagi relation-first bir PostgreSQL veritabanidir; urunun cekirdek entity'leri normalize tablolarla modellenir; JSONB yalnizca kontrollu esneklik alanlarinda kullanilir; binary/media artefact'lari object storage'da, ama bunlarin kimlik ve state metadatasi veritabaninda tutulur.

Bu karar su sonuclari dogurur:

1. "Her seyi document store'a atalım" yaklasimi benimsenmez.
2. Product, source, placement ve import workflow ayri tablolarda yasar.
3. Public truth ile transient extraction artefact'i ayni satirda tutulmaz.
4. Audit, webhook ve idempotency durable kayitlar olarak saklanir.
5. Media dosyasinin kendisi DB'de blob olarak tutulmaz; state'i tutulur.

---

## 4. Veri saklama ilkeleri

## 4.1. Relational cekirdek

Asagidaki alanlar relational model gerektirir:

- auth ve principal iliskileri
- creator/workspace ownership
- storefront / shelf / content page publication iliskileri
- product / source / placement zinciri
- import job ve verification workflow iliskileri
- billing / entitlement / webhook / audit kayitlari

## 4.2. Controlled JSONB

JSONB kullanimi su gibi kontrollu alanlarla sinirlanir:

- appearance configuration payload'lari
- extraction raw field bundle ozetleri
- disclosure config gibi varyasyonlu ama bounded alanlar
- workflow metadata snapshot'lari

JSONB su alanlar icin yasaktir:

- foreign key yerine
- search filtre omurgasi yerine
- permission matrix yerine
- dedupe ve identity truth'u yerine

## 4.3. Binary ayirma ilkesi

Image ve generated asset binary'leri object storage'da yasayabilir.  
Ama DB tarafinda su bilgiler tutulur:

- asset id
- owner/workspace iliskisi
- source turu
- variant turu
- hash
- mime type
- width/height
- lifecycle state

## 4.4. Durable workflow kaydi

Asenkron ve hassas workflow'lar icin yalniz queue provider log'una guvenilmez.

DB tarafinda durable kayit tutulur:

- import jobs
- verification sessions
- publication attempts
- webhook deliveries
- idempotency keys
- workflow dedupe keys

---

## 5. Kimlik, zaman ve lifecycle kolon ilkeleri

## 5.1. Kimlik

Ana product tablolarinda chronologically sortable, tahmin edilemez id kullanilir.

Pratik ilke:

- string tabanli ULID veya sortable UUID
- disariya acilan entity id'leri integer sequence olmaz

## 5.2. Ortak zaman alanlari

Her ana tabloda asgari:

- `created_at`
- `updated_at`

Workflow veya publication state tasiyan tablolarda ayrica gerektikce:

- `published_at`
- `archived_at`
- `deleted_at`
- `failed_at`
- `completed_at`
- `expires_at`

## 5.3. Actor izi

Ownership-sensitive veya audit kritik tablolarda ayrica:

- `created_by_user_id`
- `updated_by_user_id`

veya uygun actor kolonlari bulunur.

## 5.4. Soft delete ilkesi

Random soft delete kullanimi yasaktir.

Entity'ye gore davranis ayrilir:

1. archiveable content entity
2. restore pencereli operational entity
3. legal retention gerektiren immutable record
4. true delete veya anonymization'a giden entity

`deleted_at` her tabloya reflex olarak eklenmez.

---

## 6. Ana tablo aileleri

Bu urunun tablolari dokuz aileye ayrilir:

1. auth ve account
2. creator workspace ve ayarlar
3. public publishing surfaces
4. product ve source graph
5. import ve verification workflow
6. media ve appearance
7. billing ve entitlements
8. reliability, idempotency ve webhook
9. audit ve governance

---

## 7. Auth ve account tablolari

Auth omurgasi kullanimdaki auth cozumunun zorunlu tablolarini tasiyabilir.  
Ama product-level beklentiler baglayicidir.

Asgari tablolar:

- `users`
- `accounts`
- `sessions`
- `verifications`
- `user_settings`

### 7.1. `users`

Canonical teknik kullanici kimligidir.

Asgari kolonlar:

- `id`
- `email`
- `email_verified_at`
- `display_name`
- `status`
- `created_at`
- `updated_at`

Not:

`display_name` burada teknik account label'i olabilir; public creator display name'i ayri tabloda da tasinabilir.

### 7.2. `accounts`

Provider linking tablosu.

Kolon ornekleri:

- `id`
- `user_id`
- `provider`
- `provider_account_id`
- `access_scopes_json`
- `created_at`
- `updated_at`

Kurallar:

1. `provider + provider_account_id` unique olur.
2. Raw secret token gerekmiyorsa kalici tutulmaz.

### 7.3. `sessions`

Durable session meta tablosu.

Kolon ornekleri:

- `id`
- `user_id`
- `session_state`
- `device_label`
- `last_seen_at`
- `expires_at`
- `revoked_at`
- `created_at`

### 7.4. `user_settings`

Account-level tercihlerin source of truth'u.

Kolon ornekleri:

- `user_id`
- `locale`
- `timezone`
- `notification_email_opt_in`
- `analytics_opt_in`
- `created_at`
- `updated_at`

---

## 8. Creator workspace ve ayarlar

Asgari tablolar:

- `creator_profiles`
- `workspace_memberships`
- `workspace_invites`
- `workspace_scopes`
- `ownership_transfer_requests`

### 8.1. `creator_profiles`

Public ve urunsel creator kimligi.

Kolon ornekleri:

- `id`
- `owner_user_id`
- `handle`
- `display_name`
- `avatar_asset_id`
- `bio`
- `status`
- `created_at`
- `updated_at`

Invariants:

1. `handle` unique olur.
2. `owner_user_id` canonical owner iliskisini tasir.
3. Public status ve account status ayni sey degildir.

### 8.2. `workspace_memberships`

Owner/editor iliskisi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `user_id`
- `role`
- `membership_state`
- `invited_by_user_id`
- `accepted_at`
- `revoked_at`
- `created_at`

Invariants:

1. Her creator workspace'te tek aktif owner vardir.
2. Ayni `creator_profile_id + user_id` kombinasyonu icin tek aktif membership olur.
3. `role` enum'u sadece belgede tanimli rollerden biri olabilir.

### 8.3. `workspace_invites`

Davranissal davet kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `email`
- `proposed_role`
- `invite_token_hash`
- `status`
- `expires_at`
- `created_by_user_id`
- `accepted_membership_id`
- `created_at`

### 8.4. `ownership_transfer_requests`

Owner degisiminin durable workflow kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `from_user_id`
- `to_user_id`
- `status`
- `reauth_verified_at`
- `confirmed_at`
- `completed_at`
- `expires_at`
- `created_at`

---

## 9. Public publishing surface tablolari

Asgari tablolar:

- `storefronts`
- `shelves`
- `content_pages`
- `surface_publications`
- `surface_slugs`
- `surface_sections`

### 9.1. `storefronts`

Creator'in public root surface'i.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `current_publication_state`
- `title`
- `tagline`
- `appearance_config_json`
- `custom_domain_id` opsiyonel
- `created_at`
- `updated_at`

Invariants:

1. Her creator profile icin tek aktif storefront vardir.
2. Storefront publication state draft veya archived state'lerle karistirilmaz.

### 9.2. `shelves`

Nispeten kalici context surface'i.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `storefront_id`
- `slug`
- `title`
- `summary`
- `visibility_state`
- `default_sort_order`
- `created_at`
- `updated_at`
- `archived_at`

### 9.3. `content_pages`

Belirli icerik veya kampanya baglamina ait page.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `storefront_id`
- `slug`
- `title`
- `summary`
- `content_context_type`
- `source_content_url`
- `visibility_state`
- `scheduled_publish_at`
- `created_at`
- `updated_at`
- `archived_at`

### 9.4. `surface_publications`

Draft ve published durumlarin atomik kaydi icin publication tablosu.

Neden ayri tablo?

1. Draft edit ile published snapshot ayrisini korumak
2. Publish/unpublish denemelerini auditli tutmak
3. Cache invalidation ve public rollback'i kolaylastirmak

Kolon ornekleri:

- `id`
- `surface_type`
- `surface_id`
- `publication_revision`
- `publication_state`
- `canonical_path`
- `published_snapshot_json`
- `published_at`
- `unpublished_at`
- `created_by_user_id`
- `created_at`

Kural:

Published truth daima son aktif publication satirindan okunur; draft tablolar veya live edit state'i public source of truth olmaz.

### 9.5. `surface_slugs`

Slug history ve conflict resolution tablosu.

Kolon ornekleri:

- `id`
- `surface_type`
- `surface_id`
- `slug`
- `is_active`
- `redirect_to_slug`
- `created_at`
- `deactivated_at`

### 9.6. `surface_sections`

Storefront icindeki featured shelf/content page sirasini tutar.

Kolon ornekleri:

- `id`
- `storefront_id`
- `section_type`
- `ref_surface_id`
- `position`
- `created_at`
- `updated_at`

---

## 10. Product ve source graph tablolari

Asgari tablolar:

- `products`
- `product_sources`
- `product_source_snapshots`
- `product_placements`
- `product_media_assets`
- `product_tags`
- `tag_assignments`

### 10.1. `products`

Creator library icindeki tekrar kullanilabilir urun primitive'i.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `title`
- `normalized_title`
- `brand_name`
- `variant_hint`
- `selected_source_id`
- `selected_media_asset_id`
- `disclosure_config_json`
- `product_state`
- `created_at`
- `updated_at`
- `archived_at`

Invariants:

1. Product creator scope'u disina tasmaz.
2. `selected_source_id`, ayni product'a bagli aktif bir source olmak zorundadir.
3. Archived product aktif placement truth'u olamaz.

### 10.2. `product_sources`

Harici merchant/source kaydi.

Kolon ornekleri:

- `id`
- `product_id`
- `merchant_key`
- `submitted_url`
- `normalized_url`
- `canonical_url`
- `external_product_id`
- `source_tier`
- `source_state`
- `last_checked_at`
- `freshness_state`
- `price_display_state`
- `availability_state`
- `observed_price_amount`
- `observed_price_currency`
- `price_observed_at`
- `created_at`
- `updated_at`

Invariants:

1. `canonical_url` yoksa source import edilebilir ama active/selected source olamaz.
2. Ayni product altinda ayni canonical URL icin tek aktif source kaydi olur.
3. `merchant_key + external_product_id` varsa duplicate sinyali olarak indexlenir.

### 10.3. `product_source_snapshots`

Fiyat, availability ve extraction tarihcesi.

Kolon ornekleri:

- `id`
- `product_source_id`
- `snapshot_reason`
- `observed_title`
- `observed_price_amount`
- `observed_price_currency`
- `availability_state`
- `freshness_state`
- `raw_extraction_summary_json`
- `captured_at`

Neden ayrik?

1. Current source state ile history ayri kalir.
2. Support stale veya drift analizini okuyabilir.

### 10.4. `product_placements`

Bir product'in belirli bir surface icindeki gorunumu.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `product_id`
- `surface_type`
- `surface_id`
- `position`
- `placement_title_override`
- `placement_note`
- `is_featured`
- `created_at`
- `updated_at`
- `archived_at`

Invariants:

1. Bir placement ya shelf'e ya content page'e baglidir.
2. `surface_type + surface_id + position` unique duzende korunur.
3. Placement override product truth'unu degistirmez.

### 10.5. `product_media_assets`

Product ile asset iliskisi.

Kolon ornekleri:

- `id`
- `product_id`
- `asset_id`
- `media_role`
- `selection_state`
- `created_at`

### 10.6. `product_tags` ve `tag_assignments`

Tag taxonomy fiziksel baglantisi.

`product_tags`:

- `id`
- `tag_family`
- `tag_key`
- `display_label`
- `status`
- `created_at`

`tag_assignments`:

- `id`
- `tag_id`
- `target_type`
- `target_id`
- `assignment_source`
- `created_at`

Kurallar:

1. Taxonomy truth'u tag tablosundadir.
2. Assignment ayni hedefte duplicate satir uretemez.

---

## 11. Import ve verification workflow tablolari

Asgari tablolar:

- `import_jobs`
- `import_job_attempts`
- `verification_sessions`
- `verification_field_corrections`
- `reuse_candidates`
- `manual_review_actions`

### 11.1. `import_jobs`

Import workflow'unun durable root kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `actor_user_id`
- `submitted_url`
- `normalized_url`
- `intent`
- `target_surface_type`
- `target_surface_id`
- `status`
- `current_stage`
- `failure_code`
- `retry_eligible`
- `active_verification_session_id`
- `resulting_product_id`
- `expires_at`
- `accepted_at`
- `completed_at`
- `created_at`
- `updated_at`

Invariants:

1. `applied` durumundaki job yeni active verification oturumu acmaz.
2. `blocked` ile `failed` farkli semantik tasir.
3. Import job support icin okunabilir olmali; yalniz queue provider log'una dayanmaz.

### 11.2. `import_job_attempts`

Her teknik calistirma denemesi.

Kolon ornekleri:

- `id`
- `import_job_id`
- `attempt_number`
- `trigger_type`
- `worker_run_id`
- `stage_started_at`
- `stage_completed_at`
- `outcome`
- `failure_code`
- `failure_family`
- `metadata_json`
- `created_at`

Neden ayri tablo?

1. Retry tarihi okunur
2. Sistemik merchant sorunu ayrisir
3. Tek job icinde coklu attempt korunur

### 11.3. `verification_sessions`

Creator review ve apply kapisinin source of truth'u.

Kolon ornekleri:

- `id`
- `import_job_id`
- `session_state`
- `source_candidate_summary_json`
- `reuse_summary_json`
- `expires_at`
- `last_viewed_at`
- `applied_at`
- `created_at`
- `updated_at`

Invariants:

1. Bir import job icin launch'ta tek aktif verification session vardir.
2. Expired session apply kabul etmez.

### 11.4. `verification_field_corrections`

Insan duzeltme kaydi.

Kolon ornekleri:

- `id`
- `verification_session_id`
- `field_key`
- `previous_value_json`
- `corrected_value_json`
- `correction_source`
- `created_by_user_id`
- `created_at`

Kural:

Manual correction, extracted truth'u overwrite eden izsiz patch degildir; alan bazli audit satiridir.

### 11.5. `reuse_candidates`

Duplicate/reuse analiz sonucu bulunan adaylar.

Kolon ornekleri:

- `id`
- `verification_session_id`
- `candidate_product_id`
- `confidence_level`
- `match_reasons_json`
- `disposition`
- `created_at`

### 11.6. `manual_review_actions`

Creator'in verification sirasindaki karar trail'i.

Kolon ornekleri:

- `id`
- `verification_session_id`
- `action_type`
- `actor_user_id`
- `reason_code`
- `payload_json`
- `created_at`

---

## 12. Media ve appearance tablolari

Asgari tablolar:

- `media_assets`
- `media_variants`
- `og_assets`
- `custom_domains`

### 12.1. `media_assets`

Object storage'daki binary'nin metadata kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `asset_origin`
- `object_key`
- `storage_bucket`
- `sha256_hash`
- `mime_type`
- `width`
- `height`
- `asset_state`
- `created_at`
- `archived_at`

### 12.2. `media_variants`

Derived/resized/cropped asset'ler.

Kolon ornekleri:

- `id`
- `asset_id`
- `variant_type`
- `object_key`
- `width`
- `height`
- `derivation_state`
- `created_at`

### 12.3. `og_assets`

Public share preview ve OG gorsel kaydi.

Kolon ornekleri:

- `id`
- `surface_type`
- `surface_id`
- `asset_id`
- `generation_revision`
- `is_active`
- `generated_at`

### 12.4. `custom_domains`

Custom domain bağlama ve verification kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `hostname`
- `verification_state`
- `dns_target`
- `last_verified_at`
- `created_at`
- `updated_at`

---

## 13. Billing ve entitlement tablolari

Asgari tablolar:

- `billing_customers`
- `subscriptions`
- `entitlement_snapshots`
- `billing_checkout_sessions`

### 13.1. `billing_customers`

Harici billing provider ile user/workspace mapping'i.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `provider`
- `provider_customer_id`
- `created_at`
- `updated_at`

### 13.2. `subscriptions`

Billing state mirror kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `provider`
- `provider_subscription_id`
- `plan_key`
- `subscription_state`
- `period_start_at`
- `period_end_at`
- `grace_ends_at`
- `cancel_at_period_end`
- `created_at`
- `updated_at`

Kural:

Provider event'i authoritative ticari kaynaktir; ama product access karari direct bu satirdan degil entitlement tablosundan okunur.

### 13.3. `entitlement_snapshots`

Product access truth'u.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `plan_key`
- `capabilities_json`
- `effective_state`
- `computed_from_subscription_id`
- `created_at`
- `superseded_at`

### 13.4. `billing_checkout_sessions`

Checkout baslatma ve bridge takip tablosu.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `provider`
- `provider_session_id`
- `checkout_state`
- `bridge_state`
- `expires_at`
- `completed_at`
- `created_at`

---

## 14. Reliability, idempotency ve webhook tablolari

Asgari tablolar:

- `idempotency_keys`
- `workflow_dedup_keys`
- `webhook_events`
- `outbox_events`

### 14.1. `idempotency_keys`

Request bazli duplicate guard.

Kolon ornekleri:

- `id`
- `idempotency_key`
- `route_family`
- `actor_user_id`
- `workspace_id`
- `request_hash`
- `response_fingerprint`
- `status`
- `expires_at`
- `created_at`

Unique prensibi:

- `idempotency_key + route_family + actor_user_id`

### 14.2. `workflow_dedup_keys`

Job veya event tabanli duplicate guard.

Kolon ornekleri:

- `id`
- `workflow_type`
- `dedup_key`
- `target_entity_type`
- `target_entity_id`
- `expires_at`
- `created_at`

### 14.3. `webhook_events`

External ingress durable kaydi.

Kolon ornekleri:

- `id`
- `provider`
- `provider_event_id`
- `event_type`
- `delivery_state`
- `signature_verified`
- `payload_hash`
- `masked_payload_json`
- `received_at`
- `processed_at`
- `failure_code`

Invariants:

1. `provider + provider_event_id` unique olur.
2. Duplicate event ikinci kez side effect uretmez.

### 14.4. `outbox_events`

Internal event publishing icin DB outbox modeli.

Kolon ornekleri:

- `id`
- `event_name`
- `aggregate_type`
- `aggregate_id`
- `payload_json`
- `publish_state`
- `published_at`
- `created_at`

Neden gerekli?

1. DB commit ile event publish arasindaki kayip riski azaltilir.
2. Cache invalidation, job tetigi ve telemetry publish senkronize edilir.

---

## 15. Audit ve governance tablolari

Asgari tablolar:

- `audit_events`
- `support_actions`
- `deletion_requests`
- `data_export_requests`

### 15.1. `audit_events`

Yuksek onemli mutasyon izi.

Kolon ornekleri:

- `id`
- `actor_type`
- `actor_user_id`
- `workspace_id`
- `action_type`
- `target_entity_type`
- `target_entity_id`
- `before_snapshot_json`
- `after_snapshot_json`
- `reason_code`
- `created_at`

Kural:

Audit event analytics event'i degildir.  
Retention ve erisim politikasi daha sıkıdır.

### 15.2. `support_actions`

Scoped support/ops mutasyon kaydi.

Kolon ornekleri:

- `id`
- `performed_by_user_id`
- `workspace_id`
- `action_family`
- `target_entity_type`
- `target_entity_id`
- `reason_text`
- `created_at`

### 15.3. `deletion_requests`

Account/workspace deletion workflow root kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `requested_by_user_id`
- `request_state`
- `confirmed_at`
- `processing_started_at`
- `completed_at`
- `created_at`

### 15.4. `data_export_requests`

Veri export workflow kaydi.

Kolon ornekleri:

- `id`
- `creator_profile_id`
- `requested_by_user_id`
- `request_state`
- `artifact_asset_id`
- `expires_at`
- `created_at`
- `completed_at`

---

## 16. Iliski ve foreign key kurallari

Asgari zorunlu foreign key hatlari:

1. `creator_profiles.owner_user_id -> users.id`
2. `storefronts.creator_profile_id -> creator_profiles.id`
3. `shelves.storefront_id -> storefronts.id`
4. `content_pages.storefront_id -> storefronts.id`
5. `products.creator_profile_id -> creator_profiles.id`
6. `product_sources.product_id -> products.id`
7. `product_placements.product_id -> products.id`
8. `import_jobs.creator_profile_id -> creator_profiles.id`
9. `verification_sessions.import_job_id -> import_jobs.id`
10. `subscriptions.creator_profile_id -> creator_profiles.id`
11. `webhook_events` provider-spesifik referans gerektiginde baglayici target id tasiyabilir

Kurallar:

1. Orphan placement kabul edilmez.
2. Orphan selected source kabul edilmez.
3. Publication kaydi olmayan live public state yaratilmaz.
4. Destructive delete'te foreign key cascade kontrolsuz kullanilmaz.

---

## 17. Index stratejisi

Schema performansi sonradan "belki ekleriz" denmez.  
Asgari index aileleri ilk migration'larda vardir.

### 17.1. Lookup index'leri

- `creator_profiles(handle)` unique
- `shelves(creator_profile_id, slug)`
- `content_pages(creator_profile_id, slug)`
- `custom_domains(hostname)` unique

### 17.2. Workflow index'leri

- `import_jobs(creator_profile_id, status, created_at desc)`
- `import_job_attempts(import_job_id, attempt_number desc)`
- `verification_sessions(import_job_id, session_state)`
- `webhook_events(provider, provider_event_id)` unique

### 17.3. Product/source index'leri

- `products(creator_profile_id, archived_at, updated_at desc)`
- `product_sources(product_id, source_state)`
- `product_sources(merchant_key, canonical_url)`
- `product_sources(merchant_key, external_product_id)` where not null
- `product_placements(surface_type, surface_id, position)`

### 17.4. Reliability index'leri

- `idempotency_keys(idempotency_key, route_family, actor_user_id)` unique
- `workflow_dedup_keys(workflow_type, dedup_key)` unique
- `outbox_events(publish_state, created_at)`

### 17.5. JSONB index siniri

JSONB alanlarinda index ancak query plani icin gercek ihtiyac varsa eklenir.  
Rastgele GIN index dagitilmaz.

---

## 18. State kolonlari ve enum disiplini

Asagidaki alanlar serbest text olarak tutulmaz; controlled enum mantigi kullanir:

- membership state
- publication state
- product state
- source state
- freshness state
- import job status
- verification session state
- subscription state
- checkout state
- webhook delivery state

Neden?

1. Contract ve telemetry ile ayni dili korumak
2. Query ve dashboard tutarliligini saglamak
3. Typosource state kaosunu engellemek

---

## 19. Retention ve restore semantiginin schema'ya yansimasi

`[35-data-lifecycle-retention-and-deletion-rules.md](/Users/alperenkarip/Projects/product-showcase/project/domain/35-data-lifecycle-retention-and-deletion-rules.md)` bu konuda policy belgesidir.  
Schema tarafinda su destekler zorunludur:

1. `expires_at` alanlari workflow artefact'larinda bulunur.
2. `archived_at`, `deleted_at`, `completed_at` gibi lifecycle alanlari gereken entity'lerde vardir.
3. R2/R3/R4 retention siniflari icin purge eligibility query'leri indexlenebilir olur.
4. Audit ve billing gibi immutable kayitlar archive/purge mekanizmasiyla karistirilmaz.

Ornekler:

- verification session -> kisa omurlu restore gerektirmez, expiration yeterlidir
- import job summary -> operasyonel retention boyunca tutulur
- audit event -> uzun omurlu immutable kayittir
- billing subscription mirror -> legal/operational retention tasir

---

## 20. Migration ilkeleri

Schema migration disiplini su kurallari izler:

1. Forward-only migration esastir.
2. Breaking rename gerekiyorsa additive -> backfill -> switch -> cleanup modeli uygulanir.
3. Buyuk tablo rewrite'lari tek migration'da kilit olusturacak sekilde yapilmaz.
4. Enum/state eklemeleri contracts ve telemetry ile birlikte evrilir.

### 20.1. Yasak yaklasimlar

1. Mevcut production alanini sessizce baska anlamda kullanmak
2. Product truth ve placement truth'u ayni kolonda birlestirmek
3. JSONB icinde foreign key gizlemek
4. Queue provider var diye durable workflow tablosu acmamak

---

## 21. Senaryo bazli fiziksel davranislar

### 21.1. Senaryo: Yeni import reuse ile sonuclanir

Beklenen DB davranisi:

1. `import_jobs` satiri acilir
2. `import_job_attempts` kayitlari yazilir
3. `verification_sessions` olusur
4. `reuse_candidates` icine mevcut product adaylari yazilir
5. Apply sonunda yeni product yerine mevcut `products.id` kullanilir
6. Gerekirse yeni `product_sources` ve `product_placements` satiri acilir
7. `audit_events` kaydi olusur

### 21.2. Senaryo: Creator selected source degistirir

Beklenen DB davranisi:

1. `products.selected_source_id` guncellenir
2. `updated_at` artar
3. Gecersiz source secimi foreign key veya domain guard ile engellenir
4. Outbox event uretilebilir

### 21.3. Senaryo: Shelf publish edilir

Beklenen DB davranisi:

1. Draft content truth'u okunur
2. `surface_publications` icine yeni revision satiri yazilir
3. `surface_slugs` aktifligi dogrulanir
4. Outbox event ile revalidation tetiklenir
5. Audit izi yazilir

### 21.4. Senaryo: Billing provider duplicate webhook gonderir

Beklenen DB davranisi:

1. `webhook_events` unique key duplicate'i yakalar
2. Yan etki ikinci kez uygulanmaz
3. Gerekirse duplicate delivery kaydi ayrik metadata ile not edilir

---

## 22. Veri erisim anti-pattern'leri

Bu belgede acikca yasaklanan yaklasimlar:

1. Page icindeki placement kartini ayri product truth'u gibi saklamak
2. Import sonucu raw HTML veya full screenshot blob'unu kontrolsuz sekilde ana DB'de tutmak
3. Billing access kararini sadece provider subscription row'undan okumak
4. Verification correction'i final product alanina izsiz overwrite etmek
5. Publication snapshot olmadan live public content'i draft tablodan okumak
6. Dedupe ve idempotency'yi in-memory map ile cozmeye calismak
7. Her relation'ı JSONB nested array'e gommek

---

## 23. Bu belge sonraki belgelere ne emreder?

### 23.1. Background jobs belgesine

- import, refresh, cleanup, webhook ve export workflow'lari burada tanimli durable tablolara yazacak

### 23.2. Backup ve restore belgesine

- hangi tablo ailesinin nasil yedeklenecegi ve restore penceresi bu schema ailelerine gore kurulacak

### 23.3. Privacy data map'e

- veri gruplari bu fiziksel tablo ailelerine baglanacak

### 23.4. Uygulama implementasyonuna

- ORM secimi ne olursa olsun foreign key, unique constraint ve index disiplininden taviz verilmeyecek

---

## 24. Bu belgenin basari kriteri nedir?

Bu belge basarili sayilmak icin su kosullar saglanmis olmalidir:

1. Domain modeldeki ana primitive'lerin fiziksel karsiligi nettir.
2. Product/source/placement/import/publication/billing zinciri tablo seviyesinde ayrismistir.
3. Idempotency, webhook ve audit durable schema ile desteklenmektedir.
4. Retention ve restore kurallari tablo/lifecycle alanlarina inmistir.
5. Yeni bir backend muhendisi bu belgeye bakarak migration planini cikartabilir ve "hangi veri nerede yasiyor?" sorusunu ek açıklama istemeden cevaplayabilir.
