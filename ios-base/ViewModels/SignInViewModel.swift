//
//  LoginViewModel.swift
//  swift-base
//
//  Created by Fernanda Toledo on 8/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import RxSwift

struct SignInViewModel {
  
  var email = Variable<String>("")
  var password = Variable<String>("")
  var signedIn = Variable<Bool>(false)
  var signedInError = Variable<String>("")
  
  var isValid: Observable<Bool> {
    return Observable.combineLatest(self.email.asObservable(), self.password.asObservable()) { return !$0.isEmpty && !$1.isEmpty }
  }
  
  func loginButtonDidTap(success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    //Login with "rootstrap@gmail.com"/"123456789" to success
    UserAPI.login(email.value != "" ? email.value : "rootstrap@gmail.com", password: password.value != "" ? password.value : "123456789", success: { (_) in
      self.signedIn.value = true
      success()
    }) { (error) in
      self.signedInError.value = error.localizedDescription
      failure(error)
    }
  }
}
