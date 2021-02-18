//
//  PooPicker.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 1/31/21.
//

import SwiftUI

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding(19)
        .background(
            Color(.systemGray3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(radius: 2)
    }
}

struct PooInputView: View {
    var body: some View {
        GroupBox(
            label: HStack {
                Text("💩 Track bathrooom visits")
                Spacer()
                NavigationLink(destination: PooLogView()) {
                    Text("Entries")
                        .underline()
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        ) {
            HStack {
                NavigationLink(destination: PooPickerView()) {
                    GroupBox(
                        label:
                            HStack {
                                Text("👆  Poo picker")
                                Spacer()
                            }
                    ) {}
                }
            }
        }.padding(2)
    }
}


struct PooPickerView: View {
    let pooTypes = ["Hard and Lumpy 😖", "Lumpy Sausage 😣", "Sausage with Cracks 🥳", "Smooth, Soft Snake 🥳",
                    "Jagged Blobs 🤨", "Fluffy Blobs 🥴", "Just Liquid 😩", "Color"]
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid( columns: [.init(), .init()]) {
                    ForEach(0..<8) { i in
                        Button(action: {
                            /* need to create new poop entry -.- */
                            print("picked poo: \(pooTypes[i])")
                        }) {
                            GroupBox(
                                label: Label("", image: "poo\(i+1)")
                                    .scaleEffect(0.3, anchor: .center)
                                    .frame(width: 150, height: 80, alignment: .center)
                            ) {
                                Text(pooTypes[i])
                                    .frame(width: 150, height: 10, alignment: .center)
                                    .font(.caption)
                                    .foregroundColor(Color.red)
                            }
                        }
                    }.padding(1)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

// MARK: - Poo log view
struct PooLogView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Poop.entity(), sortDescriptors: []) var poos: FetchedResults<Poop>
    
    var body: some View {
        VStack {
            List {
                ForEach(poos, id: \.id) { poo in
                    HStack {
                        Text(poo.name ?? "Unknown")
                        Spacer()
                        Button("Edit") {
                            
                        }
                    }
                }
                .onDelete { indexSet in         /* allows deletion from list */
                    for index in indexSet {     /* might be able to abstract to viewmodel */
                        moc.delete(poos[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Poop Entries")

   }
}


struct PooPicker_Previews: PreviewProvider {
    static var previews: some View {
        PooPickerView()
    }
}
