import SwiftUI

struct SplashView: View {
    let onContinue: () -> Void
    @StateObject private var vm = SplashViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0xE3F4EA), .white], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                Image(systemName: "wallet.bifold.fill")
                    .font(.system(size: 76))
                    .foregroundStyle(Theme.primary)
                    .padding(.bottom, 16)
                Text("Pocket")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primary)
                Text("Track Your Money\nLive Better")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 8)
                Spacer()
                Spacer()
                if vm.showsGetStarted {
                    PrimaryButton(title: "Get Started", action: onContinue)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 24)
                }
            }
        }
        .onAppear { vm.autoContinueIfNeeded(onContinue) }
    }
}

#Preview { SplashView(onContinue: {}) }
