//
//  SPKit
//
//
//  MIT License
//
//  Copyright (c) 2016 Bruno Pires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Bruno Pires
//  email:      bruno@blastersystems.com
//  twitter:    @piresbruno
//  github:     piresbruno
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















