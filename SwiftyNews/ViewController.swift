//
//  ViewController.swift
//  SwiftyNews
//
//  Created by Shay on 2/22/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var newsType: UISegmentedControl!
    @IBOutlet var navBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsType.setTitle("Local", forSegmentAt: 0)
        newsType.setTitle("US", forSegmentAt: 1)
        newsType.setTitle("World", forSegmentAt: 2)
        
        navBar.items![0].title = "Home"
        navBar.items![1].title = "Search"
        navBar.items![2].title = "Notification"
        navBar.items![3].title = "Profile"
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
    
}
