//
//  ImagesViewModel.swift
//  ImageGallery
//
//  Created by Guang on 8/5/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import Foundation

struct ViewModel {
    let all: [ImageElement]
    
    //collect each Album's first image
    func getAlbumSamplesFromAll() -> [ImageElement] {
        var albumSamples = [ImageElement]()
        var tempAlbumIds = Set<Int>()
        for each in all {
            if !tempAlbumIds.contains(each.albumId) {
                tempAlbumIds.insert(each.albumId)
                albumSamples.append(each)
            }
        }
        return albumSamples
    }
    
    //collect all the image elements from selected Album with bineray search
    func getImagesWith(albumId id: Int) -> [ImageElement] {
        var imagesFromAlbum = [ImageElement]()
        
        func getStartIndex() -> Int {
            var start = 0
            var end = all.count
            while start < end {
                let mid = start + Int((end - start)/2)
                if all[mid].albumId < id {
                    start = mid + 1
                } else {
                    end = mid
                }
            }
            return start
        }
        
        for each in all[getStartIndex()..<all.count] {
            if each.albumId == id {
                imagesFromAlbum.append(each)
            } else { break }
        }
        //print(imagesFromAlbum.count)
        return imagesFromAlbum
    }
}
