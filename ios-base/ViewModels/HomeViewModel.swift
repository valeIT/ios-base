//
//  LogoutViewModel.swift
//  swift-base
//
//  Created by Fernanda Toledo on 8/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import RxSwift

struct HomeViewModel {
  
  func logout(success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    UserAPI.logout({
      success()
    }) { (error) -> Void in
      failure(error)
    }
  }
  
  func profile(success: @escaping  () -> Void, failure: @escaping (_ error: Error) -> Void) {
    UserAPI.getMyProfile({ (json) in
      success()
    }, failure: { error in
      print(error)
      failure(error)
    })
  }
}
