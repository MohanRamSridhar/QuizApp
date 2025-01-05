//
//  ContentView.swift
//  VTOP
//
//  Created by Mohan Ram on 13/12/24.
//

import GoogleGenerativeAI
import SwiftUI

enum APIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        guard let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") {
            fatalError("Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key.")
        }
        return value
    }
}

let config = GenerationConfig(
    temperature: 1,
    topP: 0.95,
    topK: 40,
    maxOutputTokens: 8192,
    responseMIMEType: "text/plain"
)

let model = GenerativeModel(
    name: "gemini-2.0-flash-exp",
    apiKey: APIKey.default,
    generationConfig: config
)

struct QuestionCard: Identifiable {
    let id = UUID()
    let question: String
    let answer: Bool
}

struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            .font(.custom("Open Sans", size: 18))
    }
}

struct ContentView: View {

    @Environment(\.colorScheme) var colorScheme
    @State private var selectedLanguage: String = ""
    @State private var showGameView: Bool = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    let allLanguages = [
        "Java", "Python", "C++", "C", "SQL", "HTML", "JavaScript",
        "TypeScript", "Kotlin", "Swift", "Ruby", "PHP", "Go", "R",
        "Perl", "Rust", "Dart", "Scala", "Clojure", "Haskell", "MATLAB",
        "Objective-C", "Shell", "Assembly", "Lua", "Visual Basic"
    ]

    var filteredLanguages: [String] {
        guard !selectedLanguage.isEmpty else { return allLanguages }
        return allLanguages.filter { $0.lowercased().hasPrefix(selectedLanguage.lowercased()) }
    }
    
    var body: some View {
        if hasSeenOnboarding {
            mainContentView
        } else {
            OnBoardView {
                withAnimation {
                    hasSeenOnboarding = true
                }
            }
        }
    }

    var mainContentView: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.6)]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    Text("Generate and answer programming questions to test your skills.")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text("1. Select or search for a programming language from the home screen.\n2. Click 'Generate Questions' to start the quiz.\n3. Swipe the cards left or right to answer 'True' or 'False'.\n4. Check your score and try again to improve!")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)

                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Enter the language", text: $selectedLanguage)
                                .disableAutocorrection(true)
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        }
                        .modifier(customViewModifier(roundedCornes: 6, startColor: .cyan, endColor: .purple, textColor: .white))

                        Text("Or select a language:")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                        if filteredLanguages.isEmpty {
                            Text("No results found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(filteredLanguages, id: \.self) { language in
                                        Button(action: {
                                            selectedLanguage = language
                                        }) {
                                            Text(language)
                                                .padding()
                                                .background(selectedLanguage == language ? Color.blue : Color.gray.opacity(0.3))
                                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                                .cornerRadius(20)
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
                                                .animation(.spring(), value: selectedLanguage)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    Button(action: {
                        if !selectedLanguage.isEmpty && allLanguages.contains(selectedLanguage) {
                            showGameView = true
                        }
                    }) {
                        Text("Generate Questions")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!selectedLanguage.isEmpty && allLanguages.contains(selectedLanguage) ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                            .scaleEffect(!selectedLanguage.isEmpty && allLanguages.contains(selectedLanguage) ? 1.05 : 1.0)
                            .animation(.easeInOut, value: selectedLanguage)
                    }
                    .disabled(selectedLanguage.isEmpty || !allLanguages.contains(selectedLanguage))
                    .padding()

                    NavigationLink(value: showGameView) {
                        EmptyView()
                    }
                    .navigationDestination(isPresented: $showGameView) {
                        GameView(selectedLanguage: selectedLanguage)
                    }
                }
                .navigationTitle("Question Generator")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: FAQView()) {
                            Text("FAQ")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                }
                .padding()
            }
        }
    }
}


extension String {
    func matches(for regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return [] }
        let range = NSRange(self.startIndex..., in: self)
        let matches = regex.matches(in: self, range: range)

        return matches.map { match in
            (0..<match.numberOfRanges).compactMap {
                Range(match.range(at: $0), in: self).map { String(self[$0]) }
            }
        }
    }
}

#Preview {
    ContentView()
}
