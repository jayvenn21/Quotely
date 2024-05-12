import SwiftUI

struct OfficeQuote: Codable {
    let id: Int
    let character: String
    let quote: String
}

struct OfficeSelectionPage: View {
    @State private var randomQuote: OfficeQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("The Office")
                .font(.title)
                .padding()

            if let quote = randomQuote {
                VStack {
                    Text("\"\(quote.quote)\"")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- \(quote.character)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Tap the button to generate a quote")
                    .foregroundColor(.gray)
                    .padding()
            }

            Button("Generate Quote") {
                fetchRandomQuote()
            }
            .padding()
        }
    }

    func fetchRandomQuote() {
        guard let url = URL(string: "https://officeapi.akashrajpurohit.com/quote/random") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quote = try JSONDecoder().decode(OfficeQuote.self, from: data)
                DispatchQueue.main.async {
                    self.randomQuote = quote
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct OfficeSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        OfficeSelectionPage()
    }
}

