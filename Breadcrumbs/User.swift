import Parse
import Foundation
import CoreLocation

typealias TrailsBlock = (trails : [Trail], error : NSError?) -> Void
typealias CrumbsBlock = (crumbs : [Crumb], error : NSError?) -> Void

class User : PFUser, PFSubclassing {
    let UserRange = 1.0 // kilometer
    
    var location : CLLocation!

    @NSManaged var tagline : String
    @NSManaged var myTrails : [Trail]
    @NSManaged var collectedCrumbs : [Crumb]
    
    func didCollect(crumb: Crumb) -> Bool {
        return !(collectedCrumbs.filter {
            return $0.isEqual(crumb)
        }.isEmpty)
    }
    
    func owns(crumb: Crumb) -> Bool {
        return crumb.owner.objectId == self.objectId
    }
}