//
//  HTTPLayer.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

protocol HTTPLayerProtocol {
    func request(at endpoint: EndpointProtocol, completion: @escaping (Result<Data>) -> Void)
    func upload(at endpoint: EndpointProtocol, urlSessionDelegate: URLSessionDelegate, completion: @escaping (Result<Data>) -> Void)

    func cancelRequests()
    func cancelAllTasksAndSessions()
    func cancelRequestAt(index: Int)
    func findIndexOf(task: URLSessionTask?) -> Int?
}

class HTTPLayer: HTTPLayerProtocol {

    var urlSession: URLSession
    var tasks: [URLSessionDataTask] = []
    var sessions: [URLSession]=[]

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func setRequestHeader(request: URLRequest) -> URLRequest {
        var newRequest=request
        newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorization=KeychainSwift().get(AppConst.KeyChain.Authorization) {
            newRequest.setValue(authorization, forHTTPHeaderField: AppConst.KeyChain.Authorization)
        }
        return newRequest
    }

    func createURLRequestFrom(endpoint: EndpointProtocol) throws -> URLRequest {

        guard let url = endpoint.url else {
            throw AppError.apiUrlProblem
        }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpBody = endpoint.httpBody
        request.httpMethod = endpoint.httpMethod
        request = setRequestHeader(request: request)

        return request
    }

    func createUploadRequestFrom(endpoint: EndpointProtocol) throws -> URLRequest {

        guard let url = endpoint.url else {
            throw AppError.apiUrlProblem
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request = setRequestHeader(request: request)

        return request
    }

    func request(at endpoint: EndpointProtocol, completion: @escaping (Result<Data>) -> Void) {

        let request: URLRequest!

        do {
            request = try createURLRequestFrom(endpoint: endpoint)
        } catch {
            completion(.failure(AppError.apiUrlProblem))
            return
        }

        let task = urlSession.dataTask(with: request) { [weak self](data, response, error) in

            self?.handleResponse(data, response, error, completion: completion)
        }

        self.tasks.append(task)
        task.resume()
    }

    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data>) -> Void) {

        if let error = error as NSError? {
            switch error.code {
            case URLError.notConnectedToInternet.rawValue:
                completion(.failure(AppError.noInternet))
            default:
                completion(.failure(AppError.unknown))
            }
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(AppError.serverError))
            return
        }

        if let data = data {
            completion(.success(data))
        } else {
            completion(.failure(AppError.unknown))
        }
    }

    func upload(at endpoint: EndpointProtocol, urlSessionDelegate: URLSessionDelegate, completion: @escaping (Result<Data>) -> Void) {

        let request: URLRequest!

        do {
            request = try createUploadRequestFrom(endpoint: endpoint)
        } catch {
            completion(.failure(AppError.apiUrlProblem))
            return
        }

        guard let dataToUpload = endpoint.httpBody else {
            return
        }

        let config=URLSessionConfiguration.default
        let session=URLSession(configuration: config, delegate: urlSessionDelegate, delegateQueue: OperationQueue.main)

        let task=session.uploadTask(with: request, from: dataToUpload) { [weak self] (data, response, error) in

            self?.handleResponse(data, response, error, completion: completion)
        }

        sessions.append(session)
        tasks.append(task)
        task.resume()
    }

    func cancelRequests() {
        self.urlSession.invalidateAndCancel()
        for task in self.tasks {
            task.cancel()
        }
        tasks = []
    }

    func cancelAllTasksAndSessions() {
        for session in sessions {
            session.invalidateAndCancel()
        }
        for task in tasks {
            task.cancel()
        }
        sessions = []
        tasks = []
    }

    func cancelRequestAt(index: Int) {
        if sessions.count > index {
            sessions[index].invalidateAndCancel()
            sessions.remove(at: index)
        }
        if tasks.count > index {
            tasks[index].cancel()
            tasks.remove(at: index)
        }
    }

    func findIndexOf(task: URLSessionTask?) -> Int? {
        guard let task = task else {
            return nil
        }

        for (index, task) in tasks.enumerated() {
            if task == task {
                return index
            }
        }

        return nil
    }
}
