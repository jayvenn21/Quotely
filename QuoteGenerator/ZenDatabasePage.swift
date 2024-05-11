import SwiftUI

struct ZenQuote: Codable {
    let q: String // Quote text
    let a: String // Author name
}

struct ZenDatabasePage: View {
    @State private var randomQuote: ZenQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Zen")
                .font(.title)
                .padding()

            Button("Fetch Random Quote") {
                fetchRandomQuote()
            }

            if let randomQuote = randomQuote {
                Text("\"\(randomQuote.q)\"")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("- \(randomQuote.a)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Tap the button to generate a quote")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }

    func fetchRandomQuote() {
        guard let url = URL(string: "https://zenquotes.io/api/random") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quotes = try JSONDecoder().decode([ZenQuote].self, from: data)
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

struct ZenDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        ZenDatabasePage()
    }
}

