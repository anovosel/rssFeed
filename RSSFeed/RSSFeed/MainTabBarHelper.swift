import Foundation
import UIKit


enum MainTabBarHelper {

    static func getViewController() -> [UIViewController] {

        let feedConfigurationRepository: FeedConfigurationRepository = FeedConfigurationLocalRepository()
        let feedLoader: FeedLoader = FeedLoaderFeedKit()
        let feedConfigurationViewModel: FeedConfigurationViewModel = .init(
            useCase: FeedConfigurationUseCase(
                repository: feedConfigurationRepository,
                feedLoader: feedLoader))
        let feedConfigurationNavigationConroller: UINavigationController = .init(
            rootViewController: FeedConfigurationViewController(
                viewModel: feedConfigurationViewModel))
        feedConfigurationNavigationConroller.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        let feedViewModel: FeedViewModel = .init(
            useCase: FeedUseCase(
                repository: feedConfigurationRepository,
                feedLoader: feedLoader))
        let feedNavigationController: UINavigationController = .init(
            rootViewController: FeedTableViewController(
                viewModel: feedViewModel))
        feedNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)

        return [feedNavigationController, feedConfigurationNavigationConroller]
    }
}
