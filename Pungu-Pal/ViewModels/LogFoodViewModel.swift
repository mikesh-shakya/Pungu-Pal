import Foundation
import CoreData

class LogFoodViewModel: NSObject, ObservableObject {
    @Published var foodName: String = ""
    @Published var calories: String = ""
    @Published var quantity: String = "1"
    @Published var selectedFood: Food?
    @Published var availableFoods: [Food] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    let coreDataManager = CoreDataManager.shared
    let foodService = FoodService.shared
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        loadAvailableFoods()
    }
    
    func loadAvailableFoods() {
        availableFoods = foodService.getAllFoods(context: context)
    }
    
    func addNewFood() {
        guard !foodName.isEmpty else {
            showError = true
            errorMessage = "Food name is required"
            return
        }
        
        guard let caloriesValue = Int(calories), caloriesValue > 0 else {
            showError = true
            errorMessage = "Please enter valid calories"
            return
        }
        
        let newFood = foodService.addFood(
            name: foodName,
            calories: caloriesValue,
            context: context
        )
        
        selectedFood = newFood
        loadAvailableFoods()
        resetForm()
    }
    
    func logSelectedFood(user: User) {
        guard let food = selectedFood else {
            showError = true
            errorMessage = "Please select a food"
            return
        }
        
        guard let quantityValue = Double(quantity), quantityValue > 0 else {
            showError = true
            errorMessage = "Please enter valid quantity"
            return
        }
        
        _ = foodService.logFood(food: food, quantity: quantityValue, user: user, context: context)
        resetForm()
    }
    
    private func resetForm() {
        foodName = ""
        calories = ""
        quantity = "1"
        selectedFood = nil
    }
}
