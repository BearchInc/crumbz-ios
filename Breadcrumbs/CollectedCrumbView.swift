import UIKit
import MapKit

class CollectedCrumbView : MKAnnotationView {
    
    override var annotation : MKAnnotation! {
        didSet {
            self.canShowCallout = true
        }
    }
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}