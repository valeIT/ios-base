//
//  FirstViewModel.swift
//  ios-base
//
//  Created by Fernanda Toledo on 8/11/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import RxSwift
import FBSDKLoginKit

class FirstViewModel {
  
  //MARK: Facebook callback methods
  func facebookLogin(success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    //Optionally store params (facebook user data) locally.
    guard FBSDKAccessToken.current() != nil else {
      return
    }
    UserAPI.loginWithFacebook(token: FBSDKAccessToken.current().tokenString, success: {
      success()
    }) { (error) -> Void in
      failure(error)
    }
  }
}
