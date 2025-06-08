# Secure Password Manager App

A secure and user-friendly password manager app built with Flutter and BLoC architecture.  
The app helps users store, manage, and generate strong passwords with enhanced security features including PIN and biometric authentication.

---

## 📱 Sample APK

A sample build of the app is available for quick testing:

🔗 **[Download APK](secure_password_app.apk)**

> You can install this APK on your Android device to try out the app without building it yourself.

---

## Table of Contents

- [Setup Instructions](#setup-instructions)  
- [App Architecture Overview](#app-architecture-overview)  
- [Security Considerations](#security-considerations)  
- [BLoC Structure Explanation](#bloc-structure-explanation)  
- [Libraries Used & Rationale](#libraries-used--rationale)  

---

## 🔧 Setup Instructions

1. **Prerequisites:**  
   - Flutter SDK installed (version 3.0 or above recommended)  
   - Android Studio or VS Code with Flutter & Dart plugins  
   - An Android/iOS device or emulator

2. **Clone the repository:**  
   ```bash
   git clone https://github.com/yourusername/secure_password_manager.git
   cd secure_password_manager
   ```
3. **Install dependencies:**  
   ```bash
   flutter pub get
   ```
4. **Run the app:**
   ```bash
   flutter run
   ```

## 🧱 App Architecture Overview

The Secure Password Manager app is built with a clean and modular architecture to ensure maintainability, testability, and scalability:

- **Presentation Layer**  
  Handles the user interface using Flutter widgets. It listens to BLoC state changes and updates the UI accordingly.

- **Business Logic Layer (BLoC)**  
  Contains all business logic and state management. Events and states are managed using the BLoC pattern to ensure a clear separation between UI and logic.

- **Data Layer**  
  Responsible for storing and retrieving credentials. Passwords and user data are securely stored in a local SQLite database encrypted with SQLCipher, using the `sqflite_sqlcipher` package.

- **Security Layer**  
  Integrates security features such as biometric authentication, PIN verification, AES encryption, clipboard protection, and screenshot prevention to safeguard sensitive data.



## 🔐 Security Considerations

This app is designed with a **security-first mindset** to safely manage sensitive credentials offline. Here are the key security features implemented:

- **Encrypted Local Storage (AES-256)**  
  All credentials (site name, username, password) are encrypted using AES-256 before being saved, ensuring data is protected even if accessed directly from device storage.

- **Biometric & PIN Authentication**  
  Users must authenticate using device-level biometrics (fingerprint or Face ID) or a secure PIN to unlock the app and access credentials.

- **Auto-Lock Mechanism**  
  The app auto-locks after 2 minutes of inactivity or immediately when sent to the background. It shows the lock screen again when resumed.

- **Screenshot Prevention**  
  Screens containing sensitive data are protected from being captured via screenshots or screen recording using the `no_screenshot` package.

- **Clipboard Auto-Clear**  
  Passwords copied to the clipboard are automatically cleared after 30 seconds to prevent accidental leaks or misuse.

- **Password Strength Indicator**  
  While creating or editing credentials, the app shows the strength of the entered password to guide users toward stronger choices.

- **Password Generator Tool**  
  Includes a built-in password generator with options to customize:
  - Length  
  - Use of numbers and symbols  
  - Entropy or strength score display

- **Minimum Required Permissions Only**  
  The app does not request any unnecessary permissions, reducing the attack surface and respecting user privacy.


##  📦 BLoC Structure Explanation

The app uses the BLoC (Business Logic Component) pattern to manage state and separate business logic from the UI, ensuring a modular and testable codebase.

- **AuthBloc**  
  - Manages user authentication flows, including biometric and PIN verification.  
  - Emits authentication states to control access to secure areas of the app.

- **CredentialBloc**  
  - Handles all password credential operations such as adding, updating, retrieving, and deleting stored credentials.  
  - Listens for credential-related events and updates the state to reflect the current list of stored passwords.


##  📚 Libraries Used & Rationale

| Library                  | Purpose                                            | Reason for Use                                               |
|--------------------------|----------------------------------------------------|--------------------------------------------------------------|
| `cupertino_icons`        | Provides iOS-style icons                           | For consistent native-style iconography across platforms     |
| `flutter_svg`            | Renders SVG images                                 | To display scalable vector graphics with crisp visuals       |
| `sizer`                  | Responsive UI sizing                               | Enables easy responsive layouts across different screen sizes|
| `flutter_bloc`           | State management using the BLoC pattern           | Provides predictable, scalable, and testable state management|
| `flutter_secure_storage` | Secure local data storage                          | Platform-native encryption for securely storing sensitive data|
| `encrypt`                | Encryption/decryption utilities                    | To implement custom encryption for sensitive information     |
| `no_screenshot`          | Prevents screenshots/screens recording             | Adds privacy by blocking screen capture in sensitive screens |
| `local_auth`             | Biometric and PIN authentication                   | Enables FaceID, fingerprint, and PIN-based user authentication|
| `fluttertoast`           | Toast notifications                               | For showing quick user feedback messages                      |
| `sqflite_sqlcipher`      | Encrypted SQLite database                          | Secure local database storage with SQLCipher encryption       |




