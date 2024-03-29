import UIKit

class NavigationViewController: UINavigationController {
    //:MARK: - Component
    
    let titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white]
    
    let backgroundColor: UIColor =  UIColor(named: Color.NavigationBackgroundColor)!
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = configureAppearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        navigationBar.insetsLayoutMarginsFromSafeArea = true
        navigationBar.topItem?.title = "HelloKorea"
        navigationBar.tintColor = UIColor(named: Color.NavigationTintColor)!
    }
    
    //: MARK: - View Methodes
    
    func configureAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = titleTextAttributes
        return appearance
    }
}
