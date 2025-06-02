import Foundation
import UIKit


enum MainTabBarHelper {

    static func getViewController() -> [UIViewController] {

        let feedConfigurationNavigationConroller: UINavigationController = .init(rootViewController: FeedConfigurationViewController())
        feedConfigurationNavigationConroller.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        // TODO: don't instantiate here
        if FeedConfigurationLocalRepository().getConfigurations().isEmpty {
            return [feedConfigurationNavigationConroller]
        }

        let firstViewController = UINavigationController(rootViewController: FeedViewController())
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let secondViewController = UINavigationController(rootViewController: FeedConfigurationViewController())
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        return [firstViewController, feedConfigurationNavigationConroller]
    }
}
