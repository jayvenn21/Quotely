import SwiftUI

struct StoicismDatabasePage: View {
    @State private var randomQuote: StoicQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack {
            Text("Stoicism")
                .font(.title)
                .padding()
            
            Button("Fetch Random Quote") {
                fetchRandomQuote()
            }
            if let randomQuote = randomQuote {
                QuoteView(quote: randomQuote)
            }
        }
        .onAppear {
            fetchRandomQuote()
        }
    }
    
    func fetchRandomQuote() {
        guard let url = URL(string: "https://stoic.tekloon.net/stoic-quote") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(StoicQuote.self, from: data)
                DispatchQueue.main.async {
                    self.randomQuote = response
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}

struct StoicismDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        StoicismDatabasePage()
    }
}

struct QuoteView: View {
    let quote: StoicQuote
    
    var body: some View {
        VStack(alignment: .center) {
            Text(quote.quote)
                .font(.headline)
                .padding()
            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct StoicQuote: Codable {
    let author: String
    let quote: String
}

