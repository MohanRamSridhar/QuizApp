//
//  FAQView.swift
//  VTOP
//
//  Created by Mohan Ram  on 22/12/24.
//

import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQView: View {
    let faqs: [FAQItem] = [
        FAQItem(question: "What is this app for?", answer: "This app generates quiz questions to help you practice programming syntax."),
        FAQItem(question: "How are questions generated?", answer: "The app uses Google's Gemini API to generate language-specific True/False questions."),
        FAQItem(question: "Can I suggest improvements?", answer: "Yes! Feel free to send feedback through the App Store.")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(faqs) { faq in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Q: \(faq.question)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("A: \(faq.answer)")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                }
                
                // Footer
                Text("Made with ❤️ Mohan Ram Sridhar")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
            }
            .navigationTitle("FAQ")
        }
    }
}
