import SwiftUI

struct DatabaseSelectionPage: View {
    @State private var selectedDatabase: String = "All Databases"
    
    var body: some View {
        VStack {
            Text("Select Database:")
                .font(.title)
                .padding()
            
            Picker("Database", selection: $selectedDatabase) {
                Text("All Databases").tag("All Databases")
                Text("Anime Database").tag("Anime Database")
                Text("Kanye Database").tag("Kanye Database")
                Text("Quote Garden Database").tag("Quote Garden Database")
                Text("Stoicism Database").tag("Stoicism Database")
                Text("Zen Database").tag("Zen Database")
                Text("Breaking Bad Database").tag("Breaking Bad Database")
                Text("Game of Thrones Database").tag("Game of Thrones Database")
                
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
        case "Quote Garden Database":
            QGDatabasePage()
        case "Stoicism Database":
            StoicismDatabasePage()
        case "Zen Database":
            ZenDatabasePage()
        case "Game of Thrones Database":
            GoTDatabasePage()
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

