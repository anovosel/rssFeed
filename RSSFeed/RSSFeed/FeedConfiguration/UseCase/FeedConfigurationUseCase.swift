final class FeedConfigurationUseCase {

    private let repository: FeedConfigurationRepository
    private let feedLoder: FeedLoader

    init(repository: FeedConfigurationRepository, feedLoder: FeedLoader) {
        self.repository = repository
        self.feedLoder = feedLoder
    }
}

extension FeedConfigurationUseCase: FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationItem) {
        repository
            .saveConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    imageUrlString: configuration.imageURLString,
                    description: configuration.description))
    }
    
    func loadConfigurations() -> [FeedConfigurationItem] {
        repository
            .getConfigurations()
            .map { .init(name: $0.name,
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: $0.imageUrlString) }
    }
    
    func deleteConfiguration(_ configuration: FeedConfigurationItem) {
        repository
            .deleteConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    imageUrlString: configuration.imageURLString,
                    description: configuration.description))
    }
    
    func update(old: FeedConfigurationItem, new: FeedConfigurationItem) {
        repository
            .updateConfiguration(
                originalUrlString: old.urlString,
                withConfiguration: .init(
                    name: new.name,
                    urlString: new.urlString,
                    imageUrlString: new.imageURLString,
                    description: new.description))
    }
    

}
