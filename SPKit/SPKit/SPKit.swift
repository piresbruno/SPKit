//
//  SPKit.swift
//  SPKit
//
//  Created by Bruno Pires on 30/11/16.
//  Copyright © 2016 BlasterSystems. All rights reserved.
//

import Foundation

public typealias callback = (SPKit, Any?)->()

public class SPKit{
    
    private var error:callback?
    private var success:callback?
    private var stack:[callback] = []
    
    static func first(_ callback:@escaping callback) -> SPKit{
        
        let instance = SPKit()
        callback(instance, nil)
        return instance
    }
    
    func then(_ callback:@escaping callback) -> SPKit{
        
        self.stack.append(callback)
        return self
    }
    
    func completed(_ callback:@escaping callback){
        self.success = callback
    }
    
    func failure(_ callback:@escaping callback){
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
    
    func finish(_ result:Any? = nil) {
        success?(self, result)
    }
    
    func failure(_ result:Any? = nil) {
        error?(self, result)
    }
}
















