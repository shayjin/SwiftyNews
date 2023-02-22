//
//  ViewController.swift
//  SwiftyNews
//
//  Created by Shay on 2/22/23.
//

import UIKit

class HomeController: UIViewController {
    @IBOutlet var newsType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsType.setTitle("Local", forSegmentAt: 0)
        newsType.setTitle("US", forSegmentAt: 1)
        newsType.setTitle("World", forSegmentAt: 2)
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
