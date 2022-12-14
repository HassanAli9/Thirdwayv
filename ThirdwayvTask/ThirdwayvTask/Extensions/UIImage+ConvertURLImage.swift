//
//  ConvertURLImage.swift
//  Social Media
//
//  Created by Hassan on 02/06/2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImg(url: String) {
        if let urlPostImg = URL(string: url) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: urlPostImg)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func getImage(url: String, completion: @escaping (Data?) -> () ){
        if let urlPostImg = URL(string: url) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: urlPostImg)
                        completion(data)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
}




