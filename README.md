# ratan_requisition

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🚀 How to Setup and Run

### 1. Clone the Repository
```bash
git clone https://github.com/sharifWebDev/requisition-flutter-app.git
cd requisition-flutter-app
```

### 2. Clean Previous Build Files
```bash
flutter clean
```

### 3. Clear Flutter Package Cache (Optional)
```bash
flutter pub cache clean
```

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Generate Required Files
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Remove Previous Installation (Optional)
```bash
flutter run --purge
```

### 7. Run the Application
```bash
flutter run
```
 
 
````md
# Flutter Useful Commands
A collection of commonly used Flutter commands for project setup, dependency management, cleaning, running, and building applications.

## Project Create

### Create New Flutter Project
```bash
cd /var/www/
flutter create ratan_requisition --org com.ratanproducts
```

---

## Dependency Management

### Install Project Dependencies
```bash
flutter pub get
```

### Generate Files (Model, JSON, Hive, Freezed, etc.)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Clean Project

### Remove Build Cache
```bash
flutter clean
```

### Clear Flutter Package Cache
```bash
flutter pub cache clean
```

---

## Run Application

### Run Application on Connected Device
```bash
flutter run
```

### Run on Specific Emulator
```bash
flutter run -d emulator-5554
```

### Fresh Install (Remove Previous App and Reinstall)
```bash
flutter run --purge
```

---

## Build Release

### Generate Android App Bundle (Play Store Upload)
```bash
flutter build appbundle
```

### Generate Release APK
```bash
flutter build apk --release
```

### Generate Smaller APK (Split by CPU Architecture)
```bash
flutter build apk --split-per-abi
```

> **Note:** `--split-per-abi` creates separate APK files for each CPU architecture and reduces APK size significantly.

---

## Linux Desktop Support

### Enable Linux Desktop Support
```bash
flutter config --enable-linux-desktop
```

### Generate Linux Platform Folder
```bash
flutter create --platforms=linux .
```

> Run this command if the `linux/` directory is missing.

--- 

## 🔄 Complete Project Refresh Workflow

Use the following commands when facing dependency conflicts, build errors, cache issues, or generated file problems:

```bash
flutter clean

flutter pub cache clean

flutter pub get

flutter pub run build_runner build --delete-conflicting-outputs

flutter run --purge

flutter run
```

---

## 📋 Quick Reference

| Command                                                           | Purpose                       |
| ----------------------------------------------------------------- | ----------------------------- |
| `flutter pub get`                                                 | Install dependencies          |
| `flutter clean`                                                   | Clean build files             |
| `flutter pub cache clean`                                         | Clear package cache           |
| `flutter run`                                                     | Run application               |
| `flutter run --purge`                                             | Fresh install and run         |
| `flutter build apk --release`                                     | Build release APK             |
| `flutter build appbundle`                                         | Build Play Store bundle       |
| `flutter build apk --split-per-abi`                               | Generate smaller APKs         |
| `flutter config --enable-linux-desktop`                           | Enable Linux support          |
| `flutter create --platforms=linux .`                              | Generate Linux platform files |
| `flutter pub run build_runner build --delete-conflicting-outputs` | Generate code files           |

---
 
