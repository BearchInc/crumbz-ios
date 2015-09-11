import UIKit
import MapKit

class CrumbAnnotationView : MKAnnotationView {
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.canShowCallout = true
    }
}