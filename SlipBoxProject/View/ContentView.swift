//
//  ContentView.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 4/11/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(fetchRequest: Note.fetch(.all))
    private var notes: FetchedResults<Note>

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        Text(note.title)
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addNote) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addNote() {
        _ = Note(title: "new Note", context: viewContext)
    }

    private func deleteNotes(offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(viewContext.delete)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
