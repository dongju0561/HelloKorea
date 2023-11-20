import Foundation
import MapKit


//MKAnnotation은 NSObject를 사용하기 때문이다.
class Artwork: NSObject, MKAnnotation {
    static var num: Int = 0
    let tag: Int
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let address: String?

    init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D,
    address: String? )
    {
        self.tag = Artwork.num
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.address = address
        Artwork.num += 1
        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}
