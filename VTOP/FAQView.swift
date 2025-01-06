//
//  FAQView.swift
//  VTOP
//
//  Created by Mohan Ram  on 22/12/24.
//

import Foundation
import SwiftUICore
import SwiftUI

struct FAQView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("Q: What is this app for?")
                    Text("A: This app generates quiz questions to help you practice programming syntax.")
                        .padding(.bottom)
                    
                    Text("Q: How are questions generated?")
                    Text("A: The app uses Google's Gemini API to generate language-specific True/False questions.")
                        .padding(.bottom)
                    
                    Text("Q: Can I suggest improvements?")
                    Text("A: Yes! Feel free to send feedback through the App Store.")
                        .padding(.bottom)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("FAQ")
        }
    }
}
