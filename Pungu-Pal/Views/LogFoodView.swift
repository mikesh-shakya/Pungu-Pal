import SwiftUI
import CoreData

struct LogFoodView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject private var viewModel: LogFoodViewModel
    @Binding var isPresented: Bool
    var onLogFood: () -> Void = {}
    
    @State private var showNewFoodForm = false
    @State private var tempUser: User?
    
    init(managedObjectContext: NSManagedObjectContext? = nil, isPresented: Binding<Bool>, onLogFood: @escaping () -> Void = {}) {
        let context = managedObjectContext ?? CoreDataManager.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: LogFoodViewModel(context: context))
        self._isPresented = isPresented
        self.onLogFood = onLogFood
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.background.ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.padding) {
                    Form {
                        Section(header: Text("Select or Add Food")) {
                            if viewModel.availableFoods.isEmpty && !showNewFoodForm {
                                Button(action: { showNewFoodForm = true }) {
                                    Text("Create New Food")
                                        .foregroundColor(Constants.Colors.primary)
                                }
                            } else if showNewFoodForm {
                                TextField("Food Name", text: $viewModel.foodName)
                                TextField("Calories", text: $viewModel.calories)
                                    .keyboardType(.numberPad)
                            } else {
                                Picker("Food", selection: $viewModel.selectedFood) {
                                    Text("Select a food").tag(nil as Food?)
                                    ForEach(viewModel.availableFoods, id: \.id) { food in
                                        Text("\(food.name) (\(food.calories) cal)")
                                            .tag(food as Food?)
                                    }
                                }
                                
                                Button(action: { showNewFoodForm = true }) {
                                    Text("Add New Food")
                                        .foregroundColor(Constants.Colors.primary)
                                }
                            }
                        }
                        
                        if showNewFoodForm {
                            Button(action: viewModel.addNewFood) {
                                Text("Create Food")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Constants.Colors.primary)
                        } else if viewModel.selectedFood != nil {
                            Section(header: Text("Quantity")) {
                                TextField("Quantity", text: $viewModel.quantity)
                                    .keyboardType(.decimalPad)
                            }
                            
                            Button(action: {
                                if tempUser == nil {
                                    tempUser = CoreDataManager.shared.getOrCreateDefaultUser(context: managedObjectContext)
                                }
                                if let user = tempUser {
                                    viewModel.logSelectedFood(user: user)
                                    onLogFood()
                                    isPresented = false
                                }
                            }) {
                                Text("Log Food")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Constants.Colors.primary)
                        }
                    }
                    
                    Spacer()
                }
                
                if viewModel.showError {
                    VStack {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.white)
                            Text(viewModel.errorMessage)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(Constants.Dimensions.padding)
                        .background(Color.red)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                        .padding(Constants.Dimensions.padding)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle(Constants.Strings.addFood)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    LogFoodView(isPresented: .constant(true))
        .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
}
