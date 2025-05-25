//
//  HeaderModel.swift
//  ContactBook
//
//  Created by alex surmava on 28.12.24.
//

final class HeaderModel {
    
    var header: String
    var isExpanded: Bool = true
    var onExpand: () -> Void
    
    init(
        title: String,
        isExpanded: Bool = true,
        onExpand: @escaping () -> Void
    ) {
        self.header = title
        self.isExpanded = isExpanded
        self.onExpand = onExpand
    }
    
}
