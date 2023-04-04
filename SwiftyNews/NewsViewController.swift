//
//  NewsViewController.swift
//  SwiftyNews
//
//  Created by Shay on 4/3/23.
//

import UIKit

class NewsViewController: UIViewController {
    
    var news: News?

    @IBOutlet var newsTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTitle.text = news?.title as? String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
