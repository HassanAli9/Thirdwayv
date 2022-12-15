//
//  Product.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 14/12/2022.
//

import Foundation


// MARK: - productes
class Product: Codable {
    let products: [ProductData]?
}

// MARK: - Producte
class ProductData: Codable {
 var id: Int?
 var productDescription: String?
 var image: Image?
 var imageDate: Data?
 var price: Int?
}

// MARK: - Image
struct Image: Codable {
    let width, height: Int?
    let url: String?
}
