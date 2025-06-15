import Foundation

protocol FeedConfigurationRepository {

    func getConfigurations() -> [FeedConfigurationDTO]
    func getConfiguration(withName: String) -> FeedConfigurationDTO?
    func getConfiguration(withUrlString: String) -> FeedConfigurationDTO?
    func saveConfiguration(_ configuration: FeedConfigurationDTO)
    func updateConfiguration(originalUrlString: String, withConfiguration: FeedConfigurationDTO)
    func deleteConfiguration(_ configuration: FeedConfigurationDTO)
}
