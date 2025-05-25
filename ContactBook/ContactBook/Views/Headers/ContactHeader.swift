//
//  ContactHeader.swift
//  ContactBook
//
//  Created by alex surmava on 28.12.24.
//

import UIKit

class ContactHeader: UITableViewHeaderFooterView {
    
    @IBOutlet private var header: UILabel!
    @IBOutlet private var colapseButton: UIButton!
    
    private var model: HeaderModel!
    
    func configure(with model: HeaderModel) {
        self.model = model
        header?.text = model.header
        if model.isExpanded {
            colapseButton?.setTitle("Collapse", for: .normal)
        } else {
            colapseButton?.setTitle("Expand", for: .normal)
        }
    }
    
    @IBAction func TappedButton() {
        model.onExpand()
    }
}
