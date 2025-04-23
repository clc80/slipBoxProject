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
}
