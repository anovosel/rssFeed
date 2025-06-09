import Foundation
import UIKit

import SnapKit

protocol FeedConfigurationInputBottomSheetDelegate: AnyObject {
    func add(item: FeedConfigurationItem)
    func delete(item: FeedConfigurationItem)
    func update(oldItem: FeedConfigurationItem, newItem: FeedConfigurationItem)
}

final class FeedConfigurationInputBottomSheetViewController: UIViewController {
    enum Reason {
        case new
        case edit(FeedConfigurationItem)
    }

    static let maxDimmedAlpha: CGFloat = 0.6
    static let dismissibleHeight: CGFloat = UIScreen.main.bounds.height - 128
    static let defaultHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 300
    var containerViewHeightConstraint: Constraint?
    var containerViewBottomConstraint: Constraint?
    var reason: Reason
    weak var delegate: FeedConfigurationInputBottomSheetDelegate?

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

    lazy var headerLabel: UILabel = {
        let label: UILabel = Self.makeHeaderLable(with: "Feed Configuration")
        label.textAlignment = .center
        return label
    }()

    lazy var verticalStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    lazy var imageView: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "photo.on.rectangle.fill"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        Self.makeLabel(with: "Name:")
    }()

    lazy var nameInputTextField: UITextField = {
        Self.makeTextField(with: "name")
    }()

    lazy var urlLabel: UILabel = {
        Self.makeLabel(with: "URL:")
    }()

    lazy var urlInputTextField: UITextField = {
        Self.makeTextField(with: "url")
    }()

    lazy var descriptionLabel: UILabel = {
        Self.makeLabel(with: "Description:")
    }()

    lazy var descriptionInputFextField: UITextField = {
        Self.makeTextField(with: "description")
    }()

    lazy var deleteButton: UIButton = {
        let button: UIButton = Self.makeButton(with: "Delete", color: .systemRed)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    lazy var saveButton: UIButton = {
        let button: UIButton = Self.makeButton(with: "Save")
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()

    var currentItem: FeedConfigurationItem? {
        guard let name: String = nameInputTextField.text,
              let urlString = urlInputTextField.text else {
            return nil
        }

        return .init(
            name: name,
            urlString: urlString,
            description: descriptionInputFextField.text,
            imageURLString: nil)
    }

    init(reason: Reason, delegate: FeedConfigurationInputBottomSheetDelegate) {
        self.reason = reason
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        if case let .edit(item) = reason {
            self.nameInputTextField.text = item.name
            self.urlInputTextField.text = item.urlString
            self.descriptionInputFextField.text = item.description
            self.deleteButton.isHidden = false
        } else {
            self.deleteButton.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        containerView.addSubview(headerLabel)
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(nameInputTextField)
        verticalStackView.addArrangedSubview(urlLabel)
        verticalStackView.addArrangedSubview(urlInputTextField)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(descriptionInputFextField)
        verticalStackView.addArrangedSubview(deleteButton)
        verticalStackView.addArrangedSubview(saveButton)

        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            containerViewHeightConstraint = $0.height.equalTo(0).constraint
            containerViewBottomConstraint = $0.bottom.equalToSuperview().constraint
        }

        headerLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(containerView.snp.height).dividedBy(2)
        }
    }

    func animatePresentContainer() {
        containerView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(Self.defaultHeight)
            }
            self.containerView.alpha = 1
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
            self.containerView.alpha = 0
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
        case .ended:
            if newHeight < Self.dismissibleHeight && isDraggingDown {
                self.animateDismissView()
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

    @objc
    func didTapDeleteButton() {
        if case let .edit(feedConfigurationItem) = reason {
            delegate?.delete(item: feedConfigurationItem)
        }
        animateDismissView()
    }

    @objc
    func didTapSaveButton() {
        guard let currentItem: FeedConfigurationItem else {
            animateDismissView()
            return
        }

        switch reason {
        case .new:
            delegate?.add(item: currentItem)
        case .edit(let feedConfigurationItem):
            delegate?.update(oldItem: feedConfigurationItem, newItem: currentItem)
        }
        animateDismissView()
    }
}

private extension FeedConfigurationInputBottomSheetViewController {

    static func makeHeaderLable(with text: String) -> UILabel {
        let label: UILabel = .init()
        label.text = text
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }

    static func makeLabel(with text: String) -> UILabel {
        let label: UILabel = .init()
        label.text = text
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }

    static func makeTextField(with placeholder: String) -> UITextField {
        let textField: UITextField = .init()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        return textField
    }

    static func makeButton(with text: String, color: UIColor? = .systemBlue) -> UIButton {
        let button: UIButton = .init(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        return button
    }
}
