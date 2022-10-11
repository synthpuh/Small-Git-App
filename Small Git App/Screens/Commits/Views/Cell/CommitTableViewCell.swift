//
//  CommitTableViewCell.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import UIKit

class CommitTableViewCell: UITableViewCell {
    
    static let reuseId = "CommitTableViewCell"
    
    var viewModel: CommitCellViewModelProtocol? {
        didSet {
            hashLabel.text = viewModel?.hash
            messageLabel.text = viewModel?.message
            authorLabel.text = viewModel?.authorName
            dateLabel.text = viewModel?.formattedDate
        }
    }

    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hashLabel.text = ""
        messageLabel.text = ""
        authorLabel.text = ""
        dateLabel.text = ""
    }
    
    override func prepareForReuse() {
        hashLabel.text = ""
        messageLabel.text = ""
        authorLabel.text = ""
        dateLabel.text = ""
    }
}
