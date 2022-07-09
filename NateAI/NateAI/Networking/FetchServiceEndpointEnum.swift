
import Foundation

enum APIEndpoint: String{
    case mockApi = "MockAlbumJsonAPI"
    func make() -> String {return self.rawValue}
}
