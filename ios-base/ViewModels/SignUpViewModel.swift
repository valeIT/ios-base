//
//  SignUpViewModel.swift
//  swift-base
//
//  Created by Fernanda Toledo on 8/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import RxSwift
import RxCocoa

struct SignUpViewModel {
  
  var email = Variable<String>("")
  var password = Variable<String>("")
  var passwordConfirmation = Variable<String>("")
  
  var error: Observable<String> {
    return Observable.combineLatest(email.asObservable(), password.asObservable(), passwordConfirmation.asObservable()) { (email, password, passwordConfirmation) in
      if !email.isEmpty && !email.isEmailFormatted() {
        return "Invalid email"
      }
      if !password.isEmpty && password.characters.count < 6 {
        return "Password too short"
      }
      if password != passwordConfirmation && !passwordConfirmation.isEmpty {
        return "Passwords don't match"
      }
      return ""
    }
  }
  
  var isValid: Observable<Bool> {
    return Observable.combineLatest(emailValid, passwordValid) { (emailValid, passwordValid) in
     return emailValid && passwordValid
    }
  }
  
  var passwordValid: Observable<Bool> {
    return Observable.combineLatest(self.password.asObservable(), self.passwordConfirmation.asObservable()) { (password, passwordConfirmation) in
      return password.characters.count >= 6 && password == passwordConfirmation
    }
  }
  
  var emailValid: Observable<Bool> {
    return email.asObservable().distinctUntilChanged().map {
      $0.isEmailFormatted()
    }
    
//    return Observable.combineLatest(self.email.asObservable(), self.emailConfirmation.asObservable()) { (email, emailConfirmation) in
//      return email.isEmailFormatted() && email == emailConfirmation
//    }
  }
  
  func signUpButtonDidTap(success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    UserAPI.signup(email.value, password: password.value, avatar64: randomImage(), success: { (_) in
      success()
    }) { (error) in
      failure(error)
    }
  }
  
  //Helper methods for test purposes
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
