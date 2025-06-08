import UIKit

import SnapKit

class FeedTableViewCell: UITableViewCell {

    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let feedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()
    
    private let feedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray3
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedTableViewCell {

    func configure(with item: FeedConfigurationItem) {
        feedImageView.image = .checkmark
        feedTitleLabel.text = item.name
        feedDescriptionLabel.text = item.description
    }
}

private extension FeedTableViewCell {

    func addSubviews() {
        [feedImageView, feedTitleLabel, feedDescriptionLabel].forEach(addSubview)
    }

    func setupConstraints() {
        feedImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(80)
        }

        feedTitleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(feedImageView.snp.trailing).offset(8)
        }

        feedDescriptionLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(feedImageView.snp.trailing).offset(8)
        }
    }
}
