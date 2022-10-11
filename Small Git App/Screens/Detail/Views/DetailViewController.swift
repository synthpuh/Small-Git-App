//
//  DetailViewController.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DetailViewModelProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DetailTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: DetailTableViewCell.reuseId)
    }
}

//MARK: - UI and Navigation

extension DetailViewController {
    
    func setNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: 44))
        let navItem = UINavigationItem(title: viewModel?.repository?.name ?? "")
        let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(backAction))
        let commitsButton = UIBarButtonItem(title: "Commits", image: nil, target: nil, action: #selector(toCommits))
        
        navItem.leftBarButtonItem = backItem
        navItem.rightBarButtonItem = commitsButton
        navBar.setItems([navItem], animated: false)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        
        self.view.addSubview(navBar)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailToCommits") {
            if let vc = segue.destination as? CommitsViewController {
                vc.viewModel = container.resolve(CommitsViewModelProtocol.self, arguments: viewModel?.repository?.owner.login ?? "", viewModel?.repository?.name ?? "")
            }
        }
    }

    @objc func backAction() {
        self.dismiss(animated: true)
    }
    
    @objc func toCommits() {
        performSegue(withIdentifier: "DetailToCommits", sender: self)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.params.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseId, for: indexPath) as? DetailTableViewCell else { return UITableViewCell()}
        var avatarUrl: String? = nil
        if indexPath.row == 1 {
            avatarUrl = viewModel?.avatarImageString
        }
        cell.viewModel = container.resolve(DetailCellViewModelProtocol.self, arguments: viewModel?.params[indexPath.row].0, viewModel?.params[indexPath.row].1, avatarUrl)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    
}
