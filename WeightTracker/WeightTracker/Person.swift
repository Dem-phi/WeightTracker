import Foundation
import SwiftUI

enum Person: String, CaseIterable, Identifiable {
    case me = "Zack Chen"
    case girlfriend = "Aria Luo"

    var color: Color {
        switch self {
        case .me:
            return .blue
        case .girlfriend:
            return .pink
        }
    }

    var id: String { rawValue }

    var displayName: String {
        return self.rawValue
    }
}