//
//  Array+.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

extension Array where Element: Identifiable {
    mutating func removeElement(_ element: Element) {
        if let index = self.firstIndex(where: { $0.id == element.id }) {
            self.remove(at: index)
        }
    }
}
