import SwiftUI

struct ContentView: View {
    @State private var isButtonTapped = false

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
            }
            .background(Color(UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0))) // Beige background color
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

