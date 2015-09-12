import UIKit
import MapKit

class CrumbView : MKAnnotationView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var annotation: MKAnnotation! {
        didSet {
            self.canShowCallout = true
            if let crumb = self.annotation as? Crumb {
                let delay = Double(random()) % 10.0 / 10.0
                let interval = NSTimeInterval(delay)
                UIView.animateWithDuration(0.8, delay: interval, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse, animations: {
                    let scalingFactor: CGFloat = 3
                    self.imageView.frame.size.width += scalingFactor
                    self.imageView.frame.size.height += scalingFactor
                }, completion: nil)
            }
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