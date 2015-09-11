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