import UIKit
import SwiftyJSON

let APP_TITLE = ""
let APP_ID = ""
let APP_VERSION = ""
let UM_APP_KEY = ""
let UM_CHANNEL_ID = ""
let AD_UNIT_ID = ""
let AD_CHA_ID = ""
let USER_AGENT = "turbolinks-app, something like yourwebsite, version=" + APP_VERSION
let CONFIG_JSON = "{\"tag_view_controllers\":[{\"title\":\"hah\",\"image_name\":\"topic\",\"path\":\"/app/card_ssr\",\"tag\":0,\"header_items\":[\"1\",\"2\"],\"header_paths\":[\"/app/card_r\",\"/app/card_sr\"],\"add_search_button\":true,\"search_path\":\"/app/hot\"},{\"title\":\"hah\",\"image_name\":\"topic\",\"path\":\"/app/card_ssr\",\"tag\":1,\"header_items\":[\"1\",\"2\"],\"header_paths\":[\"/app/card_r\",\"/app/card_sr\"],\"add_search_button\":true,\"search_path\":\"/app/hot\"}],\"routes\":[{\"title\":\"SR\",\"path\":\"/app/card_sr\",\"add_share_button\":true,\"show_google_ad\":true}]}"


struct MyVariables{
    static var root_url = "http://www.yysssr.com:3000"
    static var config_root_url = "http://www.yysssr.com:3000/app/config_info"
    static var fb_config_key = "\(APP_ID)_\(APP_VERSION)_fbconfig"
    static var collect_key = "\(APP_ID)_collect"
    static var tag_views: [SwiftyJSON.JSON] = []
    static var routes: [SwiftyJSON.JSON] = []
}


// Red Theme
let BLACK_COLOR = UIColor(red: 0.04, green: 0.02, blue: 0.02, alpha: 1.0)
let PRIMARY_COLOR = UIColor(red: 0.91, green: 0.33, blue: 0.23, alpha: 1.0)
let NAVBAR_BG_COLOR = PRIMARY_COLOR
let SIDEMENU_NAVBAR_BG_COLOR = UIColor(red: 0.74, green: 0.24, blue: 0.13, alpha: 1.0)
let SIDEMENU_BG_COLOR = UIColor(red: 0.95, green: 0.94, blue: 0.94, alpha: 1.0)
let NAVBAR_BORDER_COLOR = UIColor(red: 0.72, green: 0.30, blue: 0.26, alpha: 1.0)
let NAVBAR_TINT_COLOR = UIColor(red: 1.00, green: 1.00, blue: 0.98, alpha: 1.0)
let SEGMENT_BG_COLOR = UIColor(red: 0.23, green: 0.05, blue: 0.02, alpha: 1.0)
let TABBAR_BG_COLOR = UIColor(red: 0.96, green: 0.94, blue: 0.94, alpha: 1.0)




