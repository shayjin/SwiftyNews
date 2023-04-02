//
//  ViewController.swift
//  SwiftyNews
//
//  Created by Shay on 2/22/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import NewsAPISwift

class HomeViewController: UIViewController {
    @IBOutlet var newsType: UISegmentedControl!
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    let apiKey = "06f9dc5e275848799b55eb8d315c25f4"
    
    var userLocation: String?
    var localNews = [[String: Any]]()
    var USNews = [[String: Any]]()
    var worldNews = [[String: Any]]()
    

    @IBOutlet var picture1: UIImageView!
    @IBOutlet var title1: UILabel!
    @IBOutlet var description1: UITextView!
    @IBOutlet var picture2: UIImageView!
    @IBOutlet var title2: UILabel!
    @IBOutlet var description2: UITextView!
    @IBOutlet var picture3: UIImageView!
    @IBOutlet var title3: UILabel!
    @IBOutlet var description3: UITextView!
    @IBOutlet var picture4: UIImageView!
    @IBOutlet var title4: UILabel!
    @IBOutlet var description4: UITextView!
    @IBOutlet var picture5: UIImageView!
    @IBOutlet var title5: UILabel!
    @IBOutlet var description5: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        self.newsType.setTitle("Local", forSegmentAt: 0)
        self.newsType.setTitle("US", forSegmentAt: 1)
        self.newsType.setTitle("World", forSegmentAt: 2)
        
        self.userLocation = getUserLocation()
        
        self.localNews = parseLocalAndUSNews("everything?qInTitle=\(self.userLocation)")
        self.USNews = parseLocalAndUSNews("top-headlines?country=us")
        self.worldNews = parseWorldNews()
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View did disappear")
    }
    
    
    @IBAction func switchNewsType(_ sender: Any) {
        switch newsType.selectedSegmentIndex {
        case 0:
            print("Local News")
        case 1:
            print("US News")
        case 2:
            print("World News")
        default:
            print("Default")
        }
    }
    
    func getUserLocation() -> String {
        return ""
    }
    
    func parseLocalAndUSNews(_ apiArg: String) -> [[String: Any]] {
        //let url = URL(string: "https://newsapi.org/v2/\(apiArg)&pageSize=5&apiKey=\(apiKey)")!
        let url = URL(string: "https://naver.com")!
        var articleList = [[String: Any]]()
        
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
                
                articleList = articles
            } catch let error {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
        
        return articleList
    }
    
    
    func parseWorldNews() -> [[String: Any]] {
        var articleList = [[String: Any]]()
        let countries = ["ae", "ar", "gr", "kr", "jp"]
        
        for country in countries {
            let urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&pageSize=1&apiKey=\(apiKey)"
            let url = URL(string: urlString)!
            
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
                    
                    articleList = articles
                } catch let error {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            task.resume()
        }
        
        return articleList
    }
    
    func updateUI() {
        let UIComponnents = [
            [self.picture1, self.title1, self.description1],
            [self.picture2, self.title2, self.description2],
            [self.picture3, self.title3, self.description3],
            [self.picture4, self.title4, self.description4],
            [self.picture5, self.title5, self.description5]
        ]
        
        var temp = [
            ["image": "https://i.inside.com/6424307ded593e00183f0aad?width=1200&format=jpeg",
             "title": "Apple Never Gave Them USB. Now, They’re Getting It For Themselves", "description": "These days we use USB as a default for everything from low-speed serial ports to high-capacity storage, and the ubiquitous connector has evolved into a truly multi-purpose interface. It’s difficult …read more"],
            ["image": "https://i.inside.com/6424307ded593e00183f0aad?width=1200&format=jpeg",
             "title": "Test2", "description": "blah blah blahhh"],
            ["image": "https://i.inside.com/6424307ded593e00183f0aad?width=1200&format=jpeg",
             "title": "Test3", "description": "blah blah blahhh"],
            ["image": "https://i.inside.com/6424307ded593e00183f0aad?width=1200&format=jpeg",
             "title": "Test4", "description": "blah blah blahhh"],
            ["image": "https://i.inside.com/6424307ded593e00183f0aad?width=1200&format=jpeg",
             "title": "Test5", "description": "blah blah blahhh"]
        ]
        
        // 1.9012345679
        
        for i in 0...temp.count-1 {
            var imageView = UIComponnents[i][0] as! UIImageView
            if let url = URL(string:  "https://www.cnet.com/a/img/resize/ebf01d34fd0f1dc9356ac90b2d151fb408827d55/hub/2023/03/27/23c03d52-a078-4000-8017-7e84af489aa0/hbo-max-elizabeth-olsen-love-death.jpg?auto=webp&fit=crop&height=630&width=1200") {
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
            (UIComponnents[i][1] as! UILabel).text = temp[i]["title"]
            
            var des = UIComponnents[i][2] as! UITextView
            des.text = temp[i]["description"]
            des.isEditable = false
        }
    }
    
}
