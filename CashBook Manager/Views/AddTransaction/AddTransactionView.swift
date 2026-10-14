import SwiftUI

struct AddTransactionView: View {
    var onSaved: () -> Void = {}
    @StateObject private var vm = AddTransactionViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Add Transaction")

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    kindToggle
                    AmountInputField(text: $vm.amountText, symbol: vm.symbol)

                    Text("Category")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                    categoryGrid

                    Divider()

                    DatePicker(selection: $vm.date, in: ...Date(), displayedComponents: .date) {
                        Text("Date").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.textPrimary)
                    }
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)

            PrimaryButton(title: "Save", isEnabled: vm.canSave) {
                vm.save()
                onSaved()
                dismiss()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Theme.background)
        .hideNavigationBar()
        .navigationDestination(isPresented: $vm.isPickingCategory) {
            CategorySelectionView(kind: vm.kind, selected: vm.category) { vm.category = $0 }
        }
    }

    private var kindToggle: some View {
        HStack(spacing: 12) {
            ForEach(TransactionKind.allCases) { kind in
                let selected = vm.kind == kind
                Button { vm.kind = kind } label: {
                    HStack(spacing: 6) {
                        Image(systemName: kind.icon).font(.system(size: 13, weight: .bold))
                        Text(kind.title).font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(selected ? Color.white : Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(selected ? Theme.primary : Theme.field, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var categoryGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 18) {
            ForEach(vm.gridCategories) { category in
                Button { vm.category = category } label: {
                    VStack(spacing: 8) {
                        CategoryBadge(category: category, size: 54, style: .soft)
                            .overlay {
                                if vm.category == category {
                                    Circle().stroke(category.color, lineWidth: 2.5).padding(-3)
                                }
                            }
                        Text(category.name)
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
            Button { vm.isPickingCategory = true } label: {
                VStack(spacing: 8) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(width: 54, height: 54)
                        .background(Theme.field, in: Circle())
                    Text("More").font(.system(size: 11)).foregroundStyle(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview { NavigationStack { AddTransactionView() } }
