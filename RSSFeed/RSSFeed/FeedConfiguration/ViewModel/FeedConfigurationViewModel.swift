import Combine

final class FeedConfigurationViewModel {

    private let useCase: FeedConfigurationUseCaseType

    private let reloadConfigurationsState: AnyPublisher<FeedConfigurationViewModelState, Never>
    private let reloadConfigurationSubject: PassthroughSubject<[FeedConfigurationItem], Never>

    private var cancellables: [AnyCancellable] = []

    init(useCase: FeedConfigurationUseCaseType) {
        self.useCase = useCase
        reloadConfigurationSubject = .init()
        reloadConfigurationsState = reloadConfigurationSubject
            .map {
                .reload($0)
            }
            .eraseToAnyPublisher()
    }
}

extension FeedConfigurationViewModel: FeedConfigurationViewModelType {

    func transform(input: FeedConfigurationViewModelInput) -> FeedConfigurationViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input
            .reloadConfigurations
            .sink { [weak self] in
                self?.reloadConfigurations()
            }
            .store(in: &cancellables)

        input
            .addConfiguration
            .sink { [weak self] feedConfigurationItem in
                self?.useCase.addConfiguration(feedConfigurationItem)
                self?.reloadConfigurations()
            }
            .store(in: &cancellables)

        input
            .deleteConfiguration
            .sink { [weak self] feedConfigurationItem in
                self?.useCase.deleteConfiguration(feedConfigurationItem)
                self?.reloadConfigurations()
            }
            .store(in: &cancellables)

        input
            .updateConfiguration
            .sink { [weak self] (old: FeedConfigurationItem, new: FeedConfigurationItem) in
                self?.useCase.update(old: old, new: new)
                self?.reloadConfigurations()
            }
            .store(in: &cancellables)

        let noResultsState: FeedConfigurationViewModelOutput = Just(FeedConfigurationViewModelState.noResults)
            .eraseToAnyPublisher()
        let successState: FeedConfigurationViewModelOutput = Just(FeedConfigurationViewModelState.success)
            .eraseToAnyPublisher()

        let idle: FeedConfigurationViewModelOutput = Publishers.Merge(reloadConfigurationsState, noResultsState)
            .eraseToAnyPublisher()

        return Publishers.Merge(idle, successState)
//            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

private extension FeedConfigurationViewModel {

    func reloadConfigurations() {
        reloadConfigurationSubject.send(useCase.loadConfigurations())
    }
}
