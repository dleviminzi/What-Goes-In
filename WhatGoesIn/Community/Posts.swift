//
//  Posts.swift
//  WhatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/16/21.
//

import Foundation

struct Post: Codable {
    var parent_url: String
    var parent_upvotes: Int
    var comment_upvotes: Int
    var _date: String
    var subreddit: String
    var body: String
    var clean_body: String
    var pres_body: String
}

struct Posts: Codable {
    var posts: [Post]
}
