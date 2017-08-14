//
//  ViewController.swift
//  ImageGallery
//
//  Created by Guang on 7/30/17.
//  Copyright © 2017 Guang. All rights reserved.
//
// swiftlint:disable line_length

import UIKit
import Alamofire
import AlamofireImage

let downloadedFile = "imageFile.json"

class InitialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CanLoadImageFile {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    static private let cellIdentifier = "collectionCell"
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var images: [ImageElement]?
    static private var allContents: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setUpFlowLayout(withNumPerRow: 4)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        // Add pull refresh control
        self.collectionView.refreshControl = refreshControl
        self.collectionView?.addSubview(self.refreshControl)
        
        //CanLoadImageFile protocol
            do {
                try load(downloadedJsonFrom: downloadedFile) { (models) in
                      InitialViewController.allContents = models
                      self.images = models.getAlbumSamplesFromAll()
                      self.activityIndicator.stopAnimating()
                }
            } catch let error as NSError {
                debugPrint("Protocol: CanLoadImageFile passes no value in MainVC\(error)")}
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: InitialViewController.cellIdentifier, for : indexPath)
        cell.backgroundColor = UIColor.blue
        if let images = self.images {
            Alamofire.request(images[indexPath.row].thumbnailUrl).responseImage { response in
                debugPrint(response)
                if let image = response.result.value {
                    cell.backgroundView = UIImageView.init(image: image)
                }
                debugPrint(response.result.error ?? " ")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let albumVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "albumVC") as? AlbumCollectionViewController {
            albumVC.albumId = indexPath.row + 1
            InitialViewController.allContents.flatMap {
                albumVC.albumImages = $0.getImagesWith(albumId: (indexPath.row + 1))
                }
            self.navigationController?.pushViewController(albumVC, animated: true)
        } else {
            print("Segue to AlbumCollectionViewController error")
        }
    }
    
    private func setUpFlowLayout(withNumPerRow num: Int) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = UIScreen.main.bounds.width/CGFloat(num) - 1
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return layout
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}
