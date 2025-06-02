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
        imageUrlString: String?,
        name: String,
        urlString: String
    ) {
        // TODO: check if configuration with urlString already exists
        let newFeedConfiguration: FeedConfigurationEntity = .init(context: CoreDataManager.shared.viewContext)

        newFeedConfiguration.feedDescription = description
        newFeedConfiguration.imageUrlString = imageUrlString
        newFeedConfiguration.name = name
        newFeedConfiguration.urlString = urlString
        
        CoreDataManager.shared.saveContext()
    }

    static func deleteFeedConfiguration(withUrlString urlString: String) {
        let urlStringPredicate: NSPredicate = .init(format: "urlString == %@", urlString)
        let fetchRequest: NSFetchRequest<FeedConfigurationEntity> = createFetchRequest(withPredicate: urlStringPredicate)

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
        newUrlString: String,
        description: String?,
        imageUrlString: String?
    ) {
        let urlStringPredicate: NSPredicate = .init(format: "urlString == %@", originalUrlString)
        let fetchRequest: NSFetchRequest<FeedConfigurationEntity> = FeedConfigurationEntity.createFetchRequest(withPredicate: urlStringPredicate)
        do {
            try CoreDataManager
                .shared
                .viewContext
                .fetch(fetchRequest)
                .forEach {
                    $0.urlString = newUrlString
                    $0.feedDescription = description
                    $0.imageUrlString = imageUrlString
                }
            CoreDataManager.shared.saveContext()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
