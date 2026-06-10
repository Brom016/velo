# Velo — System Reference

> Dokumen ini adalah referensi arsitektur untuk Claude Code.
> Baca ini sebelum menyentuh file apapun di `lib/services/`, `lib/data/`, `lib/domain/`, atau `lib/core/bindings/`.

---

## Overview

**Velo** adalah aplikasi mobile speedometer & telemetri kendaraan berbasis Flutter.
Prinsip utama: **local-first, offline-capable, no external server dependency** untuk fungsi inti.

- Data sensor & trip → **SQLite lokal** (drift)
- Auth & profil user → **Firebase** (opsional, hanya jika login)
- Map tiles → **CartoDB Dark Matter** via OpenStreetMap (no API key)
- Semua fitur dasar (speedometer, G-Force, compass, riwayat) **bisa dipakai tanpa internet**

---

## Struktur Folder Lengkap

```
velo/
├── android/
│   ├── app/
│   │   ├── build.gradle              ← minSdk 21, Firebase plugin, proguard
│   │   ├── proguard-rules.pro        ← keep rules untuk Flutter, Firebase, FFmpeg
│   │   └── src/main/
│   │       └── AndroidManifest.xml   ← semua permissions
│   ├── build.gradle                  ← google-services classpath
│   └── gradle.properties
│
├── assets/
│   ├── fonts/
│   │   ├── JetBrainsMono-Regular.ttf ← WAJIB ada
│   │   └── JetBrainsMono-Bold.ttf    ← WAJIB ada
│   └── images/                       ← reserved (app icon, dll)
│
├── lib/
│   ├── main.dart                     ← entry point, InitialBinding, routing
│   ├── firebase_options.dart         ← HARUS diisi dengan flutterfire configure
│   │
│   ├── core/
│   │   ├── bindings/
│   │   │   └── initial_binding.dart  ← DI terpusat, semua Get.put permanent
│   │   ├── constants/
│   │   │   ├── app_colors.dart       ← SATU-SATUNYA sumber warna
│   │   │   ├── app_dimensions.dart   ← spacing, radius, height constants
│   │   │   ├── app_routes.dart       ← SATU-SATUNYA sumber nama route
│   │   │   └── app_text_styles.dart  ← semua TextStyle
│   │   ├── extensions/
│   │   │   └── context_ext.dart      ← screenWidth, showSnack
│   │   ├── theme/
│   │   │   └── app_theme.dart        ← ThemeData dark
│   │   └── utils/
│   │       ├── formatters.dart       ← duration, speed, distance, coords, gforce
│   │       └── validators.dart       ← email, password, name, confirmPassword
│   │
│   ├── domain/
│   │   └── models/
│   │       ├── models.dart           ← TripModel, UserModel
│   │       └── telemetry_data.dart   ← TelemetryData (snapshot sensor)
│   │
│   ├── data/
│   │   ├── local/
│   │   │   ├── database/
│   │   │   │   ├── app_database.dart   ← Drift DB definition + 4 tables
│   │   │   │   └── app_database.g.dart ← GENERATED — jangan edit manual
│   │   │   └── daos/
│   │   │       ├── daos.dart           ← TripsDao, RoutePointsDao, TelemetryDao, MediaDao
│   │   │       └── daos.g.dart         ← GENERATED — jangan edit manual
│   │   ├── remote/
│   │   │   └── firebase/
│   │   │       ├── auth_service.dart    ← Firebase Auth + Firestore user CRUD
│   │   │       └── firestore_service.dart ← cloud stats sync
│   │   └── repositories/
│   │       ├── auth_repository.dart    ← wraps AuthService + profile cache
│   │       └── trip_repository.dart    ← semua operasi trip, route, telemetry, media
│   │
│   ├── services/
│   │   ├── sensor_manager.dart        ← GPS + Accelerometer + Compass (GetxService)
│   │   └── trip_session_manager.dart  ← Start/Pause/Resume/Stop + batch write
│   │
│   ├── presentation/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── auth/
│   │   │   ├── auth_screens.dart              ← legacy combined file (bisa dihapus)
│   │   │   ├── login/
│   │   │   │   ├── login_controller.dart
│   │   │   │   └── login_screen.dart
│   │   │   └── register/
│   │   │       ├── register_controller.dart
│   │   │       └── register_screen.dart
│   │   ├── home/
│   │   │   ├── home_controller.dart
│   │   │   └── home_shell.dart               ← IndexedStack + bottom nav
│   │   ├── dashboard/
│   │   │   ├── dashboard_controller.dart
│   │   │   ├── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       └── dashboard_widgets.dart    ← SpeedometerGauge, GForceIndicator,
│   │   │                                        CompassIndicator, MetricCard, LiveBadge
│   │   ├── map/
│   │   │   ├── map_controller.dart
│   │   │   └── map_screen.dart
│   │   ├── camera/
│   │   │   ├── camera_controller.dart        ← OverlayConfig, photo/video methods
│   │   │   └── camera_screen.dart            ← preview + HUD + overlays
│   │   ├── history/
│   │   │   ├── history_controller.dart
│   │   │   ├── history_screen.dart
│   │   │   └── trip_detail_screen.dart       ← stats + mini map + media gallery
│   │   ├── profile/
│   │   │   ├── profile_controller.dart
│   │   │   └── profile_screen.dart
│   │   └── settings/
│   │       ├── settings_controller.dart      ← SharedPreferences wrapper
│   │       └── settings_screen.dart
│   │
│   └── shared/
│       └── widgets/
│           ├── velo_button.dart              ← VeloButton (4 styles)
│           └── shared_widgets.dart           ← VeloTextField, VeloCard,
│                                                LockedFeatureView, ErrorBanner
│
├── design.md    ← UI/UX reference
├── system.md    ← arsitektur reference (file ini)
├── pubspec.yaml
├── README.md    ← setup guide
└── .gitignore
```

---

## Dependency Injection

Menggunakan **GetX** `Get.put()` dengan `permanent: true` untuk services.
Semua DI terpusat di `lib/core/bindings/initial_binding.dart`.

```
InitialBinding.dependencies()
  ├── AppDatabase          (permanent)  ← SQLite connection
  ├── AuthService          (permanent)  ← Firebase Auth
  ├── AuthRepository       (permanent)  ← wraps AuthService
  ├── TripRepository       (permanent)  ← wraps DB DAOs
  ├── SensorManager        (permanent)  ← sensor streams
  └── TripSessionManager   (permanent)  ← trip lifecycle
```

**Aturan DI:**
- Controller screen di-`Get.put()` di dalam `build()` method screen-nya sendiri
- Services di-`Get.find()` dari controller, tidak dari screen
- Jangan buat `Get.put()` baru untuk service yang sudah ada di InitialBinding

---

## Routing

Semua nama route ada di `lib/core/constants/app_routes.dart`.
**Jangan hardcode string route di luar file itu.**

```
AppRoutes.splash      → /splash    → SplashScreen
AppRoutes.login       → /login     → LoginScreen
AppRoutes.register    → /register  → RegisterScreen
AppRoutes.home        → /home      → HomeShell
AppRoutes.settings    → /settings  → SettingsScreen
AppRoutes.tripDetail  → /trip-detail → TripDetailScreen (args: int tripId)
```

**Navigasi yang benar:**
```dart
// Navigasi biasa
Get.toNamed(AppRoutes.login);

// Ganti seluruh stack (setelah login/logout)
Get.offAllNamed(AppRoutes.home);

// Dengan argument
Get.toNamed(AppRoutes.tripDetail, arguments: trip.id);

// Ambil argument di destination
final id = Get.arguments as int;
```

---

## Auth Flow

```
Splash (2.2s)
    │
    ├── auth.isLoggedIn == true  ──→  /home (HomeShell)
    └── auth.isLoggedIn == false ──→  /login
                                          │
                                 ┌────────┴────────┐
                                 │                 │
                              Login             Register
                                 │                 │
                                 └────────┬────────┘
                                          │
                                    /home (HomeShell)
                                          │
                               ┌──────────┤  (IndexedStack)
                               │          │
                    Guest mode │    Tab 0: Dashboard ← always accessible
                               │    Tab 1: Map       ← require login
                               │    Tab 2: Camera    ← require login
                               │    Tab 3: History   ← always accessible
                               │    Tab 4: Profile   ← jika login
                               │           (Masuk)   ← jika guest
                               │
                    Jika guest mencoba Tab 1 atau 2:
                    → redirect ke /login
                    → setelah login, kembali ke HomeShell
```

**Guest mode:** user bisa pakai Dashboard dan History tanpa login.
Data trip guest disimpan lokal dengan `userId = 'guest'`.

---

## Database Schema (SQLite via Drift)

File: `lib/data/local/database/app_database.dart`

```
trips
├── id           INTEGER PK autoincrement
├── userId       TEXT              ← Firebase UID atau 'guest'
├── startTime    DATETIME
├── endTime      DATETIME nullable
├── totalDistanceKm REAL default 0
├── maxSpeedKmh  REAL default 0
├── avgSpeedKmh  REAL default 0
├── maxGForce    REAL default 0
└── status       TEXT default 'active'  ← 'active'|'paused'|'finished'

route_points
├── id           INTEGER PK autoincrement
├── tripId       INTEGER FK → trips.id
├── latitude     REAL
├── longitude    REAL
├── speedKmh     REAL default 0
└── recordedAt   DATETIME

telemetry_logs                          ← write batching setiap 1.5 detik
├── id           INTEGER PK autoincrement
├── tripId       INTEGER FK → trips.id
├── speedKmh     REAL
├── avgSpeedKmh  REAL
├── maxSpeedKmh  REAL
├── distanceKm   REAL
├── gForceX      REAL  ← lateral G
├── gForceY      REAL  ← longitudinal G
├── gForceMagnitude REAL
├── compassBearing  REAL
├── latitude     REAL nullable
├── longitude    REAL nullable
└── recordedAt   DATETIME

media_files
├── id           INTEGER PK autoincrement
├── tripId       INTEGER FK → trips.id
├── type         TEXT      ← 'photo' | 'video'
├── filePath     TEXT
├── thumbnailPath TEXT nullable
├── overlayConfig TEXT nullable  ← JSON snapshot overlay settings saat capture
└── capturedAt   DATETIME
```

**Strategi write:**
- `route_points` → insert per GPS update (~2-3 detik sekali)
- `telemetry_logs` → batch insert setiap **1.5 detik** via `TelemetryDao.insertBatch()`
- `trips` → update saat pause/stop saja (bukan realtime)
- `media_files` → insert saat foto/video disimpan

---

## SensorManager (`lib/services/sensor_manager.dart`)

GetxService permanent. Tidak boleh di-instantiate lebih dari sekali.

```
SensorManager
├── telemetry: Rx<TelemetryData>   ← observable, update ~500ms
├── isRunning: RxBool
│
├── start()   → request permission → mulai semua stream
├── pause()   → pause semua subscription
├── resume()  → resume semua subscription
├── stop()    → cancel semua subscription + reset accumulators
│
├── GPS Stream (geolocator)
│   ├── LocationAccuracy.high
│   ├── distanceFilter: 2 meter
│   ├── → speed (km/h), coordinates, distance accumulation
│   └── → update avgSpeed, maxSpeed
│
├── Accelerometer Stream (sensors_plus)
│   ├── samplingPeriod: 100ms
│   ├── Low-pass filter: alpha = 0.12
│   ├── → gForceX (lateral), gForceY (longitudinal)
│   └── → gForceMagnitude = sqrt(x² + y²)
│
└── Compass Stream (flutter_compass)
    └── → compassBearing: 0–360°, 0 = North
```

**Low-pass filter formula:**
```dart
_lpX = alpha * rawX + (1 - alpha) * _lpX;  // alpha = 0.12
gForceX = _lpX / 9.81;
```
Nilai alpha kecil = lebih smooth, lebih lambat respons.
Nilai alpha besar = lebih responsif, lebih noisy.

---

## TripSessionManager (`lib/services/trip_session_manager.dart`)

GetxService permanent. Mengorkestrasi SensorManager + database writes.

```
TripSessionManager
├── status: Rx<TripStatus>   ← idle | active | paused | finished
├── currentId: Rxn<int>      ← ID trip yang sedang berjalan
├── elapsed: Rx<Duration>    ← timer trip
│
├── start()
│   ├── insert row ke trips table
│   ├── set currentId
│   ├── panggil sensors.start()
│   └── mulai _batchTimer (1500ms) + _clockTimer (1s)
│
├── pause()
│   ├── stop timers
│   ├── sensors.pause()
│   ├── flush pending batch
│   └── update status = 'paused'
│
├── resume()
│   ├── sensors.resume()
│   ├── restart timers
│   └── update status = 'active'
│
└── stop()
    ├── stop timers
    ├── flush batch
    ├── update trips row (endTime, stats)
    ├── sensors.stop()
    ├── reset currentId + elapsed
    └── status = idle (setelah 800ms delay)
```

**Batch write cycle (setiap 1500ms):**
1. `_enqueue()` → buat `TelemetryLogsCompanion` dari `sensors.telemetry.value`
2. Jika ada lat/lng → insert ke `route_points` juga
3. `_flush()` → `telemetryDao.insertBatch(_pending)`

---

## TripRepository (`lib/data/repositories/trip_repository.dart`)

Single point of access untuk semua operasi database trip-related.
Controller TIDAK boleh akses DAO langsung — harus lewat repository.

```dart
// Trips
createTrip() → int (id)
finishTrip(id, dist, maxSpeed, avgSpeed, maxGForce)
updateTripStatus(id, status)
getMyTrips() → List<TripRow>
getTripById(id) → TripRow?
deleteTrip(id) → hapus cascade (route, telemetry, media)

// Route
addRoutePoint(tripId, lat, lng, speedKmh)
getRoutePoints(tripId) → List<RoutePointRow>

// Telemetry
saveTelemetryBatch(entries)
getTelemetryLogs(tripId) → List<TelemetryLogRow>

// Media
addMedia(tripId, type, filePath, ...)
getMediaByTrip(tripId) → List<MediaRow>
deleteMedia(id)
```

---

## AuthRepository (`lib/data/repositories/auth_repository.dart`)

Wraps AuthService dengan in-memory profile cache.

```dart
isLoggedIn → bool
uid        → String  ← Firebase UID atau 'guest'

register(name, email, password) → UserModel
login(email, password)          → UserModel
logout()                        → void + clear cache
getProfile(forceRefresh?)       → UserModel?
updateProfile(user)             → void
```

---

## State Management Pattern

Menggunakan **GetX** reactive state.

```dart
// Di controller
final loading = false.obs;     // RxBool
final error   = ''.obs;        // RxString
final trips   = <TripRow>[].obs; // RxList

// Di screen (dalam Obx)
Obx(() => loading.value
    ? CircularProgressIndicator()
    : ListView(...))

// Update
loading.value = true;
trips.value = await repo.getMyTrips();
```

**Aturan:**
- Satu controller per screen, di-`Get.put()` di `build()` method screen
- Controller tidak boleh import screen
- Screen tidak boleh akses repository/service langsung, harus lewat controller
- Services (SensorManager, TripSessionManager) diakses controller via `Get.find()`

---

## Overlay Settings (Camera)

Tersimpan di `CameraController` sebagai `OverlayConfig` object (in-memory, tidak persist).
Untuk persist antar sesi → simpan ke SharedPreferences (TODO).

```dart
class OverlayConfig {
  bool speed = true;     // SPD
  bool avgSpeed = true;  // AVG
  bool maxSpeed = true;  // MAX
  bool distance = true;  // DST
  bool gps = true;       // LAT, LNG
  bool datetime = true;  // TIME
  bool gforce = true;    // G
  bool maxGforce = false; // MXG
  bool compass = true;   // CompasIndicator widget
  bool miniMap = false;  // MiniMap widget (reserved)
}
```

---

## Settings (SharedPreferences)

Dikelola oleh `SettingsController`.

| Key | Type | Default | Keterangan |
|---|---|---|---|
| `speed_unit` | String | `'kmh'` | `'kmh'` atau `'mph'` |
| `gps_interval` | int | `2` | seconds: 2, 3, atau 5 |
| `batch_interval` | int | `1500` | ms: 1000, 1500, 2000 |
| `keep_screen_on` | bool | `true` | WakeLock saat recording |
| `vibration` | bool | `true` | Haptic feedback |

---

## Firebase Config

File: `lib/firebase_options.dart`

**WAJIB diisi** dengan output dari:
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_PROJECT_ID
```

**Yang diaktifkan di Firebase Console:**
- Authentication → Email/Password provider
- Firestore Database → mode production
- (Opsional) Storage untuk foto/video sync

**Firestore collections:**
```
users/{uid}
├── uid: string
├── name: string
├── email: string
├── photoUrl: string?
├── createdAt: string (ISO8601)
└── stats: {
    totalTrips: number,
    totalDistanceKm: number,
    totalDurationSeconds: number,
    updatedAt: timestamp
  }
```

---

## Map Configuration

Tile provider: **CartoDB Dark Matter** (gratis, no API key)
```
URL: https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png
Subdomains: ['a', 'b', 'c', 'd']
userAgentPackageName: 'com.velo.app'
```

Default center (jika GPS belum tersedia): Semarang, Jawa Tengah
```dart
const LatLng(-7.005, 110.438)
```

---

## Video Recording Strategy (Dual-Track)

Implementasi di `CameraController` (sebagian TODO):

```
Track 1: Hardware encoder (camera package)
└── merekam video bersih tanpa overlay

Track 2: Telemetry logger (TripSessionManager)
└── simpan data sensor tiap 500ms ke List<TelemetrySnapshot>

Pasca recording:
1. Generate ASS subtitle file dari telemetry snapshots
2. FFmpeg (ultrafast preset) composite subtitle ke video
3. Simpan ke local storage + insert ke media_files table
4. Hapus file temporary
```

FFmpeg command (referensi):
```bash
ffmpeg -i input.mp4 -vf "ass=overlay.ass" -preset ultrafast output.mp4
```

---

## Build & Release

```bash
# Debug
flutter run

# Generate drift files (WAJIB setelah edit app_database.dart atau daos.dart)
dart run build_runner build --delete-conflicting-outputs

# Release APK
flutter build apk --release

# Release AAB (Google Play)
flutter build appbundle --release
```

**minSdk:** 21 (Android 5.0 Lollipop)
**targetSdk:** sesuai flutter.targetSdkVersion
**Package name:** `com.velo.app`

---

## File yang TIDAK Boleh Diedit Manual

```
lib/data/local/database/app_database.g.dart   ← generated by drift
lib/data/local/daos/daos.g.dart               ← generated by drift
```

Jika perlu mengubah schema atau DAO, edit file `.dart`-nya, lalu jalankan:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Konvensi Penamaan

| Jenis | Konvensi | Contoh |
|---|---|---|
| File | snake_case | `trip_detail_screen.dart` |
| Class | PascalCase | `TripDetailScreen` |
| Variable | camelCase | `totalDistKm` |
| Constant | camelCase | `AppColors.amber` |
| Route constant | camelCase | `AppRoutes.tripDetail` |
| Observable | `.obs` suffix | `loading.obs` |
| Controller | `XxxController` | `HistoryController` |
| Screen | `XxxScreen` | `HistoryScreen` |
| Service | `XxxManager` atau `XxxService` | `SensorManager` |
| Repository | `XxxRepository` | `TripRepository` |

---

## Dependency Versions (pubspec.yaml)

```yaml
get: ^4.6.6
geolocator: ^13.0.0
sensors_plus: ^6.1.0
flutter_compass: ^0.8.0
flutter_map: ^7.0.1
latlong2: ^0.9.0
drift: ^2.18.0
sqlite3_flutter_libs: ^0.5.0
path_provider: ^2.1.3
path: ^1.9.0
camera: ^0.11.0
ffmpeg_kit_flutter_min: ^6.0.3
firebase_core: ^3.3.0
firebase_auth: ^5.1.0
cloud_firestore: ^5.2.0
shared_preferences: ^2.3.2
intl: ^0.19.0
uuid: ^4.4.2
```

---

## Known TODOs (Belum Diimplementasi)

- [ ] `CameraController.capturePhoto()` — photo capture + canvas compositing overlay
- [ ] `CameraController.startVideoRecording()` — dual-track recording
- [ ] `CameraController.stopVideoRecording()` — FFmpeg overlay compositing
- [ ] Persist overlay settings ke SharedPreferences
- [ ] WakeLock implementation (keep screen on saat recording)
- [ ] iOS permissions di `Info.plist`
- [ ] Upload foto/video ke Firebase Storage (opsional)
- [ ] Gallery screen per perjalanan (full implementation)
- [ ] `FirestoreService.updateStats()` dipanggil setelah trip selesai
- [ ] Mock location support untuk GPS indoor testing
- [ ] Profile photo upload