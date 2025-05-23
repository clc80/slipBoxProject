//
//  OptionalImageView.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 5/20/25.
//

import SwiftUI

struct OptionalImageView: View {
    let data: Data?

    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            EmptyView()
        }
    }
}

//#Preview {
//    OptionalImageView()
//}
