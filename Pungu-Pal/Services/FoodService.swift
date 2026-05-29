import Foundation
import CoreData

class FoodService {
    static let shared = FoodService()
    
    let coreDataManager = CoreDataManager.shared
    
    // MARK: - Food Operations
    
    func addFood(name: String, calories: Int, protein: Double = 0, carbs: Double = 0, fat: Double = 0, servingSize: String = "1 serving", context: NSManagedObjectContext) -> Food {
        let food = Food(context: context)
        food.id = UUID()
        food.name = name
        food.calories = Int32(calories)
        food.protein = protein
        food.carbs = carbs
        food.fat = fat
        food.servingSize = servingSize
        food.createdAt = Date()
        
        coreDataManager.save()
        return food
    }
    
    func getAllFoods(context: NSManagedObjectContext) -> [Food] {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Food.createdAt, ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching foods: \(error)")
            return []
        }
    }
    
    // MARK: - FoodLog Operations
    
    func logFood(food: Food, quantity: Double, user: User, context: NSManagedObjectContext) -> FoodLog {
        let foodLog = FoodLog(context: context)
        foodLog.id = UUID()
        foodLog.food = food
        foodLog.user = user
        foodLog.quantity = quantity
        foodLog.totalCalories = Int32(Double(food.calories) * quantity)
        foodLog.date = Date()
        foodLog.createdAt = Date()
        
        coreDataManager.save()
        return foodLog
    }
    
    func getFoodLogsForDate(_ date: Date, user: User, context: NSManagedObjectContext) -> [FoodLog] {
        let fetchRequest: NSFetchRequest<FoodLog> = FoodLog.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "date >= %@", startOfDay as NSDate),
            NSPredicate(format: "date < %@", endOfDay as NSDate),
            NSPredicate(format: "user == %@", user)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FoodLog.createdAt, ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching food logs for date: \(error)")
            return []
        }
    }
    
    func getTotalCaloriesForDate(_ date: Date, user: User, context: NSManagedObjectContext) -> Int32 {
        let logs = getFoodLogsForDate(date, user: user, context: context)
        return logs.reduce(0) { $0 + $1.totalCalories }
    }
    
    func deleteFoodLog(_ foodLog: FoodLog, context: NSManagedObjectContext) {
        context.delete(foodLog)
        coreDataManager.save()
    }
}
