//
//  API.swift
//  LoginActivity
//
//  Created by Guillem Budia Tirado on 8/7/15.
//  Copyright (c) 2015 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import SystemConfiguration
import SwiftyJSON

typealias onSuccesResponse = (JSON)-> Void
typealias onSuccesResponseFull = (JSON, URLResponse?)-> Void
typealias onSuccesResponseWithDict = (JSON, [String: AnyObject]?)-> Void
typealias onErrorResponseDict = (String, [ErrorDictKey: String]?)-> Void
typealias onErrorResponse = (String)->Void

enum ErrorDictKey {
    case description
    case code
}

enum NetworkRequestState {
    case initial
    case loading
    case error
    case success
}

class API: NSObject {
    
    static let shared = API()
    
    fileprivate let cookieStorage: HTTPCookieStorage!
    fileprivate let urlSession: URLSession!

    var rootURL: String
    var imageRootURL: String
    
    
    init(withURLSession session: URLSession = URLSession.shared, usingCookieStorage cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared){
        
        self.cookieStorage = cookieStorage
        self.urlSession = session
        
        self.rootURL = "http://localhost:8000/"
        self.imageRootURL = "http://localhost:8000"
       
        super.init()
    }
    
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
    private func getRequest(for path: String) -> URLRequest {
        var request = URLRequest(url: self.completeURL(path))

        request.setValue(self.rootURL, forHTTPHeaderField: "Referer")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        return request
    }
    
    func makeHTTPGetRequest(_ requestPath: RequestPath, onSuccess: @escaping onSuccesResponseFull, onError: @escaping onErrorResponseDict)->URLSessionDataTask? {
        
        
        let request = getRequest(for: requestPath.path)
        
        let task = urlSession.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            self.handleTaskResponse(requestPath: requestPath,
                                    onSuccess: onSuccess,
                                    onError: onError,
                                    _error: error,
                                    response: response,
                                    _data: data)
            
        })
        
        task.resume()
        return task
        
    }
    
    
    private func postRequest(for path: String, data: String) -> URLRequest {
        
        var request = URLRequest(url: completeURL(path))
        request.setValue(self.rootURL, forHTTPHeaderField: "Referer")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = data.data(using: String.Encoding.utf8)
        return request
    }
    
    func makeHTTPPostRequest(_ requestPath: RequestPath, data: String, onSuccess: @escaping onSuccesResponseFull, onError: @escaping onErrorResponseDict) -> URLSessionDataTask?{
        
        
        let params = data
        let request = postRequest(for: requestPath.path, data: params)
        
        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            self.handleTaskResponse(requestPath: requestPath,
                                    onSuccess: onSuccess,
                                    onError: onError,
                                    _error: error,
                                    response: response,
                                    _data: data)

        })
        task.resume()
        return task

    }
    
    private func deleteRequest(for path: String) -> URLRequest {
        
        var request = URLRequest(url: self.completeURL(path))
        request.setValue(self.rootURL, forHTTPHeaderField: "Referer")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "DELETE"
        return request
    }
    
    
    func makeHTTPDeleteRequestWithTask(_ requestPath: RequestPath, onSuccess: @escaping onSuccesResponseFull, onError: @escaping onErrorResponseDict)->URLSessionDataTask?{
        
        let request = deleteRequest(for: requestPath.path)
        
        let task = urlSession.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            self.handleTaskResponse(requestPath: requestPath,
                                    onSuccess: onSuccess,
                                    onError: onError,
                                    _error: error,
                                    response: response,
                                    _data: data)
            
        })
        task.resume()
        return task
    }
    
    
    private func handleTaskResponse(requestPath: RequestPath, onSuccess: @escaping onSuccesResponseFull, onError: @escaping onErrorResponseDict, _error: Error?, response: URLResponse?, _data: Data?) {
        
        if let error = _error {
            
            if (error as NSError).code == NSURLErrorCancelled {
                onError("cancelled", nil)
                return
            }
            
            Utils.printDebug(sender: self,
                             message: "error makeHTTPGetRequest, reason: \(error.localizedDescription)")
            
            onError(error.localizedDescription,
                    [ErrorDictKey.code : "request_failure"])
            return
            
        }
        
        if !(response?.isSuccessCode() ?? true) {
            onError("Error code \(response?.statusCode() ?? -1)",
                [ErrorDictKey.code : "request_failure"])
        }
        
        guard let data = _data, let json = JSON(uncheckedData: data) else {
            onError("No data",
                    [ErrorDictKey.code : "request_failure"])
            return
        }
        
        onSuccess(json, response)
        
    }
    
    func completeURL(_ url: String)-> URL {
        return URL(string: rootURL+url)!
    }
    
    func completeImageURL(_ img: String) -> String {
        let str = self.imageRootURL+img
        return str
    }
    
    
    @discardableResult
    func post(requestPath: RequestPath, dataDict: [String: AnyObject], onSucces: @escaping onSuccesResponseWithDict, onError: @escaping onErrorResponseDict)->URLSessionDataTask?{
        
        if let data = JSON(dataDict).rawString(){
            let task = self.makeHTTPPostRequest(requestPath, data: data, onSuccess: { (json, response) -> Void in
                
                if let error = json["error"].string {
                    Utils.printDebug(sender: self, message: "ERROR post: \(requestPath.path), error: \(error)")
                    onError(error,
                            [ErrorDictKey.description : error])
                } else {
                    onSucces(json, nil)
                }
                
            }, onError:  { (description, dict) -> Void in
                Utils.printDebug(sender: self, message: "ERROR post: \(requestPath.path), error: \(description)")
                onError(description, dict)
            })
            return task
        }
        return nil
    }
    
    
    @discardableResult
    func get(requestPath: RequestPath, onSuccess: @escaping onSuccesResponse, onError: @escaping onErrorResponseDict)->URLSessionDataTask?{
        
        let task = makeHTTPGetRequest(requestPath, onSuccess: { (json, response) in
            
            if let error = json["error"].string {
                Utils.printDebug(sender: self, message: "ERROR get: \(requestPath.path), error: \(error)")
                
                onError(error,
                        [ErrorDictKey.code : "\(error)"])
            } else {
                onSuccess(json)
            }
            
        }) { (description, dict) in
            Utils.printDebug(sender: self, message: "ERROR get: \(requestPath.path), error: \(description)")
            onError(description, dict)
        }
        
        return task
    }
    
    @discardableResult
    func delete(requestPath: RequestPath, onSuccess: @escaping onSuccesResponse, onError: @escaping onErrorResponseDict) -> URLSessionDataTask? {
        
        let task = self.makeHTTPDeleteRequestWithTask(requestPath, onSuccess: {(json, response) in
            
            if let error = json["error"].string {
                Utils.printDebug(sender: self, message: "ERROR get: \(requestPath.path), error: \(error)")
                
                onError(error,
                        [ErrorDictKey.code : "\(error)"])
            } else {
                onSuccess(json)
            }
            
        }, onError: {(description, dict)  in
            onError(description, dict)
        })
        
        return task
    }

    
    
    func printCookies(){
        Utils.printDebug(sender: self, message: "print cookies")
        guard let cookies:[HTTPCookie] = self.cookieStorage.cookies else {return}
        for cookie:HTTPCookie in cookies as [HTTPCookie] {
                print("\(cookie.name)=\(cookie.value)")
            Utils.printDebug(sender: self, message: "cookie: \(cookie.name)=\(cookie.value)")
        }
    }
    
    func getCookie(_ name: String)->HTTPCookie?{
        if let cookies = self.cookieStorage.cookies{
            for cookie  in cookies {
                if cookie.name == name {
                    return cookie
                }
            }
            print("Cookie NOT Found!")
            return nil
        }
        return nil
    }
    
    @discardableResult
    func deleteCookie(_ name: String) -> Bool {
        Utils.printDebug(sender: self, message: "deleting cookie: \(name)")
        if let cookie: HTTPCookie = self.getCookie(name){
            self.cookieStorage.deleteCookie(cookie)
            return true
        } else {return false}
    
    }
    
}


    

