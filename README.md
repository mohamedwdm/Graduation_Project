# 🚗 Go2Car — Companion Mobile Application

A production-ready Flutter mobile application for the **Go2Car — AI-Powered Smart Parking System**. This app acts as the client-side companion for users and facility administrators, facilitating real-time slot checking, bookings, automated payment simulation, parking histories, vehicle tracking, and administrative controls.

---

## ✨ Features

### 👤 User Features
* **Real-time Slot Viewer**: View live parking spot availability organized by floor, section, and accessibility needs.
* **Smart Reservations**: Choose a floor, section, and slot to reserve parking in advance with custom start and end timeframes.
* **Vehicle Manager**: Save personal vehicles (model, plate number) for quick selection when booking or locate vehicles by plate.
* **Booking History**: Keep track of all current and historical parking records.
* **Active Status Guard**: Live active reservations cannot be cancelled once they have been approved or have started, preventing status conflicts.
* **Find My Car**: Input a plate number to get fuzzy searches and navigation guidelines to locate your parked car.
* **Simulated Multi-Step Checkout**: A purely client-side user interface mockup demonstrating how the payment process would function, supporting:
  * **Simulated Credit / Debit Card**: Mock input fields for Card Number, Expiry, and CVV.
  * **Simulated PayPal**: Mock login credentials and authorization form.
  * **Simulated Apple / Google Pay**: Contact-free mobile payment mockup interface.
  * **Simulated Pay at Location**: Confirmation screen for cash or POS payment at the physical gate.
  *(Note: All payment options are mock UI simulations; no actual financial transactions or payment gateway integrations exist).*


### 🔑 Admin Features
* **Facility Overview Dashboard**: View live analytics showing active parking spots, total slot occupancy, and historical activity timelines.
* **Live Notifications & Requests**: Approve or reject pending reservations in real-time.
* **Slot & Floor Management**: Modify parking structures, add new floors, add parking slots, and toggle slot types (Normal vs. Accessible/Handicap).

---

## 🛠️ Mobile Tech Stack

| Layer / Aspect | Technology |
|----------------|------------|
| **Core Framework** | [Flutter SDK](https://flutter.dev) ^3.5.0 (Dart ^3.5.0) |
| **State Management** | [Flutter Bloc & Cubits](https://pub.dev/packages/flutter_bloc) ^9.1.1 |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) ^17.2.1 |
| **Dependency Injection** | [GetIt](https://pub.dev/packages/get_it) ^9.2.1 |
| **HTTP Client** | [Dio](https://pub.dev/packages/dio) ^5.4.0 (with global error interceptors) |
| **Local Storage** | [SharedPreferences](https://pub.dev/packages/shared_preferences) ^2.2.3 |
| **Typography & Assets** | Google Fonts (Space Grotesk, Manrope) + Flutter SVG |
| **Launcher Configurations** | Flutter Launcher Icons |

---

## 🏗️ Architecture

The codebase follows **Clean Architecture** combined with **Feature-first** folder separation. This enforces a separation of concerns, high testability, and isolated features.

```
lib/
├── app.dart                   # Global app configurations, routing provider
├── main.dart                  # Dependency setup and app startup entrypoint
├── splash_view.dart           # App startup sequence and session restoration check
├── core/                      # Shared core modules
│   ├── config/                # Environment config (Dev / Staging / Production URLs)
│   ├── di/                    # GetIt dependency injection setup
│   ├── network/               # HTTP client configuration, API interceptors
│   ├── routing/               # GoRouter paths and route definitions
│   └── widgets/               # Standard UI widgets (buttons, text fields)
└── features/                  # Feature modules
    ├── auth/                  # Authentication, Token management, & user sessions
    ├── slots/                 # Live interactive parking grid, floor selection
    ├── reservation/           # Timeframe selectors, payment mock, and history
    ├── find_car/              # Fuzzy search locator for vehicles
    ├── profile/               # Personal info, Saved Vehicles List
    ├── manage_slots_admin/    # Floor & slot manager panel for admins
    └── admin_notifications/   # Booking request approval flow and activity logs
```

### Clean Architecture Layers (Within each Feature)
1. **Data Layer**: Contains API DataSources (remote/local data fetching), Models (JSON serialization/deserialization extending domain entities), and Repository implementations.
2. **Domain Layer**: Contains the core business logic. Defines Usecases, Entities, and abstract Repository contracts.
3. **Presentation Layer**: Handles UI layouts. Built with Bloc/Cubit state management classes, main Views, and modular Widgets.

---

## 📡 API Integration & Error Handling

* **Config-driven Environments**: Switch between Local development (`10.0.2.2:8000` / `127.0.0.1:8000`), Staging, and Production API URLs seamlessly through `lib/core/config/env_config.dart`.
* **Session Guard (401 Interceptor)**: A global HTTP interceptor monitors backend communications. If a `401 Unauthorized` token expiry occurs, the interceptor automatically:
  1. Clears cached authorization credentials.
  2. Resets the WebSocket manager token.
  3. Seamlessly redirects the user back to the login screen, resolving stuck loading bugs.

---

## ⚡ Getting Started

### Prerequisites
* Flutter SDK (Version 3.5.0 or higher)
* Android SDK / Xcode (for iOS testing)
* Backend API server running (refer to the [Go2Car Backend README](../../go2car_backend/Go2Car_Backend_GP/README.md) for backend setup instructions)

### Setup Instructions

1. **Clone the repository and enter the directory**:
   ```bash
   git clone <repository_url>
   cd go2car
   ```

2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Configure the base URL**:
   Ensure `main.dart` initializes the target environment (`Environment.dev`, `Environment.staging`, or `Environment.prod`). The local environment URL maps to `10.0.2.2:8000` automatically for Android emulators.

4. **Run code generation (if icons are updated)**:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Launch the application**:
   ```bash
   # Running on connected emulator or device
   flutter run
   ```

---

## 🧪 Testing

The client-side supports Flutter's standard test suite. To run the widget, unit, and integration tests:
```bash
flutter test
```
*(Backend unit and integration tests are run via `pytest` inside the backend directory)*.