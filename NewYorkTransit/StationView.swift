//
//  StationView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 3/1/24.
//

import SwiftUI

struct StationView: View {
  @Environment(\.colorScheme) private var colorScheme
  let station: Station

  var body: some View {
    VStack(spacing: 8) {
      Text(station.name)
        .font(.system(size: 20))
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)

      Text("Northbound")
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
        .foregroundStyle(.secondary)
        .font(.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 0) {
        ForEach(station.N) { schedule in
          ScheduleRowView(schedule: schedule)
        }
      }

      Text("Southbound")
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
        .foregroundStyle(.secondary)
        .font(.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 0) {
        ForEach(station.S) { schedule in
          ScheduleRowView(schedule: schedule)
        }
      }
    }
  }
}

#Preview {
  let station = Station(
    id: "abc",
    name: "DeKalb",
    routes: ["B", "Q"],
    N: [StationSchedule(route: "Q", time: "2024-03-01T12:30:45-05:00")],
    S: [StationSchedule(route: "B", time: "2024-03-01T12:35:40-05:00")]
  )

  return StationView(station: station).padding()
}
