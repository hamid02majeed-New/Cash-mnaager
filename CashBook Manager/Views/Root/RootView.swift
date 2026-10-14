import SwiftUI

struct RootView: View {
    @StateObject private var vm = RootViewModel()

    var body: some View {
        ZStack {
            if vm.showSplash {
                SplashView(onContinue: vm.finishSplash)
                    .transition(.opacity)
            } else if !vm.hasSeenOnboarding {
                OnboardingView(onFinish: vm.finishOnboarding)
                    .transition(.move(edge: .trailing))
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: vm.showSplash)
        .animation(.easeInOut(duration: 0.3), value: vm.hasSeenOnboarding)
    }
}
