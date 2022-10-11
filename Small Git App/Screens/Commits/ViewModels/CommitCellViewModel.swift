//
//  CommitCellViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation

protocol CommitCellViewModelProtocol {
    var hash: String { get set }
    var message: String { get set }
    var authorName: String { get set }
    var dateString: String { get set }
    var formattedDate: String { get }
}

class CommitCellViewModel: CommitCellViewModelProtocol {
    
    var hash: String
    var message: String
    var authorName: String
    var dateString: String
    
    var formattedDate: String {
        formatDate(dateString: dateString)
    }
    
    init(hash: String?, message: String?, authorName: String?, dateString: String?) {
        self.hash = hash ?? "no hash provided"
        self.message = message ?? "no commit message provided"
        self.authorName = authorName ?? "no author data provided"
        self.dateString = dateString ?? ""
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        guard let date: Date = dateFormatterGet.date(from: dateString) else { return ""}
        return dateFormatterPrint.string(from: date)
    }
    
}
