import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject private var vm = AnalyticsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Spending Overview")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .frame(height: 44)
            .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 18) {
                    periodPicker
                    rangeNavigator
                    donut
                    legend
                }
                .padding(16)
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
        .mainTabBar()
    }

    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(AnalyticsPeriod.allCases) { period in
                let selected = vm.period == period
                Button { withAnimation(.easeInOut(duration: 0.2)) { vm.period = period } } label: {
                    Text(period.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(selected ? Color.white : Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(selected ? Theme.primary : Color.clear, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Theme.field, in: Capsule())
    }

    private var rangeNavigator: some View {
        HStack {
            Button { vm.step(-1) } label: {
                Image(systemName: "chevron.left").frame(width: 36, height: 36)
            }
            Spacer()
            Text(vm.rangeTitle)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Button { vm.step(1) } label: {
                Image(systemName: "chevron.right").frame(width: 36, height: 36)
            }
            .disabled(!vm.canGoForward)
            .opacity(vm.canGoForward ? 1 : 0.3)
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Theme.textSecondary)
    }

    private var donut: some View {
        let slices = vm.slices
        return ZStack {
            if slices.isEmpty {
                Circle().stroke(Theme.field, lineWidth: 30).padding(15)
            } else {
                Chart(slices) { slice in
                    SectorMark(angle: .value("Amount", slice.amount),
                               innerRadius: .ratio(0.64),
                               angularInset: 1.5)
                        .cornerRadius(3)
                        .foregroundStyle(slice.color)
                }
            }
            VStack(spacing: 2) {
                Text(vm.money(vm.totalSpent))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text("Total Expenses")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(.horizontal, 50)
        }
        .frame(width: 230, height: 230)
        .padding(.vertical, 4)
    }

    private var legend: some View {
        VStack(spacing: 14) {
            if vm.slices.isEmpty {
                EmptyStateView(icon: "chart.pie", title: "No expenses",
                               message: "There is no spending recorded for this period.")
            }
            ForEach(vm.slices) { slice in
                HStack(spacing: 10) {
                    Circle().fill(slice.color).frame(width: 9, height: 9)
                    Text(slice.name)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Text(vm.money(slice.amount))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Text("\(Int((slice.percent * 100).rounded()))%")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(width: 36, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}
