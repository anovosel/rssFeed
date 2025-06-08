final class FeedUseCase {

    private let repository: FeedConfigurationRepository

    init(repository: FeedConfigurationRepository) {
        self.repository = repository
    }
}

extension FeedUseCase: FeedUseCaseType {

    func loadFeeds() -> [FeedConfigurationItem] {
        repository
            .getConfigurations()
            .map { .init(name: $0.name,
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: $0.imageUrlString) }
    }
}
