import UIKit
import Foundation

class NewCrumbViewController : UserLocatableViewController {

    @IBOutlet weak var messageTextView: UITextView!
    
    @IBAction func didTapCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func didTapAddButton(sender: AnyObject) {
       println("Creating crumb with message: \(messageTextView.text)")
    }
}