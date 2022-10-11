//
//  ReposViewController.swift
//  Small Git App
//
//  Created by Ольга Шубина on 05.10.2022.
//

import Foundation
import UIKit

class ReposViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ReposViewModelProtocol? {
        didSet {
            self.viewModel?.avatarChanged = { [weak self] viewModel in
                DispatchQueue.main.async {
                    self?.avatarImageView.image = viewModel.avatarImage
                }
            }
            self.viewModel?.reposFetched = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.setNavigationBar()
                }
            }
        }
    }
    var profileFetcher: ProfileFetcherProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAvatarImageView()
        setProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBar()
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: RepoTableViewCell.reuseId)
    }
    
    func setNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44))
        let navItem = UINavigationItem(title: "\(viewModel?.profile?.name ?? "")")
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: #selector(refresh))
        navItem.rightBarButtonItem = refreshButton
        
        navBar.setItems([navItem], animated: false)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        
        self.view.addSubview(navBar)
    }
    
    @objc func refresh() {
        viewModel = nil
        setProfile()
        setupUI()
    }
    
    func setProfile() {
        if viewModel == nil {
            profileFetcher = container.resolve(ProfileFetcherProtocol.self)
            guard let accessToken = Defaults.accessToken else { return }
            profileFetcher?.fetchUser(accessToken: accessToken, completion: { [weak self] profile in
                if let profile = profile {
                    DispatchQueue.main.async {
                        self?.viewModel = self?.container.resolve(ReposViewModelProtocol.self, arguments: profile.userId, profile.name, profile.avatarUrlString)
                        self?.setupUI()
                    }
                } else {
                    // in case github kicks you out
                    DispatchQueue.main.async {
                        Defaults.addDefaults(profile: nil)
                        self?.performSegue(withIdentifier: "ReposToLogin", sender: self)
                    }
                }
            })
        } else {
            setupUI()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReposToLogin") {
            if let vc = segue.destination as? LoginViewController {
                vc.viewModel = container.resolve(LoginViewModelInterface.self)
            }
        } else if (segue.identifier == "ReposToDetail") {
            if let vc = segue.destination as? DetailViewController {
                vc.viewModel = container.resolve(DetailViewModelProtocol.self)
                vc.viewModel?.repository = viewModel?.selectedRepo
            }
        }
    }
}

// MARK: - UI

extension ReposViewController {
    
    func setupUI() {
        viewModel?.getImage()
        viewModel?.loadRepos()
    }
    
    func setAvatarImageView() {
        avatarImageView.layer.cornerRadius = avatarImageView.layer.bounds.height / 2
    }
}

// MARK: - UITableViewDataSource methods

extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.repositories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.reuseId, for: indexPath) as? RepoTableViewCell,
              let repo = viewModel?.repositories[indexPath.row] else { return UITableViewCell() }
        
        cell.viewModel = container.resolve(RepoCellViewModelProtocol.self, argument: repo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

// MARK: - UITableViewDelegate methods

extension ReposViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelection(for: indexPath.row)
        performSegue(withIdentifier: "ReposToDetail", sender: self)
    }
}
