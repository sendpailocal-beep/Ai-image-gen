# Zero-Cost Deployment Guide for SafeGuard 2026

To keep this app **100% Free** for you and the users, follow these steps:

### 1. Backend (Firebase Free Tier)
*   Go to [Firebase Console](https://console.firebase.google.com/).
*   Create a project and add an Android/iOS app.
*   Use **Firestore (Free Tier)** to store user contacts and last-known locations.
*   Use **Firebase Auth (Free Tier)** for phone number verification.

### 2. Edge-AI (Local Processing)
*   Don't use cloud-based AI APIs (like Google Cloud Vision/Audio). They cost money.
*   Use **TensorFlow Lite (TFLite)**. It runs on the user's phone's NPU/CPU for free.
*   Train your "Scream Detection" model using free tools like [Teachable Machine](https://teachablemachine.withgoogle.com/) and export as `.tflite`.

### 3. Communication (Free SMS/Calls)
*   **Avoid Paid APIs:** Don't use Twilio if you want it 100% free.
*   **Native Intent:** Use the phone's native `sms:` and `tel:` intents. This uses the user's existing mobile plan, so you (the developer) pay **$0**.
*   **WhatsApp Deep Links:** Use `https://wa.me/number?text=...` to trigger WhatsApp for free.

### 4. App Distribution
*   **GitHub Actions:** Use GitHub Actions to build your APK/IPA for free.
*   **F-Droid:** Host your app on F-Droid (Open Source App Store) for $0.
*   **Direct Download:** Host the APK on a free GitHub Release page.

### 5. Future Monetization (Optional & Non-Intrusive)
*   If server costs grow, add **Google AdMob** (Interstitial ads) ONLY on the "Help & Info" screens. Never on the SOS screen.
