import SwiftUI

struct StoicismDatabasePage: View {
    @State private var randomQuote: StoicQuote?
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack {
            Text("Stoicism")
                .font(.custom("Avenir-Black", size: 34)) // Avenir-Black font for the title
                .padding()
            
            if let randomQuote = randomQuote {
                QuoteView(quote: randomQuote)
            } else {
                Text("Tap the button to generate a quote")
                    .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the text
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button("Fetch Random Quote") {
                fetchRandomQuote()
            }
            .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the button text
            .padding()
        }
        .onAppear {
            // Comment this line if you don't want the quote to be automatically generated
            //fetchRandomQuote()
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
                .font(.custom("Avenir-Black", size: 24)) // Avenir-Black font for the headline
                .padding()
            Text("- \(quote.author)")
                .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the subheadline
                .foregroundColor(.secondary)
        }
    }
}

struct StoicQuote: Codable {
    let author: String
    let quote: String
}

