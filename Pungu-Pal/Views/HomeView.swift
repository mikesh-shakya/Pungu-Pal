import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject private var viewModel: HomeViewModel
    @State private var showLogFoodView = false
    
    init(managedObjectContext: NSManagedObjectContext? = nil) {
        let context = managedObjectContext ?? CoreDataManager.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.background.ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.padding) {
                    // Header
                    VStack(alignment: .leading, spacing: Constants.Dimensions.smallPadding) {
                        Text(Constants.Strings.today)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(Date().formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Constants.Dimensions.padding)
                    
                    // Calorie Summary Card
                    VStack(spacing: Constants.Dimensions.padding) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(Constants.Strings.consumed)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(viewModel.totalCaloriesConsumed)")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(Constants.Strings.remaining)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(viewModel.caloriesRemaining)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.caloriesRemaining < 0 ? .red : .green)
                            }
                        }
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                                    .fill(Color.gray.opacity(0.2))
                                
                                RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                                    .fill(Constants.Colors.primary)
                                    .frame(width: geometry.size.width * min(viewModel.progressPercentage, 1.0))
                            }
                        }
                        .frame(height: 8)
                        
                        HStack {
                            Text(Constants.Strings.dailyGoal)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(viewModel.currentUser?.dailyCalorieGoal ?? 0)")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(Constants.Dimensions.padding)
                    .background(Constants.Colors.cardBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    .padding(.horizontal, Constants.Dimensions.padding)
                    
                    // Food Logs
                    if viewModel.todaysFoodLogs.isEmpty {
                        VStack(spacing: Constants.Dimensions.padding) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No food logged yet")
                                .font(.body)
                                .foregroundColor(.gray)
                            Text("Start by logging your first meal")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .frame(maxHeight: .infinity)
                        .frame(maxWidth: .infinity)
                    } else {
                        List {
                            ForEach(viewModel.todaysFoodLogs, id: \.id) { log in
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
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteFoodLog(log)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: { showLogFoodView = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text(Constants.Strings.logFood)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(Constants.Dimensions.padding)
                        .background(Constants.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                        .padding(Constants.Dimensions.padding)
                    }
                }
            }
            .navigationTitle(Constants.Strings.appName)
            .sheet(isPresented: $showLogFoodView) {
                LogFoodView(isPresented: $showLogFoodView, onLogFood: {
                    viewModel.loadTodaysData()
                })
            }
            .onAppear {
                viewModel.loadTodaysData()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
}
