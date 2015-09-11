
import Foundation

extension UIView {
    class func fromNib<T : AnyObject>(asType type: T.Type) -> T? {
        let nibName = split(NSStringFromClass(T)) {$0 == "."}.last
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil)[0] as? T
    }
    
//    class func fromNib(named name: String) -> UIView? {
//        return NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)[0] as? UIView
//    }
}