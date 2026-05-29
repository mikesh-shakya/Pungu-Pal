import SwiftUI
import SwiftData

struct ContentView: View {

    @Query(
        sort: \FoodEntry.createdAt,
        order: .reverse
    )
    private var entries: [FoodEntry]

    @State private var showingAddFood = false

    var totalCalories: Int {
        entries.reduce(0) { $0 + $1.calories }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                VStack {
                    Text("Today's Calories")
                        .font(.headline)

                    Text("\(totalCalories)")
                        .font(.system(size: 48, weight: .bold))
                }

                List {
                    ForEach(entries) { entry in
                        HStack {
                            Text(entry.name)

                            Spacer()

                            Text("\(entry.calories)")
                        }
                    }
                }
            }
            .navigationTitle("Calories")
            .toolbar {
                Button {
                    showingAddFood = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView()
            }
        }
    }
}