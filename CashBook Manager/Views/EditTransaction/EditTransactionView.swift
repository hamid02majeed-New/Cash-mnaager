import SwiftUI

struct EditTransactionView: View {
    @StateObject private var vm: EditTransactionViewModel
    @Environment(\.dismiss) private var dismiss

    init(transactionID: UUID) {
        _vm = StateObject(wrappedValue: EditTransactionViewModel(id: transactionID))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Edit Transaction")

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    categoryRow
                    AmountInputField(text: $vm.amountText, symbol: vm.symbol, style: .outlined)
                    dateRow

                    Text("Notes (Optional)")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textSecondary)
                    TextEditor(text: $vm.note)
                        .font(.system(size: 15))
                        .scrollContentBackground(.hidden)
                        .padding(10)
                        .frame(height: 110)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)

            VStack(spacing: 6) {
                PrimaryButton(title: "Save", isEnabled: vm.canSave) {
                    if vm.save() { dismiss() }
                }
                Button("Delete") { vm.showDeleteConfirm = true }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.expense)
                    .frame(height: 44)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Theme.background)
        .hideNavigationBar()
        .navigationDestination(isPresented: $vm.isPickingCategory) {
            CategorySelectionView(kind: vm.kind, selected: vm.category) { vm.category = $0 }
        }
        .confirmationDialog("Delete this transaction?", isPresented: $vm.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                vm.delete()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action can't be undone.")
        }
        .onAppear { if !vm.exists { dismiss() } }
    }

    private var categoryRow: some View {
        Button { vm.isPickingCategory = true } label: {
            HStack(spacing: 12) {
                CategoryBadge(category: vm.category, size: 44)
                Text(vm.category.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var dateRow: some View {
        DatePicker(selection: $vm.date, in: ...Date(), displayedComponents: .date) {
            Label("Date", systemImage: "calendar")
                .font(.system(size: 15))
                .foregroundStyle(Theme.textPrimary)
        }
        .padding(.horizontal, 14)
        .frame(height: 56)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
    }
}
