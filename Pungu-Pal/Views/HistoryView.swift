import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var selectedDate = Date()
    @State private var foodLogs: [FoodLog] = []
    @State private var totalCalories: Int32 = 0
    @State private var user: User?
    
    let foodService = FoodService.shared
    let coreDataManager = CoreDataManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.background.ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.padding) {
                    // Date Picker
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding(Constants.Dimensions.padding)
                    .background(Constants.Colors.cardBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    .padding(Constants.Dimensions.padding)
                    .onChange(of: selectedDate) {
                        loadDataForSelectedDate()
                    }
                    
                    // Summary Card
                    VStack(spacing: Constants.Dimensions.padding) {
                        HStack {
                            Text("Total Consumed")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(totalCalories)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Constants.Colors.primary)
                        }
                        
                        if let dailyGoal = user?.dailyCalorieGoal {
                            HStack {
                                Text("Daily Goal")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(dailyGoal)")
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Remaining")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(dailyGoal - totalCalories)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(dailyGoal - totalCalories < 0 ? .red : .green)
                            }
                        }
                    }
                    .padding(Constants.Dimensions.padding)
                    .background(Constants.Colors.cardBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    .padding(.horizontal, Constants.Dimensions.padding)
                    
                    // Food Logs List
                    if foodLogs.isEmpty {
                        VStack(spacing: Constants.Dimensions.padding) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No logs for this date")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity)
                        .frame(maxWidth: .infinity)
                    } else {
                        List {
                            ForEach(foodLogs, id: \.id) { log in
                                HStack {
                                    VStack(alignment: .leading, spacing: Constants.Dimensions.smallPadding) {
                                        Text(log.food?.name ?? "Unknown Food")
                                            .fontWeight(.semibold)
                                        Text("Qty: \(log.quantity, specifier: "%.1f")")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("\(log.totalCalories)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Constants.Colors.primary)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(Constants.Strings.history)
            .onAppear {
                loadUserAndData()
            }
        }
    }
    
    private func loadUserAndData() {
        user = coreDataManager.getOrCreateDefaultUser(context: managedObjectContext)
        loadDataForSelectedDate()
    }
    
    private func loadDataForSelectedDate() {
        guard let user = user else { return }
        
        foodLogs = foodService.getFoodLogsForDate(selectedDate, user: user, context: managedObjectContext)
        totalCalories = foodService.getTotalCaloriesForDate(selectedDate, user: user, context: managedObjectContext)
    }
}

#Preview {
    HistoryView()
        .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
}
