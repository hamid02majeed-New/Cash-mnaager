import SwiftUI

struct DataPrivacyView: View {
    @StateObject private var vm = DataPrivacyViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Data & Privacy")
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your data is stored only on this device. Nothing is uploaded or shared.")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textSecondary)

                    ShareLink(item: vm.export, preview: SharePreview("Pocket Transactions.csv")) {
                        actionRow(icon: "square.and.arrow.up", title: "Export as CSV",
                                  subtitle: "\(vm.count) transactions", color: Theme.textPrimary)
                    }
                    .disabled(!vm.hasData)
                    .opacity(vm.hasData ? 1 : 0.4)

                    Button(action: vm.loadSamples) {
                        actionRow(icon: "wand.and.stars", title: "Load Sample Data",
                                  subtitle: "Add demo transactions to explore the app", color: Theme.textPrimary)
                    }

                    Button { vm.showEraseConfirm = true } label: {
                        actionRow(icon: "trash", title: "Erase All Data",
                                  subtitle: "Delete every transaction and your budget", color: Theme.expense)
                    }
                }
                .padding(16)
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
        .confirmationDialog("Erase all data?", isPresented: $vm.showEraseConfirm, titleVisibility: .visible) {
            Button("Erase Everything", role: .destructive, action: vm.eraseAll)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes all transactions and your budget.")
        }
    }

    private func actionRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).font(.system(size: 18)).frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .semibold))
                Text(subtitle).font(.system(size: 12)).foregroundStyle(Theme.textSecondary)
            }
            Spacer()
        }
        .foregroundStyle(color)
        .padding(14)
        .background(Theme.field, in: RoundedRectangle(cornerRadius: 14))
        .contentShape(Rectangle())
    }
}
