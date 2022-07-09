
import Foundation

protocol Networkable {
    func fetchData<T: Codable>(url: URL,type: T.Type,completionHandler: @escaping (Result<T,Error>)->Void)
}

class Networking: Networkable {
    func fetchData<T: Codable>(url: URL, type: T.Type, completionHandler: @escaping (Result < T, Error >) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let body = ["Content-Type": "application/json"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        urlRequest.httpBody = bodyData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest,completionHandler: { (data, response, error) in
            
            if let error = error {
                print("Error with fetching accounts:\(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code:\(String(describing: response))")
                return
            }
            guard let data = data else { return }
            do {
                let dataSummary = try JSONDecoder().decode(type, from: data)
                completionHandler(.success(dataSummary))
            } catch {
                completionHandler(.failure(error))
            }
        })
        task.resume()
    }
    
    
}
