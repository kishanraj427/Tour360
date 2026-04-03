# Tour360

A Flutter application for exploring 360-degree panoramic views of famous landmarks and tourist destinations worldwide. Search for any location and experience it through immersive panoramic imagery powered by Google Custom Search API.

## Features

- **Interactive 360-degree panoramic viewer** for immersive place exploration
- **Smart search** with 400+ pre-populated location suggestions and autocomplete
- **Curated collections** of top tourist destinations and most-searched places
- **Cached image loading** for smooth performance and offline-ready thumbnails
- **Lottie animations** for polished loading, error, and UI states

## Screenshots

| Home Screen | Search | 360 View |
|:-----------:|:------:|:--------:|
| *Home with top places* | *Search with suggestions* | *Panoramic viewer* |

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Dart 3.4.1+) |
| State Management | StatefulWidget + GetX navigation |
| HTTP Client | Dio |
| 360 Viewer | panorama_viewer |
| Animations | Lottie |
| Image Caching | cached_network_image |
| Typography | Google Fonts |

## Getting Started

### Prerequisites

- Flutter SDK `>=3.4.1`
- Android SDK 34+ / Xcode (for iOS)
- A Google Custom Search API key

### Installation

```bash
# Clone the repository
git clone git@github.com:kishanraj427/tour360.git
cd tour360

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

The app requires a Google Custom Search API key. Update the API key in the search screen configuration before building for production.

## Project Structure

```
lib/
├── main.dart                  # App entry point & MaterialApp setup
├── components/
│   ├── custom_search_delegate.dart  # Search with autocomplete suggestions
│   ├── most_searched.dart           # Horizontal carousel of popular places
│   └── top_places.dart              # Vertical list of top destinations
├── models/
│   └── place.dart                   # Place data model (name, image)
├── screens/
│   ├── homescreen.dart              # Main screen with search & place lists
│   ├── search_list_screen.dart      # Search results with API integration
│   └── view_screen.dart             # 360-degree panoramic viewer
└── utils/
    ├── palatte.dart                 # Color constants
    ├── store.dart                   # Curated place data & search suggestions
    └── strings.dart                 # UI string constants
```

## Architecture

The app follows a simple layered architecture with GetX navigation. See the [docs/](docs/) folder for detailed architectural documentation:

- [Architecture Overview](docs/architecture.md) - High-level system design and patterns
- [Navigation & Data Flow](docs/navigation-and-data-flow.md) - Screen routing and data lifecycle
- [API Integration](docs/api-integration.md) - Google Custom Search API details

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [dio](https://pub.dev/packages/dio) | ^5.7.0 | HTTP client for API calls |
| [panorama_viewer](https://pub.dev/packages/panorama_viewer) | ^1.0.5 | 360-degree panoramic image viewer |
| [lottie](https://pub.dev/packages/lottie) | ^3.1.2 | Lottie animation playback |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | ^3.4.1 | Optimized network image caching |
| [google_fonts](https://pub.dev/packages/google_fonts) | ^6.2.1 | Google Fonts typography |
| [get](https://pub.dev/packages/get) | ^4.6.6 | Lightweight navigation & utilities |

## License

This project is proprietary. All rights reserved.
