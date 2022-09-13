//
//  PostClient.swift
//  post-kin
//
//  Created by isa nur fajar on 09/09/22.
//

import Foundation
import Combine

final class PostClient : PostApi {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getFeed(_ feedKind: PostNetworker) -> AnyPublisher<PostModel, Error> {
        execute(feedKind.request, decodingType: PostModel.self, retries: 2)
    }
    
    func getUser(_ userKind: PostNetworker) -> AnyPublisher<UserModel, Error>{
        execute(userKind.request, decodingType: UserModel.self, retries: 2)
    }
    
}
