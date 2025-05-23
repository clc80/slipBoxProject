//
//  macOS.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 5/20/25.
//

import SwiftUI

typealias UIImage = NSImage

extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
