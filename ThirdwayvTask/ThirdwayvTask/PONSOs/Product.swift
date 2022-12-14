//
//  Product.swift
//  ThirdwayvTask
//
//  Created by Hassan Ali on 14/12/2022.
//

import Foundation

// MARK: - productes
struct Product: Codable {
    let products: [ProductData]?
}

// MARK: - Producte
struct ProductData: Codable {
    let id: Int?
    let productDescription: String?
    let image: Image?
    let price: Int?
}

// MARK: - Image
struct Image: Codable {
    let width, height: Int?
    let url: String?
}
