//
//  Game+CoreDataProperties.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var opponent: String?
    @NSManaged var runs: NSNumber?
    @NSManaged var runsAgainst: NSNumber?
    @NSManaged var date: NSDate?

}
