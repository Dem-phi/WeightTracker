import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Build model programmatically: Entity `Weight` with `date: Date`, `weight: Double` and `person: String`
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "Weight"
        entity.managedObjectClassName = NSStringFromClass(Weight.self)

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "date"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = false

        let weightAttr = NSAttributeDescription()
        weightAttr.name = "weight"
        weightAttr.attributeType = .doubleAttributeType
        weightAttr.isOptional = false

        let personAttr = NSAttributeDescription()
        personAttr.name = "person"
        personAttr.attributeType = .stringAttributeType
        personAttr.isOptional = false

        entity.properties = [dateAttr, weightAttr, personAttr]
        model.entities = [entity]

        container = NSPersistentContainer(name: "WeightModel", managedObjectModel: model)

        // Configure store description with explicit URL for Documents directory
        if !inMemory {
            let storeDescription = NSPersistentStoreDescription()
            storeDescription.type = NSSQLiteStoreType

            // Get Documents directory and create store URL
            let fileManager = FileManager.default
            if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let storeURL = documentsURL.appendingPathComponent("WeightModel.sqlite")
                storeDescription.url = storeURL
            }

            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true
            container.persistentStoreDescriptions = [storeDescription]
        } else {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            print("CoreData store location: \(description.url?.path ?? "unknown")")
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                print("Data saved successfully")
            } catch {
                let nserr = error as NSError
                fatalError("Unresolved error \(nserr), \(nserr.userInfo)")
            }
        }
    }
}

extension Weight {
    static func fetchRequestSorted(for person: Person? = nil) -> NSFetchRequest<Weight> {
        let req = NSFetchRequest<Weight>(entityName: "Weight")
        if let person = person {
            req.predicate = NSPredicate(format: "person = %@", person.rawValue)
        }
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return req
    }
}

extension Weight: Identifiable {}