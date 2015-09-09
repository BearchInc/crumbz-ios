import Parse
import Foundation

class Crumb : PFObject, PFSubclassing {
    @NSManaged var owner : User
    @NSManaged var trail : Trail
    @NSManaged var location : PFGeoPoint
    @NSManaged var message : String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Crumb"
    }
}

@objc enum TrailType : Int {
    case Public, Protected, Private
}

class Trail : PFObject, PFSubclassing {
    typealias CrumbsBlock = (crumbs : [Crumb]?, error : NSError?) -> Void
    
    @NSManaged var owner : User
    @NSManaged var type : TrailType
    
    func fetchCrumbsWithBlock(block : CrumbsBlock) {
        PFQuery(className: Crumb.parseClassName()).whereKey("trail", equalTo: self).findObjectsInBackgroundWithBlock {
            if let data = $0.0 {
                block(crumbs: data as? [Crumb], error: nil)
            }
        }
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Trail"
    }
}

class User : PFUser, PFSubclassing {
    typealias TrailsBlock = (trails : [Trail]?, error : NSError?) -> Void
    
    @NSManaged var name : String
    @NSManaged var myTrails : [Trail]
    @NSManaged var completedTrails : [Trail]
    @NSManaged var followingTrails : [Trail]
    
    func fetchMyTrailsWithBlock(block : TrailsBlock) {
        PFQuery(className: Trail.parseClassName()).whereKey("owner", equalTo: self).findObjectsInBackgroundWithBlock {
            if let data = $0.0 {
                block(trails: data as? [Trail], error: nil)
            }
        }
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}

