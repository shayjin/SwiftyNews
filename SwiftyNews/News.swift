import Foundation

class News {
    var title: Any
    var imageUrl: String
    var author: Any
    var date: Any
    var originalText: Any
    var simplifiedText: [String]
    
    init(title: Any, imageUrl: String, author: Any, date: Any, text: Any) {
        self.title = title
        self.imageUrl = imageUrl
        self.author = author
        self.date = date
        self.originalText = text as! String
        self.simplifiedText = []
        self.simplifiedText = simplify(text: text as! String)
    }
    
    init() {
        self.title = ""
        self.imageUrl = ""
        self.author = ""
        self.date = ""
        self.originalText = ""
        self.simplifiedText = []
    }
    
    func simplify(text: String) -> [String] {
        return [text]
    }
}
