import Combine
import Foundation

typealias FeedConfigurationViewModelOutput = AnyPublisher<FeedConfigurationViewModelState, Never>

enum FeedConfigurationViewModelState: Equatable {
    case idle([FeedConfiguration])
    case edit(FeedConfiguration)
    case success
    case noResults
    case failure
}
