//
// Utilities.swift
//
// Copyright (c) 2016 Damien (http://delba.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

internal let Application = UIApplication.sharedApplication()
internal let NotificationCenter = NSNotificationCenter.defaultCenter()

internal func == <T: Equatable>(tuple1: (T?, T?, T?), tuple2: (T?, T?, T?)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1) && (tuple1.2 == tuple2.2)
}

internal extension UIApplication {
    var rootViewController: UIViewController? {
        let root = delegate?.window??.rootViewController
        return root?.presentedViewController ?? root // Handle presenting an alert over a modal screen
    }
    
    func presentViewController(viewController: UIViewController?) {
        if let vc = viewController {
            rootViewController?.presentViewController(vc, animated: true, completion: nil)
        }
    }
}

internal extension NSNotificationCenter {
    func addObserver(observer: AnyObject, selector: Selector, name: String) {
        addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    func removeObserver(observer: AnyObject, name: String) {
        removeObserver(observer, name: name, object: nil)
    }
}

internal extension NSURL {
    var fragments: [String: String] {
        var result: [String: String] = [:]
        
        guard let fragment = self.fragment else { return result }
        
        for pair in fragment.componentsSeparatedByString("&") {
            let pair = pair.componentsSeparatedByString("=")
            if pair.count == 2 { result[pair[0]] = pair[1] }
        }
        
        return result
    }
    
    var queries: [String: String] {
        var result: [String: String] = [:]
        
        for item in queryItems {
            result[item.name] = item.value
        }
        
        return result
    }
    
    func queries(items: [String: String?]) -> NSURL {
        let items = items.flatMap { (key, value) -> (String, String)? in
            guard let value = value else { return nil }
            return (key, value)
        }
        
        let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        
        components?.queryItems = items.map { (name, value) in
            return NSURLQueryItem(name: name, value: value)
        }
        
        return components?.URL ?? self
    }
    
    private var queryItems: [NSURLQueryItem] {
        return NSURLComponents(URL: self, resolvingAgainstBaseURL: false)?.queryItems ?? []
    }
    
}

@available(iOS 9.0, *)
internal extension SFSafariViewController {
    convenience init(URL: NSURL, delegate: SFSafariViewControllerDelegate) {
        self.init(URL: URL)
        self.delegate = delegate
    }
}

internal struct Queue {
    static func main(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}