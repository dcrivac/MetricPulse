import SwiftUI

struct TimelineHeaderRow: View {
    var body: some View {
        HStack {
            Text("Date").frame(maxWidth: .infinity, alignment: .leading)
            Text("OCR").frame(width: 54, alignment: .center)
            Text("SCR").frame(width: 54, alignment: .center)
            Text("OTM").frame(width: 54, alignment: .center)
        }
        .font(.caption.bold())
        .foregroundStyle(.secondary)
        .listRowBackground(Color(.systemGroupedBackground))
    }
}
