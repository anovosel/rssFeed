import Foundation

struct FeedConfigurationDTO: Decodable {

    let name: String
    let urlString: String
    let imageUrlString: String?
    let description: String?
}
