//
//  ContentView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 2/29/24.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject var vm = ViewModel()

  var body: some View {
    NavigationStack {
      list.navigationTitle("Trains")
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
      await vm.fetchDemoStations()
    }
  }
}

#Preview {
  ContentView()
}
