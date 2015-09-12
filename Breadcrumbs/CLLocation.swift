import Parse
import Foundation
import CoreLocation

extension CLLocation {
    func toPFGeoPoint() -> PFGeoPoint {
        return PFGeoPoint(location: self)
    }
}