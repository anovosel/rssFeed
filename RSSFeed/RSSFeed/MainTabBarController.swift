import UIKit

class MainTabBarController: UITabBarController {

    // here define lazy var with viewControllers (or better, call some helpre which will check what tabs are neeeded)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.viewControllers = MainTabBarHelper.getViewController()
    }
}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
