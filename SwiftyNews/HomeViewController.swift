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
    @IBOutlet var testButton: UIButton!
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    let apiKey = "06f9dc5e275848799b55eb8d315c25f4"
    
    var localNews = [[String: Any]]()
    var USNews = [[String: Any]]()
    var worldNews = [[String: Any]]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View will appear")
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        self.newsType.setTitle("Local", forSegmentAt: 0)
        self.newsType.setTitle("US", forSegmentAt: 1)
        self.newsType.setTitle("World", forSegmentAt: 2)
        
        
        self.localNews = parseLocalAndUSNews("everything?qInTitle=Columbus+Ohio")
        self.USNews = parseLocalAndUSNews("top-headlines?country=us")
        self.worldNews = parseWorldNews()
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
        print(newsType.selectedSegmentIndex)
        
        switch newsType.selectedSegmentIndex {
        case 0:
            print("Local News")
            print(self.localNews)
        case 1:
            print("US News")
        case 2:
            print("World News")
        default:
            print("Default")
        }
        
    }
    
    func parseLocalAndUSNews(_ apiArg: String) -> [[String: Any]] {
        let url = URL(string: "https://newsapi.org/v2/\(apiArg)&apiKey=\(apiKey)")!
        
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
        let countries = ["ae", "ar"]
        // let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "ve", "za"]
        
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
    
}
