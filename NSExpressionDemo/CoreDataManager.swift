//
//  CoreDataManager.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    var context: NSManagedObjectContext!

    func newGame() -> Game {
        return NSEntityDescription.insertNewObjectForEntityForName("Game",
                                                                   inManagedObjectContext: self.context) as! Game
    }

}
