Döküman Oluşturma Ana Talimatı

Proje kapsamına uygun tüm dökümanlar eksiksiz, derinlikli ve operasyonel olarak kullanılabilir biçimde hazırlanmalıdır. Hiçbir başlık, madde, alt madde, senaryo, akış, hata durumu, istisna, bağımlılık, teknik gerekçe veya kullanım detayı yüzeysel bırakılmamalıdır. Her içerik, konuyu bilmeyen birinin dahi okuyup anlayabileceği açıklıkta yazılmalıdır. Anlatım mümkün olan en açık, sistematik ve öğretici seviyede olmalı; hiçbir bölüm “kısaca geçilmiş”, “sonradan doldurulur”, “detayı implementasyonda düşünülür” mantığıyla bırakılmamalıdır.

Döküman üretimi sırasında proje mevcut boilerplate yapısına tam sadakat gösterilmelidir. Boilerplate mimarisi, standartları, klasör mantığı, isimlendirme düzeni, modüler yapı, karar alma biçimi, teknik sınırlar, kalite beklentileri ve geliştirme yaklaşımı korunmalıdır. Boilerplate ile çelişen, yapıyı bozan, gereksiz çeşitlilik oluşturan veya standart dışı yönlendirmeler üretilmemelidir. Yeni bir içerik ekleniyorsa bunun boilerplate içindeki yeri, amacı, diğer dökümanlarla ilişkisi ve neden gerekli olduğu açık biçimde belirtilmelidir.

Her döküman sadece başlık doldurmak için yazılmış görünmemelidir. İçerik gerçekten uygulanabilir, geliştiriciye yol gösterici, karar aldırıcı ve belirsizliği azaltıcı olmalıdır. Her bölümde mümkün olduğunda şu unsurlar yer almalıdır: amaç, kapsam, bağlam, neden, ne yapılacağı, ne yapılmayacağı, bağımlılıklar, ön koşullar, akışlar, kullanıcı senaryoları, edge-case’ler, hata durumları, teknik notlar, mimari etkiler, kabul kriterleri, riskler ve gerekiyorsa örnekler. Yani döküman, yalnızca açıklama yapan değil; aynı zamanda implementasyonu yöneten bir referans haline gelmelidir.

Senaryolar yazılırken sadece ideal akış ele alınmamalıdır. Normal akış, alternatif akış, bozulma durumları, kullanıcı hataları, veri eksikliği, senkronizasyon problemleri, offline durumlar, yetki problemleri, validasyon hataları, başarısız işlem geri dönüşleri ve sistemin bunlara nasıl tepki vereceği detaylı biçimde yazılmalıdır. Her önemli akışta “olabilecek sorunlar” ve “beklenen sistem davranışı” açıkça tanımlanmalıdır.

Dil kullanımında muğlak, yuvarlak ve içi boş ifadelerden kaçınılmalıdır. “Gerekirse”, “uygun şekilde”, “benzer biçimde”, “geliştirilebilir”, “düşünülebilir” gibi kaçamak ifadeler minimumda tutulmalıdır. Yerine somut, karar içeren ve uygulanabilir ifadeler kullanılmalıdır. Döküman okunduğunda ekipte kimsenin “burada tam olarak ne demek istiyor?” sorusunu sormaması gerekir.

Dökümanlar birbirinden kopuk hazırlanmamalıdır. Her yeni döküman; mevcut döküman seti, proje hedefi, kullanıcı deneyimi, teknik mimari ve ürün kapsamı ile tutarlı olmalıdır. Çelişki, tekrar, kapsam kayması, terminoloji dağınıklığı ve karar uyumsuzluğu oluşmamalıdır. Aynı kavram her dökümanda aynı anlamda ve aynı isimlendirme ile kullanılmalıdır.

Her döküman yeterince derin olmalıdır. İçerik kısa tutulmak için kalite düşürülmemelidir. Bir başlık detay gerektiriyorsa detaylandırılmalıdır. Özellikle ürün akışı, kullanıcı deneyimi, teknik mimari, veri modeli, validasyon mantığı, entegrasyonlar, roller/yetkiler, hata yönetimi, state yönetimi, senkronizasyon, bildirimler, ayarlar, ölçümleme, güvenlik ve bakım süreçleri asla yüzeysel geçilmemelidir.

Dökümanların yazımında temel kalite hedefi şudur:
Bir geliştirici, tasarımcı, ürün sorumlusu veya yeni dahil olan biri bu dökümanı okuduğunda ek açıklama istemeden sistemin nasıl çalışacağını, neden böyle tasarlandığını ve neyin nasıl uygulanacağını net biçimde anlayabilmelidir.

Bu nedenle her döküman:

açıklayıcı,
tam kapsamlı,
boilerplate’e sadık,
senaryo bazlı,
teknik olarak yönlendirici,
belirsizlik bırakmayan,
tekrar ve çelişki üretmeyen,
uygulanabilir derinlikte

olmalıdır.

Eksik bırakmak, özet geçmek, varsayım yapmak, kritik detayları atlamak veya yalnızca başlık doldurmak kabul edilemez. Amaç, gösteriş amaçlı döküman üretmek değil; gerçekten projeyi taşıyacak, implementasyon hatalarını azaltacak ve kalite standardını sabitleyecek döküman seti oluşturmaktır.