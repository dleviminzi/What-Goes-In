//
//  SleepInputView.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/14/21.
//

import SwiftUI
import CoreData

let sleepLengths = [5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12]

struct SleepInputView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        GroupBox(
            label: HStack {
                Text("🛌 Track sleep")
                Spacer()
                NavigationLink(destination: SleepLogView()) {
                    Text("Entries")
                        .underline()
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<15) { i in
                        Button(action: {
                            viewModel.inputNewSleep(length: sleepLengths[i])
                        }, label: {
                            GroupBox() {
                                Text(String(sleepLengths[i]) + " hours")
                            }
                        })
                    }
                }
            }
        }
    }
}

extension SleepInputView {
    class ViewModel: ObservableObject {
        let persistenceController = PersistenceController.shared
        var moc: NSManagedObjectContext
        
        init() {
            /* managed object context for persistent storage */
            moc = persistenceController.container.viewContext
        }
        
        func inputNewSleep(length: Double) {
            let sleep = Sleep(context: moc)
            sleep.id = UUID()
            sleep.date = Date()
            sleep.length = length
            
            do {
                try self.moc.save()
            } catch {
                print(error)
            }
        }
    }
}


// MARK: - Log view
struct SleepLogView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Sleep.entity(), sortDescriptors: []) var sleeps: FetchedResults<Sleep>
    
    var body: some View {
        VStack {
            List {
                ForEach(sleeps, id: \.id) { sleep in
                    HStack {
                        Text(String(sleep.length) + " hours")
                        Spacer()
                        Button("Edit") {
                            
                        }
                    }
                }
                .onDelete { indexSet in         /* allows deletion from list */
                    for index in indexSet {     /* might be able to abstract to viewmodel */
                        moc.delete(sleeps[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Sleep Entries")
   }
}

struct SleepInputView_Previews: PreviewProvider {
    static var previews: some View {
        SleepInputView()
    }
}
