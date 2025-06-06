import Combine
import UIKit

import SnapKit

final class FeedConfigurationViewController: UIViewController {

    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, FeedConfigurationItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, FeedConfigurationItem>!

    let dataItems: [FeedConfigurationItem] = [
        FeedConfigurationItem(name: "Stream1", urlString: "stream1.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream2", urlString: "stream2.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream3", urlString: "stream3.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream4", urlString: "stream4.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream5", urlString: "stream5.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream6", urlString: "stream6.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream7", urlString: "stream7.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream8", urlString: "stream8.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream9", urlString: "stream9.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream10", urlString: "stream10.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream11", urlString: "stream11.example.com", description: nil, imageURLString: nil),
        FeedConfigurationItem(name: "Stream12", urlString: "stream12.example.com", description: nil, imageURLString: nil)
    ]

    let viewModel: FeedConfigurationViewModelType
    private let appearSubject: PassthroughSubject<Void, Never> = .init()
    private let addConfigurationSubject: PassthroughSubject<FeedConfigurationItem, Never> = .init()
    private let selectionSubject: PassthroughSubject<FeedConfigurationItem, Never> = .init()
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
        configureUI()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearSubject.send(())
    }
}

private extension FeedConfigurationViewController {

    func configureUI() {
        setupNavigationBar()
        setupCollectionView()
        setupCollectionViewDataSource()
        setupSnapshot()
    }

    func render(_ state: FeedConfigurationViewModelState) {

    }

    func bind(to viewModel: FeedConfigurationViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = FeedConfigurationViewModelInput(
            appear: appearSubject.eraseToAnyPublisher(),
            addConfiguration: addConfigurationSubject.eraseToAnyPublisher(),
            selection: selectionSubject.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: { [unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
}

extension FeedConfigurationViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = collectionViewDataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        let alert = UIAlertController(
            title: selectedItem.name,
            message: "",
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (_) in
            collectionView.deselectItem(at: indexPath, animated: true)
        })

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    private func setupCollectionView() {
        var layoutConfiguration: UICollectionLayoutListConfiguration = .init(appearance: .insetGrouped)
        layoutConfiguration.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
            guard let item = collectionViewDataSource.itemIdentifier(for: indexPath) else {
                return UISwipeActionsConfiguration(actions: [])
            }

            let action1: UIContextualAction = .init(
                style: .normal,
                title: "Action 1") { [weak self] action, view, completion in
                    self?.handleSwipe(for: action, item: item)
                    completion(true)
                }
            action1.backgroundColor = .systemBlue

            let action2: UIContextualAction = .init(
                style: .normal,
                title: "Action 2") { [weak self] action, view, completion in
                    self?.handleSwipe(for: action, item: item)
                    completion(true)
                }
            action2.backgroundColor = .systemOrange

            return UISwipeActionsConfiguration(actions: [action1, action2])
        }

        let listLayout: UICollectionViewCompositionalLayout = .list(using: layoutConfiguration)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        collectionView.delegate = self

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupCollectionViewDataSource() {
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, FeedConfigurationItem> = .init { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
    //        content.image
            content.text = itemIdentifier.name

            cell.contentConfiguration = content
        }

        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, FeedConfigurationItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: FeedConfigurationItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            cell.accessories = [.disclosureIndicator()]

            return cell
        }
    }

    private func setupSnapshot() {
        snapshot = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)

        collectionViewDataSource.apply(snapshot, animatingDifferences: false)
    }

    func handleSwipe(for action: UIContextualAction, item: FeedConfigurationItem) {
        let alert: UIAlertController = .init(
            title: action.title,
            message: item.name,
            preferredStyle: .alert)

        let okAction: UIAlertAction = .init(
            title: "OK",
            style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
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
        let bottomSheetViewController: FeedConfigurationInputBottomSheetViewController = .init()
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        self.present(bottomSheetViewController, animated: false)
    }
}
