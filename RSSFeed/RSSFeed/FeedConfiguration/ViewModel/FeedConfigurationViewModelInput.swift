import Combine
import Foundation

struct FeedConfigurationViewModelInput {
    // called when screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when new configuration is added
    let addConfiguration: AnyPublisher<Void, Never> // TODO: Void -> Configuration businessModel
    // tapped on one configuration (EDIT?)
    let selection: AnyPublisher<Void, Never>
}
