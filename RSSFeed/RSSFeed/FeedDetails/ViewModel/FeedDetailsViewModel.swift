import Combine

final class FeedDetailsViewModel {

    private let useCase: FeedDetailsUseCaseType

    private let reloadDetailsState: AnyPublisher<FeedDetailsViewModelState, Never>
    private let reloadDetailsSubject: PassthroughSubject<[FeedDetailsItem], Never>

    private var cancellables: [AnyCancellable] = []

    init(useCase: FeedDetailsUseCaseType) {
        self.useCase = useCase
        reloadDetailsSubject = .init()
        reloadDetailsState = reloadDetailsSubject
            .map {
                .reload($0)
            }
            .eraseToAnyPublisher()
    }
}

extension FeedDetailsViewModel: FeedDetailsViewModelType {

    func transform(input: FeedDetailsViewModelInput) -> FeedDetailsViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input
            .reload
            .sink { [weak self] configuration in
                self?.reloadDetails(configuration: configuration)
            }
            .store(in: &cancellables)

        return reloadDetailsState
    }
}

private extension FeedDetailsViewModel {

    func reloadDetails(configuration: FeedConfigurationItem) {
        Task { @MainActor in
            let feedDetailsItems: [FeedDetailsItem] = await useCase.loadDetails(configuration)
            reloadDetailsSubject.send(feedDetailsItems)
        }
    }
}
