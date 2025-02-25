//
//  ResponseHandler.swift
//  UrbanGuide
//
//  Created by Dima Zhiltsov on 31.01.2025.
//

import UIKit

protocol ResponseHandler: Sendable {
    associatedtype Output
    func handle(data: Data, response: HTTPURLResponse) throws -> Output
}

struct JSONResponseHandler<T: Decodable>: ResponseHandler {    
    func handle(data: Data, response: HTTPURLResponse) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
}

struct StringResponseHandler: ResponseHandler {
    func handle(data: Data, response: HTTPURLResponse) throws -> String {
        guard let result = String(data: data, encoding: .utf8) else {
            throw NetworkError.decoding
        }
        return result
    }
}

struct ImageResponseHandler: ResponseHandler {
    func handle(data: Data, response: HTTPURLResponse) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkError.decoding
        }
        return image
    }
}
