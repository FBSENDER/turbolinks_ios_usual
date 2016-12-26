//左侧滑出的导航栏，需要自己配置title， group，点击事件
//storyboard 需配置的坑略多

import UIKit
import Router

class SideMenuViewController: UITableViewController {
    private lazy var router = Router()
    
    private var menuItems: [String]!
    private var menuItemPaths: [String]!
    private var menuItemIcons: [UIImage]!
    private var menuItemIconColors = [
        UIColor(red: 94 / 255.0, green: 151 / 255.0, blue: 246 / 255.0, alpha: 1),
        UIColor(red: 156 / 255.0, green: 204 / 255.0, blue: 101 / 255.0, alpha: 1),
        UIColor(red: 224 / 255.0, green: 96 / 255.0, blue: 85 / 255.0, alpha: 1),
        UIColor(red: 79 / 255.0, green: 195 / 255.0, blue: 247 / 255.0, alpha: 1),
        ]
    
    private let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    private let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = APP_TITLE
        
        tableView.backgroundColor = SIDEMENU_BG_COLOR
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.textLabel!.text = "Something"
                cell.imageView?.image = UIImage(named: "versions")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.tintColor = UIColor(red: 246 / 255.0, green: 191 / 255.0, blue: 50 / 255.0, alpha: 1)
            } else {
                cell.textLabel!.text = "~~"
                cell.imageView?.image = UIImage(named: "versions")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.tintColor = UIColor(red: 87 / 255.0, green: 187 / 255.0, blue: 138 / 255.0, alpha: 1)
            }
        case 1:
            if indexPath.row == 0 {
                cell.textLabel!.text = "Something Again"
                cell.imageView?.image = UIImage(named: "versions")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.tintColor = UIColor(red: 246 / 255.0, green: 191 / 255.0, blue: 50 / 255.0, alpha: 1)
            } else {
                cell.textLabel!.text = "~~"
                cell.imageView?.image = UIImage(named: "versions")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.tintColor = UIColor(red: 87 / 255.0, green: 187 / 255.0, blue: 138 / 255.0, alpha: 1)
            }
        default: break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                UIApplication.shared.openURL(NSURL(string: MyVariables.root_url)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")! as URL)
            }
        case 1:
            if indexPath.row == 0 {
                UIApplication.shared.openURL(NSURL(string: "http://another site")! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: "http://another apple store url")! as URL)
            }
        default: break
        }
        
    }
    
    func actionWithPath(path: String) {
        _ = router.match(NSURL(string: path)! as URL)
    }
    
}
