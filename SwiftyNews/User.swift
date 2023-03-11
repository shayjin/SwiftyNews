import Foundation

class User {
    var name: String
    var email: String
    var likedNews: [News]
    var friends: [User]
    
    init (name: String, email: String, likedNews: [News], friends: [User]) {
        self.name = name
        self.email = email
        self.likedNews = likedNews
        self.friends = friends
    }
}
