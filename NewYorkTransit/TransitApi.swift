//
//  TransitApi.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 2/29/24.
//

import Foundation

let DEFAULT_FAVORITES = [
  [
    "id": "52ed",
    "location": [40.690635, -73.981824],
    "name": "DeKalb Av",
    "active": true,
    "rank": 1,
    "routes": ["B", "Q", "R"]
  ],
  [
    "id": "ec1f",
    "location": [40.688484, -73.985001],
    "name": "Hoyt-Schermerhorn Sts",
    "active": true,
    "rank": 2,
    "routes": ["C", "G", "A"]
  ]
]

class TransitApi {
  private let session = URLSession.shared
  private let baseURL = URL(string: "https://mta-api.fly.dev")

  func fetchStationsById(ids: [String]) async throws -> StationsResponse {
    let url = baseURL!.appendingPathComponent("/api/stations/\(ids.joined(separator: ","))")
    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      print("Invalid response")
      throw "Invalid response"
    }

    guard 200 ... 299 ~= httpResponse.statusCode else {
      print("Bad Response: \(httpResponse.statusCode)")
      throw "Bad Response: \(httpResponse.statusCode)"
    }

    let result = try JSONDecoder().decode(StationsResponse.self, from: data)

    return result
  }

  func fetchAllRoutes() async throws -> RoutesResponse {
    let url = baseURL!.appendingPathComponent("/api/routes")

    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      print("Invalid response")
      throw "Invalid response"
    }

    guard 200 ... 299 ~= httpResponse.statusCode else {
      print("Bad Response: \(httpResponse.statusCode)")
      throw "Bad Response: \(httpResponse.statusCode)"
    }

    let result = try JSONDecoder().decode(RoutesResponse.self, from: data)

    return result
  }

  func fetchStationsByLocation(latitude: Double, longitude: Double) async throws -> StationsResponse {
    var urlComponents = URLComponents(url: baseURL!.appendingPathComponent("/api/stations"), resolvingAgainstBaseURL: false)!
    let queryItems = [
      URLQueryItem(name: "latitude", value: "\(latitude)"),
      URLQueryItem(name: "longitude", value: "\(longitude)"),
      URLQueryItem(name: "limit", value: "5")
    ]
    urlComponents.queryItems = queryItems

    guard let url = urlComponents.url else {
      throw "Invalid url"
    }

    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      print("Invalid response")
      throw "Invalid response"
    }

    guard 200 ... 299 ~= httpResponse.statusCode else {
      print("Bad Response: \(httpResponse.statusCode)")
      throw "Bad Response: \(httpResponse.statusCode)"
    }

    let result = try JSONDecoder().decode(StationsResponse.self, from: data)

    return result
  }
}

extension String: Error {}

struct StationsResponse: Decodable {
  let data: [Station]
}

struct Station: Decodable, Identifiable {
  let id: String
  let name: String
  let routes: [String]

  let N: [StationSchedule]
  let S: [StationSchedule]
}

struct StationSchedule: Decodable, Identifiable {
  // FIXME: warning
  let id = UUID()

  let route: String
  let time: String

  // TODO: where should these functions live?

  func datetime() -> Date {
    let input = DateFormatter()
    input.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

    return input.date(from: time)!
  }

  func calculateMinsAway() -> Int {
    let date = datetime()
    let current = Date()
    let seconds = Int(date.timeIntervalSince(current))

    return seconds / 60
  }

  func formattedRelativeTime() -> String {
    let mins = calculateMinsAway()

    if mins == 1 {
      return "1 min away"
    } else {
      return "\(mins) mins away"
    }
  }

  func formattedArrivalTime() -> String {
    let date = datetime()
    let output = DateFormatter()
    output.dateFormat = "h:mm a"

    return output.string(from: date)
  }
}

struct RoutesResponse: Decodable {
  let data: [String]
}
