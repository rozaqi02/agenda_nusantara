# Agenda Nusantara – Panduan Setup Flutter

## 1. Install Flutter SDK

### Windows
1. Download Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Ekstrak ke `C:\flutter`
3. Tambahkan `C:\flutter\bin` ke PATH environment variable
4. Buka terminal, jalankan: `flutter doctor`

### macOS
```bash
brew install flutter
flutter doctor
```

### Linux (Ubuntu/Debian)
```bash
sudo snap install flutter --classic
flutter doctor
```

---

## 2. Install Android Studio
1. Download: https://developer.android.com/studio
2. Install Android SDK via SDK Manager
3. Buat emulator: Tools → AVD Manager → Create Virtual Device
   - Pilih Pixel 6, API Level 34

---

## 3. Buat Project Flutter Baru

```bash
flutter create agenda_nusantara
cd agenda_nusantara
```

---

## 4. Ganti `pubspec.yaml`

Buka file `pubspec.yaml` dan **ganti isinya** dengan file `pubspec.yaml` yang disediakan.

Setelah itu jalankan:
```bash
flutter pub get
```

---

## 5. Copy File Source Code

Struktur folder yang harus dibuat di dalam `lib/`:

```
lib/
├── main.dart
├── db/
│   └── db_helper.dart
├── models/
│   └── task_model.dart
└── pages/
    ├── login_page.dart
    ├── home_page.dart
    ├── add_task_page.dart
    ├── task_list_page.dart
    └── settings_page.dart
```

Buat folder `db`, `models`, dan `pages` di dalam `lib/`, lalu copy semua file yang disediakan.

---

## 6. Jalankan Aplikasi

```bash
# Pastikan emulator/device sudah terhubung
flutter devices

# Jalankan
flutter run
```

---

## Catatan Penting
- Username & password awal: **user / user**
- Data tersimpan di SQLite lokal ponsel
- Untuk build APK: `flutter build apk --release`
