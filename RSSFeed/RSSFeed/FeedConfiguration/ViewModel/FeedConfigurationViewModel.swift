import Combine

final class FeedConfigurationViewModel {

    private let useCase: FeedConfigurationUseCaseType
    private var cancellables: [AnyCancellable] = []

    init(useCase: FeedConfigurationUseCaseType) {
        self.useCase = useCase
    }
}

extension FeedConfigurationViewModel: FeedConfigurationViewModelType {

    func transform(input: FeedConfigurationViewModelInput) -> FeedConfigurationViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input.selection
            .sink(receiveValue: { [unowned self] feedConfiguration in
                // show edit configuration popup
            })
            .store(in: &cancellables)

        let initialState: FeedConfigurationViewModelOutput = Just(FeedConfigurationViewModelState.idle([]))
            .eraseToAnyPublisher()
        let noResultsState: FeedConfigurationViewModelOutput = Just(FeedConfigurationViewModelState.noResults)
            .eraseToAnyPublisher()
        let successState: FeedConfigurationViewModelOutput = Just(FeedConfigurationViewModelState.success)
            .eraseToAnyPublisher()

        let idle: FeedConfigurationViewModelOutput = Publishers.Merge(initialState, noResultsState)
            .eraseToAnyPublisher()

        return Publishers.Merge(idle, successState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
