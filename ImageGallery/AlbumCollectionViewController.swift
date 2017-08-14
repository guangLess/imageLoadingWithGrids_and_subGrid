//
//  AlbumCollectionViewController.swift
//  ImageGallery
//
//  Created by Guang on 8/3/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var albumId: Int = 1
    var albumImages = [ImageElement]()
    static private let reuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = "Album " + String(albumId)
        self.collectionView?.collectionViewLayout = setUpFlowLayout(withNumPerRow: 4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewController.reuseIdentifier, for: indexPath)
        Alamofire.request(self.albumImages[indexPath.row].thumbnailUrl).responseImage { response in
            debugPrint(response)
            if let image = response.result.value {
                cell.backgroundView = UIImageView.init(image: image)
            }
        }
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailVC") as?
            DetailViewController {
            detailVC.imageURL = albumImages[indexPath.row].url
            detailVC.text = albumImages[indexPath.row].title
            present(detailVC, animated: true, completion: nil)
        } else {
            fatalError("Error of getting to detailVC class")
        }
    }
    
    func setUpFlowLayout(withNumPerRow: Int) -> UICollectionViewLayout {
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewController.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        let cellWidth = UIScreen.main.bounds.width/5 - 1
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets.zero
        
        return layout
    }
}
