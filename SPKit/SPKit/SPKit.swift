//
//  SPKit.swift
//  SPKit
//
//  Created by Bruno Pires on 30/11/16.
//  Copyright © 2016 BlasterSystems. All rights reserved.
//

import Foundation

public typealias callback_init = (SPKit)->()
public typealias callback_regular = (Any?)->()
public typealias callback_complete = (SPKit, Any?)->()

public class SPKit{
    
    private var error:callback_regular?
    private var success:callback_regular?
    private var stack:[(SPKit, Any?)->()] = []
    
    static func first(_ callback:@escaping callback_init) -> SPKit{
        
        let instance = SPKit()
        callback(instance)
        return instance
    }
    
    func then(_ callback:@escaping callback_complete) -> SPKit{
        
        self.stack.append(callback)
        return self
    }
    
    func onCompleted(_ callback:@escaping callback_regular) -> SPKit{
        self.success = callback
        return self
    }
    
    func onFailure(_ callback:@escaping callback_regular){
        self.error = callback
    }
    
    func resolve(_ result:Any? = nil) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)){
            
            if let item = self.stack.first{
                item(self, result)
                _ = self.stack.remove(at: 0)
            }
        }
    }
    
    func complete(_ result:Any? = nil) {
        self.success?(result)
    }
    
    func failure(_ result:Any? = nil) {
        self.error?(result)
    }
}















