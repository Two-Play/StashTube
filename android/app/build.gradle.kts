import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (14.3): android/key.properties (git-ignored) names the
// upload keystore: storeFile, storePassword, keyAlias, keyPassword. CI writes
// it from repository secrets (.github/workflows/release.yml).
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) FileInputStream(file).use { load(it) }
}
val hasReleaseKey = keystoreProperties.getProperty("storeFile") != null

android {
    namespace = "io.github.two_play.stashappmobile"
    // 37: permission_handler_android (via flutter_chrome_cast) compiles against it.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Derived from github.com/Two-Play/StashAppMobile; fixed since the first release.
        applicationId = "io.github.two_play.stashappmobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
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
            // Without key.properties (e.g. a fresh checkout) release builds are
            // signed with the debug key, so `flutter run --release` still works;
            // they can't update a published release.
            signingConfig = signingConfigs.getByName(if (hasReleaseKey) "release" else "debug")
            if (!hasReleaseKey) logger.warn("No android/key.properties: release build signed with the debug key.")
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

dependencies {
    // AppCompat launch theme, required by local_auth's biometric dialog on Android 8 and below.
    implementation("androidx.appcompat:appcompat:1.7.0")
}
