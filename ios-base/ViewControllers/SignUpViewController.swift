//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import RxSwift

class SignUpViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordConfirmationField: UITextField!
  var viewModel = SignUpViewModel()
  var disposeBag = DisposeBag()
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    signUp.setRoundBorders(22)
    
    //These fields will be validated after textfielddidendediting
    emailField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.email.value = self.emailField.text!
        
      }).disposed(by: disposeBag)
    
    passwordField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.password.value = self.passwordField.text!
        
      }).disposed(by: disposeBag)
    
    //This field will be validated during textfieldtextdidchange
    passwordConfirmationField.rx.text.orEmpty
      .bind(to: viewModel.passwordConfirmation)
      .disposed(by: disposeBag)
    
    viewModel.isValid
      .bind(onNext: { [weak self] isValid in
        self?.signUp.isEnabled = isValid
      })
      .disposed(by: disposeBag)
    
    signUp.rx.tap
      .bind(onNext: { _ in
        UIApplication.showNetworkActivity()
        self.viewModel.signUpButtonDidTap(success: {
          UIApplication.hideNetworkActivity()
          UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        }) { (error) in
          UIApplication.hideNetworkActivity()
          self.showMessage(title: "Error", message: error.localizedDescription)
          print(error)
        }
      })
      .disposed(by: disposeBag)
    
//    viewModel.error.asObservable()
//      .bind(onNext: { [weak self] error in
//        self?.errorText.text = error
//      })
//      .disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    UIApplication.showNetworkActivity()
    let email = !emailField.text!.isEmpty ? emailField.text : "\(randomName())@gmail.com"
    let password = !passwordField.text!.isEmpty ? passwordField.text : "123456789"
    
    UserAPI.signup(email!, password: password!, avatar64: randomImage(), success: { (_) in
      UIApplication.hideNetworkActivity()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
    }, failure: { error in
      UIApplication.hideNetworkActivity()
      self.showMessage(title: "Error", message: error.localizedDescription)
      print(error)
    })
  }
  
  // Helper methods for test purposes
  func randomImage() -> UIImage {
    let square = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let rr = CGFloat(arc4random_uniform(255))
    let rg = CGFloat(arc4random_uniform(255))
    let rb = CGFloat(arc4random_uniform(255))
    square.backgroundColor = UIColor(red: rr/255, green: rg/255, blue: rb/255, alpha: 1.0)
    UIGraphicsBeginImageContext(square.frame.size)
    square.drawHierarchy(in: square.frame, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
  func randomName() -> String {
    return "user\(arc4random_uniform(10000))"
  }
}
