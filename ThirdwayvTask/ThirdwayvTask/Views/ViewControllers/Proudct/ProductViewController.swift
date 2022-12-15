//
//  ProductViewController.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 14/12/2022.
//

import UIKit

class ProductViewController: UIViewController {
    
    // MARK: - OUTLETS

    @IBOutlet weak var collectionView: UICollectionView!
   
    // MARK: - VARIABLES

    var productViewModel: ProductViewModel!

    // MARK: - LIFE-CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
}

// MARK: - SETUP

extension ProductViewController {
    private func initVC() {
        setupViewModel()
        setupCollectionView()
        
       if NetworkMonitor.shared.isConnected {
            print("Connected")
       }else {
           print("Not Connected")
       }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        collectionView.register(ProductCell.nib, forCellWithReuseIdentifier: ProductCell.identifier)
    }
    // END OF EXTENSION
}

// MARK: - VIEWMODEL

extension ProductViewController {
    private func setupViewModel() {
        productViewModel = ProductViewModel()
        productViewModel.bindModelOnSuccess = { [weak self] in
            self?.onSuccess()
        }
        productViewModel.bindErrorOnFailure = { [weak self] in
            self?.onFailure()
        }
    }
    
    private func onSuccess() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func onFailure() {
        let alert = UIAlertController(title: "Error", message: productViewModel.errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    // END OF EXTENSION
}

// MARK: - COLLECTION VIEW

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productViewModel.getCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell

        if let product = productViewModel.getProduct(at: indexPath) {
            cell.setupCell(with: product)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        guard let product = productViewModel.getChasedProduct(at: indexPath) else {return}
        productDetailsViewController.product = product
        
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = productViewModel.getCount() else {return}
        if indexPath.row == count - 1 {
            productViewModel.fetchData()
        }
    }
    
 
}

// MARK: - COLLECTION VIEW LAYOUT
extension ProductViewController: UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
   
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        let desc = productViewModel.getProduct(at: indexPath)?.productDescription
        let photoHeight = productViewModel.getImageHeight(at: indexPath)
        
        guard let textHeight = desc?.heightWithConstrainedWidth(width: width, font: .systemFont(ofSize: 16)) else
        {return photoHeight + 67}
        
        
        let height = photoHeight + textHeight + 67
        return  height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
