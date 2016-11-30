//
//  SPKit.swift
//  SPKit
//
//  Created by Bruno Pires on 30/11/16.
//  Copyright © 2016 BlasterSystems. All rights reserved.
//

import Foundation

public typealias callbackWithParameter = ((_ deferred:SPKit)->())
public typealias callback = (()->())

public class SPKit{
    
    private var error:callback?
    private var success:callback?
    private var stack:[callbackWithParameter] = []
    
    static func first(_ callback:@escaping callbackWithParameter) -> SPKit{
        
        let instance = SPKit()
        callback(instance)
        return instance
    }
    
    func then(_ callback:@escaping callbackWithParameter) -> SPKit{
        
        self.stack.append(callback)
        return self
    }
    
    func completed(_ callback:@escaping callback){
        self.success = callback
    }
    
    func failure(_ callback:@escaping callback){
        self.error = callback
    }
    
    func resolve() {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(5)){
            
            if let result = self.stack.first{
                result(self)
                _ = self.stack.remove(at: 0)
            }
        }
    }
    
    func finish() {
        success?()
    }
    
    func failure() {
        error?()
    }
}

















