//
//  BudgetTabelHeaderSection.swift
//  Appsai
//
//  Created by Henrikas J on 15/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class BudgetTabelHeaderSection: UIView {

    static let SECTION_ITEM_NIB = "BudgetTabelHeaderSection"

    @IBOutlet var Content: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }

    
    convenience init(sectionLabel: String = "", sectionLabelColor: UIColor, backgroundColor: UIColor ) {
        self.init()
        self.sectionLabel.text = sectionLabel
        self.sectionLabel.textColor = sectionLabelColor
        self.Content.backgroundColor = backgroundColor
    }
    
//    func setData(sectionLabel: String = "", sectionLabelColor: UIColor, backgroundColor: UIColor )
//    {
//        self.sectionLabel.text = sectionLabel
//        self.sectionLabel.textColor = sectionLabelColor
//        self.Content.backgroundColor = backgroundColor
//    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(BudgetTabelHeaderSection.SECTION_ITEM_NIB, owner: self, options: nil)
        Content.frame = bounds
        Content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(Content)
    }
    
}
