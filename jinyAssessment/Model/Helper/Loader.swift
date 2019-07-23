//
//  Loader.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


class Loader: NSObject {
    class func ShowLoaderInView(_ view:UIView,using hud:MBProgressHUD?, message:String = "Please Wait...",callback : @escaping (MBProgressHUD?) ->())  {
        DispatchQueue.main.async {
            let spinnerActivity : MBProgressHUD?
            if hud != nil{
                hud?.hide(animated: false)
            }
            spinnerActivity = MBProgressHUD.showAdded(to: view, animated: true)
            spinnerActivity?.bezelView.backgroundColor = UIColor .black
            spinnerActivity?.contentColor = UIColor.white
            spinnerActivity?.label.text = message
            spinnerActivity?.label.numberOfLines = 2
            callback(spinnerActivity)
        }
    }
    
    class func HideLoader(_ view:UIView){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
