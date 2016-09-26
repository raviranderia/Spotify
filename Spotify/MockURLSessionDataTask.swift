//
//  MockURLSessionDataTask.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/16/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
