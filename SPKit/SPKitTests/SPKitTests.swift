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
        
        SPKit.first { (deferred) in
            print("init")
            deferred.resolve()
            
        }.then { (deferred) in
            print("stage 1")
            deferred.resolve()
        }.then { (deferred) in
            print("stage 2")
            deferred.resolve()
        }.then { (deferred) in
            print("stage 3")
            deferred.finish()
        }.completed {
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
        
        SPKit.first { (deferred) in
            
            print("init")
            deferred.resolve()
            
        }.then { (deferred) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                print("stage 1")
                deferred.resolve()
            }
        }.then { (deferred) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                print("stage 2")
                deferred.resolve()
            }
        }.then { (deferred) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                print("stage 3")
                deferred.finish()
            }
        }.completed {
            
            print("COMPLETED")
            XCTAssert(true)
            expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
    
    func testSyncError() {
        
        let expect = expectation(description: "test sync error")
        
        SPKit.first { (deferred) in
            print("init")
            deferred.resolve()
            
            }.then { (deferred) in
                print("stage 1")
                deferred.resolve()
            }.then { (deferred) in
                print("stage 2")
                deferred.resolve()
            }.then { (deferred) in
                print("stage 3")
                deferred.failure()
            }.failure {
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
        
        SPKit.first { (deferred) in
            
            print("init")
            deferred.resolve()
            
            }.then { (deferred) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 1")
                    deferred.resolve()
                }
            }.then { (deferred) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 2")
                    deferred.resolve()
                }
            }.then { (deferred) in
                
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
                    print("stage 3")
                    deferred.failure()
                }
            }.failure {
                print("FAILURE")
                XCTAssert(true)
                expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (error) -> Void in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
    
}
