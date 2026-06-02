import SwiftUI
import SwiftData

@Observable
final class LogEntryViewModel {
    var date: Date = .now
    var ordersOffered: Int = 0
    var ordersCompleted: Int = 0
    var scheduledMinutes: Int = 60
    var workedMinutes: Int = 60
    var deliveries: Int = 0
    var onTimeDeliveries: Int = 0
    var earningsText: String = ""

    var ocr: Double {
        ordersOffered > 0 ? Double(ordersCompleted) / Double(ordersOffered) : 1.0
    }
    var scr: Double {
        scheduledMinutes > 0 ? min(1.0, Double(workedMinutes) / Double(scheduledMinutes)) : 1.0
    }
    var otm: Double {
        deliveries > 0 ? Double(onTimeDeliveries) / Double(deliveries) : 1.0
    }
    var earningsCents: Int? {
        Double(earningsText.filter { $0.isNumber || $0 == "." }).map { Int($0 * 100) }
    }

    func reset() {
        date = .now
        ordersOffered = 0; ordersCompleted = 0
        scheduledMinutes = 60; workedMinutes = 60
        deliveries = 0; onTimeDeliveries = 0
        earningsText = ""
    }
}

struct LogEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tiers: [TierConfig]
    @State private var vm = LogEntryViewModel()
    @State private var showSaved = false

    private var premier: TierConfig? { tiers.sorted { $0.sortOrder < $1.sortOrder }.first }

    var body: some View {
        NavigationStack {
            Form {
                Section("Date") {
                    DatePicker("Shift date", selection: $vm.date, displayedComponents: .date)
                        .labelsHidden()
                }

                Section("OCR — Order Completion Rate") {
                    StepperRow(label: "Orders Offered", subtitle: "Total dispatched to you", value: $vm.ordersOffered)
                    StepperRow(label: "Completed", subtitle: "Delivered successfully",
                               value: $vm.ordersCompleted, range: 0...max(vm.ordersOffered, 0))
                }

                Section("SCR — Schedule Compliance") {
                    StepperRow(label: "Scheduled (min)", subtitle: "Your block length",
                               value: $vm.scheduledMinutes, range: 0...480)
                    StepperRow(label: "Worked (min)", subtitle: "Time actually active",
                               value: $vm.workedMinutes, range: 0...max(vm.scheduledMinutes, 0))
                }

                Section("OTM — On Time or More") {
                    StepperRow(label: "Total Deliveries", subtitle: "Completed drops", value: $vm.deliveries)
                    StepperRow(label: "On Time", subtitle: "Arrived on time or early",
                               value: $vm.onTimeDeliveries, range: 0...max(vm.deliveries, 0))
                }

                Section("Earnings (optional)") {
                    HStack {
                        Text("$").foregroundStyle(.secondary)
                        TextField("0.00", text: $vm.earningsText).keyboardType(.decimalPad)
                    }
                }

                Section {
                    HStack(spacing: 12) {
                        RatePreview(label: "OCR", value: vm.ocr, threshold: premier?.minOCR ?? 0.9)
                        RatePreview(label: "SCR", value: vm.scr, threshold: premier?.minSCR ?? 0.9)
                        RatePreview(label: "OTM", value: vm.otm, threshold: premier?.minOTM ?? 0.85)
                        Spacer()
                    }
                } header: { Text("Live Preview") }
            }
            .navigationTitle("Log Shift")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(vm.ordersOffered == 0 && vm.deliveries == 0)
                }
            }
            .overlay {
                if showSaved { SavedOverlay() }
            }
        }
    }

    private func save() {
        modelContext.insert(MetricLog(
            date: vm.date,
            ordersOffered: vm.ordersOffered, ordersCompleted: vm.ordersCompleted,
            scheduledMinutes: vm.scheduledMinutes, workedMinutes: vm.workedMinutes,
            deliveries: vm.deliveries, onTimeDeliveries: vm.onTimeDeliveries,
            earningsCents: vm.earningsCents
        ))
        try? modelContext.save()
        vm.reset()
        showSaved = true
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            showSaved = false
        }
    }
}

private struct SavedOverlay: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)
            Text("Shift Saved").font(.headline)
        }
        .padding(36)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 12)
    }
}
