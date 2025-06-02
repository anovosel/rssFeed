import Foundation

protocol FeedConfigurationRepository {

    func getConfigurations() -> [FeedConfigurationDTO]
    func saveConfiguration(_ configuration: FeedConfigurationDTO)
    func updateConfiguration(originalUrlString: String, withConfiguration: FeedConfigurationDTO)
    func deleteConfiguration(_ configuration: FeedConfigurationDTO)
}
