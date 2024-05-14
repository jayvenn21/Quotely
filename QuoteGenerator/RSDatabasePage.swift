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
                .font(.custom("Avenir-Black", size: 34)) // Avenir-Black font for the title
                .padding()

            if let quote = randomQuote {
                Text(quote.quote)
                    .font(.custom("Avenir-Black", size: 24)) // Avenir-Black font for the headline
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Tap the button to generate a quote")
                    .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the text
                    .foregroundColor(.gray)
                    .padding()
            }

            Button("Generate Quote") {
                fetchRandomQuote()
            }
            .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the button text
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

