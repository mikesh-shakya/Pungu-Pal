import SwiftUI

struct Constants {
    struct Colors {
        static let primary = Color(red: 0.2, green: 0.7, blue: 0.4)
        static let secondary = Color(red: 0.1, green: 0.5, blue: 0.2)
        static let accent = Color(red: 1.0, green: 0.6, blue: 0.0)
        static let background = Color(UIColor.systemBackground)
        static let cardBackground = Color(UIColor.secondarySystemBackground)
    }
    
    struct Strings {
        static let appName = "Pungu Pal"
        static let dailyGoal = "Daily Goal"
        static let remaining = "Remaining"
        static let consumed = "Consumed"
        static let today = "Today"
        static let history = "History"
        static let settings = "Settings"
        static let addFood = "Add Food"
        static let logFood = "Log Food"
    }
    
    struct Dimensions {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
    }
}
