//
//  NavigationPrayViewController.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/22/24.
//

import UIKit

class NavigationPrayViewController: UINavigationController {
    let backgroundColor: UIColor =  .clear
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = configureAppearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
    }
    func configureAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowImage = UIImage()
        return appearance
    }
}
