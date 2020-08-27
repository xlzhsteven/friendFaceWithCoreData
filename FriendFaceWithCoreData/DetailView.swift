//
//  DetailView.swift
//  FriendFaceWithCoreData
//
//  Created by Xiaolong Zhang on 8/26/20.
//  Copyright © 2020 Xiaolong. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let person: Person
    @FetchRequest(entity: Person.entity(), sortDescriptors: []) var people: FetchedResults<Person>
    var body: some View {
        VStack (alignment: .leading) {
            Text("ID: \(person.id?.description ?? "")")
            Text("Address: \(person.address ?? "")")
            Text("Registered: \(dateString(from: person.registered))")
            Text("Tags: \(person.tags?.joined(separator: ", ") ?? "")")
            friendsView
        }.padding()
            .navigationBarTitle(Text("\(person.name ?? "")"), displayMode: .inline)
    }
    
    // find person from people using UUID
    private var constructFriendsList: [Person] {
        person.friends?.compactMap({getDetail(from: $0)}) ?? [Person]()
    }
    
    private func getDetail(from id: UUID) -> Person? {
        people.first(where: { $0.id == id })
    }
    
    private var friendsView: some View {
        List(0..<constructFriendsList.count, id: \.self) { row in
            NavigationLink(destination: DetailView(person: self.constructFriendsList[row])) {
                VStack(alignment: .leading) {
                    Text("\(self.constructFriendsList[row].name ?? "")")
                    Text("\(self.constructFriendsList[row].email ?? "")")
                }
            }
        }
    }
    
    private func dateString(from date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
