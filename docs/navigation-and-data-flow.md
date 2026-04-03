# Navigation & Data Flow

This document describes the screen navigation graph and how data flows through the Tour360 application.

## Navigation Graph

```mermaid
graph TD
    subgraph "App Entry"
        Main["main.dart<br/>GetMaterialApp"]
    end

    subgraph "Screens"
        HS["HomeScreen<br/>(home: true)"]
        SLS["SearchListScreen<br/>(query results)"]
        VS["ViewScreen<br/>(360 panorama)"]
    end

    subgraph "Overlays"
        SD["CustomSearchDelegate<br/>(showSearch overlay)"]
    end

    Main -->|"home"| HS
    HS -->|"showSearch()"| SD
    SD -->|"Get.to()"| SLS
    HS -->|"Get.to()<br/>via MostSearched card"| SLS
    HS -->|"Get.to()<br/>via TopPlaces card"| SLS
    SLS -->|"Get.to()"| VS
    VS -->|"Get.back()"| SLS
    SLS -->|"Get.back()"| HS
    SD -->|"close()"| HS
```

## Data Flow Per Screen

### HomeScreen

```mermaid
sequenceDiagram
    participant App as GetMaterialApp
    participant HS as HomeScreen
    participant MS as MostSearched
    participant TP as TopPlaces
    participant Store as store.dart
    participant SD as SearchDelegate

    App->>HS: Launch (home route)
    HS->>Store: Read mostSearchedPlaces
    Store-->>MS: List<Place>
    HS->>Store: Read topPlaces
    Store-->>TP: List<Place>
    
    Note over HS: User taps search icon
    HS->>SD: showSearch(delegate)
    SD->>Store: Read searchList (408 items)
    
    Note over HS: User taps a place card
    HS->>SLS: Get.to(SearchListScreen(name))
```

### SearchListScreen

```mermaid
sequenceDiagram
    participant Nav as Navigation
    participant SLS as SearchListScreen
    participant Dio as Dio HTTP Client
    participant API as Google Custom Search API
    participant VS as ViewScreen

    Nav->>SLS: Get.to(name: "Taj Mahal")
    SLS->>SLS: initState() → fetchData()
    SLS->>Dio: GET /customsearch/v1
    
    Note right of Dio: Query params:<br/>q: "Taj Mahal panoramic image"<br/>searchType: image<br/>imgSize: HUGE

    Dio->>API: HTTP Request
    
    alt Success
        API-->>Dio: JSON Response
        Dio-->>SLS: Response data
        SLS->>SLS: setState(data = items, isLoading = false)
        Note over SLS: Render image grid

        Note over SLS: User taps an image
        SLS->>VS: Get.to(ViewScreen(imageUrl, name))
    else Error
        API-->>Dio: Error / Timeout
        Dio-->>SLS: Exception
        SLS->>SLS: setState(isError = true)
        Note over SLS: Show error animation
    end
```

### ViewScreen

```mermaid
sequenceDiagram
    participant SLS as SearchListScreen
    participant VS as ViewScreen
    participant PV as PanoramaViewer

    SLS->>VS: Get.to(imageUrl, name)
    VS->>VS: Build UI with name in AppBar
    VS->>PV: PanoramaViewer(child: Image.network(url))
    
    Note over PV: User interacts:<br/>- Drag to rotate<br/>- Pinch to zoom

    Note over VS: User taps back
    VS->>SLS: Get.back()
```

## Data Model Flow

```mermaid
graph LR
    subgraph "Static Data (store.dart)"
        MPD["mostSearchedPlaces<br/>List&lt;Place&gt;"]
        TPD["topPlaces<br/>List&lt;Place&gt;"]
        SL["searchList<br/>List&lt;String&gt;"]
    end

    subgraph "Dynamic Data (API)"
        APIResp["Google CSE Response<br/>{items: [{link, title}]}"]
    end

    subgraph "Screens"
        HS["HomeScreen"]
        SLS["SearchListScreen"]
        VS["ViewScreen"]
    end

    MPD -->|"Place.name, Place.image"| HS
    TPD -->|"Place.name, Place.image"| HS
    SL -->|"suggestions"| HS

    HS -->|"place.name (String)"| SLS
    APIResp -->|"image URLs"| SLS
    SLS -->|"imageUrl (String), name (String)"| VS
```

## Navigation Parameters

| Route | Parameters | Type | Description |
|-------|-----------|------|-------------|
| HomeScreen | - | - | No parameters (entry point) |
| SearchListScreen | `name` | `String` | Location name to search for panoramic images |
| ViewScreen | `imageUrl` | `String` | URL of the panoramic image to display |
| ViewScreen | `name` | `String` | Location name for the app bar title |

## User Journey Flows

### Browse and View Flow

```mermaid
graph LR
    A["Open App"] --> B["Browse Home"]
    B --> C{"Select Place"}
    C -->|"Most Searched"| D["Search Results"]
    C -->|"Top Places"| D
    D --> E["Tap Image"]
    E --> F["360 Panoramic View"]
    F -->|"Back"| D
    D -->|"Back"| B
```

### Search Flow

```mermaid
graph LR
    A["Open App"] --> B["Tap Search Icon"]
    B --> C["Type Query"]
    C --> D["See Suggestions"]
    D --> E["Select / Submit"]
    E --> F["Search Results"]
    F --> G["Tap Image"]
    G --> H["360 Panoramic View"]
```
