# API Integration

This document describes how Tour360 integrates with external APIs for fetching panoramic imagery.

## Overview

```mermaid
graph LR
    subgraph "Tour360 App"
        SLS["SearchListScreen"]
        Dio["Dio HTTP Client"]
    end

    subgraph "Google Cloud"
        CSE["Custom Search Engine API<br/>customsearch.googleapis.com"]
    end

    subgraph "Image Hosts"
        IMG["Third-party Image Servers"]
    end

    SLS -->|"1. Search request"| Dio
    Dio -->|"2. GET /customsearch/v1"| CSE
    CSE -->|"3. JSON response<br/>(image metadata)"| Dio
    Dio -->|"4. Parse items"| SLS
    SLS -->|"5. Load image"| IMG
```

## Google Custom Search API

### Endpoint

```
GET https://customsearch.googleapis.com/customsearch/v1
```

### Request Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `key` | API Key | Google Cloud API key |
| `cx` | Search Engine ID | Custom Search Engine identifier |
| `q` | `"{location} panoramic image"` | Search query with location name |
| `searchType` | `image` | Restrict results to images only |
| `imgSize` | `HUGE` | Request high-resolution images suitable for panoramic viewing |

### Request Flow

```mermaid
sequenceDiagram
    participant User
    participant Screen as SearchListScreen
    participant Dio as Dio Client
    participant API as Google CSE API

    User->>Screen: Navigate with location name
    Screen->>Screen: initState() → fetchData()
    
    Screen->>Dio: dio.get(url, queryParams)
    Note right of Dio: GET /customsearch/v1<br/>?key=API_KEY<br/>&cx=ENGINE_ID<br/>&q=Taj+Mahal+panoramic+image<br/>&searchType=image<br/>&imgSize=HUGE

    Dio->>API: HTTPS Request
    API-->>Dio: 200 OK + JSON

    Dio-->>Screen: Response object
    Screen->>Screen: Parse response.data["items"]
    Screen->>Screen: setState(data: items)
    
    loop For each image result
        Screen->>Screen: Display CachedNetworkImage<br/>using item["link"]
    end
```

### Response Structure

```json
{
  "items": [
    {
      "title": "Panoramic view of Taj Mahal",
      "link": "https://example.com/tajmahal-panorama.jpg",
      "image": {
        "contextLink": "https://example.com/page",
        "thumbnailLink": "https://example.com/tajmahal-thumb.jpg",
        "width": 4000,
        "height": 2000
      }
    }
  ]
}
```

### Fields Used by the App

| Field | Usage |
|-------|-------|
| `items[].link` | Full-resolution image URL displayed in search results and loaded into PanoramaViewer |
| `items[].title` | (Available but currently unused) |

## Error Handling

```mermaid
stateDiagram-v2
    [*] --> FetchData

    state "API Call" as FetchData {
        [*] --> Requesting
        Requesting --> Success : 200 OK
        Requesting --> Failed : Network error / API error
    }

    Success --> RenderResults : Parse items array
    Failed --> ShowError : Display error.json Lottie

    state "UI States" as UIStates {
        RenderResults --> ImageGrid : Show cached images
        ShowError --> ErrorScreen : "Something went wrong"
    }
```

| State | UI | Trigger |
|-------|-----|---------|
| **Loading** | Lottie `loading2.json` animation | `fetchData()` called, `isLoading = true` |
| **Success** | Scrollable image grid | API returns valid items, `isLoading = false` |
| **Error** | Lottie `error.json` + error message | API call throws exception, `isError = true` |

## Rate Limits & Quotas

The Google Custom Search JSON API has the following limits:

| Tier | Queries/Day | Cost |
|------|------------|------|
| Free | 100 | Free |
| Paid | 10,000+ | $5 per 1,000 queries |

## Image Loading Pipeline

```mermaid
graph TD
    subgraph "Search Results"
        A["API returns image URLs"]
        B["CachedNetworkImage widget"]
        C["Memory Cache"]
        D["Disk Cache"]
        E["Network Fetch"]
    end

    subgraph "Panoramic Viewer"
        F["User taps image"]
        G["Image.network(url)"]
        H["PanoramaViewer renders 360"]
    end

    A --> B
    B --> C
    C -->|"miss"| D
    D -->|"miss"| E
    E -->|"download"| D
    D -->|"hit"| B
    C -->|"hit"| B

    F --> G
    G --> H

    style C fill:#90EE90
    style D fill:#90EE90
```

## Security Considerations

| Concern | Current State | Recommendation |
|---------|--------------|----------------|
| API Key exposure | Hardcoded in source | Move to environment variables or backend proxy |
| Search Engine ID | Hardcoded in source | Move to environment variables or backend proxy |
| HTTPS | All API calls use HTTPS | Maintain HTTPS-only communication |
| Input sanitization | Location name passed directly to query | Consider sanitizing user input before API calls |
