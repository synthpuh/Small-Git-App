//
//  ReposViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 05.10.2022.
//

import Foundation
import UIKit

protocol ReposViewModelProtocol {
    var profile: GithubProfileProtocol? { get set }
    var imageLoader: ImageLoaderProtocol? { get set }
    var reposService: ReposServiceProtocol? { get set }
    var repositories: [RepoDetailsProtocol] { get set }
    var avatarImage: UIImage? { get set }
    var avatarChanged: ((ReposViewModelProtocol) -> ())? { get set }
    var reposFetched: ((ReposViewModelProtocol) -> ())? { get set }
    var selectedRepo: RepoDetailsProtocol? { get set }
    
    func getImage()
    func loadRepos()
    func setSelection(for index: Int)
}

class ReposViewModel: ReposViewModelProtocol {
    
    var profile: GithubProfileProtocol?
    var imageLoader: ImageLoaderProtocol?
    var reposService: ReposServiceProtocol?
    
    var repositories: [RepoDetailsProtocol] = [] {
        didSet {
            self.reposFetched?(self)
        }
    }
    var avatarImage: UIImage? {
        didSet {
            self.avatarChanged?(self)
        }
    }
    var avatarChanged: ((ReposViewModelProtocol) -> ())?
    var reposFetched: ((ReposViewModelProtocol) -> ())?
    var selectedRepo: RepoDetailsProtocol?
    
    init(profile: GithubProfileProtocol?, imageLoader: ImageLoaderProtocol?, reposService: ReposServiceProtocol?) {
        self.profile = profile
        self.imageLoader = imageLoader
        self.reposService = reposService
    }
    
    func getImage() {
        guard let avatarUrlString = profile?.avatarUrlString else { return }
        imageLoader?.getImage(imageUrlString: avatarUrlString, completion: { [weak self] image in
            self?.avatarImage = image
        })
    }
    
    func loadRepos() {
        reposService?.fetchRepos(completion: { [weak self] repos in
            self?.repositories = repos
        })
    }
    
    func setSelection(for index: Int) {
        selectedRepo = repositories[index]
    }
}
