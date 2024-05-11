import SwiftUI

struct BBQuote: Codable {
    let quote: String
    let author: String
}

struct BBDatabasePage: View {
    @State private var randomQuote: BBQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Breaking Bad")
                .font(.title)
                .padding()

            if let quote = randomQuote {
                VStack {
                    Text(quote.quote)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- \(quote.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Tap the button to generate a quote")
                    .foregroundColor(.gray)
                    .padding()
            }

            Button("Fetch Random Quote") {
                fetchRandomQuote()
            }
            .padding()
        }
    }

    func fetchRandomQuote() {
        guard let url = URL(string: "https://api.breakingbadquotes.xyz/v1/quotes") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quotes = try JSONDecoder().decode([BBQuote].self, from: data)
                if let randomQuote = quotes.first {
                    DispatchQueue.main.async {
                        self.randomQuote = randomQuote
                    }
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct BBDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        BBDatabasePage()
    }
}

