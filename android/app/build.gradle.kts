plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Read Google Maps API key from android/local.properties (gitignored — contains google.maps.key=...)
val googleMapsKey: String = run {
    val f = rootProject.layout.projectDirectory.file("local.properties")
    if (!f.asFile.exists()) return@run ""
    val text = f.asFile.readText()
    val prefix = "google.maps.key="
    val idx = text.indexOf(prefix)
    if (idx < 0) return@run ""
    val start = idx + prefix.length
    val end = text.indexOf('\n', start)
    if (end >= 0) text.substring(start, end).trim() else text.substring(start).trim()
}

android {
    namespace = "com.example.velo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.velo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Generate string resource so AndroidManifest can reference it via @string/google_maps_key
        manifestPlaceholders["googleMapsKey"] = googleMapsKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
