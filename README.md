
SPKit is just another Swift promises framework, it prevents the **_callback hell_** and supports sync and async code.  
It was made be to simple to use, read and maintain.  
It works with Xcode 8 and Swift 3  

### How to install SPKit  
You can install SPKit using carthage, or just drag the SPKit.swift file to your project.  

### How to use SPKit  

Start the flow by calling `SPKit.first`, move to the next block by calling `.resolve()` and finish the flow by calling `.complete()` or `.failure()`.

#### Example happy path
```swift
SPKit.first { (instance) in
	print("first code exec")
	instance.resolve()
}.then { (instance, result) in
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
        print("async code")
        instance.resolve()
    }
}.then { (instance, result) in
    print("sync code")
    instance.resolve("finished stage 2")
}.then { (instance, result) in  
	print("using result value: \(result as? String ?? "")")
    instance.complete()
}.onCompleted {(result) in
    print("COMPLETED")
}.onFailure {(error) in
    print("FAILURE")
}
```

#### Example error path
```swift
SPKit.first { (instance) in
	print("first code exec")
	instance.resolve()
}.then { (instance, result) in
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
        print("async code")
        instance.resolve()
    }
}.then { (instance, result) in
    print("sync code")
    instance.resolve("finished stage 2")
}.then { (instance, result) in
	print("using result value: \(result as? String ?? "")")
    instance.failure("ooppps")
}.onCompleted {(result) in
    print("COMPLETED")
}.onFailure {(error) in
    print("FAILURE")
}
```

##### Doubts or questions 
Please open an issue.
  
    
  

![Build](https://www.bitrise.io/app/93bb51c1de5dd228.svg?token=QzEV4V8xkznqBPDKyChWLA&branch=swift3)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
![Swift version](https://img.shields.io/badge/Swift%20-3.x-orange.svg) 
![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)  
