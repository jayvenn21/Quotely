import SwiftUI

struct CustomNavigationBar: View {
    @Binding var isDarkMode: Bool // Add a binding for isDarkMode
    @Binding var isAddQuoteDialogPresented: Bool // Add a binding for AddQuoteDialog presentation
    
    var body: some View {
        HStack {
            Spacer()
            
            NavigationLink(destination: HomePage(isDarkMode: $isDarkMode)) { // Pass isDarkMode as a binding
                VStack {
                    Image(systemName: "house")
                        .font(.title)
                    Text("Home")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: ContentView()) {
                VStack {
                    Image(systemName: "rectangle.3.offgrid.fill")
                        .font(.title)
                    Text("Content")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Button(action: {
                isAddQuoteDialogPresented.toggle()
            }) {
                VStack {
                    Image(systemName: "plus.square")
                        .font(.title)
                    Text("Add Quote")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: DatabaseSelectionPage()) {
                VStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.title)
                    Text("Generate from Database")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: ShareQuotePage()) {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                    Text("Share Quote")
                        .font(.caption)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

