//
//  NoteTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 01/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

protocol NoteTableViewCellDelegate {
    func getTextViewBottomYCoordinate(view :UIView)
}

class NoteTableViewCell: UITableViewCell {
    
    var noteTableViewCellDelegate: NoteTableViewCellDelegate!

    @IBOutlet weak var noteTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        noteTextView.delegate = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.sizeToFit()
        
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissmisKeyboard))
                ], animated: false)
        
        noteTextView.inputAccessoryView = toolbar
    }
    
    @objc func dissmisKeyboard(){
        noteTextView.resignFirstResponder()
    }
}

extension NoteTableViewCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        noteTableViewCellDelegate.getTextViewBottomYCoordinate(view: textView)
        return true
    }
    
}
