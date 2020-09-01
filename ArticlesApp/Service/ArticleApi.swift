


import Foundation

class ArticleApi {
    
    var page = 1
    private var articleUrl: String!
    
    init() {
        articleUrl = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=\(page)&limit=10"
    }
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        HTTPManager.shared.get(urlString: articleUrl, completionBlock: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let dta) :
                let decoder = JSONDecoder()
                do {
                    completion(.success(try decoder.decode([Article].self, from: dta)))
                } catch {
                    // deal with error from JSON decoding if used in production
                }
            }
        })
    }
    
}
