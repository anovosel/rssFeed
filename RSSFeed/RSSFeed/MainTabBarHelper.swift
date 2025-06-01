import Foundation
import UIKit


enum MainTabBarHelper {

    static func getViewController() -> [UIViewController] {

        let firstViewController = UINavigationController(rootViewController: FeedViewController())
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let secondViewController = UINavigationController(rootViewController: FeedConfigurationViewController())
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        return [firstViewController, secondViewController]
    }
}
