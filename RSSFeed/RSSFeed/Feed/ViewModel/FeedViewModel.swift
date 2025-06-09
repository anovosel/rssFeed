import Combine

final class FeedViewModel {

    private let useCase: FeedUseCaseType

    private let reloadFeedsState: AnyPublisher<FeedViewModelState, Never>
    private let reloadFeedsSubject: PassthroughSubject<[FeedConfigurationItem], Never>

    private var cancellables: [AnyCancellable] = []

    init(useCase: FeedUseCaseType) {
        self.useCase = useCase

        reloadFeedsSubject = .init()
        reloadFeedsState = reloadFeedsSubject
            .map {
                .reload($0)
            }
            .eraseToAnyPublisher()
    }
}

extension FeedViewModel: FeedViewModelType {

    func transform(input: FeedViewModelInput) -> FeedViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input
            .reloadFeeds
            .sink { [weak self] in
                self?.reloadFeeds()
            }
            .store(in: &cancellables)

        return reloadFeedsState
    }
}

private extension FeedViewModel {

    func reloadFeeds() {
        Task { @MainActor in
            let loadedFeeds: [FeedConfigurationItem] = await useCase.loadFeeds()
            reloadFeedsSubject.send(loadedFeeds)
        }
    }
}
