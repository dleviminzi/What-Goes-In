//
//  MeditationInputView.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/14/21.
//

import SwiftUI
import CoreData

let meditationLengths = [5, 10, 15, 30, 45, 60]

struct MeditationInputView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        GroupBox(
            label: HStack {
                Text("🧘‍♂️ Track meditation")
                Spacer()
                NavigationLink(destination: MeditationLogView()) {
                    Text("Entries")
                        .underline()
                        .font(.body)
                        .foregroundColor(.blue)
                }

            }
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<6) { i in
                        Button(action: {
                            viewModel.inputNewMeditation(length: Int16(meditationLengths[i]))
                        }, label: {
                            GroupBox() {
                                Text(String(meditationLengths[i]) + " minutes")
                            }
                        })
                    }
                }
            }
        }
    }
}

extension MeditationInputView {
    class ViewModel: ObservableObject {
        let persistenceController = PersistenceController.shared
        var moc: NSManagedObjectContext
        
        init() {
            /* managed object context for persistent storage */
            moc = persistenceController.container.viewContext
        }
        
        func inputNewMeditation(length: Int16) {
            let meditation = Meditation(context: moc)
            meditation.id = UUID()
            meditation.date = Date()
            meditation.length = length
            
            do {
                try self.moc.save()
            } catch {
                print(error)
            }
        }
    }
}


// MARK: - Meditation log view
struct MeditationLogView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Meditation.entity(), sortDescriptors: []) var meds: FetchedResults<Meditation>
    
    var body: some View {
        VStack {
            List {
                ForEach(meds, id: \.id) { med in
                    HStack {
                        Text(String(med.length) + " minutes")
                        Spacer()
                        Button("Edit") {
                            
                        }
                    }
                }
                .onDelete { indexSet in         /* allows deletion from list */
                    for index in indexSet {     /* might be able to abstract to viewmodel */
                        moc.delete(meds[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Meditation entries")
   }
}

struct MeditationInputView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationInputView()
    }
}
