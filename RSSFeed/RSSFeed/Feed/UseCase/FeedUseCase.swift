final class FeedUseCase {

    private let repository: FeedConfigurationRepository
    private let feedLoader: FeedLoader

    init(repository: FeedConfigurationRepository,
         feedLoader: FeedLoader) {
        self.repository = repository
        self.feedLoader = feedLoader
    }
}

extension FeedUseCase: FeedUseCaseType {

    func loadFeeds() async -> [FeedConfigurationItem] {
        await repository
            .getConfigurations()
            .asyncMap {
                let imageUrlString: String? = await feedLoader.loadFeed(fromUrl: $0.urlString)?.imageUrlString
                return .init(name: $0.name,
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: imageUrlString) }
    }
}
