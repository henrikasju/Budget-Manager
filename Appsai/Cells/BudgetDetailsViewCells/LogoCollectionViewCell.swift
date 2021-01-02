//
//  LogoCollectionViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 06/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class LogoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var selectionIconImageView: UIImageView!
    
    func startup(selected: Bool, iconName: String){
        
//        print("-----------------------------------------------------------Cell frame: \(self.frame)")
        let originalFrame = CGRect(x: 0.0, y: 1.0, width: 85, height: 82.5)
//        print("Logo original frame: \(logoImageView.bounds)")
//        print("Selection bubble original frame: \(selectionIconImageView.bounds)")
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        let imagesRecieved = UIImage(systemName: iconName, withConfiguration: imageConfig)!
        logoImageView.image = imagesRecieved
//        logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
        logoImageView.frame = originalFrame
        
        //TODO: fix jumpiness
        
//        print("after logo frame: \(logoImageView.bounds)")
//        print("after bubble frame: \(selectionIconImageView.bounds)")
        selectionIconImageView.isHidden = !selected
        
        
        
        logoImageView.layer.shadowColor = UIColor.black.cgColor
        logoImageView.layer.shadowOpacity = 0.3
        logoImageView.layer.shadowOffset = .zero
        logoImageView.layer.shadowRadius = 2
    }
    
    func setCellSelection(selected: Bool){
        selectionIconImageView.isHidden = !selected
        
    }
    
    func reportStatus(){
        print("Logo is visible, Selection is " + (selectionIconImageView.isHidden ? "hidden" : "visible"))
    }
}
