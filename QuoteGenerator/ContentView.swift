import SwiftUI

struct ContentView: View {
    @State private var isButtonTapped = false
    @State private var touchedWordIndex: Int?

    let hoverWords = [
        "Inspiration", "Creativity", "Motivation", "Wisdom", "Imagination", "Innovation", "Positivity", "Dreams", "Courage", "Hope",
        "Believe", "Adventure", "Persistence", "Ambition", "Empowerment", "Gratitude", "Happiness", "Success", "Passion", "Optimism",
        "Kindness", "Freedom", "Unity", "Resilience", "Peace", "Love", "Joy", "Discovery", "Growth", "Balance", "Purpose", "Confidence",
        "Harmony", "Kindness", "Transformation", "Simplicity", "Gratitude", "Vision", "Strength", "Faith", "Progress", "Reflection",
        "Connection", "Curiosity", "Generosity", "Empathy", "Awareness", "Laughter", "Inspiration", "Creativity", "Motivation", "Wisdom",
        "Imagination", "Innovation", "Positivity", "Dreams", "Courage", "Hope", "Believe", "Adventure", "Persistence", "Ambition",
        "Empowerment", "Gratitude", "Happiness", "Success", "Passion", "Optimism", "Kindness", "Freedom", "Unity", "Resilience", "Peace",
        "Love", "Joy", "Discovery", "Growth", "Balance", "Purpose", "Confidence", "Harmony", "Kindness", "Transformation", "Simplicity",
        "Gratitude", "Vision", "Strength", "Faith", "Progress", "Reflection", "Connection", "Curiosity", "Generosity", "Empathy", "Awareness",
        "Laughter", "Inspiration", "Creativity", "Motivation", "Wisdom", "Imagination", "Innovation", "Positivity", "Dreams", "Courage", "Hope",
        "Believe", "Adventure", "Persistence", "Ambition", "Empowerment", "Gratitude", "Happiness", "Success", "Passion", "Optimism",
        "Kindness", "Freedom", "Unity", "Resilience", "Peace", "Love", "Joy", "Discovery", "Growth", "Balance", "Purpose", "Confidence",
        "Harmony", "Kindness", "Transformation", "Simplicity", "Gratitude", "Vision", "Strength", "Faith", "Progress", "Reflection",
        "Connection", "Curiosity", "Generosity", "Empathy", "Awareness", "Laughter", "Inspiration", "Creativity", "Motivation", "Wisdom",
        "Imagination", "Innovation", "Positivity", "Dreams", "Courage", "Hope", "Believe", "Adventure", "Persistence", "Ambition",
        "Empowerment", "Gratitude", "Happiness", "Success", "Passion", "Optimism", "Kindness", "Freedom", "Unity", "Resilience", "Peace",
        "Love", "Joy", "Discovery", "Growth", "Balance", "Purpose", "Confidence", "Harmony", "Kindness", "Transformation", "Simplicity",
        "Gratitude", "Vision", "Strength", "Faith", "Progress", "Reflection", "Connection", "Curiosity", "Generosity", "Empathy", "Awareness",
        "Laughter"
    ]

    @State private var wordPositions: [String: CGPoint] = [:]
    @State private var isDarkMode = false // State variable for light/dark mode

    init() {
        // Initialize wordPositions with random positions within the screen bounds for each word
        for word in hoverWords {
            let randomX = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
            let randomY = CGFloat.random(in: 0..<UIScreen.main.bounds.height)
            wordPositions[word] = CGPoint(x: randomX, y: randomY)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background with moving objects
                Color(UIColor(red: isDarkMode ? 0.1 : 0.95, green: isDarkMode ? 0.1 : 0.95, blue: isDarkMode ? 0.1 : 0.95, alpha: 1.0)) // Grayish background color

                VStack {
                    Spacer().frame(height: 50) // Add space at the top

                    HStack {
                        Spacer()
                        Button(action: {
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .font(.system(size: 24))
                                .padding()
                                .foregroundColor(isDarkMode ? .white : .black) // Set color based on light/dark mode
                                .background(Color.gray) // Highlight the button with a gray background
                                .clipShape(Circle()) // Clip the button into a circle shape
                        }
                        Spacer()
                    }
                    
                    Spacer() // Pushes the text to the middle
                    // Surrounding background for title text and button
                    VStack {
                        Text("Quotely")
                            .font(.system(size: 48, weight: .bold)) // Apple San Francisco font for the title
                            .foregroundColor(isDarkMode ? .white : .black) // Text color based on light/dark mode
                            .padding()
                            .scaleEffect(isButtonTapped ? 1.2 : 1) // Scale animation when button is tapped
                            .animation(.easeInOut(duration: 0.3), value: isButtonTapped) // Animation modifier with value

                        NavigationLink(destination: HomePage(isDarkMode: $isDarkMode), isActive: $isButtonTapped) {
                            EmptyView()
                        }
                        .hidden() // Hide the navigation link label

                        Button(action: {
                            withAnimation {
                                isButtonTapped.toggle()
                            }
                        }) {
                            Text("Open Quotely")
                                .font(.system(size: 24)) // Apple San Francisco font for the button
                                .foregroundColor(isDarkMode ? .green : .blue) // Button text color based on light/dark mode
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10) // Rounded button corners
                                .shadow(radius: 5) // Button shadow effect
                                .scaleEffect(isButtonTapped ? 0.95 : 1) // Scale animation when button is tapped
                        }
                    }
                    .background(Color(UIColor(red: isDarkMode ? 0.2 : 0.9, green: isDarkMode ? 0.2 : 0.9, blue: isDarkMode ? 0.2 : 0.9, alpha: 1.0))) // Darker gray background color
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Handle the touch or pointer movement here
                            touchedWordIndex = nil // Reset the touched word index
                        }
                    )

                    Spacer() // Pushes the button to the middle
                    Spacer() // Add spacer to extend background to bottom of screen
                }

                // Overlay with hovering words
                ZStack {
                    ForEach(hoverWords, id: \.self) { word in
                        HoveringWordView(word: word, isTouched: word == hoverWords[touchedWordIndex ?? 0], position: self.$wordPositions[word])
                            .zIndex(1) // Set a zIndex to ensure words are in front of all other elements
                            .gesture(
                                TapGesture().onEnded {
                                    // Handle tap on word
                                    isButtonTapped.toggle() // Trigger navigation to HomePage
                                }
                            )
                            .simultaneousGesture(
                                DragGesture().onChanged { gesture in
                                    // Handle drag gesture on word
                                    touchedWordIndex = hoverWords.firstIndex(of: word) // Update the touched word index
                                    let translation = gesture.translation
                                    // Update the position of the word
                                    self.wordPositions[word]?.x += translation.width
                                    self.wordPositions[word]?.y += translation.height
                                }
                            )
                    }
                }
            }
            .background(Color(UIColor(red: isDarkMode ? 0.2 : 0.9, green: isDarkMode ? 0.2 : 0.9, blue: isDarkMode ? 0.2 : 0.9, alpha: 1.0))) // Darker gray background color
            .navigationBarHidden(true) // Hide the navigation bar
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // Toggle between light and dark mode
    }
}

struct HoveringWordView: View {
    let word: String
    let isTouched: Bool
    @Binding var position: CGPoint?

    var body: some View {
        Text(word)
            .font(.system(size: 14)) // Apple San Francisco font
            .foregroundColor(randomColor()) // Random color for each word
            .position(position ?? .zero)
            .animation(Animation.linear(duration: Double.random(in: 2..<5)).repeatForever(autoreverses: true)) // Faster animation
            .onAppear {
                // Position word randomly within the screen bounds
                let randomX = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
                let randomY = CGFloat.random(in: 0..<UIScreen.main.bounds.height)
                self.position = CGPoint(x: randomX, y: randomY)
            }
    }

    func randomColor() -> Color {
        let red = Double.random(in: 0..<1)
        let green = Double.random(in: 0..<1)
        let blue = Double.random(in: 0..<1)
        return Color(red: red, green: green, blue: blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

