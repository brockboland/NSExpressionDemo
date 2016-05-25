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
    @NSManaged var runs: Int64
    @NSManaged var runsAgainst: Int64
    @NSManaged var date: NSTimeInterval
    @NSManaged var attendees: Int64

}
