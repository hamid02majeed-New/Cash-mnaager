import SwiftUI

struct CategorySelectionView: View {
    let onSelect: (Category) -> Void
    @StateObject private var vm: CategorySelectionViewModel
    @Environment(\.dismiss) private var dismiss

    init(kind: TransactionKind, selected: Category?, onSelect: @escaping (Category) -> Void) {
        _vm = StateObject(wrappedValue: CategorySelectionViewModel(kind: kind, selectedID: selected?.id))
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Select Category")
            SearchField(text: $vm.query, placeholder: "Search category...")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(vm.categories) { category in
                        Button {
                            onSelect(category)
                            dismiss()
                        } label: {
                            HStack(spacing: 14) {
                                CategoryBadge(category: category, size: 40)
                                Text(category.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Theme.textPrimary)
                                Spacer()
                                if category.id == vm.selectedID {
                                    Image(systemName: "checkmark").foregroundStyle(Theme.primary)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 70)
                    }
                    if vm.categories.isEmpty {
                        EmptyStateView(icon: "magnifyingglass", title: "No categories found",
                                       message: "Try a different search term.")
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Theme.background)
        .hideNavigationBar()
    }
}
