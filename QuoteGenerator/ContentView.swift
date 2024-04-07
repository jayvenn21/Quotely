import SwiftUI

struct ContentView: View {
    @State private var position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                          y: CGFloat.random(in: 0...UIScreen.main.bounds.height)) // Random initial position of the object
    @State private var velocity = CGVector(dx: 5, dy: 2) // Initial velocity of the object
    let objectSize: CGFloat = 50 // Size of the object
    let animationDuration: Double = 0.02 // Animation duration

    var body: some View {
        ZStack {
            // Background with moving objects
            Color.white // Background color
            
            Circle()
                .foregroundColor(.blue)
                .frame(width: objectSize, height: objectSize)
                .position(position)
                .animation(nil) // Disable animation for the background object
                .onAppear {
                    self.startAnimation() // Start animation when view appears
                }

            VStack {
                Spacer() // Pushes the text to the middle
                Text("Quote Generator")
                    .font(.title)
                    .padding()

                Button("Open Quote Generator") {
                    print("Open Quote Generator tapped")
                    // You can add navigation logic here
                }
                .padding()

                Spacer() // Pushes the button to the middle
            }
        }
    }

    // Function to start animation
    func startAnimation() {
        withAnimation(Animation.linear(duration: animationDuration).repeatForever()) {
            self.updatePosition() // Update position continuously
        }
    }

    // Function to update position
    func updatePosition() {
        position.x += velocity.dx
        position.y += velocity.dy

        // Bounce off the walls
        if position.x <= 0 || position.x >= UIScreen.main.bounds.width - objectSize {
            velocity.dx = -velocity.dx
        }
        if position.y <= 0 || position.y >= UIScreen.main.bounds.height - objectSize {
            velocity.dy = -velocity.dy
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

