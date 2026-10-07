//
//  ActivityRankingView.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import SwiftUI
import Combine

struct ActivityRankingView: View {

    let city: City
    let repository: WeatherRepository

    @StateObject private var viewModel: ActivityRankingViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    init(
        city: City,
        repository: WeatherRepository,
        networkMonitor: NetworkMonitor,
        calculator: ActivityScoreCalculating
    ) {

        self.city = city
        self.repository = repository

        _viewModel = StateObject(
            wrappedValue: ActivityRankingViewModel(
                city: city,
                repository: repository,
                networkMonitor: networkMonitor,
                calculator: calculator
            )
        )
    }

    var body: some View {

        Group {

            if viewModel.isLoading {

                ProgressView("Loading forecast...")

            }
            else if let errorMessage = viewModel.networkErrorMessage {
                ContentUnavailableView(
                    "Network Error",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
                
            }else if let error = viewModel.errorMessage {

                VStack(spacing: 12) {

                    Text(error)

                    Button("Retry") {
                        Task {
                            await viewModel.load()
                        }
                    }
                }

            } else {

                List(viewModel.rankings, id: \.activity) { ranking in

                    HStack {

                        Text(ranking.activity.emoji)
                            .font(.title)

                        VStack(alignment: .leading) {

                            Text(ranking.activity.title)
                                .font(.headline)

                            Text(scoreDescription(
                                ranking.overallScore
                            ))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("\(ranking.overallScore)")
                            .font(.title2)
                            .bold()
                    }
                }
            }
        }
        .navigationTitle(city.name)
        .task {
            await viewModel.load()
        }
    }

    private func scoreDescription(
        _ score: Int
    ) -> String {

        switch score {
        case 80...:
            return "Great"
        case 60..<80:
            return "Good"
        case 40..<60:
            return "Fair"
        default:
            return "Poor"
        }
    }
}
