//自定义的标签页TagViewController

import UIKit
import SwiftyJSON

class TagViewController: WebViewController {
    
    fileprivate var add_search_button = false
    fileprivate var search_path = ""
    fileprivate var header_items : [String] = []
    fileprivate var header_paths : [String] = []
    
    convenience init(path: String, headers: SwiftyJSON.JSON) {
        self.init(path: path)
        for item in headers["header_items"].arrayValue{
            self.header_items.append(item.stringValue)
        }
        for path in headers["header_paths"].arrayValue{
            self.header_paths.append(path.stringValue)
        }
        self.add_search_button = headers["add_search_button"].boolValue
        if(self.add_search_button){
            self.search_path = headers["search_path"].stringValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 顶部 标签 (丑陋的...)
        let filterSegment = UISegmentedControl(items: self.header_items)
        filterSegment.selectedSegmentIndex = 0
        filterSegment.addTarget(self, action: #selector(filterChangedAction), for: .valueChanged)
        
        navigationItem.titleView = filterSegment
        
        if(self.add_search_button){
          navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(myClickAction))
        }
        
        addObserver()
    }
    
    
    
    func filterChangedAction(sender: UISegmentedControl) {
        let path = self.header_paths[sender.selectedSegmentIndex]
        TurbolinksSessionLib.sharedInstance.actionToPath(path, withAction: .Restore)
    }
    
    func myClickAction() {
        TurbolinksSessionLib.sharedInstance.actionToPath(self.search_path, withAction: .Replace)
    }
    
    private func addObserver() {
    }
}
