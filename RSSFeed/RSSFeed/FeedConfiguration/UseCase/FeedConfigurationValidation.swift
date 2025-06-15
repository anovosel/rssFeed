import Foundation

enum FeedConfigurationValidation {

    case success
    case failure(reason: FeedConfigurationValidationFailureReason)
}

enum FeedConfigurationValidationFailureReason {

    case name(message: String)
    case urlString(message: String)
}
