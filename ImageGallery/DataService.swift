//  DataModel.swift
//  ImageGallery
//
//  Created by Guang on 8/3/17.
//  Copyright © 2017 Guang. All rights reserved.
//  swiftlint:disable statement_position

import Foundation

typealias FileName = String
extension FileName {
    var fileExtension: String? {
        guard let period = characters.index(of: ".") else { return nil }
        let extensionRange = index(after: period)..<characters.endIndex
        return self[extensionRange]
    }
    var name: String? {
        guard let period = characters.index(of: ".") else { return nil }
        let nameRange = characters.startIndex...index(before:period)
        return self[nameRange]
    }
}

struct Resource {
    let fileUrl: URL
    init(with fileName: FileName) throws {
        if fileName.isEmpty { throw AccessfileError.noName }
        if let url = Bundle.main.url(forResource: fileName.name, withExtension: fileName.fileExtension) {
            fileUrl = url
        } else {throw AccessfileError.inValidPathUrl}
    }
}

final class LocalDataServices {
    func parseData(data: Data, completion: ([AnyObject]?) -> Void ) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
            let firstEl = json.flatMap {return $0}
            completion(firstEl)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    // Build ImageElement model
    func parseElement(amount _: Int, contents: [GalleryDictionary], completion: ([ImageElement]) -> Void) {
        do {
            var imageElements = [ImageElement]()
            for content in contents {
                try imageElements.append(ImageElement(dictionary: content))
            }
            completion(imageElements)
        } catch {
            print("problem with Model inits")
        }
    }
}

protocol CanLoadImageFile {}
extension CanLoadImageFile where Self: InitialViewController {

    func load(downloadedJsonFrom fileName: String, completion: @escaping (ViewModel) -> Void) throws {
        do {
            let resourceURL = try Resource(with: fileName).fileUrl
            print("resourceURL: ", resourceURL)
            let data = try Data(contentsOf: resourceURL, options: .uncached)
            
            LocalDataServices().parseData(data: data, completion: { results in
                (results as? [GalleryDictionary]).flatMap { results in
                    LocalDataServices().parseElement(amount: 1, contents: results, completion: { imageResult in
                    let viewModel = ViewModel.init(all: imageResult)
                    completion(viewModel)
                    })
                }
            })
        }
        catch AccessfileError.noName { print("filename is empty") }
        catch AccessfileError.inValidPathUrl { print("InValidPathUrl")}
        catch AccessfileError.dataError { print("Data Error")}
    }
}
