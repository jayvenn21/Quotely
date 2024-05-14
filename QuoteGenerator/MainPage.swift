import SwiftUI;
struct MainPage: View {
    @State private var isDarkMode = false // Default value for isDarkMode
    @State private var selection = 1 // Set the selection index to the index of HomePage
    
    var body: some View {
        TabView(selection: $selection) { // Bind the selection to the state variable
            AboutView()
                .tabItem {
                    Image(systemName: "info.circle") // System name image for About
                    Text("About")
                }
                .tag(0) // Tag each tab with an index
            HomePage() // Pass the binding variable
                .tabItem {
                    Image(systemName: "house") // System name image for Home
                    Text("Home")
                }
                .tag(1) // Tag each tab with an index
            DatabaseSelectionPage()
                .tabItem {
                    Image(systemName: "book") // System name image for Database
                    Text("Database")
                }
                .tag(2) // Tag each tab with an index
            QuoteDayPage()
                .tabItem {
                    Image(systemName: "lightbulb") // System name image for Database
                    Text("Quote of the Day")
                }
                .tag(3) // Tag each tab with an index
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.white // Set tab bar background color
        }
    }
}

