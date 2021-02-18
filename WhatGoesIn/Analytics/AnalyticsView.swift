//
//  Analytics.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 1/31/21.
//

import SwiftUI
import CoreData

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CommentIBS.entity(), sortDescriptors: []) var foods: FetchedResults<CommentIBS>
    
    var body: some View {
        VStack {
            List {
                ForEach(foods, id: \.id) { food in
                    HStack {
                        Text(String(food.comment ?? "?"))
                        Spacer()
                        Button("Edit") {
                            
                        }
                    }
                }
                .onDelete { indexSet in         /* allows deletion from list */
                    for index in indexSet {     /* might be able to abstract to viewmodel */
                        moc.delete(foods[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
   }
}

struct Analytics_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
