//
//  TabBarViewController.swift
//  Appsai
//
//  Created by Henrikas J on 17/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var transitionToLeft: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController{
            if let budgetViewController = navigationController.topViewController as? BudgetsViewController{
                budgetViewController.viewWillAppear(true)
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let selectedTabBarIndex = tabBar.items?.firstIndex(of: item) {
            if selectedTabBarIndex > self.selectedIndex{
                transitionToLeft = false
            }else if selectedTabBarIndex < self.selectedIndex{
                transitionToLeft = true
            }else{
                transitionToLeft = nil
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let existingTransitionToLeft = transitionToLeft{
            existingTransitionToLeft ? print("Going Left") : print("Going Right")
//            UIView.transition(with: viewController.view, duration: 1, options: .transitionCurlDown, animations: .none, completion: nil)
//            UIView.transition(from: self.selectedViewController!.view, to: viewController.view, duration: 1, options: .transitionFlipFromLeft, completion: nil)
//            UIView.transition
        }else{
            return false
        }
        
        return true
    }
    
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
