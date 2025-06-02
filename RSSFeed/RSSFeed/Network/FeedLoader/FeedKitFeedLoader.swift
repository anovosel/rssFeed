import FeedKit

final class FeedKitFeedLoader: FeedLoader {

    func loadFeed(formUrl urlString: String) async {
        guard let feedURL = URL(string: urlString) else {
            return
        }

        let parser = FeedParser(URL: feedURL)

        await withCheckedContinuation { continuation in
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    print("Feed Parsed: \(feed)")
                    switch feed {
                    case .rss(let rssFeed):
                        print("RSS Feed: \(rssFeed)")
                    case .atom(let atomFeed):
                        print("Atom Feed: \(atomFeed)")
                    case .json(let jsonFeed):
                        print("JSON Feed: \(jsonFeed)")
                    }
                case .failure(let error):
                    print("Feed Parsing Failed: \(error)")
                }
                continuation.resume()
            }
        }
    }
}
