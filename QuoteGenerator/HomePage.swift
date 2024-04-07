import SwiftUI

struct HomePage: View {
    @State private var quote: String = ""
    @State private var isAddQuoteDialogPresented = false
    @State private var isAboutDialogPresented = false
    @State private var quotes = [
        "The greatest glory in living lies not in never falling, but in rising every time we fall. - Nelson Mandela",
        "The way to get started is to quit talking and begin doing. - Walt Disney",
        "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
        "If life were predictable it would cease to be life, and be without flavor. - Eleanor Roosevelt",
        "Life is what happens when you're busy making other plans. - John Lennon"
    ]

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
            AddQuoteDialog(isPresented: $isAddQuoteDialogPresented) { quote, creator in
                addQuote(quote: quote, creator: creator)
            }
        }
        .sheet(isPresented: $isAboutDialogPresented) {
            AboutDialog(isPresented: $isAboutDialogPresented)
        }
    }

    func generateQuote() {
        let randomIndex = Int.random(in: 0..<quotes.count)
        quote = quotes[randomIndex]
    }

    func addQuote(quote: String, creator: String) {
        let formattedQuote = "\(quote) - \(creator)"
        quotes.append(formattedQuote)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
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

    let onAddQuote: (String, String) -> Void

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

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()

                Button("Add Quote") {
                    onAddQuote(quote, creator)
                    isPresented = false
                }
                .padding()
            }
        }
        .padding()
    }
}

