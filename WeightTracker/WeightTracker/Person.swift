import Foundation
import SwiftUI

enum Person: String, CaseIterable, Identifiable {
    case me = "我"
    case girlfriend = "女朋友"

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