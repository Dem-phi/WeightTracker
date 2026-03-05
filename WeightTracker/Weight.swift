import Foundation
import CoreData

@objc(Weight)
public class Weight: NSManagedObject {
    @NSManaged public var date: Date
    @NSManaged public var weight: Double
    @NSManaged public var person: String
}