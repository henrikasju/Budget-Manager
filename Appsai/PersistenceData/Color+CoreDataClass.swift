//
//  Color+CoreDataClass.swift
//  Appsai
//
//  Created by Henrikas J on 17/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


public class Color: NSManagedObject {
    func setColor(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    func printDetailed() {
        print("Color r: \(red), g: \(green), b: \(blue), alpha: \(alpha)")
    }
}
