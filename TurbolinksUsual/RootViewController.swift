// root view controller
// 需要设置标签页对应的webviewcontroller

import UIKit
import SideMenu
import SwiftyJSON

class RootViewController: UITabBarController {
    
    fileprivate func setupSideMenu() {
        SideMenuManager.menuLeftNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sideMenuController") as? UISideMenuNavigationController
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .viewSlideOut
        SideMenuManager.menuAnimationBackgroundColor = UIColor.gray
        // SideMenu 不要手势，用处不大
        // SideMenuManager.menuAddPanGestureToPresent(toView: )
    }
    
    //在这里设置 标签页 对应的 webviewcontroller
    fileprivate func setupViewControllers() {
        var tagViews: [UIViewController] = []
        for tag_view in MyVariables.tag_views{
            let tagController = TagViewController(path: tag_view["path"].stringValue, headers: tag_view)
            tagController.tabBarItem = UITabBarItem(title: tag_view["title"].stringValue, image: UIImage(named: tag_view["image_name"].stringValue), tag: tag_view["tag"].intValue)
            tagViews.append(tagController)
        }
        viewControllers = tagViews
    }
    
    fileprivate func createSideMenuBarButton(_ image: UIImage?) -> UIBarButtonItem {
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(displaySideMenu))
    }
    
    func displaySideMenu() {
        let presentSideMenuController = {
            if let sideMenuController = SideMenuManager.menuLeftNavigationController {
                self.present(sideMenuController, animated: true, completion: nil)
            }
        }
        
        presentSideMenuController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = createSideMenuBarButton(UIImage(named: "menu"))
        delegate = self
        setupSideMenu()
        setupViewControllers()
        
        resetNavigationItem(viewControllers![selectedIndex])
    }
    
    fileprivate func resetNavigationItem(_ viewController: UIViewController) {
        navigationItem.titleView = viewController.navigationItem.titleView
        navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem
    }
    
}
extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        TurbolinksSessionLib.sharedInstance.visitableDidRequestRefresh((viewController as! WebViewController))
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.resetNavigationItem(viewController)
    }
}
