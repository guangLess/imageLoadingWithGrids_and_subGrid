//
//  DetailViewController.swift
//  ImageGallery
//
//  Created by Guang on 8/3/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    @IBOutlet weak var imageText: UILabel!
    @IBOutlet weak var detailImage: UIImageView!

    var imageURL: String = ""
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageText.text = text
        imageText.sizeToFit()
        
        if let url = URL(string: imageURL) {
            self.detailImage.af_setImage(withURL: url)
            self.detailImage.setNeedsDisplay()
        } else {
            debugPrint(imageURL, "imageURL not valid for af_setImage")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
