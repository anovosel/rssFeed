import Foundation

protocol FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationItem)

    func loadConfigurations() -> [FeedConfigurationItem]

    func deleteConfiguration(_ configuration: FeedConfigurationItem)

    func update(old: FeedConfigurationItem, new: FeedConfigurationItem)
}
