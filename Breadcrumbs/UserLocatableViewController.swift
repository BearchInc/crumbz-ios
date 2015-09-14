import UIKit
import Foundation
import CoreLocation

class UserLocatableViewController : UIViewController, CLLocationManagerDelegate {

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    lazy var currentUser : User? = {
       return User.currentUser()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Auth status changed to \(status)")
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations entries: [AnyObject]!) {
        let locations = entries as! [CLLocation]
        currentUser?.location = locations.last
        println("####### user lat: \(currentUser?.location.coordinate.latitude), lng: \(currentUser?.location.coordinate.longitude)")
    }
}
