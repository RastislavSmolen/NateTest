
import UIKit

class DisplayProductViewController: UICollectionViewController {
    
    var product: Products?
    var i = Int()
    
    private let sectionInsets = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0)
    
    private var model : ProdcutListViewModel?
    
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
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
            self?.reload()
        }
    }
    private func loadImage(indexPath:Int,completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            
            guard let product = self.product?.products[indexPath].images else {return}
            var images = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJQ9xu5I_En7x6FYaQ8Mlf2QSMCg1cFAUu7w&usqp=CAU"
            if product.isEmpty {
                images = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJQ9xu5I_En7x6FYaQ8Mlf2QSMCg1cFAUu7w&usqp=CAU"
            } else {
                images = product[0]
            }
            let url = URL(string: images)!
            
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    private func reload(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
        }
    }
    
}

// MARK: - Collection View Setup

extension DisplayProductViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        i = indexPath.row
        performSegue(withIdentifier: "ShowDetail", sender: collectionView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ProductDetailViewController else { return }
        destinationVC.product = product
        destinationVC.i = i
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productCount = product?.products[section].images[section].count else {return 1}
        return productCount
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {return UICollectionViewCell()}
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let itemNumber = NSNumber(value: indexPath.row)
        
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            
            print("Using a cached image for item: \(itemNumber)")
            cell.productImageView.image = cachedImage
            
        } else {
            self.loadImage(indexPath: indexPath.row) { [weak self] (image) in
                
                guard let self = self, let image = image else { return }
                
                self.cache.setObject(image, forKey: itemNumber)
                cell.productImageView.image = image
            }
        }
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate

extension DisplayProductViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 195, height: 195)
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
