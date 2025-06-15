import CoreData
import Foundation

extension FeedConfigurationEntity {

    private static let entityName = "FeedConfigurationEntity"

    @nonobjc public class func createFetchRequest(withPredicate predicate: NSPredicate? = nil) -> NSFetchRequest<FeedConfigurationEntity> {
        let fetchRequest: NSFetchRequest<FeedConfigurationEntity> = .init(entityName: Self.entityName)
        fetchRequest.predicate = predicate
        return fetchRequest
    }



    static func getAllFeedConfigurations() -> [FeedConfigurationEntity] {
        do {
            return try CoreDataManager.shared.viewContext.fetch(createFetchRequest())
        } catch {
            return []
        }
    }

    static func addFeedConfiguration(
        description: String?,
        name: String,
        urlString: String
    ) {
        let newFeedConfiguration: FeedConfigurationEntity = .init(context: CoreDataManager.shared.viewContext)

        newFeedConfiguration.feedDescription = description
        newFeedConfiguration.name = name
        newFeedConfiguration.urlString = urlString
        
        CoreDataManager.shared.saveContext()
    }

    static func deleteFeedConfiguration(withUrlString urlString: String) {
        let fetchRequest: NSFetchRequest<FeedConfigurationEntity> = createFetchRequest(withPredicate: predicate(urlString: urlString))

        do {
            try CoreDataManager
                .shared
                .viewContext
                .fetch(fetchRequest)
                .forEach {
                    CoreDataManager.shared.viewContext.delete($0)
                }
            CoreDataManager.shared.saveContext()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    static func updateFeedConfiguration(
        originalUrlString: String,
        newName: String,
        newUrlString: String,
        description: String?,
    ) {
        let fetchRequest: NSFetchRequest<FeedConfigurationEntity> = FeedConfigurationEntity
            .createFetchRequest(withPredicate: predicate(urlString: originalUrlString))
        do {
            try CoreDataManager
                .shared
                .viewContext
                .fetch(fetchRequest)
                .forEach {
                    $0.name = newName
                    $0.urlString = newUrlString
                    $0.feedDescription = description
                }
            CoreDataManager.shared.saveContext()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    static func getFeedConfiguration(withName name: String) -> FeedConfigurationEntity? {

        try? CoreDataManager
            .shared
            .viewContext
            .fetch(
                createFetchRequest(
                    withPredicate: predicate(name: name)))
            .first
    }

    static func getFeedConfiguration(withUrlString urlString: String) -> FeedConfigurationEntity? {

        try? CoreDataManager
            .shared
            .viewContext
            .fetch(
                createFetchRequest(
                    withPredicate: predicate(urlString: urlString)))
            .first
    }
}

private extension FeedConfigurationEntity {

    static func predicate(name: String) -> NSPredicate {
        .init(format: "name == %@", name)
    }

    static func predicate(urlString: String) -> NSPredicate {
        .init(format: "urlString == %@", urlString)
    }
}
