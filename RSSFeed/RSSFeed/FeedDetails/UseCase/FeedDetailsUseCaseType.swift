import Foundation

protocol FeedDetailsUseCaseType {

    func loadDetails(_ configuration: FeedConfigurationItem) async -> [FeedDetailsItem]
}
