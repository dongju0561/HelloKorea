import UIKit
struct ContentModel {
    var category : String
    var contentName: String
    var contentNameK: String
    var year: String
    var cast: String
    var image: UIImage
    var locations: [Location]
    
    init(category: String, contentName: String, contentNameK: String, year: String, cast: String, image: UIImage, locations: [Location]) {
        self.category = category
        self.contentName = contentName
        self.contentNameK = contentNameK
        self.year = year
        self.cast = cast
        self.image = image
        self.locations = locations
    }
}
