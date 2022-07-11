
import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet var productImageView: UIImageView!
    
}
class DisplayProductVC: UICollectionViewController {
    
    var product: Products?
    
    private let itemsPerRow: CGFloat = 2
    var section = Int()
    
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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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

extension DisplayProductVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productCount = product?.products[section].images[section].count else {return 1}
        self.section = section
        return productCount
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {return UICollectionViewCell()}
        let image = UIImage()
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let itemNumber = NSNumber(value: indexPath.item)
        
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            print("Using a cached image for item: \(itemNumber)")
            cell.productImageView.image = cachedImage
        } else {
            // 4
            self.loadImage(indexPath: indexPath.row) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                
                cell.productImageView.image = image
                
                // 5
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
        return cell
    }
}


// MARK: - Collection View Flow Layout Delegate

extension DisplayProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

import UIKit
extension UIImage {
    func validateImage(imageUrl:String) -> UIImage {
        let defaultImage = URL(string: "https://cdn.pixabay.com/photo/2017/09/22/21/43/table-2777180_1280.jpg")
        let imageURL = URL(string: imageUrl)
        
        var image = UIImage()
        
        guard let defImage = defaultImage else { return UIImage() }
        
        let imageUrl = imageURL ?? defImage
        
        if let imageData = try? Data(contentsOf: imageUrl) {
            guard let imageData = UIImage(data: imageData) else { return UIImage() }
            image = imageData
        } else {
            guard let defaultImageData = try? Data(contentsOf: defImage) else { return UIImage() }
            guard let imageData = UIImage(data: defaultImageData) else { return UIImage() }
            image = imageData
        }
        return image
    }
    
}
