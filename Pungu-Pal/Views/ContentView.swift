import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext)
    private var modelContext

    @Query(
        sort: \FoodEntry.createdAt,
        order: .reverse
    )
    private var entries: [FoodEntry]

    @State private var showingAddFood = false

    private let calorieGoal = 2200

    var todaysEntries: [FoodEntry] {
        entries.filter {
            Calendar.current.isDateInToday($0.createdAt)
        }
    }

    var totalCalories: Int {
        todaysEntries.reduce(0) { $0 + $1.calories }
    }

    var breakfastEntries: [FoodEntry] {
        todaysEntries.filter { $0.mealType == .breakfast }
    }

    var lunchEntries: [FoodEntry] {
        todaysEntries.filter { $0.mealType == .lunch }
    }

    var dinnerEntries: [FoodEntry] {
        todaysEntries.filter { $0.mealType == .dinner }
    }

    var snackEntries: [FoodEntry] {
        todaysEntries.filter { $0.mealType == .snack }
    }

    var body: some View {

        NavigationStack {

            VStack {

                CalorieSummaryCard(
                    totalCalories: totalCalories,
                    calorieGoal: calorieGoal
                )
                .padding(.horizontal)

                List {

                    mealSection(
                        title: "Breakfast",
                        entries: breakfastEntries
                    )

                    mealSection(
                        title: "Lunch",
                        entries: lunchEntries
                    )

                    mealSection(
                        title: "Dinner",
                        entries: dinnerEntries
                    )

                    mealSection(
                        title: "Snacks",
                        entries: snackEntries
                    )
                }
            }
            .navigationTitle("PunguPal")
            .toolbar {

                Button {
                    showingAddFood = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(
                isPresented: $showingAddFood
            ) {
                AddFoodView()
            }
        }
    }

    @ViewBuilder
    private func mealSection(
        title: String,
        entries: [FoodEntry]
    ) -> some View {

        Section(title) {

            ForEach(entries) { entry in
                FoodRow(entry: entry)
            }
            .onDelete { offsets in
                deleteItems(
                    offsets,
                    from: entries
                )
            }
        }
    }

    private func deleteItems(
        _ offsets: IndexSet,
        from items: [FoodEntry]
    ) {

        for index in offsets {
            modelContext.delete(
                items[index]
            )
        }
    }
}
