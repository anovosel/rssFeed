import Alamofire

enum APIClient {

//    "https://feeds.nbcnews.com/nbcnews/public/news"
    static func request(urlString: String) async {
        await withCheckedContinuation { continuation in
            AF.request(urlString).response { response in
                debugPrint(response)
                continuation.resume()
            }
        }
    }
}
