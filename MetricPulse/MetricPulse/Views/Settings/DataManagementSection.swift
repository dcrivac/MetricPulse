import SwiftUI
import SwiftData

struct DataManagementSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var logs: [MetricLog]
    @State private var confirmDelete = false
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        Section("Data") {
            Button("Export CSV") { exportCSV() }
            Button("Delete All Data", role: .destructive) { confirmDelete = true }
        }
        .confirmationDialog("Delete all shift logs?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete All", role: .destructive) { deleteAll() }
        } message: {
            Text("This cannot be undone.")
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(items: shareItems)
        }
    }

    private func deleteAll() {
        logs.forEach { modelContext.delete($0) }
        try? modelContext.save()
    }

    private func exportCSV() {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        var rows = ["Date,OCR,SCR,OTM,Earnings"]
        for log in logs.sorted(by: { $0.date < $1.date }) {
            let earn = log.earnings.map { String(format: "%.2f", $0) } ?? ""
            rows.append("\(fmt.string(from: log.date)),\(Int(log.ocr*100))%,\(Int(log.scr*100))%,\(Int(log.otm*100))%,\(earn)")
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("MetricPulse_export.csv")
        try? rows.joined(separator: "\n").write(to: url, atomically: true, encoding: .utf8)
        shareItems = [url]
        showShare = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
