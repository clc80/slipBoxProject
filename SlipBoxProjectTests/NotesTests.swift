//
//  NotesTests.swift
//  SlipBoxProjectTests
//
//  Created by Claudia Maciel on 4/22/25.
//

import XCTest
@testable import SlipBoxProject
import CoreData

final class NotesTests: XCTestCase {

    var controller: PersistenceController!

    var context: NSManagedObjectContext {
        controller.container.viewContext
    }

    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmpty()
    }

    override func tearDownWithError() throws {
        self.controller = nil
    }

    func test_Notes_Convenience_Init() {
        let noteTitle = "new"
        let note = Note(title: noteTitle, context: context)
        XCTAssertTrue(noteTitle == note.title, "Note should have the title given in the convenience initalizer")
    }

    func test_Notes_CreationDate() {
        let note = Note(context: context)

        let noteConvenient = Note(title: "new", context: context)

        XCTAssertNotNil(note.creationDate, "Notes should have creationDate property")
        XCTAssertNotNil(noteConvenient.creationDate)
    }

    func test_Notes_EditingTitle() {
        let note = Note(title: "old", context: context)
        note.title = "new"

        XCTAssertTrue(note.title == "new")
    }

    func test_FetchAllPredicate() {
        _ = Note(title: "default note", context: context)
        let fetch = Note.fetch(NSPredicate.all)
        let fetchedNotes = try? context.fetch(fetch)

        XCTAssertNotNil(fetchedNotes)
        XCTAssertTrue(fetchedNotes!.count > 0, "Predicate of all should fetch at least one object")
    }

    func test_FetchNonePredicate() {
        _ = Note(title: "default note", context: context)
        let fetch = Note.fetch(NSPredicate.none)
        let fetchedNotes = try? context.fetch(fetch)

        XCTAssertNotNil(fetchedNotes)
        XCTAssertTrue(fetchedNotes!.count == 0, "Predicate of none should no fetch any objects")
    }
}
