//
//  ScheduleRowView.swift
//  NewYorkTransit
//
//  Created by Alex Reichert on 3/1/24.
//

import SwiftUI

struct ScheduleRowView: View {
  @Environment(\.colorScheme) private var colorScheme
  @ScaledMetric private var circleDiameter = 32.0
  let schedule: StationSchedule

  var body: some View {
    HStack {
      VStack {
        ZStack {
          Circle().foregroundColor(
            getRouteBgColor(route: schedule.route)
          ).frame(height: circleDiameter)

          Text(schedule.route)
            .foregroundStyle(getRouteTextColor(route: schedule.route))
            .font(.callout)
            .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
        }
      }

      Text(schedule.formattedRelativeTime())
        .foregroundStyle(.primary)
        .font(.callout)
        .monospacedDigit()

      Spacer()
      Text(schedule.formattedArrivalTime())
        .foregroundStyle(.secondary)
        .font(.callout)
        .monospacedDigit()
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
}

func getDateFromNow(mins: Int) -> Date {
  let now = Date()
  let dateComponents = DateComponents(minute: mins)

  return Calendar.current.date(byAdding: dateComponents, to: now)!
}

#Preview {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

  return VStack {
    ScheduleRowView(schedule: StationSchedule(
      route: "Q",
      time: dateFormatter.string(from: getDateFromNow(mins: 5)))
    )
    ScheduleRowView(schedule: StationSchedule(
      route: "W",
      time: dateFormatter.string(from: getDateFromNow(mins: 7)))
    )
    ScheduleRowView(schedule: StationSchedule(
      route: "B",
      time: dateFormatter.string(from: getDateFromNow(mins: 13)))
    )

  }.padding()
}
