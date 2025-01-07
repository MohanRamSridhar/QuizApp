//
//  MockData.swift
//  VTOP
//
//  Created by Mohan Ram  on 05/01/25.
//

import UIKit
import SwiftUI

struct PageData {
    let title: String
    let header: String
    let content: String
    let imageName: String
    let color: Color
    let textColor: Color
}

struct MockData {
    static let pages: [PageData] = [
        PageData(
            title: "Getting Started",
            header: "Step 1",
            content: "Select the language you want to take a quiz in from the available options.",
            imageName: "screen 1",
            color: Color(hex: "9B5DE5"), // Vibrant purple
            textColor: Color(hex: "FFFFFF") // White for contrast
        ),
        PageData(
            title: "Getting Started",
            header: "Step 2",
            content: "If your answer is 'True,' swipe right. If you think the answer is 'False,' swipe left.",
            imageName: "screen 2",
            color: Color(hex: "C4A6E7"), // Light purple
            textColor: Color(hex: "4A4A4A") // Dark gray for readability
        ),
        PageData(
            title: "Getting Started",
            header: "Step 3",
            content: "Complete the quiz and discover how strong your skills are in the selected language.",
            imageName: "screen 3",
            color: Color(hex: "D8B4E2"), // Softer pastel purple
            textColor: Color(hex: "4A4A4A") // Dark gray for readability
        ),
        PageData(
            title: "Getting Started",
            header: "More",
            content: "For more information, check the FAQ page.",
            imageName: "screen 4",
            color: Color(hex: "E9C6F3"), // Very light purple
            textColor: Color(hex: "4A4A4A") // Dark gray for readability
        ),
    ]
}

/// Color converter from hex string to SwiftUI's Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
