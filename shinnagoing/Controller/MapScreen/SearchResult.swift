import Foundation

struct SearchResult: Decodable {
    let items: [Location]
}

struct Location: Decodable {
    let title: String
    let link: String
    let category: String
    let description: String
    let telephone: String
    let address: String
    let roadAddress: String

    private enum CodingKeys: String, CodingKey {
        case title
        case link
        case category
        case description
        case telephone
        case address
        case roadAddress
    }
}

