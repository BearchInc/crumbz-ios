import Parse
import MapKit
import Foundation
import CoreLocation

class Crumb : PFObject, PFSubclassing {
    @NSManaged var owner : User
    @NSManaged var trail : Trail
    @NSManaged var location : PFGeoPoint
    @NSManaged var message : String
    
    static func parseClassName() -> String {
        return "Crumb"
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let crumb = object as? Crumb {
            if self.objectId == crumb.objectId { return true }
        }
        
        return false
    }
}

extension Crumb {
    class func fetchCrumbsWithinRegionFromSouthwest(southwest: PFGeoPoint, toNortheast northeast: PFGeoPoint,  block : CrumbsBlock) {
        let nearbyCrumbsQuery = Crumb.query()!.includeKey("owner").includeKey("trail").whereKey("location", withinGeoBoxFromSouthwest: southwest, toNortheast: northeast)
        nearbyCrumbsQuery.findObjectsInBackgroundWithBlock {
            if let crumbs = $0.0 as? [Crumb] {
                block(crumbs: crumbs, error: nil)
            } else {
                block(crumbs: [Crumb](), error: $0.1)
            }
        }
    }
}

extension Crumb : MKAnnotation {
    var title : String { return message }
    var subtitle : String { return owner.username! }
    dynamic var coordinate : CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        
        set {
            location = PFGeoPoint(latitude: newValue.latitude, longitude: newValue.longitude)
        }
    }
}