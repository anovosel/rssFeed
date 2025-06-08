import CoreData
import Foundation

final class FeedConfigurationLocalRepository: FeedConfigurationRepository {

    func getConfigurations() -> [FeedConfigurationDTO] {
        FeedConfigurationEntity
            .getAllFeedConfigurations()
            .map(\.toDTO)
            .compactMap { $0 }
    }

    func saveConfiguration(_ configuration: FeedConfigurationDTO) {
        FeedConfigurationEntity
            .addFeedConfiguration(
                description: configuration.description,
                imageUrlString: configuration.imageUrlString,
                name: configuration.name,
                urlString: configuration.urlString)
    }

    func updateConfiguration(originalUrlString: String, withConfiguration newConfiguration: FeedConfigurationDTO) {
        FeedConfigurationEntity
            .updateFeedConfiguration(
                originalUrlString: originalUrlString,
                newName: newConfiguration.name,
                newUrlString: newConfiguration.urlString,
                description: newConfiguration.description,
                imageUrlString: newConfiguration.imageUrlString)
    }

    func deleteConfiguration(_ configuration: FeedConfigurationDTO) {
        FeedConfigurationEntity
            .deleteFeedConfiguration(
                withUrlString: configuration.urlString)
    }
}

private extension FeedConfigurationEntity {

    var toDTO: FeedConfigurationDTO? {
        guard let urlString,
              let name else {
            return nil
        }

        return .init(
            name: name,
            urlString: urlString,
            imageUrlString: imageUrlString,
            description: feedDescription)
    }
}
