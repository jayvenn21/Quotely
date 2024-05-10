import SwiftUI

struct SettingsPage: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Settings Page")
                .font(.title)
                .padding()

            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()
        }
    }
}

