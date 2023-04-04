//
//  NewsViewController.swift
//  SwiftyNews
//
//  Created by Shay on 4/3/23.
//

import UIKit

class NewsViewController: UIViewController {
    
    var news: News?

    @IBOutlet var bp1: UILabel!
    @IBOutlet var bp2: UILabel!
    @IBOutlet var bp3: UILabel!
    
    @IBOutlet var newsTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newsTitle.text = news!.title as? String
        
        bp1.text = news!.simplifiedText[0]
        bp2.text = news!.simplifiedText[1]
        bp3.text = news!.simplifiedText[2]
        
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
