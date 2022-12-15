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
    
    private var model: [ProductData]? = [ProductData]() {
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
        if NetworkMonitor.shared.isConnected {
            return model?[indexPath.row]
        }else {
            let products = cash.object(forKey: "products") as? [ProductData]
            return products?[indexPath.row]
        }
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
                guard let products = products.products else {return}
                self.model?.append(contentsOf: products)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func saveData() {
        var productsArray = [ProductData]()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            guard let products = self.model else {return}
            for product in products {
            if let url = URL(string: (product.image?.url)!) {
                    do {
                        let data = try  Data(contentsOf: url)
                        let productData = ProductData()
                        productData.imageDate =  data
                        productData.price = product.price
                        productData.productDescription = product.productDescription
                        productsArray.append(productData)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            self.cash.setObject(productsArray as NSArray, forKey: CashKey.products.rawValue)
        }
    }
}

enum CashKey: NSString {
    case products = "products"
}
