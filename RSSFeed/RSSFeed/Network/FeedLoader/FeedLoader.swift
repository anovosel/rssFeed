import Foundation

protocol FeedLoader {

    func loadFeed(fromUrl urlString: String) async -> FeedApiModel?
    func loadFeedItems(formUrl urlString: String) async -> [FeedItemApiModel]
}
