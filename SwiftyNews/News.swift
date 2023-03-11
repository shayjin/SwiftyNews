import Foundation

class News {
    var type: String
    var title: String
    var author: String
    var date: String
    var originalText: String
    var simplifiedText: [String]
    
    init(type: String, title: String, author: String, date: String, text: String) {
        self.type = type
        self.title = title
        self.author = author
        self.date = date
        self.originalText = text
        self.simplifiedText = []
        self.simplifiedText = simplify(text: text)
    }
    
    func simplify(text: String) -> [String] {
        return [text]
    }
}
