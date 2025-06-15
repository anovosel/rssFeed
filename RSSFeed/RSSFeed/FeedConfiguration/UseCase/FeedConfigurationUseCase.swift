final class FeedConfigurationUseCase {

    private let repository: FeedConfigurationRepository
    private let feedLoader: FeedLoader

    init(repository: FeedConfigurationRepository,
         feedLoader: FeedLoader) {
        self.repository = repository
        self.feedLoader = feedLoader
    }
}

extension FeedConfigurationUseCase: FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationItem) {
        repository
            .saveConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    description: configuration.description))
    }
    
    func loadConfigurations() async -> [FeedConfigurationItem] {
        await repository
            .getConfigurations()
            .asyncMap {
                let imageUrlString: String? = await feedLoader.loadFeed(fromUrl: $0.urlString)?.imageUrlString
                return .init(name: $0.name,
                         urlString: $0.urlString,
                         description: $0.description,
                         imageURLString: imageUrlString) }
    }
    
    func deleteConfiguration(_ configuration: FeedConfigurationItem) {
        repository
            .deleteConfiguration(
                .init(
                    name: configuration.name,
                    urlString: configuration.urlString,
                    description: configuration.description))
    }
    
    func update(old: FeedConfigurationItem, new: FeedConfigurationItem) {
        repository
            .updateConfiguration(
                originalUrlString: old.urlString,
                withConfiguration: .init(
                    name: new.name,
                    urlString: new.urlString,
                    description: new.description))
    }

    func validateNew(_ configuration: FeedConfigurationItem) async -> FeedConfigurationValidation {
        if existsConfiguration(withName: configuration.name) {
            return .failure(reason: .name(message: "Given name already exists!"))
        }
        return await commonValidation(configuration)
    }

    func validateExisting(_ configuration: FeedConfigurationItem) async -> FeedConfigurationValidation {
        return await commonValidation(configuration)
    }
}

private extension FeedConfigurationUseCase {

    func commonValidation(_ configuration: FeedConfigurationItem) async -> FeedConfigurationValidation {
        if configuration.name.isEmpty {
            return .failure(reason: .name(message: "Name cannot be empty!"))
        }
        if existsConfiguration(withUrlString: configuration.urlString) {
            return .failure(reason: .urlString(message: "Given URL already exists!"))
        }
        if await feedLoader.loadFeed(fromUrl: configuration.urlString) == nil {
            return .failure(reason: .urlString(message: "Unable to load feed from URL!"))
        }

        return .success
    }

    func existsConfiguration(withName name: String) -> Bool {
        repository.getConfiguration(withName: name) != nil
    }

    func existsConfiguration(withUrlString urlString: String) -> Bool {
        repository.getConfiguration(withUrlString: urlString) != nil
    }
}
