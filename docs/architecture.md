# Architecture Overview

This document describes the high-level architecture of the Tour360 Flutter application.

## System Architecture

```mermaid
graph TB
    subgraph "Tour360 App"
        UI["UI Layer<br/>(Screens & Components)"]
        Models["Data Models"]
        Utils["Utilities<br/>(Colors, Strings, Store)"]
        Navigation["GetX Navigation"]
    end

    subgraph "External Services"
        API["Google Custom Search API"]
        CDN["Image CDNs<br/>(Cached Network Images)"]
    end

    UI -->|"uses"| Models
    UI -->|"uses"| Utils
    UI -->|"navigates via"| Navigation
    UI -->|"fetches panoramic images"| API
    UI -->|"loads thumbnails"| CDN
```

## Layered Architecture

The app uses a simple, pragmatic layered architecture optimized for a focused feature set.

```mermaid
graph TD
    subgraph "Presentation Layer"
        HS["HomeScreen"]
        SLS["SearchListScreen"]
        VS["ViewScreen"]
        CSD["CustomSearchDelegate"]
        MS["MostSearched"]
        TP["TopPlaces"]
    end

    subgraph "Data Layer"
        PM["Place Model"]
        Store["Store<br/>(Curated Data)"]
    end

    subgraph "Infrastructure"
        Dio["Dio HTTP Client"]
        PV["Panorama Viewer"]
        Cache["CachedNetworkImage"]
        Lottie["Lottie Animations"]
    end

    HS --> MS
    HS --> TP
    HS --> CSD
    CSD --> SLS
    MS --> SLS
    TP --> SLS
    SLS --> VS

    HS --> Store
    MS --> Store
    TP --> Store
    CSD --> Store
    SLS --> PM
    SLS --> Dio
    VS --> PV
    MS --> Cache
    TP --> Cache
    SLS --> Cache
    HS --> Lottie
    SLS --> Lottie
    VS --> Lottie
```

## Component Responsibilities

### Screens

| Screen | Responsibility |
|--------|---------------|
| **HomeScreen** | Entry point. Displays animated header, search button, curated carousels (MostSearched, TopPlaces). |
| **SearchListScreen** | Fetches and displays panoramic image results from Google Custom Search API for a given location. |
| **ViewScreen** | Renders an interactive 360-degree panoramic view of a selected image. |

### Components

| Component | Responsibility |
|-----------|---------------|
| **CustomSearchDelegate** | Provides search UI with autocomplete from 400+ pre-populated suggestions. |
| **MostSearched** | Horizontal scrollable carousel of 8 curated popular destinations. |
| **TopPlaces** | Vertical card list of 16 curated top tourist destinations. |

### Models

| Model | Fields | Purpose |
|-------|--------|---------|
| **Place** | `name`, `image` | Represents a tourist destination with a display name and thumbnail URL. |

### Utilities

| Utility | Purpose |
|---------|---------|
| **palatte.dart** | Centralized color constants (background, primary green, white). |
| **store.dart** | Curated data: most-searched places, top places, and 408 search suggestion strings. |
| **strings.dart** | UI string constants for labels and messages. |

## State Management

The app uses **local StatefulWidget state** for screen-level data and **GetX** exclusively for navigation.

```mermaid
stateDiagram-v2
    [*] --> Idle

    state "SearchListScreen States" as SearchStates {
        Idle --> Loading : fetchData()
        Loading --> Loaded : API success
        Loading --> Error : API failure
        Error --> Loading : retry
        Loaded --> [*]
    }
```

Each screen manages its own state variables (`isLoading`, `isError`, `data`) directly within `setState()`. There are no global state controllers, streams, or reactive bindings beyond navigation.

### Why This Approach

- The app has a small, focused feature set (browse, search, view)
- No shared state is needed across screens (data flows forward via constructor parameters)
- Simplicity reduces boilerplate and cognitive overhead for a team of this size

## Design Patterns

| Pattern | Usage |
|---------|-------|
| **Composition** | Screens composed from reusable components (MostSearched, TopPlaces) |
| **Delegate** | Flutter's SearchDelegate pattern for search UX |
| **Constructor Injection** | Screen data passed via widget constructors through GetX navigation |
| **Constants Extraction** | Colors, strings, and curated data centralized in `utils/` |

## Assets Strategy

```mermaid
graph LR
    subgraph "Local Assets"
        A1["header.json"]
        A2["loading1.json"]
        A3["loading2.json"]
        A4["error.json"]
        A5["search.json"]
    end

    subgraph "Remote Assets"
        R1["Place Thumbnails<br/>(Cached)"]
        R2["Panoramic Images<br/>(On-demand)"]
    end

    A1 -->|"Lottie"| HomeScreen
    A2 -->|"Lottie"| SearchListScreen
    A3 -->|"Lottie"| ViewScreen
    A4 -->|"Lottie"| SearchListScreen
    A5 -->|"Lottie"| HomeScreen

    R1 -->|"CachedNetworkImage"| Components
    R2 -->|"Dio + PanoramaViewer"| ViewScreen
```

- **Lottie animations** are bundled locally in `assets/` for instant loading
- **Place thumbnails** are fetched from CDNs and cached via `cached_network_image`
- **Panoramic images** are fetched on-demand from Google Custom Search API results
