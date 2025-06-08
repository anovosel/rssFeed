import UIKit

import SnapKit

final class FeedTableViewController: UIViewController {

    let tableView: UITableView = .init()

    var dataItems: [FeedConfigurationItem] = [
        FeedConfigurationItem(name: "Stream1", urlString: "stream1.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream2", urlString: "stream2.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream3", urlString: "stream3.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream4", urlString: "stream4.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream5", urlString: "stream5.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream6", urlString: "stream6.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream7", urlString: "stream7.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream8", urlString: "stream8.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream9", urlString: "stream9.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream10", urlString: "stream10.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream11", urlString: "stream11.example.com", description: "Description, description, description", imageURLString: nil),
        FeedConfigurationItem(name: "Stream12", urlString: "stream12.example.com", description: "Description, description, description", imageURLString: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        setupTableView()
        setupConstraints()
    }

    func setupTableView() {
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.description())
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension FeedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.description()) as? FeedTableViewCell else {
            let cell: FeedTableViewCell = .init(style: .default, reuseIdentifier: FeedTableViewCell.description())
            cell.configure(with: dataItems[indexPath.row])
            return cell
        }
        cell.configure(with: dataItems[indexPath.row])
        return cell
    }
}
