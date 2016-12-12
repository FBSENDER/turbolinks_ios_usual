//
//  TurbolinksSessionLib.swift
//  ruby-china-ios
//
//  Created by kelei on 16/7/27.
//  Copyright © 2016年 ruby-china. All rights reserved.
//
//  ruby-china copy过来的代码 @lmc

import Turbolinks
import WebKit
import Router
import SafariServices

class TurbolinksSessionLib: NSObject {
    static let sharedInstance: TurbolinksSessionLib = {
        return TurbolinksSessionLib()
    }()
    
    func visit(_ visitable: Visitable) {
        session.visit(visitable)
        visitable.visitableView.webView?.uiDelegate = self
    }
    
    func visitableDidRequestRefresh(_ visitable: Visitable) {
        session.visitableDidRequestRefresh(visitable)
    }
    
    fileprivate lazy var router: Router = {
        let router = Router()
        return router
    }()
    
    fileprivate var application: UIApplication {
        return UIApplication.shared
    }
    
    fileprivate let kMessageHandlerName = "NativeApp"
    
    fileprivate lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: self.kMessageHandlerName)
        configuration.applicationNameForUserAgent = USER_AGENT
        configuration.processPool = WKProcessPool()
        return configuration
    }()
    
    fileprivate lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.delegate = self
        return session
    }()
    
    fileprivate var topNavigationController: UINavigationController? {
        if let topWebViewController = session.topmostVisitable as? WebViewController {
            return topWebViewController.navigationController
        }
        return nil
    }
    
    fileprivate func presentVisitableForSession(_ path: String, withAction action: Action = .Advance) {
        
        guard let topWebViewController = session.topmostVisitable as? WebViewController else {
            return
        }
        
        if (action == .Restore) {
            let urlString = ROOT_URL + path
            topWebViewController.visitableURL = URL(string: urlString)!
            session.reload()
        } else {
            let visitable = WebViewController(path: path)
            
            if action == .Advance {
                topWebViewController.navigationController?.pushViewController(visitable, animated: true)
            } else if action == .Replace {
                topWebViewController.navigationController?.popViewController(animated: false)
                topWebViewController.navigationController?.pushViewController(visitable, animated: false)
            } else {
                topWebViewController.navigationController?.pushViewController(visitable, animated: false)
            }
        }
    }
    
    func actionToPath(_ path: String, withAction action: Action) {
        let matched = router.match(URL(string: path)! as URL)
        var realAction = action
        
        if ((matched == nil)) {
            if (session.webView.url?.path == path) {
                // 如果要访问的地址是相同的，直接 Restore，而不是创建新的页面
                realAction = .Restore
            }
            presentVisitableForSession(path, withAction: realAction)
        }
    }
    
    func safariOpen(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url as URL)
        topNavigationController?.present(safariViewController, animated: true, completion: nil)
    }
}

extension TurbolinksSessionLib: SessionDelegate {
    
    public func session(_ session: Session, didProposeVisitToURL URL: Foundation.URL, withAction action: Action) {
        //let path = URL.path
        let path = URL.path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.replacingOccurrences(of: "%2F", with: "/")
        // 多次访问 product 类页面时，使用 restore 方式加载页面
        var realAction = action
        if(URL.absoluteString.range(of: "isFirst=0") != nil){
            realAction = .Restore
        }
        actionToPath(path!, withAction: realAction)
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        NSLog("ERROR: %@", error)
        guard let viewController = visitable as? WebViewController, let errorCode = ErrorCode(rawValue: error.code) else { return }
        
        switch errorCode {
        case .httpFailure:
            let statusCode = error.userInfo["statusCode"] as! Int
            switch statusCode {
            case 404:
                viewController.presentError(.HTTPNotFoundError)
            default:
                viewController.presentError(Error(HTTPStatusCode: statusCode))
            }
        case .networkFailure:
            viewController.presentError(.NetworkError)
        }
    }
    
    func sessionDidStartRequest(_ session: Session) {
        application.isNetworkActivityIndicatorVisible = true
    }
    
    func sessionDidFinishRequest(_ session: Session) {
        application.isNetworkActivityIndicatorVisible = false
    }
    
    func sessionDidLoadWebView(_ session: Session) {
        session.webView.navigationDelegate = self
    }
}

extension TurbolinksSessionLib: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> ()) {
        
        // PopupViewController
        /*if let popupWebViewController = session.topmostVisitable as? PopupWebViewController {
         popupWebViewController.webView(webView, decidePolicyForNavigationAction: navigationAction, decisionHandler: decisionHandler)
         return
         }*/
        
        // kelei 2016-10-08
        // 帖子中有 Youtube 视频时，会触发此方法。
        // po navigationAction 返回 <WKNavigationAction: 0x7fd0f9422eb0; navigationType = -1; syntheticClickType = 0; request = <NSMutableURLRequest: 0x61800001e700> { URL: https://www.youtube.com/embed/xMFs9DTympQ }; sourceFrame = (null); targetFrame = <WKFrameInfo: 0x7fd0f9401030; isMainFrame = NO; request = (null)>>
        // 所有这里判断一下 navigationType 值来修复进入帖子自动打开 Youtube 网页的问题
        if navigationAction.navigationType.rawValue < 0 {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url {
            if let host = url.host , host != URL(string: ROOT_URL)!.host! {
                // 外部网站, open in SafariView
                safariOpen(url)
            } else if let path = url.path ?? nil {
                actionToPath(path, withAction: .Advance)
            }
        }
        decisionHandler(.cancel)
    }
}



// MARK: - WKScriptMessageHandler

extension TurbolinksSessionLib: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name != kMessageHandlerName {
            return
        }
        guard let dic = message.body as? [String: AnyObject] else {
            return
        }        
        // window.webkit.messageHandlers.NativeApp.postMessage({func: "alert_success", message: "成功"})
        if let funcName = dic["func"] as? String, let message = dic["message"] as? String {
            if funcName == "alert_success" {
                RBHUD.success(message: message)
            } else {
                RBHUD.error(message: message)
            }
        }
    }
}

// MARK: - WKUIDelegate

extension TurbolinksSessionLib: WKUIDelegate {
    // 这个方法是在HTML中调用了JS的alert()方法时，就会回调此API。
    // 注意，使用了`WKWebView`后，在JS端调用alert()就不会在HTML
    // 中显示弹出窗口。因此，我们需要在此处手动弹出ios系统的alert。
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler()
        }))
        topNavigationController?.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "App Title", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        topNavigationController?.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(alert.textFields![0].text!)
        }))
        topNavigationController?.present(alert, animated: true, completion: nil)
    }
}
