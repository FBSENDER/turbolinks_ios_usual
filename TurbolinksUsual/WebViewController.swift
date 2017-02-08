//定义路由及对应的页面 title
//定义顶部右侧按钮的行为 - 分享 举报等

import UIKit
import Turbolinks
import Router
import GoogleMobileAds

class WebViewController: VisitableViewController, GADBannerViewDelegate {
    fileprivate(set) var currentPath = ""
    fileprivate lazy var router = Router()
    fileprivate var pageTitle = ""
    
    lazy var bannerView: GADBannerView! = {
        let origin = CGPoint.init(x: (UIScreen.main.bounds.size.width - 320)/2, y: UIScreen.main.bounds.size.height - (64 + 50));
        let view = GADBannerView.init(adSize: kGADAdSizeBanner, origin: origin);
        view.delegate = self
        return view;
    }()
    
    fileprivate var adCloseButton = UIButton()
    
    convenience init(path: String) {
        self.init()
        self.visitableURL = urlWithPath(path)
        self.currentPath = path
        self.initRouter()
        self.addObserver()
    }
    
    fileprivate func urlWithPath(_ path: String) -> URL {
        let urlString = MyVariables.root_url + path
        
        return URL(string: urlString)!
    }
    
    //自定义 path 与 对应的页面 title，以及是否增加顶部右侧按钮
    fileprivate func initRouter() {
        self.navigationItem.rightBarButtonItem = nil
        for route in MyVariables.routes {
            router.bind(route["path"].stringValue){
                (req) in
                self.pageTitle = route["title"].stringValue
                if(route["add_share_button"].boolValue){
                    self.addPopupMenuButton()
                }
                if(route["show_google_ad"].boolValue){
                    self.loadGoogleAd()
                }
            }
        }
    }
    
    fileprivate func addPopupMenuButton() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "dropdown"), style: .plain, target: self, action: #selector(self.showTopicContextMenu))
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    fileprivate func addObserver() {
    }
    
    func reloadByLoginStatusChanged() {
        visitableURL = urlWithPath(currentPath)
        if isViewLoaded {
            reloadVisitable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TurbolinksSessionLib.sharedInstance.visit(self)
        router.match(URL(string: self.currentPath)!)
        navigationController?.topViewController?.title = pageTitle
    }
    
    override func visitableDidRender() {
        if let urlPath = self.visitableView?.webView?.url?.path, let url = URL(string: urlPath) {
            router.match(url)
        }
        // 覆盖 visitableDidRender，避免设置 title
        navigationController?.topViewController?.title = pageTitle
    }
    
    func addCollectButton(sheet: UIAlertController, article_id: String){
        let collectAction = UIAlertAction(title: "收藏", style: .default, handler: { action in
            var collect_ids = UserDefaults.standard.array(forKey: MyVariables.collect_key)
            if(collect_ids == nil){
                collect_ids = []
            }
            for id in collect_ids! {
                if((id as! String) == article_id){
                    return
                }
            }
            collect_ids?.append(article_id)
            UserDefaults.standard.set(collect_ids, forKey: MyVariables.collect_key)
            UserDefaults.standard.synchronize()
        })
        sheet.addAction(collectAction)
    }
    
    func addCancelCollectButton(sheet: UIAlertController){
        if(self.currentPath.contains("/app/article/")){
            let splitPaths = self.currentPath.components(separatedBy: "/")
            let article_id = splitPaths[3]
            
            var do_add = false
            
            var collect_ids = UserDefaults.standard.array(forKey: MyVariables.collect_key)
            if(collect_ids == nil){
                do_add = false
            }else{
                for id in collect_ids! {
                    if((id as! String) == article_id){
                        do_add = true
                        break
                    }
                }
            }
            if(!do_add){
                addCollectButton(sheet: sheet, article_id: article_id)
                return
            }
            
            let cancelCollectAction = UIAlertAction(title: "取消收藏", style: .default, handler: { action in
                var collect_ids = UserDefaults.standard.array(forKey: MyVariables.collect_key)
                if(collect_ids == nil){
                    collect_ids = []
                }
                var new_ids = [String]()
                for id in collect_ids! {
                    if((id as! String) != article_id){
                        new_ids.append(id as! String)
                    }
                }
                UserDefaults.standard.set(new_ids, forKey: MyVariables.collect_key)
                UserDefaults.standard.synchronize()
                
            })
            sheet.addAction(cancelCollectAction)
        }
        
    }

    
    func showTopicContextMenu() {
        guard let webView = self.visitableView.webView, let title = webView.title, let url = webView.url else {
            return
        }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "分享", style: .default, handler: { action in
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.query = nil
            components?.fragment = nil
            self.share(title, url: (components?.url)!)
        })
        sheet.addAction(shareAction)
        
        // 收藏button
        addCancelCollectButton(sheet: sheet)
        
        // ugc app 官方需要一个用户举报功能...
        //let jubaoAction = UIAlertAction(title: "举报", style: .default, handler: { action in
        //    TurbolinksSessionLib.sharedInstance.actionToPath("path for 举报", withAction: .Restore)
            
        //})
        //sheet.addAction(jubaoAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        
        sheet.popoverPresentationController?.sourceView = self.view
        sheet.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: 0, y: self.view.bounds.size.height / 2), size: CGSize(width: self.view.bounds.size.width,height: self.view.bounds.size.height / 2 - 10))
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    lazy var errorView: ErrorView = {
        let view = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)!.first as! ErrorView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
        return view
    }()
    
    func presentError(_ error: Error) {
        errorView.error = error
        view.addSubview(errorView)
        installErrorViewConstraints()
    }
    
    func installErrorViewConstraints() {
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": errorView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": errorView]))
    }
    
    func retry(_ sender: AnyObject) {
        errorView.removeFromSuperview()
        reloadVisitable()
    }
    
    fileprivate func share(_ textToShare: String, url: URL) {
        let objectsToShare = [textToShare, url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: 1, y: 1), size: CGSize(width: self.view.bounds.size.width,height: self.view.bounds.size.height / 2 - 10))
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    fileprivate func addAdCloseButton(){
        adCloseButton.frame = CGRect(x: self.view.center.x + 150,y: self.view.frame.size.height - 64,width: 15,height: 15)
        adCloseButton.setBackgroundImage(UIImage(named: "close"), for: UIControlState.normal)
        adCloseButton.addTarget(self, action: #selector(hideAd), for: .touchUpInside)
        self.view.addSubview(adCloseButton)
    }
    
    func hideAd(button: UIButton){
        self.adCloseButton.removeFromSuperview()
        self.bannerView.removeFromSuperview()
    }
    
    fileprivate func loadGoogleAd(){
        bannerView.adUnitID = AD_UNIT_ID
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true;
        view.addSubview(bannerView)
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.addAdCloseButton()
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    }

}
