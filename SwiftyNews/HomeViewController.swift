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
    

    let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "ve", "za"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View will appear")
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        self.newsType.setTitle("Local", forSegmentAt: 0)
        self.newsType.setTitle("US", forSegmentAt: 1)
        self.newsType.setTitle("World", forSegmentAt: 2)
    

        
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
        case 1:
            print("US News")
        case 2:
            print("World News")
        default:
            print("Default")
        }
    }
    
    
    @IBAction func testPressed(_ sender: Any) {
        let local = URL(string: "https://newsapi.org/v2/everything?qInTitle=Columbus+Ohio&apiKey=\(apiKey)")!
        
        let US = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
    
        
        let task = URLSession.shared.dataTask(with: local) { data, response, error in
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
                    let title = article["title"] as! String
                    //print(title)
                }
                print("hi?")
            } catch let error {
                print("Error parsing JSON: \(error)")
            }
        }
        
        print("?")
        parseWorldNews()
        print("?")
        
        task.resume()
    }
    
    func parseWorldNews() -> [[String: Any]] {
        var articleList = [[String: Any]]()
        for country in countries {
            print(country)
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
                    
                    //articleList.append(articles[0][0])
                    articleList.append(articles[0])
                } catch let error {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            task.resume()
        }
        
        return articleList
    }
    
}
