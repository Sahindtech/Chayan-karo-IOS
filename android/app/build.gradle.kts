plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ ADD THIS

}

// 🔥 CRITICAL FIX: Force older stable version of androidx.activity
// This overrides the 1.11.0 update that is causing the build failure.
configurations.all {
    resolutionStrategy {
        force("androidx.activity:activity:1.10.1")
        force("androidx.activity:activity-ktx:1.10.1")
    }
}

android {
    namespace = "com.chayankaroindia.app"
    
    // Note: Use 36 only if you have Android 16 (Baklava) Preview SDK installed.
    // If you get an error saying "SDK 36 not found", change this back to 35.
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.chayankaroindia.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36 // Matches your compileSdk
        versionCode = 35
        versionName = "1.0.2"
    }

    signingConfigs {
        create("release") {
            // Ensure this path is correct on your machine
            storeFile = file("C:/Users/himan/my-release-key.jks")
            storePassword = "Chayan2025!"
            keyAlias = "chayankaro_alias"
            keyPassword = "Chayan2025!"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // Temporarily set to FALSE to avoid ProGuard issues during debugging
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
// Add this at the very end of your file
dependencies {
coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}