---
description: How to setup the Flutter project
---

# Setup Instructions for Well-Dine-Bistro-management

Follow these steps to set up the development environment for this Flutter project.

## Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extension
- Firebase Project (The config files `google-services.json` and `GoogleService-Info.plist` are already included in the repo)

## Initial Setup

1. **Clone the repository** (if you haven't already):
   ```powershell
   git clone <repository_url>
   cd Well-Dine-Birstro-management
   ```

2. **Get Dependencies**:
   // turbo
   Run the following command to fetch all required packages:
   ```powershell
   flutter pub get
   ```

3. **Verify Environment**:
   Check if your system is ready for Flutter development:
   ```powershell
   flutter doctor
   ```

4. **Run Analysis (Optional)**:
   Ensure there are no critical errors in the code:
   ```powershell
   flutter analyze
   ```

## Running the App

1. **Start an Emulator/Simulator** or connect a physical device.
2. **Launch the app**:
   ```powershell
   flutter run
   ```

## Troubleshooting
- If you encounter dependency issues, try clearing the cache:
  ```powershell
  flutter clean
  flutter pub get
  ```
