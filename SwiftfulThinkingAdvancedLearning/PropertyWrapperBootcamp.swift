//
//  PropertyWrapperBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 12.04.24.
//

import SwiftUI

extension FileManager {
    
    static func textFileURLInDocumentDirectory(fileName: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: fileName)
            .appendingPathExtension("txt")
    }
}

@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    @State private var title: String
    private let key: String
    
    var wrappedValue: String {
        get { title }
        nonmutating set { save(newValue, fileName: key) }
    }
    
    var projectedValue: Binding<String> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }
    }
    
    init(wrappedValue: String, _ key: String) {
        self.key = key
        title = Self.load(fileName: key) ?? wrappedValue
    }
    
    static private func load(fileName: String) -> String? {
        do {
            let title = try String(contentsOf: FileManager.textFileURLInDocumentDirectory(fileName: fileName), encoding: .utf8)
            print("SUCCESS READ")
            return title
        } catch {
            print("ERROR READ: \(error)")
            return nil
        }
    }
    
    private func save(_ value: String, fileName: String) {
        do {
            try value.write(to: FileManager.textFileURLInDocumentDirectory(fileName: fileName), atomically: false, encoding: .utf8)
            title = value
//            print(NSHomeDirectory())
            print("SUCCESS SAVED")
        } catch {
            print("ERROR SAVING: \(error)")
        }
    }
}

struct PropertyWrapperBootcamp: View {
    @FileManagerProperty("custom_title_1") private var title: String = "Starting text"
    @FileManagerProperty("custom_title_2") private var title2: String = "Starting text 2"
    @FileManagerProperty("custom_title_3") private var title3: String = "Starting text 3"

//    @AppStorage("title_key") private var title3: String = ""
//    var fileManagerProperty = FileManagerProperty()
    @State private var subtitle: String = "SUBTITLE"
    
    var body: some View {
        VStack(spacing: 40.0) {
            Group {
                Text(title)
                Text(title2)
                Text(title3)
            }
            .font(.largeTitle)

            PropertyWrapperChildView(subtitle: $title)
            
            Button("Click me 1") {
                title = "Title 1"
            }
            Button("Click me 2") {
                title = "Title 2"
                title2 = "Some Random Title"
            }
        }
    }
}

struct PropertyWrapperChildView: View {
    @Binding var subtitle: String
    var body: some View {
        Button(action: {
            subtitle = "ANOTHER TITLE!!!"
        }, label: {
            Text(subtitle)
                .font(.largeTitle)
        })
    }
}

#Preview {
    PropertyWrapperBootcamp()
}
