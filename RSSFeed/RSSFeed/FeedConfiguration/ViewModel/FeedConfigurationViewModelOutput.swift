import Combine
import Foundation

typealias FeedConfigurationViewModelOutput = AnyPublisher<FeedConfigurationViewModelState, Never>

enum FeedConfigurationViewModelState: Equatable {
    case idle([FeedConfigurationItem])
    case edit(FeedConfigurationItem)
    case success
    case noResults
    case failure
}
