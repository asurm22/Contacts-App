//
//  CollectionViewCell.swift
//  ContactBook
//
//  Created by alex surmava on 20.01.25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet private var name: UILabel!
    @IBOutlet private var number: UILabel!
    @IBOutlet private var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(contact: Contact){
        name.text = contact.name
        number.text = contact.phoneNumber
    }

}
