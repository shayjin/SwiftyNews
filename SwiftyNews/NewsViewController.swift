import UIKit

class NewsViewController: UIViewController {
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var bp1: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        self.newsTitle.text = news!.title as? String
        self.author.text = "Written by: \(news?.author as? String)"
        
        if news!.imageUrl != "nil" {
            if let url = URL(string: news!.imageUrl) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async { [self] in
                            let image = UIImage(data: data)
                            
                            imageView.contentMode = .scaleAspectFit
                            imageView.image = image
                        }
                    }
                }.resume()
            }
        } else {
            imageView.image = UIImage(named: "logo")
        }
        
        
        if news!.simplifiedText[0].count != 0 {
            news!.simplifiedText[0] = news!.simplifiedText[0].trimmingCharacters(in: .newlines)
            self.bp1.text = "📌  \(news!.simplifiedText[0]). "
        }

        
        if news!.simplifiedText[1].count != 0 {
            self.bp1.text! += "\n\n📌 \(news!.simplifiedText[1]). "
        }
        
        if news!.simplifiedText[2].count != 0 {
            self.bp1.text! += "\n\n📌 \(news!.simplifiedText[2]). "
        }
        
    }
}
