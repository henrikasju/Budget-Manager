//
//  ColorCollectionView.swift
//  Appsai
//
//  Created by Henrikas J on 18/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class ColorCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        
        cell.colorImage.tintColor = .red
        
        return cell
    }
    
    
}
