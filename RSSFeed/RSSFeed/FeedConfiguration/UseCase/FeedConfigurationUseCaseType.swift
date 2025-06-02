protocol FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationViewModel)

    func loadConfigurations() -> [FeedConfigurationViewModel]

    func deleteConfiguration(_ configuration: FeedConfigurationViewModel)

    func editConfiguration(_ configuration: FeedConfigurationViewModel)
}
