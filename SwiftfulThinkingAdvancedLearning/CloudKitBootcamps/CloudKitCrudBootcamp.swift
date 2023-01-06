//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 3.01.23.
//

import SwiftUI
import CloudKit

enum CloudKitFruitModelNames: String {
    case name
}

struct FruitModel: Hashable, CloudKitableProtocol {
    let name: String
    let imageURL: URL?
    let count: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let name = record[CloudKitFruitModelNames.name.rawValue] as? String else { return nil }
        self.name = name
        
        let imageAsset = record["image"] as? CKAsset
        let imageURL = imageAsset?.fileURL
        self.imageURL = imageURL
        
        self.count = record["count"] as? Int ?? 0
        
        self.record = record
    }
    
    init?(name: String, imageURL: URL?, count: Int?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let imageURL {
            record["image"] = CKAsset(fileURL: imageURL)
        }
        if let count {
            record["count"] = count
        }
        self.init(record: record)
    }
    
    func update(newName: String) -> FruitModel? {
        let record = record
        record["name"] = newName
        return FruitModel(record: record)
    }
}

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    
    init() {
        Task {
            await fetchItems()
        }
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        Task {
            await addItem(name: text)
        }
    }
    
    private func addItem(name: String) async {
        guard
            let imagePath = createLocalUrl(forImageNamed: "therock.jpg"),
            let newFruit = FruitModel(name: name, imageURL: imagePath, count: 5)
        else { return }
        
        do {
            try await CloudKitUtility.save(item: newFruit)
            await MainActor.run {
                fruits.insert(newFruit, at: 0)
                text = ""
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func createLocalUrl(forImageNamed name: String) -> URL? {

        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path

        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
            else { return nil }
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }
        
        return url
    }
    
    func fetchItems() async {
        let predicate = NSPredicate(value: true)
//        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
        let sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let items: [FruitModel] = await CloudKitUtility.fetch(predicate: predicate, recordType: "Fruits", sortDescriptors: sortDescriptors)
        await MainActor.run {
            fruits = items
        }
    }
    
    func updateItem(fruit: FruitModel) async {
        guard let updatedFruit = fruit.update(newName: "NEW NAME!!!") else { return }
        do {
            try await CloudKitUtility.save(item: updatedFruit)
            await fetchItems()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
     
        Task {
            do {
                try await CloudKitUtility.delete(item: fruit)
                await MainActor.run {
                    let _ = fruits.remove(at: index)
                }
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
                        HStack {
                            Text(fruit.name)
                            if let imageUrl = fruit.imageURL {
                                AsyncImage(url: imageUrl, content: { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                }, placeholder: {
                                    ProgressView()
                                })
                            }
                        }
                        .onTapGesture {
                            Task {
                                await vm.updateItem(fruit: fruit)
                            }
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
