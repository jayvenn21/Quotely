import SwiftUI

struct KanyeDatabasePage: View {
    @StateObject var networkManager = KanyeNetworkManager()
    
    var body: some View {
        VStack {
            Text("Kanye")
                .font(.custom("Avenir-Black", size: 34)) // Avenir-Black font for the title
                .padding()

            if let quote = networkManager.randomKanyeQuote {
                VStack {
                    Text("\"\(quote.quote)\"")
                        .font(.custom("Avenir-Black", size: 24)) // Avenir-Black font for the headline
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- Kanye")
                        .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the subheadline
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Tap the button to generate a quote")
                    .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the text
                    .foregroundColor(.gray)
                    .padding()
            }

            Button("Generate Quote") {
                networkManager.fetchRandomKanyeQuote()
            }
            .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the button text
            .padding()
        }
        .padding()
    }
}

struct KanyeDatabasePage_Previews: PreviewProvider {
    static var previews: some View {
        KanyeDatabasePage()
    }
}

struct KanyeQuote: Codable {
    let quote: String
}

class KanyeNetworkManager: ObservableObject {
    @Published var randomKanyeQuote: KanyeQuote?
    
    func fetchRandomKanyeQuote() {
        guard let url = URL(string: "https://api.kanye.rest") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let kanyeQuote = try? JSONDecoder().decode(KanyeQuote.self, from: data) {
                DispatchQueue.main.async {
                    self.randomKanyeQuote = kanyeQuote
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
}

