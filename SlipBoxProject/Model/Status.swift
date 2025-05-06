//
//  Status.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 5/6/25.
//

import Foundation

enum Status: String, Identifiable, CaseIterable {
    case draft = "Draft"
    case review = "Review"
    case archived = "Archived"

    var id: String {
        return self.rawValue
    }
}
