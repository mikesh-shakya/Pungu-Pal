import Foundation
import CoreData

@NSManaged public class FoodLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var quantity: Double
    @NSManaged public var totalCalories: Int32
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var user: User?
    @NSManaged public var food: Food?
}

extension FoodLog {
    var dayOfLog: Date {
        Calendar.current.startOfDay(for: date)
    }
}
