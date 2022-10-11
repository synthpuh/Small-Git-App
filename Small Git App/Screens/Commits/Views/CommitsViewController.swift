//
//  CommitsTableViewController.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import UIKit

class CommitsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var viewModel: CommitsViewModelProtocol? {
        didSet {
            viewModel?.commitsChanged = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addActivityIndicator()
        
        viewModel?.getCommits()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: CommitTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: CommitTableViewCell.reuseId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBar()
    }
    
    func addActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.bounds = self.view.bounds
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func setNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44))
        let navItem = UINavigationItem(title: "\(viewModel?.owner ?? "")/\(viewModel?.repo ?? "")")
        
        navBar.setItems([navItem], animated: false)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        
        self.view.addSubview(navBar)
    }
}

    // MARK: - Table view data source
    
extension CommitsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.commits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.reuseId, for: indexPath) as? CommitTableViewCell else { return UITableViewCell() }
        let commit = viewModel?.commits[indexPath.row]
        cell.viewModel = container.resolve(CommitCellViewModelProtocol.self, arguments: commit?.hash, commit?.commit?.message, commit?.commit?.committer?.name, commit?.commit?.committer?.date)
        return cell
    }
    
}
