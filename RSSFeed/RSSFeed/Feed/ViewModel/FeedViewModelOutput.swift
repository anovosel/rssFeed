import Combine
import Foundation

typealias FeedViewModelOutput = AnyPublisher<FeedViewModelState, Never>

enum FeedViewModelState: Equatable {
    case reload([FeedConfigurationItem])
}
