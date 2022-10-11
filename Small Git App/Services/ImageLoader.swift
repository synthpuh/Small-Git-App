//
//  ImageLoader.swift
//  Small Git App
//
//  Created by Ольга Шубина on 07.10.2022.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func getImage(imageUrlString: String, completion: @escaping (UIImage) -> ())
}

class ImageLoader: ImageLoaderProtocol {
    
    func getImage(imageUrlString: String, completion: @escaping (UIImage) -> ()) {
        guard let imageUrl = URL(string: imageUrlString) else {
            completion(UIImage())
            return
        }
        let request = URLRequest(url: imageUrl)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(UIImage())
                return
            }
            let image = UIImage(data: data)
            completion(image ?? UIImage())
        }.resume()
    }
}
