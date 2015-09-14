import UIKit
import Parse
import MapKit
import CoreLocation

class MapViewController: UserLocatableViewController {
    
    var plottedCrumbs = [Crumb]()
    
    let eiffelTowerLocation = CLLocation(latitude: 48.85815, longitude: 2.29452)
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsBuildings = true
            mapView.showsUserLocation = true
            mapView.showsPointsOfInterest = true
            let cameraLocation = CLLocation(latitude: locationManager.location.coordinate.latitude - 0.003, longitude: locationManager.location.coordinate.longitude - 0.003)
            var mapCamera = MKMapCamera(
                lookingAtCenterCoordinate: locationManager.location.coordinate,
                fromEyeCoordinate: cameraLocation.coordinate,
                eyeAltitude: 350.0)
            
            mapView.setCamera(mapCamera, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = currentUser {
            if !user.isAuthenticated() {
                UIAlertView(title: "Session", message: "Session is no longer active", delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }
            
            user.location = locationManager.location
            Crumb.allWithinRegionFromSouthwest(mapView.southwestGeoPoint(), toNortheast: mapView.northeastGeoPoint()) {
                self.plottedCrumbs = $0.crumbs
                self.mapView.addAnnotations($0.crumbs)
            }
        }
    }
    
    @IBOutlet weak var newCrumbButton: UIButton! {
        didSet {
            let finalYPosition = newCrumbButton.center.y
            newCrumbButton.center.y += 150
            UIView.animateWithDuration(0.8, delay: 2, options: .CurveEaseOut, animations: {
                self.newCrumbButton.center.y = finalYPosition
            }, completion: nil)
        }
    }
    
    @IBAction func didTapNewCrumbButton(sender: AnyObject) {
        println("########## New Crumb!")
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let crumb = annotation as? Crumb {
            
            if currentUser!.owns(crumb) {
                let identifier = "MyCrumb"
                var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                
                if annotationView == nil {
                    annotationView = UIView.fromNib(asType: MyCrumbView.self)!
                } else {
                    annotationView.annotation = crumb
                }
                
                return annotationView
                
            } else if currentUser!.didCollect(crumb) {
                let identifier = "CollectedCrumb"
                var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                
                if annotationView == nil {
                    annotationView = UIView.fromNib(asType: CollectedCrumbView.self)!
                } else {
                    annotationView.annotation = crumb
                }
                
                return annotationView
            } else {
                let identifier = "Crumb"
                var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                
                if annotationView == nil {
                    annotationView = UIView.fromNib(asType: CrumbView.self)!
                } else {
                    annotationView.annotation = crumb
                }
                
                return annotationView
            }
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println("########## selected!")
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        println("########## deselected")
    }

    // Fade in crumbs when added to the map
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        let annotationViews = views as! [UIView]
        for view in annotationViews {
            view.alpha = 0.0
            UIView.animateWithDuration(0.5) {
                view.alpha = 1
            }
        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        mapView.removeNonVisibleAnnotations()
        
        Crumb.allWithinRegionFromSouthwest(mapView.southwestGeoPoint(), toNortheast: mapView.northeastGeoPoint()) {
            self.plottedCrumbs = $0.crumbs
            self.mapView.addAnnotations($0.crumbs)
        }
    }
}
