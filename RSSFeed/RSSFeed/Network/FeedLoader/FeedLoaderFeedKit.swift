import FeedKit

final class FeedLoaderFeedKit: FeedLoader {

    func loadFeed(fromUrl urlString: String) async -> FeedApiModel? {
        guard let feedURL = URL(string: urlString) else {
            return nil
        }

        let parser = FeedParser(URL: feedURL)

        return await withCheckedContinuation { continuation in
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    switch feed {
                    case .rss(let rssFeed):
                        if let imageUrl: String = rssFeed.image?.url {
                            continuation.resume(returning: .init(imageUrlString: imageUrl))
                        }
                    case .atom(let atomFeed):
                        if let imageUrl: String = atomFeed.icon {
                            continuation.resume(returning: .init(imageUrlString: imageUrl))
                        }
                    case .json(let jsonFeed):
                        if let imageUrl: String = jsonFeed.icon {
                            continuation.resume(returning: .init(imageUrlString: imageUrl))
                        }
                    }
                case .failure(let error):
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    func loadFeedItems(formUrl urlString: String) async -> [FeedItemApiModel] {
        guard let feedURL = URL(string: urlString) else {
            return []
        }

        let parser = FeedParser(URL: feedURL)

        return await withCheckedContinuation { continuation in
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    switch feed {
                    case .rss(let rssFeed):
                        let items: [FeedItemApiModel] = rssFeed.items?.map { $0.asFeedApiModel() } ?? []
                        continuation.resume(returning: items)
                    case .atom(let atomFeed):
                        let items: [FeedItemApiModel] = atomFeed.links?.compactMap { $0.attributes?.asFeedApiModel() } ?? []
                        continuation.resume(returning: items)
                    case .json(let jsonFeed):
                        let items: [FeedItemApiModel] = jsonFeed.items?.map { $0.asFeedApiModel() } ?? []
                        continuation.resume(returning: items)
                    }
                case .failure:
                    continuation.resume(returning: [])
                }
            }
        }
    }
}

private extension RSSFeedItem {

    func asFeedApiModel() -> FeedItemApiModel {
        return FeedItemApiModel(
            imageUrlString: media?.mediaThumbnails?.first?.attributes?.url,
            title: title,
            description: description,
            link: link
        )
    }
}

private extension AtomFeedLink.Attributes {

    func asFeedApiModel() -> FeedItemApiModel {
        return FeedItemApiModel(
            imageUrlString: nil,
            title: title,
            description: nil,
            link: href
        )
    }
}

private extension JSONFeedItem {

    func asFeedApiModel() -> FeedItemApiModel {
        return FeedItemApiModel(
            imageUrlString: image,
            title: title,
            description: summary,
            link: url
        )
    }
}
