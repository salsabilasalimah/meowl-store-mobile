# 1. Mengapa Membuat Model Dart untuk Data JSON?

Model Dart (seperti `ProductEntry` dan `Product` di `lib/models/`) diperlukan saat mengambil/mengirim data JSON untuk memastikan type safety, null-safety, dan maintainability kode.

- Type Safety: Model mendefinisikan tipe data eksplisit (misalnya `String name`, `int price`), sehingga compiler dapat mendeteksi kesalahan tipe saat compile-time, bukan runtime.
- Null-Safety: Dart memungkinkan penanganan null dengan aman menggunakan `?` (nullable) dan `required` untuk field wajib.
- Maintainability: Model memisahkan logika parsing dari UI, memudahkan refactoring dan testing.

Konsekuensi tanpa model (menggunakan `Map<String, dynamic>` langsung):
- Validasi Tipe: Tidak ada validasi tipe, sehingga akses field seperti `map['name']` bisa menyebabkan runtime error jika key tidak ada atau tipe salah.
- Null-Safety: Sulit menangani null values, berisiko `NullPointerException`.
- Maintainability: Kode parsing tersebar di berbagai tempat, sulit diubah jika struktur JSON berubah, dan error sulit dilacak.

Dalam kode ini, `ProductEntry.fromJson()` dan `toJson()` memastikan parsing yang aman dan terstruktur.

# 2. Fungsi Package http dan CookieRequest

Package http: Library dasar untuk melakukan HTTP requests (GET, POST, dll.) di Dart. Digunakan untuk komunikasi dengan server eksternal.

Package pbp_django_auth (CookieRequest): Wrapper atas http yang menambahkan dukungan session management melalui cookies. Otomatis menangani pengiriman dan penyimpanan cookies untuk mempertahankan state login.

Perbedaan peran:
- http: Generic HTTP client tanpa state management. Setiap request independen.
- CookieRequest: Mengelola session state, sehingga request berikutnya otomatis menyertakan cookies dari response sebelumnya. Ideal untuk autentikasi berbasis session.

Dalam aplikasi ini, `CookieRequest` digunakan untuk login/logout dan fetch data yang memerlukan autentikasi, sementara `http` digunakan untuk register (karena tidak memerlukan session).

# 3. Mengapa Instance CookieRequest Dibagikan ke Semua Komponen?

Instance `CookieRequest` dibagikan menggunakan `Provider` di `main.dart` agar semua komponen dapat mengakses session yang sama. Ini penting karena:

- Session Persistence: Login di satu screen mempertahankan state di seluruh app.
- State Management: Semua komponen dapat check `request.loggedIn` dan menggunakan cookies yang sama untuk request.
- Consistency: Mencegah multiple instances yang tidak sinkron.

Tanpa sharing, setiap screen akan membuat instance baru, kehilangan session, dan user harus login ulang di setiap navigasi.

# 4. Konfigurasi Konektivitas Flutter-Django

Untuk komunikasi Flutter-Django, diperlukan konfigurasi di sisi Django dan Android:

Django Side:
- ALLOWED_HOSTS: Tambahkan `'10.0.2.2'` karena Android emulator menggunakan IP ini sebagai localhost host. Tanpa ini, Django menolak request dari emulator.
- CORS: Aktifkan `django-cors-headers` dan izinkan origins dari Flutter (misalnya `http://10.0.2.2:8000` atau `http://localhost:8000`).
- SameSite/Cookie Settings: Konfigurasi cookie untuk cross-origin, biasanya `SameSite=None; Secure` untuk HTTPS.

Android Side:
- Internet Permission: Tambahkan `<uses-permission android:name="android.permission.INTERNET" />` di `AndroidManifest.xml` untuk mengizinkan akses jaringan.

Konsekuensi jika tidak dikonfigurasi:
- Tanpa ALLOWED_HOSTS: Django mengembalikan error 400 Bad Request.
- Tanpa CORS: Browser memblokir cross-origin requests, error CORS policy.
- Tanpa SameSite settings: Cookies tidak dikirim dalam cross-origin requests.
- Tanpa internet permission: App tidak bisa mengakses jaringan, request gagal.

Dalam kode, base URL dikonfigurasi di `lib/config.dart` dengan `http://127.0.0.1:8000` untuk web dan `http://10.0.2.2:8000` untuk emulator.

# 5. Mekanisme Pengiriman Data dari Input hingga Tampilan

Flow pengiriman data:
1. Input: User mengisi form (misalnya di `ProductFormPage` atau login form).
2. Form Submission: Data dikumpulkan dari `TextEditingController` dan dikirim via HTTP POST menggunakan `CookieRequest.post()`.
3. Django Processing: Django menerima data, validasi, simpan ke database, kembalikan response (JSON).
4. Response Handling: Flutter parse response menggunakan model (`ProductEntry.fromJson()`).
5. Display: Data ditampilkan di UI, misalnya di `ListView` di `ProductEntryListPage`.

Contoh di kode:
- Login: Input username/password → POST ke `/auth/login/` → Django authenticate → Return session cookie → Flutter navigate ke menu.
- Fetch products: GET ke `/product-entry/json/` → Parse JSON ke `List<ProductEntry>` → Display di `ListView`.

Error handling: Jika gagal, tampilkan `SnackBar` atau dialog error.

# 6. Mekanisme Autentikasi dari Login hingga Menu

Login:
1. User input username/password di `LoginPage`.
2. Flutter POST ke `Config.authLogin` dengan credentials.
3. Django authenticate, jika sukses return session cookie dan user info.
4. Flutter simpan cookie via `CookieRequest`, set `loggedIn = true`.
5. Navigate ke `MyHomePage` (menu).

Register:
1. Input username/password di `RegisterPage`.
2. POST ke `Config.authRegister` menggunakan `http` (bukan CookieRequest karena belum ada session).
3. Django buat user, return success message.
4. Flutter tampilkan snackbar, navigate back ke login.

Logout:
1. User tap logout di menu.
2. Flutter POST ke `Config.authLogout` menggunakan `CookieRequest`.
3. Django clear session, return success.
4. Flutter clear local state (`request.loggedIn = false`), navigate ke `LoginPage`.

Session Check: Di `main.dart`, `FutureBuilder` check `request.init()` dan `loggedIn` untuk auto-redirect ke menu jika sudah login.

# 7. Implementasi Step-by-Step

Step 1: Setup Project Structure
- Buat Flutter project dengan `flutter create meowl_store`.
- Struktur folder: `lib/models/`, `lib/screens/`, `lib/widgets/`, `lib/config.dart`.
- Tambah dependencies: `pbp_django_auth`, `provider`, `http`.

Step 2: Buat Models
- Definisikan `Product` dan `ProductEntry` classes dengan fields sesuai JSON dari Django.
- Implement `fromJson()` dan `toJson()` untuk parsing/serialization.
- Pastikan null-safety dengan `?` dan `required`.

Step 3: Setup Authentication
- Di `main.dart`, wrap app dengan `Provider<CookieRequest>`.
- Buat `LoginPage` dengan form username/password, POST ke Django login endpoint.
- Handle response: jika sukses, navigate ke menu; jika gagal, show error.
- Buat `RegisterPage` mirip, tapi gunakan `http` package.
- Di `HomePage`, gunakan `FutureBuilder` untuk check login status via `request.init()`.

Step 4: Implement Menu dan Navigation
- Buat `MyHomePage` dengan grid buttons untuk berbagai actions.
- Implement logout: POST ke logout endpoint, clear session, navigate ke login.
- Setup drawer dengan `LeftDrawer` untuk navigation consistency.

Step 5: Fetch dan Display Data
- Buat `ProductEntryListPage` dengan `FutureBuilder` untuk fetch data.
- Gunakan `request.get(Config.productEntryJson)` untuk GET request.
- Parse response ke `List<ProductEntry>` menggunakan `fromJson()`.
- Display di `ListView` dengan `ProductEntryCard`.
- Handle filtering (by user, category) di client-side.

Step 6: Form untuk Input Data
- Buat `ProductFormPage` dengan form fields.
- Collect data dari controllers, POST ke Django endpoint.
- Handle response dan feedback ke user.

Step 7: Error Handling dan UI Polish
- Tambah try-catch di semua network calls.
- Tampilkan loading indicators dan error messages.
- Pastikan responsive UI dengan proper padding/margins.

Step 8: Android Configuration
- Tambah internet permission di `AndroidManifest.xml`.
- Test dengan emulator menggunakan `10.0.2.2` sebagai base URL.

Step 9: Testing dan Debugging
- Test login/register flow end-to-end.
- Verify data fetching dan display.
- Debug CORS/Django configuration issues.