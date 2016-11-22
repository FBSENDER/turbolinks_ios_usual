// root view controller
// 需要设置标签页对应的webviewcontroller

import UIKit
import SideMenu

class RootViewController: UITabBarController {
    fileprivate let articleTag = 0
    fileprivate let productTag = 1
    fileprivate let saleTag = 2
    
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
        let tagController1 = TagViewController(path: "")
        tagController1.tabBarItem = UITabBarItem(title: "Title", image: UIImage(named: "favorites"), tag: productTag)
        let tagController2 = TagViewController(path: "")
        tagController1.tabBarItem = UITabBarItem(title: "Title", image: UIImage(named: "topic"), tag: productTag)
        
        viewControllers = [tagController1, tagController2]
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
