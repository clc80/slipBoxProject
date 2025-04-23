//
//  Persistence.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 4/11/25.
//

import CloudKit
import Combine
import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer
    var subscriptions = Set<AnyCancellable>()

    @Published var syncErrorMessage: String? = nil

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SlipBoxProject")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            #if DEBUG
            setupSchemaSync()
            #endif
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        checkSyncStatus()
    }

    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    // Check the users cloudKit status. Is it too full, something didn't sync right
    func checkSyncStatus() {
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink { notification in
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { return }

                if event.endDate == nil {
                    print("cloudKit event start")
                } else {
                    switch event.type {

                    case .setup:
                        print("cloudkit event - setup finished")
                    case .import:
                        print("cloudkit event - import finished")
                    case .export:
                        print("cloudkit event - export finished")
                    @unknown default:
                        print("cloudkit event - added anew event type")
                    }

                    if event.succeeded {
                        print("cloudkit event - succeded")
                    } else {
                        print("cloudkit event - not succeded")
                    }

//                    if let error = event.error as? CKError {
//                        print("cloudkit event - error: \(error.localizedDescription)")
//                        switch error.code {
//
////                        case .internalError:
////                            <#code#>
////                        case .partialFailure:
////                            <#code#>
////                        case .networkUnavailable:
////                            <#code#>
////                        case .networkFailure:
////                            <#code#>
////                        case .badContainer:
////                            <#code#>
////                        case .serviceUnavailable:
////                            <#code#>
////                        case .requestRateLimited:
////                            <#code#>
////                        case .missingEntitlement:
////                            <#code#>
////                        case .notAuthenticated:
////                            <#code#>
////                        case .permissionFailure:
////                            <#code#>
////                        case .unknownItem:
////                            <#code#>
////                        case .invalidArguments:
////                            <#code#>
////                        case .resultsTruncated:
////                            <#code#>
////                        case .serverRecordChanged:
////                            <#code#>
////                        case .serverRejectedRequest:
////                            <#code#>
////                        case .assetFileNotFound:
////                            <#code#>
////                        case .assetFileModified:
////                            <#code#>
////                        case .incompatibleVersion:
////                            <#code#>
////                        case .constraintViolation:
////                            <#code#>
////                        case .operationCancelled:
////                            <#code#>
////                        case .changeTokenExpired:
////                            <#code#>
////                        case .batchRequestFailed:
////                            <#code#>
////                        case .zoneBusy:
////                            <#code#>
////                        case .badDatabase:
////                            <#code#>
//                        case .quotaExceeded:
//                            self.syncErrorMessage = "quota exceeded, please free up some space on your iCloud"
////                        case .zoneNotFound:
////                            <#code#>
////                        case .limitExceeded:
////                            <#code#>
////                        case .userDeletedZone:
////                            <#code#>
////                        case .tooManyParticipants:
////                            <#code#>
////                        case .alreadyShared:
////                            <#code#>
////                        case .referenceViolation:
////                            <#code#>
////                        case .managedAccountRestricted:
////                            <#code#>
////                        case .participantMayNeedVerification:
////                            <#code#>
////                        case .serverResponseLost:
////                            <#code#>
////                        case .assetNotAvailable:
////                            <#code#>
////                        case .accountTemporarilyUnavailable:
////                            <#code#>
//                        @unknown default:
//                            print("finish up the errors!")
//                        }
//                    }
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - For debug only

    func setupSchemaSync () {
        let options = NSPersistentCloudKitContainerSchemaInitializationOptions()
        do {
            try container.initializeCloudKitSchema(options: options)
        } catch {
            print("Cloud kit sync - schema error: \(error)")
        }
    }

    // MARK: - SwiftUI preview helper
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            let newNote = Note(title: "note \(index)", context: viewContext)
            newNote.creationDate = Date() + TimeInterval(index)
        }
        return result
    }()

    static func createEmpty() -> PersistenceController {
        return PersistenceController(inMemory: true)
    }
}
