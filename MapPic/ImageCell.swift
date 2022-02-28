//
//  ImageCell.swift
//  MapPic
//
//  Created by Kamil Niemczyk on 28/02/2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func populate(with image: UIImage) {
        self.imageView.image = image
    }
    
}
