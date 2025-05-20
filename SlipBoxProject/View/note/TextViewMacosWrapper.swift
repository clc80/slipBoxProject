//
//  TextViewMacosWrapper.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 5/12/25.
//

import SwiftUI

struct TextViewMacosWrapper: NSViewRepresentable {
    let note: Note

    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()

        view.isRichText = true
        view.isEditable = true
        view.isSelectable = true
        view.allowsUndo = true

        view.usesInspectorBar = true
        view.usesFindPanel = true
        view.usesFindBar = true
        view.isGrammarCheckingEnabled = true

        view.isRulerVisible = true

        view.delegate = context.coordinator

        return view
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(note.formattedBodyText)
        context.coordinator.note = note
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, note: note)
    }

    class Coordinator: NSObject, NSTextViewDelegate {

        var note: Note
        let parent: TextViewMacosWrapper

        init(_ parent: TextViewMacosWrapper, note: Note) {
            self.note = note
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                note.formattedBodyText = textView.attributedString()
            }
        }
    }
}

#Preview {
    TextViewMacosWrapper(note: Note(title: "new", context: PersistenceController.preview.container.viewContext))
}
