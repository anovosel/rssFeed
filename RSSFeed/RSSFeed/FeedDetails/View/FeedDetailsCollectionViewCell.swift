import UIKit

import SDWebImage
import SnapKit

class FeedDetailsCollectionViewCell: UICollectionViewCell {

    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let feedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    private let feedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray6
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedDetailsCollectionViewCell {

    func configure(with item: FeedDetailsItem) {
        if let imageUrlString: String = item.imageUrlString {
            feedImageView.sd_setImage(with: URL(string: imageUrlString))
        }
        feedTitleLabel.text = item.title
        feedDescriptionLabel.text = item.description
    }
}

private extension FeedDetailsCollectionViewCell {

    func addSubviews() {
        [feedImageView, verticalStackView].forEach(addSubview)
        [feedTitleLabel, feedDescriptionLabel].forEach(verticalStackView.addArrangedSubview)
    }

    func setupConstraints() {
        feedImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(80)
        }

        verticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(feedImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }

        feedTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        feedDescriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}
