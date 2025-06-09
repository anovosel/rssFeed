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

        // TODO: don't instantiate here and don't hide first -> show empty instead
        if FeedConfigurationLocalRepository().getConfigurations().isEmpty {
            return [feedConfigurationNavigationConroller]
        }

        let feedViewModel: FeedViewModel = .init(
            useCase: FeedUseCase(
                repository: feedConfigurationRepository,
                feedLoader: feedLoader))
        let firstViewController: UINavigationController = .init(
            rootViewController: FeedTableViewController(
                viewModel: feedViewModel))
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let secondViewController = UINavigationController(rootViewController: FeedConfigurationViewController(viewModel: feedConfigurationViewModel))
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        return [firstViewController, feedConfigurationNavigationConroller]
    }
}
