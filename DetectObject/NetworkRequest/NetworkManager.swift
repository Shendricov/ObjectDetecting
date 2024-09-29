//
//  CustomeNetManag.swift
//  DetectObject
//
//  Created by Mikhail Shendrikov on 29.09.2024.
//

import Foundation

enum URLError: Error{
    case issueURL(String)
}
                    
class NetworkManager {
    
    private let session: URLSession
    private let bounrary = "Boundary"
    
    init(session: URLSession) {
        self.session = session
    }
    
    private func getURL(scheme: String, host: String, path: String, params: [String:String]? = nil) throws -> URL {
        var componentsURL = URLComponents()
        componentsURL.scheme = scheme
        componentsURL.host = host
        componentsURL.path = path
        if let params = params {
            for param in params {
                componentsURL.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
            }
        }
        
        guard let resurlURL = componentsURL.url else { throw URLError.issueURL("URL not constructed file name \(#file), line \(#line)")}
        return resurlURL
    }
    
    func getRequest(imageData: Data) {

        var request: URLRequest?
        
        do {
            let url = try getURL(scheme: "https", host: "api.edenai.run", path: "/v2/image/object_detection")
            request = URLRequest(url: url)
        } catch {
            print(error)
        }
        
        guard var request = request else { return }
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(bounrary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiM2I3ZDIxNjYtYTVlOC00OTlkLTgxOTMtZGFlZWRiZjFmY2NlIiwidHlwZSI6ImFwaV90b2tlbiJ9.vFluADy1yC4BD_TJGJF1ttkXAuUDQOAbY_4d1X6fXGU", forHTTPHeaderField: "Authorization")
        request.httpBody = createRequestBody(imageData: imageData, boundary: bounrary)
        
        DispatchQueue.global().async {
            self.session.dataTask(with: request) { data, response, error in
                    guard error == nil, let data = data else {
                        print (error.debugDescription)
                        return
                    }
                    DispatchQueue.main.async {
                        print(String(decoding: data, as: UTF8.self))
                    }
            }.resume()
        }
        
        
    }
    
    private func createRequestBody(imageData: Data, boundary: String) -> Data {
        var body: Data = Data()
        let lineBreak = "\r\n"
        
        body.append(Data("--\(bounrary)\(lineBreak)".utf8))
        body.append("Content-Disposition: form-data; name=\"providers\"\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append("google,amazon\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\(lineBreak)".data(using: .utf8)!)
//        body.append(Data("Content-Type: \"content-type header\"\(lineBreak)".utf8))
        body.append("Content-Type: image/jpg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append(Data("\(lineBreak)--\(bounrary)--\(lineBreak)".utf8))

        return body
    }
    
}
