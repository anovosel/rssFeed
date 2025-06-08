import Combine
import Foundation

typealias FeedConfigurationViewModelOutput = AnyPublisher<FeedConfigurationViewModelState, Never>

enum FeedConfigurationViewModelState: Equatable {
    case reload([FeedConfigurationItem])
    case success
    case noResults
    case failure
}
