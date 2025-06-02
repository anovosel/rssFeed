final class FeedConfigurationUseCase {

    private let repository: FeedConfigurationRepository
    private let feedLoder: FeedLoader

    init(repository: FeedConfigurationRepository, feedLoder: FeedLoader) {
        self.repository = repository
        self.feedLoder = feedLoder
    }
}

extension FeedConfigurationUseCase: FeedConfigurationUseCaseType {
    func addConfiguration(_ configuration: FeedConfigurationViewModel) {
        repository
            .saveConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    imageUrlString: configuration.imageURLString,
                    description: configuration.description))
    }
    
    func loadConfigurations() -> [FeedConfigurationViewModel] {
        repository
            .getConfigurations()
            .map { .init(name: "",
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: $0.imageUrlString) }
    }
    
    func deleteConfiguration(_ configuration: FeedConfigurationViewModel) {
        repository
            .deleteConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    imageUrlString: configuration.imageURLString,
                    description: configuration.description))
    }
    
    func editConfiguration(_ configuration: FeedConfigurationViewModel) {
    }
    

}
