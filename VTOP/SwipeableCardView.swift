//
//  SwipeableCardView.swift
//  VTOP
//
//  Created by Mohan Ram  on 15/12/24.
//

import Foundation
import SwiftUI

struct SwipeableCardView: View {
    let card: QuestionCard
    let onAnswer: (Bool) -> Void

    @Environment(\.colorScheme) var colorScheme
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(dynamicColor(for: colorScheme, lightModeColor: .white, darkModeColor: .gray))
                .frame(width: 350, height: 500)
                .shadow(radius: 10)

            Text(card.question)
                .font(.title2)
                .foregroundColor(dynamicColor(for: colorScheme, lightModeColor: .black, darkModeColor: .white))
                .padding()
        }
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    rotation = Double(offset.width / 10)
                }
                .onEnded { _ in
                    if offset.width > 100 {
                        onAnswer(true)
                    } else if offset.width < -100 {
                        onAnswer(false)
                    }
                    offset = .zero
                    rotation = 0
                }
        )
    }

    private func dynamicColor(for colorScheme: ColorScheme, lightModeColor: Color, darkModeColor: Color) -> Color {
        colorScheme == .light ? lightModeColor : darkModeColor
    }
}
