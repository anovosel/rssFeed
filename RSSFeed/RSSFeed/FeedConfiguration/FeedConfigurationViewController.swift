import Combine
import UIKit

final class FeedConfigurationViewController: UIViewController {

    let viewModel: FeedConfigurationViewModelType
    private let appearSubject: PassthroughSubject<Void, Never> = .init()
    private let addConfigurationSubject: PassthroughSubject<FeedConfiguration, Never> = .init()
    private let selectionSubject: PassthroughSubject<FeedConfiguration, Never> = .init()
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
        self.view.backgroundColor = .red
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
