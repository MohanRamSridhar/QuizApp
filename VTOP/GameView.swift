import SwiftUI
import GoogleGenerativeAI

struct GameView: View {
    let selectedLanguage: String

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @State private var cards: [QuestionCard] = []
    @State private var userScore: Int = 0
    @State private var answerFeedbackColor: Color = .clear
    @State private var isLoading: Bool = false
    @State private var totalQuestions: Int = 0
    @State private var startTime: Date?
    @State private var endTime: Date?
    @State private var progress: Double = 0 // For animated progress

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                if isLoading {
                    ProgressView("Generating questions...")
                        .padding()
                } else if !cards.isEmpty {
                    VStack {
                        // Cartoonish Progress Indicator
                        HStack {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.green.opacity(0.3))
                                        .frame(height: 20)

                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.green)
                                        .frame(width: geometry.size.width * CGFloat(progress / Double(totalQuestions)),
                                               height: 20)
                                        .animation(.spring(), value: progress)
                                }
                            }
                            .frame(height: 30)
                        }
                        .padding()

                        ZStack {
                            ForEach(cards) { card in
                                SwipeableCardView(card: card) { isCorrect in
                                    evaluateAnswer(isCorrect, for: card)
                                }
                            }
                        }
                        .padding()

                        Text("Score: \(userScore)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                } else {
                    // End of Quiz Summary
                    VStack(spacing: 20) {
                        Text("Quiz Summary")
                            .font(.largeTitle)
                            .foregroundColor(.white)

                        Text("Correct Answers: \(userScore)")
                            .font(.headline)
                            .foregroundColor(.white)

                        if let startTime = startTime, let endTime = endTime {
                            let timeTaken = endTime.timeIntervalSince(startTime)
                            Text("Time Taken: \(Int(timeTaken)) seconds")
                                .font(.headline)
                                .foregroundColor(.white)
                        }

                        if totalQuestions > 0 {
                            let percentage = Double(userScore) / Double(totalQuestions) * 100
                            Text("Percentage Score: \(String(format: "%.2f", percentage))%")
                                .font(.headline)
                                .foregroundColor(.white)
                        }

                        Button("Play Again") {
                            dismiss()
                        }
                        .padding()
                        .background(selectedLanguage.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                        .scaleEffect(selectedLanguage.isEmpty ? 1.0 : 1.05)
                        .animation(.easeInOut, value: selectedLanguage)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Quiz Time", displayMode: .inline)
        .onAppear {
            generateQuestions(for: selectedLanguage)
        }
    }

    private func evaluateAnswer(_ userAnswer: Bool, for card: QuestionCard) {
        if userAnswer == card.answer {
            userScore += 1
        }
        removeCard(card)
    }

    private func removeCard(_ card: QuestionCard) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards.remove(at: index)
            updateProgress()
        }

        // If all cards are answered, record the end time
        if cards.isEmpty {
            endTime = Date()
        }
    }

    private func updateProgress() {
        progress = Double(totalQuestions - cards.count)
    }

    private func generateQuestions(for language: String) {
        isLoading = true
        startTime = Date() // Record the start time
        Task {
            do {
                let chat = model.startChat(history: [
                    ModelContent(role: "user", parts: [
                        .text("Generate a list of true or false questions for \(language) syntax. Each question should follow this format exactly: QuestionCard(question: \"<question_text>\", answer: <true_or_false>)")
                    ])
                ])

                let response = try await chat.sendMessage(language)
                if let generatedQuestions = parseQuestions(from: response.text ?? "") {
                    DispatchQueue.main.async {
                        self.cards = generatedQuestions
                        self.totalQuestions = generatedQuestions.count
                        self.progress = 0 // Reset progress
                        self.isLoading = false
                    }
                } else {
                    print("Parsing failed or no questions found.")
                    isLoading = false
                }
            } catch {
                print("Error generating questions: \(error)")
                isLoading = false
            }
        }
    }

    private func parseQuestions(from response: String) -> [QuestionCard]? {
        let regex = #"QuestionCard\(question: \"(.*?)\", answer: (true|false)\)"#
        let matches = response.matches(for: regex)

        return matches.compactMap { match in
            guard match.count == 3, let answer = Bool(match[2]) else { return nil }
            return QuestionCard(question: match[1], answer: answer)
        }
    }
}
