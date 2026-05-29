import Foundation
import Combine
import CoreData

class HomeViewModel: NSObject, ObservableObject {
    @Published var currentUser: User?
    @Published var todaysFoodLogs: [FoodLog] = []
    @Published var totalCaloriesConsumed: Int32 = 0
    @Published var caloriesRemaining: Int32 = 0
    @Published var isLoading = false
    
    let coreDataManager = CoreDataManager.shared
    let foodService = FoodService.shared
    let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<FoodLog>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
        loadTodaysData()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest = NSFetchRequest<FoodLog>(entityName: "FoodLog")
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "FoodLog", in: context)
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "date >= %@", startOfDay as NSDate),
            NSPredicate(format: "date < %@", endOfDay as NSDate)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FoodLog.createdAt, ascending: false)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        self.fetchedResultsController = frc
        
        do {
            try frc.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
    }
    
    func loadTodaysData() {
        isLoading = true
        
        if currentUser == nil {
            currentUser = coreDataManager.getOrCreateDefaultUser(context: context)
        }
        
        guard let user = currentUser else {
            isLoading = false
            return
        }
        
        todaysFoodLogs = foodService.getFoodLogsForDate(Date(), user: user, context: context)
        totalCaloriesConsumed = foodService.getTotalCaloriesForDate(Date(), user: user, context: context)
        caloriesRemaining = user.dailyCalorieGoal - totalCaloriesConsumed
        
        isLoading = false
    }
    
    func deleteFoodLog(_ foodLog: FoodLog) {
        foodService.deleteFoodLog(foodLog, context: context)
        loadTodaysData()
    }
    
    var progressPercentage: Double {
        guard currentUser != nil, currentUser!.dailyCalorieGoal > 0 else { return 0 }
        return Double(totalCaloriesConsumed) / Double(currentUser!.dailyCalorieGoal)
    }
}

extension HomeViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadTodaysData()
    }
}
