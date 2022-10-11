//
//  DetailViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation

protocol DetailViewModelProtocol {
    var repository: RepoDetailsProtocol? { get set }
    var params: [(String, String)] { get }
    var avatarImageString: String? { get }
}

class DetailViewModel: DetailViewModelProtocol {
    
    var repository: RepoDetailsProtocol?
    
    var params: [(String, String)] {
        return [
                ("", repository?.description ?? "No description provided"),
                ("Author", repository?.owner.login ?? ""),
                ("Forks", String(repository?.forksCount ?? 0)),
                ("Watchers", String(repository?.watchersCount ?? 0))]
    }
    
    var avatarImageString: String? {
        return repository?.owner.avatarUrl
    }
    
}
