protocol FeedUseCaseType {

    func loadFeeds() async -> [FeedConfigurationItem]
}
