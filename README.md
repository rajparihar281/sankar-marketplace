# Sankar Hub

A mobile application for industrial procurement and equipment catalog management, built with Flutter.

Sankar Hub provides an interface for browsing technical equipment, industrial sealing components, tools, and sensors. It supports real-time catalog search, category filtering, multi-criteria sorting, wishlist management, and a procurement cart workflow.

## Overview

The application is structured around a modular architecture using the Provider pattern for state management. It connects to a REST API for live product data while maintaining an offline fallback cache so the catalog remains accessible without an internet connection.

All user preferences, authentication sessions, wishlist items, and cart data are persisted locally using `shared_preferences`.

## Project Structure

The codebase is organized into layers:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Theme color palette
│   │   └── app_constants.dart      # Global constants and formatting utilities
│   ├── routes/
│   │   └── app_routes.dart         # Route generator and path definitions
│   └── theme/
│       └── app_theme.dart          # Light and dark theme specifications
├── data/
│   ├── models/
│   │   ├── user_model.dart         # User entity with JSON serialization
│   │   ├── product_model.dart      # Product data model with pricing logic
│   │   └── cart_item_model.dart    # Cart item wrapper
│   ├── sample/
│   │   └── sample_products.dart    # Offline catalog dataset
│   └── services/
│       ├── api_service.dart        # HTTP client with error handling
│       └── storage_service.dart    # Local persistence wrapper
├── providers/
│   ├── auth_provider.dart          # Authentication and user session state
│   ├── product_provider.dart       # Product catalog, search, filter, and sorting
│   ├── cart_provider.dart          # Shopping cart and order calculation state
│   ├── wishlist_provider.dart      # Saved items state
│   └── theme_provider.dart         # Theme mode toggling and persistence
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart      # Startup animation and session routing
│   ├── auth/
│   │   └── auth_screen.dart        # Login and registration forms
│   ├── main_navigation_screen.dart # Bottom navigation shell
│   ├── home/
│   │   └── home_screen.dart        # Dashboard with banners and summaries
│   ├── listing/
│   │   └── product_listing_screen.dart # Catalog grid and list view
│   ├── details/
│   │   └── product_details_screen.dart # Product specification view
│   ├── wishlist/
│   │   └── wishlist_screen.dart    # Saved items list
│   ├── cart/
│   │   └── cart_screen.dart        # Procurement cart and checkout
│   └── profile/
│       └── profile_screen.dart     # Account details and system settings
├── widgets/
│   ├── banner_carousel.dart        # Sliding announcement banner
│   ├── custom_button.dart          # Reusable button with loading state
│   ├── custom_text_field.dart      # Form field with input validation
│   ├── empty_state_view.dart       # Generic empty state placeholder
│   ├── error_state_view.dart       # Network and error state with retry action
│   ├── product_card.dart           # Adaptive product card for grid and list
│   ├── rating_stars.dart           # Rating display component
│   └── section_header.dart         # Section title with navigation action
└── main.dart                       # Entry point and provider initialization
```

## Features

### Authentication and Session Management
- Sign in and registration with form validation (email format, password constraints).
- One-click demo credentials chip for quick testing.
- Guest access mode for browsing without an account.
- Persistent session storage: returning users are taken directly to the main dashboard.

### Product Catalog and Browsing
- Live search with instant filtering across product names, descriptions, and categories.
- Category filter chips with active selection states.
- Multi-option sorting (Featured, Price: Low to High, Price: High to Low, Rating).
- Dual view modes: toggle between a 2-column responsive grid and a single-column list.
- Pull-to-refresh to re-fetch catalog data from the API.

### Product Details
- Image gallery with thumbnail selector.
- Detailed technical specifications table (dimensions, warranty, logistics).
- Interactive quantity adjuster.
- Price calculation with discount percentage display.
- Direct actions to save to wishlist or add to cart.

### Cart and Procurement
- Quantity adjustments with live subtotal, industrial tax (5%), and freight calculation.
- Free shipping threshold applied automatically.
- Simulated checkout dialog generating an order reference number upon placement.

### Wishlist
- Add or remove items from the catalog or product details page.
- Direct action to move saved items into the procurement cart.
- Persisted locally across app restarts.

### User Preferences and Settings
- Dark mode and light mode toggle with immediate visual refresh and state persistence.
- Currency display in Indian Rupee (INR).
- Order history and compliance references.

## Responsive Design

The UI is built to handle various Android screen sizes without pixel overflow:
- Uses `LayoutBuilder` to compute adaptive image and card proportions dynamically.
- `Wrap` and `FittedBox` widgets prevent horizontal overflow on narrow devices (such as 360dp width screens).
- Responsive grid ratio adjustments accommodate different system font scales.

## Getting Started

### Prerequisites
- Flutter SDK (3.20.0 or higher recommended)
- Dart SDK (3.3.0 or higher)
- Android Studio / Android SDK for mobile builds, or Chrome for web execution

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd internship_project
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

   To run on a specific device:
   ```bash
   flutter run -d chrome    # Web browser
   flutter run -d windows   # Windows desktop
   ```

### Running Tests
Execute the unit and model test suite:
```bash
flutter test
```

### Static Analysis
Run static analysis to ensure code quality:
```bash
flutter analyze
```

### Building the APK

To generate optimized, production-ready release APKs:

1. Architecture-specific release APKs (recommended for minimal size):
   ```bash
   flutter build apk --split-per-abi
   ```
   Outputs:
   - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (~18 MB, recommended for modern phones including Samsung Galaxy A03s)
   - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (~15 MB, for 32-bit devices)

2. Universal release APK (compatible across all Android architectures):
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk` (~51 MB)

3. Debug APK:
   ```bash
   flutter build apk --debug
   ```
   Output: `build/app/outputs/flutter-apk/app-debug.apk` (~164 MB, contains unstripped JIT binaries and debug symbols)

## Dependencies

- `provider`: State management across app domains.
- `http`: REST API communication.
- `shared_preferences`: Local key-value storage.
- `intl`: Number and date formatting.
- `cupertino_icons`: Icon assets.
