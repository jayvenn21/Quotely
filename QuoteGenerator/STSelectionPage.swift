import SwiftUI

struct StrangerThingsQuote: Codable {
    let quote: String
    let author: String
}

struct STSelectionPage: View {
    @State private var randomQuote: StrangerThingsQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Stranger Things")
                .font(.title)
                .padding()

            if let quote = randomQuote {
                VStack {
                    Text("\"\(quote.quote)\"")
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

            Button("Generate Quote") {
                fetchRandomQuote()
            }
            .padding()
        }
    }

    func fetchRandomQuote() {
        guard let url = URL(string: "https://strangerthings-quotes.vercel.app/api/quotes") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quotes = try JSONDecoder().decode([StrangerThingsQuote].self, from: data)
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

struct STSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        STSelectionPage()
    }
}

