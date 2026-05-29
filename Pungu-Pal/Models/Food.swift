import Foundation
import CoreData

public class Food: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var calories: Int32
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var servingSize: String
    @NSManaged public var createdAt: Date
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

extension Food {
    @NSManaged public var foodLogsArray: [FoodLog]
} 
