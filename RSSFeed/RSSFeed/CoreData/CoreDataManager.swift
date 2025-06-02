import Foundation
import CoreData

final class CoreDataManager {

    static let modelName: String = "RSSFeedModel"
    static let shared: CoreDataManager = .init()

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = .init(name: Self.modelName)

        persistentContainer.loadPersistentStores { (description, error) in
            if let error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
        debugPrint("initialized")
    }

    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            debugPrint(error)
        }
    }
}
