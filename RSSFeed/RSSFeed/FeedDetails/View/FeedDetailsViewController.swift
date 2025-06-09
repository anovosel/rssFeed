import Combine
import UIKit

import SnapKit

final class FeedDetailsViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, FeedDetailsItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FeedDetailsItem>

    enum Section {
        case main
    }

    lazy private var collectionView: UICollectionView = makeCollectionView()
    lazy private var collectionViewDataSource: DataSource = makeDataSource()

    private var dataItems: [FeedDetailsItem] = []

    private let viewModel: FeedDetailsViewModelType
    private let feedConfigurationItem: FeedConfigurationItem
    private let reloadSubject: PassthroughSubject<FeedConfigurationItem, Never> = .init()
    private var cancellables: [AnyCancellable] = []

    init(viewModel: FeedDetailsViewModelType,
         feedConfigurationItem: FeedConfigurationItem) {
        self.viewModel = viewModel
        self.feedConfigurationItem = feedConfigurationItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func  viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadSubject.send(feedConfigurationItem)
    }
}

private extension FeedDetailsViewController {

    func setupViews() {
        applySnapshot()
    }

    func render(_ state: FeedDetailsViewModelState) {
        switch state {
        case .reload(let items):
            dataItems = items
            applySnapshot()
        }
    }

    func bind(to viewModel: FeedDetailsViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input: FeedDetailsViewModelInput = .init(reload: reloadSubject.eraseToAnyPublisher())

        let output: FeedDetailsViewModelOutput = viewModel.transform(input: input)

        output
            .sink { [unowned self] state in
                self.render(state)
            }
            .store(in: &cancellables)
    }
}

extension FeedDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let item: FeedDetailsItem = dataItems[indexPath.item]
        guard let urlString = item.link,
              let url: URL = .init(string: urlString) else {
            return
        }
        UIApplication.shared.open(url)
    }

    private func makeCollectionView() -> UICollectionView {
        let layoutConfiguration: UICollectionLayoutListConfiguration = .init(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)

        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        collectionView.delegate = self

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return collectionView
    }

    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<FeedDetailsCollectionViewCell, FeedDetailsItem> { cell, indexPath, item in
            cell.configure(with: item)
        }

        return DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: FeedDetailsItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)

            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot: Snapshot = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)

        collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
