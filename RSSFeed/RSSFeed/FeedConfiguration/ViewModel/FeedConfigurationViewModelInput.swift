import Combine
import Foundation

struct FeedConfigurationViewModelInput {

    let reloadConfigurations: AnyPublisher<Void, Never>
    let addConfiguration: AnyPublisher<FeedConfigurationItem, Never>
    let deleteConfiguration: AnyPublisher<FeedConfigurationItem, Never>
    let updateConfiguration: AnyPublisher<(old: FeedConfigurationItem, new: FeedConfigurationItem), Never>
}
