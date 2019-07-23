//
//  DoneButton.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation
import UIKit

open class DoneButton: UIButton {
    var selectedItem : DropDownEntity!
}

open class TargetButton: UIButton {
    open var selectedDate : Date!
    open var selectedItem : DropDownEntity!
}

open class DropDownEntity {
    var id : Double?
    var stringID : String?
    var name : String?
    var icon : String?
    var countrystrings : String?
    var lefticon : String?
    var leftItemtext : String?
    var isDeleted : Bool = false
    var userInfo:Any?
}
