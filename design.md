# Velo — Design Reference

> Dokumen ini adalah referensi desain untuk Claude Code.
> Baca ini sebelum menyentuh file apapun di `lib/core/`, `lib/shared/`, atau `lib/presentation/`.

---

## Identitas Visual

**Nama:** Velo
**Tagline:** Telemetry System
**Platform:** Android (primary), iOS (secondary)
**Orientasi:** Portrait only

### Konsep Desain
Terinspirasi dari **layar radar militer vintage** dan **instrument panel pesawat analog**.
Bukan estetika neon cyberpunk modern — lebih ke phosphor glow di atas obsidian gelap.
Setiap elemen harus terasa seperti instrumen presisi, bukan dekorasi.

---

## Color Palette — Phosphor Amber Obsidian

Semua warna didefinisikan di `lib/core/constants/app_colors.dart`.
**Jangan hardcode warna di luar file ini.**

```dart
// Backgrounds — dari paling gelap ke paling terang
bgPrimary  = Color(0xFF0A0B0D)  // scaffold, halaman utama
bgSurface  = Color(0xFF111318)  // bottom nav, cards sekunder
bgCard     = Color(0xFF181B22)  // cards, input fields
bgOverlay  = Color(0xCC0A0B0D) // overlay 80% opaque di atas kamera/map

// Accents
amber   = Color(0xFFFFB347)  // PRIMARY — tombol utama, angka penting, glow
cyan    = Color(0xFF4DFFD2)  // SECONDARY — data realtime, nilai metric
danger  = Color(0xFFFF6B35)  // stop, delete, error, G-Force dot
positive = Color(0xFF7FFF9E) // distance, success, start point

// Text
textPrimary   = Color(0xFFE8E4DC)  // judul, nilai penting
textSecondary = Color(0xFF7A7870)  // label, placeholder, icon
textDisabled  = Color(0xFF3E3D38)  // elemen nonaktif

// Borders
border       = Color(0xFF232530)  // semua border default (0.5px)
borderActive = Color(0xFF3A3C4A)  // border saat focused/active
```

### Penggunaan Warna yang Benar

| Konteks | Warna |
|---|---|
| Kecepatan saat ini (angka besar) | `textPrimary` |
| Avg speed, max speed, G-Force value | `cyan` |
| Jarak tempuh | `positive` |
| Kecepatan maks (highlight) | `amber` |
| Tombol utama (CTA) | `amber` background, `bgPrimary` text |
| Tombol stop/hapus | `danger` |
| G-Force dot di crosshair | `danger` |
| Jarum kompas (North) | `amber` |
| Route polyline di peta | `amber` |
| HUD telemetri di kamera | `amber` label, `textPrimary` value |

---

## Typography

Dua font family, keduanya didefinisikan di `lib/core/constants/app_text_styles.dart`.

### JetBrains Mono — untuk semua angka telemetri
```
monoHero  → 56px bold  — kecepatan utama di speedometer
monoLg    → 28px bold  — angka besar di cards
monoMd    → 20px bold  — metric cards, stat boxes
monoSm    → 13px       — nilai HUD, detail
monoXs    → 11px       — label sekunder, koordinat
monoXxs   → 10px       — HUD overlay di kamera
```

### Default Sans (system) — untuk UI labels
```
heading     → 22px w600  — judul halaman
subheading  → 16px w500  — section title
body        → 14px       — teks deskriptif, subtitle
label       → 11px w500  — uppercase label, kategori (letter-spacing 0.08)
```

**Aturan penting:**
- Semua angka sensor (speed, G-Force, bearing, coords) → **JetBrains Mono**
- `FontFeature.tabularFigures()` wajib aktif untuk semua angka agar tidak "melompat"
- Label kategori seperti `SPD`, `AVG`, `DST` → uppercase, letter-spacing

---

## Spacing & Radius

Dari `lib/core/constants/app_dimensions.dart`:

```
xs = 4     sm = 8     md = 16    lg = 24    xl = 32    xxl = 48

radiusSm = 6   radiusMd = 8   radiusLg = 12   radiusXl = 16

buttonHeight    = 50
inputHeight     = 52
appBarHeight    = 56
bottomNavHeight = 60
cardPadding     = 14
```

**Grid system:** 8px base unit. Semua spacing harus kelipatan 4 atau 8.

---

## Komponen UI

### VeloButton — `lib/shared/widgets/velo_button.dart`

```dart
// 4 variant:
VeloButtonStyle.primary  → amber fill, bgPrimary text
VeloButtonStyle.danger   → danger fill, white text
VeloButtonStyle.outline  → amber border, amber text
VeloButtonStyle.ghost    → amber text only

// Props:
VeloButton(
  label: 'MULAI',
  icon: Icons.play_arrow,   // opsional, muncul di kiri label
  style: VeloButtonStyle.primary,
  loading: false,            // ganti label dengan spinner
  width: double.infinity,    // default full width
  height: 50,
  onPressed: () {},
)
```

### VeloTextField — `lib/shared/widgets/shared_widgets.dart`

```dart
VeloTextField(
  label: 'Email',
  hint: 'nama@email.com',
  controller: emailCtrl,
  prefixIcon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
  obscure: false,
  validator: Validators.email,
)
```
- Border default: `border` (0.5px)
- Border focused: `amber` (1px)
- Fill: `bgCard`
- Password field otomatis dapat toggle visibility icon

### VeloCard — `lib/shared/widgets/shared_widgets.dart`

```dart
VeloCard(
  padding: EdgeInsets.all(14),
  borderColor: AppColors.border,  // opsional, override warna border
  onTap: () {},                   // opsional
  child: widget,
)
```

### ErrorBanner — `lib/shared/widgets/shared_widgets.dart`

```dart
ErrorBanner(message: controller.error.value)
// Tidak muncul jika message kosong
// Background: danger 10% opacity + border danger 30%
```

### LockedFeatureView — `lib/shared/widgets/shared_widgets.dart`

```dart
LockedFeatureView(
  title: 'Kamera Terkunci',
  message: 'Login diperlukan untuk menggunakan kamera.',
  onLogin: () => Get.toNamed(AppRoutes.login),
)
```
Digunakan di MapScreen dan CameraScreen ketika user belum login.

---

## Dashboard Widgets — `lib/presentation/dashboard/widgets/dashboard_widgets.dart`

### SpeedometerGauge
```dart
SpeedometerGauge(speed: 84.0, maxScale: 200, size: 220)
```
- Arc dari 150° sampai 390° (sweep 240°)
- Track: `border`
- Active arc: gradient `cyan → amber`
- Glow: amber 20% opacity, blur 8
- Tick marks: 25 titik, setiap 6 titik = major tick
- Angka: JetBrainsMono monoHero di tengah

### GForceIndicator
```dart
GForceIndicator(gX: 0.12, gY: -0.05, magnitude: 0.13, size: 120)
```
- Background circle: `bgCard`
- Border luar: `amber` 60% opacity
- Ring konsentris: 0.5G, 1.0G, 1.5G dengan warna `border`
- Crosshair: `textSecondary` 25% opacity
- Dot merah: bergerak sesuai X/Y axis, diklem ke dalam lingkaran
- Dot glow: `danger` 40% opacity, blur 6
- Range: ±2G (di luar range, dot stuck di tepi)
- Label di bawah: `magnitude G` dengan warna `amber`

### CompassIndicator
```dart
CompassIndicator(bearing: 127.0, size: 120)
```
- Dial **berputar** sesuai bearing (vehicle heading)
- Jarum **fixed** selalu menunjuk ke atas (North)
- Cardinal N/E/S/W di dalam dial, ikut berputar
- "N" berwarna `amber`, sisanya `textSecondary`
- Tick marks: setiap 10°, setiap 90° = major
- Label di bawah: `bearing°` dengan warna `cyan`

### MetricCard
```dart
MetricCard(
  label: 'RATA-RATA',
  value: '061',
  unit: 'km/h',
  valueColor: AppColors.cyan,  // default cyan
  locked: false,
)
```
- `locked: true` → tampilkan lock icon + label saja

### LiveBadge
```dart
LiveBadge(label: 'REC', color: AppColors.danger)
LiveBadge(label: 'DIJEDA', color: AppColors.amber)
```
- Dot blink dengan FadeTransition 0.8s repeat
- Dot glow sesuai warna

---

## Halaman & Layout

### Splash Screen
- Background: `bgPrimary`
- Logo "VELO" center: JetBrainsMono 64px bold, amber, letter-spacing 12
- Tagline "TELEMETRY SYSTEM": 11px, `textSecondary`, letter-spacing 6
- Scanline texture overlay: white 1.4% opacity, setiap 3px
- Versi di bottom: 11px, `textSecondary` 40% opacity
- Durasi: 2.2 detik, fade in 0.9 detik

### Login / Register
- Padding horizontal: 24px
- Logo kecil di atas
- Input fields gap: 14px
- Tombol utama full width
- "Lanjut tanpa login" sebagai ghost button
- Link daftar/masuk di paling bawah

### Dashboard
- Top bar: logo kiri, [badge + timer] tengah, [avatar/login] kanan
- Speedometer: center, size 220
- Metric row: 3 cards dengan ratio Expanded
- Compass + G-Force: 2 cards side by side
- Control buttons: full width atau 2 kolom (pause + stop)

### Camera
- Full screen hitam
- HUD top-left: dark bg 72% opacity + amber border 28%
- Compass top-right: size 86
- G-Force bottom-right: size 100
- Shutter center: 70px circle, amber border 2.5px
- Gradient hitam di bottom untuk shutter bar

### Map
- Full screen flutter_map
- Overlay card top: speed + distance di atas map
- Stats bar bottom: jarak + durasi + avg speed
- Back button top-left dalam container gelap

### History
- List cards dengan date block di kiri
- Date block: `bgSurface`, tanggal amber, bulan xs
- Stats: distance, max speed, duration dalam row

### Profile
- Avatar: initials dari nama, amber border, amber text
- Stats row: 3 box Expanded
- Menu list: icon + label + chevron
- Logout: `VeloButton.danger`

---

## Icons

Gunakan `Icons.*_outlined` untuk state inactive, `Icons.*` (filled) untuk active.

| Fungsi | Outlined | Filled |
|---|---|---|
| Dashboard | `Icons.speed_outlined` | `Icons.speed` |
| Map | `Icons.map_outlined` | `Icons.map` |
| Camera | `Icons.camera_alt_outlined` | `Icons.camera_alt` |
| History | `Icons.history_outlined` | `Icons.history` |
| Profile | `Icons.person_outline` | `Icons.person` |
| Settings | `Icons.settings_outlined` | `Icons.settings` |
| Lock | `Icons.lock_outline` | `Icons.lock` |

---

## Bottom Navigation

- Height: 60px + SafeArea bottom
- Border top: `border` 0.5px
- Background: `bgSurface`
- Active: `amber` (icon filled + label w600)
- Inactive: `textSecondary` (icon outlined)
- Lock badge: 12px circle di pojok kanan atas icon, `bgSurface` bg, lock icon 7px `textDisabled`
- 5 tab: Dashboard, Peta, Kamera, Riwayat, Profil/Masuk
- Tab Peta & Kamera: tampilkan lock badge jika belum login
- Tab terakhir: tampilkan "Masuk" + `Icons.login_outlined` jika guest

---

## Prinsip Desain — Hal yang JANGAN Dilakukan

1. **Jangan** hardcode warna di luar `app_colors.dart`
2. **Jangan** hardcode spacing selain kelipatan 4/8
3. **Jangan** pakai font selain JetBrainsMono untuk angka sensor
4. **Jangan** pakai `Colors.white` atau `Colors.black` langsung — pakai dari palette
5. **Jangan** buat elemen baru tanpa mengecek apakah sudah ada di `shared/widgets/`
6. **Jangan** pakai `ElevatedButton` langsung — selalu pakai `VeloButton`
7. **Jangan** pakai `TextFormField` langsung — selalu pakai `VeloTextField`
8. **Jangan** pakai radius > 16 (kecuali bottom sheet yang `radiusXl = 16`)
9. **Jangan** pakai shadow/elevation kecuali untuk glow effect sensor widgets
10. **Jangan** ubah warna palette tanpa alasan teknis yang jelas

---

## Bottom Sheet Pattern

```dart
showModalBottomSheet(
  context: context,
  backgroundColor: AppColors.bgSurface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (_) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      // Handle bar
      Container(width: 36, height: 4,
          decoration: BoxDecoration(color: AppColors.border,
              borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 16),
      // Content...
    ]),
  ),
);
```

---

## Alert Dialog Pattern

```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    backgroundColor: AppColors.bgCard,
    title: Text('Judul', style: AppTextStyles.subheading),
    content: Text('Pesan', style: AppTextStyles.body),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('Batal')),
      TextButton(
        onPressed: () {},
        child: Text('Konfirmasi',
            style: AppTextStyles.labelDanger.copyWith(fontSize: 14)),
      ),
    ],
  ),
);
```

---

## Snackbar Pattern

```dart
Get.snackbar(
  'Judul', 'Pesan',
  backgroundColor: AppColors.bgCard,
  colorText: AppColors.textPrimary,
  snackPosition: SnackPosition.BOTTOM,
  margin: const EdgeInsets.all(16),
  borderRadius: 8,
  duration: const Duration(seconds: 3),
);
```