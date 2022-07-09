
import Foundation
class ProdcutListViewModel {
    
    var networking: Networkable
    
    init(networking: Networkable = Networking()) {
        self.networking = networking
    }
    
    func fetchData(completion: @escaping ((_ data: Products?,_ err:String?)->Void)) {
        
        guard let urlString = URL(string: "http://localhost:3000/products") else {return}
        
        networking.fetchData(url: urlString, type: Products.self) { (result) in
            switch result {
            case.success(let response): completion(response,nil)
            case.failure(let error): completion(nil,error.localizedDescription)
                DispatchQueue.main.async {
                    print(error.self)
                }
            }
        }
    }
}
