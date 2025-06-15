import UIKit

extension UIViewController {

    func showSpinner(_ spinnerViewController: SpinnerViewController? = nil) -> SpinnerViewController {
        let spinnerViewController: SpinnerViewController = spinnerViewController ?? .init()

        addChild(spinnerViewController)
        spinnerViewController.view.frame = view.frame
        view.addSubview(spinnerViewController.view)
        spinnerViewController.didMove(toParent: self)

        return spinnerViewController
    }

    func hideSpinner(_ spinnerViewController: SpinnerViewController?) {
        spinnerViewController?.willMove(toParent: nil)
        spinnerViewController?.view.removeFromSuperview()
        spinnerViewController?.removeFromParent()
    }
}
