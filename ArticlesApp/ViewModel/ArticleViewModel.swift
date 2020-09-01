
import Foundation

class ArticleViewModel {
    var page = 1
    private let articleApi = ArticleApi()
    //By using escapeing keyword
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        articleApi.page = self.page
        articleApi.fetchArticles { (result) in
            completion(result)
        }
    }
}
