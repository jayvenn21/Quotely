import SwiftUI

struct MainPage: View {
    var body: some View {
        TabView {
            AboutView()
                .tabItem {
                    Image(systemName: "house")
                    Text("About")
                }
            DatabaseSelectionPage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Database")
                }
            SettingsPage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Quotes")
                }
        }
        
    }
}



