//
//  CommunitySelectorView.swift
//  WhatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/24/21.
//

import SwiftUI

struct CommunitySelectorView: View {
    var body: some View {
        /* this is really just a garbage
         * please don't judge me */
        NavigationView {
            ScrollView {
                GroupBox(
                    label: HStack {
                        Text("View popular reddit posts in:")
                    }
                ) {
                    VStack {
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/Celiac/Celiac_top20_posts.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/Celiac")
                                        Spacer()
                                    }
                            ) {}
                        }
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/UlcerativeColitis/UlcerativeColitis_top20_posts.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/UlcerativeColitis")
                                        Spacer()
                                    }
                            ) {}
                        }
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/ibs/ibs_top20_posts.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/IBS")
                                        Spacer()
                                    }
                            ) {}
                        }
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/CrohnsDisease/CrohnsDisease_top20_posts.json")) {   /* broken right now */
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/ChronsDisease")
                                        Spacer()
                                    }
                            ) {}
                        }
                    }
                }.padding(2)
                GroupBox(
                    label: HStack {
                        Text("View popular reddit posts and comments in:")
                    }
                ) {
                    VStack {
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/Celiac/Celiac_top20_postscomments.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/Celiac")
                                        Spacer()
                                    }
                            ) {}
                        }
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/UlcerativeColitis/UlcerativeColitis_top20_postscomments.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/UlcerativeColitis")
                                        Spacer()
                                    }
                            ) {}
                        }
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/ibs/ibs_top20_postscomments.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/IBS")
                                        Spacer()
                                    }
                            ) {}
                        }
                        NavigationLink(destination: CommunityView(urlS: "https://whatgoesinalpha.s3.us-east-2.amazonaws.com/CrohnsDisease/CrohnsDisease_top20_postscomments.json")) {
                            GroupBox(
                                label:
                                    HStack {
                                        Text("r/ChronsDisease")
                                        Spacer()
                                    }
                            ) {}
                        }
                    }
                }.padding(2)
            }.navigationBarTitle("Find your community!")
        }
    }
}

struct CommunitySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CommunitySelectorView()
    }
}
