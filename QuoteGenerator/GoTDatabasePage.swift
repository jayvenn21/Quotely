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
                .font(.custom("Avenir-Black", size: 34)) // Avenir-Black font for the title
                .padding()

            if let quote = randomQuote {
                VStack {
                    Text(quote.sentence)
                        .font(.custom("Avenir-Black", size: 24)) // Avenir-Black font for the headline
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- \(quote.character.name)")
                        .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the subheadline
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Tap the button to generate a quote")
                    .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the text
                    .foregroundColor(.gray)
                    .padding()
            }

            Button("Randomize!") {
                fetchRandomQuote()
            }
            .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the button text
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

