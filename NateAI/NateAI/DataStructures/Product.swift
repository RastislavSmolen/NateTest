
import Foundation

// MARK: - Products
struct Products: Codable {
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let id, createdAt, updatedAt, title: String
    let images: [String]
    let url: String
    let merchant: String
}
