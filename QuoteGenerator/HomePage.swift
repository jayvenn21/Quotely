import SwiftUI
import MessageUI
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
    @State private var isShareSheetPresented = false // New state for share sheet
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
        VStack {
            HStack {
                Spacer()
                Button("About") {
                    isAboutDialogPresented = true
                }
                .padding()
                Spacer() // Pushes the "About" button to the middle
            }

            Text("Quote Generator")
                .font(.system(size: 28, weight: .bold)) // Apple San Francisco font for the title
                .foregroundColor(.blue) // Blue color for the title text
                .padding()

            HStack {
                Text("Filter by Length:")
                    .font(.system(size: 18)) // Apple San Francisco font for the label
                    .foregroundColor(.green) // Green color for the label text
                FilterLengthDropdown(option: $filterLengthOption)
                    .padding()
            }

            HStack {
                Text("Filter by Creator:")
                    .font(.system(size: 18)) // Apple San Francisco font for the label
                    .foregroundColor(.green) // Green color for the label text
                FilterCreatorDropdown(option: $filterCreatorOption)
                    .padding()
            }

            Button("Generate Quote") {
                generateQuote()
            }
            .font(.system(size: 18)) // Apple San Francisco font for the button
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

            HStack {
                Button("Add Quote") {
                    isAddQuoteDialogPresented = true
                }
                .font(.system(size: 18)) // Apple San Francisco font for the button
                .foregroundColor(.green) // Green color for the button text
                .padding()
                
                Button("Share") {
                    isShareSheetPresented = true
                }
                .font(.system(size: 18)) // Apple San Francisco font for the button
                .foregroundColor(.green) // Green color for the button text
                .padding()
                .sheet(isPresented: $isShareSheetPresented) {
                    ShareSheet(quote: quote ?? Quote(text: "", creator: .all, creatorName: ""))
                }
            }
        }
        .background(Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0))) // Beige background color
        .sheet(isPresented: $isAddQuoteDialogPresented) {
            AddQuoteDialog(isPresented: $isAddQuoteDialogPresented) { quote, creator, lengthCategory, creatorName in
                addQuote(quote: quote, creator: creator, lengthCategory: lengthCategory, creatorName: creatorName)
            }
        }
        .sheet(isPresented: $isAboutDialogPresented) {
            AboutDialog(isPresented: $isAboutDialogPresented)
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

    var body: some View {
        ZStack {
            Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)) // Normal beige background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("About Quotely")
                    .font(.title)
                    .padding()

                Text("Welcome to Quotely! This app generates random quotes based on two categories: the length of the quote and the type of creator.")
                    .padding()

                Text("There are already some predefined quotes available for you to test out. Also, you can add your own quotes using the 'Add Quote' button. Enjoy!")
                    .padding()

                Text("Jayanth Vennamreddy")
                    .italic()
                    .padding()

                Button("Close") {
                    isPresented = false
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(8)
            }
            .padding()
            .background(Color(UIColor(red: 235/255, green: 235/255, blue: 210/255, alpha: 1.0))) // Darker beige background
            .cornerRadius(10)
        }
    }
}

struct AddQuoteDialog: View {
    @Binding var isPresented: Bool
    @State private var quote: String = ""
    @State private var creator: FilterCreator = .all // Default selection
    @State private var creatorName: String = "" // New state variable for creator's name

    let onAddQuote: (String, FilterCreator, FilterLength, String) -> Void // Updated closure

    var body: some View {
        ZStack {
            Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)) // Normal beige background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Add Quote")
                    .font(.system(size: 28, weight: .bold)) // Apple San Francisco font for the title
                    .padding()

                TextField("Enter Quote", text: $quote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .font(.system(size: 16)) // Apple San Francisco font for the text field
                    .foregroundColor(.black) // Black color for the text field text

                TextField("Enter Creator Name", text: $creatorName) // New text input for creator's name
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .font(.system(size: 16)) // Apple San Francisco font for the text field
                    .foregroundColor(.black) // Black color for the text field text

                Picker("Select Creator Type", selection: $creator) {
                    Text("Poet").tag(FilterCreator.poet)
                    Text("Engineer").tag(FilterCreator.engineer)
                    Text("Artist").tag(FilterCreator.artist)
                    Text("Other").tag(FilterCreator.other)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .padding()
                    .font(.system(size: 16, weight: .bold)) // Apple San Francisco font for the button
                    .foregroundColor(.red) // Red color for the button text

                    Button("Add Quote") {
                        let lengthCategory: FilterLength = determineLengthCategory(quote: quote)
                        onAddQuote(quote, creator, lengthCategory, creatorName) // Pass creatorName to closure
                        isPresented = false
                    }
                    .padding()
                    .font(.system(size: 16, weight: .bold)) // Apple San Francisco font for the button
                    .foregroundColor(.green) // Green color for the button text
                }
            }
            .padding()
            .background(Color(UIColor(red: 235/255, green: 235/255, blue: 210/255, alpha: 1.0))) // Darker beige background
            .cornerRadius(10)
        }
    }

    // Function to determine the length category of the quote
    func determineLengthCategory(quote: String) -> FilterLength {
        let length = quote.components(separatedBy: " ")[0].count
        switch length {
        case ..<11:
            return .short
        case 11...30:
            return .medium
        default:
            return .large
        }
    }
}

struct ShareSheet: View {
    let quote: Quote

    var body: some View {
        VStack {
            Text("Share Quote")
                .font(.title)
                .padding()

            if quote.text.isEmpty {
                Text("You first need to have a quote in the textbox!")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("\"\(quote.text)\" - \(quote.creatorName)")
                    .padding()

                Button("Share via Messages") {
                    // Share via Messages implementation
                }
                .buttonStyle(ShareButtonStyle())

                Button("Share via Email") {
                    // Share via Email implementation
                }
                .buttonStyle(ShareButtonStyle())

                // Add more sharing options as needed...

                Button("Cancel") {
                    // Dismiss the share sheet
                }
                .buttonStyle(CancelButtonStyle())
            }
        }
        .padding()
        .background(Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)))
        .cornerRadius(10)
    }
}

// Custom button style for share buttons
struct ShareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.green)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 10) // Adjusted horizontal padding
            .padding(.vertical, 5) // Adjusted vertical padding
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green, lineWidth: 2)
                    .padding(1) // Added padding to ensure the stroke aligns perfectly with the button edges
            )
    }
}

// Custom button style for cancel button
struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.red)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 10) // Adjusted horizontal padding
            .padding(.vertical, 5) // Adjusted vertical padding
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 2)
                    .padding(1) // Added padding to ensure the stroke aligns perfectly with the button edges
            )
    }
}




