//
//  Section.swift
//  ContactBook
//
//  Created by alex surmava on 28.12.24.
//

final class Section {

    var items: [Contact]
    var headerM: HeaderModel?
    
    init(header: HeaderModel?, items: [Contact]) {
        self.headerM = header
        self.items = items
    }
    
    var isExpanded: Bool {
        get { headerM?.isExpanded ?? true }
        set { headerM?.isExpanded = newValue }
    }
    
    var header: String { headerM?.header ?? "" }
    
    var contactCount: Int { isExpanded ? items.count : 0 }
    
    
}
