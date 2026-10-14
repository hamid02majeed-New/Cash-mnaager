import Combine
import SwiftUI
import UniformTypeIdentifiers

struct CSVExport: Transferable {
    let csv: String

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .commaSeparatedText) { export in
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("Pocket-Transactions.csv")
            try export.csv.write(to: url, atomically: true, encoding: .utf8)
            return SentTransferredFile(url)
        }
    }
}

final class DataPrivacyViewModel: StoreViewModel {
    @Published var showEraseConfirm = false

    var count: Int { store.transactions.count }
    var hasData: Bool { count > 0 }

    var export: CSVExport {
        var lines = ["Date,Type,Category,Amount,Note"]
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withFullDate]
        for t in store.transactions.sorted(by: { $0.date < $1.date }) {
            let note = t.note.replacingOccurrences(of: "\"", with: "\"\"")
            lines.append("\(iso.string(from: t.date)),\(t.kind.title),\(t.category.name),\(t.amount),\"\(note)\"")
        }
        return CSVExport(csv: lines.joined(separator: "\n"))
    }

    func loadSamples() { store.loadSampleData() }
    func eraseAll() {
        store.removeAllTransactions()
        store.monthlyBudget = 0
    }
}
