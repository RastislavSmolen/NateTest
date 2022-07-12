
import Foundation
import UIKit
class ProductDetailViewController : UIViewController {

    var product : Products?
    var i = Int()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var productTitleLabel: UILabel!

    private let sectionInsets = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
       
        guard let product = product else { return }
        productTitleLabel.text = product.products[i].title
    }
}
extension ProductDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {


     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productCount = product?.products[i].images.count else {return 1}
        return productCount
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailCell", for: indexPath) as? ProductDetailCell else {return UICollectionViewCell()}

        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let url = URL(string: (product?.products[i].images[indexPath.row])!)!
        
        guard let data = try? Data(contentsOf: url) else { return cell }
        let image = UIImage(data: data)
        
        cell.productImageView.image =  image
        cell.productImageView.backgroundColor = .black
        cell.backgroundColor? = .black
                
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    
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
