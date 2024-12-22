//
//  InstructionsView.swift
//  VTOP
//
//  Created by Mohan Ram  on 22/12/24.
//

import Foundation
import SwiftUICore
import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How to Use the App")
                .font(.largeTitle)
                .bold()

            Text("1. Select or search for a programming language from the home screen.")
            Text("2. Click 'Generate Questions' to start the quiz.")
            Text("3. Swipe the cards left or right to answer 'True' or 'False'.")
            Text("4. Check your score and try again to improve!")
            Spacer()
        }
        .padding()
        .navigationTitle("Instructions")
    }
}
