import SwiftUI

struct DatabaseSelectionPage: View {
    @State private var selectedDatabase: String = "All Databases"
    
    var body: some View {
        VStack {
            Text("Select Database:")
                .font(.title)
                .padding()
            
            Picker("Database", selection: $selectedDatabase) {
                Text("Anime Database").tag("Anime Database")
                Text("Kanye Database").tag("Kanye Database")
                Text("Stoicism Database").tag("Stoicism Database")
                Text("Zen Database").tag("Zen Database")
                Text("Breaking Bad Database").tag("Breaking Bad Database")
                Text("Game of Thrones Database").tag("Game of Thrones Database")
                Text("Lucifer Database").tag("Lucifer Database")
                Text("Ron Swanson Database").tag("Ron Swanson Database")
                Text("Stranger Things Database").tag("Stranger Things Database")
                Text("Better Call Saul Database").tag("Better Call Saul Database")
                
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            NavigationLink(destination: selectedDestination()) {
                Text("Go to Selected Database")
                    .font(.title)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    func selectedDestination() -> some View {
        switch selectedDatabase {
        case "Anime Database":
            AnimeDatabasePage()
        case "Kanye Database":
            KanyeDatabasePage()
        case "Stoicism Database":
            StoicismDatabasePage()
        case "Zen Database":
            ZenDatabasePage()
        case "Game of Thrones Database":
            GoTDatabasePage()
        case "Lucifer Database":
            LuciferDatabasePage()
        case "Ron Swanson Database":
            RSDatabasePage()
        case "Stranger Things Database":
            STSelectionPage()
        case "Better Call Saul Database":
            BCSSelectionPage()
        default:
            EmptyView()
        }
    }
}

struct DatabaseSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseSelectionPage()
    }
}

