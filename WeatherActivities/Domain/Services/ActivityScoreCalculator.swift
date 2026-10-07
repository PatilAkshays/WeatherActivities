//
//  ActivityScoreCalculator.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

struct DailyWeather {
    let temperatureMax: Double
    let temperatureMin: Double
    let precipitationProbability: Double
    let precipitation: Double
    let windSpeed: Double
    let snowfall: Double
}

struct ActivityScore {
    let activity: Activity
    let score: Int
}

struct ActivityRanking {
    let activity: Activity
    let dailyScores: [Int]

    var overallScore: Int {
        guard !dailyScores.isEmpty else {
            return 0
        }

        return dailyScores.reduce(0, +) / dailyScores.count
    }
}

protocol ActivityScoreCalculating {
    func score(
        activity: Activity,
        weather: DailyWeather
    ) -> Int
}


struct ActivityScoreCalculator: ActivityScoreCalculating {

    func score(
        activity: Activity,
        weather: DailyWeather
    ) -> Int {

        switch activity {

        case .skiing:
            return skiingScore(weather)

        case .surfing:
            return surfingScore(weather)

        case .outdoorSightseeing:
            return outdoorScore(weather)

        case .indoorSightseeing:
            return indoorScore(weather)
        }
    }

    private func skiingScore(
        _ weather: DailyWeather
    ) -> Int {

        var score = 0

        // Cold weather
        if weather.temperatureMin <= 2 || weather.temperatureMax <= 2 {
            score += 30
        } else if weather.temperatureMin <= 7 || weather.temperatureMax <= 7 {
            score += 15
        }

        // Snow
        if weather.snowfall >= 5 {
            score += 40
        } else if weather.snowfall > 0 {
            score += 25
        }

        // Low precipitation
        if weather.precipitationProbability < 30 {
            score += 15
        }

        // Moderate wind
        if weather.windSpeed < 30 {
            score += 15
        }

        return min(score, 100)
    }

    private func surfingScore(
        _ weather: DailyWeather
    ) -> Int {

        var score = 0

        // Comfortable temperature
        if weather.temperatureMax >= 15 {
            score += 30
        } else if weather.temperatureMax >= 10 {
            score += 20
        }

        // Moderate wind
        if weather.windSpeed >= 10 &&
            weather.windSpeed <= 30 {
            score += 30
        } else if weather.windSpeed < 40 {
            score += 15
        }

        // Low rain
        if weather.precipitationProbability < 30 {
            score += 25
        } else if weather.precipitationProbability < 60 {
            score += 10
        }

        // Extreme wind penalty
        if weather.windSpeed > 50 {
            score -= 30
        }

        return max(0, min(score, 100))
    }

    private func outdoorScore(
        _ weather: DailyWeather
    ) -> Int {

        var score = 100

        if weather.precipitationProbability > 70 {
            score -= 40
        } else if weather.precipitationProbability > 40 {
            score -= 20
        }

        if weather.windSpeed > 40 {
            score -= 30
        } else if weather.windSpeed > 25 {
            score -= 15
        }

        if weather.temperatureMax < 5 {
            score -= 20
        }

        if weather.temperatureMax > 35 {
            score -= 20
        }

        return max(0, min(score, 100))
    }

    private func indoorScore(
        _ weather: DailyWeather
    ) -> Int {

        var score = 50

        if weather.precipitationProbability > 60 {
            score += 30
        }

        if weather.temperatureMax < 5 ||
            weather.temperatureMax > 35 {
            score += 15
        }

        if weather.windSpeed > 40 {
            score += 10
        }

        return min(score, 100)
    }
}

