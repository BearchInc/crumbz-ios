import UIKit
import Parse
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsBuildings = true
            mapView.showsUserLocation = true
            mapView.showsPointsOfInterest = true
            var mapCamera = MKMapCamera(
                lookingAtCenterCoordinate: CLLocation(latitude: 48.85815, longitude: 2.29452).coordinate,
                fromEyeCoordinate: CLLocation(latitude: 48.850, longitude: 2.29447).coordinate,
                eyeAltitude: 350.0)
            
            mapView.setCamera(mapCamera, animated: true)
        }
    }
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
       
        if let user = User.currentUser() {
            if !user.isAuthenticated() {
                UIAlertView(title: "Session", message: "Session is no longer active", delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }
            
            var trail = Trail()
            trail.owner = user
            trail.type = .Public
            
            var crumb = Crumb()
            crumb.owner = user
            crumb.trail = trail
            crumb.location = PFGeoPoint(location: self.locationManager.location!)
            crumb.message = "Big LOL it works!"
            crumb.saveEventually { saved, error in
                if !saved {
                    println("Failed saving crumbz: \(error)")
                    return
                }
                
                trail.fetchCrumbsWithBlock {
                    let total = $0.crumbs?.count
                    println("Total trail crumbs: \(total!)")
                }
            }
            
            user.fetchMyTrailsWithBlock {
                let total = $0.trails?.count
                println("total user created trails: \(total!)")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Auth status changed to \(status)")
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("locations updated \(locations)")
    }
}

