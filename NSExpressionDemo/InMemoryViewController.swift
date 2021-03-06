//
//  InMemoryViewController.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import UIKit
import CoreData

class InMemoryViewController: BaseViewController {

    override func viewDidLoad() {
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)

        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext.persistentStoreCoordinator = psc
        do {
            try psc.addPersistentStoreWithType(NSInMemoryStoreType,
                                               configuration: nil,
                                               URL: nil,
                                               options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }

        // Handle the common loading after setting up the core data stack
        super.viewDidLoad()
    }

}
