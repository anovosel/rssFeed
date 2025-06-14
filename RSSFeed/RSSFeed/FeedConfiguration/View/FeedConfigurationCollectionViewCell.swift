import UIKit

import SDWebImage
import SnapKit

class FeedConfigurationCollectionViewCell: UICollectionViewCell {

    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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

extension FeedConfigurationCollectionViewCell {

    func configure(with item: FeedConfigurationItem) {
        if let imageUrlString: String = item.imageURLString {
            feedImageView.sd_setImage(with: URL(string: imageUrlString))
        }
        feedTitleLabel.text = item.name
        feedDescriptionLabel.text = item.description
    }
}

private extension FeedConfigurationCollectionViewCell {

    func addSubviews() {
        [feedImageView, feedTitleLabel, feedDescriptionLabel].forEach(addSubview)
    }

    func setupConstraints() {
        feedImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(80)
        }

        feedTitleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(32)
            $0.leading.equalTo(feedImageView.snp.trailing).offset(8)
        }

        feedDescriptionLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(32)
            $0.leading.equalTo(feedImageView.snp.trailing).offset(8)
        }
    }
}
