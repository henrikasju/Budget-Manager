//
//  ColorOptionTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 18/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class ColorOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var colorCollectionView: ColorCollectionView!

    
    let counter: Int = 10
    
    func setup() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
    
    func getColor(number: Int) -> UIColor {
        var color: UIColor
        
        switch number {
        case 1:
        color = .red
        case 2:
        color = .green
        case 3:
        color = .gray
        case 4:
        color = .orange
        case 5:
        color = .purple
        case 6:
        color = .darkGray
        case 7:
        color = .blue
        case 8:
            color = .cyan
        case 9:
            color = .lightGray
        case 10:
            color = .brown
        default:
            color = .magenta
        }
        
        return color
    }

}

extension ColorOptionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            let shadowSize: CGFloat = 5
            let shadowDistance: CGFloat = 0
            let contactRect = CGRect(x: -shadowSize, y: 45 - (shadowSize * 0.4) + shadowDistance, width: 45 + shadowSize * 2, height: shadowSize)
            cell.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
            cell.layer.shadowRadius = 2
            cell.layer.shadowOpacity = 0.4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return counter
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        
        cell.colorImage.tintColor = getColor(number: indexPath.row)
        return cell
    }
    
}
