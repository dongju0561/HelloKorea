import UIKit

class NavigationViewController: UINavigationController {
    
    let titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white]
    let backgroundColor: UIColor =  UIColor(named: Color.NavigationBackgroundColor)!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = configureAppearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        navigationBar.insetsLayoutMarginsFromSafeArea = true
        navigationBar.topItem?.title = "HelloKorea"
        navigationBar.tintColor = UIColor(named: Color.NavigationTintColor)!
    }
    func configureAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = titleTextAttributes
        return appearance
    }
}
