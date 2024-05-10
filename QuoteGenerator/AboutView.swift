import SwiftUI

struct AboutView: View {
    let userName = "Jayanth Vennamreddy"

    var body: some View {
        ZStack {
            Color(UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)) // Light gray background
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("About Quotely")
                    .font(.custom("Avenir-Black", size: 28)) // Avenir-Black font for the title
                    .padding()
                    .foregroundColor(.black) // Black text color

                Text("Welcome to Quotely! This app generates random quotes based on two categories: length and creator. You can also add your own quotes. Enjoy!")
                    .font(.custom("Avenir-Black", size: 18)) // Avenir-Black font for the text
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.black) // Black text color

                Text("\(userName)")
                    .italic() // Italicize the text
                    .padding(.top, 4) // Add top padding
                    .foregroundColor(.black) // Black text color

                Spacer()
            }
            .foregroundColor(.black) // Set text color to black
        }
    }
}

