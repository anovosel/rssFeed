protocol FeedConfigurationUseCaseType {

    func addConfiguration(_ configuration: FeedConfigurationItem)

    func loadConfigurations() -> [FeedConfigurationItem]

    func deleteConfiguration(_ configuration: FeedConfigurationItem)

    func editConfiguration(_ configuration: FeedConfigurationItem)
}
