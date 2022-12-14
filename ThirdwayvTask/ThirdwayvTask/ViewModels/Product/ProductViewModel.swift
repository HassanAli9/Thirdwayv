//
//  ProductVM.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 14/12/2022.
//

import Foundation
import Network
import UIKit

class ProductViewModel {
   private let network = Network.shared
    
    var bindModelOnSuccess: ()->() = {}
    var bindErrorOnFailure: ()->() = {}
    
    private var model: [ProductData]? {
        didSet {
            bindModelOnSuccess()
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
                print("Got data \(products)")
            case .failure(let error):
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
