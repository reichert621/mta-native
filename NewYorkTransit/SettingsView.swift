//
//  SettingsView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 3/1/24.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject var vm = ViewModel()

  var body: some View {
    NavigationStack {
      settings.navigationTitle("Settings")
    }
  }

  var settings: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("TODO: implement settings page")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.body)
        .foregroundColor(.secondary)
      Spacer()
    }.padding()
  }
}

#Preview {
  SettingsView()
}
