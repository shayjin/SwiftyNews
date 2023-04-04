import UIKit

class NewsViewController: UIViewController {
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var bp1: UILabel!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTitle.text = news!.title as? String
        
        bp1.text = news!.simplifiedText[0] + "\n\n" + news!.simplifiedText[1] + "\n\n" + news!.simplifiedText[2]
    }
}
