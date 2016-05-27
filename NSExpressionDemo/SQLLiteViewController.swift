//
//  SQLLiteViewController.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import UIKit
import CoreData

class SQLLiteViewController: BaseViewController {

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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            guard let docURL = urls.last else {
                fatalError("Couldn't find doc directory")
            }
            let storeURL = docURL.URLByAppendingPathComponent("SQL.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType,
                                                   configuration: nil,
                                                   URL: storeURL,
                                                   options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }

        // Handle the common loading after setting up the core data stack
        super.viewDidLoad()
    }

}
