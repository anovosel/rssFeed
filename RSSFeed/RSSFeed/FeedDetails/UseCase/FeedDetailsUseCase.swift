import Algorithms

final class FeedDetailsUseCase {

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
}

extension FeedDetailsUseCase: FeedDetailsUseCaseType {

    func loadDetails(_ configuration: FeedConfigurationItem) async -> [FeedDetailsItem] {

        await feedLoader
            .loadFeed(formUrl: configuration.urlString)
            .map {
                FeedDetailsItem(
                    title: $0.title,
                    description: $0.description,
                    imageUrlString: $0.imageUrlString,
                    link: $0.link)
            }
            .uniqued { $0.hashValue }
    }
}
