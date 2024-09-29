//
//  NetworkManager.swift
//  DetectObject
//
//  Created by Mikhail Shendrikov on 26.09.2024.
//
import UIKit
enum NetworkError: Error {
    case issueURL (String)
    case requestEROR (String)
}

class NetworkManagerOld {
    
    func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edenai.run"
        components.path = "/v2/image/object_detection"
        return components.url
    }
    
    let boundary = "boundary"
    
    func getImageObject(imageData: Data) throws {
        guard let url = getURL() else { throw NetworkError.issueURL("\(#line) is ERROR") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = createRequestBody(imageData: imageData, boundary: boundary)
        request.httpBody = requestBody
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "multipart/form-data;boundary=\(boundary)",
            "content-length": "\(requestBody.count)",
            "authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiM2I3ZDIxNjYtYTVlOC00OTlkLTgxOTMtZGFlZWRiZjFmY2NlIiwidHlwZSI6ImFwaV90b2tlbiJ9.vFluADy1yC4BD_TJGJF1ttkXAuUDQOAbY_4d1X6fXGU"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            print(String(decoding: data!, as: UTF8.self))
        }.resume()
        
    }
    
    private func createRequestBody(imageData: Data, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var requestBody = Data()
//        providers
        requestBody.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"providers\"\(lineBreak + lineBreak)".data(using: .utf8)!)
        requestBody.append("amazon,google\(lineBreak)".data(using: .utf8)!)
//        file
        requestBody.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        requestBody.append("Content-Disposition:form-data; name=\"file\"; filename=\"image.jpg\"\(lineBreak)".data(using: .utf8)!)
        requestBody.append("Content-Type: image/jpg\(lineBreak + lineBreak)".data(using: .utf8)!)
        requestBody.append(imageData)
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return requestBody
    }
    
    }
