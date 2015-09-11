import Parse
import Foundation

class User : PFUser, PFSubclassing {
    typealias TrailsBlock = (trails : [Trail]?, error : NSError?) -> Void
    
    @NSManaged var tagline : String
    
    func fetchMyTrailsWithBlock(block : TrailsBlock) {
        Trail.query()!.whereKey("owner", equalTo: self).findObjectsInBackgroundWithBlock {
            if let data = $0.0 {
                block(trails: data as? [Trail], error: nil)
            }
        }
    }
}