//
//  CollectionContactHeader.swift
//  ContactBook
//
//  Created by alex surmava on 20.01.25.
//

import UIKit

class CollectionContactHeader: UICollectionReusableView {
    
    @IBOutlet private var header1: UILabel!
    @IBOutlet private var colapseButton1: UIButton!

    private var model: HeaderModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: HeaderModel) {
        self.model = model
        header1?.text = model.header
        if model.isExpanded {
            colapseButton1?.setTitle("Collapse", for: .normal)
        } else {
            colapseButton1?.setTitle("Expand", for: .normal)
        }
    }

    @IBAction func tappedButton() {
        model.onExpand()
    }
}
