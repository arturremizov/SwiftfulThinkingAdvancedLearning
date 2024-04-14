//
//  PropertyWrapper2Bootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 14.04.24.
//

import SwiftUI

@propertyWrapper
struct Capitalized: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get { value }
        nonmutating set { value = newValue.capitalized }
    }

    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
}

@propertyWrapper
struct Uppercased: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get { value }
        nonmutating set { value = newValue.uppercased() }
    }

    init(wrappedValue: String) {
        self.value = wrappedValue.uppercased()
    }
}

@propertyWrapper
struct FileManagerCodableProperty<T: Codable>: DynamicProperty {
    @State private var value: T?
    private let key: String
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue, fileName: key) }
    }
    
    var projectedValue: Binding<T?> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    init(_ key: String) {
        self.key = key
        _value = State(initialValue: Self.load(fileName: key))
    }
    
    init(_ keyPath: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        self.key = FileManagerValues.shared[keyPath: keyPath].key
        _value = State(initialValue: Self.load(fileName: key))
    }
    
    static private func load(fileName: String) -> T? {
        do {
            let fileUrl = FileManager.textFileURLInDocumentDirectory(fileName: fileName)
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("ERROR READ: \(error)")
            return nil
        }
    }
    
    private func save(_ value: T?, fileName: String) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: FileManager.textFileURLInDocumentDirectory(fileName: fileName))
            self.value = value
//            print(NSHomeDirectory())
            print("SUCCESS SAVED")
        } catch {
            print("ERROR SAVING: \(error)")
        }
    }
}

struct User: Codable {
    let name: String
    let age: Int
    let isPremium: Bool
}

struct FileManagerKeyPath<T: Codable> {
    let key: String
    let type: T.Type
}

struct FileManagerValues {
    static let shared = FileManagerValues()
    private init() {}
    
    let userProfile = FileManagerKeyPath(key: "user_profile", type: User.self)
}

import Combine

@propertyWrapper
struct FileManagerCodableStreamableProperty<T: Codable>: DynamicProperty {
    @State private var value: T?
    private let key: String
    private let publisher: CurrentValueSubject<T?, Never>
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue, fileName: key) }
    }
    
    var projectedValue: CustomProjectedValue<T> {
        CustomProjectedValue(
            binding: Binding(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            ),
            publisher: publisher.eraseToAnyPublisher()
        )
    }
    
    init(_ key: String) {
        self.key = key
        let value = Self.load(fileName: key)
        self.publisher = CurrentValueSubject(value)
        _value = State(initialValue: value)
    }
    
    init(_ keyPath: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        self.key = FileManagerValues.shared[keyPath: keyPath].key
        let value = Self.load(fileName: key)
        self.publisher = CurrentValueSubject(value)
        _value = State(initialValue: value)
    }
    
    static private func load(fileName: String) -> T? {
        do {
            let fileUrl = FileManager.textFileURLInDocumentDirectory(fileName: fileName)
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("ERROR READ: \(error)")
            return nil
        }
    }
    
    private func save(_ value: T?, fileName: String) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: FileManager.textFileURLInDocumentDirectory(fileName: fileName))
            self.value = value
            publisher.send(value)
//            print(NSHomeDirectory())
            print("SUCCESS SAVED")
        } catch {
            print("ERROR SAVING: \(error)")
        }
    }
}

struct CustomProjectedValue<T: Codable> {
    let binding: Binding<T?>
    let publisher: AnyPublisher<T?, Never>
    var stream: AsyncPublisher<AnyPublisher<T?, Never>> {
        publisher.values
    }
}

struct PropertyWrapper2Bootcamp: View {
    
    @Uppercased private var title: String = "Hello, world!"
//    @FileManagerCodableProperty("user_profile") private var userProfile: User?
//    @FileManagerCodableProperty(\.userProfile) private var userProfile: User?
//    @FileManagerCodableProperty(\.userProfile) private var userProfile
    @FileManagerCodableStreamableProperty(\.userProfile) private var userProfile

    var body: some View {
        VStack(spacing: 40.0) {
            Button(title) {
                title = "new title"
            }
            SomeBindingView(userProfile: $userProfile.binding)
            Button(userProfile?.name ?? "No value") {
                userProfile = User(name: "Nick", age: 100, isPremium: true)
            }
        }
        .onReceive($userProfile.publisher, perform: { newValue in
            print("Recieved new value of: \(String(describing: newValue))")
        })
        .task {
            for await newValue in $userProfile.stream {
                print("Stream new value: \(String(describing: newValue))")
            }
        }
    }
}

struct SomeBindingView: View {
    @Binding var userProfile: User?
    var body: some View {
        Button(userProfile?.name ?? "No value") {
            userProfile = User(name: "Emily", age: 100, isPremium: true)
        }
    }
}

#Preview {
    PropertyWrapper2Bootcamp()
}
