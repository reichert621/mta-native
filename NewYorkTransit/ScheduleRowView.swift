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
    case "N", "Q", "R", "W": Color(hex: 0xFCCC0A)
    case "B", "D", "F", "M": Color(hex: 0xFF6319)
    case "A", "C", "E": Color(hex: 0x0039A6)
    case "G": Color(hex: 0x6CBE45)
    default: .gray
    }
  }
}

func getDateFromNow(mins: Int) -> Date {
  let now = Date()
  let dateComponents = DateComponents(minute: mins)

  return Calendar.current.date(byAdding: dateComponents, to: now)!
}

func getMtaColor(name: String) -> Color {
  switch name {
  case "red": Color(hex: 0xEE352E)
  case "orange": Color(hex: 0xFF6319)
  case "yellow": Color(hex: 0xFCCC0A)
  case "light-green": Color(hex: 0x6CBE45)
  case "dark-green": Color(hex: 0x00933C)
  case "blue": Color(hex: 0x0039A6)
  case "purple": Color(hex: 0xB933AD)
  case "light-gray": Color(hex: 0xA7A9AC)
  case "dark-gray": Color(hex: 0x808183)
  case "brown": Color(hex: 0x996633)
  default: Color.gray
  }
}

extension Color {
  init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0xFF00) >> 8) / 255.0
    let blue = Double((hex & 0xFF) >> 0) / 255.0

    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
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
