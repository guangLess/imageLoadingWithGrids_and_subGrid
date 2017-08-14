//
//  Model.swift
//  ImageGallery
//
//  Created by Guang on 7/30/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import Foundation

enum AccessfileError: Error {
    case noName
    case inValidPathUrl
    case dataError
    case others(String)
}

enum ParseDataError: Error {
    case modelInitError
    case dataServiceError
}
