import Foundation

protocol FeedLoader {

    func loadFeed(formUrl urlString: String) async -> [FeedApiModel]
}
