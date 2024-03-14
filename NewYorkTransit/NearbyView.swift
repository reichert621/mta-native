//
//  NearbyView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 3/1/24.
//

import CoreLocation
import CoreLocationUI
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  let manager = CLLocationManager()

  @Published var location: CLLocationCoordinate2D?

  override init() {
    super.init()
    manager.delegate = self
  }

  func requestLocation() {
    manager.requestLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    location = locations.first?.coordinate
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error! \(error.localizedDescription)")
  }
}

struct NearbyView: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject var vm = ViewModel()
  @StateObject var lm = LocationManager()

  var body: some View {
    NavigationStack {
      list.navigationTitle("Nearby")
    }
  }

  var list: some View {
    if let location = lm.location {
      return AnyView(VStack(alignment: .leading, spacing: 0) {
        ScrollView {
          ForEach(vm.stations) { station in
            StationView(station: station)
              .padding(16)
          }
        }
      }
      .task {
        print("Your location: \(location.latitude), \(location.longitude)")
        await vm.fetchStationsByLocation(latitude: location.latitude, longitude: location.longitude)

      })
    } else {
      return AnyView(VStack {
        Text("Please share your location to view nearby stations.")
          .padding()
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)

        LocationButton(.shareCurrentLocation) {
          lm.requestLocation()
        }
        .symbolVariant(.fill)
        .cornerRadius(16)
      })
    }
  }
}

#Preview {
  NearbyView()
}
