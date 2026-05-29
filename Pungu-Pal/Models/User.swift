import Foundation
import CoreData

@NSManaged public class User: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var dailyCalorieGoal: Int32
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var foodLogs: NSSet?
    
    @objc(addFoodLogsObject:)
    @NSManaged public func addToFoodLogs(_ value: FoodLog)
    
    @objc(removeFoodLogsObject:)
    @NSManaged public func removeFromFoodLogs(_ value: FoodLog)
    
    @objc(addFoodLogs:)
    @NSManaged public func addToFoodLogs(_ values: NSSet)
    
    @objc(removeFoodLogs:)
    @NSManaged public func removeFromFoodLogs(_ values: NSSet)
}

extension User {
    @NSManaged public var foodLogsArray: [FoodLog]
}
