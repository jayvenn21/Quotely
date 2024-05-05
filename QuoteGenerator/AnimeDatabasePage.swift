import SwiftUI

struct AnimeDatabasePage: View {
    @StateObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack {
            Button("Fetch Random Quote") {
                networkManager.fetchRandomQuote()
            }
            if let randomQuote = networkManager.randomQuote {
                Text("Random Quote: \(randomQuote.quote)")
            }
            
            Button("Fetch Quote by Anime Title") {
                networkManager.fetchQuoteByAnimeTitle(title: "naruto") // Change the anime title as needed
            }
            if let quoteByAnimeTitle = networkManager.quoteByAnimeTitle {
                Text("Quote by Anime Title: \(quoteByAnimeTitle.quote)")
            }
            
            Button("Fetch Quote by Anime Character") {
                networkManager.fetchQuoteByAnimeCharacter(character: "saitama") // Change the character name as needed
            }
            if let quoteByAnimeCharacter = networkManager.quoteByAnimeCharacter {
                Text("Quote by Anime Character: \(quoteByAnimeCharacter.quote)")
            }
        }
    }
}

struct AnimeDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        AnimeDatabasePage()
    }
}

struct AnimeQuote: Codable { // Rename Quote struct to AnimeQuote
    let anime: String
    let character: String
    let quote: String
}

class NetworkManager: ObservableObject {
    @Published var randomQuote: AnimeQuote? // Rename Quote to AnimeQuote
    @Published var quoteByAnimeTitle: AnimeQuote? // Rename Quote to AnimeQuote
    @Published var quoteByAnimeCharacter: AnimeQuote? // Rename Quote to AnimeQuote
    
    func fetchRandomQuote() {
        fetchQuote(from: "https://animechan.xyz/api/random")
    }
    
    func fetchQuoteByAnimeTitle(title: String) {
        let url = "https://animechan.xyz/api/random/anime?title=\(title)"
        fetchQuote(from: url)
    }
    
    func fetchQuoteByAnimeCharacter(character: String) {
        let url = "https://animechan.xyz/api/random/character?name=\(character)"
        fetchQuote(from: url)
    }
    
    private func fetchQuote(from url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let quote = try? JSONDecoder().decode(AnimeQuote.self, from: data) { // Decode to AnimeQuote
                DispatchQueue.main.async {
                    if url.absoluteString.contains("random") {
                        self.randomQuote = quote
                    } else if url.absoluteString.contains("/anime") { // Check string representation of URL
                        self.quoteByAnimeTitle = quote
                    } else if url.absoluteString.contains("/character") { // Check string representation of URL
                        self.quoteByAnimeCharacter = quote
                    }
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
}

