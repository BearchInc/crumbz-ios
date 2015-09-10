import Parse
import MapKit
import Foundation
import CoreLocation

class Crumb : PFObject, PFSubclassing, MKAnnotation {
    @NSManaged var owner : User
    @NSManaged var trail : Trail
    @NSManaged var location : PFGeoPoint
    @NSManaged var message : String
    
    var coordinate : CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        
        set {
            location = PFGeoPoint(latitude: newValue.latitude, longitude: newValue.longitude)
        }
    }
    
    var title : String { return message }
    
    var subtitle : String { return owner.username! }
    
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
        Crumb.query()!.whereKey("trail", equalTo: self).findObjectsInBackgroundWithBlock {
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

class User : PFUser, PFSubclassing {
    typealias TrailsBlock = (trails : [Trail]?, error : NSError?) -> Void
    
    @NSManaged var tagline : String
    
    func fetchMyTrailsWithBlock(block : TrailsBlock) {
        Trail.query()!.whereKey("owner", equalTo: self).findObjectsInBackgroundWithBlock {
            if let data = $0.0 {
                block(trails: data as? [Trail], error: nil)
            }
        }
    }
}

