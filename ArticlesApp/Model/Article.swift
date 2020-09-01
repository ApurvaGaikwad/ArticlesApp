
import Foundation

struct Articles: Codable {
    var articles: [Article]?
}

struct Article: Codable {
    var content: String?
    var comments: Int?
    var likes: Int?
    var media:[Media]?
    var user: [User]?
}

struct Media: Codable {
    var image: String?
    var title: String?
    var url: String?
}

struct User: Equatable, Codable {
    var name: String?
    var avatar: String?
    var lastname: String?
    var designation: String?
}
