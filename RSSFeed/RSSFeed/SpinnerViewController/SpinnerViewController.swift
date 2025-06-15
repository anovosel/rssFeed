import UIKit

import SnapKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
