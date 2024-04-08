import SwiftUI

struct ContentView: View {
    @State private var isButtonTapped = false

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

    var body: some View {
        NavigationView {
            ZStack {
                // Background with moving objects
                Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)) // Beige background color
                
                VStack {
                    Spacer() // Pushes the text to the middle
                    Text("Quote Generator")
                        .font(.custom("Helvetica-Bold", size: 28)) // Cool font for the title
                        .foregroundColor(.blue) // Blue color for the title text
                        .padding()
                        .scaleEffect(isButtonTapped ? 1.2 : 1) // Scale animation when button is tapped
                        .animation(.easeInOut(duration: 0.3), value: isButtonTapped) // Animation modifier with value
                        // Indicates that animation should only occur when the value of isButtonTapped changes
                    
                    NavigationLink(destination: HomePage(), isActive: $isButtonTapped) {
                        EmptyView()
                    }
                    .hidden() // Hide the navigation link label
                    
                    Button(action: {
                        withAnimation {
                            isButtonTapped.toggle()
                        }
                    }) {
                        Text("Open Quote Generator")
                            .font(.custom("Helvetica", size: 18)) // Cool font for the button
                            .foregroundColor(.green) // Green color for the button text
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10) // Rounded button corners
                            .shadow(radius: 5) // Button shadow effect
                            .scaleEffect(isButtonTapped ? 0.95 : 1) // Scale animation when button is tapped
                    }
                    
                    Spacer() // Pushes the button to the middle
                }
                
                // Overlay with hovering words
                ForEach(0..<hoverWords.count, id: \.self) { index in
                    HoveringWord(word: hoverWords[index])
                }
            }
            .background(Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0))) // Beige background color
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}

struct HoveringWord: View {
    let word: String
    @State private var position = CGPoint(x: CGFloat.random(in: 0..<500), y: CGFloat.random(in: 0..<500))

    var body: some View {
        Text(word)
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .position(position)
            .animation(Animation.linear(duration: Double.random(in: 10..<30)).repeatForever(autoreverses: true))
            .onAppear {
                self.position = CGPoint(x: CGFloat.random(in: 0..<500), y: CGFloat.random(in: 0..<500))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

