# Technical Overview: Architecture, Packages, and Tools

Project: Sankar Hub
Platform: Flutter Mobile (Android, Web, Windows)

---

## 1. Architectural Pattern

The application is engineered using a Layered Architecture following Clean Architecture principles and separation of concerns. This decouples user interface components from business logic, data models, and external services, ensuring testability, maintainability, and scalability.

### Architectural Layers

```
+-------------------------------------------------------------+
|                     PRESENTATION LAYER                      |
|  - Screens: Splash, Auth, Home, Listing, Details, Cart, etc.|
|  - Reusable Widgets: ProductCard, CustomButton, Headers     |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                   STATE MANAGEMENT LAYER                    |
|  - Providers: AuthProvider, ProductProvider, CartProvider,  |
|               WishlistProvider, ThemeProvider               |
|  - Business logic, reactive state notifications             |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                         DATA LAYER                          |
|  - Models: UserModel, ProductModel, CartItemModel           |
|  - Services: ApiService (REST), StorageService (Disk)       |
|  - Cache: SampleProducts (Curated fallback dataset)         |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                         CORE LAYER                          |
|  - Constants, Design Tokens (AppColors, AppConstants)       |
|  - Routing: AppRoutes (Centralized onGenerateRoute)         |
|  - Theme: AppTheme (Material 3 Light and Dark themes)       |
+-------------------------------------------------------------+
```

### Key Architectural Characteristics

1. Unidirectional Data Flow:
   - User interactions trigger actions on the Providers.
   - Providers execute asynchronous operations through Services (REST API or Local Storage).
   - Providers mutate internal state and dispatch `notifyListeners()`.
   - UI widgets listening via `context.watch<T>()` rebuild efficiently and deterministically.

2. Resilient Data Engine:
   - `ApiService` queries live REST endpoints (`https://dummyjson.com/products`).
   - If connectivity fails, requests timeout, or network errors occur, the service automatically falls back to `SampleProducts.sankarCatalog`.
   - This ensures the application remains fully functional and testable in both online and offline environments.

3. Responsive and Defensive Layout Design:
   - All screen layouts are built to adapt to diverse device viewports (e.g., Samsung Galaxy A03s at 360dp width up to tablets and desktop).
   - Dynamic sizing uses `LayoutBuilder` rather than static pixel heights.
   - Text and content sections utilize `Wrap`, `Flexible`, and `FittedBox` to eliminate any possibility of horizontal or vertical pixel overflows.

---

## 2. Packages Used

| Package | Version | Purpose & Technical Justification |
| :--- | :--- | :--- |
| `provider` | ^6.1.5 | State management. Recommended by the Flutter team; provides a lightweight, scalable dependency injection and reactive state model without boilerplate. |
| `http` | ^1.6.0 | REST API client. Handles HTTP GET requests, URI encoding, network timeout management, and JSON payload parsing. |
| `shared_preferences` | ^2.5.6 | Local data persistence. Wraps platform-specific key-value storage (Android SharedPreferences) to persist user auth sessions, wishlist IDs, cart items, and theme preferences across restarts. |
| `intl` | ^0.20.3 | Formatting utilities. Provides standardized number, decimal, and date formatting. |
| `cupertino_icons` | ^1.0.8 | Icon assets. Supplies clean iconography to complement Material Design 3. |
| `flutter_lints` | ^6.0.0 | Static code analysis. Enforces recommended Dart and Flutter code quality guidelines. |

---

## 3. Development Tools and Environment

### SDK and Framework
- Flutter SDK: Version 3.47.6 (Channel stable)
- Dart SDK: Version 3.13.5
- Execution Targets: Android (SDK 36.1.0), Web (Chrome/Edge), Windows Desktop

### Development Tools
- Integrated Development Environment: VS Code / Android Studio with Flutter and Dart extensions
- Build System: Gradle 8.x with Android Gradle Plugin (AGP)
- Version Control: Git with dual-branch workflow (`main` for release-ready code, `develop` for integration)
- Static Analyzer: Dart Analyzer (`flutter analyze`) configured with zero warnings
- Testing Framework: `flutter_test` for automated model verification and price formatting tests

---

## 4. Summary of Completed Deliverables

1. Source Code Repository: Structured in logical folders with 14 progressive commits on GitHub.
2. Verified Android APK: Built and tested at `build/app/outputs/flutter-apk/app-debug.apk`.
3. Code Quality: Zero analyzer issues (`flutter analyze`), all unit tests passing (`flutter test`).
4. Persistence & API: Full local storage and dynamic REST integration with offline fallback.
