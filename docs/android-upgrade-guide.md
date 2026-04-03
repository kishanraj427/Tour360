# Android & Java Upgrade Guide for Old Flutter Projects

This guide documents all the changes made to upgrade the Tour360 project's Android build configuration to work with **Flutter 3.41.0** and modern toolchains. Apply these steps to any older Flutter project that fails to build.

---

## Prerequisites

- **Java 17** installed and available
- **Flutter 3.41.0+** (or your target Flutter version)
- **Android SDK 36** installed via Android Studio or `sdkmanager`

### Install Java 17 (if not installed)

```bash
sudo apt install openjdk-17-jdk
```

### Set Java 17 as default

```bash
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac
```

### Export JAVA_HOME before building

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

---

## Step-by-Step Changes

### 1. Upgrade Gradle Wrapper

**File:** `android/gradle/wrapper/gradle-wrapper.properties`

```diff
- distributionUrl=https\://services.gradle.org/distributions/gradle-7.6.3-all.zip
+ distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip
```

> Gradle 8.9 is required by AGP 8.7.0.

---

### 2. Upgrade Android Gradle Plugin (AGP) & Kotlin

**File:** `android/settings.gradle`

```diff
  plugins {
      id "dev.flutter.flutter-plugin-loader" version "1.0.0"
-     id "com.android.application" version "7.3.0" apply false
-     id "org.jetbrains.kotlin.android" version "1.7.10" apply false
+     id "com.android.application" version "8.7.0" apply false
+     id "org.jetbrains.kotlin.android" version "2.1.0" apply false
  }
```

> **Version compatibility chain:** AGP 8.7.0 requires Gradle 8.9 and Kotlin 2.1.0.

---

### 3. Update compileSdk and targetSdk

**File:** `android/app/build.gradle`

```diff
  android {
-     compileSdk = 34
+     compileSdk = 36
      ...
      defaultConfig {
          ...
-         targetSdk = 34
+         targetSdk = 36
          ...
      }
  }
```

> Some plugins (e.g., `path_provider_android`, `sqflite_android`) require SDK 36.

---

### 4. Update Java & Kotlin JVM Compatibility

**File:** `android/app/build.gradle`

```diff
  compileOptions {
-     sourceCompatibility = JavaVersion.VERSION_1_8
-     targetCompatibility = JavaVersion.VERSION_1_8
+     sourceCompatibility = JavaVersion.VERSION_17
+     targetCompatibility = JavaVersion.VERSION_17
  }

+ kotlinOptions {
+     jvmTarget = "17"
+ }
```

> Java 1.8 target is no longer compatible with Kotlin 2.1 and modern AGP.

---

### 5. Add Kotlin JVM Target Validation Override

**File:** `android/gradle.properties`

```diff
  org.gradle.jvmargs=-Xmx4G -XX:+HeapDumpOnOutOfMemoryError
  android.useAndroidX=true
  android.enableJetifier=true
+ kotlin.jvm.target=17
+ kotlin.jvm.target.validation.mode=IGNORE
```

> Some third-party plugins hardcode JVM target 21 in their own build configs. The `IGNORE` flag prevents the build from failing due to JVM target mismatches between your app and those plugins.

---

### 6. Update Outdated Plugins (if needed)

Run this to check for outdated packages:

```bash
flutter pub outdated
```

In our case, `panorama_viewer` had to be upgraded because its dependency `dchs_motion_sensors` v1.1.0 used deprecated Kotlin APIs:

**File:** `pubspec.yaml`

```diff
- panorama_viewer: ^1.0.5
+ panorama_viewer: ^2.0.7
```

Then run:

```bash
flutter pub get
```

> **General rule:** If a build fails with "Unresolved reference" errors in a plugin's Kotlin code, check `flutter pub outdated` for a newer version of that plugin.

---

### 7. Update Dart/Flutter SDK Constraints

**File:** `pubspec.yaml`

```diff
  environment:
-   sdk: '>=3.4.1 <4.0.0'
+   sdk: '>=3.11.0 <4.0.0'
+   flutter: '>=3.41.0'
```

> Match the SDK constraint to your actual Flutter version's Dart SDK. Check with `flutter --version`.

---

## Quick Reference: Version Compatibility Table

| Component                | Old Version | New Version |
|--------------------------|-------------|-------------|
| Gradle                   | 7.6.3       | 8.9         |
| Android Gradle Plugin    | 7.3.0       | 8.7.0       |
| Kotlin                   | 1.7.10      | 2.1.0       |
| compileSdk               | 34          | 36          |
| targetSdk                | 34          | 36          |
| Java Source Compatibility | 1.8         | 17          |
| Kotlin JVM Target        | (default)   | 17          |
| Java (system)            | 11          | 17          |

---

## Build Command

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 && flutter build apk --debug
```

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `Minimum supported Gradle version is X.X` | Update `gradle-wrapper.properties` to the required version |
| `AGP version X is lower than Flutter's minimum` | Update AGP in `settings.gradle` |
| `Unknown Kotlin JVM target: 21` | Install Java 17+, set `jvmTarget = "17"`, add `kotlin.jvm.target.validation.mode=IGNORE` |
| `Inconsistent JVM-target compatibility` | Add `kotlin.jvm.target.validation.mode=IGNORE` to `gradle.properties` |
| `Unresolved reference 'Registrar'` | Plugin is outdated — run `flutter pub outdated` and upgrade it |
| `compileSdk is too low` | Set `compileSdk` to the highest version required by any plugin (usually 36) |
| `Cannot run Project.afterEvaluate` | Don't use `afterEvaluate` with `evaluationDependsOn` — use `gradle.properties` instead |
