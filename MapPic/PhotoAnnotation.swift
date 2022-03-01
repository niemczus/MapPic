//
//  PhotoAnnotation.swift
//  MapPic
//
//  Created by Kamil Niemczyk on 01/03/2022.
//

import UIKit
import Cluster

class PhotoAnnotation: Annotation {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
        
        style = .image(image)
    }
}

extension PhotoAnnotation {
    
    var resizedImage: UIImage? {
        let size = CGSize(width: 40, height: 40)
        
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
}
