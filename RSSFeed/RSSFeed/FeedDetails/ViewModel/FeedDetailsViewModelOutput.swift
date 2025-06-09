import Combine
import Foundation

typealias FeedDetailsViewModelOutput = AnyPublisher<FeedDetailsViewModelState, Never>

enum FeedDetailsViewModelState: Equatable {

    case reload([FeedDetailsItem])
}
