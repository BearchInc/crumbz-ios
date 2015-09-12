import Parse
import Foundation

@objc enum TrailType : Int {
    case Public, Protected, Private
}

class Trail : PFObject, PFSubclassing {
    @NSManaged var owner : User
    @NSManaged var type : TrailType
    
    static func parseClassName() -> String {
        return "Trail"
    }
}
