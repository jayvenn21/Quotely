import SwiftUI

struct KanyeDatabasePage: View {
    @StateObject var networkManager = KanyeNetworkManager()
    
    var body: some View {
        VStack {
            Button("Fetch Random Kanye Quote") {
                networkManager.fetchRandomKanyeQuote()
            }
            if let randomKanyeQuote = networkManager.randomKanyeQuote {
                Text("Random Kanye Quote: \(randomKanyeQuote.quote)")
            }
        }
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

