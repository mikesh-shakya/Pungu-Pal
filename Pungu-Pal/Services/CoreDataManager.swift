import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "PunguPal")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unable to save context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getOrCreateDefaultUser(context: NSManagedObjectContext) -> User {
        let fetchRequest = User.fetchRequest() as! NSFetchRequest<User>
        
        if let existingUser = try? context.fetch(fetchRequest).first {
            return existingUser
        }
        
        let newUser = User(context: context)
        newUser.id = UUID()
        newUser.name = "Default User"
        newUser.dailyCalorieGoal = 2000
        newUser.createdAt = Date()
        newUser.updatedAt = Date()
        
        save()
        return newUser
    }
}
