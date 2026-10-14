import SwiftUI

struct HelpSupportView: View {
    @StateObject private var vm = HelpSupportViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Help & Support")
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(vm.faqs) { faq in
                        DisclosureGroup {
                            Text(faq.answer)
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 6)
                        } label: {
                            Text(faq.question)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Theme.textPrimary)
                                .multilineTextAlignment(.leading)
                        }
                        .tint(Theme.textSecondary)
                        .padding(14)
                        .background(Theme.field, in: RoundedRectangle(cornerRadius: 14))
                    }
                    Link(destination: vm.supportURL) {
                        Label("Contact Support", systemImage: "envelope")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Theme.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Theme.primaryLight, in: Capsule())
                    }
                    .padding(.top, 8)
                }
                .padding(16)
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
    }
}
