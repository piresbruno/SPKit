//
//  SPKitTests.swift
//  SPKitTests
//
//  Created by Bruno Pires on 30/11/16.
//  Copyright © 2016 BlasterSystems. All rights reserved.
//

import XCTest
@testable import SPKit

class SPKitTests: XCTestCase {
    
    func testSync() {
        
        let expect = expectation(description: "test sync")
        
        _ = SPKit.first { (instance) in
            print("init")
            instance.resolve()
            
        }.then { (instance, result) in
            print("stage 1")
            instance.resolve()
        }.then { (instance, result) in
            print("stage 2")
            instance.resolve()
        }.then { (instance, result) in
            print("stage 3")
            instance.complete()
        }.onCompleted { (result) in
            print("COMPLETED")
            
            XCTAssert(true)
            expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    func testAsync() {
        
        let expect = expectation(description: "test async")
        
        _ = SPKit.first { (instance) in
            
            print("init")
            instance.resolve()
            
        }.then { (instance, result) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                print("stage 1")
                instance.resolve()
            }
        }.then { (instance, result) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                print("stage 2")
                instance.resolve()
            }
        }.then { (instance, result) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                print("stage 3")
                instance.complete()
            }
        }.onCompleted {(result) in
            
            print("COMPLETED")
            XCTAssert(true)
            expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 20) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    
    func testSyncError() {
        
        let expect = expectation(description: "test sync error")
        
        _ = SPKit.first { (instance) in
            print("init")
            instance.resolve()
            
            }.then { (instance, result) in
                print("stage 1")
                instance.resolve()
            }.then { (instance, result) in
                print("stage 2")
                instance.resolve()
            }.then { (instance, result) in
                print("stage 3")
                instance.failure()
            }.onFailure {(error) in
                print("FAILURE")
                XCTAssert(true)
                expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    func testAsyncError() {
        
        let expect = expectation(description: "test async error")
        
        SPKit.first { (instance) in
            
            print("init")
            instance.resolve()
            
            }.then { (instance, result) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 1")
                    instance.resolve()
                }
            }.then { (instance, result) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 2")
                    instance.resolve()
                }
            }.then { (instance, result) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 3")
                    instance.failure()
                }
            }.onFailure { (error) in
                print("FAILURE")
                XCTAssert(true)
                expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    func testSendingResultFailure() {
        
        let expect = expectation(description: "test sync send error result")
        
        SPKit.first { (instance) in
            print("init")
            instance.resolve()
            
            }.then { (instance, result) in
                print("stage 1")
                instance.resolve()
            }.then { (instance, result) in
                print("stage 2")
                instance.resolve()
            }.then { (instance, result) in
                print("stage 3")
                instance.failure("an error occurred")
                
            }.onFailure {(error) in
                print("FAILURE")
                
                XCTAssertNotNil(error)
                expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    func testSendingResultCompletion () {
        
        let expect = expectation(description: "test sync completion send result")
        
        _ = SPKit.first { (instance) in
            
            print("init")
            instance.resolve()
            
            }.then { (instance, result) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 1")
                    instance.resolve()
                }
            }.then { (instance, result) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 2")
                    instance.resolve()
                }
            }.then { (instance, result) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 3")
                    instance.complete("completed")
                }
            }.onCompleted {(result) in
                
                print("COMPLETED")
                XCTAssertNotNil(result)
                expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
}
