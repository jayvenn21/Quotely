import SwiftUI

struct AboutView: View {
    let userName = "Jayanth Vennamreddy"

    var body: some View {
        VStack {
            Spacer()

            VStack {
                // Title
                Text("About Quotely")
                    .font(.custom("Avenir-Black", size: 28)) // Using Avenir-Black font
                    .padding()

                // Description
                Text("Welcome to Quotely! This app generates random quotes based on two categories: length and creator. You can also add your own quotes. Enjoy!")
                    .font(.custom("Avenir-Black", size: 17)) // Using Avenir-Black font
                    .multilineTextAlignment(.center)
                    .padding()

                // User Name
                Text("\(userName)")
                    .italic()
                    .font(.custom("Avenir-Black", size: 17)) // Using Avenir-Black font
                    .padding(.top, 4)
            }
            
            Spacer()
        }
    }
}

