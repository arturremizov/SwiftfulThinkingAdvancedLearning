//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 3.01.23.
//

import SwiftUI
import CloudKit

struct FruitModel: Hashable {
    let name: String
    let record: CKRecord
}

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        Task {
            await saveItem(record: newFruit)
        }
    }
    
    private func saveItem(record: CKRecord) async {
        do {
            let record = try await CKContainer.default().publicCloudDatabase.save(record)
            print("Record: \(record)")
            await MainActor.run(body: {
                text = ""
                fetchItems()
            })
        } catch {
            print("Error: \(error)")
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
//        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = 2 // max 100
        
        var items: [FruitModel] = []
        
        queryOperation.recordMatchedBlock = { recordId, result in
            switch result {
            case .success(let record):
                guard let name = record["name"] as? String else { return }
                items.append(FruitModel(name: name, record: record))
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] result in
            print("RESULT: \(result)")
            DispatchQueue.main.async {
                self?.fruits = items
            }
        }
        
        addOperation(operation: queryOperation)
    }
    
    private func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateItem(fruit: FruitModel) {
        let record = fruit.record
        record["name"] = "NEW NAME!!!"
        Task {
           await saveItem(record: record)
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        
        Task {
            do {
                try await CKContainer.default().publicCloudDatabase.deleteRecord(withID: record.recordID)
                fruits.remove(at: index)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

struct CloudKitCrudBootcamp: View {
    
    @StateObject private var vm = CloudKitCrudBootcampViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                header
                textfield
                addButton
                
                List {
                    ForEach(vm.fruits, id: \.self) { fruit in
                        Text(fruit.name)
                            .onTapGesture {
                                vm.updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(.plain)
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct CloudKitCrudBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCrudBootcamp()
    }
}

extension CloudKitCrudBootcamp {
    
    private var header: some View {
        Text("Cloud CRUD ☁️☁️☁️")
            .font(.headline)
            .underline()
    }
    
    private var textfield: some View {
        TextField("Add something here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var addButton: some View {
        Button {
            vm.addButtonPressed()
        } label: {
            Text("Add")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}
