//
//  TableViewCell.swift
//  ContactBook
//
//  Created by alex surmava on 28.12.24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private var name: UILabel!
    @IBOutlet private var number: UILabel!

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
    }
    
    func configure(contact: Contact) {
        name.text = contact.name
        number.text = contact.phoneNumber
    }
    
}
