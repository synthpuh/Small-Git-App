//
//  ViewController.swift
//  Small Git App
//
//  Created by Ольга Шубина on 02.10.2022.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModelInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = container.resolve(LoginViewModelInterface.self)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        let authorizationVC = UIViewController()
        let webView = createWebView(in: authorizationVC)
        
        viewModel?.startAuthorisation(in: webView)
        
        createNavigationVC(for: authorizationVC)
    }
    
    //MARK: - UI
    
    private func createWebView(in vc: UIViewController) -> WKWebView {
        let webView = WKWebView()
        
        webView.navigationDelegate = self
        vc.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        ])
        return webView
    }
    
    private func createNavigationVC(for vc: UIViewController) {
        
        let navigationVC = UINavigationController(rootViewController: vc)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        vc.navigationItem.leftBarButtonItem = cancelButton
        
        self.present(navigationVC, animated: true)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }
}

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        viewModel?.requestCallback(navigationAction: navigationAction, completion: { [weak self] profile in
            guard let _ = profile?.userId else {
                print("Couldn't get user")
                return
            }
            DispatchQueue.main.async {
                self?.viewModel?.profile = self?.container.resolve(GithubProfileProtocol.self, arguments: profile?.userId, profile?.name, profile?.avatarUrlString)
                self?.dismiss(animated: true)
                self?.performSegue(withIdentifier: "LoginToRepos", sender: self)
                
            }
        })
        decisionHandler(.allow)
    }
}

//MARK: - Navigation

extension LoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LoginToRepos") {
            if let vc = segue.destination as? ReposViewController {
                vc.viewModel = container.resolve(ReposViewModelProtocol.self, arguments: self.viewModel?.profile?.userId, self.viewModel?.profile?.name, self.viewModel?.profile?.avatarUrlString)
            }
        }
    }
}
