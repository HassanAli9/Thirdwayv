//
//  ProductVM.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 14/12/2022.
//

import Foundation
import NetworkLayer
import UIKit

class ProductViewModel {
   private let network = NetworkLayer.shared
   private var cash = NSCache<NSString, AnyObject>()

    
    var bindModelOnSuccess: ()->() = {}
    var bindErrorOnFailure: ()->() = {}
    
    private var model: [ProductData]? {
        didSet {
            bindModelOnSuccess()
            saveData()
        }
    }
    var errorMessage: String? {
        didSet {
            bindErrorOnFailure()
        }
    }
    
    init() {
        fetchData()
    }
    
    
    func getProduct(at indexPath: IndexPath)-> ProductData? {
        return model?[indexPath.row]
    }
    
    func getCount() -> Int? {
        model?.count ?? 0
    }
    
    func getImageHeight(at indexPath: IndexPath) -> CGFloat {
        
       
        let height = (model?[indexPath.row].image?.height!)!
        return CGFloat(height)
    }
    
    
   
    
    func fetchData() {
        network.get(responseModel: Product.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let products):
                self.model = products.products
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    
    func saveData()  {
        let cashedProduct = CashedProduct()
        var productsArray = [CashedProduct]()
      
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            for product in self.model! {
            if let url = URL(string: (product.image?.url)!) {
                    do {
                        let data = try  Data(contentsOf: url)
                        cashedProduct.image = UIImage(data: data)
                        cashedProduct.price = product.price
                        cashedProduct.description = product.productDescription
                        productsArray.append(cashedProduct)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            self.cash.setObject(productsArray as NSArray, forKey: "products")
        }
    }
}


class CashedProduct {
    var image: UIImage?
    var price: Int?
    var description: String?
}
