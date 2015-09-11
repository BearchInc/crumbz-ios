import UIKit
import Parse
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let eiffelTowerLocation = CLLocation(latitude: 48.85815, longitude: 2.29452)
    
    @IBOutlet weak var myTrailsCount: UILabel!
    @IBOutlet weak var scoresView: UIView! {
        didSet {
            scoresView.layer.shadowColor = UIColor.blackColor().CGColor
            scoresView.layer.shadowOffset = CGSizeZero
            scoresView.layer.shadowOpacity = 0.5
        }
    }
    
    @IBOutlet weak var locationView: UIView! {
        didSet {
            locationView.layer.shadowColor = UIColor.blackColor().CGColor
            locationView.layer.shadowOffset = CGSizeZero
            locationView.layer.shadowOpacity = 0.5
        }
    }
    
    @IBOutlet weak var currentLat: UILabel! {
        didSet {
            currentLat.text = "\(locationManager.location.coordinate.latitude)"
        }
    }
    
    @IBOutlet weak var currentLng: UILabel! {
        didSet {
            currentLng.text = "\(locationManager.location.coordinate.longitude)"
        }
    }
    
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
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
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
            
            user.fetchMyTrailsWithBlock {
                if let trails = $0.trails {
                    self.myTrailsCount.text = "\(trails.count)"
                    for trail in trails {
                        trail.fetchCrumbsWithBlock {
                            if let crumbs = $0.crumbs {
                                println("crumbz count: \(crumbs.count)")
                                self.mapView.addAnnotations(crumbs)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is Crumb) { return nil }
        
        let identifier = "Crumb"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            annotationView = UIView.fromNib(asType: CrumbAnnotationView.self)!
        } else {
            annotationView.annotation = annotation
        }
        
        return annotationView
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Auth status changed to \(status)")
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations entries: [AnyObject]!) {
        let locations = entries as! [CLLocation]
        currentLat.text = "\(locations.last?.coordinate.latitude)"
        currentLng.text = "\(locations.last?.coordinate.longitude)"
    }
}

