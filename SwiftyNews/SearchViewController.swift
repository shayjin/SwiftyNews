//
//  SearchViewController.swift
//  SwiftyNews
//
//  Created by Shay on 4/5/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var title1: UILabel!
    @IBOutlet var picture1: UIImageView!
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var picture2: UIImageView!
    @IBOutlet var title2: UILabel!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    @IBOutlet var picture3: UIImageView!
    @IBOutlet var title3: UILabel!
    
    @IBOutlet var picture4: UIImageView!
    @IBOutlet var title4: UILabel!
    @IBOutlet var button4: UIButton!
    
    @IBOutlet var picture5: UIImageView!
    @IBOutlet var button5: UIButton!
    @IBOutlet var title5: UILabel!
    
    var apiKey = "06f9dc5e275848799b55eb8d315c25f4"
    
    var searchedNews = [News]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.isHidden = true
       
    }
    
    
    @IBAction func search(_ sender: Any) {
        if textField.text!.count > 0 {
            self.scrollView.isHidden = false
            self.searchedNews = [News]()
            
            var apiArg: String = "everything?q=\(textField.text!)"
            
            let url = URL(string: "https://newsapi.org/v2/\(apiArg)&pageSize=5&apiKey=\(apiKey)")!
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error!)")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    guard let articles = json["articles"] as? [[String: Any]] else {
                        print("Error: Missing 'articles' field in JSON response")
                        return
                    }
                    
                    for article in articles {
                        var img: String
                        
                        if let myString = article["urlToImage"] as? String {
                            img = article["urlToImage"] as! String
                        } else {
                            img = "nil"
                        }
                        
                        let news = News(title: article["title"] as Any,
                                        imageUrl: img, author: article["author"] as Any, date: article["publishedAt"] as Any, text: article["description"] as Any, url: article["url"] as! String)
                        
                        
                        print(news)
                        self.searchedNews.append(news)
                    }
                } catch let error {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            Thread.sleep(forTimeInterval: 2)
            task.resume()
            Thread.sleep(forTimeInterval: 2)
            
            updateUI(self.searchedNews)
            view.endEditing(true)
        }
    }
    
    @IBAction func showNews(_ sender: UIButton) {
        performSegue(withIdentifier: "showNews", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNews" {
            if let destinationVC = segue.destination as? NewsViewController,
               let senderButton = sender as? UIButton {
                destinationVC.news = self.searchedNews[senderButton.tag - 1]
            }
        }
    }
    
    func updateUI(_ articleList: [News]) {
        
        let UIComponnents = [
            [self.picture1, self.title1, self.button1],
            [self.picture2, self.title2, self.button2],
            [self.picture3, self.title3, self.button3],
            [self.picture4, self.title4, self.button4],
            [self.picture5, self.title5, self.button5]
        ]
    
        for i in 0...articleList.count-1 {
            UIComponnents[i][2]!.tag = i + 1
            
            if i != 0 {
                (UIComponnents[i][2] as! UIButton).addTarget(self, action: #selector(showNews(_:)), for: .touchUpInside)
            }
            
            var imageView = UIComponnents[i][0] as! UIImageView
            
            if articleList[i].imageUrl != "nil" {
                if let url = URL(string: articleList[i].imageUrl ) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            DispatchQueue.main.async {
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
            
            imageView.layer.cornerRadius = 5.0
            imageView.layer.masksToBounds = true
            (UIComponnents[i][1] as! UILabel).text = articleList[i].title as! String
        }
    }
    

        
    
}
