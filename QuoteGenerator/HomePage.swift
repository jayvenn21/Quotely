import SwiftUI

struct HomePage: View {
    @State private var quote: String = ""
    @State private var isAddQuoteDialogPresented = false
    @State private var isAboutDialogPresented = false
    @State private var filterLengthOption: FilterLength = .all
    @State private var filterCreatorOption: FilterCreator = .all
    @State private var quotes = [
        "The greatest glory in living lies not in never falling, but in rising every time we fall. - Nelson Mandela",
        "The way to get started is to quit talking and begin doing. - Walt Disney",
        "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
        "If life were predictable it would cease to be life, and be without flavor. - Eleanor Roosevelt",
        "Life is what happens when you're busy making other plans. - John Lennon"
    ]

    var filteredQuotes: [String] {
        var filteredQuotes = quotes

        // Apply length filter
        if filterLengthOption != .all {
            filteredQuotes = filteredQuotes.filter { quote in
                let length = quote.components(separatedBy: " ")[0].count // Get the length of the quote
                switch filterLengthOption {
                case .short:
                    return length <= 10
                case .medium:
                    return length > 10 && length <= 30
                case .large:
                    return length > 30
                default:
                    return true
                }
            }
        }

        // Apply creator filter
        if filterCreatorOption != .all {
            filteredQuotes = filteredQuotes.filter { quote in
                let creator = quote.components(separatedBy: " - ")[1] // Get the creator of the quote
                switch filterCreatorOption {
                case .general:
                    return !creator.contains("poet") && !creator.contains("engineer") && !creator.contains("artist")
                case .poet:
                    return creator.contains("poet")
                case .engineer:
                    return creator.contains("engineer")
                case .artist:
                    return creator.contains("artist")
                default:
                    return true
                }
            }
        }

        return filteredQuotes
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
                .font(.title)
                .padding()

            HStack {
                Text("Filter by Length:")
                FilterLengthDropdown(option: $filterLengthOption)
                    .padding()
            }

            HStack {
                Text("Filter by Creator:")
                FilterCreatorDropdown(option: $filterCreatorOption)
                    .padding()
            }

            Button("Generate Quote") {
                generateQuote()
            }
            .padding()

            TextEditor(text: $quote)
                .frame(height: 200)
                .padding()
                .disabled(true) // Disable editing

            Spacer()

            HStack {
                Button("Add Quote") {
                    isAddQuoteDialogPresented = true
                }
                .padding()
            }
        }
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
            return
        }
        
        let randomIndex = Int.random(in: 0..<filteredQuotes.count)
        quote = filteredQuotes[randomIndex]
    }


    func addQuote(quote: String, creator: String, lengthCategory: FilterLength) {
        let formattedQuote = "\(quote) - \(creator)"
        quotes.append(formattedQuote)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

enum FilterLength {
    case all
    case short
    case medium
    case large
}

enum FilterCreator {
    case all
    case general
    case poet
    case engineer
    case artist
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
            Text("General").tag(FilterCreator.general)
            Text("Poet").tag(FilterCreator.poet)
            Text("Engineer").tag(FilterCreator.engineer)
            Text("Artist").tag(FilterCreator.artist)
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
    @State private var creator: String = ""
    @State private var selectedCreator: FilterCreator = .general // Default selection

    let onAddQuote: (String, String, FilterLength) -> Void

    var body: some View {
        VStack {
            Text("Add Quote")
                .font(.title)
                .padding()

            TextField("Enter Quote", text: $quote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter Creator", text: $creator)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Select Creator Type", selection: $selectedCreator) {
                Text("General").tag(FilterCreator.general)
                Text("Poet").tag(FilterCreator.poet)
                Text("Engineer").tag(FilterCreator.engineer)
                Text("Artist").tag(FilterCreator.artist)
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

