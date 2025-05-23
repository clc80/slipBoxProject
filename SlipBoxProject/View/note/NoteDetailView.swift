//
//  NoteDetailView.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 4/14/25.
//

import SwiftUI

struct NoteDetailView: View {
    @ObservedObject var note: Note

    var body: some View {
        VStack(spacing: 20) {
            Text("order \(Int(note.order))")

            TextField("title", text: $note.title)
                .textFieldStyle(.roundedBorder)
                .font(.title)

            Picker(selection: $note.status) {
                ForEach(Status.allCases) { status in
                    Text(status.rawValue)
                        .tag(status)
                }
            } label: {
                Text("Note's status")
            }
            .pickerStyle(.segmented)

            #if os(iOS)
            TextViewiOSWrapper(note: note)
            #else
            TextViewMacosWrapper(note: note )
            #endif

            OptionalImageView(data: note.img)
            NotePhoteSelectorButton(note: note)
        }
        .padding()
        .onDisappear { PersistenceController.shared.save() }
    }
}

#Preview {
    NoteDetailView(note: Note(title: "New note", context: PersistenceController.preview.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
