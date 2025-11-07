plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.chayankaroindia.app" // Match your package name
    compileSdk = 35 // Updated to 35 for plugin compatibility
    ndkVersion = "27.0.12077973" // Keep for plugin compatibility

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.chayankaroindia.app" // Permanent Play Store ID
        minSdk = flutter.minSdkVersion
        targetSdk = 35 // Update targetSdk to 35 as per compileSdk
        versionCode = 5 // Increment for each upload
        versionName = "1.0.2"
    }

    signingConfigs {
        create("release") {
            storeFile = file("C:/Users/himan/my-release-key.jks")
            storePassword = "Chayan2025!"  // Replace with your actual keystore password
            keyAlias = "chayankaro_alias"
            keyPassword = "Chayan2025!"        // Replace with your actual key password
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
