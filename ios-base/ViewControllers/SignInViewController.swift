//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var logIn: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  // MARK: - Lifecycle Event
  override func viewDidLoad() {
    super.viewDidLoad()
    logIn.setRoundBorders(22)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  @IBAction func tapOnSignInButton(_ sender: Any) {
    showSpinner()
    let email = !emailField.text!.isEmpty ? emailField.text : "rootstrap@gmail.com"
    let password = !passwordField.text!.isEmpty ? passwordField.text : "123456789"
    
    UserAPI.login(email!, password: password!, success: { 
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }, failure: { error in
      self.hideSpinner()
      self.showMessage(title: "Error", message: error.localizedDescription)
      print(error)
    })
  }
}
