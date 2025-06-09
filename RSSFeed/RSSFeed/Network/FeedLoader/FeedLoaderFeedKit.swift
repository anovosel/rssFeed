import FeedKit

final class FeedLoaderFeedKit: FeedLoader {

    func loadFeed(formUrl urlString: String) async -> [FeedApiModel] {
        guard let feedURL = URL(string: urlString) else {
            return []
        }

        let parser = FeedParser(URL: feedURL)

        return await withCheckedContinuation { continuation in
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    print("Feed Parsed: \(feed)")
                    switch feed {
                    case .rss(let rssFeed):
                        let items: [FeedApiModel] = rssFeed.items?.map { $0.asFeedApiModel() } ?? []
                        continuation.resume(returning: items)
                    case .atom(let atomFeed):
                        let items: [FeedApiModel] = atomFeed.links?.compactMap { $0.attributes?.asFeedApiModel() } ?? []
                        continuation.resume(returning: items)
                    case .json(let jsonFeed):
                        let items: [FeedApiModel] = jsonFeed.items?.map { $0.asFeedApiModel() } ?? []
                        continuation.resume(returning: items)
                    }
                case .failure(let error):
                    continuation.resume(returning: [])
                }
            }
        }
    }
}

private extension RSSFeedItem {

    func asFeedApiModel() -> FeedApiModel {
        return FeedApiModel(
            imageUrlString: nil,
            title: title,
            description: description,
            link: link
        )
    }
}

private extension AtomFeedLink.Attributes {

    func asFeedApiModel() -> FeedApiModel {
        return FeedApiModel(
            imageUrlString: nil,
            title: title,
            description: nil,
            link: href
        )
    }
}

private extension JSONFeedItem {

    func asFeedApiModel() -> FeedApiModel {
        return FeedApiModel(
            imageUrlString: image,
            title: title,
            description: summary,
            link: url
        )
    }
}
