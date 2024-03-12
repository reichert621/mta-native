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
}

struct RoutesResponse: Decodable {
  let data: [String]
}
