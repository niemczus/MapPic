//
//  ImageViewerVC.swift
//  MapPic
//
//  Created by Kamil Niemczyk on 02/03/2022.
//

import UIKit

class ImageViewerVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        navigationItem.backBarButtonItem?.tintColor = .cyan
    }
}

extension ImageViewerVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
