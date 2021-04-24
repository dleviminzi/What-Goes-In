//
//  PooPicker.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 1/31/21.
//

import SwiftUI
import CoreData

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding(10)
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
                    "Jagged Blobs 🤨", "Fluffy Blobs 🥴", "Just Liquid 😩"]
    let pooDesc = ["This is an indicator that you are severely constipated.", "This is an indicator that you are somewhat consitpated.", "Congrats that is a nice, healthy poop you're staring at.", "Everyone would be jealous of a poop this healthy.",
                   "This is not too bad, but eat more fibre!", "This is an indicator of inflammation.", "This is an indicator of inflamation and diarrhea."]
    let persistenceController = PersistenceController.shared
    var moc: NSManagedObjectContext

    init() {
        /* managed object context for persistent storage */
        moc = persistenceController.container.viewContext
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                ForEach(0..<7) { i in
                    Button(action: {
                        let poo = Poop(context: moc)
                        poo.id = UUID()
                        poo.name = pooTypes[i]
                        poo.type = Int16(i+1)
                        
                        do {
                            try self.moc.save()
                        } catch {
                            print(error)
                        }
                    }) {
                        GroupBox(
                        ) {
                            HStack {
                                VStack {
                                    Text(pooTypes[i])
                                        .font(.caption)
                                        .bold()
                                        .frame(width: 150, height: 10, alignment: .center)
                                        .foregroundColor(Color.red)
                                    Text(pooDesc[i])
                                        .font(.caption2)
                                        .foregroundColor(Color(.systemBackground)).colorInvert()
                                }
                                Spacer()
                                Label("", image: "\(i+1)")
                                    .scaleEffect(0.3, anchor: .center)
                                    .frame(width: 150, height: 80, alignment: .center)
                            }

                        }
                    }
                }.padding(1)
                
            }
        }
        .navigationBarTitle("Select the best fitting description", displayMode: .inline)
    }
}

// MARK: - Poo log view
struct PooLogView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Poop.entity(),
        sortDescriptors: []
    ) var poos: FetchedResults<Poop>
    
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
    func dateForm(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: date)
    }

}


struct PooPicker_Previews: PreviewProvider {
    static var previews: some View {
        PooPickerView()
    }
}
