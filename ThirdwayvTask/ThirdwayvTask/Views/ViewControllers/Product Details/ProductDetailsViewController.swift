//
//  ProductDetailsViewController.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 15/12/2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    
    
    var product: ProductData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = product.image?.url {
            productImage.downloadImage(from: url)
        }
        productPrice.text = String(product.price ?? 0) + "$"
        productDescription.text = product.productDescription
    }
}
