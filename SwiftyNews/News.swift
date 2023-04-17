import Foundation
import Alamofire

class News {
    var title: Any
    var imageUrl: String
    var author: Any
    var date: Any
    var originalText: Any?
    var simplifiedText: [String?]
    var url: String
    var id: String?
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Authorization": "Bearer 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"
    ]
    
    init(title: Any, imageUrl: String, author: Any, date: Any, text: Any, url: String) {
        self.title = title
        self.imageUrl = imageUrl
        self.author = author
        self.date = date
        self.url = url
        self.originalText? = text
        self.simplifiedText = []
        //simplify(url: url as! String)
        
    }
    
    init() {
        self.title = ""
        self.imageUrl = ""
        self.author = ""
        self.date = ""
        self.originalText = ""
        self.simplifiedText = []
        self.url = ""
    }
    
    func simplify(url: String) -> [String?] {
        let parameters: [String: Any] = [
            "prompt": "Summarize this news article in 1 to 3 sentences seperated by a period: \"\(url)\"",
            "temperature": 0.5,
            "max_tokens": 100
        ]

        AF.request("https://api.openai.com/v1/engines/text-davinci-003/completions",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let responseJSON = value as? [String: Any],
                    let choices = responseJSON["choices"] as? [[String: Any]],
                    let firstChoice = choices.first,
                    let text = firstChoice["text"] as? String {
                    
                    self.simplifiedText =  text.components(separatedBy: ". ")
                }
            case .failure(let error):
                print(error)
            }
        }
        //Thread.sleep(forTimeInterval: 2)
        return self.simplifiedText
    }
    

}
