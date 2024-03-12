//
//  NearbyView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 3/1/24.
//

import SwiftUI

struct NearbyView: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject var vm = ViewModel()

  var body: some View {
    NavigationStack {
      list.navigationTitle("Nearby")
    }
  }

  var list: some View {
    VStack(alignment: .leading, spacing: 0) {
      ScrollView {
        ForEach(vm.stations) { station in
          StationView(station: station)
            .padding(16)
        }
      }
    }
    .task {
      await vm.fetchNearbyStations()
    }
  }
}

#Preview {
  NearbyView()
}
