//
//  AppDelegate.swift
//  Appsai
//
//  Created by Henrikas J on 10/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

// TODO: Random bug when swiping transaction top bar fast from left to right repeatedly
// TODO: Fix slow loading, due to multiple transaction calculation for current month in multiple places.
// TODO: Fix Transactions top bar, currently it needs to reverse items, so it does that multiple times, slows down
// TODO: Add animations between tab bar selections
// TODO: Add better animation for transactinos table reload
// TODO: Add Statistics
// TODO: Add budget set for custom days like 10 to 25 and 25 to 10
// TODO: Dont let add transactinos without budgets
// TODO: Add alert when trying to add Transaction or Budget if form is not valid
// TODO: Logo TableViewCell Frame/Bounds changes cause jumpines
// TODO: Bug when inserting cost and without deselecting the field you press add


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBefore")
        if( isFirstLaunch ) {
            // Write one time settings
            print("Startup creating objects")
            
//            var colors: [Color] = []
            let colors = Colors(context: PersistenceManager.shared.context)
            let iconNames = CategoryIconNames(context: PersistenceManager.shared.context)
            for i in 0...10 {
                let color = Color(context: PersistenceManager.shared.context)
                let iconName = CategoryIconName(context: PersistenceManager.shared.context)
                iconName.name = getIconName(number: i)
                
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                let predefindedColor: UIColor = getColor(number: i)
                predefindedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
//                print("Recieved: R: \(red), G: \(green), B: \(blue), alpha: \(alpha)")
                
                color.setColor(red: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha))
                
//                print("RESULT: R: \(color.red), G: \(color.green), B: \(color.blue), alpha: \(color.alpha)")
                colors.addToColors(color)
                iconNames.addToIconNames(iconName)
            }
            

            UserDefaults.standard.set(["Day / Month / Year":"dd-MM-yyyy"], forKey: "DateFormat")
            UserDefaults.standard.set("€", forKey: "CurrencyType")
            
            PersistenceManager.shared.saveContext()
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBefore")
        }
        
        
        
        return true
    }
    
    func getColor(number: Int) -> UIColor {
        var color: UIColor
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        switch number {
        case 0:
        color = .link
        case 1:
        color = .systemIndigo
        case 2:
        color = .gray
        case 3:
        color = .orange
        case 4:
        color = .purple
        case 5:
        color = .darkGray
        case 6:
        color = UIColor(red: 70/255.0, green: 96/255.0, blue: 190/255.0, alpha: 1)
        case 7:
        color = UIColor(red: 73/255.0, green: 162/255.0, blue: 90/255.0, alpha: 1)
        case 8:
        color = .brown
        case 9:
        color = .systemPink
        default:
        color = .red
        }
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        print("RETURNING: R: \(red), G: \(green), B: \(blue), alpha: \(alpha)")
        
        return color
    }
    
    func getIconName(number: Int) -> String {
        
        var iconName: String
        switch number {
        case 0:
            iconName = "sun.max.fill"
        case 1:
            iconName = "paperplane.fill"
        case 2:
            iconName = "pencil.tip"
        case 3:
            iconName = "umbrella.fill"
        case 4:
            iconName = "briefcase.fill"
        case 5:
            iconName = "film.fill"
        case 6:
            iconName = "gamecontroller.fill"
        case 7:
            iconName = "gift.fill"
        case 8:
            iconName = "car.fill"
        case 9:
            iconName = "airplane"
        default:
            iconName = "tram.fill"
        }
        
        return iconName
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

