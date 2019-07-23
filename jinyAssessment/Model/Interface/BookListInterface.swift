//
//  BookListInterface.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation
protocol BookListInterface {
    func getAllBooks(callback: @escaping ([BookDetailsEntity], NSError?) -> ())
}
