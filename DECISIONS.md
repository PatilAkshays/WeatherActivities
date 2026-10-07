# Engineering Decisions

## 1. Why SwiftUI?

SwiftUI provides a concise declarative UI and works well
for this relatively small application.

UIKit was not necessary because there were no requirements
that required UIKit-specific functionality.

## 2. Why MVVM?

The application contains asynchronous API operations
and non-trivial state.

MVVM keeps view rendering separate from state management.

## 3. Why Repository?

The ViewModels should not know whether data comes from
Open-Meteo, a cache, or a mock.

This also makes testing easier.

## 4. Why URLSession?

Only two APIs are required.

Adding Alamofire would increase dependencies without
providing enough benefit for this scope.

## 5. Why No Database?

There is no offline requirement.

Adding Realm/Core Data would increase complexity without
solving a stated problem.

## 6. Why Heuristic Scoring?

The exercise doesn't define suitability criteria.

I chose explicit heuristic rules so that:

- scores are explainable
- rules are testable
- behavior can be changed independently
- product stakeholders can easily adjust thresholds

## 7. Seven-Day Ranking

Each day receives a score.

The activity's overall score is the average of its
seven daily scores.

This prevents a single unusually good day from
dominating the entire recommendation.
