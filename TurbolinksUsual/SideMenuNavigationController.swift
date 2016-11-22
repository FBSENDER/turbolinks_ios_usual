//copy from ruby-china @lmc

import SideMenu

class SideMenuNavigationController: UISideMenuNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgFrame = CGRect(origin: CGPoint(x: 0, y: -24), size: CGSize(width: navigationBar.frame.width, height: navigationBar.frame.height + 24))
        let bgView = UIView(frame: bgFrame)
        
        bgView.backgroundColor = SIDEMENU_NAVBAR_BG_COLOR
        navigationBar.addSubview(bgView)
    }
}
