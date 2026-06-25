# SafeGuard 2026: End-to-End Setup Guide

Ye app aapke bataye hue requirements ke mutabiq strictly tayyar hai. Is mein 4 baar Volume button dabane par saved contacts ko Location aur Call chali jati hai.

### 1. Requirements
*   **Flutter SDK** (Latest 2026 version)
*   **Android Studio / VS Code**
*   **Physical Android Device** (Accessibility services emulator par sahi kaam nahi kartin)

### 2. Permissions Needed
App chalane ke baad aapko ye permissions deni hongi:
1.  **Location:** "Allow all the time" (Taake background mein location mil sake).
2.  **Accessibility Service:** Settings > Accessibility > SafeGuard 2026 > **ON**. (Ye sabse zaroori hai volume button detect karne ke liye).
3.  **SMS & Phone:** SMS bhejne aur Call karne ke liye.

### 3. How to Install
1.  Is folder ko apne computer par save karein.
2.  Terminal mein `flutter pub get` chalayein dependencies install karne ke liye.
3.  Apna phone connect karein aur `flutter run` chalayein.

### 4. How to Use
1.  App khol kar apne doston ya ghar walon ke numbers add karein.
2.  App ko band kar dein ya phone lock kar dein.
3.  **Volume Up** button ko **4 baar jaldi se dabayein**.
4.  App khud khul jayegi aur pehle contact ko SMS (Maps Link ke saath) aur Call kar degi.

### 5. Technical Files
*   `lib/main.dart`: UI aur Contact Management.
*   `lib/sos_logic.dart`: Location nikalne aur SMS/Call bhejne ka code.
*   `android/app/src/main/kotlin/.../SOSAccessibilityService.kt`: Volume button press detect karne ka system code.

Ye app 100% free hai kyunke ye aapke phone ka apna SMS/Call plan use karti hai.
