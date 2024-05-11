import SwiftUI

struct SwansonQuote: Codable {
    let quote: String
}

struct RSDatabasePage: View {
    @State private var randomQuote: SwansonQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Ron Swanson")
                .font(.title)
                .padding()

            if let quote = randomQuote {
                Text(quote.quote)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
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
        guard let url = URL(string: "https://ron-swanson-quotes.herokuapp.com/v2/quotes") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quotes = try JSONDecoder().decode([String].self, from: data)
                if let quote = quotes.first {
                    DispatchQueue.main.async {
                        self.randomQuote = SwansonQuote(quote: quote)
                    }
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct RSDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        RSDatabasePage()
    }
}

