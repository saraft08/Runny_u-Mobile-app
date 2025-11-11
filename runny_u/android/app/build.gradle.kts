plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.runny_u"
    compileSdk = 34  // Cambiado de flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Cambiado de flutter.ndkVersion

    compileOptions {
        // AGREGADO: Habilitar desugaring
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.runny_u"
        minSdk = 21  // Cambiado de flutter.minSdkVersion
        targetSdk = 34  // Cambiado de flutter.targetSdkVersion
        versionCode = 1  // Cambiado de flutter.versionCode
        versionName = "1.0"  // Cambiado de flutter.versionName
        
        // AGREGADO: Habilitar MultiDex
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// AGREGADO: Dependencia para desugaring
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}