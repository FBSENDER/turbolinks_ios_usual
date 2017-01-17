import PKHUD

class RBHUD {
    static func success(_ message: String?) {
        HUD.allowsInteraction = true
        HUD.flash(.labeledSuccess(title: nil, subtitle: message), delay: 2.0)
    }
    
    static func error(_ message: String?) {
        HUD.allowsInteraction = true
        HUD.flash(.labeledError(title: nil, subtitle: message), delay: 2.0)
    }
    
    static func progress(_ message: String?) {
        HUD.allowsInteraction = false
        HUD.show(.labeledProgress(title: nil, subtitle: message))
    }
    
    static func progressHidden() {
        HUD.hide()
    }
}
