//
//  ContentView.swift
//  FriendFaceWithCoreData
//
//  Created by Xiaolong Zhang on 8/25/20.
//  Copyright © 2020 Xiaolong. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Person.entity(), sortDescriptors: []) var people: FetchedResults<Person>
    
    var body: some View {
        NavigationView {
            List(0..<people.count, id: \.self) { row in
                NavigationLink(destination: DetailView(person: self.people[row])) {
                    VStack(alignment: .leading) {
                        Text("\(self.people[row].name ?? "")")
                        Text("\(self.people[row].email ?? "")")
                    }
                }
            }.navigationBarTitle("People")
        }
        .onAppear(perform: loadData)
    }
    
    private func loadData() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let decoded = try? decoder.decode([PersonCodable].self, from: data) {
                DispatchQueue.main.async {
                    print(decoded)
                    for node in decoded {
                        let person = Person(context: self.moc)
                        self.configure(person: person, personCodable: node)
                    }
                    self.saveContext()
                }
            }
        }.resume()
    }
    
    private func configure(person: Person, personCodable: PersonCodable) {
        person.name = personCodable.name
        person.id = personCodable.id
        person.about = personCodable.about
        person.address = personCodable.address
        person.age = personCodable.age ?? 0
        person.company = personCodable.company
        person.email = personCodable.email
        person.friends = personCodable.friends?.map({$0.id})
        person.isActive = personCodable.isActive ?? false
        person.registered = personCodable.registered
        person.tags = personCodable.tags
    }
    
    private func saveContext() {
        if self.moc.hasChanges {
            try? self.moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
