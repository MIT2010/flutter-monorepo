import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// RELEASE.md "Android signing" / `melos run build:*`: `key.properties` is
// gitignored and project-specific — `key.properties.example` is the
// committed template. Absent entirely on a fresh clone, which is the
// normal state until a real project generates its own keystore.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasRealSigningConfig = keystorePropertiesFile.exists()
if (hasRealSigningConfig) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Found by actually running `melos run build:dev` for the first time in
    // this repo's history (RELEASE.md) — AGP disables the `resValue()` build
    // feature by default for build-time performance, so the per-flavor
    // `resValue(type = "string", name = "app_name", ...)` calls below (§30's
    // flavor app-name badges) fail the build with "Product Flavor ... contains
    // custom resource values, but the feature is disabled" the moment
    // anything actually tries to build a release artifact, not just `flutter
    // run`. Pre-existing since the flavors were added; nobody had run a real
    // build off this config until now.
    buildFeatures {
        resValues = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // §30: dev / staging / prod, each with its own applicationId suffix and
    // app name badge, driven by `flutter run/build --flavor <name>`.
    // https://docs.flutter.dev/deployment/flavors
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue(type = "string", name = "app_name", value = "Starter Kit (Dev)")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue(type = "string", name = "app_name", value = "Starter Kit (Staging)")
        }
        create("prod") {
            dimension = "environment"
            resValue(type = "string", name = "app_name", value = "Starter Kit")
        }
    }

    signingConfigs {
        if (hasRealSigningConfig) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Real signing when `key.properties` exists (RELEASE.md). Falls
            // back to the debug key otherwise, same as before this file was
            // touched — `flutter run --release` still works with no setup
            // for quick local testing. `melos run build:*` (which is what
            // actually produces a distributable artifact) does NOT rely on
            // this fallback silently producing a wrongly-signed release:
            // `tool/verify_signing.dart` refuses to even invoke this build
            // when `hasRealSigningConfig` is false — see that script and
            // RELEASE.md "Android signing" for the loud-failure half of
            // this story, which lives outside Gradle on purpose (Gradle
            // itself has no clean way to tell "flutter run --release" apart
            // from "flutter build appbundle --release" to fail only one).
            signingConfig = if (hasRealSigningConfig) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
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
