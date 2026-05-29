import SwiftUI

struct CalorieSummaryCard: View {

    let totalCalories: Int
    let calorieGoal: Int

    var remainingCalories: Int {
        calorieGoal - totalCalories
    }

    var body: some View {

        VStack(spacing: 8) {

            Text("Calories Remaining")
                .font(.headline)

            Text("\(remainingCalories)")
                .font(.system(size: 48, weight: .bold))

            Text("\(totalCalories) / \(calorieGoal) consumed")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}