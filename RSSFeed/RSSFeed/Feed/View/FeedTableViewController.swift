import Combine
import UIKit

import SnapKit

final class FeedTableViewController: UIViewController {

    typealias DataSource = UITableViewDiffableDataSource<Section, FeedConfigurationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FeedConfigurationItem>

    enum Section {
        case main
    }

    private let tableView: UITableView = .init()

    private lazy var dataSource: DataSource = makeDataSource()

    private var dataItems: [FeedConfigurationItem] = []
    private let viewModel: FeedViewModelType
    private let reloadSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellables: [AnyCancellable] = []



    init(viewModel: FeedViewModelType) {
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

extension FeedTableViewController: UITableViewDelegate {
}

private extension FeedTableViewController {

    func setupViews() {
        setupTableView()
        setupConstraints()
    }

    func render(_ state: FeedViewModelState) {
        switch state {
        case .reload(let configurationItems):
            dataItems = configurationItems
            applySnapshot()
        }
    }

    func bind(to viewModel: FeedViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input: FeedViewModelInput = .init(reloadFeeds: reloadSubject.eraseToAnyPublisher())

        let output: FeedViewModelOutput = viewModel.transform(input: input)

        output
            .sink { [unowned self] state in
                self.render(state)
            }
            .store(in: &cancellables)
    }

    func setupTableView() {
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        applySnapshot()
    }

    func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension FeedTableViewController {

    func makeDataSource() -> DataSource {

        let dataSource = DataSource(tableView: tableView,
                                    cellProvider: { (tableView, indexPath, title) -> UITableViewCell? in
            guard let cell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.description()) as? FeedTableViewCell else {
                let cell: FeedTableViewCell = .init(style: .default, reuseIdentifier: FeedTableViewCell.description())
                cell.configure(with: self.dataItems[indexPath.row])
                return cell
            }
            cell.configure(with: self.dataItems[indexPath.row])
            return cell
        })

        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot: Snapshot = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
