import SwiftUI
import SwiftData

struct TimelineView: View {
    @Query(sort: \MetricLog.date, order: .reverse) private var logs: [MetricLog]
    @Query private var tiers: [TierConfig]
    @State private var selectedLog: MetricLog?

    private var premier: TierConfig? {
        tiers.sorted { $0.sortOrder < $1.sortOrder }.first
    }

    var body: some View {
        NavigationStack {
            List {
                TimelineHeaderRow()
                ForEach(logs) { log in
                    TimelineDayRow(log: log, tier: premier)
                        .contentShape(Rectangle())
                        .onTapGesture { selectedLog = log }
                }
                .onDelete(perform: deleteLogs)
            }
            .listStyle(.plain)
            .navigationTitle("Timeline")
            .toolbar {
                EditButton()
            }
        }
        .sheet(item: $selectedLog) { log in
            DayDetailSheet(log: log, tier: premier)
        }
    }

    @Environment(\.modelContext) private var modelContext

    private func deleteLogs(at offsets: IndexSet) {
        for i in offsets { modelContext.delete(logs[i]) }
    }
}
