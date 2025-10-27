# Firebase Setup Guide

## Prerequisites

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

## Firebase Project Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project" or "Create a project"
3. Enter project name (e.g., `flutter-template-app`)
4. Enable Google Analytics (recommended)
5. Choose or create a Google Analytics account
6. Click "Create project"

### 2. Configure Authentication

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable the following providers:
   - Email/Password ✅
   - Google ✅
   - Apple (for iOS) ✅
   - Anonymous (optional) ✅

3. Configure OAuth redirect domains if needed
4. Set up authorized domains for production

### 3. Set up Firestore Database

1. Go to **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" (we'll add security rules later)
4. Select a location (choose closest to your users)

### 4. Configure Storage

1. Go to **Storage**
2. Click "Get started"
3. Start in test mode
4. Choose same location as Firestore

### 5. Set up Cloud Messaging

1. Go to **Cloud Messaging**
2. Generate server key (for backend integration if needed)

### 6. Enable Analytics & Crashlytics

Analytics is automatically enabled when you create the project with it.
For Crashlytics:
1. Go to **Crashlytics**
2. Click "Enable Crashlytics"

## Flutter App Configuration

### 1. Configure FlutterFire

Run the FlutterFire configure command in your project root:

```bash
flutterfire configure
```

This will:
- Create `firebase_options.dart` with your project configuration
- Download configuration files for each platform
- Update your app's platform-specific files

### 2. Platform-specific Setup

#### Android Setup

The `flutterfire configure` command handles most Android setup, but verify:

1. Check `android/app/google-services.json` exists
2. Verify `android/app/build.gradle` has:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   apply plugin: 'com.google.firebase.crashlytics'
   ```

3. Verify `android/build.gradle` has:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
       classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.4'
   }
   ```

#### iOS Setup

The `flutterfire configure` command handles most iOS setup, but verify:

1. Check `ios/Runner/GoogleService-Info.plist` exists
2. Open `ios/Runner.xcworkspace` in Xcode
3. Verify `GoogleService-Info.plist` is added to the Runner target
4. Add the following to `ios/Runner/Info.plist` for URL schemes:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

#### Web Setup

1. Add Firebase SDK to `web/index.html`:
   ```html
   <script type="module">
     import { initializeApp } from 'https://www.gstatic.com/firebasejs/10.0.0/firebase-app.js';
     import { getAnalytics } from 'https://www.gstatic.com/firebasejs/10.0.0/firebase-analytics.js';
     
     const firebaseConfig = {
       // Your config from Firebase Console
     };
     
     const app = initializeApp(firebaseConfig);
     const analytics = getAnalytics(app);
   </script>
   ```

### 3. Update Environment Variables

Add Firebase configuration to your `.env` file:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_APP_ID=your-app-id
FIREBASE_MEASUREMENT_ID=your-measurement-id
```

## Security Rules

### Firestore Rules

Create security rules in Firebase Console > Firestore Database > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public data (read-only)
    match /public/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Storage Rules

Create security rules in Firebase Console > Storage > Rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public files (read-only)
    match /public/{allPaths=**} {
      allow read: if true;
    }
  }
}
```

## Testing Configuration

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Test Firebase Connection

Run the app and check the console for Firebase initialization messages:

```bash
flutter run
```

Look for these log messages:
- `🔥 Initializing Firebase...`
- `✅ Firebase Analytics initialized`
- `✅ Firebase Performance initialized`
- `✅ Firebase Crashlytics initialized`
- `✅ Firebase Messaging initialized`
- `✅ Firebase Remote Config initialized`
- `✅ Firebase initialization completed`

### 3. Test Authentication

1. Navigate to the login screen
2. Try creating an account
3. Check Firebase Console > Authentication > Users to see if the user was created

### 4. Test Firestore

1. Navigate to a screen that writes to Firestore
2. Check Firebase Console > Firestore Database to see if data was written

## Production Deployment

### 1. Update Security Rules

Review and update your Firestore and Storage security rules for production.

### 2. Configure App Check (Recommended)

1. Go to Firebase Console > App Check
2. Enable App Check for your app
3. Configure attestation providers (Play Integrity, DeviceCheck, reCAPTCHA)

### 3. Set up Monitoring

1. Configure alerting in Firebase Console
2. Set up performance monitoring alerts
3. Configure Crashlytics notifications

### 4. Update Environment Configuration

Update your production environment variables and rebuild the app.

## Troubleshooting

### Common Issues

1. **Build errors after adding Firebase**
   - Run `flutter clean && flutter pub get`
   - Ensure all configuration files are in the correct locations

2. **Authentication not working**
   - Check if the sign-in method is enabled in Firebase Console
   - Verify OAuth configuration and authorized domains

3. **Firestore permission denied**
   - Check security rules
   - Ensure user is authenticated

4. **iOS build issues**
   - Open `ios/Runner.xcworkspace` (not .xcodeproj)
   - Clean build folder in Xcode

5. **Android build issues**
   - Check `google-services.json` is in `android/app/`
   - Verify Gradle plugins are correctly added

### Getting Help

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Flutter Community](https://flutter.dev/community)

## Next Steps

After setting up Firebase:

1. Configure push notifications
2. Set up Remote Config
3. Implement analytics tracking
4. Set up performance monitoring
5. Configure Crashlytics for error tracking