import Combine
import Foundation

enum FeedConfigurationState {
    case idle
    case edit(FeedConfigurationViewModel)
    case success([FeedConfigurationViewModel])
    case noResults
    case failure(Error)
}
