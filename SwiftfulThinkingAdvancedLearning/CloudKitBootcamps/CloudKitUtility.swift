//
//  CloudKitUtility.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 5.01.23.
//

import CloudKit

protocol CloudKitableProtocol {
    var record: CKRecord { get }
    init?(record: CKRecord)
}

class CloudKitUtility {
    
    enum CouldKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermine
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudCoundNotFetchUserRecordID
        case iCloudCouldNotDiscoverUser
    }
}

// MARK: - User Functions
extension CloudKitUtility {
    
    static func getiCloudStatus() async throws -> Bool {
        let status = try await CKContainer.default().accountStatus()
        switch status {
        case .available:
            return true
        case .noAccount:
            throw CouldKitError.iCloudAccountNotFound
        case .couldNotDetermine:
            throw CouldKitError.iCloudAccountNotDetermine
        case .restricted:
            throw CouldKitError.iCloudAccountRestricted
        default:
            throw CouldKitError.iCloudAccountUnknown
        }
    }
    
    static func requestApplicationPermission() async -> Bool {
        let status = try? await CKContainer.default().requestApplicationPermission([.userDiscoverability])
        return status == .granted ? true : false
    }
    
    static private func fetchUserRecordID() async throws -> CKRecord.ID {
        try await withCheckedThrowingContinuation { continuation in
            CKContainer.default().fetchUserRecordID { id, error in
                if let id {
                    continuation.resume(returning: id)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: CouldKitError.iCloudCoundNotFetchUserRecordID)
                }
            }
        }
    }
    
    static private func discoverUserIdentity(id: CKRecord.ID) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            CKContainer.default().discoverUserIdentity(withUserRecordID: id) { identity, error in
                
                if let name = identity?.nameComponents?.givenName {
                    continuation.resume(returning: name)
                } else {
                    continuation.resume(throwing: CouldKitError.iCloudCouldNotDiscoverUser)
                }
            }
        }
    }
    
    static func discoverUserIdentity() async throws -> String {
        let recordID = try await fetchUserRecordID()
        let name = try await discoverUserIdentity(id: recordID)
        return name
    }
}

// MARK: - CRUD Functions
extension CloudKitUtility {
    
    static func fetch<T: CloudKitableProtocol>(predicate: NSPredicate,
                      recordType: CKRecord.RecordType,
                      sortDescriptors: [NSSortDescriptor]? = nil,
                      resultsLimit: Int? = nil) async -> [T] {
        
        await withCheckedContinuation { continuation in
            // Create operation
            let queryOperation = createQueryOperation(predicate: predicate,
                                                      recordType: recordType,
                                                      sortDescriptors: sortDescriptors,
                                                      resultsLimit: resultsLimit)
            
            // Get items in query
            var items: [T] = []
            addRecordMatchedBlock(queryOperation: queryOperation) { item in
                items.append(item)
            }
            
            // Query completion
            addQueryResultBlock(queryOperation: queryOperation) { finished in
                continuation.resume(returning: items)
            }
                    
            // Execute operation
            add(operation: queryOperation)
        }
    }
    
    static private func createQueryOperation(predicate: NSPredicate,
                                             recordType: CKRecord.RecordType,
                                             sortDescriptors: [NSSortDescriptor]? = nil,
                                             resultsLimit: Int? = nil) -> CKQueryOperation {

        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        let queryOperation = CKQueryOperation(query: query)
        if let resultsLimit {
            queryOperation.resultsLimit = resultsLimit // max 100
        }
        return queryOperation
    }
    
    static private func addRecordMatchedBlock<T: CloudKitableProtocol>(queryOperation: CKQueryOperation, completion: @escaping (_ item: T) -> Void) {
        queryOperation.recordMatchedBlock = { recordId, result in
            switch result {
            case .success(let record):
                guard let item = T(record: record) else { return }
                completion(item)
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
    }
    
    static private func addQueryResultBlock(queryOperation: CKQueryOperation, completion: @escaping (_ finished: Bool) -> Void) {
        queryOperation.queryResultBlock = { result in
            completion(true)
        }
    }
    
    static private func add(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    static func save<T: CloudKitableProtocol>(item: T) async throws {
        let record = item.record
        try await saveItem(record: record)
    }
    
    @discardableResult
    static private func saveItem(record: CKRecord) async throws -> CKRecord {
        try await CKContainer.default().publicCloudDatabase.save(record)
    }
    
    static func delete<T: CloudKitableProtocol>(item: T) async throws {
        try await delete(record: item.record)
    }
    
    static private func delete(record: CKRecord) async throws {
        try await CKContainer.default().publicCloudDatabase.deleteRecord(withID: record.recordID)
    }
}
