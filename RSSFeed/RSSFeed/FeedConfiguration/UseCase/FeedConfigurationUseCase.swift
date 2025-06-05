final class FeedConfigurationUseCase {

    private let repository: FeedConfigurationRepository
    private let feedLoder: FeedLoader

    init(repository: FeedConfigurationRepository, feedLoder: FeedLoader) {
        self.repository = repository
        self.feedLoder = feedLoder
    }
}

extension FeedConfigurationUseCase: FeedConfigurationUseCaseType {
    func addConfiguration(_ configuration: FeedConfiguration) {
        repository
            .saveConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    imageUrlString: configuration.imageURLString,
                    description: configuration.description))
    }
    
    func loadConfigurations() -> [FeedConfiguration] {
        repository
            .getConfigurations()
            .map { .init(name: "",
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: $0.imageUrlString) }
    }
    
    func deleteConfiguration(_ configuration: FeedConfiguration) {
        repository
            .deleteConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    imageUrlString: configuration.imageURLString,
                    description: configuration.description))
    }
    
    func editConfiguration(_ configuration: FeedConfiguration) {
    }
    

}
