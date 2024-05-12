import SwiftUI

struct QuoteDayQuote: Codable {
    let quote: String
    let author: String
}

struct QuoteDayPage: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // Store the selected quote and its generation date locally
    @State private var selectedQuote: QuoteDayQuote?
    @State private var quoteGenerationDate: Date?

    // Format to store the date in the user defaults
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Quote of the Day")
                .font(.title)
                .padding()
            
            if let quote = selectedQuote {
                QuoteDayView(quote: quote)
            } else {
                Text("Loading...")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            fetchRandomQuoteOfTheDay()
        }
    }
    
    // Function to fetch random quote of the day
    func fetchRandomQuoteOfTheDay() {
        // Check if there's a stored quote for today
        if let storedDate = UserDefaults.standard.string(forKey: "quoteGenerationDate"),
           let date = dateFormatter.date(from: storedDate),
           Calendar.current.isDate(date, inSameDayAs: Date()) {
            // If the stored quote is from today, use it
            if let storedQuoteData = UserDefaults.standard.data(forKey: "selectedQuote"),
               let storedQuote = try? JSONDecoder().decode(QuoteDayQuote.self, from: storedQuoteData) {
                selectedQuote = storedQuote
                return
            }
        }
        
        // If there's no stored quote for today or it's outdated, fetch a new quote
        let quoteDatabases = [
            "https://stoic.tekloon.net/stoic-quote",
            "https://zenquotes.io/api/random",
            "https://api.breakingbadquotes.xyz/v1/quotes",
            "https://lucifer-quotes.vercel.app/api/quotes",
            "https://movie-quote-api.herokuapp.com/v1/quote",
            "https://ron-swanson-quotes.herokuapp.com/v2/quotes",
            "https://strangerthings-quotes.vercel.app/api/quotes",
            "https://bcs-quotes.vercel.app/api/quotes",
            "https://officeapi.akashrajpurohit.com/quote/random"
            // Add more databases here
        ]

        // Fetch quotes from each database and combine them into a single array
        var allQuotes: [QuoteDayQuote] = []
        let dispatchGroup = DispatchGroup()
        
        for database in quoteDatabases {
            dispatchGroup.enter()
            guard let url = URL(string: database) else {
                dispatchGroup.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }
                guard let data = data, error == nil else { return }
                
                do {
                    let quotes = try JSONDecoder().decode([QuoteDayQuote].self, from: data)
                    allQuotes.append(contentsOf: quotes)
                } catch {
                    print("Failed to decode quotes from \(database): \(error)")
                }
            }.resume()
        }
        
        // Notify when all quotes are fetched
        dispatchGroup.notify(queue: .main) {
            // Select a random quote from the combined array
            if let randomQuote = allQuotes.randomElement() {
                // Store the selected quote and its generation date
                selectedQuote = randomQuote
                quoteGenerationDate = Date()
                // Store the quote and its generation date in UserDefaults
                if let quoteData = try? JSONEncoder().encode(randomQuote) {
                    UserDefaults.standard.set(quoteData, forKey: "selectedQuote")
                    UserDefaults.standard.set(dateFormatter.string(from: Date()), forKey: "quoteGenerationDate")
                }
            }
        }
    }
}

struct QuoteDayView: View {
    let quote: QuoteDayQuote
    
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

