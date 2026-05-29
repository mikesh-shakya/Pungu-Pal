import Foundation
import CoreData

class SettingsViewModel: NSObject, ObservableObject {
    @Published var user: User?
    @Published var dailyGoalString: String = ""
    @Published var userName: String = ""
    @Published var isSaving = false
    
    let coreDataManager = CoreDataManager.shared
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        loadUserData()
    }
    
    func loadUserData() {
        user = coreDataManager.getOrCreateDefaultUser(context: context)
        
        if let user = user {
            dailyGoalString = String(user.dailyCalorieGoal)
            userName = user.name
        }
    }
    
    func saveChanges() {
        guard let user = user else { return }
        
        isSaving = true
        
        user.name = userName
        if let goal = Int32(dailyGoalString) {
            user.dailyCalorieGoal = goal
        }
        user.updatedAt = Date()
        
        coreDataManager.save()
        isSaving = false
    }
}
