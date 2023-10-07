import Foundation
import CoreLocation

struct Location {
    var locationName: String
    var explaination: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(locationName: String, explaination: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.locationName = locationName
        self.explaination = explaination
        self.latitude = latitude
        self.longitude = longitude
    }
}
