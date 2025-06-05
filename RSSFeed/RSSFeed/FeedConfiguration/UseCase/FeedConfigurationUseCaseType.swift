protocol FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfiguration)

    func loadConfigurations() -> [FeedConfiguration]

    func deleteConfiguration(_ configuration: FeedConfiguration)

    func editConfiguration(_ configuration: FeedConfiguration)
}
