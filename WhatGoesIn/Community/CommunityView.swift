//
//  CommunityView.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/15/21.
//

import SwiftUI
import CoreData

struct CommunityView: View {
    @StateObject var viewModel = CommunityView.ViewModel()
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ScrollView {
            ForEach(0..<20) { i in
                Button {
                    let url = URL(string: String(viewModel.p?.posts[i].parent_url ?? "Error could not load url"))!
                    UIApplication.shared.open(url)
                } label: {
                    GroupBox(
                        label: HStack {
                            Text("r/" + String(viewModel.p?.posts[i].subreddit ?? "Error could not load subreddit"))
                        }
                    ) {
                        Text(viewModel.p?.posts[i].cleaned_body ?? "Error: could not load post")
                            .font(.caption)
                            .foregroundColor(Color(.systemBackground)).colorInvert()
                    }
                }
            }
        }
    }
}

extension CommunityView {
    class ViewModel: ObservableObject {
        let persistenceController = PersistenceController.shared
        var moc: NSManagedObjectContext
        
        var p: Posts?
        
        init() {
            /* managed object context for persistent storage */
            moc = persistenceController.container.viewContext
            downloadData()
        }
        
        
        func downloadData() {
            let decoder = JSONDecoder()
            let urlString = "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/test2.json"
                        
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    do {
                        try self.p = decoder.decode(Posts.self, from: data)
                    } catch {
                        print("rip")
                    }
                }
            }
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
