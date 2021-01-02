//
//  TopBarItem.swift
//  Appsai
//
//  Created by Henrikas J on 10/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit
import Foundation

protocol TopBarItemDelegate {
    func navigationButtonPressed(buttonPressed: String)
}

@IBDesignable
class TopBarItem: UIView {
    static let CAROUSEL_ITEM_NIB = "TopBarItem"
    
    var itemDelegate: TopBarItemDelegate!

    @IBOutlet var Content: UIView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }

    
    convenience init(dateText: String, dayText: String, balanceAmount: Double, balanceText: String = "Spent", currencySymbol: String) {
        
        self.init()
        dateLabel.text = dateText
        dayLabel.text = dayText
        balanceLabel.text = balanceText
        balanceAmountLabel.text = String(format: "%.2f", balanceAmount) + currencySymbol
        setNavigationButtons(hideLeftButton: true, hideRightButton: true)
        enableNavigationButtons(enableLeft: false, enableRight: false)
    }
    
    func setNavigationButtons(hideLeftButton: Bool, hideRightButton: Bool){
        hideLeftButton ? ( leftButton.alpha = CGFloat(0) ) : ( leftButton.alpha = CGFloat(1) )
        hideRightButton ? ( rightButton.alpha = CGFloat(0) ) : ( rightButton.alpha = CGFloat(1) )
    }
    
    func enableNavigationButtons(enableLeft: Bool, enableRight: Bool)
    {
        leftButton.isUserInteractionEnabled = enableLeft
        rightButton.isUserInteractionEnabled = enableRight
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed("TopItem", owner: self, options: nil)
        Content.frame = bounds
        Content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(Content)
    }
    
    @IBAction func leftNavigationButtonAction(_ sender: Any) {
        itemDelegate.navigationButtonPressed(buttonPressed: "LEFT")
    }
    @IBAction func rightNavigationButtonAction(_ sender: Any) {
        itemDelegate.navigationButtonPressed(buttonPressed: "RIGHT")
    }
    
}
