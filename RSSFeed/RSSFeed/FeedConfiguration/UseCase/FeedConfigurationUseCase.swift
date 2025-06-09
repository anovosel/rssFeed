final class FeedConfigurationUseCase {

    private let repository: FeedConfigurationRepository
    private let feedLoader: FeedLoader

    init(repository: FeedConfigurationRepository,
         feedLoader: FeedLoader) {
        self.repository = repository
        self.feedLoader = feedLoader
    }
}

extension FeedConfigurationUseCase: FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationItem) {
        repository
            .saveConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    description: configuration.description))
    }
    
    func loadConfigurations() async -> [FeedConfigurationItem] {
        await repository
            .getConfigurations()
            .asyncMap {
                let imageUrlString: String? = await feedLoader.loadFeed(fromUrl: $0.urlString)?.imageUrlString
                return .init(name: $0.name,
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: imageUrlString) }
    }
    
    func deleteConfiguration(_ configuration: FeedConfigurationItem) {
        repository
            .deleteConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    description: configuration.description))
    }
    
    func update(old: FeedConfigurationItem, new: FeedConfigurationItem) {
        repository
            .updateConfiguration(
                originalUrlString: old.urlString,
                withConfiguration: .init(
                    name: new.name,
                    urlString: new.urlString,
                    description: new.description))
    }
}
