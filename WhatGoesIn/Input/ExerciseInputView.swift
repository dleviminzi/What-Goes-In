//
//  SwiftUIView.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/14/21.
//

import SwiftUI
import CoreData

/* obviously not ideal to just hardcode like this */
/* TODO: make types dynamic and possible to add to */
let exerciseTypes = ["🧎‍♀️ Yoga", "🚶 Walking", "🤸‍♀️ Core", "🏃‍♀️ Running", "🚴‍♂️ Cycling", "🚣 Rowing", "💃 Dance", "🏋️‍♀️ Lifting"]
let exerciseLengths = ["15 min", "30 min", "45 min", "1 hour", "1.5 hours", "2+ hours"]
let exerciseLengthsMin = [15, 30, 45, 60, 90, 120]

struct ExerciseInputView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        GroupBox(
            label: HStack {
                Text("🚲 Track exercise")
                Spacer()
                NavigationLink(destination: ExerciseLogView()) {
                    Text("Entries")
                        .underline()
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<8) { i in
                        Menu {
                            ForEach(0..<6) { j in
                                Button {
                                    viewModel.inputNewExercise(name: exerciseTypes[i], length: Int16(exerciseLengthsMin[j]))
                                } label: {
                                    Text(exerciseLengths[j])
                                    Image(systemName: "arrow.up.and.down.circle")
                                }
                            }
                        } label: {
                            GroupBox() {
                                Text(exerciseTypes[i])
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ExerciseInputView {
    class ViewModel: ObservableObject {
        let persistenceController = PersistenceController.shared
        var moc: NSManagedObjectContext
        
        init() {
            /* managed object context for persistent storage */
            moc = persistenceController.container.viewContext
        }
        
        /* TOOD: look up that cool function argument thingy */
        func inputNewExercise(name: String, length: Int16) {
            let exercise = Exercise(context: moc)
            exercise.id = UUID()
            exercise.name = name
            exercise.date = Date()
            exercise.length = length
            
            do {
                try self.moc.save()
            } catch {
                print(error)
            }
        }
    }
}

//MARK: - exercise log view
struct ExerciseLogView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Exercise.entity(), sortDescriptors: []) var exers: FetchedResults<Exercise>
    
    var body: some View {
        VStack {
            List {
                ForEach(exers, id: \.id) { exercise in
                    HStack {
                        Text(exercise.name ?? "??")
                        Text(String(exercise.length) + " hours")
                        Spacer()
                        Button("Edit") {
                            
                        }
                    }
                }
                .onDelete { indexSet in         /* allows deletion from list */
                    for index in indexSet {     /* might be able to abstract to viewmodel */
                        moc.delete(exers[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Exercise entries")
   }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseInputView()
    }
}
