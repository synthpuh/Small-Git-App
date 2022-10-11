//
//  RepoTableViewCell.swift
//  Small Git App
//
//  Created by Ольга Шубина on 09.10.2022.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    static let reuseId = "RepoTableViewCell"

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    var viewModel: RepoCellViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }
            cellLabel.text = "/\(viewModel.repoName)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLabel.text = ""
        cellImageView.image = UIImage(systemName: "folder.fill")
    }
    
    override func prepareForReuse() {
        cellLabel.text = ""
        cellImageView.image = UIImage(systemName: "folder.fill")
    }
    
}
