import UIKit

import SnapKit

final class FeedViewController: UIViewController {

    // Data
    @Published var feedItems: [String] = []

    // View
    let sampleLabel: UILabel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
//        self.view.backgroundColor = .blue
    }

    func loadData() {
        Task { @MainActor in
//            await FeedLoader.load(urlString: "https://feeds.nbcnews.com/nbcnews/public/news")
            feedItems = ["bla"]
            dataLoaded()
        }
    }

    func dataLoaded() {
        if let firstItem: String = feedItems.first {
            sampleLabel.text = firstItem
        }
    }

    func setupViews() {
        self.view.addSubview(sampleLabel)
        sampleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        sampleLabel.text = "loading..."
    }
}
