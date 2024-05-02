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
    @State private var isDarkMode = false

    init() {
        for word in hoverWords {
            let randomX = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
            let randomY = CGFloat.random(in: 0..<UIScreen.main.bounds.height)
            wordPositions[word] = CGPoint(x: randomX, y: randomY)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(UIColor(red: isDarkMode ? 0.1 : 0.95, green: isDarkMode ? 0.1 : 0.95, blue: isDarkMode ? 0.1 : 0.95, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer().frame(height: 50)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .font(.system(size: 24))
                                .padding(12)
                                .foregroundColor(isDarkMode ? .white : .black)
                                .background(Color.gray)
                                .clipShape(Circle())
                                .padding()
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Quotely")
                            .font(.custom("Avenir-Black", size: 60))
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding()
                            .scaleEffect(isButtonTapped ? 1.2 : 1)
                            .animation(.easeInOut(duration: 0.3), value: isButtonTapped)
                            .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        
                        NavigationLink(destination: HomePage(isDarkMode: $isDarkMode), isActive: $isButtonTapped) {
                            EmptyView()
                        }
                        .hidden()
                        
                        Button(action: {
                            withAnimation {
                                isButtonTapped.toggle()
                            }
                        }) {
                            Text("Open Quotely")
                                .font(.custom("Avenir-Heavy", size: 24))
                                .foregroundColor(isDarkMode ? .green : .blue)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .scaleEffect(isButtonTapped ? 0.95 : 1)
                        }
                        .padding(.bottom, 40)
                    }
                    .background(Color(UIColor(red: isDarkMode ? 0.2 : 0.9, green: isDarkMode ? 0.2 : 0.9, blue: isDarkMode ? 0.2 : 0.9, alpha: 1.0)))
                    .cornerRadius(20)
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .padding()
                    
                    Spacer()
                }

                ZStack {
                    ForEach(hoverWords, id: \.self) { word in
                        HoveringWordView(word: word, isTouched: word == hoverWords[touchedWordIndex ?? 0], position: self.$wordPositions[word])
                            .zIndex(1)
                            .gesture(
                                TapGesture().onEnded {
                                    isButtonTapped.toggle()
                                }
                            )
                            .simultaneousGesture(
                                DragGesture().onChanged { gesture in
                                    touchedWordIndex = hoverWords.firstIndex(of: word)
                                    let translation = gesture.translation
                                    self.wordPositions[word]?.x += translation.width
                                    self.wordPositions[word]?.y += translation.height
                                }
                            )
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct HoveringWordView: View {
    let word: String
    let isTouched: Bool
    @Binding var position: CGPoint?

    var body: some View {
        Text(word)
            .font(.custom("Avenir-Medium", size: 18))
            .foregroundColor(randomColor())
            .position(position ?? .zero)
            .animation(Animation.linear(duration: Double.random(in: 2..<5)).repeatForever(autoreverses: true))
            .onAppear {
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

