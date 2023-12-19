//
//  Post.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 12.12.2023.
//

import Foundation

class Post {
    var documentId: String
    var likes: Int
    var isLiked: Bool

    init(documentId: String, likes: Int, isLiked: Bool) {
        self.documentId = documentId
        self.likes = likes
        self.isLiked = isLiked
    }
}
