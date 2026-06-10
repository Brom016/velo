lib/
├── main.dart                            ← Entry point, DI, routing
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart              ← Phosphor Amber Obsidian palette
│   │   ├── app_text_styles.dart         ← JetBrainsMono + UI typography
│   │   └── app_dimensions.dart          ← Spacing, radius, height constants
│   ├── theme/
│   │   └── app_theme.dart               ← ThemeData dark (full override)
│   ├── utils/
│   │   ├── formatters.dart              ← Duration, speed, distance, coords
│   │   └── validators.dart              ← Email, password, name, required
│   └── extensions/
│       └── context_ext.dart             ← screenWidth, showSnack
│
├── domain/
│   └── models/
│       ├── models.dart                  ← TripModel, UserModel
│       └── telemetry_data.dart          ← TelemetryData (sensor snapshot)
│
├── data/
│   ├── local/
│   │   ├── database/
│   │   │   └── app_database.dart        ← Drift DB + 4 tables (run build_runner)
│   │   └── daos/
│   │       └── daos.dart                ← TripsDao, RoutePointsDao, TelemetryDao, MediaDao
│   ├── remote/
│   │   └── firebase/
│   │       └── auth_service.dart        ← Firebase Auth + Firestore profile
│   └── repositories/                    ← (reserved for future repo pattern)
│
├── services/
│   ├── sensor_manager.dart              ← GPS + Accelerometer + Compass (GetxService)
│   └── trip_session_manager.dart        ← Start/Pause/Resume/Stop + batch write
│
├── presentation/
│   ├── splash/
│   │   └── splash_screen.dart           ← Scanline animation, auth redirect
│   ├── auth/
│   │   └── auth_screens.dart            ← LoginScreen + RegisterScreen + controllers
│   ├── home/
│   │   └── home_shell.dart              ← Bottom nav shell + HomeController
│   ├── dashboard/
│   │   ├── dashboard_screen.dart        ← Main telemetry screen + DashboardController
│   │   └── widgets/
│   │       └── dashboard_widgets.dart   ← SpeedometerGauge, GForceIndicator,
│   │                                       CompassIndicator, MetricCard, LiveBadge
│   ├── map/
│   │   └── map_screen.dart              ← flutter_map + route polyline + MapController
│   ├── camera/
│   │   └── camera_screen.dart           ← Camera preview + HUD overlay + CameraController
│   ├── history/
│   │   └── history_screen.dart          ← HistoryScreen + TripDetailScreen + controller
│   ├── profile/
│   │   └── profile_screen.dart          ← Profile stats + logout + ProfileController
│   └── settings/
│       └── settings_screen.dart         ← App settings + SharedPreferences + controller
│
└── shared/
    └── widgets/
        ├── velo_button.dart             ← VeloButton (primary, danger, outline, ghost)
        └── shared_widgets.dart          ← VeloTextField, VeloCard, LockedFeatureView, ErrorBanner