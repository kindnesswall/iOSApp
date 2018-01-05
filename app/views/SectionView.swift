
import UIKit

class SectionView: UIView {

    @IBOutlet weak var title: UILabel!
    
    func setTitle(title:String){
        self.title.text = title
    }

}
