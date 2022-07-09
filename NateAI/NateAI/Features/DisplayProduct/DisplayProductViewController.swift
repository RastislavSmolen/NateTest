
import UIKit

class ViewController: UIViewController {

    var product: Products?
  
    private var model : ProdcutListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        fetchData()
    }

    
    private func setupModel() {
        model = ProdcutListViewModel()
    }
    
    private func fetchData() {
        model?.fetchData{ [weak self] (data,error)  in
                guard let data = data else { return }
                self?.product = data
                print(data)
        }
    }
    
}
