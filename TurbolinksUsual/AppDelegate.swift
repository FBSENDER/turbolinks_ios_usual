import UIKit
import WebKit
import Turbolinks
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    fileprivate lazy var rootViewController: RootViewController = {
        return RootViewController()
    }()
    
    fileprivate func initAppearance() {
        UINavigationBar.appearance().theme = true
        UISegmentedControl.appearance().theme = true
        UITabBar.appearance().theme = true
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: BLACK_COLOR], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: PRIMARY_COLOR], for: .selected)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initAppearance()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.view.backgroundColor = UIColor.white
        window?.rootViewController = navigationController
        UMAnalyticsConfig.sharedInstance().appKey = UM_APP_KEY
        UMAnalyticsConfig.sharedInstance().channelId = UM_CHANNEL_ID
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension UINavigationBar {
    var theme: Bool {
        get { return false }
        set {
            self.barStyle = .black
            self.isTranslucent = false
            self.tintColor = NAVBAR_TINT_COLOR
            self.barTintColor = NAVBAR_BG_COLOR
            
            self.backIndicatorImage = UIImage(named: "back")
            self.backIndicatorTransitionMaskImage = UIImage(named: "back")
        }
    }
    
    var bottomBorder: Bool {
        get { return false }
        set {
            // Border bottom line
            let navBorder = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.frame.size.height - 1), size: CGSize(width: self.frame.size.width, height: 1)))
            navBorder.backgroundColor = NAVBAR_BORDER_COLOR
            self.addSubview(navBorder)
            
            // Shadow
            self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            self.layer.shadowRadius = 1
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.05
        }
    }
}

extension UISegmentedControl {
    var theme: Bool {
        get { return false }
        set {
            self.tintColor = SEGMENT_BG_COLOR
        }
    }
}

extension UITabBar {
    var theme: Bool {
        get { return false }
        set {
            self.barStyle = .black
            self.isTranslucent = false
            
            self.tintColor = PRIMARY_COLOR
            self.barTintColor = TABBAR_BG_COLOR
            
            // Border top line
            let navBorder = UIView(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.frame.size.width, height: 1)))
            navBorder.backgroundColor = UIColor(red:0.93, green:0.92, blue:0.91, alpha:1.0)
            self.addSubview(navBorder)
        }
    }
}

