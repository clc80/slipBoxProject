//
//  NotePhoteSelectorButton.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 5/20/25.
//

import PhotosUI
import SwiftUI

struct NotePhoteSelectorButton: View {

    @ObservedObject var note: Note
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            if note.img == nil {
                Text("Import a photo")
            } else {
                Text("Change photo")
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    note.img = data
                }
            }
        }
    }
}

#Preview {
    NotePhoteSelectorButton(note: Note(title: "new", context: PersistenceController.preview.container.viewContext))
}
