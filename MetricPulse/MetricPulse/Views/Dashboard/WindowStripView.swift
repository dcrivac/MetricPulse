import SwiftUI

struct WindowStripView: View {
    let logs: [MetricLog]

    private var days: [Date] {
        let today = Calendar.current.startOfDay(for: Date())
        return (0..<14).map { i in
            Calendar.current.date(byAdding: .day, value: -(13 - i), to: today)!
        }
    }

    private func log(for date: Date) -> MetricLog? {
        logs.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("14-Day Window (\(logs.count) shift\(logs.count == 1 ? "" : "s"))")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                ForEach(days, id: \.self) { day in
                    DayDot(log: log(for: day), isToday: Calendar.current.isDateInToday(day))
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct DayDot: View {
    let log: MetricLog?
    let isToday: Bool

    var body: some View {
        Circle()
            .fill(dotColor)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if isToday {
                    Circle().stroke(Color.primary, lineWidth: 2).padding(1)
                }
            }
    }

    private var dotColor: Color {
        guard let log else { return Color(.systemGray5) }
        return (log.ocr >= 0.9 && log.scr >= 0.9 && log.otm >= 0.85) ? .green : .orange
    }
}
