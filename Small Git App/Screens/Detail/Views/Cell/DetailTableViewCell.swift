//
//  DetailTableViewCell.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let reuseId = "DetailTableViewCell"
    
    var viewModel: DetailCellViewModelProtocol? {
        didSet {
            parameterLabel.text = viewModel?.paramName
            descriptionLabel.text = viewModel?.paramDescription
            viewModel?.getImage()
            self.viewModel?.avatarChanged = { [weak self] viewModel in
                DispatchQueue.main.async {
                    self?.avatarImageView.image = viewModel.avatarImage
                    self?.avatarImageView.isHidden = false
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        parameterLabel.text = ""
        avatarImageView.image = UIImage()
        avatarImageView.isHidden = true
        descriptionLabel.text = ""
    }
    
    override func prepareForReuse() {
        parameterLabel.text = ""
        avatarImageView.image = UIImage()
        avatarImageView.isHidden = true
        descriptionLabel.text = ""
    }
}
