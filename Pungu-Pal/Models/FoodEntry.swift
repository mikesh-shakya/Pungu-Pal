import Foundation
import SwiftData

@Model
final class FoodEntry {

    var name: String
    var calories: Int
    var mealType: MealType
    var createdAt: Date

    init(
        name: String,
        calories: Int,
        mealType: MealType,
        createdAt: Date = Date()
    ) {
        self.name = name
        self.calories = calories
        self.mealType = mealType
        self.createdAt = createdAt
    }
}