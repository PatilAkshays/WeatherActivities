# Weather Activities
An iOS weather-based activity recommendation app that uses Open-Meteo APIs to suggest activities such as skiing, surfing, outdoor sightseeing, and indoor sightseeing based on forecast conditions. Built with Swift, SwiftUI, MVVM, and unit-tested rule-based activity scoring.

Native iOS application that searches for a city and ranks
the next 7 days based on suitability for:

- Skiing
- Surfing
- Outdoor sightseeing
- Indoor sightseeing

## Requirements

- iOS 17+
- Xcode 26+
- Swift 6

## Architecture

SwiftUI
    ↓
ViewModel
    ↓
Repository
    ↓
API Client
    ↓
Open-Meteo

Business rules are isolated inside
ActivityScoreCalculator.

## APIs

Open-Meteo Geocoding API
Open-Meteo Forecast API

No backend is required.

## How to Run

1. Clone repository
2. Open WeatherActivities.xcodeproj
3. Select an iOS simulator
4. Build and run

No API key is required.

## Suitability Algorithm

Each activity receives a score from 0–100.

The score is calculated from the next seven days
of forecast data.

### Skiing

Factors:

- Snowfall
- Temperature
- Precipitation
- Wind

### Surfing

Factors:

- Temperature
- Wind
- Precipitation

### Outdoor Sightseeing

Factors:

- Temperature
- Rain
- Wind

### Indoor Sightseeing

Factors:

- Rain
- Temperature extremes
- Wind

## Important Assumption

The Open-Meteo forecast does not provide full surf
conditions such as swell height, swell period and
wave direction.

Therefore surfing suitability represents general
weather suitability rather than actual surf quality.

## Trade-offs

I chose URLSession instead of a third-party networking
library because the application has a small API surface
and native URLSession provides async/await support.

I chose MVVM with a repository abstraction to keep
networking and business logic out of SwiftUI views.

I intentionally avoided introducing a persistence layer
because the requirements do not require offline support.

## Testing

Unit tests cover:

- Activity scoring
- Edge cases
- Repository failures
- ViewModel error handling

## AI Usage

AI tools were used for:

- Exploring API response structures
- Generating initial model/code drafts
- Reviewing possible architecture approaches
- Identifying edge cases

All AI-generated code was reviewed and tested manually.
Business rules and final architectural decisions were
validated against the Open-Meteo API documentation.
