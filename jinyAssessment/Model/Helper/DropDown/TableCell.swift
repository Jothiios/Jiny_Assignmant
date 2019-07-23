//
//  TableCell.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright (c) 2019 Widas. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ICustomCellDelegate{
    @objc  func tableView(_ sender:UIButton,selectedRow : Int)
    @objc  optional func tableView(_ sender:UIButton,indexPath : IndexPath )
     @objc optional func tableViewObject(_ sender:AnyObject,selectedRow : Int)
    @objc optional func tableView(_ sender:UIButton,selectedRow : Int,value : Bool)
}
