//
//  ScheduleRowView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 3/1/24.
//

import SwiftUI

struct ScheduleRowView: View {
  @Environment(\.colorScheme) private var colorScheme
  let schedule: StationSchedule

  var body: some View {
    HStack {
      VStack {
        Text(schedule.route)
          .foregroundStyle(getRouteTextColor(route: schedule.route))
          .font(.system(size: 12))
          .bold()
          .padding(10)
          .background(
            Circle().foregroundColor(
              getRouteBgColor(route: schedule.route)
            )
          )
      }

      Text(formattedArrivalTime(schedule.time))
        .foregroundStyle(.primary)
        .opacity(0.8)
        .font(.system(size: 14))
      Spacer()
      Text(formatDateTime(schedule.time))
        .foregroundStyle(.secondary)
        .opacity(0.8)
        .font(.system(size: 14))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  func getRouteTextColor(route: String) -> Color {
    switch route {
    case "N", "Q", "R", "W": .black
    default: .white
    }
  }

  func getRouteBgColor(route: String) -> Color {
    // TODO: use official MTA colors
    switch route {
    case "N", "Q", "R", "W": .yellow
    case "B", "D", "F", "M": .orange
    case "A", "C", "E": .blue
    case "G": .green
    default: .gray
    }
  }

  func formatDateTime(_ ts: String) -> String {
    let input = DateFormatter()
    input.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

    if let date = input.date(from: ts) {
      let output = DateFormatter()
      output.dateFormat = "h:mm a"

      return output.string(from: date)
    } else {
      return ts
    }
  }

  func formattedArrivalTime(_ ts: String) -> String {
    let mins = calculateMinsAway(ts)

    if mins == 1 {
      return "1 min away"
    } else {
      return "\(mins) mins away"
    }
  }

  func calculateMinsAway(_ ts: String) -> Int {
    let input = DateFormatter()
    input.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

    if let date = input.date(from: ts) {
      let current = Date()
      let seconds = Int(date.timeIntervalSince(current))

      return seconds / 60
    } else {
      // TODO: handle failures better
      return 0
    }
  }
}

#Preview {
  let schedule = StationSchedule(route: "Q", time: "2024-03-01T11:15:45-05:00")

  return ScheduleRowView(schedule: schedule).padding()
}
