import SwiftUI

struct DatabaseSelectionPage: View {
    @State private var selectedDatabase: String = "Better Call Saul Database"
    
    var body: some View {
        VStack {
            Text("Select Database:")
                .font(.custom("Avenir-Black", size: 28)) // Using Avenir-Black font
                .padding()
            
            Picker("Database", selection: $selectedDatabase) {
                Text("Better Call Saul Database").tag("Better Call Saul Database")
                Text("Breaking Bad Database").tag("Breaking Bad Database")
                Text("Game of Thrones Database").tag("Game of Thrones Database")
                Text("Kanye Database").tag("Kanye Database")
                Text("Lucifer Database").tag("Lucifer Database")
                Text("Office Database").tag("Office Database")
                Text("Ron Swanson Database").tag("Ron Swanson Database")
                Text("Stoicism Database").tag("Stoicism Database")
                Text("Stranger Things Database").tag("Stranger Things Database")
                Text("Zen Database").tag("Zen Database")
                
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            NavigationLink(destination: selectedDestination()) {
                Text("Go to Selected Database")
                    .font(.custom("Avenir-Black", size: 28)) // Using Avenir-Black font
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    func selectedDestination() -> some View {
        switch selectedDatabase {
        case "Office Database":
            OfficeSelectionPage()
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

