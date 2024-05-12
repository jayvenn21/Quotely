import SwiftUI

struct DuneQuote: Codable {
    let id: String
    let quote: String
}

struct DuneSelectionPage: View {
    @State private var randomQuote: DuneQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Dune")
                .font(.title)
                .padding()

            if let quote = randomQuote {
                VStack {
                    Text("\"\(quote.quote)\"")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- Dune")
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
        guard let url = URL(string: "https://the-dune-api.herokuapp.com/quotes") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quotes = try JSONDecoder().decode([DuneQuote].self, from: data)
                if let quote = quotes.first {
                    DispatchQueue.main.async {
                        self.randomQuote = quote
                    }
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct DuneSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        DuneSelectionPage()
    }
}

