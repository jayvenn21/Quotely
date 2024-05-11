import SwiftUI

struct GoTQuote: Codable {
    let sentence: String
    let character: Character
}

struct Character: Codable {
    let name: String
    let slug: String
    let house: House
}

struct House: Codable {
    let name: String
    let slug: String
}

struct GoTDatabasePage: View {
    @State private var randomQuote: GoTQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Game of Thrones Page")
                .font(.title)
                .padding()

            if let quote = randomQuote {
                VStack {
                    Text(quote.sentence)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- \(quote.character.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Tap the button to generate a quote")
                    .foregroundColor(.gray)
                    .padding()
            }

            Button("Randomize!") {
                fetchRandomQuote()
            }
            .padding()
        }
    }

    func fetchRandomQuote() {
        guard let url = URL(string: "https://api.gameofthronesquotes.xyz/v1/random") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let quote = try JSONDecoder().decode(GoTQuote.self, from: data)
                DispatchQueue.main.async {
                    self.randomQuote = quote
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct GoTDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        GoTDatabasePage()
    }
}

