import Combine
import Foundation

struct FeedConfigurationViewModelInput {
    // called when screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when new configuration is added
    let addConfiguration: AnyPublisher<FeedConfiguration, Never> 
    // tapped on one configuration (EDIT?)
    let selection: AnyPublisher<FeedConfiguration, Never>
}
