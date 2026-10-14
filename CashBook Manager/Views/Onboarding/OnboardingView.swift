import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @StateObject private var vm = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if !vm.isLast {
                    Button("Skip", action: onFinish)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 24)

            TabView(selection: $vm.index) {
                ForEach(Array(vm.pages.enumerated()), id: \.element.id) { offset, page in
                    pageView(page).tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(vm.pages.indices, id: \.self) { i in
                    Circle()
                        .fill(i == vm.index ? Theme.primary : Theme.border)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 24)

            PrimaryButton(title: vm.buttonTitle) {
                if vm.next() { onFinish() }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
        .animation(.easeInOut, value: vm.index)
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 14) {
            Spacer()
            ZStack {
                Circle().fill(Theme.primaryLight).frame(width: 200, height: 200)
                Image(systemName: page.icon)
                    .font(.system(size: 84))
                    .foregroundStyle(Theme.primary)
                Image(systemName: "centsign.circle.fill")
                    .font(.system(size: 38))
                    .foregroundStyle(Color(hex: 0xFFB400))
                    .offset(x: 56, y: -66)
            }
            .padding(.bottom, 24)
            Text(page.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
            Text(page.message)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 36)
            Spacer()
            Spacer()
        }
    }
}

#Preview { OnboardingView(onFinish: {}) }
