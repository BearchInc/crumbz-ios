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
    
    func fetchCrumbsNearby(block : CrumbsBlock) {
        let nearbyCrumbsQuery = Crumb.query()!.includeKey("owner").includeKey("trail").whereKey("location", nearGeoPoint: location.toPFGeoPoint(), withinKilometers: UserRange)
        nearbyCrumbsQuery.findObjectsInBackgroundWithBlock {
            if let crumbs = $0.0 as? [Crumb] {
                block(crumbs: crumbs, error: nil)
            } else {
                block(crumbs: [Crumb](), error: $0.1)
            }
        }
    }
}