//
//  PostNetworker.swift
//  post-kin
//
//  Created by isa nur fajar on 09/09/22.
//

import Foundation

enum PostNetworker {
    case getPost(page: Int)
    case getUser
}
extension PostNetworker: Endpoint {
    
    var base: String {
        return "https://3fc7b134-bc49-4118-a5bc-82472c90a981.mock.pstmn.io"
    }
    
    var path: String {
        switch self {
        case .getPost(let page):
            return "/posts/page\(page)"
        case .getUser:
            return "/users"
        }
    }
}
