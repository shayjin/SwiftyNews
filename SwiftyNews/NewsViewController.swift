import UIKit

class NewsViewController: UIViewController {
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var bp1: UILabel!
    @IBOutlet var bp2: UILabel!
    @IBOutlet var bp3: UILabel!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTitle.text = news!.title as? String
        
        bp1.text = news!.simplifiedText[0]
        bp2.text = news!.simplifiedText[1]
        bp3.text = news!.simplifiedText[2]
    }
}
