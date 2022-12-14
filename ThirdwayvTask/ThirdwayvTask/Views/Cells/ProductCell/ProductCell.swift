//
//  ProductCell.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 14/12/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {

    // MARK: - OUTLETS
    
  //  @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    // MARK: - VARIABLES

    static let identifier = "ProductCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - LIFE-CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCell()
    }

}


// MARK: - SETUP

extension ProductCell {
    
    private func initCell() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func setupCell(with product: ProductData) {
        productImage.setImg(url: (product.image?.url)!)
        productPrice.text = String(product.price ?? 0) + "$"
        productDescription.text = product.productDescription
    }
}
