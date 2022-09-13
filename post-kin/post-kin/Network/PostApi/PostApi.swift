//
//  PostApi.swift
//  post-kin
//
//  Created by isa nur fajar on 09/09/22.
//

import Foundation
import Combine
import netfox

protocol PostApi {
    var session : URLSession { get }
    func execute<T>(_ request: URLRequest, decodingType: T.Type, queue: DispatchQueue, retries: Int) -> AnyPublisher<T, Error> where T: Decodable
}

extension PostApi {
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    queue: DispatchQueue = .main,
                    retries: Int = 0) -> AnyPublisher<T, Error> where T: Decodable {
        NFX.sharedInstance().start()
        return session.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.responseUnsuccessful
                }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: queue)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}
