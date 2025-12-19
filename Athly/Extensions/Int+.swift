//
//  Int+.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return !isEven
    }
}
