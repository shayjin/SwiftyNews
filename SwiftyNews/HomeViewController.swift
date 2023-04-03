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
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var newsType: UISegmentedControl!
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    let apiKey = "ad608b63d41f4e499c418e50c0c3789f"
    
    var userLocation: String?
    var localNews = [News]()
    var USNews = [News]()
    var worldNews = [News]()
    

    @IBOutlet var picture1: UIImageView!
    @IBOutlet var title1: UILabel!
    @IBOutlet var picture2: UIImageView!
    @IBOutlet var title2: UILabel!
    @IBOutlet var picture3: UIImageView!
    @IBOutlet var title3: UILabel!
    @IBOutlet var picture4: UIImageView!
    @IBOutlet var title4: UILabel!
    @IBOutlet var picture5: UIImageView!
    @IBOutlet var title5: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
                
        self.newsType.setTitle("Local", forSegmentAt: 0)
        self.newsType.setTitle("US", forSegmentAt: 1)
        self.newsType.setTitle("World", forSegmentAt: 2)
        

        self.userLocation = getUserLocation()

        self.userLocation = "columbus+ohio"
      //  parseLocalAndUSNews("everything?qInTitle=columbus+ohio")
      //  parseLocalAndUSNews("top-headlines?country=us")
       // parseWorldNews()
       
        
        //updateUI(self.localNews)
        
        let locationManager = CLLocationManager()
        print(locationManager)
        locationManager.requestWhenInUseAuthorization()
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
            updateUI(self.localNews)
        case 1:
            print("US News")
            updateUI(self.USNews)
        case 2:
            print("World News")
            updateUI(self.worldNews)
        default:
            print("Default")
           // updateUI(self.localNews)
        }
    }
    
    func getUserLocation() -> String {
        let locationManager = CLLocationManager()

        // Request location authorization from the user
        locationManager.requestWhenInUseAuthorization()

        // Check if the user granted location permission
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Location permission granted!")
        case .denied:
            print("Location permission denied!")
        default:
            print("Location permission not determined.")
        }
        
        return "hi"
    }
    
    func parseLocalAndUSNews(_ apiArg: String) {
        let url = URL(string: "https://newsapi.org/v2/\(apiArg)&pageSize=5&apiKey=\(apiKey)")!
        
        var type: String
        
        if apiArg.contains("everything") {
            type = "local"
        } else {
            type = "us"
        }
        
        var articleList = [News]()
        print("1")
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
                        imageUrl: img, author: article["author"] as Any, date: article["publishedAt"] as Any, text: article["description"] as Any)
                    
                    if type == "local" {
                        self.localNews.append(news)
                    } else {
                        self.USNews.append(news)
                    }
                
                }
                
                print(self.localNews)
                
                
            } catch let error {
                print("Error parsing JSON: \(error)")
            }
            
        }
        
        Thread.sleep(forTimeInterval: 2)
        
        task.resume()
        
        Thread.sleep(forTimeInterval: 2)
    }
    
    
    func parseWorldNews() {
        var articleList = [News]()
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
                    
                    print(articles)
                    
                    for article in articles {
                        print("rodrod")
                        var img: String
                        var description: String
                        
                        if let myString = article["urlToImage"] as? String {
                            img = article["urlToImage"] as! String
                        } else {
                            img = "nil"
                        }
                        
                        if let myString = article["description"] as? String {
                            description = article["description"] as! String
                        } else {
                            description = "nil"
                        }

                        let news = News(title: article["title"] as Any,
                            imageUrl: img, author: article["author"] as Any, date: article["publishedAt"] as Any, text: description)
                        
                        self.worldNews.append(news)
                        Thread.sleep(forTimeInterval: 1)
                        
                    }
                    
                    
                } catch let error {
                    print("Error parsing JSON: \(error)")
                }
            }
            Thread.sleep(forTimeInterval: 2)
            
            task.resume()
            Thread.sleep(forTimeInterval: 2)
            print(self.worldNews)
        }
    }
    
    func updateUI(_ articleList: [News]) {
        let UIComponnents = [
            [self.picture1, self.title1],
            [self.picture2, self.title2],
            [self.picture3, self.title3],
            [self.picture4, self.title4],
            [self.picture5, self.title5]
        ]
        
        
        for i in 0...articleList.count-1 {
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
