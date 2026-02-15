# ReyHowley - Flutter Frontend

A comprehensive multi-vendor Flutter application for Food, Grocery, eCommerce, Pharmacy & Parcel delivery services.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Running the App](#running-the-app)
- [Building for Production](#building-for-production)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

**App Name:** ReyHowley  
**Version:** 1.0.0+1  
**Flutter SDK:** ^3.10.0  
**State Management:** GetX  
**Backend API:** https://reyhowley.com

ReyHowley is a feature-rich multi-vendor marketplace application that connects customers with various service providers including restaurants, grocery stores, pharmacies, and parcel delivery services.

## ✨ Features

### Core Features
- 🛒 Multi-vendor marketplace
- 🍔 Food ordering system
- 🛍️ Grocery shopping
- 💊 Pharmacy services
- 📦 Parcel delivery
- 💳 Multiple payment gateways
- 🗺️ Real-time location tracking
- 💬 In-app chat with vendors/delivery
- 🔔 Push notifications
- 🌙 Dark/Light theme support
- 🌍 Multi-language support (English, Arabic, Bengali, Spanish)

### User Features
- User registration and authentication
- Social login (Google, Facebook, Apple)
- Profile management
- Address management
- Order tracking
- Order history
- Wishlist/Favorites
- Coupons and offers
- Wallet system
- Loyalty rewards
- Product reviews and ratings
- Voice search

### Technical Features
- Firebase integration (Auth, Messaging, Core)
- Google Maps integration
- Real-time updates via Pusher
- Offline caching
- Image optimization
- Video player support
- In-app web view
- Speech-to-text functionality

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK:** 3.10.0 or higher
- **Dart SDK:** ^3.10.0
- **Android Studio** or **Xcode** (for iOS development)
- **VS Code** (recommended) with Flutter extensions
- **Git**
- **Firebase CLI** (for Firebase configuration)

### Platform-Specific Requirements

#### Android
- Android SDK 21 or higher
- Android Studio with Android SDK tools
- Java 11 or higher

#### iOS
- Xcode 14 or higher
- CocoaPods
- macOS (for iOS development)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd "rey howley app"
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Installation

```bash
flutter doctor -v
```

Fix any issues reported by `flutter doctor` before proceeding.

## ⚙️ Configuration

### 1. Backend Configuration

The app is configured to connect to the production backend:

```dart
// lib/util/app_constants.dart
static const String baseUrl = 'https://reyhowley.com';
static const String webHostedUrl = 'https://reyhowley.com';
```

To change the backend URL, edit the `baseUrl` in [lib/util/app_constants.dart](lib/util/app_constants.dart).

### 2. Firebase Configuration

Firebase services are pre-configured. The configuration files are located at:

- **Android:** `android/app/google-services.json`
- **iOS:** `ios/GoogleService-Info.plist`
- **Web/Flutter:** `lib/firebase_options.dart`

#### Update Firebase (if needed)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Download new configuration files
4. Replace existing files

### 3. Google Maps Configuration

The app uses Google Maps for location services.

**API Key:** `AIzaSyCaCSJ0BZItSyXqBv8vpD1N4WBffJeKhLQ`

Configuration files:
- **Android:** `android/app/src/main/AndroidManifest.xml`
- **iOS:** `ios/Runner/AppDelegate.swift`
- **Web:** `web/index.html`

### 4. Social Login Configuration

#### Facebook
- **App ID:** 380903914182154
- Configure in: `android/app/src/main/res/values/strings.xml` and `ios/Runner/Info.plist`

#### Google Sign-In
- **Client ID:** `491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com`
- Configured in Firebase project

#### Apple Sign-In
- Configured via Apple Developer Console
- Enabled for iOS only

### 5. Package Configuration

Update package identifier (if needed):

- **Android:** `com.sixamtech.sixam_mart_user`
- **iOS:** `com.sixamtech.sixamMartUser`

## 📁 Project Structure

```
lib/
├── api/                    # API service classes
├── common/                 # Common widgets & controllers
│   ├── controllers/        # Shared controllers
│   ├── models/            # Shared data models
│   └── widgets/           # Reusable widgets
├── features/              # Feature modules
│   ├── auth/             # Authentication
│   ├── cart/             # Shopping cart
│   ├── checkout/         # Checkout process
│   ├── dashboard/        # Main dashboard
│   ├── home/             # Home screen
│   ├── order/            # Order management
│   ├── profile/          # User profile
│   ├── store/            # Store/vendor management
│   └── ...               # Other features
├── helper/               # Helper classes
├── interfaces/           # Interface definitions
├── local/                # Local storage
├── theme/                # Theme configuration
├── util/                 # Utilities & constants
├── firebase_options.dart # Firebase configuration
└── main.dart            # App entry point
```

### Architecture

The app follows a **feature-based architecture** with:
- **GetX** for state management and routing
- **Repository pattern** for data layer
- **Controller-View separation** for UI logic
- **Dependency injection** via `get_di.dart`

## 🏃 Running the App

### Development Mode

#### Android
```bash
flutter run -d android
```

#### iOS
```bash
flutter run -d ios
```

#### Web
```bash
flutter run -d chrome
```

### Debug Mode
```bash
flutter run --debug
```

### Release Mode
```bash
flutter run --release
```

## 🏗️ Building for Production

### Android (APK)
```bash
flutter build apk --release
```

### Android (App Bundle)
```bash
flutter build appbundle --release
```

Built files location: `build/app/outputs/`

### iOS
```bash
flutter build ios --release
```

Then open Xcode:
```bash
open ios/Runner.xcworkspace
```

Archive and upload via Xcode.

### Web
```bash
flutter build web --release
```

Built files location: `build/web/`

## 🐛 Troubleshooting

### Common Issues

#### 1. Firebase Initialization Error
**Problem:** Duplicate Firebase initialization

**Solution:** Ensure Firebase is initialized only once in `main.dart`:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

#### 2. Google Maps Not Loading
**Problem:** Maps show blank screen

**Solution:**
- Verify API key is valid and enabled
- Enable Maps SDK for Android/iOS in Google Cloud Console
- Check billing is enabled

#### 3. Build Failures

**Android:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**iOS:**
```bash
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter pub get
flutter build ios
```

#### 4. Dependencies Issues
```bash
flutter clean
rm -rf pubspec.lock
rm -rf ios/Podfile.lock
flutter pub get
cd ios && pod install && cd ..
```

#### 5. Pusher Connection Issues
**Problem:** Real-time updates not working

**Solution:** Check backend Pusher configuration matches the app settings in the splash controller.

### Getting Help

- Check [Flutter Documentation](https://flutter.dev/docs)
- Review [GetX Documentation](https://pub.dev/packages/get)
- Contact the development team

## 🔧 Development Commands

### Code Analysis
```bash
flutter analyze
```

### Run Tests
```bash
flutter test
```

### Format Code
```bash
dart format .
```

### Update Dependencies
```bash
flutter pub upgrade
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (Chrome, Safari, Firefox, Edge)

## 🌐 Multi-Language Support

The app supports the following languages:

- English (en)
- Arabic (ar)
- Bengali (bn)
- Spanish (es)

Language files are located in: `assets/language/`

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Support

For technical support or questions, please contact the development team at ReyHowley.

---

**Last Updated:** February 15, 2026  
**Maintained by:** KR Solutions
