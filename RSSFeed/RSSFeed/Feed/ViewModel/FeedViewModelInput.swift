import Combine
import Foundation

struct FeedViewModelInput {
    let reloadFeeds: AnyPublisher<Void, Never>
}
