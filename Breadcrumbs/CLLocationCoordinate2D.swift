import Parse
import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func toPFGeoPoint() -> PFGeoPoint {
        return PFGeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
}
