//
//  CommitsViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation

protocol CommitsViewModelProtocol {
    var owner: String { get set }
    var repo: String { get set }
    
    var commitFetcher: CommitFetcherProtocol? { get set }
    
    var commits: [CommitResponseProtocol] { get set }
    var commitsChanged: ((CommitsViewModelProtocol) -> ())? { get set }
    
    func getCommits()
}

class CommitsViewModel: CommitsViewModelProtocol {

    var owner: String
    var repo: String
    var commitFetcher: CommitFetcherProtocol?
    
    var commits: [CommitResponseProtocol] = [] {
        didSet {
            self.commitsChanged?(self)
        }
    }
    
    var commitsChanged: ((CommitsViewModelProtocol) -> ())?
    
    init(owner: String, repo: String, commitFetcher: CommitFetcherProtocol?) {
        self.owner = owner
        self.repo = repo
        self.commitFetcher = commitFetcher
    }
    
    func getCommits() {
        commitFetcher?.repo = repo
        commitFetcher?.fetchCommits(completion: { commits in
            self.commits = commits
        })
    }
}
