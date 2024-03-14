//
//  ViewModel.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 2/29/24.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
  @Published var stations: [Station] = []

  private let api = TransitApi()

  @MainActor
  func fetchDemoStations() async {
    do {
      let response = try await api.fetchStationsById(ids: ["52ed", "ec1f"])

      stations = response.data
    } catch {
      print(error.localizedDescription)
    }
  }

  @MainActor
  func fetchNearbyStations() async {
    do {
      // TODO: fetch by location!
      let response = try await api.fetchStationsById(ids: ["ec1f"])

      stations = response.data
    } catch {
      print(error.localizedDescription)
    }
  }

  @MainActor
  func fetchStationsByLocation(latitude: Double, longitude: Double) async {
    do {
      let response = try await api.fetchStationsByLocation(latitude: latitude, longitude: longitude)

      stations = response.data
    } catch {
      print(error.localizedDescription)
    }
  }
}
