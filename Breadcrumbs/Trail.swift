import Parse
import Foundation

@objc enum TrailType : Int {
    case Public, Protected, Private
}

class Trail : PFObject, PFSubclassing {
    typealias CrumbsBlock = (crumbs : [Crumb]?, error : NSError?) -> Void
    
    @NSManaged var owner : User
    @NSManaged var type : TrailType
    
    func fetchCrumbsWithBlock(block : CrumbsBlock) {
        Crumb.query()!.whereKey("trail", equalTo: self).orderByAscending("createdAt").findObjectsInBackgroundWithBlock {
            if let data = $0.0 {
                println("count: \(data.count)")
                block(crumbs: data as? [Crumb], error: nil)
            }
        }
    }
    
    static func parseClassName() -> String {
        return "Trail"
    }
}
