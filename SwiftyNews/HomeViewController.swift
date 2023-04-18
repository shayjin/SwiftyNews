import UIKit
import FirebaseAuth
import FirebaseDatabase
import NewsAPISwift
import CoreLocation
import Alamofire

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    let auth = Auth.auth()
    let database = Database.database().reference()
    let apiKey = "06f9dc5e275848799b55eb8d315c25f4"
    
    var userLocation: String? = nil
    var localNews = [News]()
    var USNews = [News]()
    var worldNews = [News]()

    @IBOutlet var newsType: UISegmentedControl!
    @IBOutlet var button1: UIButton!
    @IBOutlet var picture1: UIImageView!
    @IBOutlet var title1: UILabel!
    @IBOutlet var button2: UIButton!
    @IBOutlet var picture2: UIImageView!
    @IBOutlet var title2: UILabel!
    @IBOutlet var picture3: UIImageView!
    @IBOutlet var button3: UIButton!
    @IBOutlet var title3: UILabel!
    @IBOutlet var button4: UIButton!
    @IBOutlet var picture4: UIImageView!
    @IBOutlet var title4: UILabel!
    @IBOutlet var button5: UIButton!
    @IBOutlet var picture5: UIImageView!
    @IBOutlet var title5: UILabel!

    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var loadingLabel2: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        loading(label: loadingLabel)
        loading(label: loadingLabel2)
        hideComponents()
        
        super.viewDidAppear(animated)

        self.newsType.accessibilityIdentifier = "newsType"

        if localNews.count <= 0 {
            getUserLocation()
            parseLocalAndUSNews("top-headlines?country=us")
            parseWorldNews()
        } else {
            switchNewsType((Any).self)
        }
    }
    
    func hideComponents() {
        let comps = [newsType, button1, picture1, title1, button2, picture2, title2, button3, picture3, title3, button4, picture4, title4, button5, picture5, title5]
        
        for comp in comps {
            comp?.isHidden = true
        }
    }
    
    func showComponents() {
        let comps = [newsType, button1, picture1, title1, button2, picture2, title2, button3, picture3, title3, button4, picture4, title4, button5, picture5, title5]
        
        for comp in comps {
            comp?.isHidden = false
        }
    }
    
    func loading(label: UILabel) {
        label.text = "Loading articles..."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func remove(label: UILabel) {
        label.isHidden = true
    }
    
    @IBAction func showNews(_ sender: UIButton) {
        performSegue(withIdentifier: "showNews", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNews" {
            if let destinationVC = segue.destination as? NewsViewController,
               let senderButton = sender as? UIButton {
                
                switch newsType.selectedSegmentIndex {
                case 0:
                    destinationVC.news = self.localNews[senderButton.tag - 1]
                case 1:
                    destinationVC.news = self.USNews[senderButton.tag - 1]
                case 2:
                    destinationVC.news = self.worldNews[senderButton.tag - 1]
                default:
                    destinationVC.news = self.localNews[senderButton.tag - 1]
                }
            }
        }
    }
    
    @IBAction func switchNewsType(_ sender: Any) {
        switch newsType.selectedSegmentIndex {
        case 0:
            updateUI(self.localNews)
        case 1:
            updateUI(self.USNews)
        case 2:
            updateUI(self.worldNews)
        default:
            updateUI(self.localNews)
        }
    }
    
    func getUserLocation() {
        let locationManager = CLLocationManager()

        while locationManager.authorizationStatus != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            Thread.sleep(forTimeInterval: 0.5)
        }
           
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { [self] placemarks, error in
                    if let error = error {
                        print("Error getting location: \(error.localizedDescription)")
                    } else if let placemark = placemarks?.first {
                        if let city = placemark.locality {
                            self.userLocation = city
                            
                            if let state = placemark.administrativeArea {
                                convertStateName(state)
                            }
                            
                            parseLocalAndUSNews("everything?qInTitle=\(self.userLocation!)")
                            updateUI(self.localNews)
                        } else {
                            print("Unable to get city name.")
                        }
                    }
                }
            } else {
                print("Unable to retrieve location.")
            }
        } else {
            print("Location permission not granted.")
        }
    }

    func parseLocalAndUSNews(_ apiArg: String) {
        let url = URL(string: "https://newsapi.org/v2/\(apiArg)&pageSize=5&apiKey=\(apiKey)")!
        var articleList = [News]()
        var type: String
        
        if apiArg.contains("everything") {
            type = "local"
        } else {
            type = "US"
        }
        
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
                
                print("what")
                for article in articles {
                    print(article)
                    var img: String
                    
                    if let myString = article["urlToImage"] as? String {
                        img = article["urlToImage"] as! String
                    } else {
                        img = "nil"
                    }
                    
                    let news = News(title: article["title"] as Any,
                                    imageUrl: img, author: article["author"] as Any, date: article["publishedAt"] as Any, text: article["description"] as Any, url: article["url"] as! String)
                    
                    if type == "local" {
                        self.localNews.append(news)
                    } else {
                        self.USNews.append(news)
                    }
                    
                }
            } catch let error {
                print("Error parsing JSON: \(error)")
            }
        }
        
        Thread.sleep(forTimeInterval: 0.5)
        task.resume()
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    
    func parseWorldNews() {
        var articleList = [News]()
        let countries = randomizeCountries()
        
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
                    
                    for article in articles {
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
                                        imageUrl: img, author: article["author"] as Any, date: article["publishedAt"] as Any, text: description, url: article["url"] as! String)
                        
                        self.worldNews.append(news)
                        Thread.sleep(forTimeInterval: 1)
                    }
                } catch let error {
                    print("Error parsing JSON: \(error)")
                }
            }
            Thread.sleep(forTimeInterval: 0.5)
            task.resume()
            Thread.sleep(forTimeInterval: 0.5)
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
        
        showComponents()
        
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
        
        remove(label: loadingLabel)
        remove(label: loadingLabel2)
    }
    
    func convertStateName(_ state: String) -> String {
        let states = [
            "AL": "Alabama",
            "AK": "Alaska",
            "AZ": "Arizona",
            "AR": "Arkansas",
            "CA": "California",
            "CO": "Colorado",
            "CT": "Connecticut",
            "DE": "Delaware",
            "FL": "Florida",
            "GA": "Georgia",
            "HI": "Hawaii",
            "ID": "Idaho",
            "IL": "Illinois",
            "IN": "Indiana",
            "IA": "Iowa",
            "KS": "Kansas",
            "KY": "Kentucky",
            "LA": "Louisiana",
            "ME": "Maine",
            "MD": "Maryland",
            "MA": "Massachusetts",
            "MI": "Michigan",
            "MN": "Minnesota",
            "MS": "Mississippi",
            "MO": "Missouri",
            "MT": "Montana",
            "NE": "Nebraska",
            "NV": "Nevada",
            "NH": "New Hampshire",
            "NJ": "New Jersey",
            "NM": "New Mexico",
            "NY": "New York",
            "NC": "North Carolina",
            "ND": "North Dakota",
            "OH": "Ohio",
            "OK": "Oklahoma",
            "OR": "Oregon",
            "PA": "Pennsylvania",
            "RI": "Rhode Island",
            "SC": "South Carolina",
            "SD": "South Dakota",
            "TN": "Tennessee",
            "TX": "Texas",
            "UT": "Utah",
            "VT": "Vermont",
            "VA": "Virginia",
            "WA": "Washington",
            "WV": "West Virginia",
            "WI": "Wisconsin",
            "WY": "Wyoming"
        ]
        
        if states[state] != nil {
            self.userLocation! += "+\(states[state]!)"
        }
        
        return states[state]!
    }
    
    func randomizeCountries() -> [String]{
        let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
        
        
        var selectedCountries: [String] = []

        for i in 1...5 {
            let randomIndex = Int.random(in: 0..<countries.count-1)
            selectedCountries.append(countries[randomIndex])
        }
        
        return selectedCountries
    }
}
