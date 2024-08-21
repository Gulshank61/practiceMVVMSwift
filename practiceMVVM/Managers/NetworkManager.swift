//
//  NetworkManager.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import Foundation
import RxSwift
import RxCocoa

enum NETWORK_METHOD: String {
    case POST
    case GET
    case PUT
    case PATCH
    case OPTIONS
    case DELETE
}

enum CONTENT_TYPE: String {
    case JSON = "application/json"
    case FORMDATA = "multipart/form-data"
    case XML = "application/xml"
    case HTML = "application/html"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let sessionConfiguration: URLSessionConfiguration
    
    private let session: URLSession
    
    private init(){
        sessionConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: self.sessionConfiguration)
    }
    
    func makeNetworkCall<T: Codable>(endpoint: String, method: NETWORK_METHOD, contentType: CONTENT_TYPE, payloadData: [String: Any], queryParams: [String:Any], model: T.Type) -> Observable<T>{
        
        let baseUrl = "https://randomuser.me"
        
        let fullUrl = baseUrl + endpoint
        
        return Observable.create { observer in
            
            guard var urlComponent = URLComponents(string: fullUrl) else {
                print("Invalid URL")
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return Disposables.create()
            }
            
            if !queryParams.isEmpty{
                urlComponent.queryItems = queryParams.map({ key, value in
                    URLQueryItem(name: key, value: "\(value)")
                })
            }
            
            guard let url = urlComponent.url else {
                print("Invalid URL")
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return Disposables.create()
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            let headers:[String:String] = [
                "Content-Type": contentType.rawValue,
                "Authorization":"Bearer "
            ]
            
            if !payloadData.isEmpty {
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: payloadData, options: .prettyPrinted)
                    
                    urlRequest.httpBody = jsonData
                }catch{
                    print("Encoding Payload Data Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            
            urlRequest.allHTTPHeaderFields = headers
            
            let task = self.session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                }
                
                if let data = data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(rawResponse)")
                    
                    do{
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(decodedData)
                        observer.onCompleted()
                    }catch{
                        print("Decoding Error: \(error.localizedDescription)")
                        observer.onError(error)
                    }
                    
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    
}
