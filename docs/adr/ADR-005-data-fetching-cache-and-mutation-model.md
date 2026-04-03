# ADR-005 — Data Fetching, Cache and Mutation Model

## Doküman Kimliği

- **ADR ID:** ADR-005
- **Başlık:** Data Fetching, Cache and Mutation Model
- **Durum:** Accepted
- **Tarih:** 2026-03-31
- **Karar türü:** Foundational data access, async state, cache ownership and mutation strategy decision
- **Karar alanı:** Server state yönetimi, query/cache tool seçimi, data access modeli, mutation lifecycle, invalidation, optimistic update, retry, error mapping, stale data ownership
- **İlgili üst belgeler:**
  - `10-data-fetching-cache-sync.md`
  - `06-application-architecture.md`
  - `09-state-management-strategy.md`
  - `11-forms-inputs-and-validation.md`
  - `15-quality-gates-and-ci-rules.md`
  - `25-error-empty-loading-states.md`
  - `36-canonical-stack-decision.md`
  - `ADR-004-state-management.md`
- **Etkilediği belgeler:**
  - `20-initial-implementation-checklist.md`
  - `21-repo-structure-spec.md`
  - `28-observability-and-debugging.md`
  - `30-contribution-guide.md`
  - `31-audit-checklist.md`
  - `32-definition-of-done.md`
  - `ADR-006-forms-and-validation.md`
  - `ADR-009-observability-stack.md`

---

# 1. Karar Özeti

Bu boilerplate kapsamında data fetching, cache ve mutation modeli için aşağıdaki karar kabul edilmiştir:

- **Server state / query-cache yaklaşımı:** Fetch-first default bootstrap + TanStack Query 5.x conditional query layer
- **Canonical veri modeli:** Client-driven query/cache lifecycle, route ve feature orchestration ile hizalı
- **Source of truth ilkesi:** Server-owned data mümkün olduğunca query/cache katmanında yaşar; generic client store’a kopyalanmaz
- **Mutation modeli:** Explicit mutation lifecycle + invalidate/revalidate merkezli; gerektiğinde kontrollü optimistic update
- **Data access yaklaşımı:** Raw fetch çağrıları screen/component içine dağılmaz; feature veya data access contract katmanı üzerinden kurulur
- **Error yaklaşımı:** Teknik hata, domain/feature anlamı ve user-facing feedback ayrılır
- **Retry yaklaşımı:** Kör global retry değil; query ve mutation bağlamına göre kontrollü policy
- **Cache ownership:** Query key, stale time, invalidation ve background refresh kararları belgeli ve tutarlı olmalıdır
- **Canonical ilke:** Async veri davranışı “ad-hoc fetch + local state” ile değil; query lifecycle, cache ownership, mapping ve feedback state disiplini ile yönetilir

Bu ADR’nin ana hükmü şudur:

> Server state bu boilerplate’te generic client store konusu değildir. Küçük / düşük async karmaşıklıklı derived project’ler fetch-first başlayabilir; ancak query/cache/mutation/offline karmaşıklık eşiği aşıldığında **TanStack Query 5.x** canonical query layer olarak devreye alınır. UI ve feature orchestration, bu katmanın ürettiği lifecycle sinyallerini tüketir; onun yerini almaz.

---

# 2. Problem Tanımı

Modern cross-platform uygulamalarda en pahalı bug ailelerinden biri data behavior kaynaklıdır.  
Yani problem çoğu zaman “buton görünmedi” değil, şunlardan biridir:

- veri stale kaldı
- mutation sonrası yanlış liste gösterildi
- aynı veri farklı yerlerde farklı göründü
- retry mantığı kullanıcıyı kilitledi
- loading state tüm ekranı gereksiz blokladı
- background refresh ile UI flicker yaptı
- optimistic update yanlış rollback oldu
- raw backend error doğrudan kullanıcıya aktı
- query data store’a kopyalandığı için source of truth çoğaldı
- logout / workspace switch sonrası eski data ekranda kaldı

Bu yüzden data fetching kararı yalnızca “hangi HTTP client?” kararı değildir.  
Asıl karar şudur:

> Server-owned veri nerede yaşayacak, ne zaman stale sayılacak, nasıl invalidation alacak, mutation sonrası nasıl senkron kalacak ve bu davranış UI’ya nasıl yansıtılacak?

Bu ADR tam olarak bu soruyu kapatır.

---

# 3. Bağlam

Bu boilerplate’in data tarafında taşıdığı zorunluluklar şunlardır:

1. Web ve mobile arasında behavior parity
2. Server state ile client state’in kesin ayrımı
3. Async lifecycle’ın UI ve feature akışlarında görünür olması
4. Loading / empty / error / success / retry davranışlarının tutarlılığı
5. Type-safe ve test edilebilir data contracts
6. Design system ve feedback state standardı ile uyum
7. Controlled invalidation ve mutation sonrasında güvenilir sonuç
8. Security ve logging hijyeninin korunması
9. Documentation-first ownership modeli
10. Ad-hoc fetch ve local cache kaosunun engellenmesi

Bu bağlamda seçilecek model şu iki uçtan da kaçınmalıdır:

- her şeyi custom fetch/local state ile çözmek
- query kütüphanesi var diye ownership düşünmeden her şeyi ona yıkmak

---

# 4. Karar Kriterleri

Bu karar aşağıdaki kriterlerle değerlendirilmiştir:

1. **Server state ownership’e uygunluk**
2. **Cache, stale ve invalidation disiplinini güçlü destekleme**
3. **Mutation lifecycle yönetimi**
4. **Retry ve error handling esnekliği**
5. **TypeScript ve testing uyumu**
6. **Cross-platform React ekosistemiyle doğal çalışma**
7. **UI lifecycle’ı ile entegrasyon**
8. **Low-level boilerplate azaltma**
9. **Custom policy yazmaya izin verme**
10. **Tooling ve community olgunluğu**
11. **Store duplication riskini azaltma**
12. **Documentation-first data contracts ile uyum**

---

# 5. Değerlendirilen Alternatifler

Bu karar öncesi ana alternatifler şunlardır:

1. TanStack Query
2. SWR
3. Custom fetch client + manual local cache/state
4. Redux Toolkit Query
5. Server state’i Zustand içinde yönetme
6. “Her feature kendi fetch mantığını yazar” yaklaşımı

Bu alternatiflerin neden seçilmediği veya seçildiği aşağıda açıklanmıştır.

---

# 6. Seçilen Karar: Şartlı Query-Layer Modeli (TanStack Query canonical escalation tool)

## 6.1. Neden TanStack Query conditional canonical query layer olarak seçildi?

Bu boilerplate'te default bootstrap fetch-first olabilir; ancak query/cache/mutation/offline karmaşıklık eşiği aşıldığında TanStack Query şu nedenlerle canonical escalation aracı olarak kabul edilir:

### 6.1.1. Server state için özel olarak tasarlanmış olması
Bu çok kritik bir farktır.  
TanStack Query generic app state aracı değildir.  
Tam tersine, tam da şu problemleri çözmek için vardır:
- fetch lifecycle
- cache
- staleness
- refetch
- invalidation
- mutation coordination
- background sync

Bu, ADR-004 ile doğrudan uyumludur.

### 6.1.2. Modern React async veri modeline güçlü uyum
React tabanlı web ve React Native tabanlı mobile için doğal ve olgun bir async state modeli sunar.

### 6.1.3. Query ve mutation ayrımını açık tutması
Bu proje için çok önemli olan şu ayrımı teknik olarak destekler:
- okuma davranışı
- yazma davranışı
- invalidation sonrası güncellenme
- optimistic update ve rollback

### 6.1.4. Retry, stale ve refetch davranışlarını policy ile yönetebilme
“Tek fetch attık, oldu” yaklaşımından çok daha kontrollü veri davranışı sağlar.

### 6.1.5. Ekosistem ve dokümantasyon olgunluğu
TanStack Query olgun, yaygın ve production-grade kullanımı olan bir araçtır.

### 6.1.6. Testing ve observability açısından güçlü kontrol
Query behavior test edilebilir; async lifecycle görünür hale getirilebilir.

---

# 7. Bu Karar Ne Anlama Gelmez?

Bu ADR yanlış yorumlanmaya çok açıktır.  
Bu yüzden sınırlar açık yazılmalıdır.

## 7.1. “Her derived project bootstrap anında TanStack Query kurmak zorunda” demek değildir
Hayır.  
Düşük async karmaşıklıkta fetch-first başlangıç meşrudur; tool yalnızca gerektiğinde devreye giren query-layer mekanizması sağlar. Ownership ve policy yine belgelidir.

## 7.2. “Fetch client artık önemsiz” demek değildir
Hayır.  
HTTP client ve mapping policy hâlâ önemlidir.

## 7.3. “Store’a hiç veri koyulamaz” demek değildir
Yanlış.  
Ama server-owned veri generic client store’a kopyalanmaz.

## 7.4. “Her query global ve sınırsız cache’lensin” demek değildir
Yanlış.  
Cache ownership ve stale policy bağlama göre düşünülür.

## 7.5. “Optimistic update her zaman yapılmalı” demek değildir
Yanlış.  
Optimistic update yalnızca gerçekten anlamlı ve güvenli olduğunda uygulanır.

---

# 8. En Kritik İlke: Server State’in Resmi Evi

Bu ADR’nin kalbi şu cümledir:

> **Server-owned async data’nın resmi evi query/cache katmanıdır.**

Bu cümle pratikte şunu ifade eder:

- API’den gelen listeler query/cache katmanında yaşar
- detail response’ları query/cache katmanında yaşar
- stale/refetch mantığı burada yönetilir
- invalidation burada ele alınır
- UI, query lifecycle’ı tüketir
- generic global store bu veriyi duplicate etmez

Bu ilke bozulursa tüm veri mimarisi bozulur.

---

# 9. Query Ownership Modeli

## 9.1. Query neyi temsil eder?

Query şunu temsil eder:
- dış kaynaktan gelen
- tekrar doğrulanması gerekebilen
- lifecycle taşıyan
- cache’lenebilir
- stale olabilen
veri kaynağını.

## 9.2. Query owner kimdir?

Tek bir dosya değil, bir ownership zinciri vardır:

- **Data access contract**: veri shape ve fetch mantığı
- **Query layer**: lifecycle ve cache
- **Feature orchestration**: ekran/feature bağlamında tüketim
- **Presentation**: lifecycle’a göre yüzey gösterimi

## 9.3. Query kararları neleri içerir?

- query key
- fetch function
- retry policy
- stale time
- refetch conditions
- error mapping strategy
- selection/transform policy
- enabled/disabled conditions

Bunlar rastgele component içinde dağılmamalıdır.

---

# 10. Query Key Politikası

## 10.1. Neden kritik?

Query key yanlış tasarlanırsa:
- cache çakışır
- yanlış veri gösterilir
- invalidation yanlış çalışır
- stale davranış anlaşılmaz olur

## 10.2. Kural

Query key’ler:
- deterministic olmalı
- data domain’ini açık ifade etmeli
- params/context ayrımını düzgün taşımalı
- gizli implicit state’e bağlı olmamalı

## 10.3. Query key neyi yansıtmalı?

- resource type
- relevant id/params
- scope/workspace/user bağlamı
- feature query intent

## 10.4. Zayıf davranışlar

- key içinde anlamsız string yığınları
- eksik param yüzünden çakışan cache
- user/workspace context’i gerektiği halde key’e koymamak
- query key’i screen-local rastgele üretmek

---

# 11. Fetch Function Politikası

## 11.1. Kural

Raw fetch çağrıları screen ve component içine dağılmayacaktır.

## 11.2. Doğru model

Fetch function:
- data access contract katmanında
- anlaşılır naming ile
- mapping ve error davranışı kontrollü
olarak yaşamalıdır.

## 11.3. Ne yapmamalıdır?

- UI feedback üretmek
- route navigation kararı vermek
- local component state değiştirmek
- toast basmak
- generic store mutate etmek

## 11.4. Neden?

Çünkü fetch function teknik veri erişimidir; feature UI orchestration değildir.

---

# 12. Data Mapping Politikası

## 12.1. En kritik ayrım

Backend response shape = domain-safe UI tüketim shape değildir.

## 12.2. Kural

Veri gerekiyorsa:
- parse edilir
- normalize edilir
- map edilir
- daha güvenli contract haline getirilir

Bu mapping rastgele component’lere dağıtılmaz.

## 12.3. Neden?

Aksi halde:
- her ekran payload’ı farklı yorumlar
- backend değişiklikleri UI’yı kaotik kırar
- aynı veri iki yerde iki şekilde görünür
- testing zorlaşır

## 12.4. Mapping nerede yaşamalı?

Bağlama göre:
- data access katmanı
- domain-safe mapping katmanı
- selected query adapter layer

Ama presentation içinde gömülü olmamalıdır.

---

# 13. Query Data’yı Store’a Kopyalama Yasağı

## 13.1. Kural

Query sonucunu generic client store’a kopyalamak canonical olarak yasaktır; yalnızca çok istisnai ve belgeli gerekçeyle mümkün olabilir.

## 13.2. Neden yasak?

Çünkü bu:
- duplicate truth üretir
- stale veri riskini yükseltir
- invalidation karmaşasını büyütür
- logout/user switch cleanup’i zorlaştırır
- feature debugging’i bozur

## 13.3. “Ama kolay oluyor” gerekçesi neden geçersiz?

Kolaylık burada gerçek çözüm değildir.  
Bu, teknik borcu kullanıcıdan saklayan yanlış kısa yol olur.

## 13.4. Meşru istisna örnekleri olabilir mi?

Çok nadir:
- user-driven local editing overlay
- offline draft composition
- optimistic local shadow state
Ama bu durumlarda bile bu veri “server cache kopyası” gibi tasarlanmamalıdır.

---

# 14. Mutation Modeli

## 14.1. Mutation nedir?

Server state’i değiştiren işlemdir:
- create
- update
- delete
- toggle
- submit
- reorder
- action/command benzeri side-effect’ler

## 14.2. Kural

Mutation, UI event handler içinde ad-hoc promise zinciri olarak değil; açık lifecycle mantığı ile düşünülmelidir.

## 14.3. Mutation lifecycle neyi kapsar?

- request start
- pending state
- success
- failure
- retry policy
- invalidation
- optimistic update (varsa)
- rollback (varsa)
- success feedback
- post-mutation navigation (gerekirse)

Bu lifecycle feature orchestration ile birlikte düşünülmelidir.

---

# 15. Mutation Sonrası Ne Yapılmalı?

Mutation sonrası temel seçenekler:

1. invalidate and refetch
2. cache patch / setQueryData
3. optimistic update + rollback
4. local UI-only result handling
5. hybrid yaklaşım

Bu seçeneklerden biri bilinçli seçilmelidir.  
“Bir şeyler olur” yaklaşımı kabul edilmez.

---

# 16. Invalidation Politikası

## 16.1. Neden çok kritik?

Birçok veri bug’ı doğrudan invalidation disiplininin eksikliğinden çıkar.

## 16.2. Kural

Her mutation için şu soru sorulmalıdır:

> Bu işlemden sonra hangi query sonuçları artık potansiyel olarak eskimiş sayılır?

Bu soru cevaplanmadan mutation tamamlanmış sayılmaz.

## 16.3. Invalidation nerede düşünülmeli?

- data access/query katmanında teknik bağ
- feature orchestration’da kullanım bağlamı
- UI’da sonucu gösteren feedback mantığı

## 16.4. Zayıf davranışlar

- mutation çalıştı, ama liste eski kaldı
- detail güncellendi, summary eski kaldı
- refetch gerektiği halde yapılmadı
- her mutation sonrası tüm cache’i kör temizlemek

---

# 17. Refetch Politikası

## 17.1. Kural

Refetch varsayılan otomatik sihir gibi düşünülmemelidir.  
Ne zaman ve neden tekrar veri alınacağı bağlamsal karardır.

## 17.2. Sorulması gerekenler

- ekran tekrar odaklanınca veri gerçekten stale olabilir mi?
- network reconnect sonrası yenilemek mantıklı mı?
- aynı session içinde veri sık değişiyor mu?
- kullanıcı manual refresh beklemeli mi?
- background refresh UX’i bozuyor mu?

## 17.3. Amaç

Hem aşırı veri çekmeyi hem de stale veriyle yaşamayı engellemek.

---

# 18. Retry Politikası

## 18.1. Kural

Retry kör biçimde global sabit sayı ile her işleme uygulanmamalıdır.

## 18.2. Neden?

Çünkü her failure aynı değildir:
- geçici network sorunu
- auth expired
- validation error
- permission error
- not found
- conflict
- server bug

Bunların hepsine aynı retry davranışı anlamsızdır.

## 18.3. Doğru yaklaşım

Retry policy:
- query vs mutation ayrımını bilmeli
- error class’ını dikkate almalı
- kullanıcı deneyimini bozmayacak şekilde çalışmalı
- sonsuz arka plan gürültüsü üretmemeli

## 18.4. Zayıf davranışlar

- validation error’a retry
- auth problemine sessiz retry
- destructive mutation’a otomatik retry
- kullanıcıyı bilgilendirmeden görünmez tekrarlayan istekler

---

# 19. Error Yaklaşımı

## 19.1. Teknik hata ≠ kullanıcı mesajı

Bu ayrım korunmalıdır.

### Teknik hata örnekleri
- HTTP timeout
- 401
- 409 conflict
- malformed payload
- network offline
- server internal error

### Kullanıcı-facing sonuçlar
- “oturum süren dolmuş olabilir”
- “değişiklik kaydedilemedi”
- “bu içerik artık güncel değil”
- “bağlantı sorunu oluştu, tekrar dene”

## 19.2. Kural

Ham error nesnesi veya backend message doğrudan kullanıcıya gösterilmez.

## 19.3. Error ownership zinciri

- raw transport error
- mapped application error
- feature meaning
- UI feedback surface

Her katman kendi işini yapmalıdır.

---

# 20. Loading Politikası

## 20.1. En büyük hata

Tüm loading’i tek “isLoading” boolean’ına indirgemektir.

## 20.2. Gerçekte hangi loading türleri vardır?

- initial loading
- background refresh
- mutation pending
- section-level loading
- pagination/loading more
- dependent query loading
- silent refresh
- optimistic local pending

## 20.3. Kural

Loading state’ler bağlama uygun ayrıştırılmalıdır.

## 20.4. Neden?

Çünkü:
- ilk açılış ile background refresh aynı UX değildir
- tek satır mutation pending ile tüm ekran bloklama aynı şey değildir
- section load ile page load aynı şey değildir

---

# 21. Empty State Politikası

## 21.1. Empty tek şey değildir

Aşağıdaki empty türleri ayrılmalıdır:
- first-use empty
- true no-data empty
- filtered empty
- access-limited empty
- post-delete empty

## 21.2. Query katmanı ile ilişkisi

Empty, teknik olarak “başarılı response ama içerik yok” olabilir.  
Bu, error değildir.  
UI’da doğru sınıflandırılmalıdır.

## 21.3. Kural

Query result boş diye rastgele generic “bir şey bulunamadı” metni kullanılmaz.  
Feature semantiği korunmalıdır.

---

# 22. Optimistic Update Politikası

## 22.1. Kural

Optimistic update varsayılan değil; kontrollü taktiktir.

## 22.2. Ne zaman güçlü adaydır?

- hızlı geri bildirim kullanıcı için çok değerliyse
- rollback mantığı nettirse
- veri modeli basitse
- çakışma riski düşükse
- kullanıcı yanılgısı riski kabul edilebilirse

## 22.3. Ne zaman zayıftır?

- karmaşık ilişkili veri yapıları
- yüksek conflict riski
- geri alma mantığı belirsiz işlemler
- finansal / kritik sonuç üreten aksiyonlar
- kullanıcıyı yanlış başarı hissine sokabilecek senaryolar

## 22.4. Kural

Optimistic update yapılıyorsa rollback stratejisi açık olmalıdır.

---

# 23. Background Refresh Politikası

## 23.1. Neden ayrı düşünülmeli?

Background refresh çoğu zaman:
- data’yı güncel tutar
ama yanlış uygulanırsa:
- flicker
- scroll reset
- context loss
- kullanıcı şaşkınlığı
üretir.

## 23.2. Kural

Background refresh UI’ı mümkün olduğunca gereksiz destabilize etmemelidir.

## 23.3. Doğru yaklaşım

- subtle refresh indicators
- layout collapse olmaması
- data replacement’in kontrollü yapılması
- stale while revalidate mantığının anlaşılır uygulanması

---

# 24. Pagination / Infinite Data Politikası

## 24.1. Kural

Pagination veya infinite query davranışı ad-hoc local arrays ile değil, resmi query lifecycle üzerinden ele alınmalıdır.

## 24.2. Düşünülmesi gerekenler

- next page ownership
- reset koşulları
- filter değişince pagination reset
- load more pending state
- end-of-list behavior
- cache lifetime

## 24.3. Zayıf davranışlar

- sayfa değişince eski pagination state’in yanlış kalması
- filtre değişince liste reset olmaması
- load more ile initial loading’i aynı göstermek

---

# 25. Enabled / Disabled Query Politikası

## 25.1. Kural

Her query her zaman otomatik çalışmamalıdır.

## 25.2. Soru

Bu query gerçekten şu anda gerekli mi?

## 25.3. Enabled koşulu hangi durumlarda önemlidir?

- eksik param varsa
- auth henüz hazır değilse
- feature capability yoksa
- dependent query zinciri varsa
- sheet/modal açılmadan veri gerekmiyorsa

## 25.4. Zayıf davranışlar

- param hazır değilken query çalıştırmak
- auth context yokken veri istemek
- görünmeyen yüzey için gereksiz background query yapmak

---

# 26. Query Selection / Transformation Politikası

## 26.1. Kural

Query sonucunun tüketiciye uygun shape’i hazırlanabilir.  
Ama bu dönüşümler rastgele component içine dağılmamalıdır.

## 26.2. Düşünülmesi gerekenler

- raw payload mı, normalized shape mi?
- domain-safe projection mı?
- UI’ya özel projection mı?
- aynı projection tekrar tekrar mı kullanılıyor?

## 26.3. Uyarı

Aşırı transformation katmanı da zararlıdır.  
Ama hiçbir mapping olmadan raw transport shape’i UI’ya yaymak daha büyük zarardır.

---

# 27. Query Cache Persistence Politikası

## 27.1. Kural

Query cache persistence varsayılan değildir.

## 27.2. Neden?

Çünkü persisted query cache:
- stale data
- wrong-user leak
- workspace confusion
- security/logging risk
üretebilir.

## 27.3. Persist düşünülürse sorulacak sorular

1. Offline requirement var mı?
2. User switch nasıl temizlenecek?
3. Hangi veri cache’lenebilir, hangisi edilemez?
4. Stale timeout nasıl işleyecek?
5. Sensitive content var mı?

Bu sorular net değilse persisted query cache açılmaz.

---

# 28. Security ve Logging Etkisi

## 28.1. Kural

Query/mutation katmanı:
- raw sensitive payload’ları log’a dökmemeli
- error nesnelerini kontrolsüz ifşa etmemeli
- auth/session taşıyan verileri yanlış katmana sızdırmamalı

## 28.2. Mutation error handling’de dikkat

Özellikle:
- validation errors
- auth/session errors
- permission errors
- server detail payload’ları
UI’ya ve log’a kontrollü aktarılmalıdır.

---

# 29. Observability Etkisi

## 29.1. Bu ADR neden observability ile ilgilidir?

Çünkü veri katmanı bozulduğunda kullanıcı çoğu zaman:
- loading sonsuz kaldı
- kaydet butonu çalışmadı
- veri eski görünüyor
- liste güncellenmedi
der.

Arka planda ise sorun:
- timeout
- retry storm
- invalidation eksikliği
- conflict
- parsing failure
olabilir.

## 29.2. Kural

Önemli query/mutation failure türleri gözlemlenebilir olmalıdır.

---

# 30. Cross-Platform Etkisi

## 30.1. Kural

TanStack Query seçimi web ve mobile için ortak server-state lifecycle mantığı sağlar.  
Bu, behavior parity için güçlü avantajdır.

## 30.2. Ne ortak olabilir?

- query ownership
- key strategy
- stale/invalidation prensipleri
- mutation lifecycle
- optimistic update policy
- error mapping modelinin büyük kısmı

## 30.3. Ne platforma göre farklılaşabilir?

- refresh triggers
- screen focus integration
- connectivity handling nuances
- UX presentation of loading/retry

Ama bu farklar ürün mantığını bozmaz.

---

# 31. Testing Üzerindeki Etki

Bu karar test stratejisinde şu sonuçları doğurur:

1. Query behavior integration test konusu olur
2. Mutation + invalidation + feedback akışı test konusu olur
3. Raw fetch function’lar ayrı testlenebilir olmalıdır
4. Error mapping ve retry davranışı testlenebilir olmalıdır
5. Server-state duplication anti-pattern’i review ve audit konusu olur

---

# 32. Repo Yapısı Üzerindeki Etki

Bu ADR şu topolojik sonuçları doğurur:

- raw API clients ile feature UI aynı yerde yaşamaz
- query contracts ve fetch logic kontrollü katmanda yaşar
- feature orchestration query consumption katmanında durur
- screen component’ler fetch owner olmaz
- query key, mapping ve invalidation politikaları dağınık helper’larda yaşamaz

Bu nedenle `21-repo-structure-spec.md` bu ADR ile hizalanmalıdır.

---

# 33. Contribution ve Review Üzerindeki Etki

Bu ADR sonrası contributor ve reviewer şu soruları sormalıdır:

1. Bu veri server-owned mu?
2. Neden query layer yerine store/local state kullanıldı?
3. Query key doğru scope’u taşıyor mu?
4. Mutation sonrası hangi data stale oldu?
5. Retry policy anlamlı mı?
6. Error mapping ham teknik detay mı sızdırıyor?
7. Loading türleri doğru ayrılmış mı?
8. Bu query gerçekten enabled olmalı mı?
9. Optimistic update gerekçeli mi?
10. Wrong-user / stale cache riski var mı?

---

# 34. Neden SWR Seçilmedi?

## 34.1. SWR kötü olduğu için değil

SWR güçlü olabilir.  
Ama bu boilerplate’in hedefleri için TanStack Query daha kapsayıcı ve güçlü seçimdir.

## 34.2. Nedenleri

- mutation lifecycle desteği
- invalidation esnekliği
- daha gelişmiş cache kontrolü
- geniş uygulama ölçeğinde daha güçlü policy alanı
- async veri davranışını daha kapsamlı ele alabilme

## 34.3. Sonuç

SWR reddedildi çünkü canonical ihtiyaç için TanStack Query daha tam karşılık veriyor.

---

# 35. Neden RTK Query Seçilmedi?

## 35.1. Gerekçe

RTK Query güçlü olabilir.  
Ama canonical state kararı Redux Toolkit yönüne gitmediği için RTK Query de doğal seçim değildir.

## 35.2. İkincil neden

Bu boilerplate store ve server-state ayrımını daha net tutmak istiyor.  
TanStack Query bu ayrımı daha doğal taşır.

---

# 36. Neden Custom Fetch + Manual Cache Seçilmedi?

Bu karar özellikle açık yazılmalıdır.

## 36.1. Neden reddedildi?

Çünkü bu yaklaşım şunları üretir:
- herkesin kendi retry mantığı
- herkesin kendi loading state modeli
- herkesin kendi invalidation kuralı
- herkesin kendi error parse davranışı
- cache ve stale kaosu

## 36.2. Sonuç

Bu yaklaşım canonical olarak reddedilmiştir.

---

# 37. Riskler

Bu kararın da riskleri vardır.

## 37.1. TanStack Query yanlış kullanılırsa query sprawl oluşabilir
Yani çok fazla dağınık query contract üretilebilir.

## 37.2. Invalidation policy iyi yazılmazsa stale bug’ları devam eder
Tool bunu sihirli çözmez.

## 37.3. Optimistic update yanlış kullanılırsa kullanıcı yanıltılabilir
Bu özellikle tehlikelidir.

## 37.4. Enabled/refetch policy düşünülmezse gereksiz ağ gürültüsü oluşabilir
Bu da hem UX hem performance sorunudur.

## 37.5. Query cache ownership belirsiz bırakılırsa team-level confusion oluşur
Bu yüzden dokümantasyon kritik kalır.

---

# 38. Risk Azaltma Önlemleri

Bu ADR’nin risklerini azaltmak için şu önlemler gerekir:

1. Query key conventions yazılmalı
2. Mutation/invalidation checklist oluşturulmalı
3. Server-state duplication review maddesi zorunlu olmalı
4. Data access contracts screen dışına çıkarılmalı
5. Error/loading taxonomy docs ile hizalanmalı
6. Observability stack async failures’ı görünür kılmalı
7. DoD mutation sonrası correctness kanıtı istemeli

---

# 39. Non-Goals

Bu ADR aşağıdakileri çözmez:

- exact HTTP client seçimi
- authentication transport specifics
- OpenAPI/codegen strategy
- offline queue detayları
- websocket/subscription strategy
- persisted query cache implementation
- every query key naming detail

Bu alanlar gerektiğinde ayrı ADR veya policy belgesi ister.

---

# 40. Uygulanma Sonuçları

Bu ADR kabul edildiğinde aşağıdaki sonuçlar doğar:

1. Server-owned veri generic client store'a kopyalanmaz
2. Fetch-first başlangıç meşrudur; query layer ancak complexity threshold aşıldığında devreye alınır
3. Query layer adopt edilirse TanStack Query canonical seçim olur
4. Mutation lifecycle explicit düşünülür
5. Invalidation resmi tasarım konusu olur
6. Loading/error/empty/retry state'ler chosen data lifecycle ile bağlanır
7. Screen ve component'ler raw fetch owner olmaktan çıkar
8. Data access contracts ve feature orchestration ayrımı güçlenir

---

# 41. Gelecekte Bu Karar Ne Zaman Yeniden Açılabilir?

Aşağıdaki durumlarda bu ADR yeniden değerlendirilebilir:

- TanStack Query, şartlı adoption modeline rağmen derived project ihtiyaçlarına sistematik olarak uymuyorsa
- ürün server-state modelinde köklü değişim olursa
- offline-first gereksinimler mevcut yaklaşımı sistematik olarak yetersiz bırakırsa
- platform bağımsız data modelinde başka bir yaklaşım belirgin üstünlük sunarsa

Bu seviyedeki değişiklik yeni ADR ve muhtemelen geniş refactor gerektirir.

---

# 42. Kararın Kısa Hükmü

> Data fetching, cache ve mutation modeli için canonical karar: server-owned async data generic client store'a kopyalanmaz; bootstrap default'u fetch-first + explicit data access contract olabilir; query/cache/mutation/offline karmaşıklık eşiği aşıldığında TanStack Query canonical query layer olarak devreye alınır; raw fetch component’lere dağılmaz; query key, stale, retry, invalidation ve mutation lifecycle açık ownership ile tasarlanır.

---

# 43. Onay Kriterleri

Bu ADR yeterli kabul edilir eğer:

1. TanStack Query'nin **şartlı adoption** kapsamı açıkça yazılmışsa
2. Server state’in generic client store dışında yönetileceği net tanımlanmışsa
3. Query key, fetch, mapping, mutation, invalidation, retry, error ve loading politikaları görünür kılınmışsa
4. Store duplication yasağı net yazılmışsa
5. SWR / RTK Query / custom fetch yaklaşımının neden canonical seçilmediği açıklanmışsa
6. Riskler ve mitigations görünürse
7. Bu karar implementasyon öncesi kilitlenmiş async data baseline olarak kullanılabilecek netlikteyse

---

# 44. TanStack Query Prefetching Stratejisi

Kullanıcı deneyimini iyileştirmek için veri önceden yükleme (prefetching) pattern’leri:

## 44.1. Web Prefetching

### Route Loader’da Prefetch
React Router loader fonksiyonu içinde `queryClient.prefetchQuery()` çağrılarak route render edilmeden önce veri hazır hale getirilir. Kullanıcı sayfaya geldiğinde veri zaten cache’dedir; loading state gösterilmez veya çok kısa sürer.

### Hover/Focus Prefetch
Link üzerine hover veya focus olduğunda `queryClient.prefetchQuery()` tetiklenir. Kullanıcı tıklamadan önce veri indirilmeye başlar. Bu pattern özellikle navigation menüleri ve liste öğeleri için etkilidir.

## 44.2. Mobile Prefetching

### Tab Geçişinde Prefetch
`onTabPress` handler’ında hedef tab’ın ana verisi prefetch edilir. Kullanıcı tab’a geçtiğinde veri hazırdır.

### Screen Focus’ta Prefetch
`useFocusEffect` hook’u içinde ekranın ihtiyaç duyduğu veri prefetch edilir. Bu pattern özellikle stack navigation’da geri dönüş (back) senaryosunda veri tazeliğini garanti eder.

## 44.3. Prefetch Kuralları

- **Stale prefetch:** Prefetch edilen veri `staleTime` süresi içindeyse tekrar fetch edilmez; cache’deki veri kullanılır
- **Öncelik sırası:** Kritik veri (user profile, permissions) > İkincil veri (notifications, feed) > Opsiyonel veri (recommendations, suggestions)
- **Bandwidth bilinçliliği:** Mobile’da aggressive prefetch yerine kullanıcı aksiyonuna bağlı selective prefetch tercih edilir
- **Gereksiz prefetch yasağı:** Kullanıcının hiçbir zaman ziyaret etmeyeceği ekranların verisi prefetch edilmez

---

# 45. Canonical staleTime Default’ları

Veri tipine göre staleTime ve gcTime (garbage collection time) default değerleri:

| Veri Tipi | staleTime | gcTime | Gerekçe |
|-----------|-----------|--------|---------|
| Kullanıcı profili | 5 dakika | 30 dakika | Nadir değişir, her ekranda kritik |
| Feed / Liste | 30 saniye | 5 dakika | Sık değişir, güncellik önemli |
| Static config (feature flags, app config) | 1 saat | 24 saat | Çok nadir değişir, deployment ile güncellenir |
| Bildirimler | 1 dakika | 10 dakika | Güncellik önemli, badge count ile ilişkili |
| Arama sonuçları | 0 (her zaman fresh) | 5 dakika | Her aramada yeni sonuç gerekli, cache yalnızca back navigation için |
| Dashboard metrikleri | 2 dakika | 15 dakika | Yaklaşık güncellik yeterli, exact real-time gerekmez |
| Referans verisi (ülke listesi, kategoriler) | 24 saat | 7 gün | Çok nadir değişir, app lifecycle boyunca sabit kalabilir |
| Form dropdown seçenekleri | 10 dakika | 1 saat | Nadir değişir, form açıldığında güncel olması yeterli |

## 45.1. Kullanım Kuralları

- Bu değerler **canonical default**’tır. Derived project ihtiyaca göre override edebilir, ancak override gerekçesi belgelenmelidir.
- `staleTime: 0` demek "her render’da refetch" demek değildir; yalnızca veri her zaman stale kabul edilir ve uygun koşullarda (window focus, component mount) refetch tetiklenir.
- `gcTime` her zaman `staleTime`’dan büyük olmalıdır. Cache’deki veri stale olsa bile gcTime süresi dolana kadar fiziksel olarak tutulur ve tekrar kullanılabilir.
- Infinite query’lerde (sayfalama) `staleTime` daha kısa tutulmalıdır çünkü yeni sayfa eklenmiş olabilir.

## 45.2. Query Key Convention ile Birlikte

staleTime ve gcTime değerleri query factory veya query options factory pattern’inde merkezi olarak tanımlanır. Feature’lar bu factory’den okur; her yerde ayrı ayrı yazılmaz.

---

# 46. Kısa Sonuç

Bu ADR’nin ana çıktısı şudur:

> Bu boilerplate’te server state generic app state değildir. Async veri davranışı fetch-first veya query-layer üzerinden yönetilebilir; fakat complexity threshold aşıldığında canonical yön TanStack Query’dir. Query cache, stale data, invalidation, retry ve mutation correctness bu katmanın resmi sorumluluğu olur; UI ve store bu veriyi duplicate ederek değil, doğru katmandan tüketerek çalışır.

---

# 47. React 19 Data API’leri ile İlişki

Bu bölüm, React 19.2 ile gelen veri ile ilgili API’lerin bu boilerplate’teki konumunu açıkça kaydeder.

## 47.1. React.use()

React 19 `use()` API’si, render sırasında Promise veya Context okumayı sağlar. Bir component içinde `const data = use(promise)` yazılarak Suspense ile entegre veri okuma yapılabilir.

**Bu boilerplate’teki pozisyonu:** Koşullu kabul.

TanStack Query’nin `useSuspenseQuery` hook’u zaten Suspense entegrasyonu sağlamaktadır ve bu boilerplate’te canonical yoldur (ADR-005 §22). Ancak `use()` aşağıdaki sınırlı senaryolarda kabul edilebilir:

- TanStack Query kapsamı dışında kalan basit, tek seferlik asenkron veri okumaları (ör: lazy-loaded konfigürasyon)
- Context okuma kısa yazımı: `use(MyContext)` yerine `useContext(MyContext)` — semantik fark yoktur, convenience syntax’tır

**Yasak kullanım:** `use()` ile doğrudan fetch çağrısı yapıp TanStack Query’yi bypass etmek. Server state ownership TanStack Query’dedir (ADR-005 §8); `use(fetch(...))` pattern’i cache, retry, invalidation ve deduplication mekanizmalarını kaybettirir.

## 47.2. React.cache()

React 19 `cache()` fonksiyonu, request-level memoization sağlar. Aynı argümanlarla çağrılan bir fonksiyonun sonucu tek bir render tree’de tekrar hesaplanmaz.

**Bu boilerplate’teki pozisyonu:** Sınırlı uygulama alanı.

`React.cache()` öncelikli olarak Server Components mimarisinde (RSC) request bazlı veri çoğaltmayı önlemek için tasarlanmıştır. SPA-first mimaride (ADR-001) Server Components kullanılmadığından, `cache()` fonksiyonunun ana kullanım senaryosu bu boilerplate’te geçerli değildir.

**Kabul edilebilir kullanım:** CPU-intensive saf hesaplamaların (ör: karmaşık veri dönüşümü, ağır filtreleme) render içinde memoize edilmesi. Ancak bu senaryolar çoğu zaman `useMemo` ile daha idiomatik şekilde çözülebilir.

## 47.3. useOptimistic

React 19 `useOptimistic` hook’u, bir state değerinin asenkron operasyon tamamlanmadan önce geçici olarak güncellenmesini sağlar.

**Bu boilerplate’teki pozisyonu:** Tamamlayıcı araç, alternatif değil.

TanStack Query’nin optimistic update mekanizması (ADR-005 §22) canonical yoldur. `onMutate` callback’inde cache snapshot alınır, optimistic veri yazılır, hata durumunda rollback yapılır. Bu mekanizma server state ile cache tutarlılığını garanti eder.

`useOptimistic` ise farklı bir katmanda çalışır: UI-local optimistic state yönetimi. Örneğin bir "beğen" butonunun anında görsel tepki vermesi gibi, cache güncellemesinden bağımsız, tamamen UI katmanında yaşayan geçici state’ler için kullanılabilir.

**Kural:** Server state’i etkileyen optimistic update → TanStack Query `onMutate`. Yalnızca UI feedback amaçlı geçici state → `useOptimistic` kabul edilebilir.

## 47.4. Suspense Stratejisi

React 19 ile Suspense olgunlaşmıştır. Bu boilerplate’te Suspense kullanımı şu şekildedir:

- **Data fetching Suspense:** `useSuspenseQuery` (TanStack Query) ile kullanılabilir ancak her query için zorunlu değildir. Progressive adoption önerilir.
- **Lazy loading Suspense:** `React.lazy()` ile code splitting zaten desteklenir ve önerilir.
- **Suspense boundary stratejisi:** Her route’un kendi `<Suspense fallback>` boundary’si olmalıdır. Nested boundary’ler dikkatli kullanılmalıdır — aşırı granüler Suspense "popcorn loading" efekti yaratır.

## 47.5. Bilinçli Karar Kaydı

> TanStack Query 5.x bu boilerplate’in canonical server state yönetim aracıdır. React 19’un `use()`, `cache()` ve `useOptimistic` API’leri TanStack Query’yi değiştirmez; sınırlı ve tamamlayıcı senaryolarda kullanılabilir. Server state ownership, cache yönetimi ve mutation lifecycle TanStack Query’nin sorumluluğundadır.
