//
//  DetailCellViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation
import UIKit

protocol DetailCellViewModelProtocol {
    var paramName: String { get set }
    var paramDescription: String { get set }
    var imageUrl: String? { get set }
    var avatarImage: UIImage? { get set }
    var avatarChanged: ((DetailCellViewModelProtocol) -> ())? { get set }
    var imageLoader: ImageLoaderProtocol? { get set }
    
    func getImage()
}

class DetailCellViewModel: DetailCellViewModelProtocol {
    
    var paramName: String
    var paramDescription: String
    var imageUrl: String?
    var imageLoader: ImageLoaderProtocol?
    
    var avatarImage: UIImage? {
        didSet {
            self.avatarChanged?(self)
        }
    }
    var avatarChanged: ((DetailCellViewModelProtocol) -> ())?
    
    init(paramName: String, paramDescription: String, imageUrl: String?, imageLoader: ImageLoaderProtocol?) {
        self.paramName = paramName
        self.paramDescription = paramDescription
        self.imageUrl = imageUrl
        self.imageLoader = imageLoader
    }
    
    func getImage() {
        guard let avatarUrlString = imageUrl else { return }
        imageLoader?.getImage(imageUrlString: avatarUrlString, completion: { [weak self] image in
            self?.avatarImage = image
        })
    }
    
}
