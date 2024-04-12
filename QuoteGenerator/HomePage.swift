import SwiftUI

// Define FilterLength enum
enum FilterLength {
    case all
    case short
    case medium
    case large
}

// Define FilterCreator enum
enum FilterCreator {
    case all
    case poet
    case engineer
    case artist
    case other // Renamed from uncategorized
}

// Define Quote struct
struct Quote {
    let text: String
    let creator: FilterCreator
    let creatorName: String // Added creator's name
}

struct HomePage: View {
    @State private var quote: Quote?
    @State private var isAddQuoteDialogPresented = false
    @State private var isAboutDialogPresented = false
    @State private var filterLengthOption: FilterLength = .all
    @State private var filterCreatorOption: FilterCreator = .all
    @State private var quotes = [
        Quote(text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", creator: .poet, creatorName: "Nelson Mandela"),
        Quote(text: "The way to get started is to quit talking and begin doing.", creator: .engineer, creatorName: "Walt Disney"),
        Quote(text: "Your time is limited, don't waste it living someone else's life.", creator: .engineer, creatorName: "Steve Jobs"),
        Quote(text: "If life were predictable it would cease to be life, and be without flavor.", creator: .artist, creatorName: "Eleanor Roosevelt"),
        Quote(text: "Life is what happens when you're busy making other plans.", creator: .artist, creatorName: "John Lennon")
    ]
    @State private var errorMessage: String?
    @Binding var isDarkMode: Bool // Pass the dark mode state from ContentView

    var filteredQuotes: [Quote] {
        var filtered = quotes

        // Filter by length
        switch filterLengthOption {
        case .short:
            filtered = filtered.filter { $0.text.count <= 20 }
        case .medium:
            filtered = filtered.filter { $0.text.count > 20 && $0.text.count <= 50 }
        case .large:
            filtered = filtered.filter { $0.text.count > 50 }
        default:
            break
        }

        // Filter by creator
        if filterCreatorOption != .all {
            filtered = filtered.filter { $0.creator == filterCreatorOption }
        }

        return filtered
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isAboutDialogPresented = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .padding()
                    }
                    Spacer() // Pushes the "About" button to the middle
                }

                Text("Quote Generator")
                    .font(.system(size: 28, weight: .bold)) // Apple San Francisco font for the title
                    .foregroundColor(isDarkMode ? .white : .black) // Set text color based on mode
                    .padding()

                HStack {
                    Text("Filter by Length:")
                        .font(.system(size: 18)) // Apple San Francisco font for the label
                        .foregroundColor(isDarkMode ? .white : .black) // Set text color based on mode
                    FilterLengthDropdown(option: $filterLengthOption)
                        .padding()
                }

                HStack {
                    Text("Filter by Creator:")
                        .font(.system(size: 18)) // Apple San Francisco font for the label
                        .foregroundColor(isDarkMode ? .white : .black) // Set text color based on mode
                    FilterCreatorDropdown(option: $filterCreatorOption)
                        .padding()
                }

                Button("Generate Quote") {
                    generateQuote()
                }
                .font(.system(size: 25)) // Apple San Francisco font for the button
                .foregroundColor(.green) // Green color for the button text
                .padding()

                if let quote = quote {
                    Text("\"\(quote.text)\" - \(quote.creatorName)") // Display quote with creator's name
                        .padding()
                } else {
                    Text("No Quote Generated")
                        .padding()
                }

                // Error message display
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()

                Button("Add Quote") {
                    isAddQuoteDialogPresented = true
                }
                .font(.system(size: 18)) // Apple San Francisco font for the button
                .foregroundColor(.green) // Green color for the button text
                .padding()

                Button("Share Quote") {
                    shareQuote()
                }
                .font(.system(size: 18)) // Apple San Francisco font for the button
                .foregroundColor(.green) // Green color for the button text
                .padding()
                .sheet(isPresented: $isAddQuoteDialogPresented) { // Changed from isAboutDialogPresented
                    AddQuoteDialog(isPresented: $isAddQuoteDialogPresented, onAddQuote: addQuote) // Pass the onAddQuote closure
                }
            }
            .background(isDarkMode ? Color.black : Color.white) // Set background color based on mode
            .foregroundColor(isDarkMode ? .white : .black) // Set text color based on mode
            .navigationBarItems(trailing:
                Button(action: {
                    isDarkMode.toggle() // Toggle dark mode
                }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill") // Set icon based on mode
                        .font(.title)
                        .padding()
                        .foregroundColor(isDarkMode ? .white : .black) // Set icon color based on mode
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle for iPad
        .preferredColorScheme(isDarkMode ? .dark : .light) // Set preferred color scheme based on mode
        .sheet(isPresented: $isAboutDialogPresented) {
            AboutDialog(isPresented: $isAboutDialogPresented)
                .preferredColorScheme(isDarkMode ? .dark : .light) // Set preferred color scheme for the About dialog
        }
    }

    func generateQuote() {
        guard !filteredQuotes.isEmpty else {
            // Handle the case where filteredQuotes is empty
            // For example, you can display an alert or disable the "Generate Quote" button
            errorMessage = "No quotes available for the selected criteria."
            return
        }
        
        let randomIndex = Int.random(in: 0..<filteredQuotes.count)
        quote = filteredQuotes[randomIndex]
        
        // Check if there is only one quote available
        if filteredQuotes.count == 1 {
            errorMessage = "There is only one quote. Add more quotes."
        } else {
            errorMessage = nil
        }
    }

    func addQuote(quote: String, creator: FilterCreator, lengthCategory: FilterLength, creatorName: String) {
        let newQuote = Quote(text: quote, creator: creator, creatorName: creatorName)
        quotes.append(newQuote)
    }
    
    func shareQuote() {
        guard let quote = quote else {
            // Display a popup message when there is no quote generated
            errorMessage = "You first need to generate a quote!"
            return
        }
        
        // Format the quote to include the text and creator's name
        let textToShare = "\"\(quote.text)\" - \(quote.creatorName)"
        
        // Create an array of activity items to share
        let activityItems: [Any] = [textToShare]
        
        // Create an array of application activities
        let applicationActivities: [UIActivity]? = nil
        
        // Get the key window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Access the windows property from the window scene
            if let keyWindow = windowScene.windows.first {
                // Create a UIActivityViewController with the activity items and application activities
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
                
                // Exclude some activities from the list (optional)
                activityViewController.excludedActivityTypes = [.addToReadingList, .openInIBooks, .markupAsPDF]
                
                // Present the UIActivityViewController
                keyWindow.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }

}

struct FilterLengthDropdown: View {
    @Binding var option: FilterLength

    var body: some View {
        Picker("Length", selection: $option) {
            Text("All").tag(FilterLength.all)
            Text("Short").tag(FilterLength.short)
            Text("Medium").tag(FilterLength.medium)
            Text("Large").tag(FilterLength.large)
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct FilterCreatorDropdown: View {
    @Binding var option: FilterCreator

    var body: some View {
        Picker("Creator", selection: $option) {
            Text("All").tag(FilterCreator.all)
            Text("Poet").tag(FilterCreator.poet)
            Text("Engineer").tag(FilterCreator.engineer)
            Text("Artist").tag(FilterCreator.artist)
            Text("Other").tag(FilterCreator.other) // Changed the tag to .other
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct AboutDialog: View {
    @Binding var isPresented: Bool
    let userName = "Jayanth Vennamreddy"

    var body: some View {
        ZStack {
            Color(UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)) // Light gray background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("About Quotely")
                    .font(.title)
                    .padding()
                    .foregroundColor(.black) // Black text color

                Text("Welcome to Quotely! This app generates random quotes based on two categories: length and creator. You can also add your own quotes. Enjoy!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.black) // Black text color

                Text("\(userName)")
                    .italic() // Italicize the text
                    .padding(.top, 4) // Add top padding
                    .foregroundColor(.black) // Black text color

                Spacer()

                Button("Close") {
                    isPresented = false
                }
                .font(.title)
                .padding()
                .foregroundColor(.white) // White text color
                .background(Color.blue) // Blue background color
                .cornerRadius(10) // Rounded button corners
                .padding()
            }
            .background(Color.white) // White background color
            .cornerRadius(20) // Rounded dialog corners
            .shadow(radius: 10) // Dialog shadow effect
        }
    }
}


struct AddQuoteDialog: View {
    @Binding var isPresented: Bool
    var onAddQuote: (String, FilterCreator, FilterLength, String) -> Void // Add the onAddQuote closure
    
    @State private var quote = ""
    @State private var creatorName = ""
    @State private var selectedCreator: FilterCreator = .all

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quote")) {
                    TextField("Enter Quote", text: $quote)
                }
                
                Section(header: Text("Creator Name")) {
                    TextField("Enter Creator Name", text: $creatorName)
                }

                Section(header: Text("Creator")) {
                    Picker("Creator", selection: $selectedCreator) {
                        Text("All").tag(FilterCreator.all)
                        Text("Poet").tag(FilterCreator.poet)
                        Text("Engineer").tag(FilterCreator.engineer)
                        Text("Artist").tag(FilterCreator.artist)
                        Text("Other").tag(FilterCreator.other) // Changed the tag to .other
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    Button("Add Quote") {
                        // Call onAddQuote closure when the "Add Quote" button is tapped
                        onAddQuote(quote, selectedCreator, .all, creatorName) // Always pass .all for lengthCategory
                        isPresented = false // Dismiss the dialog
                    }
                }
            }
            .navigationBarTitle("Add Quote")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

