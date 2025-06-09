import Combine
import UIKit

import SnapKit

final class FeedConfigurationViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, FeedConfigurationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FeedConfigurationItem>

    enum Section {
        case main
    }

    lazy private var collectionView: UICollectionView = makeCollectionView()
    lazy private var collectionViewDataSource: DataSource = makeDataSource()

    private var dataItems: [FeedConfigurationItem] = []

    private let viewModel: FeedConfigurationViewModelType
    private let reloadSubject: PassthroughSubject<Void, Never> = .init()
    private let addConfigurationSubject: PassthroughSubject<FeedConfigurationItem, Never> = .init()
    private let deleteConfigurationSubject: PassthroughSubject<FeedConfigurationItem, Never> = .init()
    private let updateConfigurationSubject: PassthroughSubject<(old: FeedConfigurationItem, new: FeedConfigurationItem), Never> = .init()
    private var cancellables: [AnyCancellable] = []

    init(viewModel: FeedConfigurationViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadSubject.send(())
    }
}

private extension FeedConfigurationViewController {

    func setupViews() {
        setupNavigationBar()
        applySnapshot()
    }

    func render(_ state: FeedConfigurationViewModelState) {
        switch state {
        case .reload(let configurationItems):
            dataItems = configurationItems
            applySnapshot()
        case .success:
            break
        case .noResults:
            break
        case .failure:
            break
        }
    }

    func bind(to viewModel: FeedConfigurationViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input: FeedConfigurationViewModelInput = .init(
            reloadConfigurations: reloadSubject.eraseToAnyPublisher(),
            addConfiguration: addConfigurationSubject.eraseToAnyPublisher(),
            deleteConfiguration: deleteConfigurationSubject.eraseToAnyPublisher(),
            updateConfiguration: updateConfigurationSubject.eraseToAnyPublisher())

        let output: FeedConfigurationViewModelOutput = viewModel.transform(input: input)

        output
            .sink { [unowned self] state in
                self.render(state)
            }
            .store(in: &cancellables)
    }
}

extension FeedConfigurationViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem: FeedConfigurationItem = collectionViewDataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        let bottomSheetViewController: FeedConfigurationInputBottomSheetViewController = .init(reason: .edit(selectedItem), delegate: self)
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        collectionView.deselectItem(at: indexPath, animated: true)
        self.present(bottomSheetViewController, animated: false)
    }

    private func makeCollectionView() -> UICollectionView {
        var layoutConfiguration: UICollectionLayoutListConfiguration = .init(appearance: .insetGrouped)
        layoutConfiguration.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
            guard let item = collectionViewDataSource.itemIdentifier(for: indexPath) else {
                return UISwipeActionsConfiguration(actions: [])
            }

            let editAction: UIContextualAction = .init(
                style: .normal,
                title: "Delete") { [weak self] action, view, completion in
                    self?.handleSwipe(for: action, item: item)
                    completion(true)
                }
            editAction.backgroundColor = .systemRed

            return UISwipeActionsConfiguration(actions: [editAction])
        }

        let listLayout: UICollectionViewCompositionalLayout = .list(using: layoutConfiguration)

        let collectionView: UICollectionView = .init(
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
        let cellRegistration: UICollectionView.CellRegistration<FeedConfigurationCollectionViewCell, FeedConfigurationItem> = .init { cell, indexPath, item in
            cell.configure(with: item)
        }

        return DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: FeedConfigurationItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//            cell.accessories = [.disclosureIndicator()]

            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot: Snapshot = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)

        collectionViewDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func handleSwipe(for action: UIContextualAction, item: FeedConfigurationItem) {
        delete(item: item)
    }
}

private extension FeedConfigurationViewController {

    func setupNavigationBar() {
        let add: UIBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
    }

    @objc
    func addTapped() {
        let bottomSheetViewController: FeedConfigurationInputBottomSheetViewController = .init(reason: .new, delegate: self)
        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetViewController, animated: false)
    }
}

extension FeedConfigurationViewController: FeedConfigurationInputBottomSheetDelegate {
    func add(item: FeedConfigurationItem) {
        addConfigurationSubject.send(item)
    }

    func delete(item: FeedConfigurationItem) {
        deleteConfigurationSubject.send(item)
    }

    func update(oldItem: FeedConfigurationItem, newItem: FeedConfigurationItem) {
        updateConfigurationSubject.send((old: oldItem, new: newItem))
    }
}
