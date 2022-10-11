//
//  RepoCellViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 09.10.2022.
//

import Foundation

protocol RepoCellViewModelProtocol {
    var repoId: Int { get set }
    var repoName: String { get set }
}

class RepoCellViewModel: RepoCellViewModelProtocol {
    var repoId: Int
    var repoName: String
    
    init(repoId: Int, repoName: String) {
        self.repoId = repoId
        self.repoName = repoName
    }
}
