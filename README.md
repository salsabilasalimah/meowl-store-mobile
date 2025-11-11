1. Jelaskan perbedaan antara `Navigator.push()` dan `Navigator.pushReplacement()` pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?

   `Navigator.push()` menambahkan halaman baru ke stack navigasi, sehingga pengguna bisa kembali ke halaman sebelumnya dengan tombol back. `Navigator.pushReplacement()` mengganti halaman saat ini dengan halaman baru, sehingga halaman sebelumnya dihapus dari stack dan pengguna tidak bisa kembali.

   Pada aplikasi Meowl Store, saya menggunakan `Navigator.push()` untuk navigasi ke halaman form dan list, karena pengguna mungkin ingin kembali ke halaman utama. `Navigator.pushReplacement()` bisa digunakan jika setelah login atau splash screen, di mana tidak perlu kembali.

2. Bagaimana kamu memanfaatkan hierarchy widget seperti `Scaffold`, `AppBar`, dan `Drawer` untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

   `Scaffold` digunakan sebagai struktur dasar setiap halaman, menyediakan `AppBar` untuk judul dan `Drawer` untuk navigasi. `AppBar` memberikan konsistensi di bagian atas dengan judul aplikasi. `Drawer` menyediakan menu navigasi yang bisa diakses dari semua halaman, memungkinkan pengguna berpindah antar halaman dengan mudah. Ini membuat aplikasi terasa terstruktur dan mudah dinavigasi.

3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti `Padding`, `SingleChildScrollView`, dan `ListView` saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

   `Padding` memberikan ruang di sekitar widget agar tidak terlalu mepet, meningkatkan keterbacaan dan estetika. `SingleChildScrollView` memungkinkan konten bisa di-scroll jika melebihi layar, seperti di halaman form yang panjang. `ListView` efisien untuk menampilkan daftar item, seperti di halaman list produk.

   Di aplikasi saya, `Padding` digunakan di sekitar form fields untuk jarak yang rapi. `SingleChildScrollView` membungkus form agar bisa di-scroll di perangkat kecil. `ListView` digunakan di halaman list produk untuk menampilkan produk dalam daftar yang bisa di-scroll.

4. Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

   Saya menggunakan `ThemeData` di `MaterialApp` dengan `primarySwatch: Colors.blue` untuk warna utama biru. `AppBar` dan tombol menggunakan warna biru untuk konsistensi. Drawer header juga biru. Ini menciptakan identitas visual yang solid, meskipun untuk brand toko mungkin perlu warna khusus, tapi di sini saya gunakan biru.