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
    let APIKey = NewsAPI(apiKey: "6165d99f329f4996977bb4d7495c0940")
    
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=6165d99f329f4996977bb4d7495c0940")!
    
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
                    let title = article["title"] as! String
                    print(title)
                }
            } catch let error {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
}
