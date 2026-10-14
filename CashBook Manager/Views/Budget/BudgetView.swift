import SwiftUI

struct BudgetView: View {
    @StateObject private var vm = BudgetViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Monthly Budget")

            ScrollView {
                VStack(spacing: 20) {
                    setBudgetCard
                    progressSection
                    illustration
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Theme.background)
        .hideNavigationBar()
    }

    private var setBudgetCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Set Your Monthly Budget")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Stay on track and reach your goals.")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textSecondary)
            }
            AmountInputField(text: $vm.budgetText, symbol: vm.symbol)
            PrimaryButton(title: vm.justSaved ? "Saved ✓" : "Save", isEnabled: vm.canSave, action: vm.save)
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Budget Progress").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.textPrimary)
                Spacer()
                Text(vm.percentText).font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.textSecondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.field)
                    Capsule()
                        .fill(vm.isOver ? Theme.expense : Theme.primary)
                        .frame(width: geo.size.width * vm.progress)
                }
            }
            .frame(height: 10)
            HStack {
                Text("\(vm.money(vm.spent)) spent")
                Spacer()
                Text(vm.isOver ? "\(vm.money(vm.spent - vm.budget)) over" : "\(vm.money(vm.remaining)) left")
            }
            .font(.system(size: 11))
            .foregroundStyle(Theme.textSecondary)
        }
        .padding(.horizontal, 4)
    }

    private var illustration: some View {
        VStack(spacing: 12) {
            ZStack {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(Theme.primary)
                Image(systemName: "centsign.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(Color(hex: 0xFFB400))
                    .offset(x: 30, y: 24)
            }
            Text(vm.footerMessage)
                .font(.system(size: 13))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.top, 24)
    }
}
