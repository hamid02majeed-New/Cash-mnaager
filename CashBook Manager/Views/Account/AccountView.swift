import SwiftUI

struct AccountView: View {
    @StateObject private var vm = AccountViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "My Account")
            ScrollView {
                VStack(spacing: 18) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white)
                        .frame(width: 84, height: 84)
                        .background(Theme.primary, in: Circle())
                        .padding(.top, 12)
                    field("Name", text: $vm.name, placeholder: "Your name")
                    field("Email", text: $vm.email, placeholder: "you@example.com", keyboard: .emailAddress)
                    PrimaryButton(title: vm.justSaved ? "Saved ✓" : "Save Changes", action: vm.save)
                        .padding(.top, 6)
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Theme.background)
        .hideNavigationBar()
    }

    private func field(_ title: String, text: Binding<String>, placeholder: String,
                       keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 13)).foregroundStyle(Theme.textSecondary)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(keyboard == .emailAddress ? .never : .words)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .frame(height: 50)
                .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
