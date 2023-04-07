import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewsViewController: UIViewController {
    @IBOutlet var newsTitle: UILabel!

    @IBOutlet var content: UITextView!
    @IBOutlet var author: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var convertButton: UIButton!
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        if auth.currentUser != nil { // logged in
            
            if let id = news?.id {
                database.child("UserInfo").child(convertEmail(email: (auth.currentUser?.email)!)).child("LikedNews").queryOrderedByValue().queryEqual(toValue: news?.id!).observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    if snapshot.exists() {
                        print("The key with value '\(id)' exists in Firebase")
                        self.likeButton.setTitle("Unlike", for: .normal)
                    } else {
                        
                        print("The key with value '\(id)' does not exist in Firebase")
                        self.likeButton.setTitle("Like", for: .normal)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                database.child("News").queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    if let lastChild = snapshot.children.allObjects.last as? DataSnapshot {
                        
                        self.likeButton.setTitle("Like", for: .normal)
                        self.news?.id = String(Int(lastChild.key)! + 1)
                    }
                }) { (error) in
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
            
        } else { // logged off
           self.likeButton.setTitle("Like", for: .normal)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if auth.currentUser != nil {
            return false
        }
        
        return true
    }
    
    
    @IBAction func like(_ sender: Any) {
        if auth.currentUser != nil {
            print("hi1")
            if self.likeButton.title(for: .normal) == "Like" {
                print("2")
                self.likeButton.setTitle("Unlike", for: .normal)
                
                database.child("News").queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { [self] (snapshot) in
                    if let lastChild = snapshot.children.allObjects.last as? DataSnapshot {
                        
                        var element = database.child("News").child((news?.id!)!)
                        
                        element.child("author").setValue(news?.author)
                        element.child("title").setValue(news?.title)
                        element.child("imgUrl").setValue(news?.imageUrl)
                        element.child("url").setValue(news?.url)
                        element.child("simplified").child("1").setValue(news?.simplifiedText[0])
                        
                        database.child("UserInfo").child(convertEmail(email: (auth.currentUser?.email)!)).child("LikedNews").child((news?.id!)!).setValue(news?.id!)
                    }
                }) { (error) in
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            } else {
                database.child("UserInfo").child(convertEmail(email: (auth.currentUser?.email)!)).child("LikedNews").child((news?.id!)!).removeValue()
                
                self.likeButton.setTitle("Like", for: .normal)
            }
        }
    }
    
    func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: ".", with: ",")
    }
    
    
    @IBAction func convertText(_ sender: Any) {
        if let url = URL(string: news!.url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    func updateUI() {
        self.scrollView.isScrollEnabled = false
        self.newsTitle.text = news!.title as? String
        
        if let author = news!.author as? String {
            self.author.text = "Written by: \(author)"
        } else {
            self.author.text = ""
        }
        
        if news!.imageUrl != "nil" {
            if let url = URL(string: news!.imageUrl) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async { [self] in
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
        
        
        self.content.isEditable = false
        

        
        if news!.simplifiedText[0].count != 0 {
            news!.simplifiedText[0] = news!.simplifiedText[0].trimmingCharacters(in: .newlines)
            self.content.text = "📌  \(news!.simplifiedText[0]). "
        }

        
        if news!.simplifiedText[1].count != 0 {
            self.content.text! += "\n\n📌 \(news!.simplifiedText[1]). "
        }
        
        if news!.simplifiedText[2].count != 0 {
            self.content.text! += "\n\n📌 \(news!.simplifiedText[2]). "
        }
    }
}
