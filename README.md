1. Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget.
= Widget tree dapat diibaratkan seperti pohon struktur dari tampilan aplikasi Flutter. Semua yang ada di layar teks, tombol, kolom, sampai kartu semuanya adalah widget yang tersusun secara bertingkat dari atas ke bawah.
Setiap widget bisa memiliki parent (induk) dan child (anak). Parent itu yang membungkus atau menaungi widget lain, sedangkan child adalah widget yang ada di dalamnya.
Misalnya di proyekku, Scaffold jadi parent dari Column, lalu Column punya beberapa child seperti InfoCard dan GridView. Hubungan ini penting karena posisi, tampilan, dan perilaku widget saling bergantung pada parent-nya.

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya.
-MaterialApp : Sebagai wadah utama aplikasi yang menerapkan gaya desain Material Design
-Scaffold : Menyediakan struktur dasar halaman seperti AppBar dan body
-AppBar : Bagian atas halaman yang menampilkan judul “Meowl Store”
-Center : Untuk menempatkan konten di tengah layar
-Column : Menyusun widget di dalamnya secara vertikal
-Padding : Memberi jarak di sekitar widget biar tampilannya nggak mepet
-GridViewcount : Menampilkan kumpulan tombol dalam bentuk grid (3 kolom)
-Card : Membungkus informasi seperti nama, NPM, dan kelas biar tampil lebih rapi
-Container : Untuk mengatur ukuran, padding, dan background widget
-Text : Menampilkan tulisan seperti nama, NPM, atau teks tombol
-Icon : Menampilkan ikon di setiap tombol
-Material dan InkWell : Biar tombol bisa diklik dan muncul efek ripple saat ditekan
-SnackBar : Menampilkan pesan sementara di bawah layar saat tombol ditekan

3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini sering digunakan sebagai widget root.
= MaterialApp berfungsi sebagai pembungkus utama dari seluruh aplikasi Flutter yang memakai gaya Material Design. Widget ini penting karena dapat mengatur hal-hal dasar seperti tema warna, navigasi antar halaman, dan tampilan bawaan aplikasi. Biasanya dijadikan widget root karena semua widget lain perlu berada di bawah struktur MaterialApp supaya bisa menggunakan gaya dan fitur desain material.

4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?
-StatelessWidget : Dipakai kalau tampilan tidak berubah selama aplikasi berjalan. Contohnya halaman yang hanya menampilkan teks statis atau tombol yang tidak mengubah data.
-StatefulWidget : Dipakai kalau tampilan bisa berubah karena interaksi pengguna atau data baru. Misalnya, form input, halaman dengan counter, atau tampilan yang tergantung kondisi tertentu.
Dalam proyek ini aku pakai StatelessWidget karena data seperti nama, NPM, dan tombolnya tidak berubah-ubah.

5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?
=BuildContext itu semacam penanda posisi widget di dalam widget tree. Penting karena digunakan Flutter untuk tahu di mana suatu widget berada, dan widget apa saja yang mengelilinginya.
Di metode build(), BuildContext dipakai supaya widget bisa mengakses data dari parent-nya, seperti tema warna atau Scaffold yang dibutuhkan untuk menampilkan SnackBar.

6. Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".
-Hot Reload : Digunakan untuk memperbarui tampilan aplikasi tanpa mengulang dari awal. Jadi pas kita ubah kode, hasilnya langsung muncul di emulator tanpa kehilangan state (misalnya posisi halaman atau inputan masih tetap).
-Hot Restart : Memulai ulang aplikasi dari awal. Semua state atau data sementara akan hilang, dan aplikasi kembali ke kondisi awal seperti baru dijalankan.

Hot reload lebih sering dipakai waktu proses ngoding biar lebih cepat lihat hasil perubahan.