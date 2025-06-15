import Foundation

protocol FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationItem)

    func loadConfigurations() async -> [FeedConfigurationItem]

    func deleteConfiguration(_ configuration: FeedConfigurationItem)

    func update(old: FeedConfigurationItem, new: FeedConfigurationItem)

    func validateNew(_ configuration: FeedConfigurationItem) async -> FeedConfigurationValidation

    func validateExisting(_ configuration: FeedConfigurationItem) async -> FeedConfigurationValidation
}
