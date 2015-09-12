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
    
    func removeNonVisibleAnnotations() {
        for obj in self.annotations {
            let annotation = obj as! MKAnnotation
            let point = self.convertCoordinate(annotation.coordinate, toPointToView: self)
            if !self.annotationVisibleRect.contains(point) {
                self.removeAnnotation(annotation)
            }
        }
    }
}