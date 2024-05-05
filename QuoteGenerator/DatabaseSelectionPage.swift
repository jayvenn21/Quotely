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
                Text("Database 1").tag("Database 1")
                Text("Database 2").tag("Database 2")
                Text("Database 3").tag("Database 3")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            NavigationLink(destination: AnimeDatabasePage()) {
                Text("Go to Anime Database")
                    .font(.title)
                    .padding()
            }
        }
    }
}

struct DatabaseSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseSelectionPage()
    }
}

