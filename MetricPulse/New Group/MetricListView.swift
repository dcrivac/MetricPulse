import SwiftUI
import SwiftData

struct MetricListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Metric.timestamp, order: .reverse) private var metrics: [Metric]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(metrics) { metric in
                    NavigationLink {
                        MetricDetailView(metric: metric)
                    } label: {
                        MetricRow(metric: metric)
                    }
                }
                .onDelete(perform: deleteMetrics)
            }
            .navigationTitle("Metrics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem {
                    Button { addMetric() } label: {
                        Label("Add Metric", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a metric")
                .foregroundStyle(.secondary)
        }
    }

    private func addMetric() {
        withAnimation {
            modelContext.insert(Metric(name: "New Metric", value: 0, unit: ""))
        }
    }

    private func deleteMetrics(offsets: IndexSet) {
        withAnimation {
            for index in offsets { modelContext.delete(metrics[index]) }
        }
    }
}

private struct MetricRow: View {
    let metric: Metric

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(metric.name)
                .font(.headline)
            Text("\(metric.value, specifier: "%.2f") \(metric.unit)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

private struct MetricDetailView: View {
    let metric: Metric

    var body: some View {
        VStack(spacing: 12) {
            Text("\(metric.value, specifier: "%.2f") \(metric.unit)")
                .font(.system(size: 48, weight: .semibold, design: .rounded))
            Text(metric.timestamp, style: .date)
                .foregroundStyle(.secondary)
        }
        .navigationTitle(metric.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    MetricListView()
        .modelContainer(for: Metric.self, inMemory: true)
}
