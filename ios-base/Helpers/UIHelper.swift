//
//  GeneralHelper.swift
//  ios-base
//
//  Created by Rootstrap on 2/19/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class UIHelper {
  // MARK: - Customize Views
  class func stylizePlaceholdersFor(_ targets: [UITextField], color: UIColor = UIColor.lightGray) {
    for textField in targets {
      textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: color])
    }
  }
  
  class func initSpinner(with frame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 80)) -> MBProgressHUD {
    let hud =  MBProgressHUD.init(frame: frame)
    hud.removeFromSuperViewOnHide = true
    hud.mode = .indeterminate
    hud.animationType = .zoom
    hud.isUserInteractionEnabled = false
    return hud
  }
}
