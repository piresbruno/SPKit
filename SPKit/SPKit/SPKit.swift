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

//  Created by Bruno Pires 
//  email:      bruno@blastersystems.com
//  twitter:    @piresbruno
//  github:     piresbruno
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
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(5)){
            
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
















