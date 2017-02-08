//左侧滑出的导航栏，需要自己配置title， group，点击事件
//storyboard 需配置的坑略多

import UIKit
import Router

class SideMenuViewController: UITableViewController {
    fileprivate lazy var router = Router()
    
    fileprivate var menuItems: [String]!
    fileprivate var menuItemPaths: [String]!
    fileprivate var menuItemIcons: [UIImage]!
    fileprivate var menuItemIconColors = [
        UIColor(red: 94 / 255.0, green: 151 / 255.0, blue: 246 / 255.0, alpha: 1),
        UIColor(red: 156 / 255.0, green: 204 / 255.0, blue: 101 / 255.0, alpha: 1),
        UIColor(red: 224 / 255.0, green: 96 / 255.0, blue: 85 / 255.0, alpha: 1),
        UIColor(red: 79 / 255.0, green: 195 / 255.0, blue: 247 / 255.0, alpha: 1),
        ]
    
    fileprivate let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    fileprivate let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = APP_TITLE
        
        tableView.backgroundColor = SIDEMENU_BG_COLOR
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
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
            }
            else if indexPath.row == 1{
                cell.textLabel!.text = "我的收藏"
                cell.imageView?.image = UIImage(named: "versions")!.withRenderingMode(.alwaysTemplate)
                cell.imageView?.tintColor = UIColor(red: 100 / 255.0, green: 150 / 255.0, blue: 150 / 255.0, alpha: 1)
            }
            else {
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
                UIApplication.shared.openURL(URL(string: MyVariables.root_url)! as URL)
            }
            else if indexPath.row == 1{
                let collect_ids = UserDefaults.standard.array(forKey: MyVariables.collect_key)
                var ids = "0"
                if(collect_ids != nil){
                    for id in (collect_ids)!{
                        ids += ",\(id as! String)"
                    }
                }
                TurbolinksSessionLib.sharedInstance.actionToPath("/app/collect/\(ids)", withAction: .Advance)
            }
            else {
                UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")! as URL)
            }
        default: break
        }
        
    }
    
    func actionWithPath(_ path: String) {
        _ = router.match(URL(string: path)! as URL)
    }
    
}
