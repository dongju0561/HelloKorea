//
//  TabBarViewController.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/03/09.
//
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = configureAppearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        tabBar.tintColor = UIColor(named: Color.TabBarTintColor)!
        tabBar.barTintColor = UIColor(named: Color.TabBarTintColor)!

        delegate = self
    }
    
    //: MARK: - View Methodes
    
    func configureAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: Color.TabBarBackgroundColor)!
        return appearance
    }
    
}
