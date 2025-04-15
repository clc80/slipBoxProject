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
            Text("Note Detail View")
                .font(.title)

            HStack {
                Text("Title: ")
                Text(note.title)

            }

            Button("clear title") {
                note.title = ""
            }

            TextField("title", text: $note.title)
                .textFieldStyle(.roundedBorder)

            Button("Delete Note") {
                let context = note.managedObjectContext
                context?.delete(note)
            }
            .foregroundStyle(.pink)
        }
    }
}

#Preview {
    NoteDetailView(note: Note(title: "New note", context: PersistenceController.preview.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
