import Foundation
import UIKit

import SnapKit

final class FeedConfigurationInputBottomSheetViewController: UIViewController {
    static let maxDimmedAlpha: CGFloat = 0.6
    static let defaultHeight: CGFloat = 300
    static let dismissibleHeight: CGFloat = 200
    static let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 300
    var containerViewHeightConstraint: Constraint?
    var containerViewBottomConstraint: Constraint?

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = Self.maxDimmedAlpha
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupPanGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }

    func setupView() {
        view.backgroundColor = .clear
    }

    func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)

        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            containerViewHeightConstraint = $0.height.equalTo(0).constraint
            containerViewBottomConstraint = $0.bottom.equalToSuperview().constraint
        }
    }

    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(Self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = Self.maxDimmedAlpha
        }
    }

    func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    func setupPanGesture() {
        let panGesture: UIPanGestureRecognizer = .init(target: self, action: #selector(handlePanGesture))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    @objc
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y

        switch gesture.state {
        case .changed:
            if newHeight < Self.maximumContainerHeight {
                containerView.snp.updateConstraints {
                    $0.height.equalTo(newHeight)
                }
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < Self.dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < Self.defaultHeight {
                animateContainerHeight(Self.defaultHeight)
            }
            else if newHeight < Self.maximumContainerHeight && isDraggingDown {
                animateContainerHeight(Self.defaultHeight)
            }
            else if newHeight > Self.defaultHeight && !isDraggingDown {
                animateContainerHeight(Self.maximumContainerHeight)
            }
        default:
            break
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
}
