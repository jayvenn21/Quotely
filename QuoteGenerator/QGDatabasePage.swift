import SwiftUI

struct QuoteGardenQuote: Codable, Identifiable {
    let id: String
    let quoteText: String
    let quoteAuthor: String
    let quoteGenre: String
}

struct GenreResponse: Codable {
    let data: [String]
}

struct AuthorResponse: Codable {
    let data: [String]
}

class QuoteGardenNetworkManager: ObservableObject {
    @Published var randomQuote: QuoteGardenQuote?
    @Published var quotes: [QuoteGardenQuote] = []
    @Published var genres: GenreResponse?
    @Published var authors: AuthorResponse?
    
    func fetchRandomQuote() {
        guard let url = URL(string: "https://quote-garden.onrender.com/api/v3/quotes?count=1") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let response = try? JSONDecoder().decode(QuoteGardenQuote.self, from: data) {
                DispatchQueue.main.async {
                    self.randomQuote = response
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    func fetchQuotes() {
        guard let url = URL(string: "https://quote-garden.onrender.com/api/v3/quotes") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let response = try? JSONDecoder().decode([QuoteGardenQuote].self, from: data) {
                DispatchQueue.main.async {
                    self.quotes = response
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    func fetchAllGenres() {
        guard let url = URL(string: "https://quote-garden.onrender.com/api/v3/genres") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let response = try? JSONDecoder().decode(GenreResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.genres = response
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    func fetchAllAuthors() {
        guard let url = URL(string: "https://quote-garden.onrender.com/api/v3/authors") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let response = try? JSONDecoder().decode(AuthorResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.authors = response
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
}

struct QGDatabasePage: View {
    @StateObject var networkManager = QuoteGardenNetworkManager()
    
    var body: some View {
        VStack {
            Text("QG")
                .font(.title)
                .padding()
            
            Button("Fetch Random Quote") {
                networkManager.fetchRandomQuote()
            }
            if let randomQuote = networkManager.randomQuote {
                Text("Random Quote: \(randomQuote.quoteText)")
            }
            
            Button("Fetch Quotes") {
                networkManager.fetchQuotes()
            }
            ForEach(networkManager.quotes) { quote in
                Text("Quote: \(quote.quoteText), Author: \(quote.quoteAuthor)")
            }
            
            Button("Fetch All Genres") {
                networkManager.fetchAllGenres()
            }
            if let genres = networkManager.genres {
                Picker("Select Genre", selection: .constant("")) {
                    ForEach(genres.data, id: \.self) { genre in
                        Text(genre).tag(genre)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Button("Fetch All Authors") {
                networkManager.fetchAllAuthors()
            }
            if let authors = networkManager.authors {
                Picker("Select Author", selection: .constant("")) {
                    ForEach(authors.data, id: \.self) { author in
                        Text(author).tag(author)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
}

struct QGDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        QGDatabasePage()
    }
}

