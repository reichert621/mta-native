//
//  NewYorkTransitApp.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 2/29/24.
//

import SwiftUI

@main
struct NewYorkTransitApp: App {
  var body: some Scene {
    WindowGroup {
      TabView {
        ContentView()
          .tabItem {
            Label("Trains", systemImage: "tram")
          }
        NearbyView()
          .tabItem {
            Label("Nearby", systemImage: "location.circle")
          }
        SettingsView()
          .tabItem {
            Label("Settings", systemImage: "gearshape")
          }
      }
    }
  }
}
