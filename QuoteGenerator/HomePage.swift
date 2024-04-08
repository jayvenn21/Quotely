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
    case uncategorized // Added uncategorized case
}

// Define Quote struct
struct Quote {
    let text: String
    let creator: FilterCreator
}

struct HomePage: View {
    @State private var quote: Quote?
    @State private var isAddQuoteDialogPresented = false
    @State private var isAboutDialogPresented = false
    @State private var filterLengthOption: FilterLength = .all
    @State private var filterCreatorOption: FilterCreator = .all
    @State private var quotes = [
        Quote(text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", creator: .poet),
        Quote(text: "The way to get started is to quit talking and begin doing.", creator: .engineer),
        Quote(text: "Your time is limited, don't waste it living someone else's life.", creator: .engineer),
        Quote(text: "If life were predictable it would cease to be life, and be without flavor.", creator: .artist),
        Quote(text: "Life is what happens when you're busy making other plans.", creator: .artist)
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
                .font(.custom("Helvetica-Bold", size: 28)) // Cool font for the title
                .foregroundColor(.blue) // Blue color for the title text
                .padding()

            HStack {
                Text("Filter by Length:")
                    .font(.custom("Helvetica", size: 18)) // Cool font for the label
                    .foregroundColor(.green) // Green color for the label text
                FilterLengthDropdown(option: $filterLengthOption)
                    .padding()
            }

            HStack {
                Text("Filter by Creator:")
                    .font(.custom("Helvetica", size: 18)) // Cool font for the label
                    .foregroundColor(.green) // Green color for the label text
                FilterCreatorDropdown(option: $filterCreatorOption)
                    .padding()
            }

            Button("Generate Quote") {
                generateQuote()
            }
            .font(.custom("Helvetica", size: 18)) // Cool font for the button
            .foregroundColor(.green) // Green color for the button text
            .padding()

            if let quote = quote {
                Text("\"\(quote.text)\" - \(creatorName(for: quote.creator))")
                    .padding()
            } else {
                Text("No quote generated")
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
                .font(.custom("Helvetica", size: 18)) // Cool font for the button
                .foregroundColor(.green) // Green color for the button text
                .padding()
            }
        }
        .background(Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0))) // Beige background color
        .sheet(isPresented: $isAddQuoteDialogPresented) {
            AddQuoteDialog(isPresented: $isAddQuoteDialogPresented) { quote, creator, lengthCategory in
                addQuote(quote: quote, creator: creator, lengthCategory: lengthCategory)
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

    func addQuote(quote: String, creator: FilterCreator, lengthCategory: FilterLength) {
        let newQuote = Quote(text: quote, creator: creator)
        quotes.append(newQuote)
    }

    func creatorName(for creator: FilterCreator) -> String {
        switch creator {
        case .all:
            return "Unknown"
        case .poet:
            return "A Random Poet"
        case .engineer:
            return "A Random Engineer"
        case .artist:
            return "A Random Artist"
        case .uncategorized: // Updated to handle uncategorized case
            return "Uncategorized"
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
            Text("Uncategorized").tag(FilterCreator.uncategorized) // Changed the tag to .uncategorized
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct AboutDialog: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("About")
                .font(.title)
                .padding()

            Text("This app generates random quotes. You can add your own quotes using the 'Add Quote' button.")
                .padding()

            Button("Close") {
                isPresented = false
            }
            .padding()
        }
        .padding()
    }
}

struct AddQuoteDialog: View {
    @Binding var isPresented: Bool
    @State private var quote: String = ""
    @State private var creator: FilterCreator = .all // Default selection

    let onAddQuote: (String, FilterCreator, FilterLength) -> Void

    var body: some View {
        VStack {
            Text("Add Quote")
                .font(.title)
                .padding()

            TextField("Enter Quote", text: $quote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Select Creator Type", selection: $creator) {
                Text("Poet").tag(FilterCreator.poet)
                Text("Engineer").tag(FilterCreator.engineer)
                Text("Artist").tag(FilterCreator.artist)
                Text("Uncategorized").tag(FilterCreator.uncategorized)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()

                Button("Add Quote") {
                    let lengthCategory: FilterLength = determineLengthCategory(quote: quote)
                    onAddQuote(quote, creator, lengthCategory)
                    isPresented = false
                }
                .padding()
            }
        }
        .padding()
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

