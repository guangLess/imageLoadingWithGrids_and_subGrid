//
//  DataService.swift
//  ImageGallery
//
//  Created by Guang on 8/3/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import Foundation

typealias GalleryDictionary = [String: AnyObject]

struct ImageElement {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

extension ImageElement {
    init(dictionary: GalleryDictionary) throws {
        guard let albumId = dictionary["albumId"] as? Int,
            let id = dictionary["id"] as? Int,
            let title = dictionary["title"] as? String,
            let url = dictionary["url"] as? String,
            let thumbnailUrl = dictionary["thumbnailUrl"] as? String else {
                print("dictionary parse errors")
                throw ParseDataError.modelInitError
        }
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
