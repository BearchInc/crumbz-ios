import Parse
import MapKit
import Foundation

extension MKMapView {
    func northeastGeoPoint() -> PFGeoPoint {
        let mRect = self.visibleMapRect
        let neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y)
        return MKCoordinateForMapPoint(neMapPoint).toPFGeoPoint()
    }
    
    func southwestGeoPoint() -> PFGeoPoint {
        let mRect = self.visibleMapRect
        let swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect))
        return MKCoordinateForMapPoint(swMapPoint).toPFGeoPoint()
    }
}