import SwiftUI

struct AboutView: View {
    let userName = "Jayanth Vennamreddy"

    var body: some View {
        VStack {
            Text("About Quotely")
                .font(.title)
                .padding()

            Text("Welcome to Quotely! This app generates random quotes based on two categories: length and creator. You can also add your own quotes. Enjoy!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Text("\(userName)")
                .italic()
                .padding(.top, 4)

            Spacer()
        }
    }
}

