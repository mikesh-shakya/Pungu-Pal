import SwiftUI
import SwiftData

struct AddFoodView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.modelContext)
    private var modelContext

    @State private var name = ""
    @State private var calories = ""

    @State private var mealType: MealType = .breakfast

    var body: some View {

        NavigationStack {

            Form {

                TextField(
                    "Food Name",
                    text: $name
                )

                TextField(
                    "Calories",
                    text: $calories
                )
                .keyboardType(.numberPad)

                Picker(
                    "Meal",
                    selection: $mealType
                ) {
                    ForEach(
                        MealType.allCases,
                        id: \.self
                    ) { meal in

                        Text(meal.rawValue.capitalized)
                            .tag(meal)
                    }
                }
            }
            .navigationTitle("Add Food")
            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(
                    placement: .confirmationAction
                ) {
                    Button("Save") {
                        saveFood()
                    }
                }
            }
        }
    }

    private func saveFood() {

        guard let calorieValue = Int(calories)
        else { return }

        let food = FoodEntry(
            name: name,
            calories: calorieValue,
            mealType: mealType
        )

        modelContext.insert(food)

        dismiss()
    }
}
