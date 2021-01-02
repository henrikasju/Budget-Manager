//
//  ColorCollectionViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 18/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var selectionIconImageView: UIImageView!
    
    func startup(selected: Bool, color: UIColor){
        selectionIconImageView.isHidden = !selected
        
        colorImage.layer.shadowColor = UIColor.black.cgColor
        colorImage.layer.shadowOpacity = 0.4
        colorImage.layer.shadowOffset = .zero
        colorImage.layer.shadowRadius = 2
        
        colorImage.tintColor = color
    }
}
