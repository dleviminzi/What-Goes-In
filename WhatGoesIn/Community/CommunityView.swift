//
//  CommunityView.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/15/21.
//

import SwiftUI
import CoreData

struct CommunityView: View {
    var psts: Posts?    /* this is a struct that holds reddit posts for json decoding purposes */
    
    init(urlS: String) {
        downloadData(urlString: urlS)   /* accepts an S3 url to json reddit posts */
    }
    
    var body: some View {
        ScrollView {
            /* display each of the comments w/ hyperlink to reddit source */
            ForEach(0..<psts!.posts.count) { i in
                Button {
                    let url = URL(string: String(psts?.posts[i].parent_url ?? "Error could not load url"))!
                    UIApplication.shared.open(url)
                } label: {
                    GroupBox(
                        label: HStack {
                            Text("r/" + String(psts?.posts[i].subreddit ?? "Error could not load subreddit"))
                        }
                    ) {
                        Text(psts?.posts[i].clean_body ?? "Error: could not load post")
                            .font(.caption)
                            .foregroundColor(Color(.systemBackground)).colorInvert()
                    }
                }
            }
        }.navigationBarTitle("Trending")
    }
    
    mutating func downloadData(urlString: String) {
        let decoder = JSONDecoder()
                    
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                do {
                    try psts = decoder.decode(Posts.self, from: data)
                } catch {
                    print("Failed to decode reddit posts/comments json, nothing will display!")
                }
            }
        }
    }
}


struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/Celiac/Celiac_top20_posts.json")
    }
}
