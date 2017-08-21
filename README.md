# HybridApp
Hybrid app without framework.
## How To
### Create a Bridge Class
Import the `JavaScriptCore`.

This is a framework that provides the ability to evaluate JavaScript in your native code.

See more in [documentation](https://developer.apple.com/documentation/javascriptcore).
```swift
import JavaScriptCore
```
Create a `JSExport` protocol.

Protocol to control the integration between Javascript and native codes.
```swift
public protocol CommunicationProtocol: JSExport {
    func exec(_ funcName: String, _ args: [Any]?)
}
```
Add the protocol delegate to your class.
```swift
open class Bridge: NSObject, CommunicationProtocol
```
Implement the `CommunicationProtocol` in your `Bridge` class.
```swift
public func exec(_ funcName: String, _ args: [Any]?) {
  // TODO: This is the function that the javascript will call.
}
```
### Implement the `WebViewController`
Like the Bridge, you will need to import the `JavaScriptCore`. 
```swift
import UIKit
import JavaScriptCore
```
Create your `WebViewController` class.
```swift
class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    //Init your bridge
    let bridge = Bridge()
    
    // MARK: API
    
    override func viewDidLoad() {
        configureWebView()
    }
    
    // MARK: OPEN FUNCTIONS

    open func executeJS(_ js: String) {
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    fileprivate func configureWebView() {
        webView.scrollView.bounces = false
        // Find your html file. In this example, the file name is "index.html"
        if let path = Bundle.main.path(forResource: "index", ofType: "html") {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20.0)
            webView.loadRequest(request)
        } else {
            // TODO: Throw your "file not found" error.
        }
    }
}
```
Create a `WebViewDelegate` and implement your functions.

I'd rather do the implementation separately.
```swift
extension WebViewController: UIWebViewDelegate {
    public func webViewDidStartLoad(_ webView: UIWebView) {
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        ...
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
    }
}
```
In the `func webViewDidStartLoad(_ webView: UIWebView)` configure your `Bridge`.

This code create `Bridge` reference in Javascript.
```swift
if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
   context.setObject(bridge, forKeyedSubscript: "Bridge" as (NSCopying & NSObjectProtocol)!)
}
```
### Call native on Javascript
Call `Bridge` in function.
```javascript
function someFunction() {
    Bridge.exec("FUNCTION_NAME", ["arg0", "arg1", ..., "argX"]);
}
```
## Example
Download or clone the example project.
## License
HybridApp is available under the MIT license. See the LICENSE file for more info.
