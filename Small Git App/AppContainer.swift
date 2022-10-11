//
//  AppContainer.swift
//  Small Git App
//
//  Created by Ольга Шубина on 04.10.2022.
//

import Foundation
import Swinject

class AppContainer {
    
    static let container: Container = {
        let container = Container()
        
        // Models
        container.register(GithubProfileProtocol.self) { (_, userId: Int?, name: String?, avatarUrlString: String?) in GithubProfile(userId: userId, name: name, avatarUrlString: avatarUrlString)
        }.inObjectScope(.graph)
        
        // View models
        container.register(LoginViewModelInterface.self) { r in
            let viewModel = LoginViewModel(authorisationService: r.resolve(AuthorisationServiceProtocol.self)!)
            return viewModel
        }.inObjectScope(.container)
        
        container.register(ReposViewModelProtocol.self) { (r: Resolver, userId: Int?, name: String?, imageUrlString: String?) in
            ReposViewModel(profile: r.resolve(GithubProfileProtocol.self, arguments: userId, name, imageUrlString),
                           imageLoader: r.resolve(ImageLoaderProtocol.self),
                           reposService: r.resolve(ReposServiceProtocol.self))
        }.inObjectScope(.container)
        
        container.register(RepoCellViewModelProtocol.self) { (_: Resolver, repo: RepoDetailsProtocol) in
            RepoCellViewModel(repoId: repo.repoId, repoName: repo.name)
        }.inObjectScope(.graph)
        
        container.register(DetailViewModelProtocol.self) { _ in DetailViewModel() }.inObjectScope(.graph)
        
        container.register(DetailCellViewModelProtocol.self) { (r: Resolver, name: String?, description: String?, imageUrl: String?) in
            return DetailCellViewModel(paramName: name ?? "", paramDescription: description ?? "", imageUrl: imageUrl, imageLoader: r.resolve(ImageLoaderProtocol.self))
        }.inObjectScope(.graph)
        
        container.register(CommitsViewModelProtocol.self) { (r: Resolver, owner: String, repo: String) in
            CommitsViewModel(owner: owner, repo: repo, commitFetcher: r.resolve(CommitFetcherProtocol.self, arguments: owner, repo))
        }.inObjectScope(.graph)
        
        container.register(CommitCellViewModelProtocol.self) { (_: Resolver, hash: String?, message: String?, name: String?, date: String?) in
            CommitCellViewModel(hash: hash, message: message, authorName: name, dateString: date)
        }.inObjectScope(.graph)
        
        //Services
        container.register(AuthorisationServiceProtocol.self) { r in
            let authorisationService = AuthorisationService(profileFetcher: r.resolve(ProfileFetcherProtocol.self)!)
            return authorisationService
        }.inObjectScope(.container)
        
        container.register(ProfileFetcherProtocol.self) { _ in ProfileFetcher() }.inObjectScope(.container)
        container.register(ImageLoaderProtocol.self) { _ in ImageLoader() }.inObjectScope(.container)
        container.register(ReposServiceProtocol.self) { _ in ReposService()}.inObjectScope(.container)
        container.register(CommitFetcherProtocol.self) { (_: Resolver, owner: String, repo: String) in CommitFetcher(owner: owner, repo: repo)}.inObjectScope(.container)
        
        return container
    }()
}
