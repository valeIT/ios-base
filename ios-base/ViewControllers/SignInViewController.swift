//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var logIn: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  var viewModel = SignInViewModel()
  var disposeBag = DisposeBag()
  
  // MARK: - Lifecycle Event
  override func viewDidLoad() {
    super.viewDidLoad()
    logIn.setRoundBorders(22)
    
    emailField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    passwordField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    viewModel.isValid
      .bind(to: logIn.rx.isEnabled)
      .disposed(by: disposeBag)
    
    logIn.rx.tap
      .bind(onNext: { _ in
        UIApplication.showNetworkActivity()
        self.viewModel.loginButtonDidTap(success: {
          UIApplication.hideNetworkActivity()
          UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        }) { (error) in
          UIApplication.hideNetworkActivity()
          self.showMessage(title: "Error", message: error.localizedDescription)
          print(error)
        }
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel.signedIn.asObservable()
      .subscribe(onNext: { signedIn in
        if signedIn {
          UIApplication.hideNetworkActivity()
          UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        }
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel.signedInError.asObservable()
      .subscribe(onNext: { signedInError in
        if !signedInError.isEmpty {
          UIApplication.hideNetworkActivity()
          self.showMessage(title: "Error", message: signedInError)
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
}
