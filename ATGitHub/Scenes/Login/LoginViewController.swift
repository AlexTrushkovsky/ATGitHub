//
//  LoginViewController.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    private var oAuthService: OAuthServiceProtocol?
    
    @IBOutlet weak var signInWithGitHub: UIButton!
    @IBAction func signInWithGitHubAction(_ sender: UIButton) {
        self.oAuthService?.loadOAuth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oAuthService = OAuthService(viewController: self)
        
        signInWithGitHub.cornerRadius = signInWithGitHub.frame.height/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.oAuthService?.isAuthorized(completion: { bool in
            if bool {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
