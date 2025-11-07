//
//  ComicVineEndpoint.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 31/10/25.
//

import Foundation
import Networking
import Alamofire

/// Implementação de APIEndpoint para ComicVine API
struct ComicVineEndpoint: APIEndpoint, Sendable {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let headers: HTTPHeaders?
    let parameters: Parameters?
    let encoding: ParameterEncoding

    init(baseURL: String,
         path: String,
         method: HTTPMethod = .get,
         headers: HTTPHeaders? = nil,
         parameters: [String: String]? = nil,
         encoding: ParameterEncoding = URLEncoding.default) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding
    }
}
