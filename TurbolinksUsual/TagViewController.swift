//自定义的标签页TagViewController

import UIKit

class TagViewController: WebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 顶部 标签 (丑陋的...)
        let filterSegment = UISegmentedControl(items: ["tag1", "tag2", "tag3"])
        filterSegment.selectedSegmentIndex = 0
        filterSegment.addTarget(self, action: #selector(filterChangedAction), for: .valueChanged)
        
        navigationItem.titleView = filterSegment
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(myClickAction))
        
        addObserver()
    }
    
    
    
    func filterChangedAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            TurbolinksSessionLib.sharedInstance.actionToPath("path1", withAction: .Restore)
        case 1:
            TurbolinksSessionLib.sharedInstance.actionToPath("path2", withAction: .Restore)
        case 2:
            TurbolinksSessionLib.sharedInstance.actionToPath("path3", withAction: .Restore)
        default:
            TurbolinksSessionLib.sharedInstance.actionToPath("default path", withAction: .Restore)
        }
    }
    
    func myClickAction() {
        TurbolinksSessionLib.sharedInstance.actionToPath("some path", withAction: .Replace)
    }
    
    private func addObserver() {
    }
}
